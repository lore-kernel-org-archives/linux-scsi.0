Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBC2A264601
	for <linux-scsi@vger.kernel.org>; Mon, 10 Feb 2025 20:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739219989; cv=none; b=OeoN1n96AbgRRXW7a/djDHaDM2wIRHS9CpkEBNE7xzvo/xUCczBDGw9rvzhUHtvDMadFSy5DKt/wuHqg+u6Q6JrtJKb3SJTWdHWtszci/xgYqYfko0ovhEf6gc+d3ml83Kf9t5wOr7rDfQOa0K41o0YCOSbAcvd0ZDbpO/pWn18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739219989; c=relaxed/simple;
	bh=9LviBTlHf6XSFXdf7PkGfzznD6NUZuGF92shJW0Y4rc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CpxNnU51PKNZZkc5m12tfZx7e2O+luC+i1Oe8+xiu7h6Vp/CHFEpyjzEcLWe/1lrdKKUj5SPtV7AL5eh8aL0BqIxPM9JcU1I6p+GbbVxogelw3NGTMigW3uZlkar7VnfpM0/DlAxtoozdFikPHRItl4as0kg5un2/nSwCEzvVKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=KmF6kbEc; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="KmF6kbEc"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4YsGfC29qFzlgTwT;
	Mon, 10 Feb 2025 20:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1739219983; x=1741811984; bh=bOLmU
	PYyWkhijgaMs7G/rg5R0iA2hyCsiEbmuVWSUWo=; b=KmF6kbEcMJVTu4djQbFYk
	Ih44V9EfssitbY8LKuRPf7PFqOUNa0/Q+tT4qbVgWyAVjQ72uyAA7Muh3WHErmOP
	OU29TgiHT2XqeaOzArjVNq7NhGlyIxu2PJrGTIuj4BBzjh7W7Q9exT64dp0e0hkS
	xMAm0NNjbcYY9EfVhKI6igrO1V9aTRLeU59fQIbhpAMwf1vXcbIDcQwqOohnNoSO
	3QzKb0KeT+PkC5gYvy+3lsrV+HrpKPX7EBeuB+8dLMnhsnqOY5RproRyq2cbQeE2
	FosoT5csLjIvEP4qwVgvOx+Q20TACfosnRtNHDlN1DHo+Fwt4vEeRjkUafUtxX/A
	g==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 52JwqmoBT5Bx; Mon, 10 Feb 2025 20:39:43 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4YsGf50QnTzlgTw2;
	Mon, 10 Feb 2025 20:39:40 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Sathya Prakash <sathya.prakash@broadcom.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Chandrakanth patil <chandrakanth.patil@broadcom.com>
Subject: [PATCH 1/2] scsi: mpi3mr: Fix locking in an error path
Date: Mon, 10 Feb 2025 12:39:35 -0800
Message-ID: <20250210203936.2946494-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.48.1.502.g6dc24dfdaf-goog
In-Reply-To: <20250210203936.2946494-1-bvanassche@acm.org>
References: <20250210203936.2946494-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Make all error paths unlock rioc->bsg_cmds.mutex.

This patch fixes the following Clang -Wthread-safety errors:

drivers/scsi/mpi3mr/mpi3mr_app.c:2835:1: error: mutex 'mrioc->bsg_cmds.mu=
tex' is not held on every path through here [-Werror,-Wthread-safety-anal=
ysis]
 2835 | }
      | ^
drivers/scsi/mpi3mr/mpi3mr_app.c:2332:6: note: mutex acquired here
 2332 |         if (mutex_lock_interruptible(&mrioc->bsg_cmds.mutex))
      |             ^
./include/linux/mutex.h:172:40: note: expanded from macro 'mutex_lock_int=
erruptible'
  172 | #define mutex_lock_interruptible(lock) mutex_lock_interruptible_n=
ested(lock, 0)
      |                                        ^

Cc: Sathya Prakash <sathya.prakash@broadcom.com>
Fixes: fb231d7deffb ("scsi: mpi3mr: Support for preallocation of SGL BSG =
data buffers part-2")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/mpi3mr/mpi3mr_app.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3m=
r_app.c
index 26582776749f..c6bd5c8c0ea5 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -2425,6 +2425,7 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_=
job *job)
 	}
=20
 	if (!mrioc->ioctl_sges_allocated) {
+		mutex_unlock(&mrioc->bsg_cmds.mutex);
 		dprint_bsg_err(mrioc, "%s: DMA memory was not allocated\n",
 			       __func__);
 		return -ENOMEM;
