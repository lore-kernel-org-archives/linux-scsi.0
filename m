Return-Path: <SRS0=dbdl=37=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BFD9C352A3
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Feb 2020 12:12:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 112AA206DB
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Feb 2020 12:12:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Hs33/e8C"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728324AbgBKMMm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Feb 2020 07:12:42 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:58276 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728241AbgBKMMm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 11 Feb 2020 07:12:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581423161;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dNMWdKtvi6Hy1HcK6nwSHcXHEGZv8eiC4BgPrfgPvCs=;
        b=Hs33/e8CmzcMk4IAZp3xuMVH2BH8zM7zUmkqQj41OH5gQ/VyLii9HEsWS19aQE+FPfJ8/d
        0AOnTOCVx6wFz8uHuZuLm1c4spR8em/stQzrg1JBXnqNdzwlFV8jwe840Ubx4fUQ5OXvVv
        fhYUoXnRIw4Fnh8E8fRqFrDsX7tlosE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-282-FvDEbcXYMJOGcg5pLV9TGg-1; Tue, 11 Feb 2020 07:12:39 -0500
X-MC-Unique: FvDEbcXYMJOGcg5pLV9TGg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AD58F8014CA;
        Tue, 11 Feb 2020 12:12:37 +0000 (UTC)
Received: from localhost (ovpn-8-17.pek2.redhat.com [10.72.8.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E9EE98B548;
        Tue, 11 Feb 2020 12:12:30 +0000 (UTC)
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
Subject: [PATCH 06/10] sbitmap: add helper of sbitmap_calculate_shift
Date:   Tue, 11 Feb 2020 20:11:31 +0800
Message-Id: <20200211121135.30064-7-ming.lei@redhat.com>
In-Reply-To: <20200211121135.30064-1-ming.lei@redhat.com>
References: <20200211121135.30064-1-ming.lei@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Move code for calculating default shift into one public helper,
which can be used for SCSI to calculate shift.

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
 include/linux/sbitmap.h | 18 ++++++++++++++++++
 lib/sbitmap.c           | 16 +++-------------
 2 files changed, 21 insertions(+), 13 deletions(-)

diff --git a/include/linux/sbitmap.h b/include/linux/sbitmap.h
index 34343ce3ef6c..2a40364d6d00 100644
--- a/include/linux/sbitmap.h
+++ b/include/linux/sbitmap.h
@@ -337,6 +337,24 @@ static inline int sbitmap_test_bit(struct sbitmap *s=
b, unsigned int bitnr)
 	return test_bit(SB_NR_TO_BIT(sb, bitnr), __sbitmap_word(sb, bitnr));
 }
=20
+static inline int sbitmap_calculate_shift(unsigned int depth)
+{
+	int	shift =3D ilog2(BITS_PER_LONG);
+
+	/*
+	 * If the bitmap is small, shrink the number of bits per word so
+	 * we spread over a few cachelines, at least. If less than 4
+	 * bits, just forget about it, it's not going to work optimally
+	 * anyway.
+	 */
+	if (depth >=3D 4) {
+		while ((4U << shift) > depth)
+			shift--;
+	}
+
+	return shift;
+}
+
 /**
  * sbitmap_show() - Dump &struct sbitmap information to a &struct seq_fi=
le.
  * @sb: Bitmap to show.
diff --git a/lib/sbitmap.c b/lib/sbitmap.c
index 254475865b3d..bb88a3643d64 100644
--- a/lib/sbitmap.c
+++ b/lib/sbitmap.c
@@ -96,19 +96,9 @@ int sbitmap_init_node(struct sbitmap *sb, unsigned int=
 depth, int shift,
 	unsigned int bits_per_word;
 	unsigned int i;
=20
-	if (shift < 0) {
-		shift =3D ilog2(BITS_PER_LONG);
-		/*
-		 * If the bitmap is small, shrink the number of bits per word so
-		 * we spread over a few cachelines, at least. If less than 4
-		 * bits, just forget about it, it's not going to work optimally
-		 * anyway.
-		 */
-		if (depth >=3D 4) {
-			while ((4U << shift) > depth)
-				shift--;
-		}
-	}
+	if (shift < 0)
+		shift =3D sbitmap_calculate_shift(depth);
+
 	bits_per_word =3D 1U << shift;
 	if (bits_per_word > BITS_PER_LONG)
 		return -EINVAL;
--=20
2.20.1

