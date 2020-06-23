Return-Path: <SRS0=JRJf=AE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88E60C433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Jun 2020 19:18:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 601D92082F
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Jun 2020 19:18:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SlH5olNw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387453AbgFWTSG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Jun 2020 15:18:06 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:49488 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1733308AbgFWTSF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Jun 2020 15:18:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592939883;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3FlvC4WnnfR6GPyXEm/QWq5hfr2bBZHvjMhaZjhHQsU=;
        b=SlH5olNwThH1X/Bn99pJBTHbUft2gTQno5e78SzYJthktJ0NAI9ZQjFFZgpt8pV4HIzi6E
        6wjiGDBq8TRnRW/lctMMe4YRPJz3+cFlKjBPjQZBLGcr4xvkyIvbC3NTk6py5/zw/pPa6l
        yWkPW8wi+as2VICXISu59AnPnNgovLc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-59-js0mMmBcOn-ygKuTfAMeUg-1; Tue, 23 Jun 2020 15:18:02 -0400
X-MC-Unique: js0mMmBcOn-ygKuTfAMeUg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4C43B10059A4;
        Tue, 23 Jun 2020 19:18:01 +0000 (UTC)
Received: from sulaco.redhat.com (unknown [10.3.128.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 671687169D;
        Tue, 23 Jun 2020 19:18:00 +0000 (UTC)
From:   Tony Asleson <tasleson@redhat.com>
To:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Subject: [RFC PATCH v3 7/8] nvme: Add durable name for dev_printk
Date:   Tue, 23 Jun 2020 14:17:48 -0500
Message-Id: <20200623191749.115200-8-tasleson@redhat.com>
In-Reply-To: <20200623191749.115200-1-tasleson@redhat.com>
References: <20200623191749.115200-1-tasleson@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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
2.25.4

