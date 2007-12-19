From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [GIT PATCH] SCSI bug fixes for 2.6.24-rc5
Date: Wed, 19 Dec 2007 09:14:30 -0600
Message-ID: <1198077270.5487.5.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:58197 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758045AbXLSPOd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Dec 2007 10:14:33 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This patch series is a sequence of late arriving bug fixes, mainly in
drivers but also one debugging scatterlist BUG_ON() in the tape ULD.
The initio bug fixes are definitely required, we just don't have
confirmation that they're the whole fix yet, so an additional fix for
initio may be necessary.

The patch is available at:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git

The short changelog is:

Alan Cox (1):
      initio: fix conflict when loading driver

Boaz Harrosh (1):
      initio: bugfix for accessors patch

FUJITA Tomonori (1):
      st: fix kernel BUG at include/linux/scatterlist.h:59!

James Bottomley (1):
      dpt_i2o: driver is only 32 bit so don't set 64 bit DMA mask

Tony Battersby (2):
      sym53c8xx: fix "irq X: nobody cared" regression
      sym53c8xx: fix free_irq() regression

The diffstat:

 dpt_i2o.c              |    3 +--
 initio.c               |    2 ++
 st.c                   |    1 +
 sym53c8xx_2/sym_glue.c |    2 +-
 sym53c8xx_2/sym_hipd.c |    2 +-
 5 files changed, 6 insertions(+), 4 deletions(-)

The complete patch is attached below.

James

---

diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index 70f48a1..b31d1c9 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -906,8 +906,7 @@ static int adpt_install_hba(struct scsi_host_template* sht, struct pci_dev* pDev
 	}
 
 	pci_set_master(pDev);
-	if (pci_set_dma_mask(pDev, DMA_64BIT_MASK) &&
-	    pci_set_dma_mask(pDev, DMA_32BIT_MASK))
+	if (pci_set_dma_mask(pDev, DMA_32BIT_MASK))
 		return -EINVAL;
 
 	base_addr0_phys = pci_resource_start(pDev,0);
diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
index 4c4465d..01bf018 100644
--- a/drivers/scsi/initio.c
+++ b/drivers/scsi/initio.c
@@ -2616,6 +2616,7 @@ static void initio_build_scb(struct initio_host * host, struct scsi_ctrl_blk * c
 		scsi_for_each_sg(cmnd, sglist, cblk->sglen, i) {
 			sg->data = cpu_to_le32((u32)sg_dma_address(sglist));
 			total_len += sg->len = cpu_to_le32((u32)sg_dma_len(sglist));
+			++sg;
 		}
 
 		cblk->buflen = (scsi_bufflen(cmnd) > total_len) ?
@@ -2867,6 +2868,7 @@ static int initio_probe_one(struct pci_dev *pdev,
 	}
 	host = (struct initio_host *)shost->hostdata;
 	memset(host, 0, sizeof(struct initio_host));
+	host->addr = pci_resource_start(pdev, 0);
 
 	if (!request_region(host->addr, 256, "i91u")) {
 		printk(KERN_WARNING "initio: I/O port range 0x%x is busy.\n", host->addr);
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 98dfd6e..328c47c 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -3611,6 +3611,7 @@ static struct st_buffer *
 
 	tb->dma = need_dma;
 	tb->buffer_size = got;
+	sg_init_table(tb->sg, max_sg);
 
 	return tb;
 }
diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index 0f74aba..9e0908d 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -1243,7 +1243,7 @@ static void sym_free_resources(struct sym_hcb *np, struct pci_dev *pdev)
 	 *  Free O/S specific resources.
 	 */
 	if (pdev->irq)
-		free_irq(pdev->irq, np);
+		free_irq(pdev->irq, np->s.host);
 	if (np->s.ioaddr)
 		pci_iounmap(pdev, np->s.ioaddr);
 	if (np->s.ramaddr)
diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.c b/drivers/scsi/sym53c8xx_2/sym_hipd.c
index 463f119..254bdae 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.c
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.c
@@ -2791,7 +2791,7 @@ irqreturn_t sym_interrupt(struct Scsi_Host *shost)
 	istat = INB(np, nc_istat);
 	if (istat & INTF) {
 		OUTB(np, nc_istat, (istat & SIGP) | INTF | np->istat_sem);
-		istat = INB(np, nc_istat);		/* DUMMY READ */
+		istat |= INB(np, nc_istat);		/* DUMMY READ */
 		if (DEBUG_FLAGS & DEBUG_TINY) printf ("F ");
 		sym_wakeup_done(np);
 	}


