Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05769C61DA4
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 21:57:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230416AbjCIV5N (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 16:57:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231232AbjCIV4K (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 16:56:10 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA90AF4D96;
        Thu,  9 Mar 2023 13:55:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1678398959; x=1709934959;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mmP5xhNzgcv2fg9WGa4um6nD+0nuRWAD43QMcPgLImE=;
  b=dETs0L99wD7yxb7s/3m5Uh6qPhQx5lxADDrtBNqmSSc1vYlto27vmvpn
   bU85W0GtlpjcM0At4OviPmwfA8ugFMNm2waU/VT2XI27+eay0JXSrxC2Y
   1iexaK5kdZo3hoYAKW0P23lmhRxoNhfHEOA78TMaiv+fQGMbe5B8bg7QT
   SVgoiP8aTIK6T7DYkhq9cz/N0XNsqQlPJjt5k3S/I7UnADrec0m9TWkWR
   6TUZE4ZW70SAUqB8dj75iriroO5Ok/GcGEcn7QVSERtl1v3aBpEBC+KUR
   aXJaPRO1JkB+2UFBFLjry+bepwngwayPMgBBll5agU6jZ5ozWOD+MeDSA
   Q==;
X-IronPort-AV: E=Sophos;i="5.98,247,1673884800"; 
   d="scan'208";a="225271030"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 10 Mar 2023 05:55:59 +0800
IronPort-SDR: OH7ARXoip+2Ozlq7+0cIqu7YlL5Cd82BPa18KG81NUDBxwtBmI0mjM5aizTcLO4wuTn/uMmO+K
 guY7QLn6hWkt8ajBwBzJcLGQ8Rc1a2kgcgsl0uv9Ka7KNwDcFvTw7g0iCuu6WeAEkKosUDZDSi
 klJRHgyL/8lacAM2EFAutP8LMYGmK0iTwKTeg+5c4JpyvcYYPa0cvRXhs2LCmeLFGkq8O9HB4/
 Ll9K+NvkvV4DYm9/LX1yhSF1tOKWIKcgX8qpMbIE0bSda0/RXqc/cz2Q7Z1OKlG/6onVA840cs
 ezA=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 09 Mar 2023 13:06:53 -0800
IronPort-SDR: fgyAYIZClVEdcBaXQ2JtP9R8LrxgXHODlgB3SsiJgClfnXwOmuNakKad3BzwzziBnt7t59muYq
 899srIBNJAI83UrhtIE3XaGSDbB8+gHkSzN74GZT7hJFkQMCEpjMM/q3NEXiQCs/NwU7rvi8Yt
 lEb5PEK4ZQ9rqw5/Rut1iQI5vvTJvnbrjhpHxTzUk2p+cqfrr85U/2BEV6Hu1+fVShqj4kHlgP
 8S2uw1A5/sVxzXMtMOPDASJPVp1UkVvZYqq8bRj5jkz3s2Q9Ei6ynbciDZtecr1YFTe96jeGAS
 ZSk=
WDCIronportException: Internal
Received: from unknown (HELO x1-carbon.wdc.com) ([10.225.164.41])
  by uls-op-cesaip01.wdc.com with ESMTP; 09 Mar 2023 13:55:58 -0800
From:   Niklas Cassel <niklas.cassel@wdc.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v4 11/19] scsi: sd: handle read/write CDL timeout failures
Date:   Thu,  9 Mar 2023 22:55:03 +0100
Message-Id: <20230309215516.3800571-12-niklas.cassel@wdc.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230309215516.3800571-1-niklas.cassel@wdc.com>
References: <20230309215516.3800571-1-niklas.cassel@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Commands using a duration limit descriptor that has limit policies set
to a value other than 0x0 may be failed by the device if one of the
limits are exceeded. For such commands, since the failure is the result
of the user duration limit configuration and workload, the commands
should not be retried and terminated immediately. Furthermore, to allow
the user to differentiate these "soft" failures from hard errors due to
hardware problem, a different error code than EIO should be returned.

There are 2 cases to consider:
(1) The failure is due to a limit policy failing the command with a
check condition sense key, that is, any limit policy other than 0xD.
For this case, scsi_check_sense() is modified to detect failures with
the ABORTED COMMAND sense key and the COMMAND TIMEOUT BEFORE PROCESSING
or COMMAND TIMEOUT DURING PROCESSING or COMMAND TIMEOUT DURING
PROCESSING DUE TO ERROR RECOVERY additional sense code. For these
failures, a SUCCESS disposition is returned so that
scsi_finish_command() is called to terminate the command.

(2) The failure is due to a limit policy set to 0xD, which result in the
command being terminated with a GOOD status, COMPLETED sense key, and
DATA CURRENTLY UNAVAILABLE additional sense code. To handle this case,
the scsi_check_sense() is modified to return a SUCCESS disposition so
that scsi_finish_command() is called to terminate the command.
In addition, scsi_decide_disposition() has to be modified to see if a
command being terminated with GOOD status has sense data.
This is as defined in SCSI Primary Commands - 6 (SPC-6), so all
according to spec, even if GOOD status commands were not checked before.

If scsi_check_sense() detects sense data representing a duration limit,
scsi_check_sense() will set the newly introduced SCSI ML byte
SCSIML_STAT_DL_TIMEOUT. This SCSI ML byte is checked in
scsi_noretry_cmd(), so that a command that failed because of a CDL
timeout cannot be retried. The SCSI ML byte is also checked in
scsi_result_to_blk_status() to complete the command request with the
BLK_STS_DURATION_LIMIT status, which result in the user seeing ETIME
errors for the failed commands.

Co-developed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 drivers/scsi/scsi_error.c | 45 +++++++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_lib.c   |  4 ++++
 drivers/scsi/scsi_priv.h  |  1 +
 3 files changed, 50 insertions(+)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index cf5ec5f5f4f6..dc85a75b33d9 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -536,6 +536,7 @@ static inline void set_scsi_ml_byte(struct scsi_cmnd *cmd, u8 status)
  */
 enum scsi_disposition scsi_check_sense(struct scsi_cmnd *scmd)
 {
+	struct request *req = scsi_cmd_to_rq(scmd);
 	struct scsi_device *sdev = scmd->device;
 	struct scsi_sense_hdr sshdr;
 
@@ -595,6 +596,22 @@ enum scsi_disposition scsi_check_sense(struct scsi_cmnd *scmd)
 		if (sshdr.asc == 0x10) /* DIF */
 			return SUCCESS;
 
+		/*
+		 * Check aborts due to command duration limit policy:
+		 * ABORTED COMMAND additional sense code with the
+		 * COMMAND TIMEOUT BEFORE PROCESSING or
+		 * COMMAND TIMEOUT DURING PROCESSING or
+		 * COMMAND TIMEOUT DURING PROCESSING DUE TO ERROR RECOVERY
+		 * additional sense code qualifiers.
+		 */
+		if (sshdr.asc == 0x2e &&
+		    sshdr.ascq >= 0x01 && sshdr.ascq <= 0x03) {
+			set_scsi_ml_byte(scmd, SCSIML_STAT_DL_TIMEOUT);
+			req->cmd_flags |= REQ_FAILFAST_DEV;
+			req->rq_flags |= RQF_QUIET;
+			return SUCCESS;
+		}
+
 		if (sshdr.asc == 0x44 && sdev->sdev_bflags & BLIST_RETRY_ITF)
 			return ADD_TO_MLQUEUE;
 		if (sshdr.asc == 0xc1 && sshdr.ascq == 0x01 &&
@@ -691,6 +708,14 @@ enum scsi_disposition scsi_check_sense(struct scsi_cmnd *scmd)
 		}
 		return SUCCESS;
 
+	case COMPLETED:
+		if (sshdr.asc == 0x55 && sshdr.ascq == 0x0a) {
+			set_scsi_ml_byte(scmd, SCSIML_STAT_DL_TIMEOUT);
+			req->cmd_flags |= REQ_FAILFAST_DEV;
+			req->rq_flags |= RQF_QUIET;
+		}
+		return SUCCESS;
+
 	default:
 		return SUCCESS;
 	}
@@ -785,6 +810,14 @@ static enum scsi_disposition scsi_eh_completed_normally(struct scsi_cmnd *scmd)
 	switch (get_status_byte(scmd)) {
 	case SAM_STAT_GOOD:
 		scsi_handle_queue_ramp_up(scmd->device);
+		if (scmd->sense_buffer && SCSI_SENSE_VALID(scmd))
+			/*
+			 * If we have sense data, call scsi_check_sense() in
+			 * order to set the correct SCSI ML byte (if any).
+			 * No point in checking the return value, since the
+			 * command has already completed successfully.
+			 */
+			scsi_check_sense(scmd);
 		fallthrough;
 	case SAM_STAT_COMMAND_TERMINATED:
 		return SUCCESS;
@@ -1807,6 +1840,10 @@ bool scsi_noretry_cmd(struct scsi_cmnd *scmd)
 		return !!(req->cmd_flags & REQ_FAILFAST_DRIVER);
 	}
 
+	/* Never retry commands aborted due to a duration limit timeout */
+	if (scsi_ml_byte(scmd->result) == SCSIML_STAT_DL_TIMEOUT)
+		return true;
+
 	if (!scsi_status_is_check_condition(scmd->result))
 		return false;
 
@@ -1966,6 +2003,14 @@ enum scsi_disposition scsi_decide_disposition(struct scsi_cmnd *scmd)
 		if (scmd->cmnd[0] == REPORT_LUNS)
 			scmd->device->sdev_target->expecting_lun_change = 0;
 		scsi_handle_queue_ramp_up(scmd->device);
+		if (scmd->sense_buffer && SCSI_SENSE_VALID(scmd))
+			/*
+			 * If we have sense data, call scsi_check_sense() in
+			 * order to set the correct SCSI ML byte (if any).
+			 * No point in checking the return value, since the
+			 * command has already completed successfully.
+			 */
+			scsi_check_sense(scmd);
 		fallthrough;
 	case SAM_STAT_COMMAND_TERMINATED:
 		return SUCCESS;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 633c4e8af830..b894432ca0b9 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -601,6 +601,8 @@ static blk_status_t scsi_result_to_blk_status(int result)
 		return BLK_STS_MEDIUM;
 	case SCSIML_STAT_TGT_FAILURE:
 		return BLK_STS_TARGET;
+	case SCSIML_STAT_DL_TIMEOUT:
+		return BLK_STS_DURATION_LIMIT;
 	}
 
 	switch (host_byte(result)) {
@@ -798,6 +800,8 @@ static void scsi_io_completion_action(struct scsi_cmnd *cmd, int result)
 				blk_stat = BLK_STS_ZONE_OPEN_RESOURCE;
 			}
 			break;
+		case COMPLETED:
+			fallthrough;
 		default:
 			action = ACTION_FAIL;
 			break;
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 74324fba4281..f42388ecb024 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -27,6 +27,7 @@ enum scsi_ml_status {
 	SCSIML_STAT_NOSPC		= 0x02,	/* Space allocation on the dev failed */
 	SCSIML_STAT_MED_ERROR		= 0x03,	/* Medium error */
 	SCSIML_STAT_TGT_FAILURE		= 0x04,	/* Permanent target failure */
+	SCSIML_STAT_DL_TIMEOUT		= 0x05, /* Command Duration Limit timeout */
 };
 
 static inline u8 scsi_ml_byte(int result)
-- 
2.39.2

