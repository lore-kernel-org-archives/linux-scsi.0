Return-Path: <SRS0=EUsX=4Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C3E0C3F2D2
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Feb 2020 23:29:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1FC0C246A8
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Feb 2020 23:29:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C+i9ETEO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbgB1X3t (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Feb 2020 18:29:49 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:37901 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726603AbgB1X3t (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Feb 2020 18:29:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582932588;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Vp58DvZjnpkYaJYd38hCRkXrB4APAd+myF/vlSec9bE=;
        b=C+i9ETEOECkgbb6EI5OfrwNUid+aAjGCUj11cASlscf81lRdnkYvVGLkzBOckMB5fsxqqh
        OkU1WupmBCP3WkqVPWpxXxds90exGNHW//9PblXr6rpKWrqgCeQjrAkNPi0Ivn5VVK7UuC
        s6gRjyeGWDPyAc7dIFU4qRHM0IMLJsE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-25-aTwSBZpoO1GBgHiaEdALsA-1; Fri, 28 Feb 2020 18:29:44 -0500
X-MC-Unique: aTwSBZpoO1GBgHiaEdALsA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2BAA18017DF;
        Fri, 28 Feb 2020 23:29:42 +0000 (UTC)
Received: from localhost (ovpn-8-18.pek2.redhat.com [10.72.8.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B994F19C7F;
        Fri, 28 Feb 2020 23:29:38 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
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
Subject: [PATCH V2 02/10] sbitmap: add helpers for updating allocation hint
Date:   Sat, 29 Feb 2020 07:29:12 +0800
Message-Id: <20200228232920.20960-3-ming.lei@redhat.com>
In-Reply-To: <20200228232920.20960-1-ming.lei@redhat.com>
References: <20200228232920.20960-1-ming.lei@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add helpers for updating allocation hint, so that we can
avoid to duplicate code.

Prepare for moving allocation hint into sbitmap.

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
 lib/sbitmap.c | 93 ++++++++++++++++++++++++++++++---------------------
 1 file changed, 54 insertions(+), 39 deletions(-)

diff --git a/lib/sbitmap.c b/lib/sbitmap.c
index 86018a6fccae..683343e02c3b 100644
--- a/lib/sbitmap.c
+++ b/lib/sbitmap.c
@@ -9,6 +9,55 @@
 #include <linux/sbitmap.h>
 #include <linux/seq_file.h>
=20
+static int init_alloc_hint(struct sbitmap_queue *sbq, gfp_t flags)
+{
+	unsigned depth =3D sbq->sb.depth;
+
+	sbq->alloc_hint =3D alloc_percpu_gfp(unsigned int, flags);
+	if (!sbq->alloc_hint)
+		return -ENOMEM;
+
+	if (depth && !sbq->sb.round_robin) {
+		int i;
+
+		for_each_possible_cpu(i)
+			*per_cpu_ptr(sbq->alloc_hint, i) =3D prandom_u32() % depth;
+	}
+
+	return 0;
+}
+
+static inline unsigned update_alloc_hint_before_get(struct sbitmap_queue=
 *sbq,
+						    unsigned int depth)
+{
+	unsigned hint;
+
+	hint =3D this_cpu_read(*sbq->alloc_hint);
+	if (unlikely(hint >=3D depth)) {
+		hint =3D depth ? prandom_u32() % depth : 0;
+		this_cpu_write(*sbq->alloc_hint, hint);
+	}
+
+	return hint;
+}
+
+static inline void update_alloc_hint_after_get(struct sbitmap_queue *sbq=
,
+					       unsigned int depth,
+					       unsigned int hint,
+					       unsigned int nr)
+{
+	if (nr =3D=3D -1) {
+		/* If the map is full, a hint won't do us much good. */
+		this_cpu_write(*sbq->alloc_hint, 0);
+	} else if (nr =3D=3D hint || unlikely(sbq->sb.round_robin)) {
+		/* Only update the hint if we used it. */
+		hint =3D nr + 1;
+		if (hint >=3D depth - 1)
+			hint =3D 0;
+		this_cpu_write(*sbq->alloc_hint, hint);
+	}
+}
+
 /*
  * See if we have deferred clears that we can batch move
  */
@@ -360,17 +409,11 @@ int sbitmap_queue_init_node(struct sbitmap_queue *s=
bq, unsigned int depth,
 	if (ret)
 		return ret;
=20
-	sbq->alloc_hint =3D alloc_percpu_gfp(unsigned int, flags);
-	if (!sbq->alloc_hint) {
+	if (init_alloc_hint(sbq, flags) !=3D 0) {
 		sbitmap_free(&sbq->sb);
 		return -ENOMEM;
 	}
=20
-	if (depth && !round_robin) {
-		for_each_possible_cpu(i)
-			*per_cpu_ptr(sbq->alloc_hint, i) =3D prandom_u32() % depth;
-	}
-
 	sbq->min_shallow_depth =3D UINT_MAX;
 	sbq->wake_batch =3D sbq_calc_wake_batch(sbq, depth);
 	atomic_set(&sbq->wake_index, 0);
@@ -423,24 +466,10 @@ int __sbitmap_queue_get(struct sbitmap_queue *sbq)
 	unsigned int hint, depth;
 	int nr;
=20
-	hint =3D this_cpu_read(*sbq->alloc_hint);
 	depth =3D READ_ONCE(sbq->sb.depth);
-	if (unlikely(hint >=3D depth)) {
-		hint =3D depth ? prandom_u32() % depth : 0;
-		this_cpu_write(*sbq->alloc_hint, hint);
-	}
+	hint =3D update_alloc_hint_before_get(sbq, depth);
 	nr =3D sbitmap_get(&sbq->sb, hint);
-
-	if (nr =3D=3D -1) {
-		/* If the map is full, a hint won't do us much good. */
-		this_cpu_write(*sbq->alloc_hint, 0);
-	} else if (nr =3D=3D hint || unlikely(sbq->sb.round_robin)) {
-		/* Only update the hint if we used it. */
-		hint =3D nr + 1;
-		if (hint >=3D depth - 1)
-			hint =3D 0;
-		this_cpu_write(*sbq->alloc_hint, hint);
-	}
+	update_alloc_hint_after_get(sbq, depth, hint, nr);
=20
 	return nr;
 }
@@ -454,24 +483,10 @@ int __sbitmap_queue_get_shallow(struct sbitmap_queu=
e *sbq,
=20
 	WARN_ON_ONCE(shallow_depth < sbq->min_shallow_depth);
=20
-	hint =3D this_cpu_read(*sbq->alloc_hint);
 	depth =3D READ_ONCE(sbq->sb.depth);
-	if (unlikely(hint >=3D depth)) {
-		hint =3D depth ? prandom_u32() % depth : 0;
-		this_cpu_write(*sbq->alloc_hint, hint);
-	}
+	hint =3D update_alloc_hint_before_get(sbq, depth);
 	nr =3D sbitmap_get_shallow(&sbq->sb, hint, shallow_depth);
-
-	if (nr =3D=3D -1) {
-		/* If the map is full, a hint won't do us much good. */
-		this_cpu_write(*sbq->alloc_hint, 0);
-	} else if (nr =3D=3D hint || unlikely(sbq->sb.round_robin)) {
-		/* Only update the hint if we used it. */
-		hint =3D nr + 1;
-		if (hint >=3D depth - 1)
-			hint =3D 0;
-		this_cpu_write(*sbq->alloc_hint, hint);
-	}
+	update_alloc_hint_after_get(sbq, depth, hint, nr);
=20
 	return nr;
 }
--=20
2.20.1

