Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0B97C677F1
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Jan 2023 14:07:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233522AbjALOHC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Jan 2023 09:07:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233591AbjALOF5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Jan 2023 09:05:57 -0500
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DF6555642;
        Thu, 12 Jan 2023 06:04:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1673532264; x=1705068264;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7+Ziz+mTsWX/A3ryVhHzi3SXwdqtLJ92byM5egPbRU4=;
  b=BvkujPgJYAlSKpBhPBLHQLxd6Sh3qmvYR5DlqXvPJ2VSPGgyQxZd5zib
   EoJFV2wblxsw1pUWbea+KTeoCyZQhMYUdEtXc2OdNzcbpjq4s9TGhKEL6
   asORO1MbBqAgDoUOuI8sDFr+6GAgmwLsyd+2Co58AaIy83r/bFggnVd7y
   ODybvyWhlGT205zcDWrbZhLLBcnuQ3kpyZCBsPUK0iu8MYYBO5R6wDNHX
   cU9Mk0hAv6mZpfotZdpn5eXCRk6L0aYZkqZvmrN/nbOMMK0UCIIDVYi1E
   rm2xhtV+l3NmXRUiz8980hUNDhZlRscnpDBnDItTDpFl6tNQjiksm2dni
   A==;
X-IronPort-AV: E=Sophos;i="5.97,211,1669046400"; 
   d="scan'208";a="332632651"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 12 Jan 2023 22:04:24 +0800
IronPort-SDR: +vB6C2ygxnShTcPinnd3lKQw4Aun6LpusgzxXt+cIY8gcfmScJBLa+8AO9HuthUhB+cEdjXlBY
 9e6bww5beASj4Kwo/SGo8KlMLne5lp1oawd1+xpquVZ9T+vW8UGaHJY0RYwwPjBWq2WOHBn2L3
 Sp1bdMxHnXl4GfCHyU76s4zqcDLX7ix1YNqkLZ0v2iO8lJFW3Q0Xgvvmd6r7suwoju5ER88aSi
 uSB7+8k1+H44KNOyC+pcyQDYb1r+gxDlR+smAmAYsPvXxzZa0EFh0d4zMbOmfhjWLRcVAWjLR+
 kKE=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 12 Jan 2023 05:16:27 -0800
IronPort-SDR: AGyUwv9qHhJI5gkBnROEGO3Hmn5U39CGteeD4NpXgaaneQHphvi6CCV7fjYtv9QI5dCxGmfz/v
 5ZZ9bHwShW5fDfUiYc1fytYSAKP1KebsQN5ShPbuUNGv1SqV5Rj84PyfbDmQzUPyKRRVyt5pik
 G8nWw540Nft3NEamPC0/2JbwWKaVDIyHkm7vsfFU2uVT9cVoAbRo/IsZUTHDahUGNpNhHmfHMj
 cDdht9f934BDn75j1pi57SV/mvbqRJAKmvdYVDCwX+iyimYnuWNkjHZ8CMG5Jr0lqaAVhisdqs
 osA=
WDCIronportException: Internal
Received: from unknown (HELO x1-carbon.wdc.com) ([10.225.164.12])
  by uls-op-cesaip01.wdc.com with ESMTP; 12 Jan 2023 06:04:23 -0800
From:   Niklas Cassel <niklas.cassel@wdc.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-block@vger.kernel.org,
        Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v2 02/18] ata: libata: allow ata_eh_request_sense() to not set CHECK_CONDITION
Date:   Thu, 12 Jan 2023 15:03:51 +0100
Message-Id: <20230112140412.667308-3-niklas.cassel@wdc.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112140412.667308-1-niklas.cassel@wdc.com>
References: <20230112140412.667308-1-niklas.cassel@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Current ata_eh_request_sense() calls ata_scsi_set_sense() with
check_condition always set to true, which, in addition to setting the
sense data, unconditionally sets the scsicmd->result to
SAM_STAT_CHECK_CONDITION.

For Command Duration Limits policy 0xD:
The device shall complete the command without error (SAM_STAT_GOOD)
with the additional sense code set to DATA CURRENTLY UNAVAILABLE.

It is perfectly fine to have sense data for a command that returned
completion without error.

In order to support for CDL policy 0xD, we have to remove this
assumption that having sense data means that the command failed
(SAM_STAT_CHECK_CONDITION).

Add a new parameter to ata_eh_request_sense() to allow us to request
sense data without unconditionally setting SAM_STAT_CHECK_CONDITION.
This new parameter will be used in a follow-up patch.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 drivers/ata/libata-eh.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 3521f3f67f5a..1c3d55fc1cae 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -1395,6 +1395,7 @@ unsigned int atapi_eh_tur(struct ata_device *dev, u8 *r_sense_key)
 /**
  *	ata_eh_request_sense - perform REQUEST_SENSE_DATA_EXT
  *	@qc: qc to perform REQUEST_SENSE_SENSE_DATA_EXT to
+ *	@check_condition: if SAM_STAT_CHECK_CONDITION should get set
  *
  *	Perform REQUEST_SENSE_DATA_EXT after the device reported CHECK
  *	SENSE.  This function is an EH helper.
@@ -1402,7 +1403,8 @@ unsigned int atapi_eh_tur(struct ata_device *dev, u8 *r_sense_key)
  *	LOCKING:
  *	Kernel thread context (may sleep).
  */
-static void ata_eh_request_sense(struct ata_queued_cmd *qc)
+static void ata_eh_request_sense(struct ata_queued_cmd *qc,
+				 bool check_condition)
 {
 	struct scsi_cmnd *cmd = qc->scsicmd;
 	struct ata_device *dev = qc->dev;
@@ -1432,8 +1434,8 @@ static void ata_eh_request_sense(struct ata_queued_cmd *qc)
 	/* Ignore err_mask; ATA_ERR might be set */
 	if (tf.status & ATA_SENSE) {
 		if (ata_scsi_sense_is_valid(tf.lbah, tf.lbam, tf.lbal)) {
-			ata_scsi_set_sense(dev, cmd, true, tf.lbah, tf.lbam,
-					   tf.lbal);
+			ata_scsi_set_sense(dev, cmd, check_condition, tf.lbah,
+					   tf.lbam, tf.lbal);
 			qc->flags |= ATA_QCFLAG_SENSE_VALID;
 		}
 	} else {
@@ -1590,7 +1592,7 @@ static unsigned int ata_eh_analyze_tf(struct ata_queued_cmd *qc)
 		 *  (i.e. NCQ autosense is not supported by the device).
 		 */
 		if (!(qc->flags & ATA_QCFLAG_SENSE_VALID) && (stat & ATA_SENSE))
-			ata_eh_request_sense(qc);
+			ata_eh_request_sense(qc, true);
 		if (err & ATA_ICRC)
 			qc->err_mask |= AC_ERR_ATA_BUS;
 		if (err & (ATA_UNC | ATA_AMNF))
-- 
2.39.0

