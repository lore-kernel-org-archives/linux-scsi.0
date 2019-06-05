From: Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: Re: [PATCH 0/3] (Qualcomm) UFS device reset support
Date: Tue, 4 Jun 2019 23:01:54 -0700
Message-ID: <20190605060154.GJ22737@tuxbook-pro>
References: <20190604072001.9288-1-bjorn.andersson@linaro.org>
 <CANcMJZBmgWMZu7Y53Lnx_x3L2UpCmEbFRHVW0SFCXfW=Yw9uYg@mail.gmail.com>
 <SN6PR04MB4925530F216E86F6404FE14CFC160@SN6PR04MB4925.namprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <SN6PR04MB4925530F216E86F6404FE14CFC160@SN6PR04MB4925.namprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Avri Altman <Avri.Altman@wdc.com>
Cc: John Stultz <john.stultz@linaro.org>, Andy Gross <agross@kernel.org>, Linus Walleij <linus.walleij@linaro.org>, Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Pedro Sousa <pedrom.sousa@synopsys.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>, "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue 04 Jun 22:50 PDT 2019, Avri Altman wrote:

> Hi,
> 
> > 
> > On Tue, Jun 4, 2019 at 12:22 AM Bjorn Andersson
> > <bjorn.andersson@linaro.org> wrote:
> > >
> > > This series exposes the ufs_reset line as a gpio, adds support for ufshcd to
> > > acquire and toggle this and then adds this to SDM845 MTP.
> > >
> > > Bjorn Andersson (3):
> > >   pinctrl: qcom: sdm845: Expose ufs_reset as gpio
> > >   scsi: ufs: Allow resetting the UFS device
> > >   arm64: dts: qcom: sdm845-mtp: Specify UFS device-reset GPIO
> > 
> > Adding similar change as in sdm845-mtp to the not yet upstream
> > blueline dts, I validated this allows my micron UFS pixel3 to boot.
> > 
> > Tested-by: John Stultz <john.stultz@linaro.org>
> Maybe ufs_hba_variant_ops would be the proper place to add this?
> 

Are you saying that these memories only need a reset when they are
paired with the Qualcomm host controller?

The way it's implemented it here is that the device-reset GPIO is
optional and only if you specify it we'll toggle the reset. So if your
board design has a UFS memory that requires a reset pulse during
initialization you specify this, regardless of which vendor your SoC
comes from.

Regards,
Bjorn
