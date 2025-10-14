Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B355E3054E5
	for <linux-scsi@vger.kernel.org>; Tue, 14 Oct 2025 20:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760472208; cv=none; b=OdpvVSyeSLEqrsbCyHdmO2iSmDngnQGoRMlvooEv0p9oJ+WkZ2hrYwcRJ0OwAAbygXqFdLuzujJhKYwS88mGOMS7tN+39jRWDl6l0BNgiWaZC5nX0sNsIo1CMzUxspVnpdvKNsme/wUqvH5WfJ8h9MAE4pTJo0GCCFzyIwKN9uE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760472208; c=relaxed/simple;
	bh=3GGSNEFO2GIW6yhCWNDuZg/1hr/4lTvwivEeXVZ3ZII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=si9Npkq6tZ3Qy5T9OW6ysXv0JAET3lUhRd4GCv4P6vxwTKu81gHIOP3l4+m7oTTHf9k/KyfSs2KJPMZw+sQDCbwFnCbxJM45FiLT5jiTsZC1aj6wJB1yy8EJLGaAHQsHhyN7+EgAL5mlyqoEC1xRWN22eNCQVYtsnReCIH+3/ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=sA5566a0; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="sA5566a0"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cmQBj6GdwzlgqTt;
	Tue, 14 Oct 2025 20:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1760472203; x=1763064204; bh=6oC9B
	IJhV3MCTIUGRECNTTWXKaYqzBIS9ewHKQCSVNA=; b=sA5566a0tu3MlFQ4/NFBE
	MFLtye0SW9fYsSf2LoI37lpnwFKUQG9DFOjtU99SXpOW2AfWuqgUNymFb4M/IGjY
	ZGWh0V9J303Li/pUxOSYvvzV6g2F9YiE4w315TXntrXhw0FjWJVuWjw39RmQTPIp
	xTSlBrV00qM4zjsj3NIhlL8ANhVDW/YSSpj34YTVN6NUhhz6jzNxkxEH4JRICmwT
	npf4Gmedqw7Uq+SPKEAzMaPSpQN2Mnb9wUQefeh/8vaQiy0wmmML6LUuT60FOfpX
	vtTdWbvQ0SJ+gklhj4u2GwUnc/F6WBERmveUmJy+S3F3tlPdIYmBOPG+UgJ9Y8vp
	Q==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ayv8eBQvIggo; Tue, 14 Oct 2025 20:03:23 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cmQBW1j9LzlgqV0;
	Tue, 14 Oct 2025 20:03:14 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	"ping.gao" <ping.gao@samsung.com>,
	Chenyuan Yang <chenyuan0y@gmail.com>
Subject: [PATCH 8/8] ufs: core: Simplify ufshcd_mcq_sq_cleanup() using guard()
Date: Tue, 14 Oct 2025 13:01:00 -0700
Message-ID: <20251014200118.3390839-9-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.788.g6d19910ace-goog
In-Reply-To: <20251014200118.3390839-1-bvanassche@acm.org>
References: <20251014200118.3390839-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Simplify ufshcd_mcq_sq_cleanup() by using guard(mutex)() instead of
explicit mutex_lock() and mutex_unlock() calls. No functionality has
been changed.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufs-mcq.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index c9bdd4140fd0..d04662b57cd1 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -568,12 +568,12 @@ int ufshcd_mcq_sq_cleanup(struct ufs_hba *hba, int =
task_tag)
=20
 	id =3D hwq->id;
=20
-	mutex_lock(&hwq->sq_mutex);
+	guard(mutex)(&hwq->sq_mutex);
=20
 	/* stop the SQ fetching before working on it */
 	err =3D ufshcd_mcq_sq_stop(hba, hwq);
 	if (err)
-		goto unlock;
+		return err;
=20
 	/* SQCTI =3D EXT_IID, IID, LUN, Task Tag */
 	nexus =3D lrbp->lun << 8 | task_tag;
@@ -600,8 +600,6 @@ int ufshcd_mcq_sq_cleanup(struct ufs_hba *hba, int ta=
sk_tag)
 	if (ufshcd_mcq_sq_start(hba, hwq))
 		err =3D -ETIMEDOUT;
=20
-unlock:
-	mutex_unlock(&hwq->sq_mutex);
 	return err;
 }
=20
