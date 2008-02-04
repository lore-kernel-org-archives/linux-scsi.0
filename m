From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 20/24][RFC] u14-34f: Use of scsi_make_sense() API for DMA-able sense buffer
Date: Mon,  4 Feb 2008 19:49:30 +0200
Message-ID: <1202147370-5372-1-git-send-email-bharrosh@panasas.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:57515 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458AbYBDRys (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Feb 2008 12:54:48 -0500
In-Reply-To: 47A72A7F.1050301@panasas.com
References: 47A72A7F.1050301@panasas.com
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <jens.axboe@oracle.com>J
Cc: Andrew Morton <akpm@linux-foundation.org>

  - Use a pre allocated, DMA mapped, sense buffer at each command,
    Using the scsi_make_sense() API. And scsi_return_sense() when
    done.
  - Set .pre_allocate_sense && .sense_buffsize at host template.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/u14-34f.c |   22 ++++++++++++++--------
 1 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/u14-34f.c b/drivers/scsi/u14-34f.c
index 662c004..ec66899 100644
--- a/drivers/scsi/u14-34f.c
+++ b/drivers/scsi/u14-34f.c
@@ -429,6 +429,7 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_tcq.h>
 #include <scsi/scsicam.h>
+#include <scsi/scsi_eh.h>
 
 static int u14_34f_detect(struct scsi_host_template *);
 static int u14_34f_release(struct Scsi_Host *);
@@ -451,6 +452,8 @@ static struct scsi_host_template driver_template = {
                 .this_id                 = 7,
                 .unchecked_isa_dma       = 1,
                 .use_clustering          = ENABLE_CLUSTERING,
+		.pre_allocate_sense      = 1,
+		.sense_buffsize          = SCSI_SENSE_BUFFERSIZE,
                 };
 
 #if !defined(__BIG_ENDIAN_BITFIELD) && !defined(__LITTLE_ENDIAN_BITFIELD)
@@ -577,6 +580,7 @@ struct mscp {
 
    /* Additional fields begin here. */
    struct scsi_cmnd *SCpnt;
+   u8 *sense_buffer;
    unsigned int cpp_index;              /* cp index */
 
    /* All the cp structure is zero filled by queuecommand except the
@@ -1118,8 +1122,9 @@ static void map_dma(unsigned int i, unsigned int j) {
    cpp = &HD(j)->cp[i]; SCpnt = cpp->SCpnt;
    pci_dir = SCpnt->sc_data_direction;
 
-   if (SCpnt->sense_buffer)
-      cpp->sense_addr = H2DEV(pci_map_single(HD(j)->pdev, SCpnt->sense_buffer,
+   cpp->sense_buffer = scsi_make_sense(SCpnt);
+   BUG_ON(!cpp->sense_buffer);
+   cpp->sense_addr = H2DEV(pci_map_single(HD(j)->pdev, cpp->sense_buffer,
                            SCSI_SENSE_BUFFERSIZE, PCI_DMA_FROMDEVICE));
 
    cpp->sense_len = SCSI_SENSE_BUFFERSIZE;
@@ -1144,7 +1149,7 @@ static void map_dma(unsigned int i, unsigned int j) {
 
    } else {
 	   pci_dir = PCI_DMA_BIDIRECTIONAL;
-	   cpp->data_len = H2DEV(scsi_bufflen(SCpnt));
+	   cpp->data_len = 0;
    }
 }
 
@@ -1156,9 +1161,9 @@ static void unmap_dma(unsigned int i, unsigned int j) {
    cpp = &HD(j)->cp[i]; SCpnt = cpp->SCpnt;
    pci_dir = SCpnt->sc_data_direction;
 
-   if (DEV2H(cpp->sense_addr))
-      pci_unmap_single(HD(j)->pdev, DEV2H(cpp->sense_addr),
+   pci_unmap_single(HD(j)->pdev, DEV2H(cpp->sense_addr),
                        DEV2H(cpp->sense_len), PCI_DMA_FROMDEVICE);
+   scsi_return_sense(SCpnt, cpp->sense_buffer);
 
    scsi_dma_unmap(SCpnt);
 
@@ -1298,6 +1303,7 @@ static int u14_34f_queuecommand(struct scsi_cmnd *SCpnt, void (*done)(struct scs
    /* Use data transfer direction SCpnt->sc_data_direction */
    scsi_to_dev_dir(i, j);
 
+   /* FIXME:map_dma can fail */
    /* Map DMA buffers and SG list */
    map_dma(i, j);
 
@@ -1821,7 +1827,7 @@ static irqreturn_t ihdlr(int irq, unsigned int j) {
          /* Works around a flaw in scsi.c */
          else if (tstatus == CHECK_CONDITION
                   && SCpnt->device->type == TYPE_DISK
-                  && (SCpnt->sense_buffer[2] & 0xf) == RECOVERED_ERROR)
+                  && (spp->sense_buffer[2] & 0xf) == RECOVERED_ERROR)
             status = DID_BUS_BUSY << 16;
 
          else
@@ -1832,11 +1838,11 @@ static irqreturn_t ihdlr(int irq, unsigned int j) {
 
          if (spp->target_status && SCpnt->device->type == TYPE_DISK &&
              (!(tstatus == CHECK_CONDITION && HD(j)->iocount <= 1000 &&
-               (SCpnt->sense_buffer[2] & 0xf) == NOT_READY)))
+               (spp->sense_buffer[2] & 0xf) == NOT_READY)))
             scmd_printk(KERN_INFO, SCpnt,
 	    	"ihdlr, pid %ld, target_status 0x%x, sense key 0x%x.\n",
                    SCpnt->serial_number, spp->target_status,
-                   SCpnt->sense_buffer[2]);
+                   spp->sense_buffer[2]);
 
          HD(j)->target_to[scmd_id(SCpnt)][scmd_channel(SCpnt)] = 0;
 
-- 
1.5.3.3

