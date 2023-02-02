Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D163FC61DA4
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Feb 2023 16:25:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232149AbjBBQZy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Feb 2023 11:25:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231546AbjBBQZv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Feb 2023 11:25:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFE1969B08
        for <linux-scsi@vger.kernel.org>; Thu,  2 Feb 2023 08:24:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675355097;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lvAQrZ5GI20DfhRf7JUyWWGadV3QhvQWMOzJf48p54A=;
        b=KJBdWzuqc9mF6wy9k4nwR8tKSVuVeFAxlCuRaVnx817eT+pmKVs1gIfMS1M9cdi8PhF849
        dZLZS/RHlBzZLzkwroGVTVbQmCbzI4pCQI6UqoWxd9/iOqxYhLgYA8F3x0tnM9ZUGqlGjx
        zbiDl87RIKSTjOSukJem0EraDxxLS5E=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-221-N_Lz-7i2O7aDSE12ak0VAA-1; Thu, 02 Feb 2023 11:24:53 -0500
X-MC-Unique: N_Lz-7i2O7aDSE12ak0VAA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3E7858027EB;
        Thu,  2 Feb 2023 16:24:53 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-192-75.brq.redhat.com [10.40.192.75])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BA025404BEC0;
        Thu,  2 Feb 2023 16:24:52 +0000 (UTC)
From:   Tomas Henzl <thenzl@redhat.com>
To:     linux-scsi@vger.kernel.org
Cc:     mikoxyzzz@gmail.com
Subject: [PATCH v2 1/4] ses: fix slab-out-of-bounds reported by KASAN in ses_enclosure_data_process
Date:   Thu,  2 Feb 2023 17:24:48 +0100
Message-Id: <20230202162451.15346-2-thenzl@redhat.com>
In-Reply-To: <20230202162451.15346-1-thenzl@redhat.com>
References: <20230202162451.15346-1-thenzl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

A fix for:
BUG: KASAN: slab-out-of-bounds in ses_enclosure_data_process+0x949/0xe30 [ses]
Read of size 1 at addr ffff88a1b043a451 by task systemd-udevd/3271
Checking after (and before in next loop) addl_desc_ptr[1] is sufficient,
we expect the size to be sanitized before first access to addl_desc_ptr[1].
Testing for one more byte shall protect partially the ses_process_descriptor.

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/ses.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index 0a1734f34587..1ee927ac8603 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -603,9 +603,11 @@ static void ses_enclosure_data_process(struct enclosure_device *edev,
 			     /* these elements are optional */
 			     type_ptr[0] == ENCLOSURE_COMPONENT_SCSI_TARGET_PORT ||
 			     type_ptr[0] == ENCLOSURE_COMPONENT_SCSI_INITIATOR_PORT ||
-			     type_ptr[0] == ENCLOSURE_COMPONENT_CONTROLLER_ELECTRONICS))
+			     type_ptr[0] == ENCLOSURE_COMPONENT_CONTROLLER_ELECTRONICS)){
 				addl_desc_ptr += addl_desc_ptr[1] + 2;
-
+				if (addl_desc_ptr + 1 >= ses_dev->page10 + ses_dev->page10_len)
+					addl_desc_ptr = NULL;
+			}
 		}
 	}
 	kfree(buf);
-- 
2.38.1

