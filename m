Return-Path: <SRS0=9S6W=BD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06743C43457
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jul 2020 17:17:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA53A20658
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jul 2020 17:17:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bHX9QAUX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726764AbgGXRRY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Jul 2020 13:17:24 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:41708 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726953AbgGXRRX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Jul 2020 13:17:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595611042;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8ImeJ3bLpLTJQP5gpaVY3PbrCkxzGZxT2qAXoeNIvVo=;
        b=bHX9QAUX2Qpa35b8ljPHagpzqGIMWPcEkjYVU6ebUW4UWGyMV/mtQxguhlG8ZTQi4eCbaO
        abQkQz+HiJ/QwRjFw7WmXNHz1TQMg7I5cEUI7r20Zq2+Yh4hUJHKWGe6aSmuEo0aDj2CIl
        I3uoClDcjNDGa2voXoU+ogcwHVgPb6s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-495-ojXNLA1kO8SG5im6BrRqMA-1; Fri, 24 Jul 2020 13:17:20 -0400
X-MC-Unique: ojXNLA1kO8SG5im6BrRqMA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E31F618FF665;
        Fri, 24 Jul 2020 17:17:18 +0000 (UTC)
Received: from sulaco.redhat.com (unknown [10.3.128.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C5B1D74F64;
        Fri, 24 Jul 2020 17:17:17 +0000 (UTC)
From:   Tony Asleson <tasleson@redhat.com>
To:     linux-block@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, b.zolnierkie@samsung.com,
        axboe@kernel.dk
Subject: [v4 06/11] libata: Add ata_scsi_durable_name
Date:   Fri, 24 Jul 2020 12:17:01 -0500
Message-Id: <20200724171706.1550403-7-tasleson@redhat.com>
In-Reply-To: <20200724171706.1550403-1-tasleson@redhat.com>
References: <20200724171706.1550403-1-tasleson@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Function used to create the durable name for ata scsi.

Signed-off-by: Tony Asleson <tasleson@redhat.com>
---
 drivers/ata/libata-scsi.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 36e588d88b95..ec1f6e406ceb 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1091,6 +1091,14 @@ int ata_scsi_dev_config(struct scsi_device *sdev, struct ata_device *dev)
 	return 0;
 }
 
+int ata_scsi_durable_name(const struct device *dev, char *buf, size_t len)
+{
+	struct ata_device *ata_dev = container_of(dev, struct ata_device, tdev);
+
+	return scsi_durable_name(ata_dev->sdev, buf, len);
+}
+
+
 /**
  *	ata_scsi_slave_config - Set SCSI device attributes
  *	@sdev: SCSI device to examine
@@ -1111,8 +1119,11 @@ int ata_scsi_slave_config(struct scsi_device *sdev)
 
 	ata_scsi_sdev_config(sdev);
 
-	if (dev)
+	if (dev) {
 		rc = ata_scsi_dev_config(sdev, dev);
+		if (!rc)
+			dev->tdev.durable_name = ata_scsi_durable_name;
+	}
 
 	return rc;
 }
-- 
2.26.2

