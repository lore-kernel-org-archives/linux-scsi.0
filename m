Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B78DC6FD19
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 21:57:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231284AbjCIV5z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 16:57:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231270AbjCIV4o (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 16:56:44 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 262A9F6386;
        Thu,  9 Mar 2023 13:56:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1678398965; x=1709934965;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=U56GFe28NZXQ6UkI4778Mu/NlPLVOeSg97GcX8sR+Hw=;
  b=Xl81mVwZnNt1gzYRnO+K8B9A2QW94V6M0Mz6eK0N9eezJiKYc9xfkUS4
   /rAqza7gP1qMpNJuAa9YmTR6f/9PLCB9NhXxN47ei43mVwtf+XWYeTqIg
   OGJnJkKje84StLUgLRqYc1DY9r2H+KCRi/6wrYMQtXaQPS6KOFesx00YV
   70uzkLNmvTkK0L3bGXrLjLSj2ndkGdibCdI9z66IyVDy5jymVgTflVeqp
   QLdmrCUdrfsvqjihS3HLOTAVullYvElB6SuYDWGk7eV5kojqR+ONuybFU
   i6Wt3v3I208HAc+jBjsRsIxFfBz9sn4MeG1erfkSEkPThK4pqGGco+tvy
   g==;
X-IronPort-AV: E=Sophos;i="5.98,247,1673884800"; 
   d="scan'208";a="225271035"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 10 Mar 2023 05:56:04 +0800
IronPort-SDR: 0H82iQ4Z4d8M8XdXREcI7Kg4fj3UEaCTqiEvfEufUpcZtr+fb8cACTJ0PqZ3ScNMcPWMIa4OhZ
 s0OkzQxyI8tGemnCmj807/DFBJqg1QPmqulPVTgECLpv+z764ZWslQJi67q262UpcIb6rZOH5e
 esYreoCs83fkCZEscxx5itjSYpzO/MwvGaa/uKV4Le7jvh777Pe9pbi3H4//6Kqxe+Rf3VHtI3
 ZCm8g2D/gqHr0KEmAFflszSVL1UDaqhi9Mhivxt9Srr1keWP7RLbsYmsQ/71Wl0vvyOg/l/NZ/
 N4E=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 09 Mar 2023 13:06:58 -0800
IronPort-SDR: 9tD9TIweKFMYAPLajH/piobJjD90VI+NrIMjj2kW5/qCxTmMlBNTWSPxEVFeXJiU3dLqjqr1Pl
 maUf/moKRiUqzuFd4taDfyOg9poGj1biZrXqBKcWEbuJYZfTgSJnWJ7sOnLimJD0gUUS7njJBZ
 K8c8w0YIIBlh5n1L4e4QNE69DuVb8JzUaqRhMiImySm61zypsz6fA9oUMhW5YtJ3OAaGqcYdp8
 zKk+TrSjz/Yg59v5Fpxq0omKaJx/NyGy4lYPvrAvOif0ogRJWHA9e9LtIboAuUP/4Mp+/k5LeX
 pHo=
WDCIronportException: Internal
Received: from unknown (HELO x1-carbon.wdc.com) ([10.225.164.41])
  by uls-op-cesaip01.wdc.com with ESMTP; 09 Mar 2023 13:56:03 -0800
From:   Niklas Cassel <niklas.cassel@wdc.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v4 13/19] ata: libata: change ata_eh_request_sense() to not set CHECK_CONDITION
Date:   Thu,  9 Mar 2023 22:55:05 +0100
Message-Id: <20230309215516.3800571-14-niklas.cassel@wdc.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230309215516.3800571-1-niklas.cassel@wdc.com>
References: <20230309215516.3800571-1-niklas.cassel@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Currently, ata_eh_request_sense() unconditionally sets the scsicmd->result
to SAM_STAT_CHECK_CONDITION.

For Command Duration Limits policy 0xD:
The device shall complete the command without error (SAM_STAT_GOOD)
with the additional sense code set to DATA CURRENTLY UNAVAILABLE.

It is perfectly fine to have sense data for a command that returned
completion without error.

In order to support for CDL policy 0xD, we have to remove this
assumption that having sense data means that the command failed
(SAM_STAT_CHECK_CONDITION).

Change ata_eh_request_sense() to not set SAM_STAT_CHECK_CONDITION,
and instead move the setting of SAM_STAT_CHECK_CONDITION to the single
caller that wants SAM_STAT_CHECK_CONDITION set, that way
ata_eh_request_sense() can be reused in a follow-up patch that adds
support for CDL policy 0xD.

The only caller of ata_eh_request_sense() is protected by:
if (!(qc->flags & ATA_QCFLAG_SENSE_VALID)), so we can remove this
duplicated check from ata_eh_request_sense() itself.

Additionally, ata_eh_request_sense() is only called from
ata_eh_analyze_tf(), which is only called when iteratating the QCs using
ata_qc_for_each_raw(), which does not include the internal tag,
so cmd can never be NULL (all non-internal commands have qc->scsicmd set),
so remove the !cmd check as well.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/ata/libata-eh.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index a6c901811802..598ae07195b6 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -1401,8 +1401,11 @@ unsigned int atapi_eh_tur(struct ata_device *dev, u8 *r_sense_key)
  *
  *	LOCKING:
  *	Kernel thread context (may sleep).
+ *
+ *	RETURNS:
+ *	true if sense data could be fetched, false otherwise.
  */
-static void ata_eh_request_sense(struct ata_queued_cmd *qc)
+static bool ata_eh_request_sense(struct ata_queued_cmd *qc)
 {
 	struct scsi_cmnd *cmd = qc->scsicmd;
 	struct ata_device *dev = qc->dev;
@@ -1411,15 +1414,12 @@ static void ata_eh_request_sense(struct ata_queued_cmd *qc)
 
 	if (ata_port_is_frozen(qc->ap)) {
 		ata_dev_warn(dev, "sense data available but port frozen\n");
-		return;
+		return false;
 	}
 
-	if (!cmd || qc->flags & ATA_QCFLAG_SENSE_VALID)
-		return;
-
 	if (!ata_id_sense_reporting_enabled(dev->id)) {
 		ata_dev_warn(qc->dev, "sense data reporting disabled\n");
-		return;
+		return false;
 	}
 
 	ata_tf_init(dev, &tf);
@@ -1432,13 +1432,19 @@ static void ata_eh_request_sense(struct ata_queued_cmd *qc)
 	/* Ignore err_mask; ATA_ERR might be set */
 	if (tf.status & ATA_SENSE) {
 		if (ata_scsi_sense_is_valid(tf.lbah, tf.lbam, tf.lbal)) {
-			ata_scsi_set_sense(dev, cmd, tf.lbah, tf.lbam, tf.lbal);
+			/* Set sense without also setting scsicmd->result */
+			scsi_build_sense_buffer(dev->flags & ATA_DFLAG_D_SENSE,
+						cmd->sense_buffer, tf.lbah,
+						tf.lbam, tf.lbal);
 			qc->flags |= ATA_QCFLAG_SENSE_VALID;
+			return true;
 		}
 	} else {
 		ata_dev_warn(dev, "request sense failed stat %02x emask %x\n",
 			     tf.status, err_mask);
 	}
+
+	return false;
 }
 
 /**
@@ -1588,8 +1594,9 @@ static unsigned int ata_eh_analyze_tf(struct ata_queued_cmd *qc)
 		 *  was not included in the NCQ command error log
 		 *  (i.e. NCQ autosense is not supported by the device).
 		 */
-		if (!(qc->flags & ATA_QCFLAG_SENSE_VALID) && (stat & ATA_SENSE))
-			ata_eh_request_sense(qc);
+		if (!(qc->flags & ATA_QCFLAG_SENSE_VALID) &&
+		    (stat & ATA_SENSE) && ata_eh_request_sense(qc))
+			set_status_byte(qc->scsicmd, SAM_STAT_CHECK_CONDITION);
 		if (err & ATA_ICRC)
 			qc->err_mask |= AC_ERR_ATA_BUS;
 		if (err & (ATA_UNC | ATA_AMNF))
-- 
2.39.2

