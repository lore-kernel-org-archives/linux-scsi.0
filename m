Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EC0F3546D6
	for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2026 03:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790567904; cv=none; b=QslKO+DT4JTD1hmIvABmJu1YpcnIk7flR4vIxEKkD+L0UTUQvJu/KjlHQhYXRWjR8yD7Pc8VSwOJWI5UYAUqeAY4EckdSTPkGAYmUrPfdQhZhGY06Jb5bHk3KPXB8k1r3uS58ui4fXQiu/EujqbDlApkcB7jg/VNF4gt3ByJ/eA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790567904; c=relaxed/simple;
	bh=bwJeEo0fFkN69DKRkhPJmYcCsx6w+GE5NQ1kWaHula4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IELK0mKpQRfQ6vT8mi5OvbXtEpDutj9cCJWk69QeevJNVOaI+qz2EyOGWCMGIU9ot3AOpt3PpWWR6EXgHIRfDgj1vdXG8DsDeW02rcCk1a16ePLBgJuoIz0RySP+XX9R5PYIYaaLq/spe9FprHOGVYOE4KiQFWfYSvNdQZnayHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=p5Cbhmci; arc=none smtp.client-ip=209.85.215.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="p5Cbhmci"
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cc1b8088202so1778431a12.3
        for <linux-scsi@vger.kernel.org>; Sun, 27 Sep 2026 20:58:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790567902; x=1791172702; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=n2JLL5e+F1wlkRjH+6wUiOfkjZbO3ZdGYtj4jVl+vcw=;
        b=p5CbhmcihITwnviX46bLhrgMNQ0YAF8uNx9PDjPkYqLtv7y1VtXLL4FQ7LhWcB7QCD
         owLTHHG8myGGfnXYQ+q1D4PM2xdIZK6g/s2XH7+cxHOd51HSolUIZjmiX2l1tv9queEJ
         imA2ZQW02Y+ZWldQ8fFf91N9TJR66fWgtFtQkkuH/ymUKRgQXDu5mLb5IptSI92iycJh
         gP/joIqvo23MERgiSWS2mfxyqJCDqbS8g1MPFwjF6Dom4tgGp7XzsUCNgVdO0hoQnEdv
         +ULrI2GWQJrq2aVXTLpVD6ZiDWdM2BOp9ejs3K00J0v5eW4ah6m49f6cxE+frXk/2K8e
         RmIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790567902; x=1791172702;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=n2JLL5e+F1wlkRjH+6wUiOfkjZbO3ZdGYtj4jVl+vcw=;
        b=qTARXsiAn3/u8tT4wPRiluFaIC8P7THfgAP/T5IU4EZccf1CWMuQ11NsPqyRuLIGRq
         whzwlCiP4SxVto4JcmOlkzkgiXO3AnhjZafVU1Nd+A0DxASmBMyrlSPktriJK5F/Z0zs
         XFcT46dm0TFjmYkFVyAJO81UFH2WS8atuI7dFZayHtMTQaWOwPEKVKBYVB/vvMqB0LUe
         9u9P7wsHFpSNJLilMnlmLaf+poIg8cy41oazZ6K9jXsqpTYf0Pu3H2ZVidd8kDu65v6J
         rSjVDj/Hiethyo1qJq8rqi2CjhJFIMRppKeLS+0GD8RR9DktGU3moxLsyPJMm186KCNS
         tDlg==
X-Forwarded-Encrypted: i=1; AKwUvBzoB09gwVQlwTY7UOjlIqeLxwu+/klz5U86vRNJ7jMwEkif20cPUkcxx3AqyRunTbqelh+9aeGVbL+H@vger.kernel.org
X-Gm-Message-State: AFuF++nGMfEysa8DBbJSqbMSULRdkqBwQeHERG56ZewkO/M52h0DfLtV
	VAPOcrIWnOtEh2xArW13ORyhz8tEwuncBaOrqOQ6tVkDV619B4WtnVUkYXaxfek+y//za2Ptz0P
	ngob62EMLej6YVNF4WbKUwA==
X-Received: from pgbcv12.prod.google.com ([2002:a05:6a02:420c:b0:cc7:a60d:9b55])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:9218:b0:3de:3e4a:c102 with SMTP id adf61e73a8af0-3de4d646b60mr3694877637.14.1790567902171;
 Sun, 27 Sep 2026 20:58:22 -0700 (PDT)
Date: Mon, 28 Sep 2026 11:58:16 +0800
In-Reply-To: <20260928035816.1294326-1-stanleyjhu@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260928035816.1294326-1-stanleyjhu@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20260928035816.1294326-3-stanleyjhu@google.com>
Subject: [PATCH v3 2/2] scsi: ufs: core: Decouple CQ sweep from request
 iterator in MCQ
From: Stanley Jhu <stanleyjhu@google.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>, Bean Huo <beanhuo@micron.com>, 
	Bart Van Assche <bvanassche@acm.org>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, 
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, 
	Manivannan Sadhasivam <mani@kernel.org>, Peter Wang <peter.wang@mediatek.com>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Stanley Jhu <stanleyjhu@google.com>, 
	stable@vger.kernel.org
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
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
---
 drivers/ufs/core/ufshcd.c | 31 ++++++++++++-------------------
 1 file changed, 12 insertions(+), 19 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 234e18b5078f..f50431f35e58 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6068,8 +6068,6 @@ static bool ufshcd_mcq_force_compl_one(struct request *rq, void *priv)
 	if (blk_mq_is_reserved_rq(rq) || !hwq)
 		return true;
 
-	ufshcd_mcq_compl_all_cqes_lock(hba, hwq);
-
 	/*
 	 * For those cmds of which the cqes are not present in the cq, complete
 	 * them explicitly.
@@ -6085,19 +6083,6 @@ static bool ufshcd_mcq_force_compl_one(struct request *rq, void *priv)
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
@@ -6112,10 +6097,18 @@ static bool ufshcd_mcq_compl_one(struct request *rq, void *priv)
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
2.56.0.rc1.315.gc6ed9934b7-goog

