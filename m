From: Martin Wilck <mwilck@suse.de>
Subject: [PATCH 2/2] hpsa: destroy sas transport properties before scsi_host
Date: Mon, 21 Nov 2016 15:04:29 +0100
Message-ID: <20161121140429.12788-3-mwilck@suse.de>
References: <20161121140429.12788-1-mwilck@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35711 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753176AbcKUOE6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 21 Nov 2016 09:04:58 -0500
In-Reply-To: <20161121140429.12788-1-mwilck@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: don.brace@pmcs.com
Cc: storagedev@pmcs.com, iss_storagedev@hp.com, linux-scsi@vger.kernel.org, JBottomley@odin.com, hch@lst.de, hare@suse.de, Martin Wilck <mwilck@suse.de>

Unloading the hpsa driver causes warnings

[ 1063.793652] WARNING: CPU: 1 PID: 4850 at ../fs/sysfs/group.c:237 device_del+0x54/0x240()
[ 1063.793659] sysfs group ffffffff81cf21a0 not found for kobject 'port-2:0'

with two different stacks:
1)
[ 1063.793774]  [<ffffffff81448af4>] device_del+0x54/0x240
[ 1063.793780]  [<ffffffff8145178a>] transport_remove_classdev+0x4a/0x60
[ 1063.793784]  [<ffffffff81451216>] attribute_container_device_trigger+0xa6/0xb0
[ 1063.793802]  [<ffffffffa0105d46>] sas_port_delete+0x126/0x160 [scsi_transport_sas]
[ 1063.793819]  [<ffffffffa036ebcc>] hpsa_free_sas_port+0x3c/0x70 [hpsa]

2)
[ 1063.797103]  [<ffffffff81448af4>] device_del+0x54/0x240
[ 1063.797118]  [<ffffffffa0105d4e>] sas_port_delete+0x12e/0x160 [scsi_transport_sas]
[ 1063.797134]  [<ffffffffa036ebcc>] hpsa_free_sas_port+0x3c/0x70 [hpsa]

This is caused by the fact that host device hostX is deleted before the
SAS transport devices hostX/port-a:b.

This patch fixes this by reverting the order of device deletions.

References: bsc#1010946
Signed-off-by: Martin Wilck <mwilck@suse.de>
---
 drivers/scsi/hpsa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 8ec77c3..f23f680 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -9020,6 +9020,7 @@ static void hpsa_remove_one(struct pci_dev *pdev)
 	destroy_workqueue(h->rescan_ctlr_wq);
 	destroy_workqueue(h->resubmit_wq);
 
+	hpsa_delete_sas_host(h);
 	/*
 	 * Call before disabling interrupts.
 	 * scsi_remove_host can trigger I/O operations especially
@@ -9054,7 +9055,6 @@ static void hpsa_remove_one(struct pci_dev *pdev)
 	h->lockup_detected = NULL;			/* init_one 2 */
 	/* (void) pci_disable_pcie_error_reporting(pdev); */	/* init_one 1 */
 
-	hpsa_delete_sas_host(h);
 
 	kfree(h);					/* init_one 1 */
 }
-- 
2.10.1

