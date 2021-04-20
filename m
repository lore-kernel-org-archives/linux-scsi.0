Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C280C433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:10:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 287716109E
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:10:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233975AbhDTAK6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 20:10:58 -0400
Received: from mail-pj1-f50.google.com ([209.85.216.50]:39430 "EHLO
        mail-pj1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234035AbhDTAKl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 20:10:41 -0400
Received: by mail-pj1-f50.google.com with SMTP id ot17-20020a17090b3b51b0290109c9ac3c34so21335816pjb.4
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 17:10:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kmu8VMKnEMxkzvOSAE+iKu/OOFP5tIJOwUm3NVOfEkY=;
        b=Zi355J3RSOoQpTdJVg20n+ygVyTcwo2vDQwRwW36GiuyNQcLv71ZDmhxBDQo+v/1Pq
         qN/moSuQTEUiWnnUUVpnsHgWZmQyhDiUFi7R3VA9UVXfd0wf3pZ6yWkPGmeKXNJg+D9L
         gd70I2qxIzGYXU118RHCf1Ad7CcHqKftEP0m9hMYuJbOgegXGXsjYIIpeW7s0rVLbzfp
         EC91F8+YG8Gr7HqY29VMX8+8UP7CNd3lgs11yxjoMFJjg/t+QXpQdsK/H98Idc2KZhd0
         E1jNJF/eVXEEoNu2VXkkkvQfyS65jNOPUEZR0db8ostYmf8gLnj2GfQFCobryBj8N4Bj
         o1Ng==
X-Gm-Message-State: AOAM530WzcVKcjXQV5aG9PFZTqoXj+/zD8AzpUAbwYS4Be8+qzWsNYe5
        B5Rdj3n5R3BZqLOJZSUogFI=
X-Google-Smtp-Source: ABdhPJxcAceMjJLDhNB+EpPZG6N/uNFLqD1UPL8HmdGjXMPITEsAAa8E8sTdllJnyhPTUFSgAtT/iQ==
X-Received: by 2002:a17:902:c745:b029:eb:6fc0:39e7 with SMTP id q5-20020a170902c745b02900eb6fc039e7mr25486514plq.82.1618877409160;
        Mon, 19 Apr 2021 17:10:09 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id 33sm14006787pgq.21.2021.04.19.17.10.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 17:10:08 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 067/117] megaraid: Convert to the scsi_status union
Date:   Mon, 19 Apr 2021 17:07:55 -0700
Message-Id: <20210420000845.25873-68-bvanassche@acm.org>
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

Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Sumit Saxena <sumit.saxena@broadcom.com>
Cc: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/megaraid.c                     | 50 ++++++++---------
 drivers/scsi/megaraid/megaraid_mbox.c       | 62 ++++++++++-----------
 drivers/scsi/megaraid/megaraid_sas_base.c   | 30 +++++-----
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 20 +++----
 4 files changed, 81 insertions(+), 81 deletions(-)

diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 80f546976c7e..49d072147242 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -585,7 +585,7 @@ mega_build_cmd(adapter_t *adapter, struct scsi_cmnd *cmd, int *busy)
 
 		/* have just LUN 0 for each target on virtual channels */
 		if (cmd->device->lun) {
-			cmd->result = (DID_BAD_TARGET << 16);
+			cmd->status.combined = (DID_BAD_TARGET << 16);
 			cmd->scsi_done(cmd);
 			return NULL;
 		}
@@ -604,7 +604,7 @@ mega_build_cmd(adapter_t *adapter, struct scsi_cmnd *cmd, int *busy)
 			max_ldrv_num += 0x80;
 
 		if(ldrv_num > max_ldrv_num ) {
-			cmd->result = (DID_BAD_TARGET << 16);
+			cmd->status.combined = (DID_BAD_TARGET << 16);
 			cmd->scsi_done(cmd);
 			return NULL;
 		}
@@ -616,7 +616,7 @@ mega_build_cmd(adapter_t *adapter, struct scsi_cmnd *cmd, int *busy)
 			 * Do not support lun >7 for physically accessed
 			 * devices
 			 */
-			cmd->result = (DID_BAD_TARGET << 16);
+			cmd->status.combined = (DID_BAD_TARGET << 16);
 			cmd->scsi_done(cmd);
 			return NULL;
 		}
@@ -636,7 +636,7 @@ mega_build_cmd(adapter_t *adapter, struct scsi_cmnd *cmd, int *busy)
 			 * If no, return success always
 			 */
 			if( !adapter->has_cluster ) {
-				cmd->result = (DID_OK << 16);
+				cmd->status.combined = (DID_OK << 16);
 				cmd->scsi_done(cmd);
 				return NULL;
 			}
@@ -654,7 +654,7 @@ mega_build_cmd(adapter_t *adapter, struct scsi_cmnd *cmd, int *busy)
 
 			return scb;
 #else
-			cmd->result = (DID_OK << 16);
+			cmd->status.combined = (DID_OK << 16);
 			cmd->scsi_done(cmd);
 			return NULL;
 #endif
@@ -669,7 +669,7 @@ mega_build_cmd(adapter_t *adapter, struct scsi_cmnd *cmd, int *busy)
 			memset(buf, 0, cmd->cmnd[4]);
 			kunmap_atomic(buf - sg->offset);
 
-			cmd->result = (DID_OK << 16);
+			cmd->status.combined = (DID_OK << 16);
 			cmd->scsi_done(cmd);
 			return NULL;
 		}
@@ -865,7 +865,7 @@ mega_build_cmd(adapter_t *adapter, struct scsi_cmnd *cmd, int *busy)
 			 */
 			if( ! adapter->has_cluster ) {
 
-				cmd->result = (DID_BAD_TARGET << 16);
+				cmd->status.combined = (DID_BAD_TARGET << 16);
 				cmd->scsi_done(cmd);
 				return NULL;
 			}
@@ -888,7 +888,7 @@ mega_build_cmd(adapter_t *adapter, struct scsi_cmnd *cmd, int *busy)
 #endif
 
 		default:
-			cmd->result = (DID_BAD_TARGET << 16);
+			cmd->status.combined = (DID_BAD_TARGET << 16);
 			cmd->scsi_done(cmd);
 			return NULL;
 		}
@@ -1472,7 +1472,7 @@ mega_cmd_done(adapter_t *adapter, u8 completed[], int nstatus, int status)
 					"aborted cmd [%x] complete\n",
 					scb->idx);
 
-				scb->cmd->result = (DID_ABORT << 16);
+				scb->cmd->status.combined = (DID_ABORT << 16);
 
 				list_add_tail(SCSI_LIST(scb->cmd),
 						&adapter->completed_list);
@@ -1491,7 +1491,7 @@ mega_cmd_done(adapter_t *adapter, u8 completed[], int nstatus, int status)
 					"reset cmd [%x] complete\n",
 					scb->idx);
 
-				scb->cmd->result = (DID_RESET << 16);
+				scb->cmd->status.combined = (DID_RESET << 16);
 
 				list_add_tail(SCSI_LIST(scb->cmd),
 						&adapter->completed_list);
@@ -1565,12 +1565,12 @@ mega_cmd_done(adapter_t *adapter, u8 completed[], int nstatus, int status)
 		}
 
 		/* clear result; otherwise, success returns corrupt value */
-		cmd->result = 0;
+		cmd->status.combined = 0;
 
 		/* Convert MegaRAID status to Linux error code */
 		switch (status) {
 		case 0x00:	/* SUCCESS , i.e. SCSI_STATUS_GOOD */
-			cmd->result |= (DID_OK << 16);
+			cmd->status.combined |= (DID_OK << 16);
 			break;
 
 		case 0x02:	/* ERROR_ABORTED, i.e.
@@ -1583,9 +1583,9 @@ mega_cmd_done(adapter_t *adapter, u8 completed[], int nstatus, int status)
 				memcpy(cmd->sense_buffer, pthru->reqsensearea,
 						14);
 
-				cmd->result = (DRIVER_SENSE << 24) |
+				cmd->status.combined = (DRIVER_SENSE << 24) |
 					(DID_OK << 16) |
-					(CHECK_CONDITION << 1);
+					SAM_STAT_CHECK_CONDITION;
 			}
 			else {
 				if (mbox->m_out.cmd == MEGA_MBOXCMD_EXTPTHRU) {
@@ -1593,20 +1593,20 @@ mega_cmd_done(adapter_t *adapter, u8 completed[], int nstatus, int status)
 					memcpy(cmd->sense_buffer,
 						epthru->reqsensearea, 14);
 
-					cmd->result = (DRIVER_SENSE << 24) |
+					cmd->status.combined = (DRIVER_SENSE << 24) |
 						(DID_OK << 16) |
-						(CHECK_CONDITION << 1);
+						SAM_STAT_CHECK_CONDITION;
 				} else {
 					cmd->sense_buffer[0] = 0x70;
 					cmd->sense_buffer[2] = ABORTED_COMMAND;
-					cmd->result |= (CHECK_CONDITION << 1);
+					cmd->status.b.status = SAM_STAT_CHECK_CONDITION;
 				}
 			}
 			break;
 
 		case 0x08:	/* ERR_DEST_DRIVE_FAILED, i.e.
 				   SCSI_STATUS_BUSY */
-			cmd->result |= (DID_BUS_BUSY << 16) | status;
+			cmd->status.combined |= (DID_BUS_BUSY << 16) | status;
 			break;
 
 		default:
@@ -1616,8 +1616,8 @@ mega_cmd_done(adapter_t *adapter, u8 completed[], int nstatus, int status)
 			 * MEGA_RESERVATION_STATUS failed
 			 */
 			if( cmd->cmnd[0] == TEST_UNIT_READY ) {
-				cmd->result |= (DID_ERROR << 16) |
-					(RESERVATION_CONFLICT << 1);
+				cmd->status.combined |= (DID_ERROR << 16) |
+					SAM_STAT_RESERVATION_CONFLICT;
 			}
 			else
 			/*
@@ -1628,12 +1628,12 @@ mega_cmd_done(adapter_t *adapter, u8 completed[], int nstatus, int status)
 				(cmd->cmnd[0] == RESERVE ||
 					 cmd->cmnd[0] == RELEASE) ) {
 
-				cmd->result |= (DID_ERROR << 16) |
-					(RESERVATION_CONFLICT << 1);
+				cmd->status.combined |= (DID_ERROR << 16) |
+					SAM_STAT_RESERVATION_CONFLICT;
 			}
 			else
 #endif
-				cmd->result |= (DID_BAD_TARGET << 16)|status;
+				cmd->status.combined |= (DID_BAD_TARGET << 16)|status;
 		}
 
 		mega_free_scb(adapter, scb);
@@ -1983,10 +1983,10 @@ megaraid_abort_and_reset(adapter_t *adapter, struct scsi_cmnd *cmd, int aor)
 				mega_free_scb(adapter, scb);
 
 				if( aor == SCB_ABORT ) {
-					cmd->result = (DID_ABORT << 16);
+					cmd->status.combined = (DID_ABORT << 16);
 				}
 				else {
-					cmd->result = (DID_RESET << 16);
+					cmd->status.combined = (DID_RESET << 16);
 				}
 
 				list_add_tail(SCSI_LIST(cmd),
diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
index b1a2d3536add..b819365249ea 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -1442,7 +1442,7 @@ megaraid_queue_command_lck(struct scsi_cmnd *scp, void (*done)(struct scsi_cmnd
 
 	adapter		= SCP2ADAPTER(scp);
 	scp->scsi_done	= done;
-	scp->result	= 0;
+	scp->status.combined = 0;
 
 	/*
 	 * Allocate and build a SCB request
@@ -1510,12 +1510,12 @@ megaraid_mbox_build_cmd(adapter_t *adapter, struct scsi_cmnd *scp, int *busy)
 			 * If no, return success always
 			 */
 			if (!adapter->ha) {
-				scp->result = (DID_OK << 16);
+				scp->status.combined = (DID_OK << 16);
 				return NULL;
 			}
 
 			if (!(scb = megaraid_alloc_scb(adapter, scp))) {
-				scp->result = (DID_ERROR << 16);
+				scp->status.combined = (DID_ERROR << 16);
 				*busy = 1;
 				return NULL;
 			}
@@ -1552,7 +1552,7 @@ megaraid_mbox_build_cmd(adapter_t *adapter, struct scsi_cmnd *scp, int *busy)
 						 __LINE__));
 			}
 		}
-		scp->result = (DID_OK << 16);
+		scp->status.combined = (DID_OK << 16);
 		return NULL;
 
 		case INQUIRY:
@@ -1577,7 +1577,7 @@ megaraid_mbox_build_cmd(adapter_t *adapter, struct scsi_cmnd *scp, int *busy)
 				scp->sense_buffer[0] = 0x70;
 				scp->sense_buffer[2] = ILLEGAL_REQUEST;
 				scp->sense_buffer[12] = MEGA_INVALID_FIELD_IN_CDB;
-				scp->result = CHECK_CONDITION << 1;
+				scp->status.combined = SAM_STAT_CHECK_CONDITION;
 				return NULL;
 			}
 
@@ -1589,18 +1589,18 @@ megaraid_mbox_build_cmd(adapter_t *adapter, struct scsi_cmnd *scp, int *busy)
 			 * requests for more than 40 logical drives
 			 */
 			if (SCP2LUN(scp)) {
-				scp->result = (DID_BAD_TARGET << 16);
+				scp->status.combined = (DID_BAD_TARGET << 16);
 				return NULL;
 			}
 			if ((target % 0x80) >= MAX_LOGICAL_DRIVES_40LD) {
-				scp->result = (DID_BAD_TARGET << 16);
+				scp->status.combined = (DID_BAD_TARGET << 16);
 				return NULL;
 			}
 
 
 			/* Allocate a SCB and initialize passthru */
 			if (!(scb = megaraid_alloc_scb(adapter, scp))) {
-				scp->result = (DID_ERROR << 16);
+				scp->status.combined = (DID_ERROR << 16);
 				*busy = 1;
 				return NULL;
 			}
@@ -1645,7 +1645,7 @@ megaraid_mbox_build_cmd(adapter_t *adapter, struct scsi_cmnd *scp, int *busy)
 			 * Allocate a SCB and initialize mailbox
 			 */
 			if (!(scb = megaraid_alloc_scb(adapter, scp))) {
-				scp->result = (DID_ERROR << 16);
+				scp->status.combined = (DID_ERROR << 16);
 				*busy = 1;
 				return NULL;
 			}
@@ -1712,7 +1712,7 @@ megaraid_mbox_build_cmd(adapter_t *adapter, struct scsi_cmnd *scp, int *busy)
 
 				megaraid_dealloc_scb(adapter, scb);
 
-				scp->result = (DID_ERROR << 16);
+				scp->status.combined = (DID_ERROR << 16);
 				return NULL;
 			}
 
@@ -1733,7 +1733,7 @@ megaraid_mbox_build_cmd(adapter_t *adapter, struct scsi_cmnd *scp, int *busy)
 			 * Do we support clustering and is the support enabled
 			 */
 			if (!adapter->ha) {
-				scp->result = (DID_BAD_TARGET << 16);
+				scp->status.combined = (DID_BAD_TARGET << 16);
 				return NULL;
 			}
 
@@ -1741,7 +1741,7 @@ megaraid_mbox_build_cmd(adapter_t *adapter, struct scsi_cmnd *scp, int *busy)
 			 * Allocate a SCB and initialize mailbox
 			 */
 			if (!(scb = megaraid_alloc_scb(adapter, scp))) {
-				scp->result = (DID_ERROR << 16);
+				scp->status.combined = (DID_ERROR << 16);
 				*busy = 1;
 				return NULL;
 			}
@@ -1759,7 +1759,7 @@ megaraid_mbox_build_cmd(adapter_t *adapter, struct scsi_cmnd *scp, int *busy)
 			return scb;
 
 		default:
-			scp->result = (DID_BAD_TARGET << 16);
+			scp->status.combined = (DID_BAD_TARGET << 16);
 			return NULL;
 		}
 	}
@@ -1767,7 +1767,7 @@ megaraid_mbox_build_cmd(adapter_t *adapter, struct scsi_cmnd *scp, int *busy)
 
 		// Do not allow access to target id > 15 or LUN > 7
 		if (target > 15 || SCP2LUN(scp) > 7) {
-			scp->result = (DID_BAD_TARGET << 16);
+			scp->status.combined = (DID_BAD_TARGET << 16);
 			return NULL;
 		}
 
@@ -1803,13 +1803,13 @@ megaraid_mbox_build_cmd(adapter_t *adapter, struct scsi_cmnd *scp, int *busy)
 
 		// disable channel sweep if fast load option given
 		if (rdev->fast_load) {
-			scp->result = (DID_BAD_TARGET << 16);
+			scp->status.combined = (DID_BAD_TARGET << 16);
 			return NULL;
 		}
 
 		// Allocate a SCB and initialize passthru
 		if (!(scb = megaraid_alloc_scb(adapter, scp))) {
-			scp->result = (DID_ERROR << 16);
+			scp->status.combined = (DID_ERROR << 16);
 			*busy = 1;
 			return NULL;
 		}
@@ -2289,7 +2289,7 @@ megaraid_mbox_dpc(unsigned long devp)
 
 		case 0x00:
 
-			scp->result = (DID_OK << 16);
+			scp->status.combined = (DID_OK << 16);
 			break;
 
 		case 0x02:
@@ -2301,8 +2301,8 @@ megaraid_mbox_dpc(unsigned long devp)
 				memcpy(scp->sense_buffer, pthru->reqsensearea,
 						14);
 
-				scp->result = DRIVER_SENSE << 24 |
-					DID_OK << 16 | CHECK_CONDITION << 1;
+				scp->status.combined = DRIVER_SENSE << 24 |
+					DID_OK << 16 | SAM_STAT_CHECK_CONDITION;
 			}
 			else {
 				if (mbox->cmd == MBOXCMD_EXTPTHRU) {
@@ -2310,20 +2310,20 @@ megaraid_mbox_dpc(unsigned long devp)
 					memcpy(scp->sense_buffer,
 						epthru->reqsensearea, 14);
 
-					scp->result = DRIVER_SENSE << 24 |
+					scp->status.combined = DRIVER_SENSE << 24 |
 						DID_OK << 16 |
-						CHECK_CONDITION << 1;
+						SAM_STAT_CHECK_CONDITION;
 				} else {
 					scp->sense_buffer[0] = 0x70;
 					scp->sense_buffer[2] = ABORTED_COMMAND;
-					scp->result = CHECK_CONDITION << 1;
+					scp->status.combined = SAM_STAT_CHECK_CONDITION;
 				}
 			}
 			break;
 
 		case 0x08:
 
-			scp->result = DID_BUS_BUSY << 16 | status;
+			scp->status.combined = DID_BUS_BUSY << 16 | status;
 			break;
 
 		default:
@@ -2333,8 +2333,8 @@ megaraid_mbox_dpc(unsigned long devp)
 			 * failed
 			 */
 			if (scp->cmnd[0] == TEST_UNIT_READY) {
-				scp->result = DID_ERROR << 16 |
-					RESERVATION_CONFLICT << 1;
+				scp->status.combined = DID_ERROR << 16 |
+					SAM_STAT_RESERVATION_CONFLICT;
 			}
 			else
 			/*
@@ -2344,11 +2344,11 @@ megaraid_mbox_dpc(unsigned long devp)
 			if (status == 1 && (scp->cmnd[0] == RESERVE ||
 					 scp->cmnd[0] == RELEASE)) {
 
-				scp->result = DID_ERROR << 16 |
-					RESERVATION_CONFLICT << 1;
+				scp->status.combined = DID_ERROR << 16 |
+					SAM_STAT_RESERVATION_CONFLICT;
 			}
 			else {
-				scp->result = DID_BAD_TARGET << 16 | status;
+				scp->status.combined = DID_BAD_TARGET << 16 | status;
 			}
 		}
 
@@ -2423,7 +2423,7 @@ megaraid_abort_handler(struct scsi_cmnd *scp)
 			"megaraid: %d[%d:%d], abort from completed list\n",
 				scb->sno, scb->dev_channel, scb->dev_target));
 
-			scp->result = (DID_ABORT << 16);
+			scp->status.combined = (DID_ABORT << 16);
 			scp->scsi_done(scp);
 
 			megaraid_dealloc_scb(adapter, scb);
@@ -2453,7 +2453,7 @@ megaraid_abort_handler(struct scsi_cmnd *scp)
 				"megaraid abort: [%d:%d], driver owner\n",
 				scb->dev_channel, scb->dev_target));
 
-			scp->result = (DID_ABORT << 16);
+			scp->status.combined = (DID_ABORT << 16);
 			scp->scsi_done(scp);
 
 			megaraid_dealloc_scb(adapter, scb);
@@ -2573,7 +2573,7 @@ megaraid_reset_handler(struct scsi_cmnd *scp)
 				scb->sno, scb->dev_channel, scb->dev_target));
 			}
 
-			scb->scp->result = (DID_RESET << 16);
+			scb->scp->status.combined = (DID_RESET << 16);
 			scb->scp->scsi_done(scb->scp);
 
 			megaraid_dealloc_scb(adapter, scb);
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 4d4e9dbe5193..218c38b54be1 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -1784,7 +1784,7 @@ megasas_queue_command(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
 	    scmd->device->host->hostdata;
 
 	if (instance->unload == 1) {
-		scmd->result = DID_NO_CONNECT << 16;
+		scmd->status.combined = DID_NO_CONNECT << 16;
 		scmd->scsi_done(scmd);
 		return 0;
 	}
@@ -1799,21 +1799,21 @@ megasas_queue_command(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
 		    (DID_REQUEUE << 16)) {
 			return SCSI_MLQUEUE_HOST_BUSY;
 		} else {
-			scmd->result = DID_NO_CONNECT << 16;
+			scmd->status.combined = DID_NO_CONNECT << 16;
 			scmd->scsi_done(scmd);
 			return 0;
 		}
 	}
 
 	if (atomic_read(&instance->adprecovery) == MEGASAS_HW_CRITICAL_ERROR) {
-		scmd->result = DID_NO_CONNECT << 16;
+		scmd->status.combined = DID_NO_CONNECT << 16;
 		scmd->scsi_done(scmd);
 		return 0;
 	}
 
 	mr_device_priv_data = scmd->device->hostdata;
 	if (!mr_device_priv_data) {
-		scmd->result = DID_NO_CONNECT << 16;
+		scmd->status.combined = DID_NO_CONNECT << 16;
 		scmd->scsi_done(scmd);
 		return 0;
 	}
@@ -1825,19 +1825,19 @@ megasas_queue_command(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
 		return SCSI_MLQUEUE_DEVICE_BUSY;
 
 
-	scmd->result = 0;
+	scmd->status.combined = 0;
 
 	if (MEGASAS_IS_LOGICAL(scmd->device) &&
 	    (scmd->device->id >= instance->fw_supported_vd_count ||
 		scmd->device->lun)) {
-		scmd->result = DID_BAD_TARGET << 16;
+		scmd->status.combined = DID_BAD_TARGET << 16;
 		goto out_done;
 	}
 
 	if ((scmd->cmnd[0] == SYNCHRONIZE_CACHE) &&
 	    MEGASAS_IS_LOGICAL(scmd->device) &&
 	    (!instance->fw_sync_cache_support)) {
-		scmd->result = DID_OK << 16;
+		scmd->status.combined = DID_OK << 16;
 		goto out_done;
 	}
 
@@ -2744,7 +2744,7 @@ static int megasas_wait_for_outstanding(struct megasas_instance *instance)
 						struct megasas_cmd, list);
 			list_del_init(&reset_cmd->list);
 			if (reset_cmd->scmd) {
-				reset_cmd->scmd->result = DID_REQUEUE << 16;
+				reset_cmd->scmd->status.combined = DID_REQUEUE << 16;
 				dev_notice(&instance->pdev->dev, "%d:%p reset [%02x]\n",
 					reset_index, reset_cmd,
 					reset_cmd->scmd->cmnd[0]);
@@ -3581,7 +3581,7 @@ megasas_complete_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd,
 	case MFI_CMD_LD_WRITE:
 
 		if (alt_status) {
-			cmd->scmd->result = alt_status << 16;
+			cmd->scmd->status.combined = alt_status << 16;
 			exception = 1;
 		}
 
@@ -3599,18 +3599,18 @@ megasas_complete_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd,
 		switch (hdr->cmd_status) {
 
 		case MFI_STAT_OK:
-			cmd->scmd->result = DID_OK << 16;
+			cmd->scmd->status.combined = DID_OK << 16;
 			break;
 
 		case MFI_STAT_SCSI_IO_FAILED:
 		case MFI_STAT_LD_INIT_IN_PROGRESS:
-			cmd->scmd->result =
+			cmd->scmd->status.combined =
 			    (DID_ERROR << 16) | hdr->scsi_status;
 			break;
 
 		case MFI_STAT_SCSI_DONE_WITH_ERROR:
 
-			cmd->scmd->result = (DID_OK << 16) | hdr->scsi_status;
+			cmd->scmd->status.combined = (DID_OK << 16) | hdr->scsi_status;
 
 			if (hdr->scsi_status == SAM_STAT_CHECK_CONDITION) {
 				memset(cmd->scmd->sense_buffer, 0,
@@ -3618,20 +3618,20 @@ megasas_complete_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd,
 				memcpy(cmd->scmd->sense_buffer, cmd->sense,
 				       hdr->sense_len);
 
-				cmd->scmd->result |= DRIVER_SENSE << 24;
+				cmd->scmd->status.combined |= DRIVER_SENSE << 24;
 			}
 
 			break;
 
 		case MFI_STAT_LD_OFFLINE:
 		case MFI_STAT_DEVICE_NOT_FOUND:
-			cmd->scmd->result = DID_BAD_TARGET << 16;
+			cmd->scmd->status.combined = DID_BAD_TARGET << 16;
 			break;
 
 		default:
 			dev_printk(KERN_DEBUG, &instance->pdev->dev, "MFI FW status %#x\n",
 			       hdr->cmd_status);
-			cmd->scmd->result = DID_ERROR << 16;
+			cmd->scmd->status.combined = DID_ERROR << 16;
 			break;
 		}
 
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 2221175ae051..c70e7ce72123 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -2035,23 +2035,23 @@ map_cmd_status(struct fusion_context *fusion,
 	switch (status) {
 
 	case MFI_STAT_OK:
-		scmd->result = DID_OK << 16;
+		scmd->status.combined = DID_OK << 16;
 		break;
 
 	case MFI_STAT_SCSI_IO_FAILED:
 	case MFI_STAT_LD_INIT_IN_PROGRESS:
-		scmd->result = (DID_ERROR << 16) | ext_status;
+		scmd->status.combined = (DID_ERROR << 16) | ext_status;
 		break;
 
 	case MFI_STAT_SCSI_DONE_WITH_ERROR:
 
-		scmd->result = (DID_OK << 16) | ext_status;
+		scmd->status.combined = (DID_OK << 16) | ext_status;
 		if (ext_status == SAM_STAT_CHECK_CONDITION) {
 			memset(scmd->sense_buffer, 0,
 			       SCSI_SENSE_BUFFERSIZE);
 			memcpy(scmd->sense_buffer, sense,
 			       SCSI_SENSE_BUFFERSIZE);
-			scmd->result |= DRIVER_SENSE << 24;
+			scmd->status.combined |= DRIVER_SENSE << 24;
 		}
 
 		/*
@@ -2073,13 +2073,13 @@ map_cmd_status(struct fusion_context *fusion,
 
 	case MFI_STAT_LD_OFFLINE:
 	case MFI_STAT_DEVICE_NOT_FOUND:
-		scmd->result = DID_BAD_TARGET << 16;
+		scmd->status.combined = DID_BAD_TARGET << 16;
 		break;
 	case MFI_STAT_CONFIG_SEQ_MISMATCH:
-		scmd->result = DID_IMM_RETRY << 16;
+		scmd->status.combined = DID_IMM_RETRY << 16;
 		break;
 	default:
-		scmd->result = DID_ERROR << 16;
+		scmd->status.combined = DID_ERROR << 16;
 		break;
 	}
 }
@@ -4699,7 +4699,7 @@ int megasas_task_abort_fusion(struct scsi_cmnd *scmd)
 	if (!mr_device_priv_data) {
 		sdev_printk(KERN_INFO, scmd->device, "device been deleted! "
 			"scmd(%p)\n", scmd);
-		scmd->result = DID_NO_CONNECT << 16;
+		scmd->status.combined = DID_NO_CONNECT << 16;
 		ret = SUCCESS;
 		goto out;
 	}
@@ -4780,7 +4780,7 @@ int megasas_reset_target_fusion(struct scsi_cmnd *scmd)
 	if (!mr_device_priv_data) {
 		sdev_printk(KERN_INFO, scmd->device,
 			    "device been deleted! scmd: (0x%p)\n", scmd);
-		scmd->result = DID_NO_CONNECT << 16;
+		scmd->status.combined = DID_NO_CONNECT << 16;
 		ret = SUCCESS;
 		goto out;
 	}
@@ -4959,7 +4959,7 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int reason)
 					MPI2_FUNCTION_SCSI_IO_REQUEST)
 					fpio_count++;
 
-				scmd_local->result =
+				scmd_local->status.combined =
 					megasas_check_mpio_paths(instance,
 							scmd_local);
 				if (instance->ldio_threshold &&
