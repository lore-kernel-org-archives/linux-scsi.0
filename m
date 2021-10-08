Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C75FDC433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 20:25:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B033361100
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 20:25:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242782AbhJHU1I (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Oct 2021 16:27:08 -0400
Received: from mail-pf1-f181.google.com ([209.85.210.181]:36785 "EHLO
        mail-pf1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242765AbhJHU1B (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Oct 2021 16:27:01 -0400
Received: by mail-pf1-f181.google.com with SMTP id m26so9133640pff.3
        for <linux-scsi@vger.kernel.org>; Fri, 08 Oct 2021 13:25:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=W0A/Jo7ruNv71phDeQouqyaE0CgD5Vcq7kG8jaJjaCc=;
        b=AAsIxaA7ZJEfXP5eDvbUcQcqgwdhCY4X8ce14CzcWqwYEj61Q8Sn71g1FfqQvwp7UH
         Oz2SLwnyTdlY3DrT6sU3klUsUh7pU9gI3X9OGn/k0fPv19+/qA8qbZkOHy9qNvLHujmG
         hez5EPJNdVCOV/sfAz6vN74JMwsUWYFYavXNNXnklTh2ZXpSLlZuxBJHYMuzS7SCFa7D
         G4ULV25U6Qy52vvndJmmwulOLZ9eXDxxs4uEcFYbRQknJs7Imf66E3wQuiWoFNF3qcUt
         QqF7IdmG9Ry5a5NA8GvTGgHTVwapHpZt4Oiu7V5FRu8XWiI7c/ZaJ+97yxMcMMIh0rs6
         vIkQ==
X-Gm-Message-State: AOAM533Ey5ahfgL3Xucn10PCTIryTPIFf4heYt943On2jt8+ipf+ELEb
        sz9wPwrNy4iwlE9nV9tGmmM=
X-Google-Smtp-Source: ABdhPJxFszkVj4AX0O9uEmCdJErd9G/6eTOEov02OI+JDpvtOzyZBTDehef4Nut4cbJCjJYqRKC7ww==
X-Received: by 2002:a63:390:: with SMTP id 138mr6367995pgd.37.1633724705738;
        Fri, 08 Oct 2021 13:25:05 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a8e9:7950:57f8:970])
        by smtp.gmail.com with ESMTPSA id x21sm170858pfa.186.2021.10.08.13.25.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 13:25:05 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 33/46] scsi: ncr53c8xx: Switch to attribute groups
Date:   Fri,  8 Oct 2021 13:23:40 -0700
Message-Id: <20211008202353.1448570-34-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
In-Reply-To: <20211008202353.1448570-1-bvanassche@acm.org>
References: <20211008202353.1448570-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

struct device supports attribute groups directly but does not support
struct device_attribute directly. Hence switch to attribute groups.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ncr53c8xx.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ncr53c8xx.c b/drivers/scsi/ncr53c8xx.c
index 2b8c6fa5e775..57fa29a1bcc0 100644
--- a/drivers/scsi/ncr53c8xx.c
+++ b/drivers/scsi/ncr53c8xx.c
@@ -8039,11 +8039,13 @@ static struct device_attribute ncr53c8xx_revision_attr = {
 	.show	= show_ncr53c8xx_revision,
 };
   
-static struct device_attribute *ncr53c8xx_host_attrs[] = {
-	&ncr53c8xx_revision_attr,
+static struct attribute *ncr53c8xx_host_attrs[] = {
+	&ncr53c8xx_revision_attr.attr,
 	NULL
 };
 
+ATTRIBUTE_GROUPS(ncr53c8xx_host);
+
 /*==========================================================
 **
 **	Boot command line.
@@ -8085,8 +8087,8 @@ struct Scsi_Host * __init ncr_attach(struct scsi_host_template *tpnt,
 
 	if (!tpnt->name)
 		tpnt->name	= SCSI_NCR_DRIVER_NAME;
-	if (!tpnt->shost_attrs)
-		tpnt->shost_attrs = ncr53c8xx_host_attrs;
+	if (!tpnt->shost_groups)
+		tpnt->shost_groups = ncr53c8xx_host_groups;
 
 	tpnt->queuecommand	= ncr53c8xx_queue_command;
 	tpnt->slave_configure	= ncr53c8xx_slave_configure;
