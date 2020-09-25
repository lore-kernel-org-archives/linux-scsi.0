Return-Path: <SRS0=8X05=DC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C42F6C47426
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Sep 2020 16:19:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8ADA22344C
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Sep 2020 16:19:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YLKAhDSG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729545AbgIYQTw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Sep 2020 12:19:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:38226 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729525AbgIYQTq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Sep 2020 12:19:46 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601050785;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6namRKwyl41y70rGoFYuQn74j+aa0S3vYKcYpbMpaLA=;
        b=YLKAhDSGMl2IBRIXWbUpnlzyndcLAa8svBg/4at1iLITFGulyPhKppRrpJiybpixa0YgcX
        YM9EMqYdo4Da/PnsYtXzyNFaIqsoLOo7sVTD2MQ20j/VY73I8FVe0XwP/et2eS6WUjoeaF
        RKKqVT79JyVEEbx/rtUM4m4e3RQ8KHA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-252-716peKunOrer45eL0-rxew-1; Fri, 25 Sep 2020 12:19:42 -0400
X-MC-Unique: 716peKunOrer45eL0-rxew-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1EDFD87130C;
        Fri, 25 Sep 2020 16:19:41 +0000 (UTC)
Received: from sulaco.redhat.com (unknown [10.10.110.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 524465D9DC;
        Fri, 25 Sep 2020 16:19:40 +0000 (UTC)
From:   Tony Asleson <tasleson@redhat.com>
To:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org
Subject: [v5 09/12] libata: use durable_name_printk
Date:   Fri, 25 Sep 2020 11:19:26 -0500
Message-Id: <20200925161929.1136806-10-tasleson@redhat.com>
In-Reply-To: <20200925161929.1136806-1-tasleson@redhat.com>
References: <20200925161929.1136806-1-tasleson@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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
index b1cd4d97bc2a..11200b861ce8 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -6443,7 +6443,8 @@ void ata_port_printk(const struct ata_port *ap, const char *level,
 	vaf.fmt = fmt;
 	vaf.va = &args;
 
-	printk("%sata%u: %pV", level, ap->print_id, &vaf);
+	durable_name_printk(level, &ap->tdev, "ata%u: %pV",
+		ap->print_id, &vaf);
 
 	va_end(args);
 }
@@ -6461,11 +6462,11 @@ void ata_link_printk(const struct ata_link *link, const char *level,
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
@@ -6482,9 +6483,9 @@ void ata_dev_printk(const struct ata_device *dev, const char *level,
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

