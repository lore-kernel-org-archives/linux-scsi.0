Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AED3C76188
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Apr 2023 18:48:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232851AbjDCSs3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Apr 2023 14:48:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232822AbjDCSs2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Apr 2023 14:48:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4966B10A
        for <linux-scsi@vger.kernel.org>; Mon,  3 Apr 2023 11:47:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680547662;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=gtUjtEty3oWtSyU5P9dqlDBjXIGDm5es4Y+hPi9vAgQ=;
        b=VPY7xtZgUNm60BdTl70zW7YqYNUgDrMpVmGAlkhi4LU2jcr8TrCidroApBGc4mrM0Q2ryl
        ZrdP98qLthzHEGVsF+L5bHpOK79izx9+0mG2Pp/PRWaVf3WdDGpthsPegafQU3CqhPYNbQ
        3NVa4iSLw/V0ysgX0ifeoFiqC381DV4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-192-SZ5TbfUANv2wo1afbldlWQ-1; Mon, 03 Apr 2023 14:47:38 -0400
X-MC-Unique: SZ5TbfUANv2wo1afbldlWQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 11D7885A5B1;
        Mon,  3 Apr 2023 18:47:38 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.45.224.64])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4FC00175AD;
        Mon,  3 Apr 2023 18:47:37 +0000 (UTC)
From:   Tomas Henzl <thenzl@redhat.com>
To:     linux-scsi@vger.kernel.org
Cc:     sreekanth.reddy@broadcom.com, ranjan.kumar@broadcom.com,
        sathya.prakash@broadcom.com
Subject: [PATCH] scsi: mpt3sas: fix an issue when driver's being removed
Date:   Mon,  3 Apr 2023 20:47:36 +0200
Message-Id: <20230403184736.6399-1-thenzl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Warnings may be logged during driver removal:
mpt3sas 0000:01:00.0: AMD-Vi: Event logged [IO_PAGE_FAULT ..,
Fix it by deallocating dma memory later.

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 492d1940d596..c3c1f466fe01 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -12929,10 +12929,10 @@ _mpt3sas_exit(void)
 	pr_info("mpt3sas version %s unloading\n",
 				MPT3SAS_DRIVER_VERSION);
 
-	mpt3sas_ctl_exit(hbas_to_enumerate);
-
 	pci_unregister_driver(&mpt3sas_driver);
 
+	mpt3sas_ctl_exit(hbas_to_enumerate);
+
 	scsih_exit();
 }
 
-- 
2.39.2

