From: Adrian Bunk <bunk@kernel.org>
Subject: Re: 2.6.23-rc9 boot failure (megaraid?)
Date: Tue, 2 Oct 2007 20:15:18 +0200
Message-ID: <20071002181518.GC10852@stusta.de>
References: <Pine.LNX.4.64.0710021242510.6275@postal>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:58732 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752102AbXJBSOz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Oct 2007 14:14:55 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0710021242510.6275@postal>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Burton Windle <bwindle@fint.org>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Sumant Patro <sumant.patro@lsi.com>, James Bottomley <James.Bottomley@SteelEye.com>, megaraidlinux@lsi.com, linux-scsi@vger.kernel.org

Cc's added, the complete bug report is at
  http://lkml.org/lkml/2007/10/2/243

On Tue, Oct 02, 2007 at 12:48:26PM -0400, Burton Windle wrote:
> 2.6.23-rc9 fails to boot for me; 2.6.22.9 works fine.
>
> System is a Dell Poweredge with PERC 2/DC with RAID1 volume.
>...

Thanks for your report.

Diff'ing the dmesg's shows:

<--  snip  -->

 scsi0: scanning scsi channel 4 [P0] for physical devices.
 scsi0: scanning scsi channel 5 [P1] for physical devices.
 st: Version 20070203, fixed bufsize 32768, s/g segs 256
-sd 0:0:0:0: [sda] 17547264 512-byte hardware sectors (8984 MB)
+sd 0:0:0:0: [sda] Sector size 0 reported, assuming 512.
+sd 0:0:0:0: [sda] 1 512-byte hardware sectors (0 MB)
 sd 0:0:0:0: [sda] Write Protect is off
 sd 0:0:0:0: [sda] Asking for cache data failed
 sd 0:0:0:0: [sda] Assuming drive cache: write through
-sd 0:0:0:0: [sda] 17547264 512-byte hardware sectors (8984 MB)
+sd 0:0:0:0: [sda] Sector size 0 reported, assuming 512.
+sd 0:0:0:0: [sda] 1 512-byte hardware sectors (0 MB)
 sd 0:0:0:0: [sda] Write Protect is off
 sd 0:0:0:0: [sda] Asking for cache data failed
 sd 0:0:0:0: [sda] Assuming drive cache: write through
  sda: sda1
+ sda: p1 exceeds device capacity

<--  snip  -->

Does reverting the commit below fix the problem?

cu
Adrian


commit 3f6270ef76f2ce5c134615a470685d6c2a66c07e
Author: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date:   Mon May 14 20:17:27 2007 +0900

    [SCSI] megaraid_old: convert to use the data buffer accessors
    
    - remove the unnecessary map_single path.
    
    - convert to use the new accessors for the sg lists and the
    parameters.
    
    Jens Axboe <jens.axboe@oracle.com> did the for_each_sg cleanup.
    
    Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
    Acked-by: Sumant Patro <sumant.patro@lsi.com>
    Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>

diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 40ee07d..3907f67 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -523,10 +523,8 @@ mega_build_cmd(adapter_t *adapter, Scsi_Cmnd *cmd, int *busy)
 	/*
 	 * filter the internal and ioctl commands
 	 */
-	if((cmd->cmnd[0] == MEGA_INTERNAL_CMD)) {
-		return cmd->request_buffer;
-	}
-
+	if((cmd->cmnd[0] == MEGA_INTERNAL_CMD))
+		return (scb_t *)cmd->host_scribble;
 
 	/*
 	 * We know what channels our logical drives are on - mega_find_card()
@@ -657,22 +655,14 @@ mega_build_cmd(adapter_t *adapter, Scsi_Cmnd *cmd, int *busy)
 
 		case MODE_SENSE: {
 			char *buf;
+			struct scatterlist *sg;
 
-			if (cmd->use_sg) {
-				struct scatterlist *sg;
+			sg = scsi_sglist(cmd);
+			buf = kmap_atomic(sg->page, KM_IRQ0) + sg->offset;
 
-				sg = (struct scatterlist *)cmd->request_buffer;
-				buf = kmap_atomic(sg->page, KM_IRQ0) +
-					sg->offset;
-			} else
-				buf = cmd->request_buffer;
 			memset(buf, 0, cmd->cmnd[4]);
-			if (cmd->use_sg) {
-				struct scatterlist *sg;
+			kunmap_atomic(buf - sg->offset, KM_IRQ0);
 
-				sg = (struct scatterlist *)cmd->request_buffer;
-				kunmap_atomic(buf - sg->offset, KM_IRQ0);
-			}
 			cmd->result = (DID_OK << 16);
 			cmd->scsi_done(cmd);
 			return NULL;
@@ -1551,23 +1541,15 @@ mega_cmd_done(adapter_t *adapter, u8 completed[], int nstatus, int status)
 		islogical = adapter->logdrv_chan[cmd->device->channel];
 		if( cmd->cmnd[0] == INQUIRY && !islogical ) {
 
-			if( cmd->use_sg ) {
-				sgl = (struct scatterlist *)
-					cmd->request_buffer;
-
-				if( sgl->page ) {
-					c = *(unsigned char *)
+			sgl = scsi_sglist(cmd);
+			if( sgl->page ) {
+				c = *(unsigned char *)
 					page_address((&sgl[0])->page) +
 					(&sgl[0])->offset; 
-				}
-				else {
-					printk(KERN_WARNING
-						"megaraid: invalid sg.\n");
-					c = 0;
-				}
-			}
-			else {
-				c = *(u8 *)cmd->request_buffer;
+			} else {
+				printk(KERN_WARNING
+				       "megaraid: invalid sg.\n");
+				c = 0;
 			}
 
 			if(IS_RAID_CH(adapter, cmd->device->channel) &&
@@ -1704,30 +1686,14 @@ mega_rundoneq (adapter_t *adapter)
 static void
 mega_free_scb(adapter_t *adapter, scb_t *scb)
 {
-	unsigned long length;
-
 	switch( scb->dma_type ) {
 
 	case MEGA_DMA_TYPE_NONE:
 		break;
 
-	case MEGA_BULK_DATA:
-		if (scb->cmd->use_sg == 0)
-			length = scb->cmd->request_bufflen;
-		else {
-			struct scatterlist *sgl =
-				(struct scatterlist *)scb->cmd->request_buffer;
-			length = sgl->length;
-		}
-		pci_unmap_page(adapter->dev, scb->dma_h_bulkdata,
-			       length, scb->dma_direction);
-		break;
-
 	case MEGA_SGLIST:
-		pci_unmap_sg(adapter->dev, scb->cmd->request_buffer,
-			scb->cmd->use_sg, scb->dma_direction);
+		scsi_dma_unmap(scb->cmd);
 		break;
-
 	default:
 		break;
 	}
@@ -1767,80 +1733,33 @@ __mega_busywait_mbox (adapter_t *adapter)
 static int
 mega_build_sglist(adapter_t *adapter, scb_t *scb, u32 *buf, u32 *len)
 {
-	struct scatterlist	*sgl;
-	struct page	*page;
-	unsigned long	offset;
-	unsigned int	length;
+	struct scatterlist *sg;
 	Scsi_Cmnd	*cmd;
 	int	sgcnt;
 	int	idx;
 
 	cmd = scb->cmd;
 
-	/* Scatter-gather not used */
-	if( cmd->use_sg == 0 || (cmd->use_sg == 1 && 
-				 !adapter->has_64bit_addr)) {
-
-		if (cmd->use_sg == 0) {
-			page = virt_to_page(cmd->request_buffer);
-			offset = offset_in_page(cmd->request_buffer);
-			length = cmd->request_bufflen;
-		} else {
-			sgl = (struct scatterlist *)cmd->request_buffer;
-			page = sgl->page;
-			offset = sgl->offset;
-			length = sgl->length;
-		}
-
-		scb->dma_h_bulkdata = pci_map_page(adapter->dev,
-						  page, offset,
-						  length,
-						  scb->dma_direction);
-		scb->dma_type = MEGA_BULK_DATA;
-
-		/*
-		 * We need to handle special 64-bit commands that need a
-		 * minimum of 1 SG
-		 */
-		if( adapter->has_64bit_addr ) {
-			scb->sgl64[0].address = scb->dma_h_bulkdata;
-			scb->sgl64[0].length = length;
-			*buf = (u32)scb->sgl_dma_addr;
-			*len = (u32)length;
-			return 1;
-		}
-		else {
-			*buf = (u32)scb->dma_h_bulkdata;
-			*len = (u32)length;
-		}
-		return 0;
-	}
-
-	sgl = (struct scatterlist *)cmd->request_buffer;
-
 	/*
 	 * Copy Scatter-Gather list info into controller structure.
 	 *
 	 * The number of sg elements returned must not exceed our limit
 	 */
-	sgcnt = pci_map_sg(adapter->dev, sgl, cmd->use_sg,
-			scb->dma_direction);
+	sgcnt = scsi_dma_map(cmd);
 
 	scb->dma_type = MEGA_SGLIST;
 
-	BUG_ON(sgcnt > adapter->sglen);
+	BUG_ON(sgcnt > adapter->sglen || sgcnt < 0);
 
 	*len = 0;
 
-	for( idx = 0; idx < sgcnt; idx++, sgl++ ) {
-
-		if( adapter->has_64bit_addr ) {
-			scb->sgl64[idx].address = sg_dma_address(sgl);
-			*len += scb->sgl64[idx].length = sg_dma_len(sgl);
-		}
-		else {
-			scb->sgl[idx].address = sg_dma_address(sgl);
-			*len += scb->sgl[idx].length = sg_dma_len(sgl);
+	scsi_for_each_sg(cmd, sg, sgcnt, idx) {
+		if (adapter->has_64bit_addr) {
+			scb->sgl64[idx].address = sg_dma_address(sg);
+			*len += scb->sgl64[idx].length = sg_dma_len(sg);
+		} else {
+			scb->sgl[idx].address = sg_dma_address(sg);
+			*len += scb->sgl[idx].length = sg_dma_len(sg);
 		}
 	}
 
@@ -4494,7 +4413,7 @@ mega_internal_command(adapter_t *adapter, megacmd_t *mc, mega_passthru *pthru)
 	scmd->device = sdev;
 
 	scmd->device->host = adapter->host;
-	scmd->request_buffer = (void *)scb;
+	scmd->host_scribble = (void *)scb;
 	scmd->cmnd[0] = MEGA_INTERNAL_CMD;
 
 	scb->state |= SCB_ACTIVE;
