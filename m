From: Stephen Boyd <swboyd@chromium.org>
Subject: Re: [PATCH v3 8/8] phy: ufs-qcom: Refactor all init steps into phy_poweron
Date: Wed, 06 Feb 2019 14:04:15 -0800
Message-ID: <154949065550.115909.10216592012769136925@swboyd.mtv.corp.google.com>
References: <20190205185902.106085-1-evgreen@chromium.org> <20190205185902.106085-9-evgreen@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190205185902.106085-9-evgreen@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Gross <andy.gross@linaro.org>, Kishon Vijay Abraham I <kishon@ti.com>
Cc: Marc Gonzalez <marc.w.gonzalez@free.fr>, Can Guo <cang@codeaurora.org>, Vivek Gautam <vivek.gautam@codeaurora.org>, Douglas Anderson <dianders@chromium.org>, Asutosh Das <asutoshd@codeaurora.org>, Evan Green <evgreen@chromium.org>, Jeffrey Hugo <jhugo@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>, linux-scsi@vger.kernel.org, Grygorii Strashko <grygorii.strashko@ti.com>, Bjorn Andersson <bjorn.andersson@linaro.org>, linux-kernel@vger.kernel.org, Manu Gautam <mgautam@codeaurora.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, Vinayak Holikatti <vinholikatti@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Quoting Evan Green (2019-02-05 10:59:02)
> The phy code was using implicit sequencing between the PHY driver
> and the UFS driver to implement certain hardware requirements.
> Specifically, the PHY reset register in the UFS controller needs
> to be deasserted before serdes start occurs in the PHY.
>=20
> Before this change, the code was doing this by utilizing the two
> phy callbacks, phy_init() and phy_poweron(), as "init step 1" and
> "init step 2", where the UFS driver would deassert reset between
> these two steps.
>=20
> This makes it challenging to power off the regulators in suspend,
> as regulators are initialized in init, not in poweron(), but only
> poweroff() is called during suspend, not exit().
>=20
> For UFS, move the actual firing up of the PHY to phy_poweron() and
> phy_poweroff() callbacks, rather than init()/exit(). UFS calls
> phy_poweroff() during suspend, so now all clocks and regulators for
> the phy can be powered down during suspend.
>=20
> QMP is a little tricky because the PHY is also shared with PCIe and
> USB3, which have their own definitions for init() and poweron(). Rename
> the meaty functions to _enable() and _disable() to disentangle from the
> PHY core names, and then create two different ops structures: one for
> UFS and one for the other PHY types.
>=20
> In phy-qcom-ufs, remove the 'is_powered_on' and 'is_started' guards,
> as the generic PHY code does the reference counting. The
> 14/20nm-specific init functions get collapsed into the generic power_on()
> function, with the addition of a calibrate() callback specific to 14/20nm.
>=20
> Signed-off-by: Evan Green <evgreen@chromium.org>

Reviewed-by: Stephen Boyd <swboyd@chromium.org>

although it may change if the patch before this is changed
significantly.

> diff --git a/drivers/phy/qualcomm/phy-qcom-qmp.c b/drivers/phy/qualcomm/p=
hy-qcom-qmp.c
> index 2861c64b9bcc..3597c4c0e50f 100644
> --- a/drivers/phy/qualcomm/phy-qcom-qmp.c
> +++ b/drivers/phy/qualcomm/phy-qcom-qmp.c
> @@ -1341,8 +1341,7 @@ static int qcom_qmp_phy_com_exit(struct qcom_qmp *q=
mp)
>         return 0;
>  }
> =20
> -/* PHY Initialization */
> -static int qcom_qmp_phy_init(struct phy *phy)
> +static int qcom_qmp_phy_enable(struct phy *phy)
>  {
>         struct qmp_phy *qphy =3D phy_get_drvdata(phy);
>         struct qcom_qmp *qmp =3D qphy->qmp;
> @@ -1423,14 +1422,6 @@ static int qcom_qmp_phy_init(struct phy *phy)
>                         goto err_lane_rst;
>         }
> =20
> -       /*
> -        * UFS PHY requires the deassert of software reset before serdes =
start.
> -        * For UFS PHYs that do not have software reset control bits, def=
er
> -        * starting serdes until the power on callback.
> -        */
> -       if ((cfg->type =3D=3D PHY_TYPE_UFS) && cfg->no_pcs_sw_reset)
> -               goto out;
> -
>         /*
>          * Pull out PHY from POWER DOWN state.
>          * This is active low enable signal to power-down PHY.
> @@ -1442,7 +1433,9 @@ static int qcom_qmp_phy_init(struct phy *phy)
>                 usleep_range(cfg->pwrdn_delay_min, cfg->pwrdn_delay_max);
> =20
>         /* Pull PHY out of reset state */
> -       qphy_clrbits(pcs, cfg->regs[QPHY_SW_RESET], SW_RESET);
> +       if (!cfg->no_pcs_sw_reset)
> +               qphy_clrbits(pcs, cfg->regs[QPHY_SW_RESET], SW_RESET);
> +
>         if (cfg->has_phy_dp_com_ctrl)
>                 qphy_clrbits(dp_com, QPHY_V3_DP_COM_SW_RESET, SW_RESET);
> =20

This is non-obvious, but OK I can see now that it's fine that everything
is combined into one function. I didn't realize that phy_init() was
polling the ready bit in addition to power on doing that under certain
circumstances.

Quite honestly, I find the whole implementation to be obtuse; combining
all the phy code together into one function and then changing the
execution paths via booleans and the 'type' member. It makes following
and reviewing this code really painful. We should make phy ops for each
type of phy: USB, USB+DP, PCIE, UFS, etc. and then have those ops call
simpler building block functions that do the common things. Then
reviewers don't have to untangle the execution paths in their minds to
make sure that nothing goes wrong when a stray 'if (my_phy_flag)' is
thrown into the init function and have to wonder if that causes problems
for something else.
