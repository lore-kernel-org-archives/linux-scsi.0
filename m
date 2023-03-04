Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08FC5C61DA3
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Mar 2023 00:35:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbjCDAfY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 19:35:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbjCDAeu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 19:34:50 -0500
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFF1D4C2B
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2023 16:34:16 -0800 (PST)
Received: by mail-pj1-f44.google.com with SMTP id me6-20020a17090b17c600b0023816b0c7ceso7884369pjb.2
        for <linux-scsi@vger.kernel.org>; Fri, 03 Mar 2023 16:34:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677890052;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uNBZEXnuNLSbR6kjSK5gewVoRiq0PJ3JQYeI9QvkyZY=;
        b=B7BDoZp5hCVaLqGeFz4e7WH9D7etvtIOgRLRez0QpC8iCkLZEQr0+N9RtAhm+dJ3Zm
         h9OWYmS9xTtYAAPGxnTsv7wgcW9wj2+0CjM1zKmDWN13RZcx32oMimUsT2YqQRKJnNkf
         bUHo6iUhtA2hBzMGBm86DBnI3tYR42SBVaZNBatssUaQ1h9phQ647AuNpLBYY3GQcGdv
         2Hgap7upGjHupHxUA5Aj5D1WTswkyH4KhQK7Ci1FtXsWFMDrO52V/NZRDZ/uLF327ZvM
         IkCqp4EM9T6gawukU/AUSn/RwFLJHljmydNSuW+5NgcJmq4A3Y7BasPKX1jt0SFzOe7J
         PWpw==
X-Gm-Message-State: AO0yUKVNyyJS45wr8JfcY5GLY5+JRAk1VqwcwJaQkbCwclu1g3WckWBD
        uXKJs+iCWf0LE4ZUvQ1a+zk=
X-Google-Smtp-Source: AK7set/QIHPu3oz15lb9g0ecbtlkmKdXGa7evnB2PT/jwhnsFPlzfV8iHU5RDVL4pQnK//1neGJ8DQ==
X-Received: by 2002:a17:902:a512:b0:19d:1674:c04d with SMTP id s18-20020a170902a51200b0019d1674c04dmr3184914plq.61.1677890051919;
        Fri, 03 Mar 2023 16:34:11 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:efb8:1cdc:a06f:1b53])
        by smtp.gmail.com with ESMTPSA id kk15-20020a170903070f00b00189743ed3b6sm2071078plb.64.2023.03.03.16.34.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 16:34:11 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Finn Thain <fthain@linux-m68k.org>
Subject: [PATCH 61/81] scsi: pcmcia-sym53c500: Declare SCSI host template const
Date:   Fri,  3 Mar 2023 16:30:43 -0800
Message-Id: <20230304003103.2572793-62-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
In-Reply-To: <20230304003103.2572793-1-bvanassche@acm.org>
References: <20230304003103.2572793-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it explicit that the SCSI host template is not modified.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/pcmcia/sym53c500_cs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/pcmcia/sym53c500_cs.c b/drivers/scsi/pcmcia/sym53c500_cs.c
index 5d7dfefd6f6c..278c78d066c4 100644
--- a/drivers/scsi/pcmcia/sym53c500_cs.c
+++ b/drivers/scsi/pcmcia/sym53c500_cs.c
@@ -668,7 +668,7 @@ ATTRIBUTE_GROUPS(SYM53C500_shost);
 /*
 *  scsi_host_template initializer
 */
-static struct scsi_host_template sym53c500_driver_template = {
+static const struct scsi_host_template sym53c500_driver_template = {
      .module			= THIS_MODULE,
      .name			= "SYM53C500",
      .info			= SYM53C500_info,
@@ -702,7 +702,7 @@ SYM53C500_config(struct pcmcia_device *link)
 	int ret;
 	int irq_level, port_base;
 	struct Scsi_Host *host;
-	struct scsi_host_template *tpnt = &sym53c500_driver_template;
+	const struct scsi_host_template *tpnt = &sym53c500_driver_template;
 	struct sym53c500_data *data;
 
 	dev_dbg(&link->dev, "SYM53C500_config\n");
