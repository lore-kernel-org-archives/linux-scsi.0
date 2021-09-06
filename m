Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 633E5C433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Sep 2021 09:01:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3FFE960F3A
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Sep 2021 09:01:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234755AbhIFJCW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Sep 2021 05:02:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:42467 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229499AbhIFJCW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Sep 2021 05:02:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630918877;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=6wdmD6HWgzVx/YJWyT4i2eZjjo6iKAc+s1liXG821aQ=;
        b=Zo8RcpcP25sBq4RIwB9w5SG0Wcomy8UF+0Fg/4CldCrwV2RyTGFs2e2f6lLV1pnAkHiYce
        phmjequEEAfhgsfd+d5TA6217xb5Y1YObKfnbJSUetXLSkRCUTsVfJlCW8HcyHPfIs2BNU
        rrCC7ORJ+95LY4FCnO51+4pgbipDRpk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-346-FFF4w1KKMSuqHp4KoE-mjw-1; Mon, 06 Sep 2021 05:01:16 -0400
X-MC-Unique: FFF4w1KKMSuqHp4KoE-mjw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8B6F1188352E;
        Mon,  6 Sep 2021 09:01:15 +0000 (UTC)
Received: from localhost (ovpn-8-35.pek2.redhat.com [10.72.8.35])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EF5DF60CA0;
        Mon,  6 Sep 2021 09:01:11 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>
Subject: [PATCH] scsi: sd: free 'scsi_disk' device via put_device
Date:   Mon,  6 Sep 2021 17:01:12 +0800
Message-Id: <20210906090112.531442-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Once the device is initialized via device_initialize(), it should be
freed via put_device, so fix it. Meantime get the parent before adding
device, the release handler can work as expected always.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/scsi/sd.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index cbd9999f93a6..a8039beb5a02 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3401,15 +3401,16 @@ static int sd_probe(struct device *dev)
 	}
 
 	device_initialize(&sdkp->dev);
-	sdkp->dev.parent = dev;
+	sdkp->dev.parent = get_device(dev);
 	sdkp->dev.class = &sd_disk_class;
 	dev_set_name(&sdkp->dev, "%s", dev_name(dev));
 
 	error = device_add(&sdkp->dev);
-	if (error)
-		goto out_free_index;
+	if (error) {
+		put_device(&sdkp->dev);
+		goto out;
+	}
 
-	get_device(dev);
 	dev_set_drvdata(dev, sdkp);
 
 	gd->major = sd_major((index & 0xf0) >> 4);
-- 
2.31.1

