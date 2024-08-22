Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B61FD1D0DE3
	for <linux-scsi@vger.kernel.org>; Thu, 22 Aug 2024 20:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724356825; cv=none; b=FsDGkBWV/eMv4+dVLw3W9bzJVVNAfKaCah+qnez3pTfC5Vo52rkA/I48s2so0x9mrw/eOvCLxsKQss9qnuIjySccGXyefhZUJ5UrHg/RZ7aZ2KpFaQkAaFxkWVQaeFBSY0JM5+3fewP1G5tGslv5EgjGcF38mfjBl6DGgS/BfNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724356825; c=relaxed/simple;
	bh=olUflGePI8UC7pbPjQF243zd138PFVIYAD+oNAvagPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=epSGk6bcDyk+uFNVfmpHNZYo3ExjlBEaWH+3UiT0JHkGVlHAg5nBEcx2wVQKdeLBGm+1wCp+knyAKFa+An0PICuzjLrpkINAbBtQl8LJGtfxCXM+6PKXlCNpLGRi3lasJbZS1AvM92nNd7fYp8eYgywdiSP3yg8mnDxfcaaUP/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=UFMvAuae; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="UFMvAuae"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WqYw54Jzzz6ClY9L;
	Thu, 22 Aug 2024 20:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1724356817; x=1726948818; bh=Nf/Y4
	zec52rhkP1REqo6mtxk3dwMrtOi3jDm4vxsJuQ=; b=UFMvAuaeoyxTVJd6bTQLb
	bOoItBGdwFW4xbmc9FybRhdNbr1ueyUpSVoTQZl9cXECXpKYN+nWZs+8FZkzE69n
	W/O78iKrwMC4EocD+TQtuY9OHSPFLKKGJSh64jO08j5PgfqQVymGm2EN0QeVW6mx
	Rp07ABz+YFT6HnmW5I23NdQlocyJ7QIQRvm3Kr92nzfqcUFc1V3WRO1BC9PezKYf
	IURzvOHRpDNnsgxmQuDtnbt43XHSkwIT9uVC0oPf6zlUKKR0iqJLyB1RZfaMBRFp
	V91XxfCbhz2WwdWt/IKsgY01iQ4+N6U9tFL2IboBplcVTYMbOWN8YHe0+Ipm5Vuh
	w==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 0QQpwSyznUGP; Thu, 22 Aug 2024 20:00:17 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WqYw00k0hz6ClY9R;
	Thu, 22 Aug 2024 20:00:15 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v3 08/18] scsi: mpi3mr: Simplify an alloc_ordered_workqueue() invocation
Date: Thu, 22 Aug 2024 12:59:12 -0700
Message-ID: <20240822195944.654691-9-bvanassche@acm.org>
X-Mailer: git-send-email 2.46.0.295.g3b9ea8a38a-goog
In-Reply-To: <20240822195944.654691-1-bvanassche@acm.org>
References: <20240822195944.654691-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Let alloc_ordered_workqueue() format the workqueue name instead of callin=
g
snprintf() explicitly.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/mpi3mr/mpi3mr.h    | 2 --
 drivers/scsi/mpi3mr/mpi3mr_os.c | 4 +---
 2 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 875bad7538f2..1dc640de3efc 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -1060,7 +1060,6 @@ struct scmd_priv {
  * @sbq_lock: Sense buffer queue lock
  * @sbq_host_index: Sense buffer queuehost index
  * @event_masks: Event mask bitmap
- * @fwevt_worker_name: Firmware event worker thread name
  * @fwevt_worker_thread: Firmware event worker thread
  * @fwevt_lock: Firmware event lock
  * @fwevt_list: Firmware event list
@@ -1241,7 +1240,6 @@ struct mpi3mr_ioc {
 	u32 sbq_host_index;
 	u32 event_masks[MPI3_EVENT_NOTIFY_EVENTMASK_WORDS];
=20
-	char fwevt_worker_name[MPI3MR_NAME_LENGTH];
 	struct workqueue_struct	*fwevt_worker_thread;
 	spinlock_t fwevt_lock;
 	struct list_head fwevt_list;
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr=
_os.c
index 69b14918de59..e18c44b53b99 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -5305,10 +5305,8 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pc=
i_device_id *id)
 	else
 		scsi_host_set_guard(shost, SHOST_DIX_GUARD_CRC);
=20
-	snprintf(mrioc->fwevt_worker_name, sizeof(mrioc->fwevt_worker_name),
-	    "%s%d_fwevt_wrkr", mrioc->driver_name, mrioc->id);
 	mrioc->fwevt_worker_thread =3D alloc_ordered_workqueue(
-	    mrioc->fwevt_worker_name, 0);
+		"%s%d_fwevt_wrkr", 0, mrioc->driver_name, mrioc->id);
 	if (!mrioc->fwevt_worker_thread) {
 		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
 		    __FILE__, __LINE__, __func__);
