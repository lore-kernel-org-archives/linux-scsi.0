From: Stephen Boyd <swboyd@chromium.org>
Subject: Re: [PATCH v3 7/8] phy: qcom: Utilize UFS reset controller
Date: Wed, 06 Feb 2019 13:33:03 -0800
Message-ID: <154948878332.115909.8361746129233481633@swboyd.mtv.corp.google.com>
References: <20190205185902.106085-1-evgreen@chromium.org> <20190205185902.106085-8-evgreen@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190205185902.106085-8-evgreen@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Gross <andy.gross@linaro.org>, Kishon Vijay Abraham I <kishon@ti.com>
Cc: Marc Gonzalez <marc.w.gonzalez@free.fr>, Can Guo <cang@codeaurora.org>, Vivek Gautam <vivek.gautam@codeaurora.org>, Douglas Anderson <dianders@chromium.org>, Asutosh Das <asutoshd@codeaurora.org>, Evan Green <evgreen@chromium.org>, Jeffrey Hugo <jhugo@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>, linux-scsi@vger.kernel.org, Grygorii Strashko <grygorii.strashko@ti.com>, Bjorn Andersson <bjorn.andersson@linaro.org>, linux-kernel@vger.kernel.org, Manu Gautam <mgautam@codeaurora.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, Vinayak Holikatti <vinholikatti@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Quoting Evan Green (2019-02-05 10:59:01)
> diff --git a/drivers/phy/qualcomm/phy-qcom-ufs-qmp-20nm.c b/drivers/phy/q=
ualcomm/phy-qcom-ufs-qmp-20nm.c
> index aef40f7a41d4..b05f89d734f0 100644
> --- a/drivers/phy/qualcomm/phy-qcom-ufs-qmp-20nm.c
> +++ b/drivers/phy/qualcomm/phy-qcom-ufs-qmp-20nm.c
> @@ -67,6 +67,16 @@ static int ufs_qcom_phy_qmp_20nm_init(struct phy *gene=
ric_phy)
>         bool is_rate_B =3D false;
>         int ret;
> =20
> +       ret =3D ufs_qcom_phy_get_reset(phy_common);
> +       if (ret)
> +               return ret;
> +
> +       if (phy_common->ufs_reset) {
> +               ret =3D reset_control_assert(phy_common->ufs_reset);

It looks like you can always call this and set phy_common->ufs_reset to
NULL when it should be a no-op. But it would never be NULL because we
would always fail earlier in ufs_qcom_phy_get_reset()?

> +               if (ret)
> +                       return ret;
> +       }
> +
>         if (phy_common->mode =3D=3D PHY_MODE_UFS_HS_B)
>                 is_rate_B =3D true;
> =20
> diff --git a/drivers/phy/qualcomm/phy-qcom-ufs.c b/drivers/phy/qualcomm/p=
hy-qcom-ufs.c
> index f2979ccad00a..9cc8aa0b7a4f 100644
> --- a/drivers/phy/qualcomm/phy-qcom-ufs.c
> +++ b/drivers/phy/qualcomm/phy-qcom-ufs.c
> @@ -147,6 +147,22 @@ struct phy *ufs_qcom_phy_generic_probe(struct platfo=
rm_device *pdev,
>  }
>  EXPORT_SYMBOL_GPL(ufs_qcom_phy_generic_probe);
> =20
> +int ufs_qcom_phy_get_reset(struct ufs_qcom_phy *phy_common)
> +{
> +       struct reset_control *reset;
> +
> +       if (phy_common->ufs_reset)
> +               return 0;
> +
> +       reset =3D devm_reset_control_get_exclusive_by_index(phy_common->d=
ev, 0);
> +       if (IS_ERR(reset))
> +               return PTR_ERR(reset);
> +
> +       phy_common->ufs_reset =3D reset;
> +       return 0;

I find this API weird that it doesn't return the pointer to the reset
controller. It would be more kernel idiomatic if it returned the pointer
and used error pointers.

Are there now two places where we're getting the reset controller? I'm
confused now.

> +}
> +EXPORT_SYMBOL_GPL(ufs_qcom_phy_get_reset);
> +
>  static int __ufs_qcom_phy_clk_get(struct device *dev,
>                          const char *name, struct clk **clk_out, bool err=
_print)
>  {
> @@ -533,6 +549,14 @@ int ufs_qcom_phy_power_on(struct phy *generic_phy)
>         if (phy_common->is_powered_on)
>                 return 0;
> =20
> +       if (phy_common->ufs_reset) {
> +               err =3D reset_control_deassert(phy_common->ufs_reset);
> +               if (err) {
> +                       dev_err(dev, "Failed to assert UFS PHY reset");
> +                       return err;
> +               }
> +       }
> +
>         if (!phy_common->is_started) {
>                 err =3D ufs_qcom_phy_start_serdes(phy_common);
>                 if (err)
> @@ -620,6 +644,9 @@ int ufs_qcom_phy_power_off(struct phy *generic_phy)
> =20
>         ufs_qcom_phy_disable_vreg(phy_common->dev, &phy_common->vdda_pll);
>         ufs_qcom_phy_disable_vreg(phy_common->dev, &phy_common->vdda_phy);
> +       if (phy_common->ufs_reset)
> +               reset_control_assert(phy_common->ufs_reset);

All these ifs can go away basically.

> +
>         phy_common->is_powered_on =3D false;
> =20
>         return 0;
