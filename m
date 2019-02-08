From: Marc Gonzalez <marc.w.gonzalez@free.fr>
Subject: [PATCH v4 0/7] UFS on APQ8098/MSM8998
Date: Fri, 8 Feb 2019 23:09:29 +0100
Message-ID: <09ce9c20-c47b-f936-a8a9-6c8ec8f0f867@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: MSM <linux-arm-msm@vger.kernel.org>, SCSI <linux-scsi@vger.kernel.org>
Cc: Jeffrey Hugo <jhugo@codeaurora.org>, Bjorn Andersson <bjorn.andersson@linaro.org>, Andy Gross <andy.gross@linaro.org>, David Brown <david.brown@linaro.org>, Evan Green <evgreen@chromium.org>, Douglas Anderson <dianders@chromium.org>, Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, Pedro Sousa <pedrom.sousa@synopsys.com>, Rob Herring <robh+dt@kernel.org>, Kishon Vijay Abraham <kishon@ti.com>, Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>, Martin Petersen <martin.petersen@oracle.com>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hello,

This series adds support for the UFS host controller on
APQ8098/MSM8998-based boards.

I CCed the regulator maintainers to discuss the revert in
patch 6. Basically, the original patch added a quirk which
forcefully disables vccq when the UFSHC is connected to a
Samsung or Hynix Flash chip. Problem is, this disabling
breaks init on my board, and Jeffrey's board as well.
Hence the revert, for which I don't see any adverse
consequences?

Differences between v3 and v4:
- Rebase on top of -next
- Pick up Douglas Anderson's UFSHC doc fix
- Document 8998 UFSHC binding
- Improve UFS PHY binding doc
- Put the UFS DT patch at the end of the series

Difference between v2 and v3:
- Add qcom,msm8998-qmp-ufs-phy compat string and match it in the PHY driver
- Drop vdd-hba-fixed-regulator
- Write the reg addresses with full 32-bit width
- Set regulator-allow-set-load only on the 3 rails used by UFS.
- Revert the patch introducing ufshcd_set_vccq_rail_unused

Difference between v1 and v2:
- New patch to add 'regulator-allow-set-load' prop to all vreg nodes
- Rename rpmcc node to 'clock-controller' + Add Review tags
- Drop UFS pinctrl gymnastics (not required, probably left enabled in bootloader)
- Delete GCC_UFS_ICE_CORE_CLK (ICE not used upstream, I think)
- Fix sizes of ufsphy register areas based on Jeffrey's feedback
- Hack ufshcd_set_vccq_rail_unused into a NOP to work around lock up + reboot

Douglas Anderson (1):
  dt-bindings: ufs: Fix the compatible string definition

Marc Gonzalez (6):
  dt-bindings: ufs: Add msm8998 compatible string
  dt-bindings: phy-qcom-qmp: Add qcom,msm8998-qmp-ufs-phy
  phy: qcom-qmp: Add QMP UFS PHY support for msm8998
  arm64: dts: qcom: msm8998: Allow drivers to set-load
  Revert "scsi: ufs: disable vccq if it's not needed by UFS device"
  arm64: dts: qcom: msm8998: Add UFS nodes

 .../devicetree/bindings/phy/qcom-qmp-phy.txt  |  4 ++
 .../devicetree/bindings/ufs/ufshcd-pltfrm.txt | 14 +++--
 arch/arm64/boot/dts/qcom/msm8998-mtp.dtsi     | 22 +++++++
 arch/arm64/boot/dts/qcom/msm8998.dtsi         | 62 +++++++++++++++++++
 drivers/phy/qualcomm/phy-qcom-qmp.c           |  3 +
 drivers/scsi/ufs/ufs.h                        |  1 -
 drivers/scsi/ufs/ufshcd.c                     | 59 ++----------------
 7 files changed, 104 insertions(+), 61 deletions(-)

-- 
2.17.1
