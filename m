From: Evan Green <evgreen@chromium.org>
Subject: Re: [PATCH v1 5/8] scsi: ufs: qcom: Expose the reset controller for PHY
Date: Tue, 22 Jan 2019 14:40:54 -0800
Message-ID: <CAE=gft5-96uyFhU-15MmQKKdYQn2mO2oRfg5P+OAt+J-eAze8g@mail.gmail.com>
References: <20190111230129.127037-1-evgreen@chromium.org> <20190111230129.127037-6-evgreen@chromium.org>
 <154785066196.169631.9228316876601255899@swboyd.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <154785066196.169631.9228316876601255899@swboyd.mtv.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Stephen Boyd <swboyd@chromium.org>
Cc: Andy Gross <andy.gross@linaro.org>, Kishon Vijay Abraham I <kishon@ti.com>, Rob Herring <robh+dt@kernel.org>, Can Guo <cang@codeaurora.org>, Douglas Anderson <dianders@chromium.org>, Asutosh Das <asutoshd@codeaurora.org>, Vivek Gautam <vivek.gautam@codeaurora.org>, "James E.J. Bottomley" <jejb@linux.ibm.com>, Vinayak Holikatti <vinholikatti@gmail.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Jan 18, 2019 at 2:31 PM Stephen Boyd <swboyd@chromium.org> wrote:
>
> Quoting Evan Green (2019-01-11 15:01:26)
> > diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
> > index 3aeadb14aae1e..db46f9a64b54c 100644
> > --- a/drivers/scsi/ufs/ufs-qcom.c
> > +++ b/drivers/scsi/ufs/ufs-qcom.c
> > @@ -16,6 +16,7 @@
> >  #include <linux/of.h>
> >  #include <linux/platform_device.h>
> >  #include <linux/phy/phy.h>
> > +#include <linux/reset.h>
>
> Shouldn't this be <linux/reset-controller.h>?

Oh, actually I don't need this at all since ufs-qcom.h includes
reset-controller.h. Will remove.

>
> >
> >  #include "ufshcd.h"
> >  #include "ufshcd-pltfrm.h"
> > @@ -255,11 +261,6 @@ static int ufs_qcom_power_up_sequence(struct ufs_hba *hba)
> >         if (is_rate_B)
> >                 phy_set_mode(phy, PHY_MODE_UFS_HS_B);
> >
> > -       /* Assert PHY reset and apply PHY calibration values */
> > -       ufs_qcom_assert_reset(hba);
> > -       /* provide 1ms delay to let the reset pulse propagate */
> > -       usleep_range(1000, 1100);
> > -
> >         /* phy initialization - calibrate the phy */
> >         ret = phy_init(phy);
> >         if (ret) {
> > @@ -268,15 +269,6 @@ static int ufs_qcom_power_up_sequence(struct ufs_hba *hba)
> >                 goto out;
> >         }
> >
> > -       /* De-assert PHY reset and start serdes */
> > -       ufs_qcom_deassert_reset(hba);
> > -
> > -       /*
> > -        * after reset deassertion, phy will need all ref clocks,
> > -        * voltage, current to settle down before starting serdes.
> > -        */
> > -       usleep_range(1000, 1100);
> > -
> >         /* power on phy - start serdes and phy's power and clocks */
> >         ret = phy_power_on(phy);
> >         if (ret) {
> > @@ -290,7 +282,6 @@ static int ufs_qcom_power_up_sequence(struct ufs_hba *hba)
> >         return 0;
> >
> >  out_disable_phy:
> > -       ufs_qcom_assert_reset(hba);
> >         phy_exit(phy);
> >  out:
> >         return ret;
> > @@ -554,21 +545,10 @@ static int ufs_qcom_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
> >                 ufs_qcom_disable_lane_clks(host);
> >                 phy_power_off(phy);
> >
> > -               /* Assert PHY soft reset */
> > -               ufs_qcom_assert_reset(hba);
> > -               goto out;
> > -       }
> > -
> > -       /*
> > -        * If UniPro link is not active, PHY ref_clk, main PHY analog power
> > -        * rail and low noise analog power rail for PLL can be switched off.
>
> We lost this comment?

Yeah. These are all phy implementation choices, and phy-qcom-qmp
wasn't even doing any of this, so it didn't seem like an appropriate
comment for the UFS controller code.

>
> > -        */
> > -       if (!ufs_qcom_is_link_active(hba)) {
> > +       } else if (!ufs_qcom_is_link_active(hba)) {
> >                 ufs_qcom_disable_lane_clks(host);
> > -               phy_power_off(phy);
>
> And now this looks similar to the above if statement, so can they be
> combined?

well, the if statement above has an extra phy_power_off in it... the
only possible combining I see is this, which looks worse, doesn't it?

if (ufs_qcom_is_link_off(hba) || !ufs_qcom_is_link_active(hba)) {
    ufs_qcom_disable_lane_clocks(host);
    if (ufs_qcom_is_link_off(hba)) {
        phy_power_off(phy);
    }
}

>
> >
> > -out:
> >         return ret;
> >  }
> >
> > @@ -578,21 +558,26 @@ static int ufs_qcom_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
> >         struct phy *phy = host->generic_phy;
> >         int err;
> >
> > -       err = phy_power_on(phy);
> > -       if (err) {
> > -               dev_err(hba->dev, "%s: failed enabling regs, err = %d\n",
> > -                       __func__, err);
> > -               goto out;
> > -       }
> > +       if (ufs_qcom_is_link_off(hba)) {
> > +               err = phy_power_on(phy);
> > +               if (err) {
> > +                       dev_err(hba->dev, "%s: failed enabling regs, err = %d\n",
>
> Not a problem with this translation, but I would expect this error to
> say something more like 'failed to power on phy' instead of 'enabling
> regs'.

Oh yeah. Will fix.

>
> > +                               __func__, err);
> > +                       return err;
> > +               }
> >
> > -       err = ufs_qcom_enable_lane_clks(host);
> > -       if (err)
> > -               goto out;
> > +               err = ufs_qcom_enable_lane_clks(host);
> > +               if (err)
> > +                       return err;
> >
> > -       hba->is_sys_suspended = false;
> > +       } else if (!ufs_qcom_is_link_active(hba)) {
> > +               err = ufs_qcom_enable_lane_clks(host);
> > +               if (err)
> > +                       return err;
> > +       }
> >
> > -out:
> > -       return err;
> > +       hba->is_sys_suspended = false;
> > +       return 0;
> >  }
> >
> >  struct ufs_qcom_dev_params {
> > @@ -1118,8 +1103,6 @@ static int ufs_qcom_setup_clocks(struct ufs_hba *hba, bool on,
> >                 return 0;
> >
> >         if (on && (status == POST_CHANGE)) {
> > -               phy_power_on(host->generic_phy);
> > -
>
> How is it ok to remove this call here?
>
> >                 /* enable the device ref clock for HS mode*/
> >                 if (ufshcd_is_hs_mode(&hba->pwr_info))
> >                         ufs_qcom_dev_ref_clk_ctrl(host, true);
> > @@ -1131,9 +1114,6 @@ static int ufs_qcom_setup_clocks(struct ufs_hba *hba, bool on,
> >                 if (!ufs_qcom_is_link_active(hba)) {
> >                         /* disable device ref_clk */
> >                         ufs_qcom_dev_ref_clk_ctrl(host, false);
> > -
> > -                       /* powering off PHY during aggressive clk gating */
> > -                       phy_power_off(host->generic_phy);
>
> And here?

This pair was calling phy_power_on and phy_power_off during clock
gating (and init). For SDM845/phy-qcom-qmp, this did nothing, since
there was no phy_power_off. In fact they needed an extra patch to not
call phy_power_on too early during init because of this function [1].
So for sdm845 this is a noop, since the phy will already be powered on
in ufs_qcom_power_up_sequence.

For msm8996/phy-qcom-ufs, it may change behavior a bit. Where we used
to end up in ufs_qcom_phy_power_off during clock gating, this change
is now not doing that. So regulators and a couple clocks are being
left on during clock gating. The phy power off now happens in suspend
if usermode selects that level. It seemed weird to be doing a bunch of
regulator and power down stuff in something called "clock gating".

Although looking at it now, I'm not even sure if these calls really
did do anything, since phy_power_on is reference counted, and
ufs_qcom_power_up_sequence called it... so it's possible ever since
commit 052553af6a31 ("ufs/phy: qcom: Refactor to use phy_init call")
in late 2017 this hasn't been doing anything at all.

[1] https://lkml.org/lkml/2018/9/21/204

>
> >                 }
> >
> >                 vote = host->bus_vote.min_bw_vote;
> > @@ -1147,6 +1127,39 @@ static int ufs_qcom_setup_clocks(struct ufs_hba *hba, bool on,
> >         return err;
> >  }
> >
> > +static int
> > +ufs_qcom_reset_assert(struct reset_controller_dev *rcdev, unsigned long id)
> > +{
> > +       struct ufs_qcom_host *host = rcdev_to_ufs_host(rcdev);
> > +
> > +       WARN_ON(id);
>
> Nitpick: Add a comment explaining that there's only one reset expected?

Will do.

>
> > +       ufs_qcom_assert_reset(host->hba);
> > +       /* provide 1ms delay to let the reset pulse propagate */
> > +       usleep_range(1000, 1100);
> > +       return 0;
> > +}
> > +
> > +static int
> > +ufs_qcom_reset_deassert(struct reset_controller_dev *rcdev, unsigned long id)
> > +{
> > +       struct ufs_qcom_host *host = rcdev_to_ufs_host(rcdev);
> > +
> > +       WARN_ON(id);
>
> Same nitpick.

Yep.

>
> > +       ufs_qcom_deassert_reset(host->hba);
> > +
> > +       /*
> > +        * after reset deassertion, phy will need all ref clocks,
> > +        * voltage, current to settle down before starting serdes.
> > +        */
> > +       usleep_range(1000, 1100);
> > +       return 0;
> > +}
> > +
> > +const struct reset_control_ops ufs_qcom_reset_ops = {
>
> Can it be static?

Yes!

>
> > +       .assert = ufs_qcom_reset_assert,
> > +       .deassert = ufs_qcom_reset_deassert,
> > +};
> > +
> >  #define        ANDROID_BOOT_DEV_MAX    30
> >  static char android_boot_dev[ANDROID_BOOT_DEV_MAX];
> >
