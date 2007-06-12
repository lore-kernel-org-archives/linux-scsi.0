From: Boaz Harrosh <bharrosh@panasas.com>
Subject: scsi_cmnd accessors issues
Date: Tue, 12 Jun 2007 21:02:20 +0300
Message-ID: <466EDFAC.9020104@panasas.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030803050905060302040501"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-e.panasas.com ([65.194.124.178]:52577 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755016AbXFLSCu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jun 2007 14:02:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Ed Lin <ed.lin@promise.com>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>

This is a multi-part message in MIME format.
--------------030803050905060302040501
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

2 things

[1]
There are 2 files (see attached patch) that use scsi_befflen() & scsi_sg_count() as
L-value. If I try the scsi_sgtable approach and do:

#define scsi_sg_count(cmd) ((cmd)->sg_table ? (cmd)->sg_table->sg_count : 0)
#define scsi_sglist(cmd) ((cmd)->sg_table ? (cmd)->sg_table->sglist : NULL)
#define scsi_bufflen(cmd) ((cmd)->sg_table ? (cmd)->sg_table->length : 0)

I get compilation errors. Attached solution is to add scsi_set_ accessors to these
members. But it would be best to STOP these drivers from doing that ugly hack of
modifying sg_count and bufflen.
(CC sign-off-by maintainers of the drivers in question. Files are
drivers/scsi/tmscsim.c & drivers/scsi/stex.c )

see: http://www.bhalevy.com/open-osd/download/sgtable_bidi_varlen/
     for the full bidi over scsi_sgtable solution

[2]
if I use __deprecated on request_buffer, request_bufflen, and use_sg with
scsi_sgtable implementation Than I get below list of files complaining:
drivers/ata/libata-scsi.c
drivers/firewire/fw-sbp2.c
drivers/infiniband/ulp/srp/ib_srp.c
drivers/message/i2o/i2o_scsi.c
drivers/scsi/aacraid/aachba.c
drivers/scsi/lpfc/lpfc_scsi.c
drivers/scsi/aha152x.c
drivers/scsi/pcmcia/nsp_cs.c
drivers/scsi/sym53c8xx_2/sym_glue.h
drivers/scsi/sym53c8xx_2/sym_glue.c
drivers/scsi/ncr53c8xx.c
drivers/scsi/sd.c
drivers/scsi/sr.c
drivers/scsi/advansys.c
drivers/scsi/psi240i.c
drivers/scsi/aha1542.c
drivers/scsi/ips.c
drivers/scsi/fd_mcs.c
drivers/scsi/in2000.c
drivers/scsi/NCR5380.c
drivers/scsi/qla1280.c
drivers/scsi/seagate.c
drivers/scsi/dc395x.c
drivers/scsi/atp870u.c
drivers/scsi/gdth.c
drivers/scsi/ide-scsi.c
drivers/scsi/ppa.c
drivers/scsi/imm.c
drivers/scsi/hptiop.c
drivers/usb/image/microtek.c
drivers/usb/storage/protocol.c
drivers/usb/storage/transport.c
drivers/usb/storage/shuttle_usbat.c
drivers/usb/storage/sddr09.c
drivers/usb/storage/freecom.c
drivers/usb/storage/isd200.c

and also these files from scsi-ml that need changing when implementation changes:
drivers/scsi/scsi.c
drivers/scsi/scsi_error.c
drivers/scsi/scsi_debug.c

(see: 0004-Convert-scsi-ml-to-use-of-new-scsi_sgtable.patch at scsi_cmnd.h)

Which of the files do you have pending patches for? Which do you need that I send
what I have for them?

Thanks
Boaz




--------------030803050905060302040501
Content-Type: text/plain;
 name="0003-Add-scsi_set_-accessors-to-bufflen-and-sg_count.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0003-Add-scsi_set_-accessors-to-bufflen-and-sg_count.patch"

>From 4f3c5a3b6dd6acb6240a52cecf52fc6787f625e8 Mon Sep 17 00:00:00 2001
From: Boaz Harrosh <bharrosh@bh-buildlin2.(none)>
Date: Mon, 11 Jun 2007 17:19:39 +0300
Subject: [PATCH] Add scsi_set_ accessors to bufflen and sg_count

 - drivers/scsi/stex.c && drivers/scsi/tmscsim.c modify bufflen and sg_count
   members from struct scsi_cmnd. This will not compile when in the future
   accessors are implemented over scsi_sgtable. So we add set_ accessors for these
   drivers to use.
 - It would be best if these drivers STOP modifying these members and this patch is
   reverted
---
 drivers/scsi/stex.c      |    4 ++--
 drivers/scsi/tmscsim.c   |    4 ++--
 include/scsi/scsi_cmnd.h |   10 ++++++++++
 3 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index adda296..4795d53 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -719,8 +719,8 @@ static void stex_ys_commands(struct st_hba *hba,
 
 	if (ccb->cmd->cmnd[0] == MGT_CMD &&
 		resp->scsi_status != SAM_STAT_CHECK_CONDITION) {
-		scsi_bufflen(ccb->cmd) =
-			le32_to_cpu(*(__le32 *)&resp->variable[0]);
+		scsi_set_bufflen(ccb->cmd,
+			le32_to_cpu(*(__le32 *)&resp->variable[0]));
 		return;
 	}
 
diff --git a/drivers/scsi/tmscsim.c b/drivers/scsi/tmscsim.c
index 73c5ca0..bfc718a 100644
--- a/drivers/scsi/tmscsim.c
+++ b/drivers/scsi/tmscsim.c
@@ -1728,7 +1728,7 @@ dc390_SRBdone( struct dc390_acb* pACB, struct dc390_dcb* pDCB, struct dc390_srb*
 		       (u32) pcmd->result, (u32) pSRB->TotalXferredLen));
 	    } else {
 		SET_RES_DRV(pcmd->result, DRIVER_SENSE);
-		scsi_sg_count(pcmd) = pSRB->SavedSGCount;
+		scsi_set_sg_count(pcmd, pSRB->SavedSGCount);
 		//pSRB->ScsiCmdLen	 = (u8) (pSRB->Segment1[0] >> 8);
 		DEBUG0 (printk ("DC390: RETRY pid %li (%02x), target %02i-%02i\n", pcmd->pid, pcmd->cmnd[0], pcmd->device->id, pcmd->device->lun));
 		pSRB->TotalXferredLen = 0;
@@ -1750,7 +1750,7 @@ dc390_SRBdone( struct dc390_acb* pACB, struct dc390_dcb* pDCB, struct dc390_srb*
 	else if( status_byte(status) == QUEUE_FULL )
 	{
 	    scsi_track_queue_full(pcmd->device, pDCB->GoingSRBCnt - 1);
-	    scsi_sg_count(pcmd) = pSRB->SavedSGCount;
+	    scsi_set_sg_count(pcmd, pSRB->SavedSGCount);
 	    DEBUG0 (printk ("DC390: RETRY pid %li (%02x), target %02i-%02i\n", pcmd->pid, pcmd->cmnd[0], pcmd->device->id, pcmd->device->lun));
 	    pSRB->TotalXferredLen = 0;
 	    SET_RES_DID(pcmd->result, DID_SOFT_ERROR);
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 53e1705..d0c1101 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -152,6 +152,16 @@ static inline int scsi_get_resid(struct scsi_cmnd *cmd)
 	return cmd->resid;
 }
 
+static inline void scsi_set_sg_count(struct scsi_cmnd *cmd, int sg_count)
+{
+	cmd->use_sg = sg_count;
+}
+
+static inline void scsi_set_bufflen(struct scsi_cmnd *cmd, int length)
+{
+	cmd->request_bufflen = length;
+}
+
 #define scsi_for_each_sg(cmd, sg, nseg, __i)			\
 	for (__i = 0, sg = scsi_sglist(cmd); __i < (nseg); __i++, (sg)++)
 
-- 
1.5.0.4.402.g8035



--------------030803050905060302040501--
