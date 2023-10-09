Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE6E5E95A91
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Oct 2023 15:28:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376478AbjJIP2Y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Oct 2023 11:28:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376380AbjJIP2Y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Oct 2023 11:28:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A963A6
        for <linux-scsi@vger.kernel.org>; Mon,  9 Oct 2023 08:27:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696865255;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=EacTf+XOQKr6PyiaoBj0ZdPBigzoSuxteR5y7gs4eow=;
        b=SfoiqMDfxEyjacj1YW2NT0UdRiCvtpKqLvmEPbxBGd1dLlcYqYEk5EyRKuXKhOL78GCcwn
        ySDJXFuiqs5YU1TjfR9Ck8cZ+BitOSNGDeRmBNvoFCAM9ofsmLlpeqZJl4Ydp2LLXsvmcL
        b1qlsA30XG3ATa1SYE5pVXY5lZhiGmY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-414-fX2bpUocOeykBx7YXshvOg-1; Mon, 09 Oct 2023 11:27:32 -0400
X-MC-Unique: fX2bpUocOeykBx7YXshvOg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E22E485A5BA;
        Mon,  9 Oct 2023 15:27:31 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.45.225.106])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 36B9440C6EA8;
        Mon,  9 Oct 2023 15:27:31 +0000 (UTC)
From:   Tomas Henzl <thenzl@redhat.com>
To:     linux-scsi@vger.kernel.org
Cc:     sreekanth.reddy@broadcom.com, ranjan.kumar@broadcom.com,
        sathya.prakash@broadcom.com
Subject: [PATCH] mpt3sas: suppress a warning in debug kernel
Date:   Mon,  9 Oct 2023 17:27:30 +0200
Message-ID: <20231009152730.14925-1-thenzl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The mpt3sas_ctl_exit should be called after communication
with the controller stops but in the current place it may cause
false warnings about memory not released.
Fix it by moving the call right after mpt3sas_base_detach.

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index c3c1f466fe01..9af7a7e24474 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -11350,6 +11350,7 @@ static void scsih_remove(struct pci_dev *pdev)
 	}
 
 	mpt3sas_base_detach(ioc);
+	mpt3sas_ctl_exit(hbas_to_enumerate);
 	spin_lock(&gioc_lock);
 	list_del(&ioc->list);
 	spin_unlock(&gioc_lock);
@@ -12931,8 +12932,6 @@ _mpt3sas_exit(void)
 
 	pci_unregister_driver(&mpt3sas_driver);
 
-	mpt3sas_ctl_exit(hbas_to_enumerate);
-
 	scsih_exit();
 }
 
-- 
2.41.0

