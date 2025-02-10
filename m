Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AA04264601
	for <linux-scsi@vger.kernel.org>; Mon, 10 Feb 2025 20:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739219992; cv=none; b=LO0ND8IdiHiKQzOr6UsizEhy5H4Gl7v4Y5u4zKkegRAQj9j1BH/cjKZjBcPz+B5LPlq+xmWEYQ5vZDiSfrqoJuIjGaCFR0gQ7G3tQhD5dyfeZGzRpJ3ivIEBuR1adV3SYq1S/PYKRHhPeuNWUvgLlCVq1LQmPh1qSrG62NEZ6No=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739219992; c=relaxed/simple;
	bh=a67hbA34t1LkmktA9Vmg5fqrKY6V9VI18fGmyxBrYwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OUvmGlO4C9suMQs4fx9FWwXYocAsRHjKSO39Y9BA2oIJeME7PAYT3Z3lzauZ5k+1oQzm31h2rJ/gnyzp55S6ABG2L63pUZi670+mcS6IerEbFjDKGPsAZi3labhW4gjOx3vtpOrmPvKfx/qENPQybgPryQQJeykUd/hKp+hLEzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=SwYeX/b1; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="SwYeX/b1"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4YsGfG12hyzlgTw2;
	Mon, 10 Feb 2025 20:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1739219985; x=1741811986; bh=LRto8
	R//v2bO8wRp7tA200+bmc3nC/6ECYN60R2m3pA=; b=SwYeX/b1/hgE93uphofs0
	fmqpnaED4O+WgW6qFIVIXjy5NvHG0JbssprZ2soJYNY50n5Iwg/GmOtO1DQNHo13
	Y5a3Asypi8aWNdN3mQtXeg1c9kl05DZHP/hSBsg0LmFHvhK42dAYWlJlaCmn98mz
	Uk5cvL7TjsMANNjEAVJTCq3aX0lU3kdGYeT5osFJi06YzCo/KPUak7BfwYqC97hD
	WD0AqHfHou/GcJjijY3+LnS62qfqSIrqecQ4ez+sJofJTX0ACGx/jjsiv73g3fHI
	jK9MqHX5F9DjpZkhT3rRGn2pvc0t1AJUO+TZRCbvx8iqr0/8YqAMuuVb2g9VQ8LN
	w==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id WOAJAm8Mw1wV; Mon, 10 Feb 2025 20:39:45 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4YsGf73BnxzlgTvv;
	Mon, 10 Feb 2025 20:39:43 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 2/2] scsi: mpt3sas: Fix a locking bug in an error path
Date: Mon, 10 Feb 2025 12:39:36 -0800
Message-ID: <20250210203936.2946494-3-bvanassche@acm.org>
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

Call mutex_unlock(&ioc->hostdiag_unlock_mutex) once from error paths
instead of twice.

This patch fixes the following Clang -Wthread-safety errors:

drivers/scsi/mpt3sas/mpt3sas_base.c:8085:2: error: mutex 'ioc->hostdiag_u=
nlock_mutex' is not held on every path through here [-Werror,-Wthread-saf=
ety-analysis]
 8085 |         pci_cfg_access_unlock(ioc->pdev);
      |         ^
drivers/scsi/mpt3sas/mpt3sas_base.c:8019:2: note: mutex acquired here
 8019 |         mutex_lock(&ioc->hostdiag_unlock_mutex);
      |         ^
./include/linux/mutex.h:171:26: note: expanded from macro 'mutex_lock'
  171 | #define mutex_lock(lock) mutex_lock_nested(lock, 0)
      |                          ^
drivers/scsi/mpt3sas/mpt3sas_base.c:8085:2: error: mutex 'ioc->hostdiag_u=
nlock_mutex' is not held on every path through here [-Werror,-Wthread-saf=
ety-analysis]
 8085 |         pci_cfg_access_unlock(ioc->pdev);
      |         ^
drivers/scsi/mpt3sas/mpt3sas_base.c:8019:2: note: mutex acquired here
 8019 |         mutex_lock(&ioc->hostdiag_unlock_mutex);
      |         ^
./include/linux/mutex.h:171:26: note: expanded from macro 'mutex_lock'
  171 | #define mutex_lock(lock) mutex_lock_nested(lock, 0)
      |                          ^
drivers/scsi/mpt3sas/mpt3sas_base.c:8087:2: error: releasing mutex 'ioc->=
hostdiag_unlock_mutex' that was not held [-Werror,-Wthread-safety-analysi=
s]
 8087 |         mutex_unlock(&ioc->hostdiag_unlock_mutex);
      |         ^

Cc: Ranjan Kumar <ranjan.kumar@broadcom.com>
Fixes: c0767560b012 ("scsi: mpt3sas: Reload SBR without rebooting HBA")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/m=
pt3sas_base.c
index dc43cfa83088..212e3b86bb81 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -8018,7 +8018,7 @@ _base_diag_reset(struct MPT3SAS_ADAPTER *ioc)
=20
 	mutex_lock(&ioc->hostdiag_unlock_mutex);
 	if (mpt3sas_base_unlock_and_get_host_diagnostic(ioc, &host_diagnostic))
-		goto out;
+		goto unlock;
=20
 	hcb_size =3D ioc->base_readl(&ioc->chip->HCBSize);
 	drsprintk(ioc, ioc_info(ioc, "diag reset: issued\n"));
@@ -8038,7 +8038,7 @@ _base_diag_reset(struct MPT3SAS_ADAPTER *ioc)
 			ioc_info(ioc,
 			    "Invalid host diagnostic register value\n");
 			_base_dump_reg_set(ioc);
-			goto out;
+			goto unlock;
 		}
 		if (!(host_diagnostic & MPI2_DIAG_RESET_ADAPTER))
 			break;
@@ -8074,17 +8074,19 @@ _base_diag_reset(struct MPT3SAS_ADAPTER *ioc)
 		ioc_err(ioc, "%s: failed going to ready state (ioc_state=3D0x%x)\n",
 			__func__, ioc_state);
 		_base_dump_reg_set(ioc);
-		goto out;
+		goto fail;
 	}
=20
 	pci_cfg_access_unlock(ioc->pdev);
 	ioc_info(ioc, "diag reset: SUCCESS\n");
 	return 0;
=20
- out:
+unlock:
+	mutex_unlock(&ioc->hostdiag_unlock_mutex);
+
+fail:
 	pci_cfg_access_unlock(ioc->pdev);
 	ioc_err(ioc, "diag reset: FAILED\n");
-	mutex_unlock(&ioc->hostdiag_unlock_mutex);
 	return -EFAULT;
 }
=20
