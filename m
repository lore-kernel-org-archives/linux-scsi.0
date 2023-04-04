Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B7B7C77B60
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Apr 2023 18:31:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236221AbjDDSby (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Apr 2023 14:31:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236219AbjDDSbk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Apr 2023 14:31:40 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B32D44EF2;
        Tue,  4 Apr 2023 11:28:33 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id g19so30390507lfr.9;
        Tue, 04 Apr 2023 11:28:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680632912;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:dkim-signature
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/Z0HrXglURUTmiT3OjfkcREc/jfLk/MFC0HZkLcGyTs=;
        b=DrzMiFEBQ0wBozbHfFAzI8HzhLmW4e70Ze9QJMu2WRa94/nZAzznrxg6tYCso67dH4
         11tEjUSPGvclrwqnqWek9B3sCcZB6Oa2iecapc35ghU9RbUrZRDBWokPKjC26TNckSUn
         D+7PdErsyabuJ3GvGL3TpsSKpdTpVhVa7xQG4m18ChEBW70saMOyJ2p+Cb7xWW6fUVxf
         +cdDtIBBQq/xTD8QPZHM2ODm5s0g88ePGOZfTgQ3RcxX2glvQvOSdpfTbOIMt/pvLP6n
         NixjAxmXUzRAXpvmQaCihLx8U5xdWP8cTU6YPlmYrvTebjoVgQv0I/IT9Nf+DsW5JvWX
         m9gw==
X-Gm-Message-State: AAQBX9fQQNo6Ya8edEVqFlkjRDZuyq4knKjyh9fAqKLVcAe1t8/NW6zC
        Gz59geHWFx6Ply4+9jQk60WjoE59pLnLVg==
X-Google-Smtp-Source: AKy350awHKKAUVlR8KWtHRrLjGYaZe4Z3i4jF8zUJJMDMj1hyM4xsheKHm+tE1jK0IaVRSu5ZvUahA==
X-Received: by 2002:a05:6512:24d:b0:4eb:b28:373e with SMTP id b13-20020a056512024d00b004eb0b28373emr926637lfo.61.1680632911863;
        Tue, 04 Apr 2023 11:28:31 -0700 (PDT)
Received: from flawful.org (c-a3f5e255.011-101-6d6c6d3.bbcust.telenor.se. [85.226.245.163])
        by smtp.gmail.com with ESMTPSA id q21-20020ac25295000000b004eb51cfb147sm16247lfm.115.2023.04.04.11.28.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 11:28:31 -0700 (PDT)
Received: by flawful.org (Postfix, from userid 112)
        id 7E226865; Tue,  4 Apr 2023 20:28:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1680632910; bh=XGZVEMwxr52fp5lGTU9X5lm3s1wffMMFZDS68VuUgmE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DSEMnLoOYVCGpT6vsv5VDSVttaSfbETEaA51/MM1FATmS4Yi+J+z+HSPHmYz4at4m
         Fhe4fo4UM1MredhYlPAc9MFjiYbgpuYlcRhRAcnYPSMFske0QkgfhvkepWkzKFJUx3
         jWf1wlik8IbrhDQk/rsRcAgELVW+YTWKI7kVUW7U=
Received: from x1-carbon.lan (OpenWrt.lan [192.168.1.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by flawful.org (Postfix) with ESMTPSA id 97902949;
        Tue,  4 Apr 2023 20:25:33 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1680632733; bh=XGZVEMwxr52fp5lGTU9X5lm3s1wffMMFZDS68VuUgmE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=amLrie37E65S58ijvN3F7ATehaGeGnh1IfTHl5WbbekQMYaf8hrq+f3mNn2hkjzVk
         RsNFGjyluojDCF+nO7iDYFnoG/rVU2Dij1lGmrTi0whr88lazsP5Xa9G1EI/hSE5vs
         jvQNteHlajNMjX1PdaxBA0ul6j6wRPlMfq0CyJSE=
From:   Niklas Cassel <nks@flawful.org>
To:     Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v5 04/19] scsi: core: allow libata to complete successful commands via EH
Date:   Tue,  4 Apr 2023 20:24:09 +0200
Message-Id: <20230404182428.715140-5-nks@flawful.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230404182428.715140-1-nks@flawful.org>
References: <20230404182428.715140-1-nks@flawful.org>
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

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_error.c | 3 ++-
 include/scsi/scsi_cmnd.h  | 5 +++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 2aa2c2aee6e7..cf5ec5f5f4f6 100644
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
2.39.2

