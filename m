From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PATCH] SCSI bug fix for 2.6.24-rc8
Date: Wed, 23 Jan 2008 18:14:24 -0600
Message-ID: <1201133664.3110.114.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:52703 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752453AbYAXAOg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Jan 2008 19:14:36 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

Hopefully this should resolve the outstanding initio failures.

Patch is available here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git

Full patch attached.

James

---

From: Stuart Swales <stuart.swales@croftnuisk.co.uk>
Date: Wed, 23 Jan 2008 20:00:48 +0000
Subject: [SCSI] initio: fix module hangs on loading

I've verified (on my Initio 9100 with a DAT drive) that the
2.6.24-rc8-git6 initio module still hangs on loading.

These fixes (other than the printk) are needed to get the module to load
ok (and work correctly) with my adapter & tape drive.

a) printk cosmetic fix

b) cblk->sglen needs setting for later DMA I/O routines to use

c) host->bios_addr needs setting for debug output correctness

d) semaph & semaph_lock initialisation had got lost since 2.6.22

e) since 2.6.22 the bios data address was truncated to 16 bits (needs 20
when shifted left)

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/initio.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
index 01bf018..a10a5c7 100644
--- a/drivers/scsi/initio.c
+++ b/drivers/scsi/initio.c
@@ -823,7 +823,7 @@ static void initio_append_busy_scb(struct initio_host * host, struct scsi_ctrl_b
 {
 
 #if DEBUG_QUEUE
-	printk("append busy SCB %o; ", scbp);
+	printk("append busy SCB %p; ", scbp);
 #endif
 	if (scbp->tagmsg)
 		host->act_tags[scbp->target]++;
@@ -2609,6 +2609,7 @@ static void initio_build_scb(struct initio_host * host, struct scsi_ctrl_blk * c
 		cblk->bufptr = cpu_to_le32((u32)dma_addr);
 		cmnd->SCp.dma_handle = dma_addr;
 
+		cblk->sglen = nseg;
 
 		cblk->flags |= SCF_SG;	/* Turn on SG list flag       */
 		total_len = 0;
@@ -2869,6 +2870,7 @@ static int initio_probe_one(struct pci_dev *pdev,
 	host = (struct initio_host *)shost->hostdata;
 	memset(host, 0, sizeof(struct initio_host));
 	host->addr = pci_resource_start(pdev, 0);
+	host->bios_addr = bios_seg;
 
 	if (!request_region(host->addr, 256, "i91u")) {
 		printk(KERN_WARNING "initio: I/O port range 0x%x is busy.\n", host->addr);
@@ -2895,6 +2897,8 @@ static int initio_probe_one(struct pci_dev *pdev,
 
 	host->pci_dev = pdev;
 
+	host->semaph = 1;
+	spin_lock_init(&host->semaph_lock);
 	host->num_scbs = num_scb;
 	host->scb = scb;
 	host->next_pending = scb;
@@ -2911,7 +2915,7 @@ static int initio_probe_one(struct pci_dev *pdev,
 	host->last_avail = prev;
 	spin_lock_init(&host->avail_lock);
 
-	initio_init(host, phys_to_virt(bios_seg << 4));
+	initio_init(host, phys_to_virt(((u32)bios_seg << 4)));
 
 	host->jsstatus0 = 0;
 
-- 
1.5.3.7



