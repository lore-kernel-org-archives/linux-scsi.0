Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6712C433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  6 May 2022 10:58:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391102AbiEFLBz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 May 2022 07:01:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391095AbiEFLBv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 May 2022 07:01:51 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1758B183A1
        for <linux-scsi@vger.kernel.org>; Fri,  6 May 2022 03:58:06 -0700 (PDT)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1651834683;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t51aPj6atti1TjwQSM11HjfqS0rAN9YXmURyukaAX5s=;
        b=W13TfLmet4ZK5qgd4vFKJVod65HTVP/jLyZtyl2Nplqxt4a0h/vIUntwk5mLBWk214A/Dc
        TB6W28B82ADHMol86YvXgQueaXBfsL9H9K5cxHnBmt9k0ASaFnxJYnJrwc3AoA/0YlC+M9
        9ir24Y+pMcNI6/4IJgiXfpweyiPd/43wFTX54Cw6xn6MoDoKFVk4XtgoBhJLuRXdfIybtF
        4x80pN0EiDqlzalQylyHMIgb2d15SKfdGwDzrBEoh69avtygBt2oLFhN0hX/6momNOMl7I
        AlvOB1m8OJMS6JO8tIArZ3N7Z+8jKn2rmVCG7YBYlzeVJOrG+SQEUUg+D5lCYQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1651834683;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t51aPj6atti1TjwQSM11HjfqS0rAN9YXmURyukaAX5s=;
        b=m3ABj958awlvoW5uSpMwyS1BoY2bhNTeiLhrU+DdYvwQ4JAZqZGHCJJRJuUaDKHd/6fmmv
        Ii2qYK5Zmzk/sKCw==
To:     linux-scsi@vger.kernel.org
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        Hannes Reinecke <hare@suse.de>,
        Javed Hasan <jhasan@marvell.com>,
        Saurav Kashyap <skashyap@marvell.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Davidlohr Bueso <dbueso@suse.de>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 1/4] scsi: fcoe: Add a local_lock to fcoe_percpu
Date:   Fri,  6 May 2022 12:57:55 +0200
Message-Id: <20220506105758.283887-2-bigeasy@linutronix.de>
In-Reply-To: <20220506105758.283887-1-bigeasy@linutronix.de>
References: <20220506105758.283887-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Davidlohr Bueso <dave@stgolabs.net>

fcoe_get_paged_crc_eof() relies on the caller having preemption
disabled to ensure the per-CPU fcoe_percpu context remains valid
throughout the call. This is done by either holding spinlocks
(such as bnx2fc_global_lock or qedf_global_lock) or the get_cpu()
from fcoe_alloc_paged_crc_eof(). This last one breaks PREEMPT_RT
semantics as there can be memory allocation and end up sleeping
in atomic contexts.

Introduce a local_lock_t to struct fcoe_percpu that will keep the
non-RT case the same, mapping to preempt_disable/enable, while
RT will use a per-CPU spinlock allowing the region to be preemptible
but still maintain CPU locality. The other users of fcoe_percpu
are already safe in this regard and do not require local_lock()ing.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Link: https://lore.kernel.org/r/20211117025956.79616-3-dave@stgolabs.net
---
 drivers/scsi/fcoe/fcoe.c | 6 ++++--
 include/scsi/libfcoe.h   | 2 ++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 983e00135feac..af9b788823ac7 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -1453,9 +1453,10 @@ static int fcoe_alloc_paged_crc_eof(struct sk_buff *=
skb, int tlen)
 	struct fcoe_percpu_s *fps;
 	int rc;
=20
-	fps =3D &get_cpu_var(fcoe_percpu);
+	local_lock(&fcoe_percpu.lock);
+	fps =3D this_cpu_ptr(&fcoe_percpu);
 	rc =3D fcoe_get_paged_crc_eof(skb, tlen, fps);
-	put_cpu_var(fcoe_percpu);
+	local_unlock(&fcoe_percpu.lock);
=20
 	return rc;
 }
@@ -2488,6 +2489,7 @@ static int __init fcoe_init(void)
 		p =3D per_cpu_ptr(&fcoe_percpu, cpu);
 		INIT_WORK(&p->work, fcoe_receive_work);
 		skb_queue_head_init(&p->fcoe_rx_list);
+		local_lock_init(&p->lock);
 	}
=20
 	/* Setup link change notification */
diff --git a/include/scsi/libfcoe.h b/include/scsi/libfcoe.h
index 310e0dbffda99..279782156373a 100644
--- a/include/scsi/libfcoe.h
+++ b/include/scsi/libfcoe.h
@@ -14,6 +14,7 @@
 #include <linux/netdevice.h>
 #include <linux/skbuff.h>
 #include <linux/workqueue.h>
+#include <linux/local_lock.h>
 #include <linux/random.h>
 #include <scsi/fc/fc_fcoe.h>
 #include <scsi/libfc.h>
@@ -327,6 +328,7 @@ struct fcoe_percpu_s {
 	struct sk_buff_head fcoe_rx_list;
 	struct page *crc_eof_page;
 	int crc_eof_offset;
+	local_lock_t lock;
 };
=20
 /**
--=20
2.36.0

