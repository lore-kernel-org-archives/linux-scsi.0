Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9F90C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Nov 2021 03:00:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF1FF61BFE
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Nov 2021 03:00:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232825AbhKQDDX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Nov 2021 22:03:23 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:41834 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232852AbhKQDDV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Nov 2021 22:03:21 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 334CD212C9;
        Wed, 17 Nov 2021 03:00:22 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6407813BBF;
        Wed, 17 Nov 2021 03:00:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id UNNcDENwlGFefgAAMHmgww
        (envelope-from <dave@stgolabs.net>); Wed, 17 Nov 2021 03:00:19 +0000
From:   Davidlohr Bueso <dave@stgolabs.net>
To:     martin.petersen@oracle.com, jejb@linux.ibm.com
Cc:     hare@suse.de, bigeasy@linutronix.de, tglx@linutronix.de,
        linux-scsi@vger.kernel.org, linux-rt-users@vger.kernel.org,
        linux-kernel@vger.kernel.org, dave@stgolabs.net,
        Davidlohr Bueso <dbueso@suse.de>
Subject: [PATCH 2/3] scsi/fcoe: Add a local_lock to fcoe_percpu
Date:   Tue, 16 Nov 2021 18:59:55 -0800
Message-Id: <20211117025956.79616-3-dave@stgolabs.net>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20211117025956.79616-1-dave@stgolabs.net>
References: <20211117025956.79616-1-dave@stgolabs.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

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
---
 drivers/scsi/fcoe/fcoe.c | 6 ++++--
 include/scsi/libfcoe.h   | 2 ++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 6415f88738ad..a0064a1b4a32 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -1452,9 +1452,10 @@ static int fcoe_alloc_paged_crc_eof(struct sk_buff *skb, int tlen)
 	struct fcoe_percpu_s *fps;
 	int rc;
 
-	fps = &get_cpu_var(fcoe_percpu);
+	local_lock(&fcoe_percpu.lock);
+	fps = this_cpu_ptr(&fcoe_percpu);
 	rc = fcoe_get_paged_crc_eof(skb, tlen, fps);
-	put_cpu_var(fcoe_percpu);
+	local_unlock(&fcoe_percpu.lock);
 
 	return rc;
 }
@@ -2487,6 +2488,7 @@ static int __init fcoe_init(void)
 		p = per_cpu_ptr(&fcoe_percpu, cpu);
 		INIT_WORK(&p->work, fcoe_receive_work);
 		skb_queue_head_init(&p->fcoe_rx_list);
+		local_lock_init(&p->lock);
 	}
 
 	/* Setup link change notification */
diff --git a/include/scsi/libfcoe.h b/include/scsi/libfcoe.h
index fac8e89aed81..6e79fb87fea2 100644
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
@@ -326,6 +327,7 @@ struct fcoe_percpu_s {
 	struct sk_buff_head fcoe_rx_list;
 	struct page *crc_eof_page;
 	int crc_eof_offset;
+	local_lock_t lock;
 };
 
 /**
-- 
2.26.2

