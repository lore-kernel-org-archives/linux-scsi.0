Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B087C63718
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Dec 2022 11:03:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbiLHLD0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Dec 2022 06:03:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbiLHLCF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Dec 2022 06:02:05 -0500
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F04435F73;
        Thu,  8 Dec 2022 03:00:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1670497257; x=1702033257;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qEbSqx02Hms4e+VhyDUd/rgwE6Jtv1eQbot0wFgdMSg=;
  b=Fz57JeVDEbkLfm09Bh0O28B6lARe6TDFNUeKIYnSDqEwsqFIFrDC+OxL
   hKCyVBpASqDgZKZC/vVEPz4qvN20kqb5UGkUSbjrrdkStL5Sh/WRLPai2
   /RzgxIqV12CE+71gkyoow4djCxtYPeYXo8p/kLTGsFLUouND19Am9u67W
   9sqaVNARfC7ryx1Zy0H52Kygq5V/7htGqRPBcCoGH5uUwEWTSswIkErBM
   RiIyuLwT3fXYoI+SSta5Ld+lWE35kJa/z/S6I/Xz2fm72K7entkJfJU1p
   w2s+9mhyQNJ2r4T1BPPQomkRKWUgfRIJmoK6OYy0SrpwYrl25StT0O6ey
   A==;
X-IronPort-AV: E=Sophos;i="5.96,227,1665417600"; 
   d="scan'208";a="223333375"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 08 Dec 2022 19:00:57 +0800
IronPort-SDR: njZymEfvw3f9dz+YvmRhXbYzEEb6EV5y+X3tNKdYPYy2fA0d+4EtUtszc7MnDsYaP7lNu1Xbw6
 OCTBGc1ZvG9xja4cEmFcfk6Da2wz35hBNimjr73fymtb2+vZk8qxqnpHDRrt7QJ+CI8zk2pp0c
 Il3opvEUTd6vOBC3jRH5fXmDyZDGjguBgvmpbwFeHFw9ym4v+LmMA8nQtAF4gZnfO9IIvgGitc
 G+Lo9Bn3Foe+Ks5odFvXkgNAhSP78SYbh6yHlCerDmja90HfaaFKhoEUewVtZuc59CVDzhVwN0
 Cus=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Dec 2022 02:13:42 -0800
IronPort-SDR: pmnLZj8r0EJGUg9r3uyUBAul7aXJxI7Ge3x9qxANnkVZbyrANcbbFkSrThUVfQPaq+BgdVN1+F
 KgMpW1wcIJQBiJzPZWwcEfVQRWNfKkjAN8aRtDgSG2LWZjLSqjIiYHZxf5HFZ6/IQpGSfUItfa
 cfqS+u+G91sFqfWAQuoqhv9DFZcthKrDCSSDBVEg021/HzplLMliCx4pUvPBOoB9lRgSKVaeWm
 /sRZn5Ldq1JJ/7hVvd6dCCewRKhxxFvlTlAbczmfl/RVmg4O1e4YtaHcYBv9UAAWfZKIz9hCxm
 EzQ=
WDCIronportException: Internal
Received: from dellx5.wdc.com (HELO x1-carbon.cphwdc) ([10.200.210.81])
  by uls-op-cesaip01.wdc.com with ESMTP; 08 Dec 2022 03:00:57 -0800
From:   Niklas Cassel <niklas.cassel@wdc.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        Niklas Cassel <niklas.cassel@wdc.com>,
        linux-ide@vger.kernel.org
Subject: [PATCH 06/25] ata: libata: allow ata_scsi_set_sense() to not set CHECK_CONDITION
Date:   Thu,  8 Dec 2022 11:59:22 +0100
Message-Id: <20221208105947.2399894-7-niklas.cassel@wdc.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221208105947.2399894-1-niklas.cassel@wdc.com>
References: <20221208105947.2399894-1-niklas.cassel@wdc.com>
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
index 8cb250930c48..c278366370ab 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -1429,7 +1429,8 @@ static void ata_eh_request_sense(struct ata_queued_cmd *qc)
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
index cbb3a7a50816..0e6684ca0315 100644
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
 
@@ -2380,7 +2382,7 @@ static unsigned int ata_scsiop_mode_sense(struct ata_scsi_args *args, u8 *rbuf)
 	return 1;
 
 saving_not_supp:
-	ata_scsi_set_sense(dev, args->cmd, ILLEGAL_REQUEST, 0x39, 0x0);
+	ata_scsi_set_sense(dev, args->cmd, true, ILLEGAL_REQUEST, 0x39, 0x0);
 	 /* "Saving parameters not supported" */
 	return 1;
 }
@@ -3241,11 +3243,11 @@ static unsigned int ata_scsi_write_same_xlat(struct ata_queued_cmd *qc)
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
 
@@ -3471,7 +3473,7 @@ static unsigned int ata_scsi_zbc_in_xlat(struct ata_queued_cmd *qc)
 
 invalid_param_len:
 	/* "Parameter list length error" */
-	ata_scsi_set_sense(qc->dev, scmd, ILLEGAL_REQUEST, 0x1a, 0x0);
+	ata_scsi_set_sense(qc->dev, scmd, true, ILLEGAL_REQUEST, 0x1a, 0x0);
 	return 1;
 }
 
@@ -3549,7 +3551,7 @@ static unsigned int ata_scsi_zbc_out_xlat(struct ata_queued_cmd *qc)
 	return 1;
 invalid_param_len:
 	/* "Parameter list length error" */
-	ata_scsi_set_sense(qc->dev, scmd, ILLEGAL_REQUEST, 0x1a, 0x0);
+	ata_scsi_set_sense(qc->dev, scmd, true, ILLEGAL_REQUEST, 0x1a, 0x0);
 	return 1;
 }
 
@@ -3810,7 +3812,7 @@ static unsigned int ata_scsi_mode_select_xlat(struct ata_queued_cmd *qc)
 
  invalid_param_len:
 	/* "Parameter list length error" */
-	ata_scsi_set_sense(qc->dev, scmd, ILLEGAL_REQUEST, 0x1a, 0x0);
+	ata_scsi_set_sense(qc->dev, scmd, true, ILLEGAL_REQUEST, 0x1a, 0x0);
 	return 1;
 
  skip:
@@ -4166,7 +4168,7 @@ void ata_scsi_simulate(struct ata_device *dev, struct scsi_cmnd *cmd)
 		break;
 
 	case REQUEST_SENSE:
-		ata_scsi_set_sense(dev, cmd, 0, 0, 0);
+		ata_scsi_set_sense(dev, cmd, true, 0, 0, 0);
 		break;
 
 	/* if we reach this, then writeback caching is disabled,
@@ -4198,7 +4200,7 @@ void ata_scsi_simulate(struct ata_device *dev, struct scsi_cmnd *cmd)
 
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
2.38.1

