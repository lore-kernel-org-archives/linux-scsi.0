From: Anton Blanchard <anton@samba.org>
Subject: [PATCH] ibmvscsi: Fix oops when an interrupt is pending during
 probe
Date: Tue, 13 Jul 2010 14:59:29 +1000
Message-ID: <20100713045929.GB10155@kryten>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:40357 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751004Ab0GMFDK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Jul 2010 01:03:10 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, tj@kernel.org, brking@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org


A driver needs to be ready to take an interrupt as soon as it registers
an interrupt handler. I noticed the following oops when testing kdump:

ipr: IBM Power RAID SCSI Device Driver version: 2.5.0 (February 11, 2010)
ibmvscsi 30000002: SRP_VERSION: 16.a
ibmvscsi 30000002: SRP_VERSION: 16.a
Unable to handle kernel paging request for data at address 0x00000000
...
pc: c000000004085e34: .tasklet_action+0xf4/0x1dc
...
c000000004086fe4 .__do_softirq+0x16c/0x2c0
c00000000403138c .call_do_softirq+0x14/0x24
c00000000400ee14 .do_softirq+0xa0/0x104
c00000000408690c .irq_exit+0x70/0xd0
c00000000400f190 .do_IRQ+0x214/0x2a8
c000000004004804 hardware_interrupt_entry+0x1c/0x98
--- Exception: 501 (Hardware Interrupt) at c00000000400c544 .raw_local_irq_restore+0x48/0x54
c00000000465d2a8 ._raw_spin_unlock_irqrestore+0x74/0xa0
c0000000040e7f00 .__setup_irq+0x2ec/0x3f0
c0000000040e8198 .request_threaded_irq+0x194/0x22c
c00000000446d854 .rpavscsi_init_crq_queue+0x284/0x3f0
c00000000446c764 .ibmvscsi_probe+0x688/0x710
c00000000402903c .vio_bus_probe+0x37c/0x3e4
c000000004403f10 .driver_probe_device+0xec/0x1b8
c000000004404088 .__driver_attach+0xac/0xf4
c000000004403184 .bus_for_each_dev+0x98/0x104
c000000004403c98 .driver_attach+0x40/0x60
c0000000044026f0 .bus_add_driver+0x154/0x324
c0000000044045d0 .driver_register+0xe8/0x1ac
c00000000402b2a8 .vio_register_driver+0x54/0x74
c000000004933ea4 .ibmvscsi_module_init+0x80/0xc0
c000000004009834 .do_one_initcall+0x98/0x1d8
c0000000049005b4 .kernel_init+0x27c/0x33c
c000000004031550 .kernel_thread+0x54/0x70

srp_task needs to be setup before request_irq. The patch below fixes the oops.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

diff --git a/drivers/scsi/ibmvscsi/rpa_vscsi.c b/drivers/scsi/ibmvscsi/rpa_vscsi.c
index a864ccc..989b9a8 100644
--- a/drivers/scsi/ibmvscsi/rpa_vscsi.c
+++ b/drivers/scsi/ibmvscsi/rpa_vscsi.c
@@ -277,6 +277,12 @@ static int rpavscsi_init_crq_queue(struct crq_queue *queue,
 		goto reg_crq_failed;
 	}
 
+	queue->cur = 0;
+	spin_lock_init(&queue->lock);
+
+	tasklet_init(&hostdata->srp_task, (void *)rpavscsi_task,
+		     (unsigned long)hostdata);
+
 	if (request_irq(vdev->irq,
 			rpavscsi_handle_event,
 			0, "ibmvscsi", (void *)hostdata) != 0) {
@@ -291,15 +297,10 @@ static int rpavscsi_init_crq_queue(struct crq_queue *queue,
 		goto req_irq_failed;
 	}
 
-	queue->cur = 0;
-	spin_lock_init(&queue->lock);
-
-	tasklet_init(&hostdata->srp_task, (void *)rpavscsi_task,
-		     (unsigned long)hostdata);
-
 	return retrc;
 
       req_irq_failed:
+	tasklet_kill(&hostdata->srp_task);
 	do {
 		rc = plpar_hcall_norets(H_FREE_CRQ, vdev->unit_address);
 	} while ((rc == H_BUSY) || (H_IS_LONG_BUSY(rc)));
