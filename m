From: Kishon Vijay Abraham I <kishon@ti.com>
Subject: Re: [PATCH v5 0/8] phy: qcom-ufs: Enable regulators to be off in
 suspend
Date: Tue, 26 Mar 2019 13:18:35 +0530
Message-ID: <d90e86b9-a330-677c-a70a-d66139473f48@ti.com>
References: <20190321171800.104681-1-evgreen@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190321171800.104681-1-evgreen@chromium.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Evan Green <evgreen@chromium.org>
Cc: Stephen Boyd <swboyd@chromium.org>, Marc Gonzalez <marc.w.gonzalez@free.fr>, Can Guo <cang@codeaurora.org>, Vivek Gautam <vivek.gautam@codeaurora.org>, Douglas Anderson <dianders@chromium.org>, Asutosh Das <asutoshd@codeaurora.org>, devicetree@vger.kernel.org, Pedro Sousa <pedrom.sousa@synopsys.com>, liwei <liwei213@huawei.com>, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, Bart Van Assche <Bart.VanAssche@wdc.com>, linux-kernel@vger.kernel.org, Andy Gross <andy.gross@linaro.org>, Subhash Jadavani <subhashj@codeaurora.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Alim Akhtar <alim.akhtar@samsung.com>, Rob Herring <robh+dt@kernel.org>, Avri Altman <avri.altman@wdc.com>, Mark Rutland <mark.rutland@arm.com>, James
List-Id: linux-scsi@vger.kernel.org

Hi,

On 21/03/19 10:47 PM, Evan Green wrote:
> The goal with this series is to enable shutting off regulators that power
> UFS during system suspend.
> 
> In "the good life" version of this, we'd just disable the regulators
> in phy_poweroff() and be done with it. Unfortunately, that's not symmetric,
> as regulators are not enabled during phy_poweron(). Ok, so you might think
> we could just move the regulator enable and anything else that needs to
> come along into phy_poweron(), so that we can then undo it all in
> phy_poweroff(). That's where things get tricky.
> 
> The qcom-qmp-phy overloaded the phy_init() and phy_poweron() callbacks,
> basically to mean "init phase 1" and "init phase 2". There are two phases
> because they have this phy_reset bit outside of the phy (in the UFS
> controller registers), and they need to make sure this bit is toggled at
> specific points in the phy init sequence. So there's this implicit
> sequence in the init dance between ufs-qcom.c and phy-qcom-qmp.c:
> 1) ufs-qcom asserts the PHY reset bit.
> 2) phy-qcom-qmp phy_init() does most of its initialization, but exits early.
> 3) ufs-qcom deasserts the PHY reset bit.
> 4) phy-qcom-qmp phy_poweron() finishes its initialization.
> 
> This init dance is very difficult to follow in the code (since it's split
> between two drivers and not spelled out well), and arguably represents a
> deficiency in the hardware description of these devices.
> 
> In this series I'm proposing tweaking the bindings for the Qualcomm
> UFS controller and PHY. In it we expose a reset controller from the
> UFS controller, that is then picked up and used from the PHY code.
> With this, the phy code can be reorganized to complete its initialization
> in a single function, removing the implicit two-phase overloading.
> 
> Then I can move most of the phy initialization, including enabling
> the regulators, into phy_poweron(). Now, when phy_poweroff() is called,
> the phy actually powers off. This finally disables the regulators
> and allows me to save power in system suspend.
> 
> Because the UFS PHY reset bit is now toggled in the PHY, rather
> than in ufs-qcom, this also percolated to all other PHYs using
> ufs-qcom, which from what I can see is just 8996.
> 
> I removed the calls to phy_poweroff() during clock gating. This
> was originally dialing down a clock or two, while leaving the phy powered.
> I've now changed the semantics of phy_poweroff() to, well, actually power off.
> This works great for userlands that have set UFS's spm_lvl to 5 (off) like
> I have, but maybe changes power consumption for devices that have spm_lvl
> set to 3. I could try to use phy_init() and phy_poweron() as the two
> different possible transitions (fully off, and clocks off respectively),
> but I'm not sure if it actually matters, and I like the idea that
> phy_poweroff() really does power the thing off.
> 
> Also, I don't have an 8996 device to test. If someone is able to test this
> out and perhaps point out any (hopefully obvious) bugs in the 8996 portion,
> I'd be grateful.
> 
> This patch is based atop phy-next.

Merged the series except the dts patches.

Thanks
Kishon
> 
> Changes in v5:
> - Updated tags
> 
> Changes in v4:
> - Do reset_control_* unconditionally since null is handled (Stephen).
> - Keep doing reset_control* unconditionally through refactor (Stephen).
> 
> Changes in v3:
> - Refactor to only expose the reset controller in one change (Stephen).
> - Add period to comment (Stephen).
> - Reset err to 0 in ignored error case (Stephen).
> - Add include of reset-controller.h (Stephen)
> - Refactored to move reset control in a single commit (Stephen)
> - Use no_pcs_sw_reset as an indicator of UFS reset in qmp-phy (Stephen).
> - Assign ret = PTR_ERR() earlier, for better reuse (Stephen).
> - Refactor init => poweron for all PHYs and UFS in one step (Stephen)
> 
> Changes in v2:
> - Added resets to example (Stephen).
> - Remove include of reset.h (Stephen)
> - Fix error print of phy_power_on (Stephen)
> - Comment for reset controller warnings on id != 0 (Stephen)
> - Add static to ufs_qcom_reset_ops (Stephen).
> - Use devm_* to get the reset (Stephen)
> - Clear ufs_reset on error getting it
> - Remove needless error print (Stephen)
> - Use devm_ to get the reset (Stephen)
> - Removed whitespace changes (Stephen)
> 
> Evan Green (8):
>   dt-bindings: ufs: Add #reset-cells for Qualcomm controllers
>   dt-bindings: phy-qcom-qmp: Add UFS PHY reset
>   dt-bindings: phy: qcom-ufs: Add resets property
>   arm64: dts: sdm845: Add UFS PHY reset
>   arm64: dts: msm8996: Add UFS PHY reset controller
>   scsi: ufs: qcom: Expose the reset controller for PHY
>   phy: qcom: Utilize UFS reset controller
>   phy: ufs-qcom: Refactor all init steps into phy_poweron
> 
>  .../devicetree/bindings/phy/qcom-qmp-phy.txt  |   6 +-
>  .../devicetree/bindings/ufs/ufs-qcom.txt      |   5 +-
>  .../devicetree/bindings/ufs/ufshcd-pltfrm.txt |   3 +
>  arch/arm64/boot/dts/qcom/msm8996.dtsi         |   4 +-
>  arch/arm64/boot/dts/qcom/sdm845.dtsi          |   3 +
>  drivers/phy/qualcomm/phy-qcom-qmp.c           | 112 +++++++++--------
>  drivers/phy/qualcomm/phy-qcom-ufs-i.h         |   5 +-
>  drivers/phy/qualcomm/phy-qcom-ufs-qmp-14nm.c  |  25 +---
>  drivers/phy/qualcomm/phy-qcom-ufs-qmp-20nm.c  |  25 +---
>  drivers/phy/qualcomm/phy-qcom-ufs.c           |  57 ++++++---
>  drivers/scsi/ufs/Kconfig                      |   1 +
>  drivers/scsi/ufs/ufs-qcom.c                   | 114 +++++++++++-------
>  drivers/scsi/ufs/ufs-qcom.h                   |   4 +
>  13 files changed, 193 insertions(+), 171 deletions(-)
> 
