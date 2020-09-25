Return-Path: <SRS0=8X05=DC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B99D9C4741F
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Sep 2020 16:19:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76FB822B2D
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Sep 2020 16:19:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hVavjcj6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727874AbgIYQTh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Sep 2020 12:19:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:33991 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728996AbgIYQTh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Sep 2020 12:19:37 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601050776;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NmMNFZem4zxwx8zsacxizdBtvT6u9qJjyTu6Rji6vJI=;
        b=hVavjcj6bTQgFGcbQ9n8AkmVcmzHdw4q6QORhGmn+Ncy/40jhO98uFDP65J3AvbXgC3Pyp
        lWCOTCuQmXkMICCuCDAOh6+gT8zCWEChRp0KaDe5xv79Y43mAJLBuqjB1ZCCrmaCMmLb8V
        45feOp53EwVqzacSNqtNQB1ToChxiXY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-164-WgbhSpbDOseWmP0nrURg3A-1; Fri, 25 Sep 2020 12:19:34 -0400
X-MC-Unique: WgbhSpbDOseWmP0nrURg3A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5E649801AAC;
        Fri, 25 Sep 2020 16:19:33 +0000 (UTC)
Received: from sulaco.redhat.com (unknown [10.10.110.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 90F2D5D9DC;
        Fri, 25 Sep 2020 16:19:32 +0000 (UTC)
From:   Tony Asleson <tasleson@redhat.com>
To:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org
Subject: [v5 02/12] create_syslog_header: Add durable name
Date:   Fri, 25 Sep 2020 11:19:19 -0500
Message-Id: <20200925161929.1136806-3-tasleson@redhat.com>
In-Reply-To: <20200925161929.1136806-1-tasleson@redhat.com>
References: <20200925161929.1136806-1-tasleson@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This gets us a persistent durable name for code that logs messages in the
block layer that have the appropriate callbacks setup for durable name.

Signed-off-by: Tony Asleson <tasleson@redhat.com>
---
 drivers/base/core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 88696ade8bfc..adef36d4b475 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -3864,6 +3864,7 @@ create_syslog_header(const struct device *dev, char *hdr, size_t hdrlen)
 {
 	const char *subsys;
 	size_t pos = 0;
+	int dlen;
 
 	if (dev->class)
 		subsys = dev->class->name;
@@ -3906,6 +3907,10 @@ create_syslog_header(const struct device *dev, char *hdr, size_t hdrlen)
 				"DEVICE=+%s:%s", subsys, dev_name(dev));
 	}
 
+	dlen = dev_durable_name(dev, hdr + (pos + 1), hdrlen - (pos + 1));
+	if (dlen)
+		pos += dlen + 1;
+
 	if (pos >= hdrlen)
 		goto overflow;
 
-- 
2.26.2

