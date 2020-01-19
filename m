Return-Path: <SRS0=1Um0=3I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92060C33CBA
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jan 2020 07:15:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 675292072B
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jan 2020 07:15:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fHtNGmSK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726744AbgASHPC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 19 Jan 2020 02:15:02 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:45450 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726421AbgASHPC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 19 Jan 2020 02:15:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579418100;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iybflM26WYMeoCRAkRYTW6uRVuVHivY05NfEWJZtDVs=;
        b=fHtNGmSKZkDQmyQzO2K4rMo3b2GIOnlqaobiwVBLVVx2pcMbn/+9Z7LqdJidlHd2jiAOt8
        tLE0weSRyBFmqOq2BD6Eck1h7B4KDNjjbIPtWa1taveHPZ0D/kBQdUZF8w3zwC/4qPER3C
        +Y4MnoN16HPb5yuZP0Vqs6UzL6keotU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-372-3Eh3k-aQPU6VwzYAc0Cvkg-1; Sun, 19 Jan 2020 02:14:57 -0500
X-MC-Unique: 3Eh3k-aQPU6VwzYAc0Cvkg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3AA47185432D;
        Sun, 19 Jan 2020 07:14:55 +0000 (UTC)
Received: from localhost (ovpn-8-23.pek2.redhat.com [10.72.8.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7E6E884BC8;
        Sun, 19 Jan 2020 07:14:51 +0000 (UTC)
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
        Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH 1/6] scsi: mpt3sas: don't use .device_busy in device reset routine
Date:   Sun, 19 Jan 2020 15:14:27 +0800
Message-Id: <20200119071432.18558-2-ming.lei@redhat.com>
In-Reply-To: <20200119071432.18558-1-ming.lei@redhat.com>
References: <20200119071432.18558-1-ming.lei@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsih_dev_reset() uses scsi_device->device_busy to check if there is
inflight commands aimed to this LUN.

Uses block layer's helper of blk_mq_tagset_busy_iter() to do that, so
we can prepare for bypassing .device_busy for SSD since it is quite
expensive to inc/dec the global atomic counter in IO path.

With this change, no driver uses scsi_device->device_busy any more.

Cc: Sathya Prakash <sathya.prakash@broadcom.com>
Cc: Chaitra P B <chaitra.basappa@broadcom.com>
Cc: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Sumit Saxena <sumit.saxena@broadcom.com>
Cc: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Cc: Ewan D. Milne <emilne@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Bart Van Assche <bart.vanassche@wdc.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 32 +++++++++++++++++++++++++++-
 1 file changed, 31 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/=
mpt3sas_scsih.c
index c597d544eb39..91766c172d8f 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -2994,6 +2994,36 @@ scsih_abort(struct scsi_cmnd *scmd)
 	return r;
 }
=20
+struct device_busy {
+	struct scsi_device *dev;
+	unsigned int cnt;
+};
+
+static bool scsi_device_check_in_flight(struct request *rq, void *data,
+				      bool reserved)
+{
+	struct device_busy *busy =3D data;
+	struct scsi_cmnd *cmd =3D blk_mq_rq_to_pdu(rq);
+
+	if (test_bit(SCMD_STATE_INFLIGHT, &cmd->state) && cmd->device =3D=3D
+			busy->dev)
+		(busy->cnt)++;
+
+	return true;
+}
+
+static bool scsih_dev_busy(struct scsi_device *device)
+{
+	struct device_busy data =3D {
+		.dev =3D	device,
+		.cnt =3D 0,
+	};
+
+	blk_mq_tagset_busy_iter(&device->host->tag_set,
+				scsi_device_check_in_flight, &data);
+	return data.cnt > 0;
+}
+
 /**
  * scsih_dev_reset - eh threads main device reset routine
  * @scmd: pointer to scsi command object
@@ -3060,7 +3090,7 @@ scsih_dev_reset(struct scsi_cmnd *scmd)
 		MPI2_SCSITASKMGMT_TASKTYPE_LOGICAL_UNIT_RESET, 0, 0,
 		tr_timeout, tr_method);
 	/* Check for busy commands after reset */
-	if (r =3D=3D SUCCESS && atomic_read(&scmd->device->device_busy))
+	if (r =3D=3D SUCCESS && scsih_dev_busy(scmd->device))
 		r =3D FAILED;
  out:
 	sdev_printk(KERN_INFO, scmd->device, "device reset: %s scmd(0x%p)\n",
--=20
2.20.1

