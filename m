From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] ips: remove unnecesary local_irq_save/restore for scsi sg
 copy API
Date: Thu, 9 Oct 2008 11:25:43 +0900
Message-ID: <20081009112512S.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:34473 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753287AbYJICZu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Oct 2008 22:25:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, Mark_Salyzyn@adaptec.com

Since the commit 50bed2e2862a8f3a4f7d683d0d27292e71ef18b9 (sg: disable
interrupts inside sg_copy_buffer), no need to disable interrupts
before calling scsi_sg_copy_from/to_buffer. So we can kill
ips_scmd_buf_write and ips_scmd_buf_read, which are simple wrappers to
just call them with interrupts disabled. We can directly call
scsi_sg_copy_from_buffer and scsi_sg_copy_from_buffer respectively.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/ips.c |   80 ++++++++++++++-------------------------------------
 1 files changed, 22 insertions(+), 58 deletions(-)

diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index bc9e6dd..7f878ba 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -321,11 +321,6 @@ static int ips_is_passthru(struct scsi_cmnd *);
 static int ips_make_passthru(ips_ha_t *, struct scsi_cmnd *, ips_scb_t *, int);
 static int ips_usrcmd(ips_ha_t *, ips_passthru_t *, ips_scb_t *);
 static void ips_cleanup_passthru(ips_ha_t *, ips_scb_t *);
-static void ips_scmd_buf_write(struct scsi_cmnd * scmd, void *data,
-			       unsigned int count);
-static void ips_scmd_buf_read(struct scsi_cmnd * scmd, void *data,
-			      unsigned int count);
-
 static int ips_proc_info(struct Scsi_Host *, char *, char **, off_t, int, int);
 static int ips_host_info(ips_ha_t *, char *, off_t, int);
 static void copy_mem_info(IPS_INFOSTR *, char *, int);
@@ -1588,16 +1583,17 @@ ips_make_passthru(ips_ha_t *ha, struct scsi_cmnd *SC, ips_scb_t *scb, int intr)
 		   some error codes.  Return a failed command to the scsi layer. */
 		if (ha->ioctl_data) {
 			pt = (ips_passthru_t *) ha->ioctl_data;
-			ips_scmd_buf_read(SC, pt, sizeof (ips_passthru_t));
+                        scsi_sg_copy_to_buffer(SC, pt, sizeof(ips_passthru_t));
 			pt->BasicStatus = 0x0B;
 			pt->ExtendedStatus = 0x00;
-			ips_scmd_buf_write(SC, pt, sizeof (ips_passthru_t));
+                        scsi_sg_copy_from_buffer(SC, pt,
+                                                 sizeof(ips_passthru_t));
 		}
 		return IPS_FAILURE;
 	}
 	ha->ioctl_datasize = length;
 
-	ips_scmd_buf_read(SC, ha->ioctl_data, ha->ioctl_datasize);
+	scsi_sg_copy_to_buffer(SC, ha->ioctl_data, ha->ioctl_datasize);
 	pt = (ips_passthru_t *) ha->ioctl_data;
 
 	/*
@@ -1614,8 +1610,8 @@ ips_make_passthru(ips_ha_t *ha, struct scsi_cmnd *SC, ips_scb_t *scb, int intr)
 	case IPS_NUMCTRLS:
 		memcpy(ha->ioctl_data + sizeof (ips_passthru_t),
 		       &ips_num_controllers, sizeof (int));
-		ips_scmd_buf_write(SC, ha->ioctl_data,
-				   sizeof (ips_passthru_t) + sizeof (int));
+                scsi_sg_copy_from_buffer(SC, ha->ioctl_data,
+                                         sizeof(ips_passthru_t) + sizeof(int));
 		SC->result = DID_OK << 16;
 
 		return (IPS_SUCCESS_IMM);
@@ -1636,8 +1632,8 @@ ips_make_passthru(ips_ha_t *ha, struct scsi_cmnd *SC, ips_scb_t *scb, int intr)
 			    pt->CoppCP.cmd.flashfw.op_code ==
 			    IPS_CMD_RW_BIOSFW) {
 				ret = ips_flash_copperhead(ha, pt, scb);
-				ips_scmd_buf_write(SC, ha->ioctl_data,
-						   sizeof (ips_passthru_t));
+                                scsi_sg_copy_from_buffer(SC, ha->ioctl_data,
+                                                         sizeof(ips_passthru_t));
 				return ret;
 			}
 			if (ips_usrcmd(ha, pt, scb))
@@ -2021,7 +2017,8 @@ ips_cleanup_passthru(ips_ha_t * ha, ips_scb_t * scb)
 	     scb->cmd.flashfw.op_code == IPS_CMD_RW_BIOSFW))
 		ips_free_flash_copperhead(ha);
 
-	ips_scmd_buf_write(scb->scsi_cmd, ha->ioctl_data, ha->ioctl_datasize);
+        scsi_sg_copy_from_buffer(scb->scsi_cmd, ha->ioctl_data,
+                                 ha->ioctl_datasize);
 }
 
 /****************************************************************************/
@@ -3398,8 +3395,8 @@ ips_map_status(ips_ha_t * ha, ips_scb_t * scb, ips_stat_t * sp)
 
 				/* Restrict access to physical DASD */
 				if (scb->scsi_cmd->cmnd[0] == INQUIRY) {
-				    ips_scmd_buf_read(scb->scsi_cmd,
-                                      &inquiryData, sizeof (inquiryData));
+                                        scsi_sg_copy_to_buffer(scb->scsi_cmd,
+                                                               &inquiryData, sizeof(inquiryData));
  				    if ((inquiryData.DeviceType & 0x1f) == TYPE_DISK) {
 				        errcode = DID_TIME_OUT;
 				        break;
@@ -3493,40 +3490,6 @@ ips_send_wait(ips_ha_t * ha, ips_scb_t * scb, int timeout, int intr)
 
 /****************************************************************************/
 /*                                                                          */
-/* Routine Name: ips_scmd_buf_write                                         */
-/*                                                                          */
-/* Routine Description:                                                     */
-/*  Write data to struct scsi_cmnd request_buffer at proper offsets	    */
-/****************************************************************************/
-static void
-ips_scmd_buf_write(struct scsi_cmnd *scmd, void *data, unsigned int count)
-{
-	unsigned long flags;
-
-	local_irq_save(flags);
-	scsi_sg_copy_from_buffer(scmd, data, count);
-	local_irq_restore(flags);
-}
-
-/****************************************************************************/
-/*                                                                          */
-/* Routine Name: ips_scmd_buf_read                                          */
-/*                                                                          */
-/* Routine Description:                                                     */
-/*  Copy data from a struct scsi_cmnd to a new, linear buffer		    */
-/****************************************************************************/
-static void
-ips_scmd_buf_read(struct scsi_cmnd *scmd, void *data, unsigned int count)
-{
-	unsigned long flags;
-
-	local_irq_save(flags);
-	scsi_sg_copy_to_buffer(scmd, data, count);
-	local_irq_restore(flags);
-}
-
-/****************************************************************************/
-/*                                                                          */
 /* Routine Name: ips_send_cmd                                               */
 /*                                                                          */
 /* Routine Description:                                                     */
@@ -3612,9 +3575,9 @@ ips_send_cmd(ips_ha_t * ha, ips_scb_t * scb)
 					strncpy(inquiry.ProductRevisionLevel,
 						"1.00", 4);
 
-					ips_scmd_buf_write(scb->scsi_cmd,
-							   &inquiry,
-							   sizeof (inquiry));
+                                        scsi_sg_copy_from_buffer(scb->scsi_cmd,
+                                                                 &inquiry,
+                                                                 sizeof(inquiry));
 
 					scb->scsi_cmd->result = DID_OK << 16;
 				}
@@ -4046,8 +4009,9 @@ ips_chkstatus(ips_ha_t * ha, IPS_STATUS * pstatus)
 		} else {	/* bus == 0 */
 			/* restrict access to physical drives */
 			if (scb->scsi_cmd->cmnd[0] == INQUIRY) {
-			    ips_scmd_buf_read(scb->scsi_cmd,
-                                  &inquiryData, sizeof (inquiryData));
+			    scsi_sg_copy_to_buffer(scb->scsi_cmd,
+                                                   &inquiryData,
+                                                   sizeof (inquiryData));
 			    if ((inquiryData.DeviceType & 0x1f) == TYPE_DISK)
 			        scb->scsi_cmd->result = DID_TIME_OUT << 16;
 			}
@@ -4130,7 +4094,7 @@ ips_inquiry(ips_ha_t * ha, ips_scb_t * scb)
 	strncpy(inquiry.ProductId, "SERVERAID       ", 16);
 	strncpy(inquiry.ProductRevisionLevel, "1.00", 4);
 
-	ips_scmd_buf_write(scb->scsi_cmd, &inquiry, sizeof (inquiry));
+        scsi_sg_copy_from_buffer(scb->scsi_cmd, &inquiry, sizeof(inquiry));
 
 	return (1);
 }
@@ -4160,7 +4124,7 @@ ips_rdcap(ips_ha_t * ha, ips_scb_t * scb)
 			 drive_info[scb->target_id].sector_count) - 1);
 	cap.len = cpu_to_be32((uint32_t) IPS_BLKSIZE);
 
-	ips_scmd_buf_write(scb->scsi_cmd, &cap, sizeof (cap));
+        scsi_sg_copy_from_buffer(scb->scsi_cmd, &cap, sizeof(cap));
 
 	return (1);
 }
@@ -4251,7 +4215,7 @@ ips_msense(ips_ha_t * ha, ips_scb_t * scb)
 		return (0);
 	}			/* end switch */
 
-	ips_scmd_buf_write(scb->scsi_cmd, &mdata, sizeof (mdata));
+        scsi_sg_copy_from_buffer(scb->scsi_cmd, &mdata, sizeof(mdata));
 
 	return (1);
 }
@@ -4280,7 +4244,7 @@ ips_reqsen(ips_ha_t * ha, ips_scb_t * scb)
 	reqsen.AdditionalSenseCode = IPS_SCSI_REQSEN_NO_SENSE;
 	reqsen.AdditionalSenseCodeQual = IPS_SCSI_REQSEN_NO_SENSE;
 
-	ips_scmd_buf_write(scb->scsi_cmd, &reqsen, sizeof (reqsen));
+        scsi_sg_copy_from_buffer(scb->scsi_cmd, &reqsen, sizeof(reqsen));
 
 	return (1);
 }
-- 
1.5.5.GIT

