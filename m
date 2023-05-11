Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A392BC7EE26
	for <linux-scsi@archiver.kernel.org>; Thu, 11 May 2023 01:17:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236884AbjEKBRt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 May 2023 21:17:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236736AbjEKBRr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 May 2023 21:17:47 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C38B2121;
        Wed, 10 May 2023 18:17:46 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id 2adb3069b0e04-4eff4ea8e39so8917972e87.1;
        Wed, 10 May 2023 18:17:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683767865; x=1686359865;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:dkim-signature
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=h+4RaBv1ov4egPySFESfk3QXcsNv5gDW3Rrjw1thRf4=;
        b=UBz8SME5thAvE8lJdCD/DxD5YmsEoI79lfZncEvMsKq300oyrkFq45oaya0h/JZeaZ
         1UdwSgXPQV2SoKVuwEDjAGrJVF5/pdjpLruCg6cD73dOEgDwMOys2NJ7nmhgMJzpZO9z
         cZKBGulqQESKW0LnK4u+vjG8qDqnVAjOPCzRNYAGd+z7G54/WeYKPFuKUeOiuiGQKaW8
         4FqAlkaiHcSFSKr4rxm9PqUHq9K/BaYxAUb1Jx8p52V+bN/BwvJXAWwj2cIn15O5e0z6
         ZsCxcr2D98mJkWJLmWeCaZeP0aihqyRAVwBHUtTgjly3tIVonm0KCy23D/Gc1yz8Vl6I
         +2TQ==
X-Gm-Message-State: AC+VfDwnypURl0YMiWKdSXtCqgAPKX0Zvi4v02k0Wb5f2/883+XTAWbY
        L6JQJoJbCn4oVeXqu4Ykp9Gc5T6/dK0ivb7u
X-Google-Smtp-Source: ACHHUZ7Plj5SaXfQY0tfYWOH31IyiAgdHl9uuI55PEkTRpkmXe3L2W5TMr3/dOeFKTAPQ1N46Ok6XQ==
X-Received: by 2002:ac2:521b:0:b0:4e8:893f:8079 with SMTP id a27-20020ac2521b000000b004e8893f8079mr2177432lfl.64.1683767864669;
        Wed, 10 May 2023 18:17:44 -0700 (PDT)
Received: from flawful.org (c-fcf6e255.011-101-6d6c6d3.bbcust.telenor.se. [85.226.246.252])
        by smtp.gmail.com with ESMTPSA id v20-20020ac25594000000b004efef5cf939sm895718lfg.83.2023.05.10.18.17.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 May 2023 18:17:44 -0700 (PDT)
Received: by flawful.org (Postfix, from userid 112)
        id 7A05A3B3; Thu, 11 May 2023 03:17:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1683767863; bh=0MfL/ebFp6MBZS+hM/17qesIwNTyts07YzvxRKdVdD4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JJPm0BlE0GUzf7Ebqm2gWEa/5rmrv0Mv/UZvchyVeZG3P8uDzgU+FLcH4pcaeoA96
         VtTlEVSP45gv4p0WQWx+yBgHuX6JTGP+m2WJbDy0uw30x7NGySXSoaY699YVdqvYM5
         tWS5vxADsmYCeJITI41eRQGTus7ssX8tBESa8Guk=
Received: from x1-carbon.. (unknown [64.141.80.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by flawful.org (Postfix) with ESMTPSA id C86C5587;
        Thu, 11 May 2023 03:14:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1683767696; bh=0MfL/ebFp6MBZS+hM/17qesIwNTyts07YzvxRKdVdD4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NyQP7665MTBiRgw06u2aQ5k3vVb4HeHo89HOwnIeG8pspK3GaY9XLxTt/iVssYlFU
         Ot3T1ee2uvPlBBBjKhzQDYdN9IfZrHjWPWXhgIL003xY94e1AznfAlrlkOd6kZj4nL
         kFf+WtNjWPu5XTQUjGGJiyAdecVz6+Ky8I7iSK1w=
From:   Niklas Cassel <nks@flawful.org>
To:     Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <dlemoal@kernel.org>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v7 04/19] scsi: core: allow libata to complete successful commands via EH
Date:   Thu, 11 May 2023 03:13:37 +0200
Message-Id: <20230511011356.227789-5-nks@flawful.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230511011356.227789-1-nks@flawful.org>
References: <20230511011356.227789-1-nks@flawful.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

In SCSI, we get the sense data as part of the completion, for ATA
however, we need to fetch the sense data as an extra step. For an
aborted ATA command the sense data is fetched via libata's
->eh_strategy_handler().

For Command Duration Limits policy 0xD:
The device shall complete the command without error with the additional
sense code set to DATA CURRENTLY UNAVAILABLE.

In order to handle this policy in libata, we intend to send a successful
command via SCSI EH, and let libata's ->eh_strategy_handler() fetch the
sense data for the good command. This is similar to how we handle an
aborted ATA command, just that we need to read the Successful NCQ
Commands log instead of the NCQ Command Error log.

When we get a SATA completion with successful commands, ATA_SENSE will
be set, indicating that some commands in the completion have sense data.

The sense_valid bitmask in the Sense Data for Successful NCQ Commands
log will inform exactly which commands that had sense data, which might
be a subset of all the commands that was completed in the same
completion. (Yet all will have ATA_SENSE set, since the status is per
completion.)

The successful commands that have e.g. a "DATA CURRENTLY UNAVAILABLE"
sense data will have a SCSI ML byte set, so scsi_eh_flush_done_q() will
not set the scmd->result to DID_TIME_OUT for these commands. However,
the successful commands that did not have sense data, must not get their
result marked as DID_TIME_OUT by SCSI EH.

Add a new flag SCMD_FORCE_EH_SUCCESS, which tells SCSI EH to not mark a
command as DID_TIME_OUT, even if it has scmd->result == SAM_STAT_GOOD.

This will be used by libata in a follow-up patch.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 drivers/scsi/scsi_error.c | 3 ++-
 include/scsi/scsi_cmnd.h  | 5 +++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 3ec8bfd4090f..8b7d227bfe1c 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -2165,7 +2165,8 @@ void scsi_eh_flush_done_q(struct list_head *done_q)
 			 * scsi_eh_get_sense), scmd->result is already
 			 * set, do not set DID_TIME_OUT.
 			 */
-			if (!scmd->result)
+			if (!scmd->result &&
+			    !(scmd->flags & SCMD_FORCE_EH_SUCCESS))
 				scmd->result |= (DID_TIME_OUT << 16);
 			SCSI_LOG_ERROR_RECOVERY(3,
 				scmd_printk(KERN_INFO, scmd,
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index c2cb5f69635c..526def14e7fb 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -52,6 +52,11 @@ struct scsi_pointer {
 #define SCMD_TAGGED		(1 << 0)
 #define SCMD_INITIALIZED	(1 << 1)
 #define SCMD_LAST		(1 << 2)
+/*
+ * libata uses SCSI EH to fetch sense data for successful commands.
+ * SCSI EH should not overwrite scmd->result when SCMD_FORCE_EH_SUCCESS is set.
+ */
+#define SCMD_FORCE_EH_SUCCESS	(1 << 3)
 #define SCMD_FAIL_IF_RECOVERING	(1 << 4)
 /* flags preserved across unprep / reprep */
 #define SCMD_PRESERVED_FLAGS	(SCMD_INITIALIZED | SCMD_FAIL_IF_RECOVERING)
-- 
2.40.1

