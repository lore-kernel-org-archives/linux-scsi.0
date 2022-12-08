Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69127C4332F
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Dec 2022 11:04:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbiLHLEV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Dec 2022 06:04:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229902AbiLHLDa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Dec 2022 06:03:30 -0500
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D14F89300
        for <linux-scsi@vger.kernel.org>; Thu,  8 Dec 2022 03:01:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1670497299; x=1702033299;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=oLwoD0k+2ptuNw6dbgtNnXCNXdqKGfrc6HYOeC/bJcE=;
  b=WljUvz0i5vbq8MQl91Yjyx3FMnaKIdCIuowWWngwycOKkQlS/ap2GzMt
   4ZGUh4V/6AFDG0UKhUB3HEK99z9m/uIBunGtMGaYnBwJOq7aImm8RhICb
   Le5kxZqsehsJrpQ2JW6MwiS0RZxM7C4m33ssEO5C8eUSwmu3JJHdnX8U6
   sif44QEt8AHA/sJDC9Xkmp8OFw+OzRgCRtDBqheUc9ebIOLee9p6I1Bz9
   XlLdybkm0+FrQmEPGQXDWvlOi5nmCnwy3swdd+H2lEwzIR07giak+jbau
   gyIEc/oQPuuf8P2sHzaLcprI062siXCzxwTrlGLYXM3/TZTOKv7wrm9qh
   g==;
X-IronPort-AV: E=Sophos;i="5.96,227,1665417600"; 
   d="scan'208";a="223333434"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 08 Dec 2022 19:01:38 +0800
IronPort-SDR: SPeOVw9LIP5DYoilZ9/TEdzgo2M5nZz+RdjoXwIDxvdtLYBRYyJg6d/qYAKiegdg/xV6kHVZlH
 HEuj6yWvt88TYf6BUPRnawo893y7Q5PKkvMKZk1skxcBxToklYpYc/69IC1D+iR9Mp3i17tae1
 L5CzKVCbpr1iPqUlIuZQpiTo9CLJt7uZqNcWYFNKxnsKUtxmNXGPARpytEMpvQwCguDhDj0B+u
 2kyDV74/0BOqPmxbE4SjHi78k8/UNMQ3JyAkrGqjwG/o+FPk8BRp9cr1KQIW2SgRIwHNVUZCXm
 hwg=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Dec 2022 02:14:24 -0800
IronPort-SDR: 0MlWO8RGTZ4JDQtZ+BueoiXAJbEftH5NYVB3l3fZdmPG9mf3hnvS5450AcoR8i18YpXSWlSeGD
 xTBcT8J8MayT+ci7Bxa3h+PZRmCN6U7czKaW7X/GT/iwwLXdT0jZnMP+2JWUpWSbrjnQ2aLzCq
 mCUmYXC+77PaHQsTZh38sXJ2Kna0xx/lgsgmeRVDIlUBxktLyCr2kq6/vdKXe6z0ViilS2hzv2
 WgLcaXVZjygN3APdagSLcuhmiIUUEe+lpegXG96yfLqUkL7dTrmQxh00/mMGm6S254N30BQJhn
 36w=
WDCIronportException: Internal
Received: from dellx5.wdc.com (HELO x1-carbon.cphwdc) ([10.200.210.81])
  by uls-op-cesaip01.wdc.com with ESMTP; 08 Dec 2022 03:01:38 -0800
From:   Niklas Cassel <niklas.cassel@wdc.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Subject: [PATCH 23/25] scsi: sd: handle read/write CDL timeout failures
Date:   Thu,  8 Dec 2022 11:59:39 +0100
Message-Id: <20221208105947.2399894-24-niklas.cassel@wdc.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221208105947.2399894-1-niklas.cassel@wdc.com>
References: <20221208105947.2399894-1-niklas.cassel@wdc.com>
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
index 51aa5c1e31b5..1bdab5385985 100644
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
+	if (get_scsi_ml_byte(scmd->result) == SCSIML_STAT_DL_TIMEOUT)
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
index e64fd8f495d7..4f317c6593aa 100644
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
index 4f97e126c6fb..f8da92428ff6 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -27,6 +27,7 @@ enum scsi_ml_status {
 	SCSIML_STAT_NOSPC		= 0x02,	/* Space allocation on the dev failed */
 	SCSIML_STAT_MED_ERROR		= 0x03,	/* Medium error */
 	SCSIML_STAT_TGT_FAILURE		= 0x04,	/* Permanent target failure */
+	SCSIML_STAT_DL_TIMEOUT		= 0x05, /* Command Duration Limit timeout */
 };
 
 static inline u8 get_scsi_ml_byte(int result)
-- 
2.38.1

