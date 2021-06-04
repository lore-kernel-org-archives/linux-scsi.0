Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23310C4743C
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Jun 2021 18:26:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0297861406
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Jun 2021 18:26:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbhFDS2I (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Jun 2021 14:28:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38264 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229769AbhFDS2H (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Jun 2021 14:28:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622831180;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Mv7uXkgY5PVRquRJS6H5Ba6nGlgoWs763Ui8NnpQ+gw=;
        b=NbT0IM2wkSfY2xX/hqmP8VZqbPqu1FKU2j6OBbpYicMcY9qwIeSnMk4YpQD7HxGuSAeoct
        L6nyjTcDtb+JAxWfx28Ucq4Hj58Yu5TbQCUrkdGKy5V5GdZZCPsdEM+mxY9BfoJ4O2oVJL
        ViB6NVaQ7ILpd0mY9DzQ+26zjkesxkE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-508-oiwmGK49MZWbKSbGQSYOfQ-1; Fri, 04 Jun 2021 14:26:18 -0400
X-MC-Unique: oiwmGK49MZWbKSbGQSYOfQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 89C6D10CE783;
        Fri,  4 Jun 2021 18:26:17 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.40.192.170])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AB9375D74B;
        Fri,  4 Jun 2021 18:26:16 +0000 (UTC)
From:   Tomas Henzl <thenzl@redhat.com>
To:     linux-scsi@vger.kernel.org
Cc:     kashyap.desai@broadcom.com, sathya.prakash@broadcom.com
Subject: [PATCH] mpi3mr: fix a double free
Date:   Fri,  4 Jun 2021 20:26:15 +0200
Message-Id: <20210604182615.9593-1-thenzl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix a double free, scsi_tgt_priv_data will be freed
in mpi3mr_target_destroy.
I've also removed a second init of starget->hostdata
with the same value.

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index a54aa009ec5a..0681d9133fe4 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -3300,7 +3300,6 @@ static int mpi3mr_target_alloc(struct scsi_target *starget)
 	spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
 	tgt_dev = __mpi3mr_get_tgtdev_by_perst_id(mrioc, starget->id);
 	if (tgt_dev && !tgt_dev->is_hidden) {
-		starget->hostdata = scsi_tgt_priv_data;
 		scsi_tgt_priv_data->starget = starget;
 		scsi_tgt_priv_data->dev_handle = tgt_dev->dev_handle;
 		scsi_tgt_priv_data->perst_id = tgt_dev->perst_id;
@@ -3309,10 +3308,8 @@ static int mpi3mr_target_alloc(struct scsi_target *starget)
 		tgt_dev->starget = starget;
 		atomic_set(&scsi_tgt_priv_data->block_io, 0);
 		retval = 0;
-	} else {
-		kfree(scsi_tgt_priv_data);
+	} else
 		retval = -ENXIO;
-	}
 	spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
 
 	return retval;
-- 
2.31.1

