From: Evan Green <evgreen@chromium.org>
Subject: Re: [PATCH v3 7/8] phy: qcom: Utilize UFS reset controller
Date: Fri, 8 Feb 2019 10:59:49 -0800
Message-ID: <CAE=gft5H1mWdi3iL22v2reD7AK4rwxwSq=YX2DpykAcys8fyZg@mail.gmail.com>
References: <20190205185902.106085-1-evgreen@chromium.org> <20190205185902.106085-8-evgreen@chromium.org>
 <154948878332.115909.8361746129233481633@swboyd.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <154948878332.115909.8361746129233481633@swboyd.mtv.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Stephen Boyd <swboyd@chromium.org>
Cc: Andy Gross <andy.gross@linaro.org>, Kishon Vijay Abraham I <kishon@ti.com>, Marc Gonzalez <marc.w.gonzalez@free.fr>, Can Guo <cang@codeaurora.org>, Vivek Gautam <vivek.gautam@codeaurora.org>, Douglas Anderson <dianders@chromium.org>, Asutosh Das <asutoshd@codeaurora.org>, Jeffrey Hugo <jhugo@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>, SCSI <linux-scsi@vger.kernel.org>, Grygorii Strashko <grygorii.strashko@ti.com>, Bjorn Andersson <bjorn.andersson@linaro.org>, LKML <linux-kernel@vger.kernel.org>, Manu Gautam <mgautam@codeaurora.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, Vinayak Holikatti <vinholikatti@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Feb 6, 2019 at 1:33 PM Stephen Boyd <swboyd@chromium.org> wrote:
>
> Quoting Evan Green (2019-02-05 10:59:01)
> > diff --git a/drivers/phy/qualcomm/phy-qcom-ufs-qmp-20nm.c b/drivers/phy/qualcomm/phy-qcom-ufs-qmp-20nm.c
> > index aef40f7a41d4..b05f89d734f0 100644
> > --- a/drivers/phy/qualcomm/phy-qcom-ufs-qmp-20nm.c
> > +++ b/drivers/phy/qualcomm/phy-qcom-ufs-qmp-20nm.c
> > @@ -67,6 +67,16 @@ static int ufs_qcom_phy_qmp_20nm_init(struct phy *generic_phy)
> >         bool is_rate_B = false;
> >         int ret;
> >
> > +       ret = ufs_qcom_phy_get_reset(phy_common);
> > +       if (ret)
> > +               return ret;
> > +
> > +       if (phy_common->ufs_reset) {
> > +               ret = reset_control_assert(phy_common->ufs_reset);
>
> It looks like you can always call this and set phy_common->ufs_reset to
> NULL when it should be a no-op. But it would never be NULL because we
> would always fail earlier in ufs_qcom_phy_get_reset()?

True, I'll do this unconditionally.

>
> > +               if (ret)
> > +                       return ret;
> > +       }
> > +
> >         if (phy_common->mode == PHY_MODE_UFS_HS_B)
> >                 is_rate_B = true;
> >
> > diff --git a/drivers/phy/qualcomm/phy-qcom-ufs.c b/drivers/phy/qualcomm/phy-qcom-ufs.c
> > index f2979ccad00a..9cc8aa0b7a4f 100644
> > --- a/drivers/phy/qualcomm/phy-qcom-ufs.c
> > +++ b/drivers/phy/qualcomm/phy-qcom-ufs.c
> > @@ -147,6 +147,22 @@ struct phy *ufs_qcom_phy_generic_probe(struct platform_device *pdev,
> >  }
> >  EXPORT_SYMBOL_GPL(ufs_qcom_phy_generic_probe);
> >
> > +int ufs_qcom_phy_get_reset(struct ufs_qcom_phy *phy_common)
> > +{
> > +       struct reset_control *reset;
> > +
> > +       if (phy_common->ufs_reset)
> > +               return 0;
> > +
> > +       reset = devm_reset_control_get_exclusive_by_index(phy_common->dev, 0);
> > +       if (IS_ERR(reset))
> > +               return PTR_ERR(reset);
> > +
> > +       phy_common->ufs_reset = reset;
> > +       return 0;
>
> I find this API weird that it doesn't return the pointer to the reset
> controller. It would be more kernel idiomatic if it returned the pointer
> and used error pointers.
>
> Are there now two places where we're getting the reset controller? I'm
> confused now.

Yeah, this was never meant to be an API, just a little static helper
function. But in order to structure the changes so that this change is
strictly "move the reset" (and not "combine init and poweron"), I had
to export this function and use it in the 14nm and 20nm init
functions. Those drivers do init() entirely themselves, and don't call
the common driver. In the next change, those init functions smoosh
into the common power_on() here, and then this function goes from
exported back to static. ... so yeah, temporary scaffolding to make
the series clearer.

>
> > +}
> > +EXPORT_SYMBOL_GPL(ufs_qcom_phy_get_reset);
> > +
> >  static int __ufs_qcom_phy_clk_get(struct device *dev,
> >                          const char *name, struct clk **clk_out, bool err_print)
> >  {
> > @@ -533,6 +549,14 @@ int ufs_qcom_phy_power_on(struct phy *generic_phy)
> >         if (phy_common->is_powered_on)
> >                 return 0;
> >
> > +       if (phy_common->ufs_reset) {
> > +               err = reset_control_deassert(phy_common->ufs_reset);
> > +               if (err) {
> > +                       dev_err(dev, "Failed to assert UFS PHY reset");
> > +                       return err;
> > +               }
> > +       }
> > +
> >         if (!phy_common->is_started) {
> >                 err = ufs_qcom_phy_start_serdes(phy_common);
> >                 if (err)
> > @@ -620,6 +644,9 @@ int ufs_qcom_phy_power_off(struct phy *generic_phy)
> >
> >         ufs_qcom_phy_disable_vreg(phy_common->dev, &phy_common->vdda_pll);
> >         ufs_qcom_phy_disable_vreg(phy_common->dev, &phy_common->vdda_phy);
> > +       if (phy_common->ufs_reset)
> > +               reset_control_assert(phy_common->ufs_reset);
>
> All these ifs can go away basically.

Righto.


>
> > +
> >         phy_common->is_powered_on = false;
> >
> >         return 0;
