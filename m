Return-Path: <SRS0=+pcl=63=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA6D3C433E3
	for <linux-scsi@archiver.kernel.org>; Wed, 13 May 2020 21:36:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C39062054F
	for <linux-scsi@archiver.kernel.org>; Wed, 13 May 2020 21:36:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZbLy3mLc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729529AbgEMVgk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 May 2020 17:36:40 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:39160 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729483AbgEMVgg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 May 2020 17:36:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589405795;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y2+b6an8Oose37xQfoDtn8tXCYrO95yhISh4EW9FuGk=;
        b=ZbLy3mLc/81HimcH/37KqgVyAH5vex9dpfrGFw9KRuxANhtc04NJyYdGaSUjbCCTjxulKW
        uX1/mnVvrVWtLHASlSZ/5/OrE+EU93hBgT0sYv0XGFHDlSl9dms8Kr0MN2W6SjyoaUmpJk
        P3XeBjiaiMrgQPsZelFsO7oWfCPiCIk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-254-sDeRDpkvPQaAWoakivOJ6A-1; Wed, 13 May 2020 17:36:29 -0400
X-MC-Unique: sDeRDpkvPQaAWoakivOJ6A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 80BC5100CCC2;
        Wed, 13 May 2020 21:36:28 +0000 (UTC)
Received: from sulaco.redhat.com (unknown [10.3.128.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D66A95D99A;
        Wed, 13 May 2020 21:36:27 +0000 (UTC)
From:   Tony Asleson <tasleson@redhat.com>
To:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Subject: [RFC PATCH v2 5/7] ata_dev_printk: Use dev_printk
Date:   Wed, 13 May 2020 16:36:19 -0500
Message-Id: <20200513213621.470411-6-tasleson@redhat.com>
In-Reply-To: <20200513213621.470411-1-tasleson@redhat.com>
References: <20200513213621.470411-1-tasleson@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Utilize the dev_printk function which will add structured data
to the log message.

Signed-off-by: Tony Asleson <tasleson@redhat.com>
---
 drivers/ata/libata-core.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 42c8728f6117..16978d615a17 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -7301,6 +7301,7 @@ EXPORT_SYMBOL(ata_link_printk);
 void ata_dev_printk(const struct ata_device *dev, const char *level,
 		    const char *fmt, ...)
 {
+	const struct device *gendev;
 	struct va_format vaf;
 	va_list args;
 
@@ -7309,9 +7310,12 @@ void ata_dev_printk(const struct ata_device *dev, const char *level,
 	vaf.fmt = fmt;
 	vaf.va = &args;
 
-	printk("%sata%u.%02u: %pV",
-	       level, dev->link->ap->print_id, dev->link->pmp + dev->devno,
-	       &vaf);
+	gendev = (dev->sdev) ? &dev->sdev->sdev_gendev : &dev->tdev;
+
+	dev_printk(level, gendev, "ata%u.%02u: %pV",
+			dev->link->ap->print_id,
+			dev->link->pmp + dev->devno,
+			&vaf);
 
 	va_end(args);
 }
-- 
2.25.4

