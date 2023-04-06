Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEFB2C76196
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Apr 2023 11:47:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236949AbjDFLrr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Apr 2023 07:47:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238779AbjDFLrU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Apr 2023 07:47:20 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB330BB8A;
        Thu,  6 Apr 2023 04:43:17 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id b6so20358108ljr.1;
        Thu, 06 Apr 2023 04:43:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680781329;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:dkim-signature
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s8H2qIMz3Gty35NiNYKZYVBmBlGMd1so+hGxNCASCEY=;
        b=pKCvhCgi64aG7RPHiN/Lvl9XDX16QUBZkAB+TbZ/mMuXSp5eNkGa62OWZGF+D1Ri2T
         KKe3ccv/k70C5QUU3CVx90+t9YFAa7Kk52bAExUrkmrdPM9RZeazWv17zKbYMDoBN6pV
         lO9eN3neUzfajUNbzvcwxud7eCDB1gWU1xdmRrRwr1FptDPoA889X3/drjRpB4BKAY6E
         I5AvwVMAadbz/24pjqnlRhl2D283Vtka1IBOABdzPkJ/0ePDx0VC/46b86qvq8yVV2Ot
         utc6xqSAiwrbymukhpApj9K5MIsiaa5IXcdlaEgCQvix7Qxr0h14dOSN4zYqkm9W9lyB
         IsOw==
X-Gm-Message-State: AAQBX9c9PIpvfKHVgsXFOI+c/89iokLqfHb/9oaCMXv+HZqRo+ZAL3dp
        mHOjPu4OJKTkZXOAt5WJJlrJeE8OpZ2C6A==
X-Google-Smtp-Source: AKy350YLLyGaTS9PsCqq/YGlAjjHRHbcVtGvVM6PtOsYtMgoZV2BtB2xIYfUIZlL56fwz9585K5iLA==
X-Received: by 2002:a2e:8e92:0:b0:2a0:4de2:db88 with SMTP id z18-20020a2e8e92000000b002a04de2db88mr3090023ljk.44.1680781329320;
        Thu, 06 Apr 2023 04:42:09 -0700 (PDT)
Received: from flawful.org (c-fcf6e255.011-101-6d6c6d3.bbcust.telenor.se. [85.226.246.252])
        by smtp.gmail.com with ESMTPSA id x12-20020a2e7c0c000000b002a61bd34f63sm250992ljc.84.2023.04.06.04.42.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 04:42:09 -0700 (PDT)
Received: by flawful.org (Postfix, from userid 112)
        id 3553667E; Thu,  6 Apr 2023 13:42:08 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1680781328; bh=EW5tWLpRWwKlaovMDrPHJz7vr86vu6Zk+592YnNpO6U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Eq+x5tJUYQHU3STM8CrAmSC1KVwpZs7KMiItHL4zn3blZrasm3AVyvvucjacR9Tsf
         TNbRo6jGPQPFgVAb/65M6R/ZTQCxExVlDEwZadGYS+BUVAKn9UAZ+x6HbokyrRM6mD
         zpFx3p9eR8uXy1s4h8qUs7Sbr5r8HbJeModDqDWU=
Received: from x1-carbon.lan (OpenWrt.lan [192.168.1.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by flawful.org (Postfix) with ESMTPSA id 2A590D26;
        Thu,  6 Apr 2023 13:33:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1680780796; bh=EW5tWLpRWwKlaovMDrPHJz7vr86vu6Zk+592YnNpO6U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V9mvVatqK+uUQus/RnH/NLqmZDZMGNlGXWB0hqefRPdSWtSr97kav2cgt0cDFGcV1
         j9VWKwnRUyEZ9nx2lApE1XPAXff2KPRdh7U9bo3gyIeTmE/ley/XncSV8MAM3YfeeC
         1vX2qTMrAxoNYHpl1ODVpp/Lb0dqbZexmDZyT3F8=
From:   Niklas Cassel <nks@flawful.org>
To:     Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <dlemoal@fastmail.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v6 13/19] ata: libata: change ata_eh_request_sense() to not set CHECK_CONDITION
Date:   Thu,  6 Apr 2023 13:32:42 +0200
Message-Id: <20230406113252.41211-14-nks@flawful.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230406113252.41211-1-nks@flawful.org>
References: <20230406113252.41211-1-nks@flawful.org>
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

