Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAF7BC47082
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Jun 2021 14:57:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE14A6124B
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Jun 2021 14:57:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233728AbhFHO7L (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Jun 2021 10:59:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41824 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233648AbhFHO7K (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jun 2021 10:59:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623164237;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=if2YOJJrnJLCKZDdSkb/6AGH98oArhKFEZFHmlp9nPc=;
        b=dU9/TWuYshWFHbhlpRsL87f2uIdn4zYMa4t8DpzGajKRZLkEH5bL28hZCfYF4lQG/iSH34
        vx8tHMzpyezj425KDUILUUi55tZ8Eg6JxO0jssO9J8wakyTGok/hckz9y1m5Su8oUA8ujU
        LWWxaT5L2uZTfU+ddGMYgmTnXcIlEik=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-120-HY4pPYu3MZ2aJ9zj5Ybn1g-1; Tue, 08 Jun 2021 10:57:15 -0400
X-MC-Unique: HY4pPYu3MZ2aJ9zj5Ybn1g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7B156800D62;
        Tue,  8 Jun 2021 14:57:14 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.40.192.236])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9303C5D9DC;
        Tue,  8 Jun 2021 14:57:13 +0000 (UTC)
From:   Tomas Henzl <thenzl@redhat.com>
To:     linux-scsi@vger.kernel.org
Cc:     kashyap.desai@broadcom.com, sathya.prakash@broadcom.com
Subject: [PATCH V2] mpi3mr: fix a double free
Date:   Tue,  8 Jun 2021 16:57:12 +0200
Message-Id: <20210608145712.16386-1-thenzl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix a double free, scsi_tgt_priv_data will be freed
in mpi3mr_target_destroy so remove the kfree from 
mpi3mr_target_alloc.
I've also removed few unneeded initialisations.

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
V2: removed init of scsi_tgt_priv_data->starget = starget and
scsi_tgt_priv_data->dev_handle = MPI3MR_INVALID_DEV_HANDLE
suggested by Kashyap


 drivers/scsi/mpi3mr/mpi3mr_os.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index a54aa009ec5a..29d43235b525 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -3294,13 +3294,10 @@ static int mpi3mr_target_alloc(struct scsi_target *starget)
 		return -ENOMEM;
 
 	starget->hostdata = scsi_tgt_priv_data;
-	scsi_tgt_priv_data->starget = starget;
-	scsi_tgt_priv_data->dev_handle = MPI3MR_INVALID_DEV_HANDLE;
 
 	spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
 	tgt_dev = __mpi3mr_get_tgtdev_by_perst_id(mrioc, starget->id);
 	if (tgt_dev && !tgt_dev->is_hidden) {
-		starget->hostdata = scsi_tgt_priv_data;
 		scsi_tgt_priv_data->starget = starget;
 		scsi_tgt_priv_data->dev_handle = tgt_dev->dev_handle;
 		scsi_tgt_priv_data->perst_id = tgt_dev->perst_id;
@@ -3309,10 +3306,8 @@ static int mpi3mr_target_alloc(struct scsi_target *starget)
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

