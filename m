Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBADCC25B08
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Aug 2022 07:26:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231670AbiHQH0C (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Aug 2022 03:26:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiHQH0B (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Aug 2022 03:26:01 -0400
X-Greylist: delayed 312 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 17 Aug 2022 00:26:00 PDT
Received: from mx.swemel.ru (mx.swemel.ru [95.143.211.150])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90DE06B8F1;
        Wed, 17 Aug 2022 00:26:00 -0700 (PDT)
From:   Denis Arefev <arefev@swemel.ru>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=swemel.ru; s=mail;
        t=1660721158;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=+8trc0HzuNdzJYDIdm9RSEE7rJ+rGGw4sPL4RMjtjlQ=;
        b=iRtuNf9lzoeIhMzLHY2WYqbjs3nDA+X4xwdAg5v5y1/yECP3yusfpj96vylF8IVSgFfB7q
        QOIIpvuYQY1HgX7lYgLIBCmwtNE+x2NxXwcE7zWwahTBbmZghTxHPi7A8xDETGkzZzBSH0
        9DM68Ke+wIOPmnLFmRHyDyv4fzQ7xY0=
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org (open list:SCSI SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list),
        ldv-project@linuxtesting.org, trufanov@swemel.ru, vfh@swemel.ru
Subject: [PATCH] Add qlogicfas408_reset in qlogic_resume
Date:   Wed, 17 Aug 2022 10:25:58 +0300
Message-Id: <20220817072558.47163-1-arefev@swemel.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Denis Arefev <arefev@swemel.ru>
---
 drivers/scsi/pcmcia/qlogic_stub.c |  2 +-
 drivers/scsi/qlogicfas408.c       | 19 +++++++++++++++++++
 drivers/scsi/qlogicfas408.h       |  1 +
 3 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/pcmcia/qlogic_stub.c b/drivers/scsi/pcmcia/qlogic_stub.c
index 828d53faf09a..710a0c35bf12 100644
--- a/drivers/scsi/pcmcia/qlogic_stub.c
+++ b/drivers/scsi/pcmcia/qlogic_stub.c
@@ -268,7 +268,7 @@ static int qlogic_resume(struct pcmcia_device *link)
 		outb(0x04, link->resource[0]->start + 0xd);
 	}
 	/* Ugggglllyyyy!!! */
-	qlogicfas408_host_reset(NULL);
+	qlogicfas408_reset(info->host);
 
 	return 0;
 }
diff --git a/drivers/scsi/qlogicfas408.c b/drivers/scsi/qlogicfas408.c
index 136681ad18a5..c5f9efe044e0 100644
--- a/drivers/scsi/qlogicfas408.c
+++ b/drivers/scsi/qlogicfas408.c
@@ -516,6 +516,24 @@ int qlogicfas408_host_reset(struct scsi_cmnd *cmd)
 	return SUCCESS;
 }
 
+/*
+ *	Reset SCSI bus
+ */
+
+int qlogicfas408_reset(struct  Scsi_Host *host)
+{
+	struct qlogicfas408_priv *priv = get_priv_by_host(host);
+	unsigned long flags;
+
+	priv->qabort = 2;
+
+	spin_lock_irqsave(host->host_lock, flags);
+	ql_zap(priv);
+	spin_unlock_irqrestore(host->host_lock, flags);
+
+	return SUCCESS;
+}
+
 /*
  *	Return info string
  */
@@ -608,6 +626,7 @@ EXPORT_SYMBOL(qlogicfas408_info);
 EXPORT_SYMBOL(qlogicfas408_queuecommand);
 EXPORT_SYMBOL(qlogicfas408_abort);
 EXPORT_SYMBOL(qlogicfas408_host_reset);
+EXPORT_SYMBOL(qlogicfas408_reset);
 EXPORT_SYMBOL(qlogicfas408_biosparam);
 EXPORT_SYMBOL(qlogicfas408_ihandl);
 EXPORT_SYMBOL(qlogicfas408_get_chip_type);
diff --git a/drivers/scsi/qlogicfas408.h b/drivers/scsi/qlogicfas408.h
index a971db11d293..593e59e1697e 100644
--- a/drivers/scsi/qlogicfas408.h
+++ b/drivers/scsi/qlogicfas408.h
@@ -110,6 +110,7 @@ int qlogicfas408_biosparam(struct scsi_device * disk,
 			   sector_t capacity, int ip[]);
 int qlogicfas408_abort(struct scsi_cmnd * cmd);
 extern int qlogicfas408_host_reset(struct scsi_cmnd *cmd);
+extern int qlogicfas408_reset(struct Scsi_Host *host);
 const char *qlogicfas408_info(struct Scsi_Host *host);
 int qlogicfas408_get_chip_type(int qbase, int int_type);
 void qlogicfas408_setup(int qbase, int id, int int_type);
-- 
2.25.1

