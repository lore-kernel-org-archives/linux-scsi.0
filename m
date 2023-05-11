Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA722C7EE23
	for <linux-scsi@archiver.kernel.org>; Thu, 11 May 2023 01:23:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235624AbjEKBXH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 May 2023 21:23:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbjEKBXF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 May 2023 21:23:05 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76728E51;
        Wed, 10 May 2023 18:23:03 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id 2adb3069b0e04-4f13d8f74abso8969936e87.0;
        Wed, 10 May 2023 18:23:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683768182; x=1686360182;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:dkim-signature
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xF32VaywX//csdEKto/eJklDotWsjFyaEWqGFSA+5oI=;
        b=a07/wIxb6XbVGQvDOjdNJUkrP2xGwe+qSkdNpjX9UsT32Urdo3W3HEQ/tJ8oEEhM5l
         MKE8YwM23j7z08jAq8GwiLthlgcvexdfyy1HeqsJlYJY84DJ9G3gxt4dEsgpIoYk+e2B
         PShdhAYR+FD6HC10Zw+r6IDhhUWhqMB5smBVFeiMsffE/Js9K5PFWKBReepnukRm5aee
         vzU99UlpH1uV5VHqqPXIM5RlaPXL01mn+B/42dEY4jDYw0f6RtEkqTecxqGzRd2tOMFZ
         OqSi3gHcx4rH89QOv4iJNc5nagXmrPG8Lg0LTgpRN2SY1Nsnr4QtWMVuYnKuc56dz4jh
         ISVg==
X-Gm-Message-State: AC+VfDxweIBjn6Byafx+J454pFtq7U7ssQPZvHq/4bdo/aM6a58a3Emi
        Q+Lx3SIyBrW/31dfLkFWootj5Z4KLD8/mflF
X-Google-Smtp-Source: ACHHUZ4zd661XSnb5/yY31zJWg2udZH4eajTjFE4QPlhH0+pVJCff1btx6pJAf9CuJD7d3IrZTlj9Q==
X-Received: by 2002:ac2:518c:0:b0:4ef:ec6a:198c with SMTP id u12-20020ac2518c000000b004efec6a198cmr2210830lfi.26.1683768181674;
        Wed, 10 May 2023 18:23:01 -0700 (PDT)
Received: from flawful.org (c-fcf6e255.011-101-6d6c6d3.bbcust.telenor.se. [85.226.246.252])
        by smtp.gmail.com with ESMTPSA id d12-20020ac241cc000000b004ef11b30a17sm913644lfi.91.2023.05.10.18.23.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 May 2023 18:23:01 -0700 (PDT)
Received: by flawful.org (Postfix, from userid 112)
        id 954C8585; Thu, 11 May 2023 03:23:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1683768180; bh=QwCekgsjUK6zdEU6U3foCgsOqTlY7NkDZKvQRq/vYIc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sHJ+g2mVkt+nwX2Ls2cRzESAvH/QNHRbTzuOMLV0ncHxUisl//qJcIHcWR4v35UOe
         P+LnU0JEA8fDnrdb2kDodo77hdzXXQtuw870F3MZaTjg+6DgGNinfjU+eNxvvXKPNB
         Qqk8yAlVl63j366ZVBGXCTQI9jJE4OQYGYz+DKQ8=
Received: from x1-carbon.. (unknown [64.141.80.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by flawful.org (Postfix) with ESMTPSA id 591037A7;
        Thu, 11 May 2023 03:15:26 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1683767728; bh=QwCekgsjUK6zdEU6U3foCgsOqTlY7NkDZKvQRq/vYIc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q9JDtCufV2hF4C0lhU0EJLpXWGvfFbMTVMgsRHceZkdOkiTZOOzy60CT4wdwOLiBt
         Ohl1SJSyQNskG4sMannRg/ussPo7bv7MwMBTyPhOAE1uRD4IvMMgdYdLgt5ItZtmCm
         Ax0s6ux2GuFPS/r61NwOavsIo0cHMWhYj4nn+RH8=
From:   Niklas Cassel <nks@flawful.org>
To:     Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <dlemoal@kernel.org>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v7 13/19] ata: libata: change ata_eh_request_sense() to not set CHECK_CONDITION
Date:   Thu, 11 May 2023 03:13:46 +0200
Message-Id: <20230511011356.227789-14-nks@flawful.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230511011356.227789-1-nks@flawful.org>
References: <20230511011356.227789-1-nks@flawful.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

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

Reviewed-by: Hannes Reinecke <hare@suse.de>
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
2.40.1

