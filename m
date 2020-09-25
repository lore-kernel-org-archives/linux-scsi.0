Return-Path: <SRS0=8X05=DC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67C2BC47423
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Sep 2020 16:19:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D05121D7A
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Sep 2020 16:19:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HyJqWlmG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729511AbgIYQTo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Sep 2020 12:19:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:32867 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729469AbgIYQTn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Sep 2020 12:19:43 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601050781;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rwAc6IYMXXgAxXrjBQyg7IGNXahbd5GI5Gq+iFjPuIQ=;
        b=HyJqWlmGPEAeHSYwEkWKBiTT7AWQIuLpbpcGsQg5fyI4uE37gg2BK/lalDqNz2JKJCrDt5
        4XVGc1Kcw6leo28hQkzn8Rv3POrfC9hfo1NU6XJlfkD7cdhYMac/g7j4E2d8E7xU6JndGw
        CYCMGZk3st04MUJKgFdKeyitbShtuek=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-538-Z-mNMkj8MP-ubHS7T7yGJw-1; Fri, 25 Sep 2020 12:19:37 -0400
X-MC-Unique: Z-mNMkj8MP-ubHS7T7yGJw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BB4231DDF3;
        Fri, 25 Sep 2020 16:19:36 +0000 (UTC)
Received: from sulaco.redhat.com (unknown [10.10.110.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E17A55D9DC;
        Fri, 25 Sep 2020 16:19:35 +0000 (UTC)
From:   Tony Asleson <tasleson@redhat.com>
To:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org
Subject: [v5 05/12] nvme: Add durable name for dev_printk
Date:   Fri, 25 Sep 2020 11:19:22 -0500
Message-Id: <20200925161929.1136806-6-tasleson@redhat.com>
In-Reply-To: <20200925161929.1136806-1-tasleson@redhat.com>
References: <20200925161929.1136806-1-tasleson@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Changed the comment from // to /* and re-worked buffer
space needed for formatting wwid as requested by
Keith Busch.

ref.
https://lore.kernel.org/linux-block/20200513230455.GA1503@redsun51.ssa.fujisawa.hgst.com/

Signed-off-by: Tony Asleson <tasleson@redhat.com>
---
 drivers/nvme/host/core.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 4ee2330c603e..2e3b808c7815 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2734,6 +2734,22 @@ static bool nvme_validate_cntlid(struct nvme_subsystem *subsys,
 	return true;
 }
 
+static ssize_t wwid_show(struct device *dev, struct device_attribute *attr,
+			char *buf);
+
+static int dev_to_nvme_durable_name(const struct device *dev, char *buf, size_t len)
+{
+	/*
+	 * Max 141 needed for wwid_show, make sure we have the space available
+	 * in our buffer before we format the wwid directly into it.
+	 */
+	if (len >= 141) {
+		ssize_t wwid_len = wwid_show((struct device *)dev, NULL, buf);
+		return wwid_len > 0 ? wwid_len - 1 : 0;  /* remove '\n' */
+	}
+	return 0;
+}
+
 static int nvme_init_subsystem(struct nvme_ctrl *ctrl, struct nvme_id_ctrl *id)
 {
 	struct nvme_subsystem *subsys, *found;
@@ -3663,6 +3679,8 @@ static void nvme_alloc_ns(struct nvme_ctrl *ctrl, unsigned nsid)
 	disk->queue = ns->queue;
 	disk->flags = flags;
 	memcpy(disk->disk_name, disk_name, DISK_NAME_LEN);
+	disk_to_dev(disk)->durable_name = dev_to_nvme_durable_name;
+
 	ns->disk = disk;
 
 	if (__nvme_revalidate_disk(disk, id))
-- 
2.26.2

