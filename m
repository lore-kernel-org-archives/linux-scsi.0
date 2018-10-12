From: Doug Anderson <dianders@chromium.org>
Subject: Re: [PATCH V14 1/2] scsi: ufs: set the device reference clock setting
Date: Fri, 12 Oct 2018 15:50:37 -0700
Message-ID: <CAD=FV=UrHF0Bp8DMKz_FjeGT_px6MJpkheF7RcmDxNC3=RPG9w@mail.gmail.com>
References: <1537770516-28410-1-git-send-email-sayalil@codeaurora.org> <1537770516-28410-2-git-send-email-sayalil@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1537770516-28410-2-git-send-email-sayalil@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: sayalil@codeaurora.org
Cc: subhashj@codeaurora.org, cang@codeaurora.org, Vivek Gautam <vivek.gautam@codeaurora.org>, Rajendra Nayak <rnayak@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, jejb@linux.vnet.ibm.com, "Martin K. Petersen" <martin.petersen@oracle.com>, Asutosh Das <asutoshd@codeaurora.org>, Evan Green <evgreen@chromium.org>, riteshh@codeaurora.org, stummala@codeaurora.org, Adrian Hunter <adrian.hunter@intel.com>, jlbec@evilplan.org, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi,

On Sun, Sep 23, 2018 at 11:29 PM Sayali Lokhande <sayalil@codeaurora.org> wrote:
> +static struct ufs_ref_clk ufs_ref_clk_freqs[] = {
> +       {19200000, REF_CLK_FREQ_19_2_MHZ},
> +       {26000000, REF_CLK_FREQ_26_MHZ},
> +       {38400000, REF_CLK_FREQ_38_4_MHZ},
> +       {52000000, REF_CLK_FREQ_52_MHZ},
> +       {0, REF_CLK_FREQ_INVAL},
> +};
> +
> +static inline enum ufs_ref_clk_freq

Please don't specify inline.  Let the compiler decide whether inline is better.


> +ufs_get_bref_clk_from_hz(u32 freq)
> +{
> +       int i = 0;
> +
> +       while (ufs_ref_clk_freqs[i].freq_hz != freq) {
> +               if (!ufs_ref_clk_freqs[i].freq_hz)
> +                       return REF_CLK_FREQ_INVAL;
> +               i++;
> +       }
> +
> +       return ufs_ref_clk_freqs[i].val;

I think you'll have less confusion if you write the above as this (untested):

for (i = 0; ufs_ref_clk_freqs[i].freq_hz; i++) {
  if (ufs_ref_clk_freqs[i].freq_hz == freq)
    return ufs_ref_clk_freqs[i].val;
}

return REF_CLK_FREQ_INVAL;

Now it looks like a normal iteration till a normal stop condition
(NULL term array).


> +void ufshcd_parse_dev_ref_clk_freq(struct ufs_hba *hba)

Shouldn't this return an error code so that if there's a problem it
can return back to the caller?  Right now you print error messages but
ufshcd_pltfrm_init() will plow merrily along after.


> +{
> +       struct device *dev = hba->dev;
> +       struct device_node *np = dev->of_node;
> +       struct clk *refclk = NULL;
> +       u32 freq = 0;

"freq" should be "unsigned long" to match clk_get_rate(), not u32.
Similarly all the places you pass it to and store it in should be
"unsigned long" too.  Save "u32" for values which are being programmed
into 32-bit hardware registers.


> +       if (!np)
> +               return;

You don't need to check for (!np).  If you do clk_get() and there's no
np you'll get get an error back.  Handle it there.


> +
> +       refclk = of_clk_get_by_name(np, "ref_clk");
> +       if (!refclk)
> +               return;

I can't quickly tell.  Are you intending "ref_clk" to be optional or
required?  You check against "NULL" and return with no error message,
so I'm kinda assuming it's optional.  ...but:

1. of_clk_get_by_name() doesn't return NULL when the clock wasn't
specified.  It returns "-ENOENT".  That means that (right now) anyone
who doesn't specify a "ref_clk" will get a crash when you try calling
clk_get_rate() on the error-code-clk.

2. It seems like it would be good to add a comment that
"dev_ref_clk_freq" was already initted to "REF_CLK_FREQ_INVAL in
ufshcd_alloc_host() to make it obvious how people are working that
didn't specify "ref_clk".


One note is that regardless of whether "ref_clk" is optional or
required, something about "ref_clk" should be mentioned in
"Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt" so people
know that's an important clock name.


Yet another note here is that I'm confused why you'd want to use
of_clk_get_by_name().  Why not use clk_get()?  You've already got the
"dev" node and clk_get() should be preferred since not everyone uses
device tree.


OK, one last note is that clk_get() could return -EPROBE_DEFER.  In
such a case you need to basically cancel your whole probe and
propagate the -EPROBE_DEFER.  Make sure you think about that when
you're coding things up.


OK, I lied about the previous one being the last note.  Why don't you
just add a bit of code in the ufshcd_init_clocks() loop.  If you
notice that the clock name is "ref_clk" (similar to how
__ufshcd_setup_clocks() checks) then you can grab the frequency.  Then
you can avoid dealing with all my comments above about
of_clk_get_by_name() and errors and -EPROBE_DEFER...


> +       freq = clk_get_rate(refclk);
> +
> +       hba->dev_ref_clk_freq =
> +               ufs_get_bref_clk_from_hz(freq);
> +
> +       if (hba->dev_ref_clk_freq == REF_CLK_FREQ_INVAL)
> +               dev_err(hba->dev,
> +               "%s: invalid ref_clk setting = %d\n",
> +               __func__, freq);

nit: including "__func__" in dev_xxx() calls is discouraged.  The
"dev_xxx" calls already print the device name and the string within a
given device driver should be unique enough so __func__ just adds crap
to the logs.  If you really feel that __func__ adds something for you,
try posting up a patch to make all "dev_err" functions include
__func__.  ...but I think you'd probably be rejected.


Also (more important): You're missing a clk_put().  Thus you're
leaking a reference to "ref_clk".


> +}
> +
> +static int ufshcd_set_dev_ref_clk(struct ufs_hba *hba)
> +{
> +       int err, ref_clk = -1;
> +       u32 freq = hba->dev_ref_clk_freq;

Ugh, this is ugly.  hba->dev_ref_clk_freq could be -1 but you're
jamming it into a u32 here.  That doesn't seem so ideal.  Are you sure
-1 was the best choice for REF_CLK_FREQ_INVAL?


> +
> +       err = ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_READ_ATTR,
> +                       QUERY_ATTR_IDN_REF_CLK_FREQ, 0, 0, &ref_clk);

It's not so wonderful to be passing a pointer to an "int" to a
function expecting a pointer to a "u32".  Change "ref_clk" to "u32".


> +
> +       if (err) {
> +               dev_err(hba->dev, "%s: failed reading bRefClkFreq. err = %d\n",
> +                        __func__, err);

Again, no __func__.


> +               goto out;
> +       }
> +
> +       if (ref_clk == hba->dev_ref_clk_freq)

nit: you already cached "hba->dev_ref_clk_freq in "freq".  Use it.


> +               goto out; /* nothing to update */
> +
> +       err = ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
> +                       QUERY_ATTR_IDN_REF_CLK_FREQ, 0, 0, &freq);
> +
> +       if (err) {
> +               dev_err(hba->dev, "%s: bRefClkFreq setting to %u Hz failed\n",
> +               __func__, ufs_ref_clk_freqs[freq].freq_hz);

Again, no __func__.


> +               goto out;
> +       }
> +
> +       dev_dbg(hba->dev, "%s: bRefClkFreq setting to %u Hz succeeded\n",
> +               __func__, ufs_ref_clk_freqs[freq].freq_hz);

Again, no __func__.
