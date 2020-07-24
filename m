Return-Path: <SRS0=9S6W=BD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0359FC433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jul 2020 17:17:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D84A820658
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jul 2020 17:17:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Dbhw5UYp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbgGXRRW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Jul 2020 13:17:22 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:46513 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726397AbgGXRRV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 24 Jul 2020 13:17:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595611040;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mODc3efTkpI2zf5Pknz9bXgNLlzTp1vYCCFGuMMO6Cs=;
        b=Dbhw5UYpT5HTqCzmVyP3UWwqM15NBYcgQ0ElJby+bGd6umbLmRCrfR+tUrsp7s90gnH4ai
        ceprV9kaNCi+Ej7Z3/XERDHgknjc2JkfCSb9IZ/Ud8JMNMztUl4Heqem9Tb7MwvoIzh6sI
        oVC0p+ARkZVEWCJeMlJYZDiuSN3toRY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-281-AFtHj5L7PQmK2wkqzuSOOA-1; Fri, 24 Jul 2020 13:17:18 -0400
X-MC-Unique: AFtHj5L7PQmK2wkqzuSOOA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7099318FF662;
        Fri, 24 Jul 2020 17:17:17 +0000 (UTC)
Received: from sulaco.redhat.com (unknown [10.3.128.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 33D8474F64;
        Fri, 24 Jul 2020 17:17:16 +0000 (UTC)
From:   Tony Asleson <tasleson@redhat.com>
To:     linux-block@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, b.zolnierkie@samsung.com,
        axboe@kernel.dk
Subject: [v4 05/11] nvme: Add durable name for dev_printk
Date:   Fri, 24 Jul 2020 12:17:00 -0500
Message-Id: <20200724171706.1550403-6-tasleson@redhat.com>
In-Reply-To: <20200724171706.1550403-1-tasleson@redhat.com>
References: <20200724171706.1550403-1-tasleson@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Corrections from Keith Busch review comments.

Signed-off-by: Tony Asleson <tasleson@redhat.com>
---
 drivers/nvme/host/core.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index f3c037f5a9ba..f2e5b91668a1 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2667,6 +2667,22 @@ static bool nvme_validate_cntlid(struct nvme_subsystem *subsys,
 	return true;
 }
 
+static ssize_t wwid_show(struct device *dev, struct device_attribute *attr,
+			char *buf);
+
+static int dev_to_nvme_durable_name(const struct device *dev, char *buf, size_t len)
+{
+	char serial[144];	/* Max 141 for wwid_show */
+	ssize_t serial_len = wwid_show((struct device *)dev, NULL, serial);
+
+	if (serial_len > 0 && serial_len < len) {
+		serial_len -= 1;  /* Remove the '\n' from the string */
+		strncpy(buf, serial, serial_len);
+		return serial_len;
+	}
+	return 0;
+}
+
 static int nvme_init_subsystem(struct nvme_ctrl *ctrl, struct nvme_id_ctrl *id)
 {
 	struct nvme_subsystem *subsys, *found;
@@ -3616,6 +3632,8 @@ static void nvme_alloc_ns(struct nvme_ctrl *ctrl, unsigned nsid)
 	disk->queue = ns->queue;
 	disk->flags = flags;
 	memcpy(disk->disk_name, disk_name, DISK_NAME_LEN);
+	disk_to_dev(disk)->durable_name = dev_to_nvme_durable_name;
+
 	ns->disk = disk;
 
 	__nvme_revalidate_disk(disk, id);
-- 
2.26.2

