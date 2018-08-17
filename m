From: Evan Green <evgreen@chromium.org>
Subject: Re: [PATCH V8 1/2] scsi: ufs: set the device reference clock setting
Date: Fri, 17 Aug 2018 10:27:07 -0700
Message-ID: <CAE=gft5TziAjH_ExTZyZ8-2i8J=vfhZ8UHCSn-dDwx6eEC2LGg@mail.gmail.com>
References: <1533805799-5831-1-git-send-email-sayalil@codeaurora.org> <1533805799-5831-2-git-send-email-sayalil@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1533805799-5831-2-git-send-email-sayalil@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: sayalil@codeaurora.org
Cc: subhashj@codeaurora.org, cang@codeaurora.org, vivek.gautam@codeaurora.org, Rajendra Nayak <rnayak@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, asutoshd@codeaurora.org, riteshh@codeaurora.org, adrian.hunter@intel.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Aug 9, 2018 at 2:10 AM Sayali Lokhande <sayalil@codeaurora.org> wrote:
>
> From: Subhash Jadavani <subhashj@codeaurora.org>
>
> UFS host supplies the reference clock to UFS device and UFS device
> specification allows host to provide one of the 4 frequencies (19.2 MHz,
> 26 MHz, 38.4 MHz, 52 MHz) for reference clock. Host should set the
> device reference clock frequency setting in the device based on what
> frequency it is supplying to UFS device.
>
> Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
> Signed-off-by: Can Guo <cang@codeaurora.org>
> Signed-off-by: Sayali Lokhande <sayalil@codeaurora.org>
> ---
>  drivers/scsi/ufs/ufs.h           | 21 ++++++++++
>  drivers/scsi/ufs/ufshcd-pltfrm.c |  2 +
>  drivers/scsi/ufs/ufshcd.c        | 89 ++++++++++++++++++++++++++++++++++++++++
>  drivers/scsi/ufs/ufshcd.h        |  2 +
>  4 files changed, 114 insertions(+)
>
> diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
> index 14e5bf7..c555ac0 100644
> --- a/drivers/scsi/ufs/ufs.h
> +++ b/drivers/scsi/ufs/ufs.h
> @@ -378,6 +378,27 @@ enum query_opcode {
>         UPIU_QUERY_OPCODE_TOGGLE_FLAG   = 0x8,
>  };
>
> +/* bRefClkFreq attribute values */
> +enum ref_clk_freq_hz {
> +       REF_CLK_FREQ_19_2_MHZ   = 19200000,
> +       REF_CLK_FREQ_26_MHZ     = 26000000,
> +       REF_CLK_FREQ_38_4_MHZ   = 38400000,
> +       REF_CLK_FREQ_52_MHZ     = 52000000,
> +};
> +
> +enum bref_clk_freq {
> +       bREF_CLK_FREQ_0, /* 19.2 MHz */
> +       bREF_CLK_FREQ_1, /* 26 MHz */
> +       bREF_CLK_FREQ_2, /* 38.4 MHz */
> +       bREF_CLK_FREQ_3, /* 52 MHz */
> +       bREF_CLK_FREQ_INVAL,
> +};

These enums are not helpful, roughly the equivalent of VALUE_1000 =
1000. Replace both with a single one, something like:

enum ufs_ref_clk_freq {
        UFS_REF_CLK_19P2MHZ = 0,
        UFS_REF_CLK_26MHZ = 1,
        UFS_REF_CLK_38P4MHZ = 2,
        UFS_REF_CLK_52MHZ = 3,
        UFS_REF_CLK_INVAL = -1
};

> +
> +struct ufs_ref_clk {
> +       enum ref_clk_freq_hz freq_hz;

Just make this an unsigned, no need for an enum of identity values.

> +       enum bref_clk_freq val;
> +};
> +
>  /* Query response result code */
>  enum {
>         QUERY_RESULT_SUCCESS                    = 0x00,
> diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
> index e82bde0..0953563 100644
> --- a/drivers/scsi/ufs/ufshcd-pltfrm.c
> +++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
> @@ -343,6 +343,8 @@ int ufshcd_pltfrm_init(struct platform_device *pdev,
>         pm_runtime_set_active(&pdev->dev);
>         pm_runtime_enable(&pdev->dev);
>
> +       ufshcd_parse_dev_ref_clk_freq(hba);
> +
>         ufshcd_init_lanes_per_dir(hba);
>
>         err = ufshcd_init(hba, mmio_base, irq);
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index c5b1bf1..0cbdde7 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -6296,6 +6296,89 @@ static void ufshcd_def_desc_sizes(struct ufs_hba *hba)
>         hba->desc_size.hlth_desc = QUERY_DESC_HEALTH_DEF_SIZE;
>  }
>
> +static struct ufs_ref_clk ufs_ref_clk_freqs[] = {
> +       {REF_CLK_FREQ_19_2_MHZ, bREF_CLK_FREQ_0},

Then these should just be something like:
        {19200000, UFS_REF_CLK_19P2MHZ},
        ...
        {0, UFS_REF_CLK_INVAL},

> +       {REF_CLK_FREQ_26_MHZ, bREF_CLK_FREQ_1},
> +       {REF_CLK_FREQ_38_4_MHZ, bREF_CLK_FREQ_2},
> +       {REF_CLK_FREQ_52_MHZ, bREF_CLK_FREQ_3},
> +};
> +
> +static inline enum bref_clk_freq
> +ufs_get_bref_clk_for_ref_clk_freq_hz(u32 freq)
> +{
> +       enum bref_clk_freq val;
> +
> +       for (val = bREF_CLK_FREQ_0; val <= bREF_CLK_FREQ_3; val++)

In my suggestion above, I terminated the table with {0,
UFS_REF_CLK_INVAL}. Then you could change this to a while loop that
stops when you see that sentinel node. I don't like the way it is now
because 1) You're making assumptions about the enum values being equal
to array indices, which may not line up if the next UFS spec adds
values that aren't contiguous (and defeats the whole point of the
table), and 2) Using <= LAST_VALID_VALUE makes this susceptible to
bugs when more valid values are added but someone forgets to go find
this loop and update it.

> +               if (ufs_ref_clk_freqs[val].freq_hz == freq)
> +                       return val;
> +
> +       /* if no match found, return invalid*/
> +       return bREF_CLK_FREQ_INVAL;
> +}
> +
> +void ufshcd_parse_dev_ref_clk_freq(struct ufs_hba *hba)
> +{
> +       struct device *dev = hba->dev;
> +       struct device_node *np = dev->of_node;
> +       struct clk *refclk = NULL;
> +       u32 freq = 0;
> +
> +       if (!np)
> +               return;
> +
> +       hba->dev_ref_clk_freq = bREF_CLK_FREQ_INVAL;
> +
> +       refclk = of_clk_get_by_name(np, "ref_clk");
> +       if (!refclk)
> +               return;
> +
> +       freq = clk_get_rate(refclk);
> +       if (freq > REF_CLK_FREQ_52_MHZ) {
> +               dev_err(hba->dev,
> +               "%s: invalid ref_clk setting = %d\n",
> +               __func__, freq);
> +               return;
> +       }
> +
> +       hba->dev_ref_clk_freq =
> +               ufs_get_bref_clk_for_ref_clk_freq_hz(freq);
> +}
> +
> +static int ufshcd_set_dev_ref_clk(struct ufs_hba *hba)
> +{
> +       int err = 0;
> +       int ref_clk = -1;
> +
> +       err = ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_READ_ATTR,
> +                       QUERY_ATTR_IDN_REF_CLK_FREQ, 0, 0, &ref_clk);
> +
> +       if (err) {
> +               dev_err(hba->dev, "%s: failed reading bRefClkFreq. err = %d\n",
> +                        __func__, err);
> +               goto out;
> +       }
> +
> +       if (ref_clk == hba->dev_ref_clk_freq)
> +               goto out; /* nothing to update */
> +
> +       err = ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
> +                       QUERY_ATTR_IDN_REF_CLK_FREQ, 0, 0,
> +                       &hba->dev_ref_clk_freq);

This is probably a nit, but I think the compiler is allowed to choose
any type for your enum that fits all of its values. This may not be a
u32, so you should probably create a u32 local, and assign into it
before passing a pointer into this function.

Ah wait, I see that you made the member a u32. It might be nicer to
type the member as the enum, and then do this local conversion as I've
mentioned. That will allow the compiler to help check more.

> +
> +       if (err)
> +               dev_err(hba->dev, "%s: bRefClkFreq setting to %d Hz failed\n",
> +               __func__, ufs_ref_clk_freqs[hba->dev_ref_clk_freq].freq_hz);
> +       /*
> +        * It is good to print this out here to debug any later failures
> +        * related to gear switch.
> +        */
> +       dev_dbg(hba->dev, "%s: bRefClkFreq setting to %d Hz succeeded\n",
> +               __func__, ufs_ref_clk_freqs[hba->dev_ref_clk_freq].freq_hz);
> +
> +out:
> +       return err;
> +}
> +
>  /**
>   * ufshcd_probe_hba - probe hba to detect device and initialize
>   * @hba: per-adapter instance
> @@ -6361,6 +6444,12 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
>                         "%s: Failed getting max supported power mode\n",
>                         __func__);
>         } else {
> +               /*
> +                * Set the right value to bRefClkFreq before attempting to
> +                * switch to HS gears.
> +                */
> +               if (hba->dev_ref_clk_freq < bREF_CLK_FREQ_INVAL)
> +                       ufshcd_set_dev_ref_clk(hba);

As mentioned by other reviewers, you're calling this function, but you
haven't called ufshcd_parse_dev_ref_clk_freq in all cases that lead to
this. So this function is now setting 19.2MHz into a whole set of
devices who haven't specified it. Perhaps the initialization of the
member needs to go in ufshcd_alloc_host. (Look for callers of that to
find other paths that circumvent your parse function). I'm not sure
how to advise on enabling this functionality for non-DT machines.

>                 ret = ufshcd_config_pwr_mode(hba, &hba->max_pwr_info.info);
>                 if (ret) {
>                         dev_err(hba->dev, "%s: Failed setting power mode, err = %d\n",
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 8110dcd..101a75c 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -548,6 +548,7 @@ struct ufs_hba {
>         void *priv;
>         unsigned int irq;
>         bool is_irq_enabled;
> +       u32 dev_ref_clk_freq;

As I mentioned above, this might be better as the enum type.

>
>         /* Interrupt aggregation support is broken */
>         #define UFSHCD_QUIRK_BROKEN_INTR_AGGR                   0x1
> @@ -746,6 +747,7 @@ static inline void ufshcd_rmwl(struct ufs_hba *hba, u32 mask, u32 val, u32 reg)
>  int ufshcd_wait_for_register(struct ufs_hba *hba, u32 reg, u32 mask,
>                                 u32 val, unsigned long interval_us,
>                                 unsigned long timeout_ms, bool can_sleep);
> +void ufshcd_parse_dev_ref_clk_freq(struct ufs_hba *hba);

I wonder if this should fail if you end up finding a DT property, but
it's a crazy invalid value. What do you think?

>
>  static inline void check_upiu_size(void)
>  {
> --
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> a Linux Foundation Collaborative Project
>
