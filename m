Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA0D21E412A
	for <linux-scsi@vger.kernel.org>; Tue,  6 Jan 2026 18:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767725858; cv=none; b=NfT13ghTI/orN0HfGmXq7H2TpRDM+jukWGCdSmBO1CgxaWuzynIX4CIXtyKKTkmd2OiuqmQUyImz3tQ9qr/X1whdU9BfqM2F9WsXg0/cG5UWSATzhfmNbBVmIQ9Br5Ug6tvQZyPqkUaYYER6cd5Bu9XjD9Nj+WQiA6O3TzZ8Jpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767725858; c=relaxed/simple;
	bh=PIt/XOexxWiMe/hwev+yWHeRqeuytSGj2Z3facfYBB0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Oa27e6fDDQA8Ypx7F67BpXyvfdgGQugq9MfA4BytxMS0YaRV5nnWWH5CDjfz5E5qK7eNyuYWOk7ScDdhywUR0225Rz7sv/xZwuU8p4qZowsf+pKdoCOtXnox/4WZdHRIeGDkHX2rEsBMQjG1I6IFwdh4SUVdv+ivYVhtnNwCkag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=qsqzCQU/; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="qsqzCQU/"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4dm0ly2ZBgz1XScCj;
	Tue,  6 Jan 2026 18:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1767725852; x=1770317853; bh=Wz3NbiEtx+fif302pZu3eFi2rV9QScVArKv
	5bBhfx74=; b=qsqzCQU/l1Sx7Q58p1juGCcfao6hXvoGxoTapbIMOIpr3rkvrAl
	m3RYrj5Rq4oJ7zyH8Q1FlhaD6R0rWbKzLRU7BEpdRXdPeFvaJxqmMecm3PYuo+s4
	bPE54tOwwJJqeeAkFUkAaUmleZfDXMHxVMRxuzrw6Srn24gvr+gEsrTC7HpTy/jE
	FMF+zSLJ85wQJ8HkBO0HqHuVvg/cFWbjQOBDjH6i6OkiYcdQq25RA1/XxpeEjF22
	ax84k9EAU+CIFbFIOCrkhKGddu3faYrCIhWs0CCNCwR9PzZtYoK7R+UIzT7ixji1
	6q81PMTpwGEuyEvep09c1qmavX4PM/szqFA==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id XjjNROxu98_K; Tue,  6 Jan 2026 18:57:32 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4dm0lt4JYPz1XM6J7;
	Tue,  6 Jan 2026 18:57:30 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH] scsi: mpi3mr: Simplify the workqueue allocation code
Date: Tue,  6 Jan 2026 11:57:22 -0700
Message-ID: <20260106185723.2526901-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Let alloc_ordered_workqueue() format the workqueue name instead of
calling scnprintf() explicitly. Compile-tested only.

Cc: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/mpi3mr/mpi3mr.h    | 2 --
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 5 +----
 2 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 31d68c151b20..82f4ae87d6bc 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -1076,7 +1076,6 @@ struct scmd_priv {
  * @fwevt_worker_thread: Firmware event worker thread
  * @fwevt_lock: Firmware event lock
  * @fwevt_list: Firmware event list
- * @watchdog_work_q_name: Fault watchdog worker thread name
  * @watchdog_work_q: Fault watchdog worker thread
  * @watchdog_work: Fault watchdog work
  * @watchdog_lock: Fault watchdog lock
@@ -1265,7 +1264,6 @@ struct mpi3mr_ioc {
 	spinlock_t fwevt_lock;
 	struct list_head fwevt_list;
=20
-	char watchdog_work_q_name[50];
 	struct workqueue_struct *watchdog_work_q;
 	struct delayed_work watchdog_work;
 	spinlock_t watchdog_lock;
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr=
_fw.c
index 8fe6e0bf342e..b564fe5980a6 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -2878,11 +2878,8 @@ void mpi3mr_start_watchdog(struct mpi3mr_ioc *mrio=
c)
 		return;
=20
 	INIT_DELAYED_WORK(&mrioc->watchdog_work, mpi3mr_watchdog_work);
-	snprintf(mrioc->watchdog_work_q_name,
-	    sizeof(mrioc->watchdog_work_q_name), "watchdog_%s%d", mrioc->name,
-	    mrioc->id);
 	mrioc->watchdog_work_q =3D alloc_ordered_workqueue(
-		"%s", WQ_MEM_RECLAIM, mrioc->watchdog_work_q_name);
+		"watchdog_%s%d", WQ_MEM_RECLAIM, mrioc->name, mrioc->id);
 	if (!mrioc->watchdog_work_q) {
 		ioc_err(mrioc, "%s: failed (line=3D%d)\n", __func__, __LINE__);
 		return;
