Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DC7F49D5A1
	for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2026 14:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789742297; cv=none; b=h25zdF2twkN7jTxmHse8Cmvf0YY+10g2372tCqi9lGTndSOAPDx1Cn9dlGVQmElVHUwSCaxPC62HIiJ8Ctc4K3iVq5yzIMlXrwYgk4po9Vim+npBIvqDKPN9pyqKj3vjxvJgTkU/07j3LwOgNc33BRGYDaKrXulQbFhhw0XGKR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789742297; c=relaxed/simple;
	bh=+KPB1lKxojDRY5zT5v7uCSLpxLCh41smyn55eJFDsZA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GpI8kabE9fmyoPQ08Xr4XUFRsA1GP16YcuOWkYJBus4hqL+icYTHlrSTWnmgFkGJYwKGMWOlvLWv4QggaCe4ZMWLrCcwW+3QySSmogkdFKFg0VsbQ4xUL+2FCU0DlNElhsvSchnS7o3gvjTxPvUf13d6dUPgbO72y7DZ3g2S370=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aVA9Qz11; arc=none smtp.client-ip=209.85.210.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aVA9Qz11"
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-8663802b58fso1039526b3a.2
        for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2026 07:38:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789742295; x=1790347095; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3OT5P6cXKt1EfvL7fMqaW1ELy2bttp1x4RCZYKi6/zc=;
        b=aVA9Qz11E+sndk2B8QAwwmKWPBlneksH4yfSSdzKeubSpR/SVYdfogf1Bryyx2iccS
         o6k0zdw2O5U5b/7T9+oxnt2pyd043paq04LFdy/1oGuwA+kFO4U6NqMAIsGO2Q3eM+FS
         unXb9a6zllXduCkfxvcBeYdy8anD/0rRayKqneJzzdEjYHHXzNKJnwyR+bmaQFV6zL8X
         NVchZyw9bN3H7UDpLmzzRM4GRGdPe8Bfa6NZyLFbxTsfinuJ+Yk+l4vyYdZ4glW272Ix
         sS+2k4hh+1BLD8wbno5iRA5P2giVQ4NM1BrwMGXKwZkeN7RVJA0kZ2aAEBoiLY9oX+qP
         ILLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789742295; x=1790347095;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3OT5P6cXKt1EfvL7fMqaW1ELy2bttp1x4RCZYKi6/zc=;
        b=SqRWoJ50aT+YKxXp3BdjveCIL4XYIVpxUqIjcNVMqyqvMRoHtluASz5B46a974Lcuk
         lCL2oxWQSDy/xIiP34IxHsqu3GQjJkiASxmnbtqrujN34pggcXw+ET5nBw3Ee6fp/TJN
         D4NIn7eb8ATLTSTaBDgTRPxQuuwOWACjBSOu08XjfB/3QK0pRKFMoDyGxxHn5aSnQtdN
         xL36ADnwJhu24zHZzMbIeB0JGq/igVq7tzwZn2lywhHNw2Fmlqb4ZwAXEWER9bcYMpuw
         coRDvZNySmqD3PZ0NKB0ZtzqL8rShfhstX/mpNYyfO9YAbryb9schfIccOltKwPsTOfG
         uI9Q==
X-Forwarded-Encrypted: i=1; AKwUvBy78bbY1xHat6OlIKyNk/gH2NtChsTu3kin08yKTNFLzjP+2cIwEVsvSlt4uXb62f29MJws+qeYTJar@vger.kernel.org
X-Gm-Message-State: AFuF++lje3S3bOm2r8/9s3jGiZWPTdflR53oMugwJIUVnQwntUJPWiF5
	o75zrijdj1SoCn1GlEQjnYI5dIwHtdnbSTingtR+qKrgOgXFZ7DGSInkPoVgZeX7rthwykSlARK
	jNV09QTV2OJHuQZ3zstGjyQ==
X-Received: from pfqf14.prod.google.com ([2002:aa7:9d8e:0:b0:847:9be8:84d5])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:4409:b0:872:b1f1:aa8d with SMTP id d2e1a72fcca58-874dc0f8b95mr5056873b3a.14.1789742295298;
 Fri, 18 Sep 2026 07:38:15 -0700 (PDT)
Date: Fri, 18 Sep 2026 22:38:08 +0800
In-Reply-To: <20260918143809.3034592-1-stanleyjhu@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <CAE14pdek6ynze+muDZrK+yNX-3ioe3vprxOA4W22qokg352tJQ@mail.gmail.com>
 <20260918143809.3034592-1-stanleyjhu@google.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Message-ID: <20260918143809.3034592-3-stanleyjhu@google.com>
Subject: [PATCH v2 2/2] scsi: ufs: core: Decouple CQ sweep from request
 iterator in MCQ
From: Stanley Jhu <stanleyjhu@google.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>, Bean Huo <beanhuo@micron.com>, 
	Bart Van Assche <bvanassche@acm.org>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, 
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, 
	Manivannan Sadhasivam <mani@kernel.org>, Peter Wang <peter.wang@mediatek.com>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stanleyjhu@google.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

In MCQ mode, ufshcd_mcq_compl_pending_transfer() uses
blk_mq_tagset_busy_iter() to iterate over busy requests during error
recovery and host reset. However, both iterator callbacks perform
whole-queue operations redundantly for each visited request:

- force_compl == true: ufshcd_mcq_force_compl_one() calls
  ufshcd_mcq_compl_all_cqes_lock() on every busy request, sweeping the
  entire completion ring (hwq->max_entries slots) once per active
  request under spin_lock_irqsave even though the first sweep already
  cleared all completion entries.
- force_compl == false: ufshcd_mcq_compl_one() acquires cq_lock and
  polls CQTPy over MMIO via ufshcd_mcq_poll_cqe_lock() for every busy
  request without doing any per-request work.

Sweep or poll each hardware queue (hba->uhq[i]) once at the start of
ufshcd_mcq_compl_pending_transfer(). When force_compl is true, run
blk_mq_tagset_busy_iter() afterward to complete residual in-flight
requests with DID_REQUEUE, and remove the now-unused
ufshcd_mcq_compl_one() callback.

Fixes: ab248643d3d6 ("scsi: ufs: core: Add error handling for MCQ mode")
Cc: stable@vger.kernel.org
Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
---
 drivers/ufs/core/ufshcd.c | 31 ++++++++++++-------------------
 1 file changed, 12 insertions(+), 19 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 2ba244cf40ac..a69dcb04d985 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6044,8 +6044,6 @@ static bool ufshcd_mcq_force_compl_one(struct request *rq, void *priv)
 	if (blk_mq_is_reserved_rq(rq) || !hwq)
 		return true;
 
-	ufshcd_mcq_compl_all_cqes_lock(hba, hwq);
-
 	/*
 	 * For those cmds of which the cqes are not present in the cq, complete
 	 * them explicitly.
@@ -6061,19 +6059,6 @@ static bool ufshcd_mcq_force_compl_one(struct request *rq, void *priv)
 	return true;
 }
 
-static bool ufshcd_mcq_compl_one(struct request *rq, void *priv)
-{
-	struct scsi_device *sdev = rq->q->queuedata;
-	struct Scsi_Host *shost = sdev->host;
-	struct ufs_hba *hba = shost_priv(shost);
-	struct ufs_hw_queue *hwq = ufshcd_mcq_req_to_hwq(hba, rq);
-
-	if (!blk_mq_is_reserved_rq(rq) && hwq)
-		ufshcd_mcq_poll_cqe_lock(hba, hwq);
-
-	return true;
-}
-
 /**
  * ufshcd_mcq_compl_pending_transfer - MCQ mode function. It is
  * invoked from the error handler context or ufshcd_host_reset_and_restore()
@@ -6088,10 +6073,18 @@ static bool ufshcd_mcq_compl_one(struct request *rq, void *priv)
 static void ufshcd_mcq_compl_pending_transfer(struct ufs_hba *hba,
 					      bool force_compl)
 {
-	blk_mq_tagset_busy_iter(&hba->host->tag_set,
-				force_compl ? ufshcd_mcq_force_compl_one :
-					      ufshcd_mcq_compl_one,
-				NULL);
+	int i;
+
+	for (i = 0; i < hba->nr_hw_queues; i++) {
+		if (force_compl)
+			ufshcd_mcq_compl_all_cqes_lock(hba, &hba->uhq[i]);
+		else
+			ufshcd_mcq_poll_cqe_lock(hba, &hba->uhq[i]);
+	}
+
+	if (force_compl)
+		blk_mq_tagset_busy_iter(&hba->host->tag_set,
+					ufshcd_mcq_force_compl_one, NULL);
 }
 
 /**
-- 
2.55.0.1082.g2b9226bbc0-goog

