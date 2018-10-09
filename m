From: Doug Anderson <dianders@chromium.org>
Subject: Re: [PATCH 1/1] scsi: ufs: make UFS Tx lane1 clock optional
Date: Tue, 9 Oct 2018 14:56:41 -0700
Message-ID: <CAD=FV=Xg4UtkJxvVQ2_ky+6-XnM=FvXcnc8xb=uhHeiP5bdFiw@mail.gmail.com>
References: <1538973275-5961-1-git-send-email-cang@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1538973275-5961-1-git-send-email-cang@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: cang@codeaurora.org
Cc: subhashj@codeaurora.org, Asutosh Das <asutoshd@codeaurora.org>, Vivek Gautam <vivek.gautam@codeaurora.org>, Rajendra Nayak <rnayak@codeaurora.org>, Evan Green <evgreen@chromium.org>, Vinayak Holikatti <vinholikatti@gmail.com>, jejb@linux.vnet.ibm.com, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, venkatg@codeaurora.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi,

On Sun, Oct 7, 2018 at 9:34 PM Can Guo <cang@codeaurora.org> wrote:
>
> From: Venkat Gopalakrishnan <venkatg@codeaurora.org>
>
> The UFS Tx lane1 clock could be muxed, hence keep it optional by ignoring
> it if it is not provided in device tree.

Thanks for the updated commit message.  This makes much more sense now!  :-)


> @@ -113,10 +110,10 @@ static void ufs_qcom_disable_lane_clks(struct ufs_qcom_host *host)
>         if (!host->is_lane_clks_enabled)
>                 return;
>
> -       if (host->hba->lanes_per_direction > 1)
> +       if (host->tx_l1_sync_clk)
>                 clk_disable_unprepare(host->tx_l1_sync_clk);

I don't believe you need the "if".  A NULL clock is by definition OK
to enable / disable which is designed to make optional clocks easier
to deal with.


>         clk_disable_unprepare(host->tx_l0_sync_clk);
> -       if (host->hba->lanes_per_direction > 1)
> +       if (host->rx_l1_sync_clk)
>                 clk_disable_unprepare(host->rx_l1_sync_clk);

optional: Technically this part of the patch wasn't actually needed,
right?  "rx_l1_sync_clk" is not optional so that means that
"rx_l1_sync_clk" should be non-NULL exactly when lanes_per_direction >
1.

...but actually I'm fine with keeping this part of your patch for
symmetry.  Especially since you can leverage the
clk_disable_unprepare(NULL) to simplify your code.  Please mention in
your commit message that this is a cleanup and just for symmetry.
Probably also remove the "if" tests that are guarding
ufs_qcom_host_clk_enable().


>         clk_disable_unprepare(host->rx_l0_sync_clk);
>
> @@ -141,24 +138,21 @@ static int ufs_qcom_enable_lane_clks(struct ufs_qcom_host *host)
>         if (err)
>                 goto disable_rx_l0;
>
> -       if (host->hba->lanes_per_direction > 1) {
> +       if (host->rx_l1_sync_clk) {

Similar: the above change isn't required but I'm OK if you want to
make this change for symmetry / to cleanup clock handling.  Please
mention in your commit message.


> +       /* The tx lane1 clk could be muxed, hence keep this optional */
> +       if (host->tx_l1_sync_clk)
> +               ufs_qcom_host_clk_enable(dev, "tx_lane1_sync_clk",
> +                                        host->tx_l1_sync_clk);

If "host->tx_l1_sync_clk" is provided then you should still check the
return value of ufs_qcom_host_clk_enable(), right?  ...so please leave
the error path here.


> @@ -174,23 +168,33 @@ static int ufs_qcom_init_lane_clks(struct ufs_qcom_host *host)
>
>         err = ufs_qcom_host_clk_get(dev,
>                         "rx_lane0_sync_clk", &host->rx_l0_sync_clk);
> -       if (err)
> +       if (err) {
> +               dev_err(dev, "%s: failed to get rx_lane0_sync_clk, err %d",
> +                               __func__, err);

nit: including "__func__" in dev_xxx() calls is discouraged.  The
"dev_xxx" calls already print the device name and the string within a
given device driver should be unique enough so __func__ just adds crap
to the logs.  If you really feel that __func__ adds something for you,
try posting up a patch to make all "dev_err" functions include
__func__.  ...but I think you'd probably be rejected.

suggestion: you'd save a few lines of code and simplify your probe if
you just passed an "optional" bool to the ufs_qcom_host_clk_get() that
controlled the printout.


> -               err = ufs_qcom_host_clk_get(dev, "tx_lane1_sync_clk",
> -                       &host->tx_l1_sync_clk);
> +               /* The tx lane1 clk could be muxed, hence keep this optional */
> +               ufs_qcom_host_clk_get(dev, "tx_lane1_sync_clk",
> +                                       &host->tx_l1_sync_clk);

To be technically correct you should actually check the error value
returned by ufs_qcom_host_clk_get().  Specifically figure out what the
error value is when "tx_lane1_sync_clk" isn't specified and check for
that.

...one reason this matters is -EPROBE_DEFER.  In theory devm_clk_get()
could return -EPROBE_DEFER.  In such a case you'd want to exit the
probe, not continue on.  It's also just good coding practice to handle
just the error you want though so that if the function returned some
other failing case you'd propagate it down instead of eating it.

If you passed "optional" to ufs_qcom_host_clk_get() as suggested above
you could put this error-code checking in ufs_qcom_host_clk_get() and
return 0 from that function if an optional clock was found to not
exist.

-Doug
