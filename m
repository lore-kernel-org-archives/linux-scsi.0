From: Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH 3/3] [SCSI] megaraid: Remove 64-bit DMA related dead code
Date: Fri, 07 Jun 2013 10:23:47 -0600
Message-ID: <20130607162347.11205.68121.stgit@amt.stowe>
References: <20130607162329.11205.95093.stgit@amt.stowe>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130607162329.11205.95093.stgit@amt.stowe>
Sender: linux-kernel-owner@vger.kernel.org
To: megaraidlinux@lsi.com, JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

With the driver now setup for default 32-bit DMA capabilities, remove the
64-bit DMA related dead code.

Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
---

 drivers/scsi/megaraid.c |   45 +++++++++------------------------------------
 drivers/scsi/megaraid.h |    1 -
 2 files changed, 9 insertions(+), 37 deletions(-)

diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 316924c..58953ab 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -713,12 +713,7 @@ mega_build_cmd(adapter_t *adapter, Scsi_Cmnd *cmd, int *busy)
 			pthru->cdblen = cmd->cmd_len;
 			memcpy(pthru->cdb, cmd->cmnd, cmd->cmd_len);
 
-			if( adapter->has_64bit_addr ) {
-				mbox->m_out.cmd = MEGA_MBOXCMD_PASSTHRU64;
-			}
-			else {
-				mbox->m_out.cmd = MEGA_MBOXCMD_PASSTHRU;
-			}
+			mbox->m_out.cmd = MEGA_MBOXCMD_PASSTHRU;
 
 			scb->dma_direction = PCI_DMA_FROMDEVICE;
 
@@ -750,16 +745,9 @@ mega_build_cmd(adapter_t *adapter, Scsi_Cmnd *cmd, int *busy)
 			 * A little hack: 2nd bit is zero for all scsi read
 			 * commands and is set for all scsi write commands
 			 */
-			if( adapter->has_64bit_addr ) {
-				mbox->m_out.cmd = (*cmd->cmnd & 0x02) ?
-					MEGA_MBOXCMD_LWRITE64:
-					MEGA_MBOXCMD_LREAD64 ;
-			}
-			else {
-				mbox->m_out.cmd = (*cmd->cmnd & 0x02) ?
-					MEGA_MBOXCMD_LWRITE:
-					MEGA_MBOXCMD_LREAD ;
-			}
+			mbox->m_out.cmd = (*cmd->cmnd & 0x02) ?
+				MEGA_MBOXCMD_LWRITE:
+				MEGA_MBOXCMD_LREAD ;
 
 			/*
 			 * 6-byte READ(0x08) or WRITE(0x0A) cdb
@@ -929,13 +917,7 @@ mega_build_cmd(adapter_t *adapter, Scsi_Cmnd *cmd, int *busy)
 					channel, target);
 
 			/* Initialize mailbox */
-			if( adapter->has_64bit_addr ) {
-				mbox->m_out.cmd = MEGA_MBOXCMD_PASSTHRU64;
-			}
-			else {
-				mbox->m_out.cmd = MEGA_MBOXCMD_PASSTHRU;
-			}
-
+			mbox->m_out.cmd = MEGA_MBOXCMD_PASSTHRU;
 			mbox->m_out.xferaddr = scb->pthru_dma_addr;
 
 		}
@@ -1763,7 +1745,7 @@ mega_build_sglist(adapter_t *adapter, scb_t *scb, u32 *buf, u32 *len)
 
 	*len = 0;
 
-	if (scsi_sg_count(cmd) == 1 && !adapter->has_64bit_addr) {
+	if (scsi_sg_count(cmd) == 1) {
 		sg = scsi_sglist(cmd);
 		scb->dma_h_bulkdata = sg_dma_address(sg);
 		*buf = (u32)scb->dma_h_bulkdata;
@@ -1772,13 +1754,8 @@ mega_build_sglist(adapter_t *adapter, scb_t *scb, u32 *buf, u32 *len)
 	}
 
 	scsi_for_each_sg(cmd, sg, sgcnt, idx) {
-		if (adapter->has_64bit_addr) {
-			scb->sgl64[idx].address = sg_dma_address(sg);
-			*len += scb->sgl64[idx].length = sg_dma_len(sg);
-		} else {
-			scb->sgl[idx].address = sg_dma_address(sg);
-			*len += scb->sgl[idx].length = sg_dma_len(sg);
-		}
+		scb->sgl[idx].address = sg_dma_address(sg);
+		*len += scb->sgl[idx].length = sg_dma_len(sg);
 	}
 
 	/* Reset pointer and length fields */
@@ -2076,10 +2053,7 @@ proc_show_config(struct seq_file *m, void *v)
 
 	if(adapter->flag & BOARD_64BIT)
 		seq_puts(m, "Controller capable of 64-bit memory addressing\n");
-	if( adapter->has_64bit_addr )
-		seq_puts(m, "Controller using 64-bit memory addressing\n");
-	else
-		seq_puts(m, "Controller is not using 64-bit memory addressing\n");
+	seq_puts(m, "Controller is not using 64-bit memory addressing\n");
 
 	seq_printf(m, "Base = %08lx, Irq = %d, ",
 		   adapter->base, adapter->host->irq);
@@ -4471,7 +4445,6 @@ megaraid_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	/* Set the Mode of addressing to 32 bit */
 	pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
-	adapter->has_64bit_addr = 0;
 		
 	mutex_init(&adapter->int_mtx);
 	init_completion(&adapter->int_waitq);
diff --git a/drivers/scsi/megaraid.h b/drivers/scsi/megaraid.h
index 4d0ce4e..17e449b 100644
--- a/drivers/scsi/megaraid.h
+++ b/drivers/scsi/megaraid.h
@@ -827,7 +827,6 @@ typedef struct {
 
 #endif
 
-	int	has_64bit_addr;		/* are we using 64-bit addressing */
 	int	support_ext_cdb;
 	int	boot_ldrv_enabled;
 	int	boot_ldrv;
