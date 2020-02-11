Return-Path: <SRS0=dbdl=37=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2548C352A3
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Feb 2020 12:12:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7798C206DB
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Feb 2020 12:12:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aOLWFlZ2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728626AbgBKMMg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Feb 2020 07:12:36 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:46508 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728276AbgBKMMg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 11 Feb 2020 07:12:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581423155;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WiTipfkLrqtLl/ZixFIKofa3xAQ/IjBrUQCQVY1fURk=;
        b=aOLWFlZ2VYGBBveNlushxqdKnPuyHnhxk9TnVH6BSJI24zlqBUsGw7+YpPoGcVfcqtY11s
        yKOHyJ9XK5q9WDeYNcygiIt5y6A435mls+7nZSvB3UDx4oVpLPNpwZyZqLnZsiZtMu46L8
        ausxFKM43c7z9vPuZHwiafu3hJN4sPA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-425-yZpK-6OgMEW43AngSoL3uA-1; Tue, 11 Feb 2020 07:12:31 -0500
X-MC-Unique: yZpK-6OgMEW43AngSoL3uA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 554A0800D55;
        Tue, 11 Feb 2020 12:12:28 +0000 (UTC)
Received: from localhost (ovpn-8-17.pek2.redhat.com [10.72.8.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DFF4F27081;
        Tue, 11 Feb 2020 12:12:22 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     Ming Lei <ming.lei@redhat.com>, Omar Sandoval <osandov@fb.com>,
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
Subject: [PATCH 05/10] sbitmap: export sbitmap_weight
Date:   Tue, 11 Feb 2020 20:11:30 +0800
Message-Id: <20200211121135.30064-6-ming.lei@redhat.com>
In-Reply-To: <20200211121135.30064-1-ming.lei@redhat.com>
References: <20200211121135.30064-1-ming.lei@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SCSI's .device_busy will be converted to sbitmap, and sbitmap_weight
is needed, so export the helper.

Cc: Omar Sandoval <osandov@fb.com>
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
 include/linux/sbitmap.h |  9 +++++++++
 lib/sbitmap.c           | 11 ++++++-----
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/include/linux/sbitmap.h b/include/linux/sbitmap.h
index 103b41c03311..34343ce3ef6c 100644
--- a/include/linux/sbitmap.h
+++ b/include/linux/sbitmap.h
@@ -346,6 +346,15 @@ static inline int sbitmap_test_bit(struct sbitmap *s=
b, unsigned int bitnr)
  */
 void sbitmap_show(struct sbitmap *sb, struct seq_file *m);
=20
+
+/**
+ * sbitmap_weight() - Return how many real bits set in a &struct sbitmap=
.
+ * @sb: Bitmap to check.
+ *
+ * Return: How many real bits set
+ */
+unsigned int sbitmap_weight(const struct sbitmap *sb);
+
 /**
  * sbitmap_bitmap_show() - Write a hex dump of a &struct sbitmap to a &s=
truct
  * seq_file.
diff --git a/lib/sbitmap.c b/lib/sbitmap.c
index ca1a446574aa..254475865b3d 100644
--- a/lib/sbitmap.c
+++ b/lib/sbitmap.c
@@ -345,20 +345,21 @@ static unsigned int __sbitmap_weight(const struct s=
bitmap *sb, bool set)
 	return weight;
 }
=20
-static unsigned int sbitmap_weight(const struct sbitmap *sb)
+static unsigned int sbitmap_cleared(const struct sbitmap *sb)
 {
-	return __sbitmap_weight(sb, true);
+	return __sbitmap_weight(sb, false);
 }
=20
-static unsigned int sbitmap_cleared(const struct sbitmap *sb)
+unsigned int sbitmap_weight(const struct sbitmap *sb)
 {
-	return __sbitmap_weight(sb, false);
+	return __sbitmap_weight(sb, true) - sbitmap_cleared(sb);
 }
+EXPORT_SYMBOL_GPL(sbitmap_weight);
=20
 void sbitmap_show(struct sbitmap *sb, struct seq_file *m)
 {
 	seq_printf(m, "depth=3D%u\n", sb->depth);
-	seq_printf(m, "busy=3D%u\n", sbitmap_weight(sb) - sbitmap_cleared(sb));
+	seq_printf(m, "busy=3D%u\n", sbitmap_weight(sb));
 	seq_printf(m, "cleared=3D%u\n", sbitmap_cleared(sb));
 	seq_printf(m, "bits_per_word=3D%u\n", 1U << sb->shift);
 	seq_printf(m, "map_nr=3D%u\n", sb->map_nr);
--=20
2.20.1

