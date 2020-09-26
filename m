Return-Path: <SRS0=SrIF=DD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E94ABC2D0A8
	for <linux-scsi@archiver.kernel.org>; Sat, 26 Sep 2020 15:00:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DEB921D7F
	for <linux-scsi@archiver.kernel.org>; Sat, 26 Sep 2020 15:00:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TE9tZPLM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729186AbgIZPAZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 26 Sep 2020 11:00:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:21174 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726210AbgIZPAY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 26 Sep 2020 11:00:24 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601132423;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=LUAzUOLpm/8qENDMFglIWRX6RjLDvBiKfDpGj67d+bM=;
        b=TE9tZPLMOyXDebFjkrsVarzhDnyEupj+4UvG7kTriBAtjmCy/Kvx/10HOMAWEappqeGpvw
        Sp4XLL8eiEri80qFT7SB6bobchpttd1nrIRjgFJlNZ2dBaFgtLoX948SZBFYMYr/oosk1c
        YUp12C5dbQiDYA1h+Dr2iOpKUgynSvI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-278-ezDT77fsMJeMCWmIbquRzQ-1; Sat, 26 Sep 2020 11:00:19 -0400
X-MC-Unique: ezDT77fsMJeMCWmIbquRzQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B02641074648;
        Sat, 26 Sep 2020 15:00:17 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.40.192.35])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 429B31A3D6;
        Sat, 26 Sep 2020 15:00:16 +0000 (UTC)
From:   Tomas Henzl <thenzl@redhat.com>
To:     linux-scsi@vger.kernel.org
Cc:     aacraid@microsemi.com, Balsundar.P@microchip.com,
        Sagar.Biradar@microchip.com, Dave.Carroll@microchip.com,
        Mahesh.Rajashekhara@microchip.com
Subject: [PATCH] aacraid: add a missing iounmap call
Date:   Sat, 26 Sep 2020 17:00:15 +0200
Message-Id: <20200926150015.6187-1-thenzl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add a missing resource cleanup in _aac_reset_adapter

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/aacraid/commsup.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 7c0710417d37..6cc7dabe5e11 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -1551,6 +1551,7 @@ static int _aac_reset_adapter(struct aac_dev *aac, int forced, u8 reset_type)
 	aac_fib_map_free(aac);
 	dma_free_coherent(&aac->pdev->dev, aac->comm_size, aac->comm_addr,
 			  aac->comm_phys);
+	aac_adapter_ioremap(aac, 0);
 	aac->comm_addr = NULL;
 	aac->comm_phys = 0;
 	kfree(aac->queues);
-- 
2.25.4

