Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C231C63797
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Jan 2023 14:06:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231594AbjALOG5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Jan 2023 09:06:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232964AbjALOFy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Jan 2023 09:05:54 -0500
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39344551DC;
        Thu, 12 Jan 2023 06:04:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1673532262; x=1705068262;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KhDiB7z5zRoUamoxOmDJuECgZy6X7QOah0MaQzKH+cg=;
  b=IDAqFdDeQsPRAE2GvmunsdoGGK2B/nJt9BrEBdIZORdQXR1iePjZwiHD
   EI+BzWajxoyVk2p5YxNJew0vzMMPfNKRgfDwvruSfnnOOVgGDlnIXeQCp
   4AXryx0VPDjvzpOh7KKvFhTy5y7o5rgvGTNHzz13ZzsAg3IXCqycpsYlU
   dYspvZM2KeyGGByMtFraIBMqs6SASOysJLcKdml73h2qz+zGUVfgTgbuE
   JOlhq/30ErQLWlqZYfWpEiBBMOnR3UdHwT4hpcKeKlatlkkH/6HIH1BDG
   7rCJwVliGTnVY1UDIAgw6D77ctHId2R5cQV/IuiGuIGTLLbQr+pXRgO38
   A==;
X-IronPort-AV: E=Sophos;i="5.97,211,1669046400"; 
   d="scan'208";a="332632645"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 12 Jan 2023 22:04:21 +0800
IronPort-SDR: BzEngncKbA3/Ue0MoESLlW6p1XQdMP2mKxArCeuMgfiv3ToQsSaNf9F1TNp0XUqls3xtF2AwPh
 ghP58WlCCng4J9bNJ1dePiDl/lkJdtiyz99V0DHTojvU9K4i3pKJPxuhQiKMXp6s6x1A4/yGF/
 jIj/4EUNI5aY2aTsmQYaAd4qFo/arMekEfMegXlO02B4ijxza2pNeqGsJTCRdWLPG+Hj27W0dN
 fCwz24/u1N9EXTmSs8sQn5ELOAGT3xj2HNtakvXyE0ARVVpYzeejerRJyHy18unxMMXXozH83L
 nYw=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 12 Jan 2023 05:16:24 -0800
IronPort-SDR: iIeJxRAXL2vPPAsQtvwWJGqKJV8Jd2braiQDeBorBQDYunnoIvrPG4AXrl1tk4A/newp8IYI40
 JWBx/OsedPDMjxyjc1FOsKBF4ay6Qx8tv9dlq5HZ4puoMWHYU7V+P1s+CjjWydhgUuscszmY9m
 c6ojclBFLQrJffLLwEeTOptBjjU7tpfMEy+ljRHzSJ0b8Sgy32PeOCKRHHzEtDxeDXEg48lcmz
 YfKbFBxvVJDcCs2AT97z10wgBhrW0d6XwD8jARNtHgLiM4udDUP25z4hiQoKMcHU+CXBFxd6WF
 WZE=
WDCIronportException: Internal
Received: from unknown (HELO x1-carbon.wdc.com) ([10.225.164.12])
  by uls-op-cesaip01.wdc.com with ESMTP; 12 Jan 2023 06:04:21 -0800
From:   Niklas Cassel <niklas.cassel@wdc.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-block@vger.kernel.org,
        Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v2 01/18] ata: libata: allow ata_scsi_set_sense() to not set CHECK_CONDITION
Date:   Thu, 12 Jan 2023 15:03:50 +0100
Message-Id: <20230112140412.667308-2-niklas.cassel@wdc.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112140412.667308-1-niklas.cassel@wdc.com>
References: <20230112140412.667308-1-niklas.cassel@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Current ata_scsi_set_sense() calls scsi_build_sense(), which,
in addition to setting the sense data, unconditionally sets the
scsicmd->result to SAM_STAT_CHECK_CONDITION.

For Command Duration Limits policy 0xD:
The device shall complete the command without error (SAM_STAT_GOOD)
with the additional sense code set to DATA CURRENTLY UNAVAILABLE.

It is perfectly fine to have sense data for a command that returned
completion without error.

In order to support for CDL policy 0xD, we have to remove this
assumption that having sense data means that the command failed
(SAM_STAT_CHECK_CONDITION).

Add a new parameter to ata_scsi_set_sense() to allow us to set
sense data without unconditionally setting SAM_STAT_CHECK_CONDITION.
This new parameter will be used in a follow-up patch.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 drivers/ata/libata-eh.c   |  3 ++-
 drivers/ata/libata-sata.c |  4 ++--
 drivers/ata/libata-scsi.c | 38 ++++++++++++++++++++------------------
 drivers/ata/libata.h      |  4 ++--
 4 files changed, 26 insertions(+), 23 deletions(-)

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index a6c901811802..3521f3f67f5a 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -1432,7 +1432,8 @@ static void ata_eh_request_sense(struct ata_queued_cmd *qc)
 	/* Ignore err_mask; ATA_ERR might be set */
 	if (tf.status & ATA_SENSE) {
 		if (ata_scsi_sense_is_valid(tf.lbah, tf.lbam, tf.lbal)) {
-			ata_scsi_set_sense(dev, cmd, tf.lbah, tf.lbam, tf.lbal);
+			ata_scsi_set_sense(dev, cmd, true, tf.lbah, tf.lbam,
+					   tf.lbal);
 			qc->flags |= ATA_QCFLAG_SENSE_VALID;
 		}
 	} else {
diff --git a/drivers/ata/libata-sata.c b/drivers/ata/libata-sata.c
index f3e7396e3191..414d7f8a95bf 100644
--- a/drivers/ata/libata-sata.c
+++ b/drivers/ata/libata-sata.c
@@ -1471,8 +1471,8 @@ void ata_eh_analyze_ncq_error(struct ata_link *link)
 		asc = (qc->result_tf.auxiliary >> 8) & 0xff;
 		ascq = qc->result_tf.auxiliary & 0xff;
 		if (ata_scsi_sense_is_valid(sense_key, asc, ascq)) {
-			ata_scsi_set_sense(dev, qc->scsicmd, sense_key, asc,
-					   ascq);
+			ata_scsi_set_sense(dev, qc->scsicmd, true, sense_key,
+					   asc, ascq);
 			ata_scsi_set_sense_information(dev, qc->scsicmd,
 						       &qc->result_tf);
 			qc->flags |= ATA_QCFLAG_SENSE_VALID;
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index aa338f10cef2..6d4ee296450e 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -205,14 +205,16 @@ bool ata_scsi_sense_is_valid(u8 sk, u8 asc, u8 ascq)
 }
 
 void ata_scsi_set_sense(struct ata_device *dev, struct scsi_cmnd *cmd,
-			u8 sk, u8 asc, u8 ascq)
+			bool check_condition, u8 sk, u8 asc, u8 ascq)
 {
 	bool d_sense = (dev->flags & ATA_DFLAG_D_SENSE);
 
 	if (!cmd)
 		return;
 
-	scsi_build_sense(cmd, d_sense, sk, asc, ascq);
+	scsi_build_sense_buffer(d_sense, cmd->sense_buffer, sk, asc, ascq);
+	if (check_condition)
+		set_status_byte(cmd, SAM_STAT_CHECK_CONDITION);
 }
 
 void ata_scsi_set_sense_information(struct ata_device *dev,
@@ -235,7 +237,7 @@ void ata_scsi_set_sense_information(struct ata_device *dev,
 static void ata_scsi_set_invalid_field(struct ata_device *dev,
 				       struct scsi_cmnd *cmd, u16 field, u8 bit)
 {
-	ata_scsi_set_sense(dev, cmd, ILLEGAL_REQUEST, 0x24, 0x0);
+	ata_scsi_set_sense(dev, cmd, true, ILLEGAL_REQUEST, 0x24, 0x0);
 	/* "Invalid field in CDB" */
 	scsi_set_sense_field_pointer(cmd->sense_buffer, SCSI_SENSE_BUFFERSIZE,
 				     field, bit, 1);
@@ -245,7 +247,7 @@ static void ata_scsi_set_invalid_parameter(struct ata_device *dev,
 					   struct scsi_cmnd *cmd, u16 field)
 {
 	/* "Invalid field in parameter list" */
-	ata_scsi_set_sense(dev, cmd, ILLEGAL_REQUEST, 0x26, 0x0);
+	ata_scsi_set_sense(dev, cmd, true, ILLEGAL_REQUEST, 0x26, 0x0);
 	scsi_set_sense_field_pointer(cmd->sense_buffer, SCSI_SENSE_BUFFERSIZE,
 				     field, 0xff, 0);
 }
@@ -914,7 +916,7 @@ static void ata_gen_passthru_sense(struct ata_queued_cmd *qc)
 	    tf->status & (ATA_BUSY | ATA_DF | ATA_ERR | ATA_DRQ)) {
 		ata_to_sense_error(qc->ap->print_id, tf->status, tf->error,
 				   &sense_key, &asc, &ascq, verbose);
-		ata_scsi_set_sense(qc->dev, cmd, sense_key, asc, ascq);
+		ata_scsi_set_sense(qc->dev, cmd, true, sense_key, asc, ascq);
 	} else {
 		/*
 		 * ATA PASS-THROUGH INFORMATION AVAILABLE
@@ -1005,7 +1007,7 @@ static void ata_gen_ata_sense(struct ata_queued_cmd *qc)
 	if (ata_dev_disabled(dev)) {
 		/* Device disabled after error recovery */
 		/* LOGICAL UNIT NOT READY, HARD RESET REQUIRED */
-		ata_scsi_set_sense(dev, cmd, NOT_READY, 0x04, 0x21);
+		ata_scsi_set_sense(dev, cmd, true, NOT_READY, 0x04, 0x21);
 		return;
 	}
 	/* Use ata_to_sense_error() to map status register bits
@@ -1015,12 +1017,12 @@ static void ata_gen_ata_sense(struct ata_queued_cmd *qc)
 	    tf->status & (ATA_BUSY | ATA_DF | ATA_ERR | ATA_DRQ)) {
 		ata_to_sense_error(qc->ap->print_id, tf->status, tf->error,
 				   &sense_key, &asc, &ascq, verbose);
-		ata_scsi_set_sense(dev, cmd, sense_key, asc, ascq);
+		ata_scsi_set_sense(dev, cmd, true, sense_key, asc, ascq);
 	} else {
 		/* Could not decode error */
 		ata_dev_warn(dev, "could not decode error status 0x%x err_mask 0x%x\n",
 			     tf->status, qc->err_mask);
-		ata_scsi_set_sense(dev, cmd, ABORTED_COMMAND, 0, 0);
+		ata_scsi_set_sense(dev, cmd, true, ABORTED_COMMAND, 0, 0);
 		return;
 	}
 
@@ -1496,7 +1498,7 @@ static unsigned int ata_scsi_verify_xlat(struct ata_queued_cmd *qc)
 	return 1;
 
 out_of_range:
-	ata_scsi_set_sense(qc->dev, scmd, ILLEGAL_REQUEST, 0x21, 0x0);
+	ata_scsi_set_sense(qc->dev, scmd, true, ILLEGAL_REQUEST, 0x21, 0x0);
 	/* "Logical Block Address out of range" */
 	return 1;
 
@@ -1631,7 +1633,7 @@ static unsigned int ata_scsi_rw_xlat(struct ata_queued_cmd *qc)
 	return 1;
 
 out_of_range:
-	ata_scsi_set_sense(qc->dev, scmd, ILLEGAL_REQUEST, 0x21, 0x0);
+	ata_scsi_set_sense(qc->dev, scmd, true, ILLEGAL_REQUEST, 0x21, 0x0);
 	/* "Logical Block Address out of range" */
 	return 1;
 
@@ -2354,7 +2356,7 @@ static unsigned int ata_scsiop_mode_sense(struct ata_scsi_args *args, u8 *rbuf)
 	return 1;
 
 saving_not_supp:
-	ata_scsi_set_sense(dev, args->cmd, ILLEGAL_REQUEST, 0x39, 0x0);
+	ata_scsi_set_sense(dev, args->cmd, true, ILLEGAL_REQUEST, 0x39, 0x0);
 	 /* "Saving parameters not supported" */
 	return 1;
 }
@@ -3215,11 +3217,11 @@ static unsigned int ata_scsi_write_same_xlat(struct ata_queued_cmd *qc)
 	return 1;
 invalid_param_len:
 	/* "Parameter list length error" */
-	ata_scsi_set_sense(dev, scmd, ILLEGAL_REQUEST, 0x1a, 0x0);
+	ata_scsi_set_sense(dev, scmd, true, ILLEGAL_REQUEST, 0x1a, 0x0);
 	return 1;
 invalid_opcode:
 	/* "Invalid command operation code" */
-	ata_scsi_set_sense(dev, scmd, ILLEGAL_REQUEST, 0x20, 0x0);
+	ata_scsi_set_sense(dev, scmd, true, ILLEGAL_REQUEST, 0x20, 0x0);
 	return 1;
 }
 
@@ -3446,7 +3448,7 @@ static unsigned int ata_scsi_zbc_in_xlat(struct ata_queued_cmd *qc)
 
 invalid_param_len:
 	/* "Parameter list length error" */
-	ata_scsi_set_sense(qc->dev, scmd, ILLEGAL_REQUEST, 0x1a, 0x0);
+	ata_scsi_set_sense(qc->dev, scmd, true, ILLEGAL_REQUEST, 0x1a, 0x0);
 	return 1;
 }
 
@@ -3524,7 +3526,7 @@ static unsigned int ata_scsi_zbc_out_xlat(struct ata_queued_cmd *qc)
 	return 1;
 invalid_param_len:
 	/* "Parameter list length error" */
-	ata_scsi_set_sense(qc->dev, scmd, ILLEGAL_REQUEST, 0x1a, 0x0);
+	ata_scsi_set_sense(qc->dev, scmd, true, ILLEGAL_REQUEST, 0x1a, 0x0);
 	return 1;
 }
 
@@ -3785,7 +3787,7 @@ static unsigned int ata_scsi_mode_select_xlat(struct ata_queued_cmd *qc)
 
  invalid_param_len:
 	/* "Parameter list length error" */
-	ata_scsi_set_sense(qc->dev, scmd, ILLEGAL_REQUEST, 0x1a, 0x0);
+	ata_scsi_set_sense(qc->dev, scmd, true, ILLEGAL_REQUEST, 0x1a, 0x0);
 	return 1;
 
  skip:
@@ -4141,7 +4143,7 @@ void ata_scsi_simulate(struct ata_device *dev, struct scsi_cmnd *cmd)
 		break;
 
 	case REQUEST_SENSE:
-		ata_scsi_set_sense(dev, cmd, 0, 0, 0);
+		ata_scsi_set_sense(dev, cmd, true, 0, 0, 0);
 		break;
 
 	/* if we reach this, then writeback caching is disabled,
@@ -4173,7 +4175,7 @@ void ata_scsi_simulate(struct ata_device *dev, struct scsi_cmnd *cmd)
 
 	/* all other commands */
 	default:
-		ata_scsi_set_sense(dev, cmd, ILLEGAL_REQUEST, 0x20, 0x0);
+		ata_scsi_set_sense(dev, cmd, true, ILLEGAL_REQUEST, 0x20, 0x0);
 		/* "Invalid command operation code" */
 		break;
 	}
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index 2cd6124a01e8..5481d29bb273 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -115,8 +115,8 @@ extern int ata_scsi_add_hosts(struct ata_host *host,
 extern void ata_scsi_scan_host(struct ata_port *ap, int sync);
 extern int ata_scsi_offline_dev(struct ata_device *dev);
 extern bool ata_scsi_sense_is_valid(u8 sk, u8 asc, u8 ascq);
-extern void ata_scsi_set_sense(struct ata_device *dev,
-			       struct scsi_cmnd *cmd, u8 sk, u8 asc, u8 ascq);
+extern void ata_scsi_set_sense(struct ata_device *dev, struct scsi_cmnd *cmd,
+			       bool check_condition, u8 sk, u8 asc, u8 ascq);
 extern void ata_scsi_set_sense_information(struct ata_device *dev,
 					   struct scsi_cmnd *cmd,
 					   const struct ata_taskfile *tf);
-- 
2.39.0

