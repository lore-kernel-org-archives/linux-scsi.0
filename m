Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8A49C67871
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Jan 2023 14:10:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234982AbjALOKu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Jan 2023 09:10:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230497AbjALOJ6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Jan 2023 09:09:58 -0500
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18B6658D10;
        Thu, 12 Jan 2023 06:05:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1673532319; x=1705068319;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1f7zHLpGMm9g1WnrgGxTA6e76XFBUATSXLYVFXzagpA=;
  b=EuETioCMypNA5iAv05LvpYkrFt6AJajPyOPRqE1NrmOHYGXG792mQcX3
   SSgCAHKr2hAC/BhmM7ihw5DJYnC7f4Y2/7or/L5X5zdBCjZBCGZVycSEK
   n2LnKquQCOhw4Cqk/zVutz7xvCGiYZxhwoiPdYH1RSPVA75/e32lPR9jU
   xy2AEbu6TPVLFd1IHah+jipiAk/2pLTGgaR5NS8tk5pBBbc4dwQejMpjv
   /BHjMS2CD8Zpv8mlub6S1UgAAcloREmOPh1ydB3ynexElm4Gz/PhYxP8n
   7aE2m7J3/IUjcB3P6MN7tHhNdqOwZlYVacwhCN/7fMm0c9H/4qQ6VvFY2
   g==;
X-IronPort-AV: E=Sophos;i="5.97,211,1669046400"; 
   d="scan'208";a="332632749"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 12 Jan 2023 22:05:05 +0800
IronPort-SDR: PC+hahFSnhm7oGzGfLE7OfxADTo+uL5WeCvT4JSG4WQxCd7S0sscAGIuiNLK4WtprygUeGlS9t
 EnBB8pMyU9nSGoRdQIaLRfXw2wPJbRIvpJNfH6QhWqhBm1DFeXNE7y+ur1hC9nKq14H1OIWPsf
 jdiHKaB6CSWrfK631D/KXlgDZlTclWN75eJskpaLDNb/BQCQKBdUOyKj1vqQI0n35vBm7H4pWr
 xtKAq2ILgjMZz+IIWxM8i6Q+Bd5Xe6imdFJD+pvRjoPmdtx4lNTLmTytYoh6D7q+3xfRW4zOCc
 Q8I=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 12 Jan 2023 05:17:09 -0800
IronPort-SDR: tPnPlSHdk/WuxeYIpwzgwjgcaZ4zbIwxsapujAwRoPQAmIymye0ZDQacuzoG9ZbHlxWg13HrrC
 ugzdDVuT7z2OjLNAA2UXFKSPKq4CJVGf0qlD/1oOq+cT40jTGNk7FQSKxYju90ar2s3Joq73OF
 rDDrViqVgM6RriubwKhDQPKYLi+zrZObc4XfebJ9hy6qgRdtwAHmftncvEITOtson4A9/hOqEb
 2N1NYAHYlDqpnkf6pkJ3I6O0OnmyytimpEqpWz9hP0GBgfG14d9/X5MEAbB/4hZ/qTsxaFxVLl
 Z0k=
WDCIronportException: Internal
Received: from unknown (HELO x1-carbon.wdc.com) ([10.225.164.12])
  by uls-op-cesaip01.wdc.com with ESMTP; 12 Jan 2023 06:05:04 -0800
From:   Niklas Cassel <niklas.cassel@wdc.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v2 16/18] scsi: sd: handle read/write CDL timeout failures
Date:   Thu, 12 Jan 2023 15:04:05 +0100
Message-Id: <20230112140412.667308-17-niklas.cassel@wdc.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112140412.667308-1-niklas.cassel@wdc.com>
References: <20230112140412.667308-1-niklas.cassel@wdc.com>
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
 drivers/scsi/scsi_error.c | 46 +++++++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_lib.c   |  4 ++++
 drivers/scsi/scsi_priv.h  |  1 +
 3 files changed, 51 insertions(+)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 51aa5c1e31b5..e7103bf3ab23 100644
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
@@ -691,6 +708,15 @@ enum scsi_disposition scsi_check_sense(struct scsi_cmnd *scmd)
 		}
 		return SUCCESS;
 
+	case COMPLETED:
+		if (sshdr.asc == 0x55 && sshdr.ascq == 0x0a) {
+			set_scsi_ml_byte(scmd, SCSIML_STAT_DL_TIMEOUT);
+			req->cmd_flags |= REQ_FAILFAST_DEV;
+			req->rq_flags |= RQF_QUIET;
+			return SUCCESS;
+		}
+		return SUCCESS;
+
 	default:
 		return SUCCESS;
 	}
@@ -785,6 +811,14 @@ static enum scsi_disposition scsi_eh_completed_normally(struct scsi_cmnd *scmd)
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
@@ -1807,6 +1841,10 @@ bool scsi_noretry_cmd(struct scsi_cmnd *scmd)
 		return !!(req->cmd_flags & REQ_FAILFAST_DRIVER);
 	}
 
+	/* Never retry commands aborted due to a duration limit timeout */
+	if (scsi_ml_byte(scmd->result) == SCSIML_STAT_DL_TIMEOUT)
+		return true;
+
 	if (!scsi_status_is_check_condition(scmd->result))
 		return false;
 
@@ -1966,6 +2004,14 @@ enum scsi_disposition scsi_decide_disposition(struct scsi_cmnd *scmd)
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
index 79cece5eff5d..5923873f09e5 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -602,6 +602,8 @@ static blk_status_t scsi_result_to_blk_status(int result)
 		return BLK_STS_MEDIUM;
 	case SCSIML_STAT_TGT_FAILURE:
 		return BLK_STS_TARGET;
+	case SCSIML_STAT_DL_TIMEOUT:
+		return BLK_STS_DURATION_LIMIT;
 	}
 
 	switch (host_byte(result)) {
@@ -799,6 +801,8 @@ static void scsi_io_completion_action(struct scsi_cmnd *cmd, int result)
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
2.39.0

