Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E5EDC433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  6 May 2022 10:58:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391101AbiEFLBx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 May 2022 07:01:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391096AbiEFLBv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 May 2022 07:01:51 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B7EF1F614
        for <linux-scsi@vger.kernel.org>; Fri,  6 May 2022 03:58:06 -0700 (PDT)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1651834684;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J7v1Eab4GLB095312EVi4rIlE+wlQX1zpsqmd0x9ybM=;
        b=Cb5ujYm5L443htQigITpl6UGitu5IHjn5vht87GJWbprdM/b6lJbwtlmDxz89T/Wz8KN+Q
        z5qWiQPLr6/0AsAaI4LU8cWJ7m5Z0O0MRVT7+dDTBn62fZzh3aLaDmgKfj1f/14lu22WUF
        fzAWmfHV8l024igzLfDS6WM5FiEy+ayZ9JGwJMSk1akZaR8gU7e97fjA+Cw6PBG05Cmtzj
        DFgwW88drSGuzeYn7l09RVfqvCjFTVvfI95sHZsHe2FACnfw755C/JBgz51wQca3GkObAi
        20WW7VlFLnh6zzqpkjxyLdF4p6QHIY1N9QNcruid5HeeYAtRiLYxhkVL/LCf6w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1651834684;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J7v1Eab4GLB095312EVi4rIlE+wlQX1zpsqmd0x9ybM=;
        b=xhopbmP0VMnlwzROnbcyYAFdYvSx7w+EMur+vAIJjPMTfuXv5mDwr/fSVsZa+/vbmh41Ms
        La+Vs/4ebZxlaFCw==
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
Subject: [PATCH 3/4] scsi: libfc: Remove get_cpu() semantics in fc_exch_em_alloc()
Date:   Fri,  6 May 2022 12:57:57 +0200
Message-Id: <20220506105758.283887-4-bigeasy@linutronix.de>
In-Reply-To: <20220506105758.283887-1-bigeasy@linutronix.de>
References: <20220506105758.283887-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Davidlohr Bueso <dave@stgolabs.net>

The get_cpu() in fc_exch_em_alloc() was introduced in:

    f018b73af6db ([SCSI] libfc, libfcoe, fcoe: use smp_processor_id() only =
when preempt disabled)

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
Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Link: https://lore.kernel.org/r/20211117025956.79616-2-dave@stgolabs.net
---
 drivers/scsi/libfc/fc_exch.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index aa223db4cf53c..1d91c457527f3 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -825,10 +825,9 @@ static struct fc_exch *fc_exch_em_alloc(struct fc_lpor=
t *lport,
 	}
 	memset(ep, 0, sizeof(*ep));
=20
-	cpu =3D get_cpu();
+	cpu =3D raw_smp_processor_id();
 	pool =3D per_cpu_ptr(mp->pool, cpu);
 	spin_lock_bh(&pool->lock);
-	put_cpu();
=20
 	/* peek cache of free slot */
 	if (pool->left !=3D FC_XID_UNKNOWN) {
--=20
2.36.0

