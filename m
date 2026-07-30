Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 105875464C
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 22:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785451695; cv=none; b=lvWVZLy61MNkJ4rt/BWHVwObxoRKMYBLlgiDja4zGrSR0V4Hr6SanVkABGJs5vCVEwY8jsrFhLOMhEv3TeAMo0HfD4GgDQNMrwhvsVAgyk4ZoaZwVuZMqqyKdPRkfOPre0QYxnaABVivsasLc8tqpuWL6Y7fwun5l1cXBpz2vU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785451695; c=relaxed/simple;
	bh=Uh2kqNzenSgeuokHHwOo59nRuvU3MlOuJNSDr8grqTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lMC7P2tSOrOoM900LOouNJJtP6iE0512yilD2iwyK9vIVFywiLq/amIyZT87nrl8ujnjzCHYqOCwTI7KUFH5a5BkFgsM0j5h0qptaHCNY9AlJnvOp+q5U/ES+iT0eOTXdt1ed1u0Z4SEYh4eKgE1KPFFUs9Df8JNMXUpouZIuBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=xZO7WhVA; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="xZO7WhVA"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hB49T5k2Tz1XM2FN;
	Thu, 30 Jul 2026 22:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1785451690; x=1788043691; bh=T8bCX
	+kZFkL4o/NjINdXo14hgrpSu5S5lRQMb0p/oEI=; b=xZO7WhVAQOTGhHG6S7SL7
	dhtdu0DT2gjzCgoeMBQGOy0T7mW7zDvzGK1mI9y8NH++6/u2CfdS7n5VbZxp/dTI
	t0RjHsHeWzKUkzHtzqoJtCgGsR5rLxmq4pDrjgzG9bVSEnCgVPHUqGX7uaUnPJ9e
	7oJBj70Uha9K2BDJYZcHDE9/0AFgFi6s5Wj84XqeeHg0+WRkasmHiCrmdqOuMbdN
	rRMgIL5eG3usDilQ3xFUOrYeZ21B9KNNylvKsp3/GrPrH23S31lMZpQsyu+xcP4E
	1i1HTf+hVB73W3hP4sp01Xd3PkEKUzvZ9oUwSAViv5PuCpKjBA3dODGjfGL+AlbZ
	w==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id lQ3bI28WqzHC; Thu, 30 Jul 2026 22:48:10 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hB49N48TQz1XM4TB;
	Thu, 30 Jul 2026 22:48:08 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Marco Elver <elver@google.com>,
	linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Don Brace <don.brace@microchip.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH v3 28/57] scsi: hpsa: Prepare for enabling lock context analysis
Date: Thu, 30 Jul 2026 15:45:11 -0700
Message-ID: <e26d3c5bd77310a14adb0d72e9f1b5f760a4a4a4.1785451174.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
In-Reply-To: <cover.1785451174.git.bvanassche@acm.org>
References: <cover.1785451174.git.bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

mutex_lock_interruptible() returns a negative value upon failure or zero
upon success. Since the Clang thread-safety analyzer only supports =3D=3D=
 0
and !=3D 0 tests for functions that perform conditional locking, change
the =3D=3D -EINTR test into !=3D 0. This change does not modify the behav=
ior
of hpsa_do_reset().

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/hpsa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index a1b116cd4723..1b3595c6e036 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3163,7 +3163,7 @@ static int hpsa_do_reset(struct ctlr_info *h, struc=
t hpsa_scsi_dev_t *dev,
 	int rc =3D 0;
=20
 	/* We can really only handle one reset at a time */
-	if (mutex_lock_interruptible(&h->reset_mutex) =3D=3D -EINTR) {
+	if (mutex_lock_interruptible(&h->reset_mutex)) {
 		dev_warn(&h->pdev->dev, "concurrent reset wait interrupted.\n");
 		return -EINTR;
 	}
