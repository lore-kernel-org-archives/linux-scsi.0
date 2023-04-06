Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0A20C761A6
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Apr 2023 11:42:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238738AbjDFLmV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Apr 2023 07:42:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238637AbjDFLlx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Apr 2023 07:41:53 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B1D1A5E7;
        Thu,  6 Apr 2023 04:37:50 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id 20so40406489lju.0;
        Thu, 06 Apr 2023 04:37:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680780983;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:dkim-signature
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/Z0HrXglURUTmiT3OjfkcREc/jfLk/MFC0HZkLcGyTs=;
        b=xr4bJSXMOE0H8gja8frLzh4Fz7VN06BDTnGpTT6ECdZAlLI7t6SgCoteHfMVKwP+Ei
         6HHejK8smRmgHNL9r/xc0aTP4tuItotojUCALAmkoXCTuruvMllDHNcjxNXlmkQi+xdW
         +/FRGboBZqLCU4A3zPlj1znWjz30Z3vrowM4VSalD+sqYsO3VnsGmh7mkzsKef3QP4Lw
         z4JE3hY2D8ndMpbQMOy8EcXUnAiFWWNQby13vWAIAbBNMArl5QwxJGerargBHgNedJAt
         XshaV15p2OD1twwwOx69mptcIGBiHP63EfHyDTDQdZTiqnqRjeCVsSWtz3RQ0679Jjab
         QHww==
X-Gm-Message-State: AAQBX9coz5kGeSIdrjafkTcbBzAktDNsmMULEMmXIS0AhZp2jfCrPrdT
        /wN7AeadEFuF9MOL49D+Elimc+6eyiACsQ==
X-Google-Smtp-Source: AKy350ZsIEPLOHzKUcIDc/cx+tJSMQqVBn1KvhN6U7jzKmyqiiF7X1SkIVMHq2Y5br35UVhxyw0I2w==
X-Received: by 2002:a2e:3307:0:b0:2a0:3f9f:fecd with SMTP id d7-20020a2e3307000000b002a03f9ffecdmr2580847ljc.49.1680780983365;
        Thu, 06 Apr 2023 04:36:23 -0700 (PDT)
Received: from flawful.org (c-fcf6e255.011-101-6d6c6d3.bbcust.telenor.se. [85.226.246.252])
        by smtp.gmail.com with ESMTPSA id r1-20020a2eb601000000b0029c36ebf89asm248944ljn.112.2023.04.06.04.36.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 04:36:23 -0700 (PDT)
Received: by flawful.org (Postfix, from userid 112)
        id 33A416D4; Thu,  6 Apr 2023 13:36:22 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1680780982; bh=XGZVEMwxr52fp5lGTU9X5lm3s1wffMMFZDS68VuUgmE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DX+yp+f0S3v0AGoXiCUNXisbfhOF/iIK+GePP7lQjGW1GWD5XYx7xi4oP2vmUK3ei
         bEbJp4VKfOEcp0IgiZl+F1oy/Vzz+lA1Wlp//LKhdibqMClTFSGY4zCeOU1SOeqERt
         7nW9ga4caEErxQqqr/bEYZNE8totjLsD1Ibog0VU=
Received: from x1-carbon.lan (OpenWrt.lan [192.168.1.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by flawful.org (Postfix) with ESMTPSA id 8241F6D7;
        Thu,  6 Apr 2023 13:33:08 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1680780788; bh=XGZVEMwxr52fp5lGTU9X5lm3s1wffMMFZDS68VuUgmE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RO4ce7qjSBBmz8rUR7jhk61XDZ9uynxSP/QGm6zYnRSlFnYUuFv4JIoyKtezmmbkA
         km8r3G5ksrGKTt2fAiX6NJAsAXvsWbvj6nv7pN/mY9MkUdbOOnV+s+DbQvZiMoDnV3
         0Su0++j4/3HgsiA36QS+9JEJ2FrwLgGVLTLPqFx0=
From:   Niklas Cassel <nks@flawful.org>
To:     Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Damien Le Moal <dlemoal@fastmail.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v6 04/19] scsi: core: allow libata to complete successful commands via EH
Date:   Thu,  6 Apr 2023 13:32:33 +0200
Message-Id: <20230406113252.41211-5-nks@flawful.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230406113252.41211-1-nks@flawful.org>
References: <20230406113252.41211-1-nks@flawful.org>
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

