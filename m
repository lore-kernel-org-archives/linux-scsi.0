Return-Path: <SRS0=1Um0=3I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21333C33CB1
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jan 2020 07:15:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E91A82087E
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jan 2020 07:15:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DSm7FBgS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726621AbgASHPN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 19 Jan 2020 02:15:13 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:53627 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726444AbgASHPN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Jan 2020 02:15:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579418112;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eAGUB+1EGEZIIMkgrPBp+rzVSx6XFXPgJno8wjIOYho=;
        b=DSm7FBgStJhqZSffdqfIjWhUqMQG0/BIfYpVD2SOo8QF1pw0L6rmmNClw5N3mSIO/FgBfU
        B0j7GobKr0/u2BrdEIqB6Mp6iRkpbxGUkm2ApGfKmKEogPlAmhjO4J+O1UIH1d4mR12kIs
        J67V9RFQjubOCDGDHYlZsAzdEwME1T8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-393-3oOzpheHMlKatQ7VhE93uQ-1; Sun, 19 Jan 2020 02:15:09 -0500
X-MC-Unique: 3oOzpheHMlKatQ7VhE93uQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1DD4D107ACCA;
        Sun, 19 Jan 2020 07:15:07 +0000 (UTC)
Received: from localhost (ovpn-8-23.pek2.redhat.com [10.72.8.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 018E260BEC;
        Sun, 19 Jan 2020 07:15:02 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Ming Lei <ming.lei@redhat.com>,
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
Subject: [PATCH 3/6] scsi: sd: register request queue after sd_revalidate_disk is done
Date:   Sun, 19 Jan 2020 15:14:29 +0800
Message-Id: <20200119071432.18558-4-ming.lei@redhat.com>
In-Reply-To: <20200119071432.18558-1-ming.lei@redhat.com>
References: <20200119071432.18558-1-ming.lei@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for improving SSD performance in the following patch, which
needs to read queue flag of QUEUE_FLAG_NONROT in IO path. So we have
to freeze queue before changing this flag in sd_revalidate_disk().

However, queue freezing becomes quite slow after the queue is registered
because RCU grace period is involved.

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
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/scsi/sd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 5afb0046b12a..f401ba96dcfd 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3380,11 +3380,12 @@ static int sd_probe(struct device *dev)
 		pm_runtime_set_autosuspend_delay(dev,
 			sdp->host->hostt->rpm_autosuspend_delay);
 	}
-	device_add_disk(dev, gd, NULL);
+	device_add_disk_no_queue_reg(dev, gd);
 	if (sdkp->capacity)
 		sd_dif_config_host(sdkp);
=20
 	sd_revalidate_disk(gd);
+	blk_register_queue(gd);
=20
 	if (sdkp->security) {
 		sdkp->opal_dev =3D init_opal_dev(sdp, &sd_sec_submit);
--=20
2.20.1

