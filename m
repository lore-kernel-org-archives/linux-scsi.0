Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4075C4708F
	for <linux-scsi@archiver.kernel.org>; Mon, 31 May 2021 05:07:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92AD1610C8
	for <linux-scsi@archiver.kernel.org>; Mon, 31 May 2021 05:07:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbhEaFJh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 May 2021 01:09:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20256 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229730AbhEaFJg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 31 May 2021 01:09:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622437677;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5UJIi0KGvBaJJMBe4y1OqXoaepCK8zMrucjMhS/LFV0=;
        b=WtBCbfACmgs+SyRUW2y9a6IAN9JxBi8bjj8yLMty5yNG+b9V9EhBDZAvmL8xIAiFzmkGmi
        Eam45MN8W5R/ucmYwkyAGeEALBt+bx9fOdwDZA5SpJl2qa6lbkMNu2xSbHwAMxx3iJArke
        5xdpeYlIMmj5rd2dzQTRfXPGTlkRppg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-312-BAu6HjUBNiGmgejvujs9xQ-1; Mon, 31 May 2021 01:07:55 -0400
X-MC-Unique: BAu6HjUBNiGmgejvujs9xQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3D74A8042C9;
        Mon, 31 May 2021 05:07:54 +0000 (UTC)
Received: from localhost (ovpn-12-235.pek2.redhat.com [10.72.12.235])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 75A595D740;
        Mon, 31 May 2021 05:07:51 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>, John Garry <john.garry@huawei.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH V3 3/3] scsi: core: put ->shost_gendev.parent in failure handling path
Date:   Mon, 31 May 2021 13:07:27 +0800
Message-Id: <20210531050727.2353973-4-ming.lei@redhat.com>
In-Reply-To: <20210531050727.2353973-1-ming.lei@redhat.com>
References: <20210531050727.2353973-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

get_device(shost->shost_gendev.parent) is called in
scsi_add_host_with_dma(), but its counter pair isn't called in the failure
path, so fix it by calling put_device(shost->shost_gendev.parent) in its
failure path.

Reported-by: John Garry <john.garry@huawei.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/scsi/hosts.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 6cbc3eb16525..6cc43c51b7b3 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -298,6 +298,7 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
  out_del_dev:
 	device_del(&shost->shost_dev);
  out_del_gendev:
+	put_device(shost->shost_gendev.parent);
 	device_del(&shost->shost_gendev);
  out_disable_runtime_pm:
 	device_disable_async_suspend(&shost->shost_gendev);
-- 
2.29.2

