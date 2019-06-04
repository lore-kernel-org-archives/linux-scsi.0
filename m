From: Stephen Boyd <swboyd@chromium.org>
Subject: Re: [PATCH 3/3] arm64: dts: qcom: sdm845-mtp: Specify UFS device-reset GPIO
Date: Tue, 04 Jun 2019 09:22:42 -0700
Message-ID: <5cf69ad2.1c69fb81.216a9.30f8@mx.google.com>
References: <20190604072001.9288-1-bjorn.andersson@linaro.org> <20190604072001.9288-4-bjorn.andersson@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190604072001.9288-4-bjorn.andersson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Gross <agross@kernel.org>, Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>, Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Pedro Sousa <pedrom.sousa@synopsys.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-arm-msm@vger.kernel.org, linux-gpio@vger.kernel.org, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Evan Green <evgreen@chromium.org>
List-Id: linux-scsi@vger.kernel.org

Quoting Bjorn Andersson (2019-06-04 00:20:01)
> Specify the UFS device-reset gpio, so that the controller will issue a
> reset of the UFS device.
>=20
> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> ---
>  arch/arm64/boot/dts/qcom/sdm845-mtp.dts | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/arch/arm64/boot/dts/qcom/sdm845-mtp.dts b/arch/arm64/boot/dt=
s/qcom/sdm845-mtp.dts
> index 2e78638eb73b..d116a0956a9c 100644
> --- a/arch/arm64/boot/dts/qcom/sdm845-mtp.dts
> +++ b/arch/arm64/boot/dts/qcom/sdm845-mtp.dts
> @@ -388,6 +388,8 @@
>  &ufs_mem_hc {
>         status =3D "okay";
> =20
> +       device-reset-gpios =3D <&tlmm 150 GPIO_ACTIVE_LOW>;
> +

We had to do something similar on one particular brand of UFS that we had. I
think it was an SK Hynix part that had trouble and wouldn't provision prope=
rly.
Either way, we did this with a pinctrl toggle in the DTS where the "init" s=
tate
has the UFS_RESET pin asserted and then "default" state has the pin deasser=
ted.
That was good enough to make this work.

	&ufs_mem_hc {
		pinctrl-names =3D "init", "default";
		pinctrl-0 =3D <&ufs_dev_reset_assert>;
		pinctrl-1 =3D <&ufs_dev_reset_deassert>;
	};

        ufs_dev_reset_assert: ufs_dev_reset_assert {
                config {
                        pins =3D "ufs_reset";
                        bias-pull-down;         /* default: pull down */
                        drive-strength =3D <8>;   /* default: 3.1 mA */
                        output-low; /* active low reset */
                };
        };

        ufs_dev_reset_deassert: ufs_dev_reset_deassert {
                config {
                        pins =3D "ufs_reset";
                        bias-pull-down;         /* default: pull down */
                        drive-strength =3D <8>;
                        output-high; /* active low reset */
                };
        };
