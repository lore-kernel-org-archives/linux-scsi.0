Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9046C4332F
	for <linux-scsi@archiver.kernel.org>; Sun,  5 Nov 2023 18:37:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbjKEShl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 5 Nov 2023 13:37:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjKEShk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Nov 2023 13:37:40 -0500
Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DF8CBE
        for <linux-scsi@vger.kernel.org>; Sun,  5 Nov 2023 10:37:37 -0800 (PST)
Received: from tr.lan (ip-86-49-120-218.bb.vodafone.cz [86.49.120.218])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 1197086844;
        Sun,  5 Nov 2023 19:37:34 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1699209454;
        bh=2bQ1NBdYxAkeSjvQu0LHUnnnotHkIk6ivN+kRNSRHl4=;
        h=From:To:Cc:Subject:Date:From;
        b=SiilG6zr/IP25x7vS84qZfmn6RpQyAo6YY6dX8LCNdbk4lO7Ekgkm3c28t9pqDXTM
         SBpH7ddSQLMhAoJ9YYZdlAUZahj4djiyYv5NRjDm4PoKOmMt4csQqG6IuYnnrU0nZt
         Ozz9G9xtRTxLYVFZq8eazsm5lOTXqkB8Ue3ky/TstaCgYPiAHquQ0eoFbr3kZ6yO7c
         EQbEmDN6BX2Gz5uLMB1JQlIp5g/cBvyYBaJfL/1ccfPun/Y07Xb4iTXv9tBl4HJmd2
         ZmKorJ23l5jMblf78EZPm8J3ohU76BhH8wo6KVmGLeuY0ypYAYagGKqtgCppWMEHf4
         CuMleMlql/cPQ==
From:   Marek Vasut <marex@denx.de>
To:     linux-scsi@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        Jason Yan <yanaijie@huawei.com>,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2] scsi: mvsas: Try to enable MSI
Date:   Sun,  5 Nov 2023 19:36:49 +0100
Message-ID: <20231105183712.26520-1-marex@denx.de>
X-Mailer: git-send-email 2.42.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.103.8 at phobos.denx.de
X-Virus-Status: Clean
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This seems to be needed on OCZ RevoDrive 3 X2 / RevoDrive 350
OCZ Technology Group, Inc. RevoDrive 3 X2 PCIe SSD 240 GB (Marvell SAS Controller) [1b85:1021] (rev 02)

Without MSI enabled, the controller fails as follows:
"
mvsas 0000:00:02.0: mvsas: PCI-E x0, Bandwidth Usage: UnKnown Gbps
scsi host0: mvsas
sas: Enter sas_scsi_recover_host busy: 0 failed: 0
ata1.00: qc timeout after 5000 msecs (cmd 0xec)
ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
ata1.00: qc timeout after 10000 msecs (cmd 0xec)
ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
ata1.00: qc timeout after 30000 msecs (cmd 0xec)
ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 tries: 1
sas: sas_probe_sata: for direct-attached device 0000000000000000 returned -19
sas: Enter sas_scsi_recover_host busy: 0 failed: 0
ata2.00: qc timeout after 5000 msecs (cmd 0xec)
ata2.00: failed to IDENTIFY (I/O error, err_mask=0x4)
ata2.00: qc timeout after 10000 msecs (cmd 0xec)
ata2.00: failed to IDENTIFY (I/O error, err_mask=0x4)
ata2.00: qc timeout after 30000 msecs (cmd 0xec)
ata2.00: failed to IDENTIFY (I/O error, err_mask=0x4)
sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 tries: 1
sas: sas_probe_sata: for direct-attached device 0100000000000000 returned -19
"

With this patch, the controller detects the two SSD drives on it:
"
mvsas 0000:00:02.0: mvsas: PCI-E x0, Bandwidth Usage: UnKnown Gbps
scsi host0: mvsas
sas: Enter sas_scsi_recover_host busy: 0 failed: 0
ata1.00: ATA-8: OCZ-REVODRIVE350, 2.50, max UDMA/133
ata1.00: 234441648 sectors, multi 1: LBA48 NCQ (depth 32)
ata1.00: configured for UDMA/133
sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 tries: 1
scsi 0:0:0:0: Direct-Access     ATA      OCZ-REVODRIVE350 2.50 PQ: 0 ANSI: 5
sas: Enter sas_scsi_recover_host busy: 0 failed: 0
ata2.00: ATA-8: OCZ-REVODRIVE350, 2.50, max UDMA/133
ata2.00: 234441648 sectors, multi 1: LBA48 NCQ (depth 32)
ata2.00: configured for UDMA/133
sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 tries: 1
scsi 0:0:1:0: Direct-Access     ATA      OCZ-REVODRIVE350 2.50 PQ: 0 ANSI: 5
scsi 0:0:0:0: Attached scsi generic sg0 type 0
sd 0:0:0:0: [sda] 234441648 512-byte logical blocks: (120 GB/112 GiB)
sd 0:0:1:0: [sdb] 234441648 512-byte logical blocks: (120 GB/112 GiB)
sd 0:0:1:0: Attached scsi generic sg1 type 0
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:1:0: [sdb] Write Protect is off
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] Preferred minimum I/O size 512 bytes
sd 0:0:1:0: [sdb] Preferred minimum I/O size 512 bytes
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:1:0: [sdb] Attached SCSI disk
"

The enablement of MSIs has been part of this driver before, but was
removed without any real explanation in commit:
20b09c2992fe ("[SCSI] mvsas: add support for 94xx; layout change; bug fixes")
The enablement of MSIs is also part of the 'oczpcie' driver, which is
really an ancient fork of this driver with a lot of variable renames
and such.

This variant of fix attempt limits the MSI enablement to OCZ devices,
since the only ones produced are likely the RevoDrive series, and all
are likely to be affected. In case the MSI enablement fails, try to
continue in hope that the probe might still somehow work out, but warn
the user about this.

Signed-off-by: Marek Vasut <marex@denx.de>
---
Note that the "PCI-E x0, Bandwidth Usage: UnKnown Gbps" is due to QEMU
     vfio-pci VT-d passthrough, for some reason this is what it reports.
     The issue with PCI MSI happens on real hardware too, this vfio/VT-d
     is just debugging convenience.
Note that this would be nice to have in stable series, but I'm reluctant
     to ask for that in order to avoid breaking other peoples' machines.
     Maybe a default-off kernel parameter for the mvsas module would be
     acceptable for stable?
---
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: Jason Yan <yanaijie@huawei.com>
Cc: John Garry <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
---
V2: - Limit the MSI enablement to OCZ devices only
---
 drivers/scsi/mvsas/mv_init.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index 43ebb331e2167..d3b1cee6b3252 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -571,6 +571,17 @@ static int mvs_pci_init(struct pci_dev *pdev, const struct pci_device_id *ent)
 	rc = sas_register_ha(SHOST_TO_SAS_HA(shost));
 	if (rc)
 		goto err_out_shost;
+
+	/* Try to enable MSI, this is needed at least on OCZ RevoDrive 3 X2 */
+	if (pdev->vendor == PCI_VENDOR_ID_OCZ) {
+		rc = pci_enable_msi(mvi->pdev);
+		if (rc) {
+			dev_err(&mvi->pdev->dev,
+				"mvsas: Failed to enable MSI for OCZ device, attached drives may not be detected. rc=%d\n",
+				rc);
+		}
+	}
+
 	rc = request_irq(pdev->irq, irq_handler, IRQF_SHARED,
 		DRV_NAME, SHOST_TO_SAS_HA(shost));
 	if (rc)
@@ -583,6 +594,9 @@ static int mvs_pci_init(struct pci_dev *pdev, const struct pci_device_id *ent)
 	return 0;
 
 err_not_sas:
+	if (pdev->vendor == PCI_VENDOR_ID_OCZ)
+		pci_disable_msi(mvi->pdev);
+
 	sas_unregister_ha(SHOST_TO_SAS_HA(shost));
 err_out_shost:
 	scsi_remove_host(mvi->shost);
@@ -607,6 +621,9 @@ static void mvs_pci_remove(struct pci_dev *pdev)
 	tasklet_kill(&((struct mvs_prv_info *)sha->lldd_ha)->mv_tasklet);
 #endif
 
+	if (pdev->vendor == PCI_VENDOR_ID_OCZ)
+		pci_disable_msi(mvi->pdev);
+
 	sas_unregister_ha(sha);
 	sas_remove_host(mvi->shost);
 
-- 
2.42.0

