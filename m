Return-Path: <SRS0=1Um0=3I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DC2EC33CB6
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jan 2020 07:15:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 142892081E
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jan 2020 07:15:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Xs5hHJFv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726744AbgASHPW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 19 Jan 2020 02:15:22 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:37267 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726421AbgASHPW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 19 Jan 2020 02:15:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579418122;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5XwGpGzb35Aht5FANg0+PHZ30iYq94l9uvU4jwniegA=;
        b=Xs5hHJFvuX/rxTu13H9IhGW2mfmCYmiLEuA/zWGtYPyxZRa9PUXDnf12ufZOghPQww9HMJ
        qKsQCSQ/sBBzmxBWB0execqhUcLL6r7MR15E9Jz436u4A0IuxBaIk//vrfK7hFcB+ka3Y0
        x4mnBTb4pAJF2Uf5a/mC5c67IqOxhxE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-213-8MmHpCgcN3iVqwSU_H0-pw-1; Sun, 19 Jan 2020 02:15:15 -0500
X-MC-Unique: 8MmHpCgcN3iVqwSU_H0-pw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DAA31185432C;
        Sun, 19 Jan 2020 07:15:12 +0000 (UTC)
Received: from localhost (ovpn-8-23.pek2.redhat.com [10.72.8.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 958EA5D9CD;
        Sun, 19 Jan 2020 07:15:09 +0000 (UTC)
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
Subject: [PATCH 4/6] block: freeze queue for updating QUEUE_FLAG_NONROT
Date:   Sun, 19 Jan 2020 15:14:30 +0800
Message-Id: <20200119071432.18558-5-ming.lei@redhat.com>
In-Reply-To: <20200119071432.18558-1-ming.lei@redhat.com>
References: <20200119071432.18558-1-ming.lei@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We will read the NONROT flag for bypassing scsi->device_busy in SCSI
IO path, so have to freeze queue when updating this flag.

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
 block/blk-sysfs.c | 14 +++++++++++++-
 drivers/scsi/sd.c |  4 ++++
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index fca9b158f4a0..9cc0dd5f88a1 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -281,6 +281,18 @@ QUEUE_SYSFS_BIT_FNS(random, ADD_RANDOM, 0);
 QUEUE_SYSFS_BIT_FNS(iostats, IO_STAT, 0);
 #undef QUEUE_SYSFS_BIT_FNS
=20
+static ssize_t queue_store_nonrot_freeze(struct request_queue *q,
+		const char *page, size_t count)
+{
+	size_t ret;
+
+	blk_mq_freeze_queue(q);
+	ret =3D queue_store_nonrot(q, page, count);
+	blk_mq_unfreeze_queue(q);
+
+	return ret;
+}
+
 static ssize_t queue_zoned_show(struct request_queue *q, char *page)
 {
 	switch (blk_queue_zoned_model(q)) {
@@ -642,7 +654,7 @@ static struct queue_sysfs_entry queue_write_zeroes_ma=
x_entry =3D {
 static struct queue_sysfs_entry queue_nonrot_entry =3D {
 	.attr =3D {.name =3D "rotational", .mode =3D 0644 },
 	.show =3D queue_show_nonrot,
-	.store =3D queue_store_nonrot,
+	.store =3D queue_store_nonrot_freeze,
 };
=20
 static struct queue_sysfs_entry queue_zoned_entry =3D {
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index f401ba96dcfd..349c944b29a3 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2935,7 +2935,9 @@ static void sd_read_block_characteristics(struct sc=
si_disk *sdkp)
 	rot =3D get_unaligned_be16(&buffer[4]);
=20
 	if (rot =3D=3D 1) {
+		blk_mq_freeze_queue(q);
 		blk_queue_flag_set(QUEUE_FLAG_NONROT, q);
+		blk_mq_unfreeze_queue(q);
 		blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, q);
 	}
=20
@@ -3131,7 +3133,9 @@ static int sd_revalidate_disk(struct gendisk *disk)
 		 * cause this to be updated correctly and any device which
 		 * doesn't support it should be treated as rotational.
 		 */
+		blk_mq_freeze_queue(q);
 		blk_queue_flag_clear(QUEUE_FLAG_NONROT, q);
+		blk_mq_unfreeze_queue(q);
 		blk_queue_flag_set(QUEUE_FLAG_ADD_RANDOM, q);
=20
 		if (scsi_device_supports_vpd(sdp)) {
--=20
2.20.1

