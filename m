From: Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: Re: [PATCH 3/3] arm64: dts: qcom: sdm845-mtp: Specify UFS
 device-reset GPIO
Date: Tue, 4 Jun 2019 15:09:10 -0700
Message-ID: <20190604220910.GA4814@minitux>
References: <20190604072001.9288-1-bjorn.andersson@linaro.org>
 <20190604072001.9288-4-bjorn.andersson@linaro.org>
 <5cf69ad2.1c69fb81.216a9.30f8@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5cf69ad2.1c69fb81.216a9.30f8@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Stephen Boyd <swboyd@chromium.org>
Cc: Andy Gross <agross@kernel.org>, Linus Walleij <linus.walleij@linaro.org>, Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Pedro Sousa <pedrom.sousa@synopsys.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-arm-msm@vger.kernel.org, linux-gpio@vger.kernel.org, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Evan Green <evgreen@chromium.org>
List-Id: linux-scsi@vger.kernel.org

On Tue 04 Jun 09:22 PDT 2019, Stephen Boyd wrote:

> Quoting Bjorn Andersson (2019-06-04 00:20:01)
> > Specify the UFS device-reset gpio, so that the controller will issue a
> > reset of the UFS device.
> > 
> > Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> > ---
> >  arch/arm64/boot/dts/qcom/sdm845-mtp.dts | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/arch/arm64/boot/dts/qcom/sdm845-mtp.dts b/arch/arm64/boot/dts/qcom/sdm845-mtp.dts
> > index 2e78638eb73b..d116a0956a9c 100644
> > --- a/arch/arm64/boot/dts/qcom/sdm845-mtp.dts
> > +++ b/arch/arm64/boot/dts/qcom/sdm845-mtp.dts
> > @@ -388,6 +388,8 @@
> >  &ufs_mem_hc {
> >         status = "okay";
> >  
> > +       device-reset-gpios = <&tlmm 150 GPIO_ACTIVE_LOW>;
> > +
> 
> We had to do something similar on one particular brand of UFS that we had. I
> think it was an SK Hynix part that had trouble and wouldn't provision properly.
> Either way, we did this with a pinctrl toggle in the DTS where the "init" state
> has the UFS_RESET pin asserted and then "default" state has the pin deasserted.
> That was good enough to make this work.
> 

Thanks for pointing this out, I forgot to attribute these downstream
changes. I can see how this works, but I must say I find it quite
hackish.

The downstream solution seems to have evolved this into naming these
states and jumping between them (with the appropriate sleeps) during a
host reset as well.


But thanks for the confirmation that there's more than John's memory
that needs this.

Regards,
Bjorn

> 	&ufs_mem_hc {
> 		pinctrl-names = "init", "default";
> 		pinctrl-0 = <&ufs_dev_reset_assert>;
> 		pinctrl-1 = <&ufs_dev_reset_deassert>;
> 	};
> 
>         ufs_dev_reset_assert: ufs_dev_reset_assert {
>                 config {
>                         pins = "ufs_reset";
>                         bias-pull-down;         /* default: pull down */
>                         drive-strength = <8>;   /* default: 3.1 mA */
>                         output-low; /* active low reset */
>                 };
>         };
> 
>         ufs_dev_reset_deassert: ufs_dev_reset_deassert {
>                 config {
>                         pins = "ufs_reset";
>                         bias-pull-down;         /* default: pull down */
>                         drive-strength = <8>;
>                         output-high; /* active low reset */
>                 };
>         };
