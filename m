From: Stephen Boyd <swboyd@chromium.org>
Subject: Re: [PATCH v4 8/8] phy: ufs-qcom: Refactor all init steps into phy_poweron
Date: Fri, 22 Feb 2019 12:28:26 -0800
Message-ID: <155086730616.77512.8822375378896358546@swboyd.mtv.corp.google.com>
References: <20190213232526.26995-1-evgreen@chromium.org> <20190213232526.26995-9-evgreen@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190213232526.26995-9-evgreen@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Gross <andy.gross@linaro.org>, Kishon Vijay Abraham I <kishon@ti.com>
Cc: Marc Gonzalez <marc.w.gonzalez@free.fr>, Can Guo <cang@codeaurora.org>, Vivek Gautam <vivek.gautam@codeaurora.org>, Douglas Anderson <dianders@chromium.org>, Asutosh Das <asutoshd@codeaurora.org>, Evan Green <evgreen@chromium.org>, Jeffrey Hugo <jhugo@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>, linux-scsi@vger.kernel.org, Grygorii Strashko <grygorii.strashko@ti.com>, Bjorn Andersson <bjorn.andersson@linaro.org>, linux-kernel@vger.kernel.org, Manu Gautam <mgautam@codeaurora.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, Vinayak Holikatti <vinholikatti@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Quoting Evan Green (2019-02-13 15:25:26)
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
> ---

Reviewed-by: Stephen Boyd <swboyd@chromium.org>
