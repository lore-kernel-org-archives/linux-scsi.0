Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [96.44.175.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 768291369A8;
	Wed, 10 Jul 2024 17:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=96.44.175.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720633740; cv=none; b=l+eVyYKwfpUgnRbKtUBoLpLaj40JEGSUUdTg4j3tlauVKH6Fanckx9F51u90mWaPlXtuyF2ZbD4daZpYiNdvwEHpoF3gD/wzNc+bykgzWB7yBg7Uxzk2rje7ea8DrtdeHa0I9mRW+8dU/b3P4OVkLl5grrC5cOpQ2qyN5GYZSKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720633740; c=relaxed/simple;
	bh=CnP+d+fWQpiP9tgiGxYKpgdz2IM3KLGz288TsVNUudM=;
	h=Message-ID:Subject:From:To:Cc:Date:Content-Type:MIME-Version; b=JEUAeC3eaGAyryeh39hg2ysSAKRqFfvwu2x5WZuhvNSY9MvSGtG079//FlcENALqF02gDvk6l55u506VgD6/8lJPxA8DvscHd82LD/ci6uUHRpS18lTxCZE7bXRtQ3JitFIsOyaTMRvLP8JUBYVz05W1HRFvAKfizo+kAYkxnlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=wGCWgoLm; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=wGCWgoLm; arc=none smtp.client-ip=96.44.175.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="wGCWgoLm";
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="wGCWgoLm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1720633737;
	bh=CnP+d+fWQpiP9tgiGxYKpgdz2IM3KLGz288TsVNUudM=;
	h=Message-ID:Subject:From:To:Date:From;
	b=wGCWgoLm9z0ZulKLN9OHjDAWgweeexpyHyz22u6Hzj/F6aGByd81cfroLcMONbn0U
	 /0snLH7F98H9B5JDbwk9d/oBXsAtW6b/wTh0PCMnZTl1nN//ZrMh/Ftw+cP1knJr4X
	 j/X9IB+LZ69G4QA+KmLYzxRUH4tzlLZ6KKUtN/ws=
Received: from localhost (localhost [127.0.0.1])
	by bedivere.hansenpartnership.com (Postfix) with ESMTP id 8B38A1286F76;
	Wed, 10 Jul 2024 13:48:57 -0400 (EDT)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
 by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavis, port 10024)
 with ESMTP id UJEUysR6rIVl; Wed, 10 Jul 2024 13:48:57 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1720633737;
	bh=CnP+d+fWQpiP9tgiGxYKpgdz2IM3KLGz288TsVNUudM=;
	h=Message-ID:Subject:From:To:Date:From;
	b=wGCWgoLm9z0ZulKLN9OHjDAWgweeexpyHyz22u6Hzj/F6aGByd81cfroLcMONbn0U
	 /0snLH7F98H9B5JDbwk9d/oBXsAtW6b/wTh0PCMnZTl1nN//ZrMh/Ftw+cP1knJr4X
	 j/X9IB+LZ69G4QA+KmLYzxRUH4tzlLZ6KKUtN/ws=
Received: from [10.106.168.35] (unknown [167.220.57.35])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(Client did not present a certificate)
	by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 38DDD1286E22;
	Wed, 10 Jul 2024 13:48:57 -0400 (EDT)
Message-ID: <ce3dd4dc5924fa3fbc1468a5dca262aed50bb4d7.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 6.10-rc7
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds
	 <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel
	 <linux-kernel@vger.kernel.org>
Date: Wed, 10 Jul 2024 10:48:56 -0700
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

One core change that moves a disk start message to a location where it
will only be printed once instead of twice plus a couple of error
handling race fixes in the ufs driver.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Damien Le Moal (1):
      scsi: sd: Do not repeat the starting disk message

Peter Wang (2):
      scsi: ufs: core: Fix ufshcd_abort_one racing issue
      scsi: ufs: core: Fix ufshcd_clear_cmd racing issue

And the diffstat:

 drivers/scsi/sd.c          |  5 ++---
 drivers/ufs/core/ufs-mcq.c | 11 ++++++-----
 drivers/ufs/core/ufshcd.c  |  2 ++
 3 files changed, 10 insertions(+), 8 deletions(-)

With full diff below

James

---

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index fe82baa924f8..6203915945a4 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -4117,8 +4117,6 @@ static int sd_resume(struct device *dev)
 {
 	struct scsi_disk *sdkp = dev_get_drvdata(dev);
 
-	sd_printk(KERN_NOTICE, sdkp, "Starting disk\n");
-
 	if (opal_unlock_from_suspend(sdkp->opal_dev)) {
 		sd_printk(KERN_NOTICE, sdkp, "OPAL unlock failed\n");
 		return -EIO;
@@ -4135,12 +4133,13 @@ static int sd_resume_common(struct device *dev, bool runtime)
 	if (!sdkp)	/* E.g.: runtime resume at the start of sd_probe() */
 		return 0;
 
+	sd_printk(KERN_NOTICE, sdkp, "Starting disk\n");
+
 	if (!sd_do_start_stop(sdkp->device, runtime)) {
 		sdkp->suspended = false;
 		return 0;
 	}
 
-	sd_printk(KERN_NOTICE, sdkp, "Starting disk\n");
 	ret = sd_start_stop_device(sdkp, 1);
 	if (!ret) {
 		sd_resume(dev);
diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index 8944548c30fa..c532416aec22 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -105,16 +105,15 @@ EXPORT_SYMBOL_GPL(ufshcd_mcq_config_mac);
  * @hba: per adapter instance
  * @req: pointer to the request to be issued
  *
- * Return: the hardware queue instance on which the request would
- * be queued.
+ * Return: the hardware queue instance on which the request will be or has
+ * been queued. %NULL if the request has already been freed.
  */
 struct ufs_hw_queue *ufshcd_mcq_req_to_hwq(struct ufs_hba *hba,
 					 struct request *req)
 {
-	u32 utag = blk_mq_unique_tag(req);
-	u32 hwq = blk_mq_unique_tag_to_hwq(utag);
+	struct blk_mq_hw_ctx *hctx = READ_ONCE(req->mq_hctx);
 
-	return &hba->uhq[hwq];
+	return hctx ? &hba->uhq[hctx->queue_num] : NULL;
 }
 
 /**
@@ -515,6 +514,8 @@ int ufshcd_mcq_sq_cleanup(struct ufs_hba *hba, int task_tag)
 		if (!cmd)
 			return -EINVAL;
 		hwq = ufshcd_mcq_req_to_hwq(hba, scsi_cmd_to_rq(cmd));
+		if (!hwq)
+			return 0;
 	} else {
 		hwq = hba->dev_cmd_queue;
 	}
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 1b65e6ae4137..46433ecf0c4d 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6456,6 +6456,8 @@ static bool ufshcd_abort_one(struct request *rq, void *priv)
 	/* Release cmd in MCQ mode if abort succeeds */
 	if (is_mcq_enabled(hba) && (*ret == 0)) {
 		hwq = ufshcd_mcq_req_to_hwq(hba, scsi_cmd_to_rq(lrbp->cmd));
+		if (!hwq)
+			return 0;
 		spin_lock_irqsave(&hwq->cq_lock, flags);
 		if (ufshcd_cmd_inflight(lrbp->cmd))
 			ufshcd_release_scsi_cmd(hba, lrbp);

