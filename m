Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E550C433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  6 May 2022 10:58:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391099AbiEFLBw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 May 2022 07:01:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391083AbiEFLBu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 May 2022 07:01:50 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1683F64EF
        for <linux-scsi@vger.kernel.org>; Fri,  6 May 2022 03:58:06 -0700 (PDT)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1651834684;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=az714Uw6U2hRUUDjtCNatC/A4A3mwY8ik7Gck4abaUE=;
        b=pYy7m/fRmT9GTSC8EOKLaog2HsBf+u8Og1eXgbxRrIIsa6xQNOey5naDUJn83EwuMcIw6R
        uHrQ+cb1yVFEVSWMfa9dwWRHDvPJzB39sdYSpdcZDA/86GWyuyA8xFAu0tuv7Byv8kTqjQ
        lrXe6WGramtrD/ZnFgB412ulh8pP6V7694rrUZBkz6dfO27Cu/mOqWf/d7peA+GSbV0IUz
        B2nl/mak/snI6u+2c15HY+H4L7nGZf9ay+7pxUF4YjgfOmBRUHqSOczvtrPnUBW5P405jk
        kErMTLN/LeglOgUYU54UrnF8TJi+2P+uZBdN3BOXY5H7y3vhQEnQwYpyd9lXCQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1651834684;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=az714Uw6U2hRUUDjtCNatC/A4A3mwY8ik7Gck4abaUE=;
        b=M3kMqvOwgm3rYeie4SJAafVOKjee7cY+QOxLnnFPCzIIEaOChdIeVf5CUR+n1H537k/+IQ
        hevussZJFh3XsBCQ==
To:     linux-scsi@vger.kernel.org
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        Hannes Reinecke <hare@suse.de>,
        Javed Hasan <jhasan@marvell.com>,
        Saurav Kashyap <skashyap@marvell.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Davidlohr Bueso <dbueso@suse.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 4/4] scsi: bnx2fc: Avoid using get_cpu() in bnx2fc_cmd_alloc().
Date:   Fri,  6 May 2022 12:57:58 +0200
Message-Id: <20220506105758.283887-5-bigeasy@linutronix.de>
In-Reply-To: <20220506105758.283887-1-bigeasy@linutronix.de>
References: <20220506105758.283887-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Using get_cpu() leads to disabling preemption and in this context it is
not possible to acquire the following spinlock_t on PREEMPT_RT because
it becomes a sleeping lock.

Commit
   0ea5c27583e1c ("[SCSI] bnx2fc: common free list for cleanup commands")

says that it is using get_cpu() as a fix in case the CPU is preempted.
While this might be true, the important part is that it is now using the
same CPU for locking and unlocking while previously it always relied on
smp_processor_id().
The date structure itself is protected with a lock so it does not rely
on CPU-local access.

Replace get_cpu() with raw_smp_processor_id() to obtain the current CPU
number which is used as an index for the per-CPU resource.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/scsi/bnx2fc/bnx2fc_io.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_i=
o.c
index 6a1fc35b832ae..b42a9accb8320 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -472,7 +472,7 @@ struct bnx2fc_cmd *bnx2fc_cmd_alloc(struct bnx2fc_rport=
 *tgt)
 	u32 free_sqes;
 	u32 max_sqes;
 	u16 xid;
-	int index =3D get_cpu();
+	int index =3D raw_smp_processor_id();
=20
 	max_sqes =3D BNX2FC_SCSI_MAX_SQES;
 	/*
@@ -485,7 +485,6 @@ struct bnx2fc_cmd *bnx2fc_cmd_alloc(struct bnx2fc_rport=
 *tgt)
 	    (tgt->num_active_ios.counter  >=3D max_sqes) ||
 	    (free_sqes + max_sqes <=3D BNX2FC_SQ_WQES_MAX)) {
 		spin_unlock_bh(&cmd_mgr->free_list_lock[index]);
-		put_cpu();
 		return NULL;
 	}
=20
@@ -498,7 +497,6 @@ struct bnx2fc_cmd *bnx2fc_cmd_alloc(struct bnx2fc_rport=
 *tgt)
 	atomic_inc(&tgt->num_active_ios);
 	atomic_dec(&tgt->free_sqes);
 	spin_unlock_bh(&cmd_mgr->free_list_lock[index]);
-	put_cpu();
=20
 	INIT_LIST_HEAD(&io_req->link);
=20
--=20
2.36.0

