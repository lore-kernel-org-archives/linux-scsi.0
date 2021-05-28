Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40E67C4707F
	for <linux-scsi@archiver.kernel.org>; Fri, 28 May 2021 01:19:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 163C461378
	for <linux-scsi@archiver.kernel.org>; Fri, 28 May 2021 01:19:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235119AbhE1BUl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 May 2021 21:20:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32983 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233887AbhE1BUk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 27 May 2021 21:20:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622164746;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zVlDftVe6eOa5AQYy8K0pIAtbGYKu1lYu7Dl7fPSiqc=;
        b=VepUtQMsEjyNT5+ujMyFxP30ozt+0rb840oNE/lOQbl5jUbAA3lUwr48niwRBELQudzply
        5As+5x17s0u+jQtJGOnvHwh9nP+V5fRFotZoti+WxMsGVtHcmsJYIgcYcW3/brLae9zW4y
        tNTKxHSNl3g2tB6b9ZL3ZgRjHMrD00c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-543-HINxxxouOLe887m8b_iI7Q-1; Thu, 27 May 2021 21:19:04 -0400
X-MC-Unique: HINxxxouOLe887m8b_iI7Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1BFCA801B13;
        Fri, 28 May 2021 01:19:03 +0000 (UTC)
Received: from localhost (ovpn-12-72.pek2.redhat.com [10.72.12.72])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 773EC50DE3;
        Fri, 28 May 2021 01:19:02 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>, John Garry <john.garry@huawei.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH V2 2/2] scsi: core: put shost->shost_gendev in failure handling path
Date:   Fri, 28 May 2021 09:18:38 +0800
Message-Id: <20210528011838.2122559-3-ming.lei@redhat.com>
In-Reply-To: <20210528011838.2122559-1-ming.lei@redhat.com>
References: <20210528011838.2122559-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

get_device(&shost->shost_gendev) is called in scsi_add_host_with_dma(),
but its counter pair isn't called in the failure path, so fix it
by calling put_device(&shost->shost_gendev) in its failure path.

Reported-by: John Garry <john.garry@huawei.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/scsi/hosts.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index ea50856cb203..492b64f349e1 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -295,6 +295,7 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
 	 * scsi_host_dev_release, so not free them in the failure path
 	 */
  out_del_dev:
+	put_device(&shost->shost_gendev);
 	device_del(&shost->shost_dev);
  out_del_gendev:
 	device_del(&shost->shost_gendev);
-- 
2.29.2

