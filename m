From: Evan Green <evgreen@chromium.org>
Subject: Re: [PATCH v5 0/8] phy: qcom-ufs: Enable regulators to be off in suspend
Date: Tue, 26 Mar 2019 09:17:48 -0700
Message-ID: <CAE=gft5c3pS2ksH_oW_+F52gr4r0KnkoUHJXZ7u9vChSAZEovg@mail.gmail.com>
References: <20190321171800.104681-1-evgreen@chromium.org> <d90e86b9-a330-677c-a70a-d66139473f48@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <d90e86b9-a330-677c-a70a-d66139473f48@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kishon Vijay Abraham I <kishon@ti.com>, Andy Gross <andy.gross@linaro.org>, Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Stephen Boyd <swboyd@chromium.org>, Marc Gonzalez <marc.w.gonzalez@free.fr>, Can Guo <cang@codeaurora.org>, Vivek Gautam <vivek.gautam@codeaurora.org>, Douglas Anderson <dianders@chromium.org>, Asutosh Das <asutoshd@codeaurora.org>, "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" <devicetree@vger.kernel.org>, Pedro Sousa <pedrom.sousa@synopsys.com>, liwei <liwei213@huawei.com>, SCSI <linux-scsi@vger.kernel.org>, linux-arm-msm <linux-arm-msm@vger.kernel.org>, Bart Van Assche <Bart.VanAssche@wdc.com>, LKML <linux-kernel@vger.kernel.org>, Subhash Jadavani <subhashj@codeaurora.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Alim Akhtar <alim.akhtar@samsung.com>, Rob Herring <robh+dt@kernel.org>, Avri Altman <avri.altman@wdc.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Mar 26, 2019 at 12:49 AM Kishon Vijay Abraham I <kishon@ti.com> wrote:
>
> Hi,
>
> On 21/03/19 10:47 PM, Evan Green wrote:
> > The goal with this series is to enable shutting off regulators that power
> > UFS during system suspend.
> >
> > In "the good life" version of this, we'd just disable the regulators
> > in phy_poweroff() and be done with it. Unfortunately, that's not symmetric,
> > as regulators are not enabled during phy_poweron(). Ok, so you might think
> > we could just move the regulator enable and anything else that needs to
> > come along into phy_poweron(), so that we can then undo it all in
> > phy_poweroff(). That's where things get tricky.
> >
> > The qcom-qmp-phy overloaded the phy_init() and phy_poweron() callbacks,
> > basically to mean "init phase 1" and "init phase 2". There are two phases
> > because they have this phy_reset bit outside of the phy (in the UFS
> > controller registers), and they need to make sure this bit is toggled at
> > specific points in the phy init sequence. So there's this implicit
> > sequence in the init dance between ufs-qcom.c and phy-qcom-qmp.c:
> > 1) ufs-qcom asserts the PHY reset bit.
> > 2) phy-qcom-qmp phy_init() does most of its initialization, but exits early.
> > 3) ufs-qcom deasserts the PHY reset bit.
> > 4) phy-qcom-qmp phy_poweron() finishes its initialization.
> >
> > This init dance is very difficult to follow in the code (since it's split
> > between two drivers and not spelled out well), and arguably represents a
> > deficiency in the hardware description of these devices.
> >
> > In this series I'm proposing tweaking the bindings for the Qualcomm
> > UFS controller and PHY. In it we expose a reset controller from the
> > UFS controller, that is then picked up and used from the PHY code.
> > With this, the phy code can be reorganized to complete its initialization
> > in a single function, removing the implicit two-phase overloading.
> >
> > Then I can move most of the phy initialization, including enabling
> > the regulators, into phy_poweron(). Now, when phy_poweroff() is called,
> > the phy actually powers off. This finally disables the regulators
> > and allows me to save power in system suspend.
> >
> > Because the UFS PHY reset bit is now toggled in the PHY, rather
> > than in ufs-qcom, this also percolated to all other PHYs using
> > ufs-qcom, which from what I can see is just 8996.
> >
> > I removed the calls to phy_poweroff() during clock gating. This
> > was originally dialing down a clock or two, while leaving the phy powered.
> > I've now changed the semantics of phy_poweroff() to, well, actually power off.
> > This works great for userlands that have set UFS's spm_lvl to 5 (off) like
> > I have, but maybe changes power consumption for devices that have spm_lvl
> > set to 3. I could try to use phy_init() and phy_poweron() as the two
> > different possible transitions (fully off, and clocks off respectively),
> > but I'm not sure if it actually matters, and I like the idea that
> > phy_poweroff() really does power the thing off.
> >
> > Also, I don't have an 8996 device to test. If someone is able to test this
> > out and perhaps point out any (hopefully obvious) bugs in the 8996 portion,
> > I'd be grateful.
> >
> > This patch is based atop phy-next.
>
> Merged the series except the dts patches.

Yay, thanks Kishon.

Andy, Bjorn, are you able to take the DT patches?
-Evan
