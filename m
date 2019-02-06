From: Stephen Boyd <sboyd@kernel.org>
Subject: RE: [PATCH v3 6/8] scsi: ufs: qcom: Expose the reset controller for PHY
Date: Wed, 06 Feb 2019 11:48:53 -0800
Message-ID: <154948253306.115909.17663891665120785337@swboyd.mtv.corp.google.com>
References: <20190205185902.106085-1-evgreen@chromium.org> <20190205185902.106085-7-evgreen@chromium.org> <10ea3fe2-e331-0342-cfad-eccce3753d2e@ti.com> <SN6PR04MB4925A158FB93AC99D15ED3EBFC6F0@SN6PR04MB4925.namprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <SN6PR04MB4925A158FB93AC99D15ED3EBFC6F0@SN6PR04MB4925.namprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Gross <andy.gross@linaro.org>, Avri Altman <Avri.Altman@wdc.com>, Evan Green <evgreen@chromium.org>, Kishon Vijay Abraham I <kishon@ti.com>, Vinayak Holikatti <vinholikatti@gmail.com>
Cc: Marc Gonzalez <marc.w.gonzalez@free.fr>, Can Guo <cang@codeaurora.org>, Vivek Gautam <vivek.gautam@codeaurora.org>, Douglas Anderson <dianders@chromium.org>, Asutosh Das <asutoshd@codeaurora.org>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Quoting Avri Altman (2019-02-06 05:57:17)
> Hi,
>=20
> > On 06/02/19 12:29 AM, Evan Green wrote:
> > > Expose a reset controller that the phy will later use to control its
> > > own PHY reset in the UFS controller. This will enable the combining
> > > of PHY init functionality into a single function.
> > >
> > > Signed-off-by: Evan Green <evgreen@chromium.org>
> >=20
> > I'd like to get ACK from scsi/ufs/ MAINTAINER Vinayak for me merge it i=
n PHY
> > tree.
> Looks like this series is qcom specific, and has less impact of the ufs c=
ore driver.
>=20
> > > +   err =3D devm_reset_controller_register(dev, &host->rcdev);
> Just my 2 cents:
> Isn't this should be done somewhere in drivers/clk/qcom,
> Like its done for any other qcom board?

It's not a clk controller, so I don't see how that makes sense. There
are clk/reset controllers on qcom platforms, and so we've combined them
into the same overall driver there because those resets affect clk
operations and vice-versa. But this looks like some sort of reset in the
phy or the controller itself and isn't the "clk type" resets that we
implement in drivers/clk/qcom/
