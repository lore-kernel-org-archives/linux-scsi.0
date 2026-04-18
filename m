Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B9B7377017
	for <linux-scsi@vger.kernel.org>; Sat, 18 Apr 2026 13:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776519023; cv=none; b=QmxmpZZu18G9DCThoNqFaoHsJAE4on9zf1PjE83KYIWeWF1pOf/Ais/UBawzVNfObnSSIxXKmm9LZ7LlN0SKaQSII3SR4DCsnKlVey+cHBJ3utfABbFWaRymV6B+1n2fDXyOZnUcNrmSFMLI4HH08T2i77I877SORTHK1vipUpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776519023; c=relaxed/simple;
	bh=qZvlNuK8tH4BDyFywnoaGtb4DYHdxKKSUg7PjuGMihs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KSOFlLxAQ5hoe4sjdUolUekExD3V/wrisNY5il0KTEO1WRYQsd3UrojnID61ZTABjocMUQ2H0vQnkYRMsL8n2M78ghKLxrTYF2CiFgMQRaZo+UdA5c4c4jsZbmV9gC42Yhsp2gsnu1FpqylIfOTfN8ILIUGtxrSl8FLxY87J+UA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=snu.ac.kr; spf=pass smtp.mailfrom=snu.ac.kr; dkim=pass (1024-bit key) header.d=snu.ac.kr header.i=@snu.ac.kr header.b=uD7y9f7+; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=snu.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=snu.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=snu.ac.kr header.i=@snu.ac.kr header.b="uD7y9f7+"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-35da9c0c007so1599495a91.2
        for <linux-scsi@vger.kernel.org>; Sat, 18 Apr 2026 06:30:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=snu.ac.kr; s=google; t=1776519020; x=1777123820; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QOsocMkxtjKD9j9zvFgGCM2TULz401mQWwIAVfMJ00Q=;
        b=uD7y9f7+FN3iScyGlJiTniaRz+hw6/gkMxSY5CpK+kF6zfzlTfiE5P9gMeVp8m5FKG
         q9CIyrqxBZO7mV/cHNRXshKgLRW5Ih3JM9rczlROi5mR94Ol+CkvIE7daHh+v/bIwfMc
         AyBogQavbe01NxbxChCgD3RdQrex7Iu9oWkHY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776519020; x=1777123820;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QOsocMkxtjKD9j9zvFgGCM2TULz401mQWwIAVfMJ00Q=;
        b=plgiDLSDZUPOiWStAKODpRmIJiqe2jKOO31I/QpNcsXzGL/jl5vxs14XfvFkHYWVmY
         q9QRERGYQVQp+T9PPlLwF1i4+OpTXiPAn0mOzBuvYK7Z8qxSedEj23lqBmgjZyl/zimT
         /tnUuO4U88eG46ldGPwHeLkOIgxQMitl7lT7jVV1PMj/YaZyy7RHrg3C7Kk2bXzIOr4I
         UBc0uvqC62W1r3Ntm6OLnepkmtA9WH6cPYqAb6ox/iXwOufNaJnG1QjoVaqzJTujRIKU
         Jec1WmPMSzZI0LWO/725AQutprnOs/T96lERMK8pSuduxuwFklkSwBjf3tf/t2xkLrLi
         GOSg==
X-Forwarded-Encrypted: i=1; AFNElJ+zH3WubnpEKwgKB+J2XFhZ7abDSICVBkiRxFPXwfH8j9LQypGWqC82lanNYLdVamSC2BTt01CAL63l@vger.kernel.org
X-Gm-Message-State: AOJu0Ywoq/WCroycNcn7SyL+cySlU2azdsoaVcVUW73SLBKlNHjoqKr5
	YJP13q347E88RTkc0q+pemkqj8fQUhYvyepmfItvvGBsafUxMjBKc+rSQ8Vizu/VMQ8=
X-Gm-Gg: AeBDievH930EJL0p0plOuGqSp3HW4Ul6mDM4sczmYIfcSYDnvbIPF+hzAKgjvihNLx0
	puBq+4swuZRkBIlS4KDqAoTqh8CySUky+lYdF6Q0K+OYpPS3weOp24s23mODnVxJYNgvt4wIbzG
	abwfNFpXqGh74cTldS5hZKJudqe7EfPHMu3/cDrc21wbnsrFBLqN7ubBR5GLiyAWb8r8ADlP9Cy
	KVAWEEZ517ZCAAOKSZbmCl4qFJoFz3OP3mkHQZn8+7uA0+mNuaXplJ1rsn4PBctcoQvUw0mTIfL
	mrAAF77qd9y0k3EPdGtgJ+Pe7XVZM/cWtIXpL4+f6awNwkTnDI//KJvE7aWqIbBjjikp93ROgpn
	SXU5be33ZNy5uF+uFKcjSJmZROPrn8hWw/Ag5FsxoEcx1Amx8ZZB12LzMbwEWVKYbhKd4yPCw8o
	Lcj2XvUsJHvccoKWaIlBGe7hjGNFmR345wEeVa9YdAT3ljM8VQzWsewrEgafx2kvsN11fE+A==
X-Received: by 2002:a17:90a:da83:b0:35b:9ab6:1d4b with SMTP id 98e67ed59e1d1-3614048e368mr7488746a91.20.1776519020536;
        Sat, 18 Apr 2026 06:30:20 -0700 (PDT)
Received: from nunu.. (nunu.snu.ac.kr. [147.46.112.82])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3614195a9fbsm6843001a91.11.2026.04.18.06.30.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Apr 2026 06:30:20 -0700 (PDT)
From: Sangyun Kim <sangyun.kim@snu.ac.kr>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Duoming Zhou <duoming@zju.edu.cn>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] scsi: mvsas: fix iterator use-after-free in mvs_free() wq drain loop
Date: Sat, 18 Apr 2026 22:30:03 +0900
Message-Id: <20260418133003.2462460-3-sangyun.kim@snu.ac.kr>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260418133003.2462460-1-sangyun.kim@snu.ac.kr>
References: <20260418133003.2462460-1-sangyun.kim@snu.ac.kr>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mvs_free() walks mvi->wq_list with list_for_each_entry() and calls
cancel_delayed_work_sync(&mwq->work_q) for each element.  If the
callback for the current node is already executing, the sync wait
allows mvs_work_queue() to remove its own list entry and kfree() the
mvs_wq:

  list_del(&mwq->entry);
  spin_unlock_irqrestore(&mvi->lock, flags);
  kfree(mwq);

When cancel_delayed_work_sync() returns, list_for_each_entry() in
mvs_free() advances with list_next_entry(mwq, entry), which reads
mwq->entry.next from the already-freed node.  This is a read
use-after-free in the remove path.

Switching the iterator to list_for_each_entry_safe() is not enough,
because any saved "next" cursor can itself be freed by its own
callback once cancel_delayed_work_sync() drops mvi->lock.

Drain wq_list one entry at a time under mvi->lock:

 - mvs_free() uses list_first_entry() + list_del_init() to detach
   the head, drops the lock, calls cancel_delayed_work_sync(), then
   kfree()s the entry, and retakes the lock for the next iteration.

 - mvs_work_queue() checks list_empty(&mwq->entry) under mvi->lock
   before doing its own list_del_init() + kfree().  If mvs_free()
   has already detached the entry, the callback skips the final
   free and teardown owns it.

This gives teardown and the callback a single-owner rule for the
struct mvs_wq free.

Fixes: 60cd16a3b743 ("scsi: mvsas: Fix use-after-free bugs in mvs_work_queue")
Signed-off-by: Sangyun Kim <sangyun.kim@snu.ac.kr>
---
 drivers/scsi/mvsas/mv_init.c | 11 ++++++++++-
 drivers/scsi/mvsas/mv_sas.c  | 10 +++++++---
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index 0c9c62c25987..c32f645deef3 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -85,6 +85,7 @@ static void mvs_phy_init(struct mvs_info *mvi, int phy_id)
 static void mvs_free(struct mvs_info *mvi)
 {
 	struct mvs_wq *mwq;
+	unsigned long flags;
 	int slot_nr;
 
 	if (!mvi)
@@ -120,8 +121,16 @@ static void mvs_free(struct mvs_info *mvi)
 		dma_free_coherent(mvi->dev, TRASH_BUCKET_SIZE,
 				  mvi->bulk_buffer1, mvi->bulk_buffer_dma1);
 
-	list_for_each_entry(mwq, &mvi->wq_list, entry)
+	spin_lock_irqsave(&mvi->lock, flags);
+	while (!list_empty(&mvi->wq_list)) {
+		mwq = list_first_entry(&mvi->wq_list, struct mvs_wq, entry);
+		list_del_init(&mwq->entry);
+		spin_unlock_irqrestore(&mvi->lock, flags);
 		cancel_delayed_work_sync(&mwq->work_q);
+		kfree(mwq);
+		spin_lock_irqsave(&mvi->lock, flags);
+	}
+	spin_unlock_irqrestore(&mvi->lock, flags);
 	MVS_CHIP_DISP->chip_iounmap(mvi);
 	if (mvi->shost)
 		scsi_host_put(mvi->shost);
diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index 359226e80eae..7df6964a76e8 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -1729,9 +1729,13 @@ static void mvs_work_queue(struct work_struct *work)
 				PORTE_BROADCAST_RCVD, GFP_ATOMIC);
 		mv_dprintk("phy%d Got Broadcast Change\n", phy_no);
 	}
-	list_del(&mwq->entry);
-	spin_unlock_irqrestore(&mvi->lock, flags);
-	kfree(mwq);
+	if (!list_empty(&mwq->entry)) {
+		list_del_init(&mwq->entry);
+		spin_unlock_irqrestore(&mvi->lock, flags);
+		kfree(mwq);
+	} else {
+		spin_unlock_irqrestore(&mvi->lock, flags);
+	}
 }
 
 static int mvs_handle_event(struct mvs_info *mvi, void *data, int handler)
-- 
2.34.1

