Return-Path: <SRS0=8X05=DC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB93DC47420
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Sep 2020 16:19:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B9CB21D7A
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Sep 2020 16:19:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g5VPU+kj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729540AbgIYQTs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Sep 2020 12:19:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:31038 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729480AbgIYQTn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Sep 2020 12:19:43 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601050782;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ANY2qnzvW5slLXQEnRPDZ8OvNs0Obq0WqgEdDcyBR9E=;
        b=g5VPU+kj5IERHKjczBgRvQPuSJa325X8+lwnD+Q/UtbJM7RMZTbMhndQrM9972pMF7ews0
        a2U0B4vvc6FUWHBCWFyhBuI6GiKrcBHIvU/3EUuu/1D3XwdKTz2FMNpr5r0vDtvQPRlm5Q
        u/eSWlzEXDUiGD50dfxap4nJ+UxfAO0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-582-Xdn-GAWHPDq-o_t1u0PIGQ-1; Fri, 25 Sep 2020 12:19:38 -0400
X-MC-Unique: Xdn-GAWHPDq-o_t1u0PIGQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D93E210BBED2;
        Fri, 25 Sep 2020 16:19:37 +0000 (UTC)
Received: from sulaco.redhat.com (unknown [10.10.110.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 162515D9DC;
        Fri, 25 Sep 2020 16:19:36 +0000 (UTC)
From:   Tony Asleson <tasleson@redhat.com>
To:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org
Subject: [v5 06/12] libata: Add ata_scsi_durable_name
Date:   Fri, 25 Sep 2020 11:19:23 -0500
Message-Id: <20200925161929.1136806-7-tasleson@redhat.com>
In-Reply-To: <20200925161929.1136806-1-tasleson@redhat.com>
References: <20200925161929.1136806-1-tasleson@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Function used to create the durable name for ata scsi.

Signed-off-by: Tony Asleson <tasleson@redhat.com>
---
 drivers/ata/libata-scsi.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 46336084b1a9..194dac7dbdca 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1086,6 +1086,13 @@ int ata_scsi_dev_config(struct scsi_device *sdev, struct ata_device *dev)
 	return 0;
 }
 
+int ata_scsi_durable_name(const struct device *dev, char *buf, size_t len)
+{
+	struct ata_device *ata_dev = container_of(dev, struct ata_device, tdev);
+
+	return scsi_durable_name(ata_dev->sdev, buf, len);
+}
+
 /**
  *	ata_scsi_slave_config - Set SCSI device attributes
  *	@sdev: SCSI device to examine
@@ -1102,14 +1109,19 @@ int ata_scsi_slave_config(struct scsi_device *sdev)
 {
 	struct ata_port *ap = ata_shost_to_port(sdev->host);
 	struct ata_device *dev = __ata_scsi_find_dev(ap, sdev);
-	int rc = 0;
+	int rc;
 
 	ata_scsi_sdev_config(sdev);
 
-	if (dev)
+	if (dev) {
 		rc = ata_scsi_dev_config(sdev, dev);
+		if (rc)
+			return rc;
 
-	return rc;
+		dev->tdev.durable_name = ata_scsi_durable_name;
+	}
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(ata_scsi_slave_config);
 
-- 
2.26.2

