Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [96.44.175.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6426C646;
	Sat, 17 Aug 2024 07:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=96.44.175.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723879666; cv=none; b=AZHpRmybJZL87G/vrM1dIQexclgB5vuCYsf279GLBRmeQre3rzW5Fy4whEgdVz37qqkwAPIfIKnmlF8DxG0U0dQcrN6piSE/FIsv9zBwXtGINjZSPRaT4nQsY4xmmEx5MRoPCt22mBelhjH/gwTe0tmXt8j1IWwWQGuAo9Frzrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723879666; c=relaxed/simple;
	bh=qEzeb2ZLs4ndgf/5ICVAKYD4i5xTiSmsF4kb34G7trU=;
	h=Message-ID:Subject:From:To:Cc:Date:Content-Type:MIME-Version; b=YoUJ40tyBiCwL35KZjX8CalAyc3gI0re+UllXIftkBQgvOk5nrv2L9HLrG2GOyqRvOEWIOYcwSOMZjjtUgjwP5FM3sQ5auc10OaZ11/k8Ce254hdoIKL2Kd42zAj7LX107tqoimd5JwznIAyup9osc/fKBigISgDj6RNRcNf8GU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=L2BJbDWP; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=L2BJbDWP; arc=none smtp.client-ip=96.44.175.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="L2BJbDWP";
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="L2BJbDWP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1723879663;
	bh=qEzeb2ZLs4ndgf/5ICVAKYD4i5xTiSmsF4kb34G7trU=;
	h=Message-ID:Subject:From:To:Date:From;
	b=L2BJbDWPrFm3cQWz/1WfOtvGO8h2JzeCy/+Z9eE7ghFdSo2hWMAIEXpKFS6p4FVro
	 dFd3XFsZY4cQPUQYSCIu6CS1SfPsYykQck7AjLW/yJbRZcAfExmD5lBSr8F1gJuYcn
	 0+GnR95aJsCuIFpdDu09VHr/3IfHQof+GqauNsUA=
Received: from localhost (localhost [127.0.0.1])
	by bedivere.hansenpartnership.com (Postfix) with ESMTP id A02EE12879F8;
	Sat, 17 Aug 2024 03:27:43 -0400 (EDT)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
 by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavis, port 10024)
 with ESMTP id jcscohnvmWso; Sat, 17 Aug 2024 03:27:43 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1723879663;
	bh=qEzeb2ZLs4ndgf/5ICVAKYD4i5xTiSmsF4kb34G7trU=;
	h=Message-ID:Subject:From:To:Date:From;
	b=L2BJbDWPrFm3cQWz/1WfOtvGO8h2JzeCy/+Z9eE7ghFdSo2hWMAIEXpKFS6p4FVro
	 dFd3XFsZY4cQPUQYSCIu6CS1SfPsYykQck7AjLW/yJbRZcAfExmD5lBSr8F1gJuYcn
	 0+GnR95aJsCuIFpdDu09VHr/3IfHQof+GqauNsUA=
Received: from [IPv6:2a00:23c8:1007:7701:19d1:8255:2991:876d] (unknown [IPv6:2a00:23c8:1007:7701:19d1:8255:2991:876d])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 4BD6A1285F9A;
	Sat, 17 Aug 2024 03:27:42 -0400 (EDT)
Message-ID: <47228494aa07492b9c00d463789049a0a492d033.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 6.11-rc3
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds
	 <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel
	 <linux-kernel@vger.kernel.org>
Date: Sat, 17 Aug 2024 08:27:39 +0100
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

Two small fixes to the mpi3mr driver.  One to avoid oversize
allocations in tracing and the other to fix an uninitialized spinlock
in the user to driver feature request code (used to trigger dumps and
the like).

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Shin'ichiro Kawasaki (2):
      scsi: mpi3mr: Avoid MAX_PAGE_ORDER WARNING for buffer allocations
      scsi: mpi3mr: Add missing spin_lock_init() for mrioc->trigger_lock

And the diffstat:

 drivers/scsi/mpi3mr/mpi3mr_app.c | 11 ++++++++---
 drivers/scsi/mpi3mr/mpi3mr_os.c  |  1 +
 2 files changed, 9 insertions(+), 3 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index 8b0eded6ef36..01f035f9330e 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -100,7 +100,8 @@ void mpi3mr_alloc_diag_bufs(struct mpi3mr_ioc *mrioc)
 			dprint_init(mrioc,
 			    "trying to allocate trace diag buffer of size = %dKB\n",
 			    trace_size / 1024);
-		if (mpi3mr_alloc_trace_buffer(mrioc, trace_size)) {
+		if (get_order(trace_size) > MAX_PAGE_ORDER ||
+		    mpi3mr_alloc_trace_buffer(mrioc, trace_size)) {
 			retry = true;
 			trace_size -= trace_dec_size;
 			dprint_init(mrioc, "trace diag buffer allocation failed\n"
@@ -118,8 +119,12 @@ void mpi3mr_alloc_diag_bufs(struct mpi3mr_ioc *mrioc)
 	diag_buffer->type = MPI3_DIAG_BUFFER_TYPE_FW;
 	diag_buffer->status = MPI3MR_HDB_BUFSTATUS_NOT_ALLOCATED;
 	if ((mrioc->facts.diag_fw_sz < fw_size) && (fw_size >= fw_min_size)) {
-		diag_buffer->addr = dma_alloc_coherent(&mrioc->pdev->dev,
-		    fw_size, &diag_buffer->dma_addr, GFP_KERNEL);
+		if (get_order(fw_size) <= MAX_PAGE_ORDER) {
+			diag_buffer->addr
+				= dma_alloc_coherent(&mrioc->pdev->dev, fw_size,
+						     &diag_buffer->dma_addr,
+						     GFP_KERNEL);
+		}
 		if (!retry)
 			dprint_init(mrioc,
 			    "%s:trying to allocate firmware diag buffer of size = %dKB\n",
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index ca8f132e03ae..616894571c6a 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -5234,6 +5234,7 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	spin_lock_init(&mrioc->watchdog_lock);
 	spin_lock_init(&mrioc->chain_buf_lock);
 	spin_lock_init(&mrioc->sas_node_lock);
+	spin_lock_init(&mrioc->trigger_lock);
 
 	INIT_LIST_HEAD(&mrioc->fwevt_list);
 	INIT_LIST_HEAD(&mrioc->tgtdev_list);

