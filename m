Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8702D1C6891
	for <linux-scsi@vger.kernel.org>; Fri, 16 Aug 2024 21:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723845417; cv=none; b=rFEEvGs4Qelm3wK0st0OGPjJ5sE2BbzgKeY2mWjlu3Tg4LQ0VdG16moO6xxzW9iBPqUvk0O0JaYq7aSGbQ1NuocdWs+3bLGnsxE7myTb+lstYOKQ1QnVoYQkt04BFv75msmXjKXfvTp2N8aCmdLO5vOZM8VIu6H0dpB1wM3yngA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723845417; c=relaxed/simple;
	bh=oCKfZiil7S9TriXqWLTRiM9HgqmYlrOvVZK57uhQHmc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bej5eha0/EzJIBq9oQl1qraxABhOympHUWfXEhMTR8NWm0WsE6z8oYKxnYg6ITKaJbhQ0doat3NSoQ+B19xBxvQ6EFXM+bpqUp9rIDtzAtnRFgLyXn2zBytkvtoLsQnGtNdW1Aq/DZ197JouFPNCXm1w3rSIpx0/kP9bgCZktfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=CCHKBd6t; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="CCHKBd6t"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WlwnN21HBz6ClY9F;
	Fri, 16 Aug 2024 21:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1723845412; x=1726437413; bh=w26i2
	B5H2tnd9B4SMfrn/GDTxT9edZNBHJKDDPrC2P8=; b=CCHKBd6toAzFTSvZkPwhk
	AhrpKjrckNzJECL7a+ufLTD6aEXoXGyb8+NkvuKikKLax8o95GL3AtRiNNEHTCmA
	vVW44ghblJIDgz4UD4lTm6SO9pahlTf1a2wfM08tHCSBT4eDvict2ibWk2RSKkOx
	8ZDtP+NUlx+0+jLybpeddKxqY1icrvp6sRWIn16b9vlNKH5zf8/rLuV9MyW/3fuJ
	+FFtGkO2kMNUZjxFO31SxGkf3j4vRc/oniCSTTSsESdpc8IEIhr8LNuQUH1/+Pvd
	S0Fd2mr6m5UhEiPwyDNUo4LXvNgauiBaIqW8g/hCpsy9ijlycTUaUOvt26a+f2pn
	w==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 4W7UrcMd41zo; Fri, 16 Aug 2024 21:56:52 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WlwnG3Z8yz6ClY99;
	Fri, 16 Aug 2024 21:56:50 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v2 08/18] scsi: mpi3mr: Simplify an alloc_ordered_workqueue() invocation
Date: Fri, 16 Aug 2024 14:55:31 -0700
Message-ID: <20240816215605.36240-9-bvanassche@acm.org>
X-Mailer: git-send-email 2.46.0.184.g6999bdac58-goog
In-Reply-To: <20240816215605.36240-1-bvanassche@acm.org>
References: <20240816215605.36240-1-bvanassche@acm.org>
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
index dc2cdd5f0311..c1c97ed1eb38 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -1059,7 +1059,6 @@ struct scmd_priv {
  * @sbq_lock: Sense buffer queue lock
  * @sbq_host_index: Sense buffer queuehost index
  * @event_masks: Event mask bitmap
- * @fwevt_worker_name: Firmware event worker thread name
  * @fwevt_worker_thread: Firmware event worker thread
  * @fwevt_lock: Firmware event lock
  * @fwevt_list: Firmware event list
@@ -1240,7 +1239,6 @@ struct mpi3mr_ioc {
 	u32 sbq_host_index;
 	u32 event_masks[MPI3_EVENT_NOTIFY_EVENTMASK_WORDS];
=20
-	char fwevt_worker_name[MPI3MR_NAME_LENGTH];
 	struct workqueue_struct	*fwevt_worker_thread;
 	spinlock_t fwevt_lock;
 	struct list_head fwevt_list;
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr=
_os.c
index ca8f132e03ae..58a66a318e02 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -5316,10 +5316,8 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pc=
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
