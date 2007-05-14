From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 0/19] clean ups on the drivers
Date: Tue, 15 May 2007 07:36:18 +0900 (JST)
Message-ID: <20070514200856O.fujita.tomonori@lab.ntt.co.jp>
References: <20070512153023.GA8088@infradead.org>
	<200705141440.l4EEe3dB004194@mbox.iij4u.or.jp>
	<4648829A.10602@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:58048 "EHLO
	tama55.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755362AbXENWhN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 May 2007 18:37:13 -0400
In-Reply-To: <4648829A.10602@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: stefanr@s5r6.in-berlin.de
Cc: fujita.tomonori@lab.ntt.co.jp, hch@infradead.org, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, jens.axboe@oracle.com

From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 0/19] clean ups on the drivers
Date: Mon, 14 May 2007 17:39:06 +0200

> FUJITA Tomonori wrote:
> >> > There are two patches for each driver, removing the non-use-sg code
> >> > and converting to use the accessors.
> ...
> > I merged the two. And I finished cleaning up 35 drivers in total.
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/tomo/linux-2.6-bidi.git cleanups
> 
> According to what I see via gitweb, at least usb-storage, ieee1394/sbp2,
> and firewire/fw-sbp2 weren't treated yet.  If somebody does so for the
> latter two:  The shost->shost_gendev.parent has to be changed for
> scsi_dma_{un}map.  I don't know if this can be done without breaking
> anything.

The drivers don't need to use scsi_dma_{un}map. For example, iscsi_tcp
(doesn't need dma mappings), ib_iser and ib_srp (the ib stack provides
something like scsi_dmap_{un}map) don't use them.

Here's a patch for ieee1394/sbp2, which does the minimum requirement,
which kills the non-use-sg case and use scsi_sg_count and scsi_sglist
macros.


>From 07037aac7f5b0a14158a44370e0306f95d9dfcdd Mon Sep 17 00:00:00 2001
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date: Mon, 14 May 2007 20:00:04 +0900
Subject: [PATCH] ieee1394/sbp2: convert to use the data buffer accessors

- remove the unnecessary map_single path.

- convert to use the new accessors for the sg lists and the
parameters.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/ieee1394/sbp2.c |   75 ++--------------------------------------------
 1 files changed, 4 insertions(+), 71 deletions(-)

diff --git a/drivers/ieee1394/sbp2.c b/drivers/ieee1394/sbp2.c
index 4cb6fa2..d0db6f8 100644
--- a/drivers/ieee1394/sbp2.c
+++ b/drivers/ieee1394/sbp2.c
@@ -1488,69 +1488,6 @@ static void sbp2_prep_command_orb_sg(struct sbp2_command_orb *orb,
 	}
 }
 
-static void sbp2_prep_command_orb_no_sg(struct sbp2_command_orb *orb,
-					struct sbp2_fwhost_info *hi,
-					struct sbp2_command_info *cmd,
-					struct scatterlist *sgpnt,
-					u32 orb_direction,
-					unsigned int scsi_request_bufflen,
-					void *scsi_request_buffer,
-					enum dma_data_direction dma_dir)
-{
-	cmd->dma_dir = dma_dir;
-	cmd->dma_size = scsi_request_bufflen;
-	cmd->dma_type = CMD_DMA_SINGLE;
-	cmd->cmd_dma = dma_map_single(hi->host->device.parent,
-				      scsi_request_buffer,
-				      cmd->dma_size, cmd->dma_dir);
-	orb->data_descriptor_hi = ORB_SET_NODE_ID(hi->host->node_id);
-	orb->misc |= ORB_SET_DIRECTION(orb_direction);
-
-	/* handle case where we get a command w/o s/g enabled
-	 * (but check for transfers larger than 64K) */
-	if (scsi_request_bufflen <= SBP2_MAX_SG_ELEMENT_LENGTH) {
-
-		orb->data_descriptor_lo = cmd->cmd_dma;
-		orb->misc |= ORB_SET_DATA_SIZE(scsi_request_bufflen);
-
-	} else {
-		/* The buffer is too large. Turn this into page tables. */
-
-		struct sbp2_unrestricted_page_table *sg_element =
-						&cmd->scatter_gather_element[0];
-		u32 sg_count, sg_len;
-		dma_addr_t sg_addr;
-
-		orb->data_descriptor_lo = cmd->sge_dma;
-		orb->misc |= ORB_SET_PAGE_TABLE_PRESENT(0x1);
-
-		/* fill out our SBP-2 page tables; split up the large buffer */
-		sg_count = 0;
-		sg_len = scsi_request_bufflen;
-		sg_addr = cmd->cmd_dma;
-		while (sg_len) {
-			sg_element[sg_count].segment_base_lo = sg_addr;
-			if (sg_len > SBP2_MAX_SG_ELEMENT_LENGTH) {
-				sg_element[sg_count].length_segment_base_hi =
-					PAGE_TABLE_SET_SEGMENT_LENGTH(SBP2_MAX_SG_ELEMENT_LENGTH);
-				sg_addr += SBP2_MAX_SG_ELEMENT_LENGTH;
-				sg_len -= SBP2_MAX_SG_ELEMENT_LENGTH;
-			} else {
-				sg_element[sg_count].length_segment_base_hi =
-					PAGE_TABLE_SET_SEGMENT_LENGTH(sg_len);
-				sg_len = 0;
-			}
-			sg_count++;
-		}
-
-		orb->misc |= ORB_SET_DATA_SIZE(sg_count);
-
-		sbp2util_cpu_to_be32_buffer(sg_element,
-				(sizeof(struct sbp2_unrestricted_page_table)) *
-				sg_count);
-	}
-}
-
 static void sbp2_create_command_orb(struct sbp2_lu *lu,
 				    struct sbp2_command_info *cmd,
 				    unchar *scsi_cmd,
@@ -1594,13 +1531,9 @@ static void sbp2_create_command_orb(struct sbp2_lu *lu,
 		orb->data_descriptor_hi = 0x0;
 		orb->data_descriptor_lo = 0x0;
 		orb->misc |= ORB_SET_DIRECTION(1);
-	} else if (scsi_use_sg)
+	} else
 		sbp2_prep_command_orb_sg(orb, hi, cmd, scsi_use_sg, sgpnt,
 					 orb_direction, dma_dir);
-	else
-		sbp2_prep_command_orb_no_sg(orb, hi, cmd, sgpnt, orb_direction,
-					    scsi_request_bufflen,
-					    scsi_request_buffer, dma_dir);
 
 	sbp2util_cpu_to_be32_buffer(orb, sizeof(*orb));
 
@@ -1689,15 +1622,15 @@ static int sbp2_send_command(struct sbp2_lu *lu, struct scsi_cmnd *SCpnt,
 			     void (*done)(struct scsi_cmnd *))
 {
 	unchar *scsi_cmd = (unchar *)SCpnt->cmnd;
-	unsigned int request_bufflen = SCpnt->request_bufflen;
+	unsigned int request_bufflen = scsi_bufflen(SCpnt);
 	struct sbp2_command_info *cmd;
 
 	cmd = sbp2util_allocate_command_orb(lu, SCpnt, done);
 	if (!cmd)
 		return -EIO;
 
-	sbp2_create_command_orb(lu, cmd, scsi_cmd, SCpnt->use_sg,
-				request_bufflen, SCpnt->request_buffer,
+	sbp2_create_command_orb(lu, cmd, scsi_cmd, scsi_sg_count(SCpnt),
+				request_bufflen, scsi_sglist(SCpnt),
 				SCpnt->sc_data_direction);
 	sbp2_link_orb_command(lu, cmd);
 
-- 
1.4.4.3

