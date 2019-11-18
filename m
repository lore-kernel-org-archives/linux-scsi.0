Return-Path: <SRS0=r6FR=ZK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2149DC432C0
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 10:31:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC30F20730
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 10:31:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JtiOg2iQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbfKRKbz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Nov 2019 05:31:55 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:37308 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726518AbfKRKbz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 18 Nov 2019 05:31:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574073114;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L14bP1v4AxvDNzpocYgioYdse5rLV822J0Dg6UrPweU=;
        b=JtiOg2iQvr3Owznbsqf962FZCaT7xPUQF3Mpu3/GuQuKwOvnHvg74y0cwDd52OhyH6SnZQ
        mzUSdCgkC7FfAaFG2IMwkHtaqdpxGVswsyiYmWmpC9lWIvzJMA9z/O3rdK2kM7wJtzNCNH
        FIBCVenQtfTri2tEcQQGdrvoWggQhKY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-48-z39Ibvi6N0Getux7GzBQLw-1; Mon, 18 Nov 2019 05:31:51 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0402E107B7C1;
        Mon, 18 Nov 2019 10:31:49 +0000 (UTC)
Received: from localhost (ovpn-8-23.pek2.redhat.com [10.72.8.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A2C8218783;
        Mon, 18 Nov 2019 10:31:44 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Chaitra P B <chaitra.basappa@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH 3/4] scsi: sd: register request queue after sd_revalidate_disk is done
Date:   Mon, 18 Nov 2019 18:31:16 +0800
Message-Id: <20191118103117.978-4-ming.lei@redhat.com>
In-Reply-To: <20191118103117.978-1-ming.lei@redhat.com>
References: <20191118103117.978-1-ming.lei@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: z39Ibvi6N0Getux7GzBQLw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for improving SSD performance in the following patch, which
needs to read queue flag of QUEUE_FLAG_NONROT in IO path. So we have
to freeze queue before changing this flag in sd_revalidate_disk().

However, queue freezing becomes quite slow after the queue is registered
because RCU period is involved.

So delay registering queue after sd_revalidate_disk() is done for
avoiding slow queue freezing which will be added to sd_revalidate_disk()
in the following patch.

Cc: Sathya Prakash <sathya.prakash@broadcom.com>
Cc: Chaitra P B <chaitra.basappa@broadcom.com>
Cc: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Sumit Saxena <sumit.saxena@broadcom.com>
Cc: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Cc: Ewan D. Milne <emilne@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>,
Cc: Hannes Reinecke <hare@suse.de>
Cc: Bart Van Assche <bart.vanassche@wdc.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/scsi/sd.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 03163ac5fe95..0744c34468e1 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3368,12 +3368,14 @@ static int sd_probe(struct device *dev)
 =09}
=20
 =09blk_pm_runtime_init(sdp->request_queue, dev);
-=09device_add_disk(dev, gd, NULL);
+=09device_add_disk_no_queue_reg(dev, gd);
 =09if (sdkp->capacity)
 =09=09sd_dif_config_host(sdkp);
=20
 =09sd_revalidate_disk(gd);
=20
+=09blk_register_queue(gd);
+
 =09if (sdkp->security) {
 =09=09sdkp->opal_dev =3D init_opal_dev(sdp, &sd_sec_submit);
 =09=09if (sdkp->opal_dev)
--=20
2.20.1

