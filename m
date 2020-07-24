Return-Path: <SRS0=9S6W=BD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FA4CC43460
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jul 2020 17:17:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52289206F6
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jul 2020 17:17:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W8tgfX1y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbgGXRR2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Jul 2020 13:17:28 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:32354 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726967AbgGXRR1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 24 Jul 2020 13:17:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595611046;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eIjvNwQwRBmED5NqFfXN7K7BJEBPgapMv/+dcSKQmIk=;
        b=W8tgfX1yocLJkPEqON4tGOfb+rLKPg73yBRY/bpFX4m6CIz8Dr9P8CSv5b4cpyPOb79Ft1
        Ao8ZKme+ZtHuco/ONhQuqXTmoDCObXKuJxoFnVugyKYD/668R2d0TwZC88k6usuqdiuTdl
        4R+zNJDO/lWr1a8YcPkRmOBUaBG8zps=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-332-xGt-Xre7PqiCYDQkB42i_Q-1; Fri, 24 Jul 2020 13:17:23 -0400
X-MC-Unique: xGt-Xre7PqiCYDQkB42i_Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1E9288005B0;
        Fri, 24 Jul 2020 17:17:22 +0000 (UTC)
Received: from sulaco.redhat.com (unknown [10.3.128.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D269A79D01;
        Fri, 24 Jul 2020 17:17:20 +0000 (UTC)
From:   Tony Asleson <tasleson@redhat.com>
To:     linux-block@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, b.zolnierkie@samsung.com,
        axboe@kernel.dk
Subject: [v4 08/11] libata: use durable_name_printk
Date:   Fri, 24 Jul 2020 12:17:03 -0500
Message-Id: <20200724171706.1550403-9-tasleson@redhat.com>
In-Reply-To: <20200724171706.1550403-1-tasleson@redhat.com>
References: <20200724171706.1550403-1-tasleson@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Utilize durable_name_printk to associate the durable name
with the log message via structured data.  The user visible
portion of the log message is unchanged.

Signed-off-by: Tony Asleson <tasleson@redhat.com>
---
 drivers/ata/libata-core.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index beca5f91bb4c..468aa3f7eaad 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -6444,7 +6444,8 @@ void ata_port_printk(const struct ata_port *ap, const char *level,
 	vaf.fmt = fmt;
 	vaf.va = &args;
 
-	printk("%sata%u: %pV", level, ap->print_id, &vaf);
+	durable_name_printk(level, &ap->tdev, "ata%u: %pV",
+		ap->print_id, &vaf);
 
 	va_end(args);
 }
@@ -6462,11 +6463,11 @@ void ata_link_printk(const struct ata_link *link, const char *level,
 	vaf.va = &args;
 
 	if (sata_pmp_attached(link->ap) || link->ap->slave_link)
-		printk("%sata%u.%02u: %pV",
-		       level, link->ap->print_id, link->pmp, &vaf);
+		durable_name_printk(level, &link->tdev, "ata%u.%02u: %pV",
+		       link->ap->print_id, link->pmp, &vaf);
 	else
-		printk("%sata%u: %pV",
-		       level, link->ap->print_id, &vaf);
+		durable_name_printk(level, &link->tdev, "ata%u: %pV",
+		       link->ap->print_id, &vaf);
 
 	va_end(args);
 }
@@ -6483,9 +6484,9 @@ void ata_dev_printk(const struct ata_device *dev, const char *level,
 	vaf.fmt = fmt;
 	vaf.va = &args;
 
-	printk("%sata%u.%02u: %pV",
-	       level, dev->link->ap->print_id, dev->link->pmp + dev->devno,
-	       &vaf);
+	durable_name_printk(level, &dev->tdev, "ata%u.%02u: %pV",
+		dev->link->ap->print_id, dev->link->pmp + dev->devno,
+		&vaf);
 
 	va_end(args);
 }
-- 
2.26.2

