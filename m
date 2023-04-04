Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73E40C77B62
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Apr 2023 18:36:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236424AbjDDSgB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Apr 2023 14:36:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236402AbjDDSfl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Apr 2023 14:35:41 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE1D36582;
        Tue,  4 Apr 2023 11:33:14 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id br6so43490147lfb.11;
        Tue, 04 Apr 2023 11:33:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680633193;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:dkim-signature
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s8H2qIMz3Gty35NiNYKZYVBmBlGMd1so+hGxNCASCEY=;
        b=IjxsZrGaUE0aYYVN3MWZaPwiFL+gtqk72QzhuVC+m02cpmK/W2kv6ESPaLF1eQaN7L
         +BvDkVZxCOAv4SZ6YfwtwRs0len2kJ7c2YaRyG+0ISTSnUVZCkXGNwvyLkjX4v+9BJCc
         6rxVLIME6lCH+bv4ZFPyKnmzmUXf1HInecLxadnBSHJjWKvRbOGisddJoDbmJhaHG24L
         bEIevyiEj/80hKQYZrS9Ehe8P6bS2bm3CPPiDV1azgQEQonptiusrFC5caVr6OMOujH1
         zB5Uw8OSctJTqHoTxFMVpfCmbdC8dcbtmjwAft6tOjU1++yJFkPipzUa4DDpkUAC9art
         XSig==
X-Gm-Message-State: AAQBX9cn/jSrkdXrcpJyJTeGFMoWNl4WrsZt/LzvN2QkDtGhTy36bM0R
        9CEGP1jvg8H6bNClfKOtqNBdbem21brCGQ==
X-Google-Smtp-Source: AKy350ZFt7lV1WRE8AnWhFZdWE3oAIje0MW5aj6+5d6FnhFD51oPReJH3kug7iGhTmXDx54sVjkkIA==
X-Received: by 2002:a05:6512:147:b0:4eb:18d:91df with SMTP id m7-20020a056512014700b004eb018d91dfmr739642lfo.27.1680633193019;
        Tue, 04 Apr 2023 11:33:13 -0700 (PDT)
Received: from flawful.org (c-a3f5e255.011-101-6d6c6d3.bbcust.telenor.se. [85.226.245.163])
        by smtp.gmail.com with ESMTPSA id l25-20020a19c219000000b004eb258f73a9sm2426229lfc.163.2023.04.04.11.33.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 11:33:12 -0700 (PDT)
Received: by flawful.org (Postfix, from userid 112)
        id EEE2E2C0; Tue,  4 Apr 2023 20:33:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1680633192; bh=EW5tWLpRWwKlaovMDrPHJz7vr86vu6Zk+592YnNpO6U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jUVxpf2UJZgXs0fQ2Rq7X3Ef77i/cUcFvsfNRoldU1Zvo7yl6AbsEKk0doh4e+w8K
         ZxroN+RBWWiWxZjx8JQRArWwbflkLWgYnfON+dNUwV57pqCOazDZ9avyu2L6YQBrUj
         DQ14dEY6nrcOZ1Zt/Ojy677fyjjp+w/1bERGeR/8=
Received: from x1-carbon.lan (OpenWrt.lan [192.168.1.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by flawful.org (Postfix) with ESMTPSA id A19121110;
        Tue,  4 Apr 2023 20:25:51 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1680632751; bh=EW5tWLpRWwKlaovMDrPHJz7vr86vu6Zk+592YnNpO6U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UlQrLNLQVCD3GCKSKahHKH3U8uY5W3cSRBs2mrlY3+kdwvWmx9Gt1qlIibv5V6AO8
         ub7Xc46v4PiQGYZ9NoiPlyH2XbYCGdY9rezoJPSovDO1LcXAdt/5LgBp1plDhFVALF
         QWV88IoPAOLjmZMzFB2KCv3vWiOKmMFW7QR6U+mI=
From:   Niklas Cassel <nks@flawful.org>
To:     Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v5 13/19] ata: libata: change ata_eh_request_sense() to not set CHECK_CONDITION
Date:   Tue,  4 Apr 2023 20:24:18 +0200
Message-Id: <20230404182428.715140-14-nks@flawful.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230404182428.715140-1-nks@flawful.org>
References: <20230404182428.715140-1-nks@flawful.org>
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

