Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF799C54EAA
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Jan 2023 10:14:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236093AbjA3KOU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Jan 2023 05:14:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236075AbjA3KOM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jan 2023 05:14:12 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E0D115C88
        for <linux-scsi@vger.kernel.org>; Mon, 30 Jan 2023 02:13:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675073606;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3RjW4DOZCvhQd1bXgafs79oHh0ytkPtehsJxnCjunDQ=;
        b=GRYMva/6AvWHWQRBEhuricRq6bEbB+50xdLJtgcNPan07vCy09yPgeW2G862bdPaJjMAaS
        Du3aBeMDQLmuQLmjJe/gePUmu74FNHAMgK86RNmNyhm+PS8Yx5hPlYfwzHghR7B9I+xuJn
        QJIlovgrslzLcMFylasoshnNLBP7Wd8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-524-Zef3kL9TMgyiS-yIJfIxrQ-1; Mon, 30 Jan 2023 05:13:21 -0500
X-MC-Unique: Zef3kL9TMgyiS-yIJfIxrQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 05970802C15
        for <linux-scsi@vger.kernel.org>; Mon, 30 Jan 2023 10:13:21 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-193-84.brq.redhat.com [10.40.193.84])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9DD451121314
        for <linux-scsi@vger.kernel.org>; Mon, 30 Jan 2023 10:13:20 +0000 (UTC)
From:   Tomas Henzl <thenzl@redhat.com>
To:     linux-scsi@vger.kernel.org
Subject: [PATCH 4/4] ses: fix slab-out-of-bounds reported by KASAN in ses_intf_remove
Date:   Mon, 30 Jan 2023 11:13:17 +0100
Message-Id: <20230130101317.4862-5-thenzl@redhat.com>
In-Reply-To: <20230130101317.4862-1-thenzl@redhat.com>
References: <20230130101317.4862-1-thenzl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

A fix for:
BUG: KASAN: slab-out-of-bounds in ses_intf_remove+0x23f/0x270 [ses]
Read of size 8 at addr ffff88a10d32e5d8 by task rmmod/12013
When edev->components is zero, accessing edev->component[0]
members is wrong.

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/ses.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index dbfe12f63c98..7a9eb54e8808 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -850,7 +850,8 @@ static void ses_intf_remove_enclosure(struct scsi_device *sdev)
 	kfree(ses_dev->page2);
 	kfree(ses_dev);
 
-	kfree(edev->component[0].scratch);
+	if (edev->components)
+		kfree(edev->component[0].scratch);
 
 	put_device(&edev->edev);
 	enclosure_unregister(edev);
-- 
2.38.1

