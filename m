From: Suman Tripathi <stripathi@apm.com>
Subject: [PATCH v8 0/3] ahci_xgene: Fixes related to APM X-Gene SATA host controller driver.
Date: Sun, 24 Aug 2014 00:07:24 +0530
Message-ID: <1408819047-17224-1-git-send-email-stripathi@apm.com>
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, ddutile@redhat.com, jcm@redhat.com, patches@apm.com, Suman Tripathi <stripathi@apm.com>, Loc Ho <lho@apm.com>
List-Id: linux-scsi@vger.kernel.org

This patch set contains a couple of fixes related to APM X-Gene SATA
controller driver.

v2 Change:
   1. Drop the Link down retry patch from this patch set.

v4 Change:
   1. Drop the patch to fix the csr-mask in dts for PHY clock
     node of SATA Host Controller 1.
   2. Add the patch to correct the OOB tunning parameters for
     the COMINIT/COMWAKE parameters.
   3. Add the patch to remove the NCQ support from the APM
     X-Gene AHCI SATA Host controller driver.
   4. Add the patch to remove the clock and PHY reference nodes
     from the APM X-Gene Host controller dts node.

v5 Change :
   1. All the patches are based on 3.16.0-rc6/for-3.17 kernel.
   2. Drop the patch to remove the clock and PHY reference nodes
     from the APM X-Gene Host controller dts node as it breaks
     with old firmware.
   3. Add the patch to skip phy and clock initialisation if
     already done in the firmware.
   4. Add the patch to fix the csr-mask in dts for PHY clock
     node of SATA Host Controller 1.
   5. Add the patch to remove the NCQ support from the APM
     X-Gene AHCI SATA Host controller driver based on 3.16.0-rc6/
     for-3.17 kernel.
   6. Drop the patch to correct the OOB tunning parameters for
     the COMINIT/COMWAKE parameters as it is already applied to
     3.16/for-3.17 branch by the maintainer.
   7. Drop the patch to fix the watermark threshold as it is
     already applied to 3.16/for-3.17 branch by the maintainer.

v6 change :
   1. Drop the patch to skip phy and clock initialisation if
     already done in the firmware.
   2. Drop the patch to fix the csr-mask in dts for PHY clock
     node of SATA Host Controller 1.
   3. Add the remove the clock and PHY node patch as it
     fixes the dropped patches together. This patch works with
     old and new firmware as well.

v7 change :
   1. Drop the patch to remove the clock and PHY reference nodes
     from the APM X-Gene Host controller dts node as it breaks
     with old firmware if sata not initialised from the firmware.
   2. Add the patch to skip phy and clock initialisation if
     already done in the firmware.
   3. Add the patch to fix the csr-mask in dts for PHY clock
     node of SATA Host Controller 1.
   4. Add the Link down retry patch with a proper comments and
     explanation.
   5. Drop the patch to remove NCQ as it is applied to 3.16/for-3.17.

v8 change :
   1. Adding proper comments for link down retry patch.
   2. changing the return type to bool for skip phy patch.

Signed-off-by: Loc Ho <lho@apm.com>
Signed-off-by: Suman Tripathi <stripathi@apm.com>
---

Suman Tripathi (3):
  arm64: Fix the csr-mask for APM X-Gene SoC AHCI SATA PHY clock DTS
    node.
  ahci_xgene: Skip the PHY and clock initialization if already
    configured by the firmware.
  ahci_xgene: Fix the link down in first attempt for the APM X-Gene SoC
    AHCI SATA host controller driver.

 arch/arm64/boot/dts/apm-storm.dtsi |  5 +----
 drivers/ata/ahci_xgene.c           | 41 +++++++++++++++++++++++++++++++-------
 2 files changed, 35 insertions(+), 11 deletions(-)

--
1.8.2.1

