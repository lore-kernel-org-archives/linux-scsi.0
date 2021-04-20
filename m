Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C7CEC43460
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:10:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E552C613AF
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:10:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233831AbhDTAKr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 20:10:47 -0400
Received: from mail-pj1-f51.google.com ([209.85.216.51]:46851 "EHLO
        mail-pj1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233841AbhDTAKc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 20:10:32 -0400
Received: by mail-pj1-f51.google.com with SMTP id u14-20020a17090a1f0eb029014e38011b09so14625394pja.5
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 17:10:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cA0kQQ+tio1hAj9Omb8s/5Nh2DlSJv4IBN6Z9UYWqV4=;
        b=tGJxFKm+gjCi5sA/JL9IuYf30B3nK0RioTPakRrny1r1MZFRmVE0kQIut63wTqp9qe
         Rt7E0zE9LYaQZ/OjT+l3NAWlvn3vTSdpgLbF5cksnaHEU3KE9Zivp3GFwIUjXC6kcXd1
         2ggpu4tN5kolEzKGNE3/juJMS4wHb0ytBpOTwNhp55Bfz/d4e+j2xeMP0+0b0V5zGel6
         8tQ+ykYiVvWon2/hCVTIwSc83TxOwPLDcfzg7bRrzLxiUrLsVcH4ZR7iV258tl6flBTQ
         D9R0VXjjOjK/IzwzZdP6v49AyBAX6c7s42mZNKNt7RoDLFysjMZorntEM3mU9ZEyCdQn
         SLLg==
X-Gm-Message-State: AOAM532xMXxbt8bbEa3SGYu9BT3Q8oiaZRa+zZWvtPGmlm2qUmTJjkhz
        HzLUlnLDpVUbReaN5Qp77NA=
X-Google-Smtp-Source: ABdhPJz71/UH+W9CTwxSI7iwzAYgkrCnibR66e9BnBrS//B7GDYvxZsVKT3tr3AEzTHURpJr6fu/aw==
X-Received: by 2002:a17:902:bd8b:b029:ec:7e58:a544 with SMTP id q11-20020a170902bd8bb02900ec7e58a544mr18397976pls.26.1618877402187;
        Mon, 19 Apr 2021 17:10:02 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id 33sm14006787pgq.21.2021.04.19.17.10.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 17:10:01 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 061/117] ips: Convert to the scsi_status union
Date:   Mon, 19 Apr 2021 17:07:49 -0700
Message-Id: <20210420000845.25873-62-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210420000845.25873-1-bvanassche@acm.org>
References: <20210420000845.25873-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

An explanation of the purpose of this patch is available in the patch
"scsi: Introduce the scsi_status union".

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ips.c | 72 +++++++++++++++++++++++-----------------------
 1 file changed, 36 insertions(+), 36 deletions(-)

diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index 1a3c534826ba..4be97e52bbd5 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -935,7 +935,7 @@ static int __ips_eh_reset(struct scsi_cmnd *SC)
 			  ips_name, ha->host_num);
 
 		while ((scb = ips_removeq_scb_head(&ha->scb_activelist))) {
-			scb->scsi_cmd->result = DID_ERROR << 16;
+			scb->scsi_cmd->status.combined = DID_ERROR << 16;
 			scb->scsi_cmd->scsi_done(scb->scsi_cmd);
 			ips_freescb(ha, scb);
 		}
@@ -945,7 +945,7 @@ static int __ips_eh_reset(struct scsi_cmnd *SC)
 			  ips_name, ha->host_num);
 
 		while ((scsi_cmd = ips_removeq_wait_head(&ha->scb_waitlist))) {
-			scsi_cmd->result = DID_ERROR;
+			scsi_cmd->status.combined = DID_ERROR;
 			scsi_cmd->scsi_done(scsi_cmd);
 		}
 
@@ -964,7 +964,7 @@ static int __ips_eh_reset(struct scsi_cmnd *SC)
 			  ips_name, ha->host_num);
 
 		while ((scb = ips_removeq_scb_head(&ha->scb_activelist))) {
-			scb->scsi_cmd->result = DID_ERROR << 16;
+			scb->scsi_cmd->status.combined = DID_ERROR << 16;
 			scb->scsi_cmd->scsi_done(scb->scsi_cmd);
 			ips_freescb(ha, scb);
 		}
@@ -974,7 +974,7 @@ static int __ips_eh_reset(struct scsi_cmnd *SC)
 			  ips_name, ha->host_num);
 
 		while ((scsi_cmd = ips_removeq_wait_head(&ha->scb_waitlist))) {
-			scsi_cmd->result = DID_ERROR << 16;
+			scsi_cmd->status.combined = DID_ERROR << 16;
 			scsi_cmd->scsi_done(scsi_cmd);
 		}
 
@@ -993,7 +993,7 @@ static int __ips_eh_reset(struct scsi_cmnd *SC)
 	DEBUG_VAR(1, "(%s%d) Failing active commands", ips_name, ha->host_num);
 
 	while ((scb = ips_removeq_scb_head(&ha->scb_activelist))) {
-		scb->scsi_cmd->result = DID_RESET << 16;
+		scb->scsi_cmd->status.combined = DID_RESET << 16;
 		scb->scsi_cmd->scsi_done(scb->scsi_cmd);
 		ips_freescb(ha, scb);
 	}
@@ -1052,13 +1052,13 @@ static int ips_queue_lck(struct scsi_cmnd *SC, void (*done) (struct scsi_cmnd *)
 
 	if (ips_is_passthru(SC)) {
 		if (ha->copp_waitlist.count == IPS_MAX_IOCTL_QUEUE) {
-			SC->result = DID_BUS_BUSY << 16;
+			SC->status.combined = DID_BUS_BUSY << 16;
 			done(SC);
 
 			return (0);
 		}
 	} else if (ha->scb_waitlist.count == IPS_MAX_QUEUE) {
-		SC->result = DID_BUS_BUSY << 16;
+		SC->status.combined = DID_BUS_BUSY << 16;
 		done(SC);
 
 		return (0);
@@ -1075,7 +1075,7 @@ static int ips_queue_lck(struct scsi_cmnd *SC, void (*done) (struct scsi_cmnd *)
 	/* Check for command to initiator IDs */
 	if ((scmd_channel(SC) > 0)
 	    && (scmd_id(SC) == ha->ha_id[scmd_channel(SC)])) {
-		SC->result = DID_NO_CONNECT << 16;
+		SC->status.combined = DID_NO_CONNECT << 16;
 		done(SC);
 
 		return (0);
@@ -1092,13 +1092,13 @@ static int ips_queue_lck(struct scsi_cmnd *SC, void (*done) (struct scsi_cmnd *)
 		if ((pt->CoppCP.cmd.reset.op_code == IPS_CMD_RESET_CHANNEL) &&
 		    (pt->CoppCP.cmd.reset.adapter_flag == 1)) {
 			if (ha->scb_activelist.count != 0) {
-				SC->result = DID_BUS_BUSY << 16;
+				SC->status.combined = DID_BUS_BUSY << 16;
 				done(SC);
 				return (0);
 			}
 			ha->ioctl_reset = 1;	/* This reset request is from an IOCTL */
 			__ips_eh_reset(SC);
-			SC->result = DID_OK << 16;
+			SC->status.combined = DID_OK << 16;
 			SC->scsi_done(SC);
 			return (0);
 		}
@@ -1107,7 +1107,7 @@ static int ips_queue_lck(struct scsi_cmnd *SC, void (*done) (struct scsi_cmnd *)
 		scratch = kmalloc(sizeof (ips_copp_wait_item_t), GFP_ATOMIC);
 
 		if (!scratch) {
-			SC->result = DID_ERROR << 16;
+			SC->status.combined = DID_ERROR << 16;
 			done(SC);
 
 			return (0);
@@ -1125,7 +1125,7 @@ static int ips_queue_lck(struct scsi_cmnd *SC, void (*done) (struct scsi_cmnd *)
 
 	return (0);
 out_error:
-	SC->result = DID_ERROR << 16;
+	SC->status.combined = DID_ERROR << 16;
 	done(SC);
 
 	return (0);
@@ -1610,7 +1610,7 @@ ips_make_passthru(ips_ha_t *ha, struct scsi_cmnd *SC, ips_scb_t *scb, int intr)
 		       &ips_num_controllers, sizeof (int));
 		ips_scmd_buf_write(SC, ha->ioctl_data,
 				   sizeof (ips_passthru_t) + sizeof (int));
-		SC->result = DID_OK << 16;
+		SC->status.combined = DID_OK << 16;
 
 		return (IPS_SUCCESS_IMM);
 
@@ -1667,7 +1667,7 @@ ips_flash_copperhead(ips_ha_t * ha, ips_passthru_t * pt, ips_scb_t * scb)
 	}
 	pt->BasicStatus = 0x0B;
 	pt->ExtendedStatus = 0;
-	scb->scsi_cmd->result = DID_OK << 16;
+	scb->scsi_cmd->status.combined = DID_OK << 16;
 	/* IF it's OK to Use the "CD BOOT" Flash Buffer, then you can     */
 	/* avoid allocating a huge buffer per adapter ( which can fail ). */
 	if (pt->CoppCP.cmd.flashfw.type == IPS_BIOS_IMAGE &&
@@ -1869,7 +1869,7 @@ ips_flash_firmware(ips_ha_t * ha, ips_passthru_t * pt, ips_scb_t * scb)
 	scb->cmd.flashfw.buffer_addr = cpu_to_le32(scb->data_busaddr);
 	if (pt->TimeOut)
 		scb->timeout = pt->TimeOut;
-	scb->scsi_cmd->result = DID_OK << 16;
+	scb->scsi_cmd->status.combined = DID_OK << 16;
 	return IPS_SUCCESS;
 }
 
@@ -1971,7 +1971,7 @@ ips_usrcmd(ips_ha_t * ha, ips_passthru_t * pt, ips_scb_t * scb)
 	}
 
 	/* assume success */
-	scb->scsi_cmd->result = DID_OK << 16;
+	scb->scsi_cmd->status.combined = DID_OK << 16;
 
 	/* success */
 	return (1);
@@ -2578,7 +2578,7 @@ ips_next(ips_ha_t * ha, int intr)
 		switch (ret) {
 		case IPS_FAILURE:
 			if (scb->scsi_cmd) {
-				scb->scsi_cmd->result = DID_ERROR << 16;
+				scb->scsi_cmd->status.combined = DID_ERROR << 16;
 				scb->scsi_cmd->scsi_done(scb->scsi_cmd);
 			}
 
@@ -2586,7 +2586,7 @@ ips_next(ips_ha_t * ha, int intr)
 			break;
 		case IPS_SUCCESS_IMM:
 			if (scb->scsi_cmd) {
-				scb->scsi_cmd->result = DID_OK << 16;
+				scb->scsi_cmd->status.combined = DID_OK << 16;
 				scb->scsi_cmd->scsi_done(scb->scsi_cmd);
 			}
 
@@ -2611,7 +2611,7 @@ ips_next(ips_ha_t * ha, int intr)
 		switch (ret) {
 		case IPS_FAILURE:
 			if (scb->scsi_cmd) {
-				scb->scsi_cmd->result = DID_ERROR << 16;
+				scb->scsi_cmd->status.combined = DID_ERROR << 16;
 			}
 
 			ips_freescb(ha, scb);
@@ -2646,7 +2646,7 @@ ips_next(ips_ha_t * ha, int intr)
 		if (intr == IPS_INTR_ON)
 			spin_unlock(host->host_lock);	/* Unlock HA after command is taken off queue */
 
-		SC->result = DID_OK;
+		SC->status.combined = DID_OK;
 		SC->host_scribble = NULL;
 
 		scb->target_id = SC->device->id;
@@ -2711,7 +2711,7 @@ ips_next(ips_ha_t * ha, int intr)
 			break;
 		case IPS_FAILURE:
 			if (scb->scsi_cmd) {
-				scb->scsi_cmd->result = DID_ERROR << 16;
+				scb->scsi_cmd->status.combined = DID_ERROR << 16;
 				scb->scsi_cmd->scsi_done(scb->scsi_cmd);
 			}
 
@@ -3205,7 +3205,7 @@ ips_done(ips_ha_t * ha, ips_scb_t * scb)
 			switch (ret) {
 			case IPS_FAILURE:
 				if (scb->scsi_cmd) {
-					scb->scsi_cmd->result = DID_ERROR << 16;
+					scb->scsi_cmd->status.combined = DID_ERROR << 16;
 					scb->scsi_cmd->scsi_done(scb->scsi_cmd);
 				}
 
@@ -3213,7 +3213,7 @@ ips_done(ips_ha_t * ha, ips_scb_t * scb)
 				break;
 			case IPS_SUCCESS_IMM:
 				if (scb->scsi_cmd) {
-					scb->scsi_cmd->result = DID_ERROR << 16;
+					scb->scsi_cmd->status.combined = DID_ERROR << 16;
 					scb->scsi_cmd->scsi_done(scb->scsi_cmd);
 				}
 
@@ -3366,7 +3366,7 @@ ips_map_status(ips_ha_t * ha, ips_scb_t * scb, ips_stat_t * sp)
 		}		/* end switch */
 	}			/* end switch */
 
-	scb->scsi_cmd->result = device_error | (errcode << 16);
+	scb->scsi_cmd->status.combined = device_error | (errcode << 16);
 
 	return (1);
 }
@@ -3484,11 +3484,11 @@ ips_send_cmd(ips_ha_t * ha, ips_scb_t * scb)
 		case ERASE:
 		case WRITE_FILEMARKS:
 		case SPACE:
-			scb->scsi_cmd->result = DID_ERROR << 16;
+			scb->scsi_cmd->status.combined = DID_ERROR << 16;
 			break;
 
 		case START_STOP:
-			scb->scsi_cmd->result = DID_OK << 16;
+			scb->scsi_cmd->status.combined = DID_OK << 16;
 			break;
 
 		case TEST_UNIT_READY:
@@ -3499,7 +3499,7 @@ ips_send_cmd(ips_ha_t * ha, ips_scb_t * scb)
 				 * or we have a SCSI inquiry
 				 */
 				if (scb->scsi_cmd->cmnd[0] == TEST_UNIT_READY)
-					scb->scsi_cmd->result = DID_OK << 16;
+					scb->scsi_cmd->status.combined = DID_OK << 16;
 
 				if (scb->scsi_cmd->cmnd[0] == INQUIRY) {
 					IPS_SCSI_INQ_DATA inquiry;
@@ -3531,7 +3531,7 @@ ips_send_cmd(ips_ha_t * ha, ips_scb_t * scb)
 							   &inquiry,
 							   sizeof (inquiry));
 
-					scb->scsi_cmd->result = DID_OK << 16;
+					scb->scsi_cmd->status.combined = DID_OK << 16;
 				}
 			} else {
 				scb->cmd.logical_info.op_code = IPS_CMD_GET_LD_INFO;
@@ -3549,7 +3549,7 @@ ips_send_cmd(ips_ha_t * ha, ips_scb_t * scb)
 
 		case REQUEST_SENSE:
 			ips_reqsen(ha, scb);
-			scb->scsi_cmd->result = DID_OK << 16;
+			scb->scsi_cmd->status.combined = DID_OK << 16;
 			break;
 
 		case READ_6:
@@ -3645,7 +3645,7 @@ ips_send_cmd(ips_ha_t * ha, ips_scb_t * scb)
 				 * we don't have to do anything
 				 * so just return
 				 */
-				scb->scsi_cmd->result = DID_OK << 16;
+				scb->scsi_cmd->status.combined = DID_OK << 16;
 			} else
 				ret = IPS_SUCCESS;
 
@@ -3653,7 +3653,7 @@ ips_send_cmd(ips_ha_t * ha, ips_scb_t * scb)
 
 		case RESERVE:
 		case RELEASE:
-			scb->scsi_cmd->result = DID_OK << 16;
+			scb->scsi_cmd->status.combined = DID_OK << 16;
 			break;
 
 		case MODE_SENSE:
@@ -3687,7 +3687,7 @@ ips_send_cmd(ips_ha_t * ha, ips_scb_t * scb)
 		case READ_DEFECT_DATA:
 		case READ_BUFFER:
 		case WRITE_BUFFER:
-			scb->scsi_cmd->result = DID_OK << 16;
+			scb->scsi_cmd->status.combined = DID_OK << 16;
 			break;
 
 		default:
@@ -3703,7 +3703,7 @@ ips_send_cmd(ips_ha_t * ha, ips_scb_t * scb)
 			sp[13] = 0x00;	/* ASCQ                     */
 
 			device_error = 2;	/* Indicate Check Condition */
-			scb->scsi_cmd->result = device_error | (DID_OK << 16);
+			scb->scsi_cmd->status.combined = device_error | (DID_OK << 16);
 			break;
 		}		/* end switch */
 	}
@@ -3717,7 +3717,7 @@ ips_send_cmd(ips_ha_t * ha, ips_scb_t * scb)
 		/* If we already know the Device is Not there, no need to attempt a Command   */
 		/* This also protects an NT FailOver Controller from getting CDB's sent to it */
 		if (ha->conf->dev[scb->bus - 1][scb->target_id].ucState == 0) {
-			scb->scsi_cmd->result = DID_NO_CONNECT << 16;
+			scb->scsi_cmd->status.combined = DID_NO_CONNECT << 16;
 			return (IPS_SUCCESS_IMM);
 		}
 
@@ -3957,14 +3957,14 @@ ips_chkstatus(ips_ha_t * ha, IPS_STATUS * pstatus)
 				errcode = DID_ERROR;
 			}	/* end switch */
 
-			scb->scsi_cmd->result = errcode << 16;
+			scb->scsi_cmd->status.combined = errcode << 16;
 		} else {	/* bus == 0 */
 			/* restrict access to physical drives */
 			if (scb->scsi_cmd->cmnd[0] == INQUIRY) {
 			    ips_scmd_buf_read(scb->scsi_cmd,
                                   &inquiryData, sizeof (inquiryData));
 			    if ((inquiryData.DeviceType & 0x1f) == TYPE_DISK)
-			        scb->scsi_cmd->result = DID_TIME_OUT << 16;
+			        scb->scsi_cmd->status.combined = DID_TIME_OUT << 16;
 			}
 		}		/* else */
 	} else {		/* recovered error / success */
