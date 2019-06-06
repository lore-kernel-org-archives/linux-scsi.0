From: Avri Altman <Avri.Altman@wdc.com>
Subject: RE: [PATCH 0/3] (Qualcomm) UFS device reset support
Date: Thu, 6 Jun 2019 06:32:15 +0000
Message-ID: <SN6PR04MB49255AF3D92E655E1BBD75AEFC170@SN6PR04MB4925.namprd04.prod.outlook.com>
References: <20190604072001.9288-1-bjorn.andersson@linaro.org>
 <CANcMJZBmgWMZu7Y53Lnx_x3L2UpCmEbFRHVW0SFCXfW=Yw9uYg@mail.gmail.com>
 <SN6PR04MB4925530F216E86F6404FE14CFC160@SN6PR04MB4925.namprd04.prod.outlook.com>
 <20190605060154.GJ22737@tuxbook-pro>
 <SN6PR04MB492521B7D2DB6F3462EDB7D9FC160@SN6PR04MB4925.namprd04.prod.outlook.com>
 <20190606003959.GM4814@minitux>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190606003959.GM4814@minitux>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: John Stultz <john.stultz@linaro.org>, Andy Gross <agross@kernel.org>, Linus Walleij <linus.walleij@linaro.org>, Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Pedro Sousa <pedrom.sousa@synopsys.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>, "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

>=20
> On Wed 05 Jun 02:32 PDT 2019, Avri Altman wrote:
>=20
> > >
> > > On Tue 04 Jun 22:50 PDT 2019, Avri Altman wrote:
> > >
> > > > Hi,
> > > >
> > > > >
> > > > > On Tue, Jun 4, 2019 at 12:22 AM Bjorn Andersson
> > > > > <bjorn.andersson@linaro.org> wrote:
> > > > > >
> > > > > > This series exposes the ufs_reset line as a gpio, adds support =
for ufshcd
> to
> > > > > > acquire and toggle this and then adds this to SDM845 MTP.
> > > > > >
> > > > > > Bjorn Andersson (3):
> > > > > >   pinctrl: qcom: sdm845: Expose ufs_reset as gpio
> > > > > >   scsi: ufs: Allow resetting the UFS device
> > > > > >   arm64: dts: qcom: sdm845-mtp: Specify UFS device-reset GPIO
> > > > >
> > > > > Adding similar change as in sdm845-mtp to the not yet upstream
> > > > > blueline dts, I validated this allows my micron UFS pixel3 to boo=
t.
> > > > >
> > > > > Tested-by: John Stultz <john.stultz@linaro.org>
> > > > Maybe ufs_hba_variant_ops would be the proper place to add this?
> > > >
> > >
> > > Are you saying that these memories only need a reset when they are
> > > paired with the Qualcomm host controller?
> > ufs_hba_variant_ops is for vendors to implement their own vops,
> > and as you can see, many of them do.
> > Adding hw_reset to that template seems like the proper way
> > to do what you are doing.
> >
>=20
> Right, but the vops is operations related to the UFS controller, this
> property relates to the memory connected.
This is not entirely accurate. Those are vendor/board specific,
As the original commit log indicates:
" vendor/board specific and hence determined with
 the help of compatible property in device tree."

I would rather have this new vop:
void    (*device_reset)(struct ufs_hba *), Or whatever,=20
actively set in ufs_hba_variant_ops, rather than ufshcd_init_device_reset
failing as part of the default init flow.

Thanks,
Avri

>=20
> E.g I have a Hynix memory and John have a Micron memory that needs this
> reset and my assumption is that these memories will need their RESET pin
> toggled regardless of which controller they are connected to.
>=20
> Regards,
> Bjorn
