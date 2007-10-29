From: Brian King <brking@linux.vnet.ibm.com>
Subject: [RFC 1/3] [SCSI/libata] libata EH conversion for ipr SAS
Date: Mon, 29 Oct 2007 15:18:30 -0500
Message-ID: <47264016.9060603@linux.vnet.ibm.com>
References: <47263F85.70908@linux.vnet.ibm.com>
Reply-To: brking@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:50768 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751795AbXJ2USn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Oct 2007 16:18:43 -0400
In-Reply-To: <47263F85.70908@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: brking@linux.vnet.ibm.com
Cc: "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@SteelEye.com>


Currently libata uses ap->dev when allocating DMA'able storage on
behalf of the LLDD, or when mapping DMA buffers. This dev struct
is also being used when allocating memory for the ata_port struct
and associated structures. This patch splits these two uses by adding
a dmadev pointer to the ata_port. This allows for ap->dev to be
any arbitrary struct device. This is to be used by the libata SAS
LLDDs. 

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 linux-2.6-bjking1/drivers/ata/libata-core.c |   13 ++++++++-----
 linux-2.6-bjking1/include/linux/libata.h    |    2 ++
 2 files changed, 10 insertions(+), 5 deletions(-)

diff -puN include/linux/libata.h~libata_dmadev include/linux/libata.h
--- linux-2.6/include/linux/libata.h~libata_dmadev	2007-10-29 11:31:39.000000000 -0500
+++ linux-2.6-bjking1/include/linux/libata.h	2007-10-29 11:41:53.000000000 -0500
@@ -391,6 +391,7 @@ struct ata_ioports {
 struct ata_host {
 	spinlock_t		lock;
 	struct device 		*dev;
+	struct device		*dmadev;
 	void __iomem * const	*iomap;
 	unsigned int		n_ports;
 	void			*private_data;
@@ -601,6 +602,7 @@ struct ata_port {
 	struct ata_port_stats	stats;
 	struct ata_host		*host;
 	struct device 		*dev;
+	struct device		*dmadev;
 
 	void			*port_task_data;
 	struct delayed_work	port_task;
diff -puN drivers/ata/libata-core.c~libata_dmadev drivers/ata/libata-core.c
--- linux-2.6/drivers/ata/libata-core.c~libata_dmadev	2007-10-29 11:31:39.000000000 -0500
+++ linux-2.6-bjking1/drivers/ata/libata-core.c	2007-10-29 11:31:39.000000000 -0500
@@ -4294,7 +4294,7 @@ void ata_sg_clean(struct ata_queued_cmd 
 
 	if (qc->flags & ATA_QCFLAG_SG) {
 		if (qc->n_elem)
-			dma_unmap_sg(ap->dev, sg, qc->n_elem, dir);
+			dma_unmap_sg(ap->dmadev, sg, qc->n_elem, dir);
 		/* restore last sg */
 		sg_last(sg, qc->orig_n_elem)->length += qc->pad_len;
 		if (pad_buf) {
@@ -4305,7 +4305,7 @@ void ata_sg_clean(struct ata_queued_cmd 
 		}
 	} else {
 		if (qc->n_elem)
-			dma_unmap_single(ap->dev,
+			dma_unmap_single(ap->dmadev,
 				sg_dma_address(&sg[0]), sg_dma_len(&sg[0]),
 				dir);
 		/* restore sg */
@@ -4631,7 +4631,7 @@ static int ata_sg_setup_one(struct ata_q
 		goto skip_map;
 	}
 
-	dma_address = dma_map_single(ap->dev, qc->buf_virt,
+	dma_address = dma_map_single(ap->dmadev, qc->buf_virt,
 				     sg->length, dir);
 	if (dma_mapping_error(dma_address)) {
 		/* restore sg */
@@ -4719,7 +4719,7 @@ static int ata_sg_setup(struct ata_queue
 	}
 
 	dir = qc->dma_dir;
-	n_elem = dma_map_sg(ap->dev, sg, pre_n_elem, dir);
+	n_elem = dma_map_sg(ap->dmadev, sg, pre_n_elem, dir);
 	if (n_elem < 1) {
 		/* restore last sg */
 		lsg->length += qc->pad_len;
@@ -6335,7 +6335,7 @@ void ata_host_resume(struct ata_host *ho
  */
 int ata_port_start(struct ata_port *ap)
 {
-	struct device *dev = ap->dev;
+	struct device *dev = ap->dmadev;
 	int rc;
 
 	ap->prd = dmam_alloc_coherent(dev, ATA_PRD_TBL_SZ, &ap->prd_dma,
@@ -6480,6 +6480,7 @@ struct ata_port *ata_port_alloc(struct a
 	ap->ctl = ATA_DEVCTL_OBS;
 	ap->host = host;
 	ap->dev = host->dev;
+	ap->dmadev = host->dmadev;
 	ap->last_ctl = 0xFF;
 
 #if defined(ATA_VERBOSE_DEBUG)
@@ -6589,6 +6590,7 @@ struct ata_host *ata_host_alloc(struct d
 
 	spin_lock_init(&host->lock);
 	host->dev = dev;
+	host->dmadev = dev;
 	host->n_ports = max_ports;
 
 	/* allocate ports bound to this host */
@@ -6732,6 +6734,7 @@ void ata_host_init(struct ata_host *host
 {
 	spin_lock_init(&host->lock);
 	host->dev = dev;
+	host->dmadev = dev;
 	host->flags = flags;
 	host->ops = ops;
 }
_
