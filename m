Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 779A3C05027
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Feb 2023 16:25:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231245AbjBBQZv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Feb 2023 11:25:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230144AbjBBQZt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Feb 2023 11:25:49 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD53D4B19B
        for <linux-scsi@vger.kernel.org>; Thu,  2 Feb 2023 08:24:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675355098;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lhZjMiHleEv76N3Nisr/BZ88qX5wCuHWty6zAczN+zc=;
        b=d0ORsVC9/upyWawEtqFZag4/96D+bxcSzorwrBwuqWZqtSa0Mbrr+pgHPLEPPGLAzpAOqf
        z0xkyODyfU6TmPh6mUrHTKeB7ptRlJSgvmbU0wMx8OxUp2e0mSqjD92kL0s6/9Lxcr8TG1
        IM4kdMrUw8K+4iv27UzU4UnuFfgWDz4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-422-lHWkUoMhMQeFeH92M0xP5A-1; Thu, 02 Feb 2023 11:24:55 -0500
X-MC-Unique: lHWkUoMhMQeFeH92M0xP5A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AD02D83394C;
        Thu,  2 Feb 2023 16:24:54 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-192-75.brq.redhat.com [10.40.192.75])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 33B5C404BEC0;
        Thu,  2 Feb 2023 16:24:54 +0000 (UTC)
From:   Tomas Henzl <thenzl@redhat.com>
To:     linux-scsi@vger.kernel.org
Cc:     mikoxyzzz@gmail.com
Subject: [PATCH v2 3/4] ses: fix possible desc_ptr out-of-bounds accesses in ses_enclosure_data_process
Date:   Thu,  2 Feb 2023 17:24:50 +0100
Message-Id: <20230202162451.15346-4-thenzl@redhat.com>
In-Reply-To: <20230202162451.15346-1-thenzl@redhat.com>
References: <20230202162451.15346-1-thenzl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Sanitize possible desc_ptr out-of-bounds accesses
in ses_enclosure_data_process.

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/ses.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index 896fd4f6e93d..dbfe12f63c98 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -572,15 +572,19 @@ static void ses_enclosure_data_process(struct enclosure_device *edev,
 			int max_desc_len;
 
 			if (desc_ptr) {
-				if (desc_ptr >= buf + page7_len) {
+				if (desc_ptr + 3 >= buf + page7_len) {
 					desc_ptr = NULL;
 				} else {
 					len = (desc_ptr[2] << 8) + desc_ptr[3];
 					desc_ptr += 4;
-					/* Add trailing zero - pushes into
-					 * reserved space */
-					desc_ptr[len] = '\0';
-					name = desc_ptr;
+					if (desc_ptr + len > buf + page7_len)
+						desc_ptr = NULL;
+					else {
+						/* Add trailing zero - pushes into
+						 * reserved space */
+						desc_ptr[len] = '\0';
+						name = desc_ptr;
+					}
 				}
 			}
 			if (type_ptr[0] == ENCLOSURE_COMPONENT_DEVICE ||
-- 
2.38.1

