Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D227C61DA4
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Jan 2023 10:14:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236065AbjA3KOT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Jan 2023 05:14:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236068AbjA3KOM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jan 2023 05:14:12 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2469F166DE
        for <linux-scsi@vger.kernel.org>; Mon, 30 Jan 2023 02:13:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675073602;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lhZjMiHleEv76N3Nisr/BZ88qX5wCuHWty6zAczN+zc=;
        b=fcEJKKkxokxPHJkBVl0TC/qXw+bwIXXqhKJxqsBDmxVh/XmlvGa/NZ2xw1eJEWXBr7ejxq
        dhtBACBzv0qAId9X8XXO599Wy9xb4Z5ELvQMrsOpt5+1VDQ0+rv3L3gS+vBZ61HXCWvlb5
        FyDg2cC8YMG7lo8pELCjDTKooufOUuI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-28-3_A7VEJ0N_uc2VFmFlweBg-1; Mon, 30 Jan 2023 05:13:20 -0500
X-MC-Unique: 3_A7VEJ0N_uc2VFmFlweBg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 644393810B09
        for <linux-scsi@vger.kernel.org>; Mon, 30 Jan 2023 10:13:20 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-193-84.brq.redhat.com [10.40.193.84])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 088501121314
        for <linux-scsi@vger.kernel.org>; Mon, 30 Jan 2023 10:13:19 +0000 (UTC)
From:   Tomas Henzl <thenzl@redhat.com>
To:     linux-scsi@vger.kernel.org
Subject: [PATCH 3/4] ses: fix possible desc_ptr out-of-bounds accesses in ses_enclosure_data_process
Date:   Mon, 30 Jan 2023 11:13:16 +0100
Message-Id: <20230130101317.4862-4-thenzl@redhat.com>
In-Reply-To: <20230130101317.4862-1-thenzl@redhat.com>
References: <20230130101317.4862-1-thenzl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
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

