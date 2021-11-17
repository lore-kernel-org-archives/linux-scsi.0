Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59F1EC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Nov 2021 03:00:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 441A561C12
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Nov 2021 03:00:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232829AbhKQDDS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Nov 2021 22:03:18 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:47928 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232817AbhKQDDS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Nov 2021 22:03:18 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 147781FD29;
        Wed, 17 Nov 2021 03:00:19 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 52AE013BBF;
        Wed, 17 Nov 2021 03:00:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id SBVmNz9wlGFefgAAMHmgww
        (envelope-from <dave@stgolabs.net>); Wed, 17 Nov 2021 03:00:15 +0000
From:   Davidlohr Bueso <dave@stgolabs.net>
To:     martin.petersen@oracle.com, jejb@linux.ibm.com
Cc:     hare@suse.de, bigeasy@linutronix.de, tglx@linutronix.de,
        linux-scsi@vger.kernel.org, linux-rt-users@vger.kernel.org,
        linux-kernel@vger.kernel.org, dave@stgolabs.net,
        Davidlohr Bueso <dbueso@suse.de>
Subject: [PATCH 1/3] scsi/libfc: Remove get_cpu() semantics in fc_exch_em_alloc()
Date:   Tue, 16 Nov 2021 18:59:54 -0800
Message-Id: <20211117025956.79616-2-dave@stgolabs.net>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20211117025956.79616-1-dave@stgolabs.net>
References: <20211117025956.79616-1-dave@stgolabs.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The get_cpu() in fc_exch_em_alloc() was introduced in:

    f018b73af6db ([SCSI] libfc, libfcoe, fcoe: use smp_processor_id() only when preempt disabled)

for no other reason than to simply use smp_processor_id()
without getting a warning, because everything is done with
the pool->lock held anyway. However, get_cpu(), by disabling
preemption, does not play well with PREEMPT_RT, particularly
when acquiring a regular (and thus sleepable) spinlock.

Therefore remove the get_cpu() and just use the unstable value
as we will have CPU locality guarantees next by taking the lock.
The window of migration, as noted by Sebastian, is small and
even if it happens the result is correct.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
---
 drivers/scsi/libfc/fc_exch.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 841000445b9a..be37bfb2814d 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -825,10 +825,9 @@ static struct fc_exch *fc_exch_em_alloc(struct fc_lport *lport,
 	}
 	memset(ep, 0, sizeof(*ep));
 
-	cpu = get_cpu();
+	cpu = raw_smp_processor_id();
 	pool = per_cpu_ptr(mp->pool, cpu);
 	spin_lock_bh(&pool->lock);
-	put_cpu();
 
 	/* peek cache of free slot */
 	if (pool->left != FC_XID_UNKNOWN) {
-- 
2.26.2

