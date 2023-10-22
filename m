Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D55D1C00A8F
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Oct 2023 20:03:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232025AbjJVUDp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 22 Oct 2023 16:03:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjJVUDp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Oct 2023 16:03:45 -0400
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7041DF2
        for <linux-scsi@vger.kernel.org>; Sun, 22 Oct 2023 13:03:42 -0700 (PDT)
Received: from tr.lan (ip-86-49-120-218.bb.vodafone.cz [86.49.120.218])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 234758778F;
        Sun, 22 Oct 2023 22:03:37 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1698005018;
        bh=D9reWuKMocmpuD+3dxooQysK2sbJ8H3tQ6nzJYfvsLo=;
        h=From:To:Cc:Subject:Date:From;
        b=DGCHJ3WfMN3nWMPhjj/jjAYKv8XP8WjaAsVZVgRCRzzQVI5nWbhEHk/qLE5WflApy
         q4CSOa3ww4ftTdDq+oWJ+Fkvz9jM2TkrMngVTt9GdK7Y4h6Lky2z3tPjH22bCjAkfp
         ANsOsFZgplBAJ1OsF9/iWlPvOR6+3PwElzUhWRx+rYxoiDUyF10NCCuzIODl/nRhg0
         v4i6fE5VZocV2B2HIR85+SLdxlbEwmlmYIlDW+Nf7UTXQHUVzpmc9dd0/qg7KCS6j4
         2TC2lN3W5AOXomTQ3G52TwdUp2SoWEnceIzHh9hY17s3qfDWM7AGL4albZ4R4VG6Jj
         KzklHrR0MHIzw==
From:   Marek Vasut <marex@denx.de>
To:     linux-scsi@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        Jason Yan <yanaijie@huawei.com>,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH] [RFC] scsi: mvsas: Try to enable MSI
Date:   Sun, 22 Oct 2023 22:03:21 +0200
Message-ID: <20231022200329.60844-1-marex@denx.de>
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

I am not sure whether this is the correct fix, or whether this should
be a controller specific quirk instead, considering how this is likely
a legacy controller driver.

The enablement of MSIs has been part of this driver before, but was
removed without any real explanation in commit:
20b09c2992fe ("[SCSI] mvsas: add support for 94xx; layout change; bug fixes")
The enablement of MSIs is also part of the 'oczpcie' driver, which is
really an ancient fork of this driver with a lot of variable renames
and such.

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
 drivers/scsi/mvsas/mv_init.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index 43ebb331e2167..6850e39237d3e 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -571,6 +571,8 @@ static int mvs_pci_init(struct pci_dev *pdev, const struct pci_device_id *ent)
 	rc = sas_register_ha(SHOST_TO_SAS_HA(shost));
 	if (rc)
 		goto err_out_shost;
+	/* Try to enable MSI, this is needed at least on OCZ RevoDrive 3 X2 */
+	pci_enable_msi(pdev);
 	rc = request_irq(pdev->irq, irq_handler, IRQF_SHARED,
 		DRV_NAME, SHOST_TO_SAS_HA(shost));
 	if (rc)
@@ -583,6 +585,7 @@ static int mvs_pci_init(struct pci_dev *pdev, const struct pci_device_id *ent)
 	return 0;
 
 err_not_sas:
+	pci_disable_msi(pdev);
 	sas_unregister_ha(SHOST_TO_SAS_HA(shost));
 err_out_shost:
 	scsi_remove_host(mvi->shost);
@@ -607,6 +610,7 @@ static void mvs_pci_remove(struct pci_dev *pdev)
 	tasklet_kill(&((struct mvs_prv_info *)sha->lldd_ha)->mv_tasklet);
 #endif
 
+	pci_disable_msi(pdev);
 	sas_unregister_ha(sha);
 	sas_remove_host(mvi->shost);
 
-- 
2.42.0

