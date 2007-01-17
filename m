From: Tejun Heo <htejun@gmail.com>
Subject: [PATCH] libata: initialize qc->dma_dir to DMA_NONE
Date: Wed, 17 Jan 2007 11:34:02 +0900
Message-ID: <20070117023402.GP10987@htj.dyndns.org>
References: <45AD50AD.2040700@linux.vnet.ibm.com> <20070116224115.50d29cf7@localhost.localdomain> <45AD55A4.50208@pobox.com> <1168989094.2789.20.camel@mulgrave.il.steeleye.com> <45AD5D27.8020004@linux.vnet.ibm.com> <45AD60B9.3030501@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <45AD60B9.3030501@linux.vnet.ibm.com>
Sender: linux-ide-owner@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@SteelEye.com>, Alan <alan@lxorguk.ukuu.org.uk>, linux-scsi@vger.kernel.org, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

libata didn't used to init qc->dma_dir to any specific value on qc
initialization and command translation path didn't set qc->dma_dir if
the command doesn't need data transfer.  This made non-data commands
to have random qc->dma_dir.

This usually doesn't cause problem because LLDs usually check
qc->protocol first and look at qc->dma_dir iff the command needs data
transfer but this doesn't hold for all LLDs.

It might be worthwhile to rename qc->dma_dir to qc->data_dir as we use
the field to tag data direction for both PIO and DMA protocols.

This problem has been spotted by James Bottomley.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>

diff --git a/include/linux/libata.h b/include/linux/libata.h
index 7cfc18f..925ad7f 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1139,6 +1139,7 @@ static inline void ata_tf_init(struct ata_device *dev, struct ata_taskfile *tf)
 
 static inline void ata_qc_reinit(struct ata_queued_cmd *qc)
 {
+	qc->dma_dir = DMA_NONE;
 	qc->__sg = NULL;
 	qc->flags = 0;
 	qc->cursect = qc->cursg = qc->cursg_ofs = 0;
