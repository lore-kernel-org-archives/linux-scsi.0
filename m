Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B633C54EED
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Jan 2023 19:04:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234643AbjAXTEl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Jan 2023 14:04:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234574AbjAXTDx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Jan 2023 14:03:53 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1DB44DBCB;
        Tue, 24 Jan 2023 11:03:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1674587031; x=1706123031;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pPfChadvZkjWP5BXTDptKrvxhcFM28TnCX7UlT8m74c=;
  b=rHe6lxt+ahs1dE6/Yk0m6HnFiDbNf7uFkZCL4e/WqBPujoG1zfw/rlGJ
   KbRazTMQef+WgJJvA/ot7GS5EBQXq8qpiuF84eiBAKEuhv14NweGHhKtN
   NWvS3raMifYcUW9MUf9YXlQqf0Q6a8QITmm3RzeJBAQMCgVCGU3MwByud
   jIU5gk2w1d1SdbW2wjnanUzxOCn5XiiFLA62+NTBy8fBf53eSLGfxWPS2
   r30v8qEIkYitG2BMeJIM54IoqPRrAGdRqIATEMuPV6lQj8Mbb5YSiJ7LW
   5miX3Iu0Vw29XPq2QWVi2BHR6H58VlUNsA6exTQJ2qd8dis5qLkqCt164
   w==;
X-IronPort-AV: E=Sophos;i="5.97,243,1669046400"; 
   d="scan'208";a="221472972"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 25 Jan 2023 03:03:51 +0800
IronPort-SDR: 0hYa7oe0XqNYIKjo38IvYXuZLF6ZFjO5O5PTVn1tgNWbcBwQZGGnqnea36d69jZ9+wImb7UshZ
 JY5/7NTBiT9j1yRCJhOHWIAZ5DgUc7VcFQt3M+x+KO8vNWUXdDuf4UicAvgzUwwmTdCr/uxoBM
 gVaxQviBvkyJyBjhJjb6BTFeFvSF1qzw5W+dVcJoy+MUITC1KPFKKkGc+aqrfLYPTusHtAvHpC
 3KyK5RhKxJKuYAf/aSQOwGGEqdJvwkNA9T2ZJgtosX/HBPUkbQD+olmyvirIITZvUUtxiNMlOW
 CvU=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 24 Jan 2023 10:15:39 -0800
IronPort-SDR: DMA61RK9yqrwkv7mL8wZ7CNlqamy1epfDOQX6JofKneDaF6u4l83MYeQuPHSRzJYJFr+S1v3ya
 E8cBZtfu3Lvg18d0UiP4hgBsrRsJRnD/zSN21OiAkMIiGuVGXI9n9b8AGZ7XfHlg7UNiwJ5whj
 Ly3Sjo9gPKyfTJl3U1yTdu6vddHKmtJDaYk4VKMdRHEwbke4lnywLWPitxs7MppViKpna+42Og
 aFt3lrDkIsgwiYr0mlmAzWNJzg2I8wCjyhSsGzp5rFta2wfsePTCOQkxyk0AxRZXBrDMZ/ZjVC
 YdU=
WDCIronportException: Internal
Received: from unknown (HELO x1-carbon.lan) ([10.225.164.48])
  by uls-op-cesaip02.wdc.com with ESMTP; 24 Jan 2023 11:03:49 -0800
From:   Niklas Cassel <niklas.cassel@wdc.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v3 11/18] ata: libata: change ata_eh_request_sense() to not set CHECK_CONDITION
Date:   Tue, 24 Jan 2023 20:02:57 +0100
Message-Id: <20230124190308.127318-12-niklas.cassel@wdc.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230124190308.127318-1-niklas.cassel@wdc.com>
References: <20230124190308.127318-1-niklas.cassel@wdc.com>
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
2.39.1

