Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6730F201276
	for <linux-scsi@vger.kernel.org>; Tue,  2 Jul 2024 21:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719957209; cv=none; b=Gd1maE0OFCz54rdJwm9LJQW72zhE/3OCok2yf3axKukf5t+rI6A5CP3frY7gLpi2uOECgqjF9NDjtVA6rxNCwVjnlBo4melJqmn1Z+QXeD3olEtm4mGiE2nYClmsNsa+sk/3hStFlLs0+WiHaN/42NBBn462wtIsZEAptw8MqIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719957209; c=relaxed/simple;
	bh=65bbT3KX9ZdYfUGDnbfm3nMExXAL1mP8DcRUqth1eO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LVRVxj0fG89xruzd3jtclWbOvDuJ4tHSkpQ16nIv7ecZEWHGvWJoBNvNVbguH8ZiNvSO2KZ44Mr7HnJU3jy3W1Va0xzNLmSmJYd9rcKzVA+JnLVJKzfwMHCjBmkojf9OaU3C39j0BT8ac6ORuitQwX4AScK3/+5Oa+f4XX+yfvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=z2QGplcm; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="z2QGplcm"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4WDGr76dmXzlnRR8;
	Tue,  2 Jul 2024 21:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1719957205; x=1722549206; bh=4STJh
	QAsVbdaems4rAow2E0Af4XjcdUBl6bEtl8xU+I=; b=z2QGplcmqSjsSXiBWoz2a
	IB75hzSo2TO0Bh2zB2He0hCWi6escKACE1fKIzhswYEH+/GEr2PZhqfAIYURViCF
	Y2blcwmzicHYOlaw43NIcGpuD2tB1wP4iholuCeJN9cx7RhSr7ym8egS8U5r/4YN
	E5/ICKMIGcizQo4NuPm779omcgnPlM6BRkgzmWZPdwrxQsLV7aV775PYCapGbBVo
	X5noqZ89v707J0Sx/zMG1B53WH3W5pFeDya+VNBVHAJCafIVj+raW9yF0A+s7mt5
	vcqV4YlSbDFAUiiYzj4h5bFDgG3zGXzN+boDy3Z0YsaXUuXulVA108Q1YLBFZTei
	w==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id bZK6uXThrPgE; Tue,  2 Jul 2024 21:53:25 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4WDGr32H5WzlnQkr;
	Tue,  2 Jul 2024 21:53:23 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 08/18] scsi: mpi3mr: Simplify an alloc_ordered_workqueue() invocation
Date: Tue,  2 Jul 2024 14:51:55 -0700
Message-ID: <20240702215228.2743420-9-bvanassche@acm.org>
X-Mailer: git-send-email 2.45.2.803.g4e1b14247a-goog
In-Reply-To: <20240702215228.2743420-1-bvanassche@acm.org>
References: <20240702215228.2743420-1-bvanassche@acm.org>
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
index c8968f12b9e6..8428d42f4bb1 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -1056,7 +1056,6 @@ struct scmd_priv {
  * @sbq_lock: Sense buffer queue lock
  * @sbq_host_index: Sense buffer queuehost index
  * @event_masks: Event mask bitmap
- * @fwevt_worker_name: Firmware event worker thread name
  * @fwevt_worker_thread: Firmware event worker thread
  * @fwevt_lock: Firmware event lock
  * @fwevt_list: Firmware event list
@@ -1235,7 +1234,6 @@ struct mpi3mr_ioc {
 	u32 sbq_host_index;
 	u32 event_masks[MPI3_EVENT_NOTIFY_EVENTMASK_WORDS];
=20
-	char fwevt_worker_name[MPI3MR_NAME_LENGTH];
 	struct workqueue_struct	*fwevt_worker_thread;
 	spinlock_t fwevt_lock;
 	struct list_head fwevt_list;
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr=
_os.c
index eac179dc9370..2298d23e9c09 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -5273,10 +5273,8 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pc=
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
