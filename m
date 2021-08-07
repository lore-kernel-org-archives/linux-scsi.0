Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A89F4C432BE
	for <linux-scsi@archiver.kernel.org>; Sat,  7 Aug 2021 04:19:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8499A611C6
	for <linux-scsi@archiver.kernel.org>; Sat,  7 Aug 2021 04:19:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230523AbhHGET2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 7 Aug 2021 00:19:28 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:14369 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230419AbhHGETX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 7 Aug 2021 00:19:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1628309946; x=1659845946;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GDixQfLhl+wigdfxzQ55zq0wfcgvOrepU97SohcxuxI=;
  b=JW83/p7L3ilvfOUjj0aeOG+utnmC+6i3HPAmTWXNdKwo8FyB+0p6/vsY
   D9YEkYBK6Kte7mjJ9QzIDwYsziuhZzeRczQyRZqudSwB7Jby5x8U46/Ip
   lm9aTZwe1ZWKMJRi9neV8rpbtNX9AXX+0VShDmdZGqpB2izd9LXxzTPcO
   vZIt2rHJ6pDpMunMg39friNPGvk5uI+hJvwBKlZHp7RyDyDQU5JO5762i
   1kFXjmMrLJBe/1Ox3kb5bJRCQpexFNzBPniASqC7nibl3hX17dEbc3nWU
   cYuzqlaRwTubloS7rgv1vu/Eq3VXWUbhRXLgWKOm5yK6buJZoWCZcCSuR
   Q==;
X-IronPort-AV: E=Sophos;i="5.84,301,1620662400"; 
   d="scan'208";a="181363648"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 07 Aug 2021 12:19:06 +0800
IronPort-SDR: +HUL+iNdrMdJvWtsUvLuy0mPNY36OVn7tVVo32Y6qgbjr+j+5Dm0mOkZqnIK7HPrP9SbpPgzar
 i8YgDG1sUf9kUbtwKlBzuQn9CdM17c64pBYKjkyYA7G4caAWMZZqUrzhc30FxyzNTi34j1ifGo
 Ekn+R6D+zQIS52S4GYOI6nu5iEc9e7b/69UXNHFEWON7R06sO11dHYZZ3HLKqOVSSrDC2hNeWZ
 zkKyj56R3AUUb4+qwiLABnlbTtWMjsjRl2uVQYPKzXyH00UfgP/pIxpFyFNcvq35sEENoOn4qT
 LFaAr2MqCp4ECoWWX1wb2aYI
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2021 20:56:34 -0700
IronPort-SDR: 7uQnmpPLJjQ6xBWlT+TTc7YXZ9UUwDTRI9Ci1FEEwNHy12vbizIO7rkpwFi4FQ+MOj8wuYm8eb
 1lYmYS7MF+uGpghk2KKokRX7Ki3NEF3VdXg4UtsXs7s3MeRoO4TK+bcezP0T1HFBUroBHPanFO
 1MmUt/OwX5L7NKOEcEjzLTF/zOCXZ+K+x13k9CZMezSpybKsYZ/wgT4hGLB26tO0KFIXVCBdtp
 Ffi7qmdZvl3rsR4auifyEqBSQXcUKmMHtdNeC2/f/prBTaCxdxCKY3KpH1CRw+FNO/o9bLqiHW
 FZ8=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 06 Aug 2021 21:19:05 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH v4 03/10] libata: fix sparse warning
Date:   Sat,  7 Aug 2021 13:18:52 +0900
Message-Id: <20210807041859.579409-4-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210807041859.579409-1-damien.lemoal@wdc.com>
References: <20210807041859.579409-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Sparse complains about context imbalance in ata_scsi_rbuf_get() and
ata_scsi_rbuf_put() due to these functions respectively only taking
and releasing the ata_scsi_rbuf_lock spinlock. Since these functions are
only called from ata_scsi_rbuf_fill() with ata_scsi_rbuf_get() being
called with a copy_in argument always false, the code can be simplified
and ata_scsi_rbuf_{get|put} removed. This change both simplifies the
code and fixes the sparse warning.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/ata/libata-scsi.c | 60 ++++++---------------------------------
 1 file changed, 9 insertions(+), 51 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index b9588c52815d..0b7b4624e4df 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1765,53 +1765,6 @@ struct ata_scsi_args {
 	struct scsi_cmnd	*cmd;
 };
 
-/**
- *	ata_scsi_rbuf_get - Map response buffer.
- *	@cmd: SCSI command containing buffer to be mapped.
- *	@flags: unsigned long variable to store irq enable status
- *	@copy_in: copy in from user buffer
- *
- *	Prepare buffer for simulated SCSI commands.
- *
- *	LOCKING:
- *	spin_lock_irqsave(ata_scsi_rbuf_lock) on success
- *
- *	RETURNS:
- *	Pointer to response buffer.
- */
-static void *ata_scsi_rbuf_get(struct scsi_cmnd *cmd, bool copy_in,
-			       unsigned long *flags)
-{
-	spin_lock_irqsave(&ata_scsi_rbuf_lock, *flags);
-
-	memset(ata_scsi_rbuf, 0, ATA_SCSI_RBUF_SIZE);
-	if (copy_in)
-		sg_copy_to_buffer(scsi_sglist(cmd), scsi_sg_count(cmd),
-				  ata_scsi_rbuf, ATA_SCSI_RBUF_SIZE);
-	return ata_scsi_rbuf;
-}
-
-/**
- *	ata_scsi_rbuf_put - Unmap response buffer.
- *	@cmd: SCSI command containing buffer to be unmapped.
- *	@copy_out: copy out result
- *	@flags: @flags passed to ata_scsi_rbuf_get()
- *
- *	Returns rbuf buffer.  The result is copied to @cmd's buffer if
- *	@copy_back is true.
- *
- *	LOCKING:
- *	Unlocks ata_scsi_rbuf_lock.
- */
-static inline void ata_scsi_rbuf_put(struct scsi_cmnd *cmd, bool copy_out,
-				     unsigned long *flags)
-{
-	if (copy_out)
-		sg_copy_from_buffer(scsi_sglist(cmd), scsi_sg_count(cmd),
-				    ata_scsi_rbuf, ATA_SCSI_RBUF_SIZE);
-	spin_unlock_irqrestore(&ata_scsi_rbuf_lock, *flags);
-}
-
 /**
  *	ata_scsi_rbuf_fill - wrapper for SCSI command simulators
  *	@args: device IDENTIFY data / SCSI command of interest.
@@ -1830,14 +1783,19 @@ static inline void ata_scsi_rbuf_put(struct scsi_cmnd *cmd, bool copy_out,
 static void ata_scsi_rbuf_fill(struct ata_scsi_args *args,
 		unsigned int (*actor)(struct ata_scsi_args *args, u8 *rbuf))
 {
-	u8 *rbuf;
 	unsigned int rc;
 	struct scsi_cmnd *cmd = args->cmd;
 	unsigned long flags;
 
-	rbuf = ata_scsi_rbuf_get(cmd, false, &flags);
-	rc = actor(args, rbuf);
-	ata_scsi_rbuf_put(cmd, rc == 0, &flags);
+	spin_lock_irqsave(&ata_scsi_rbuf_lock, flags);
+
+	memset(ata_scsi_rbuf, 0, ATA_SCSI_RBUF_SIZE);
+	rc = actor(args, ata_scsi_rbuf);
+	if (rc == 0)
+		sg_copy_from_buffer(scsi_sglist(cmd), scsi_sg_count(cmd),
+				    ata_scsi_rbuf, ATA_SCSI_RBUF_SIZE);
+
+	spin_unlock_irqrestore(&ata_scsi_rbuf_lock, flags);
 
 	if (rc == 0)
 		cmd->result = SAM_STAT_GOOD;
-- 
2.31.1

