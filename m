Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D63831329D
	for <linux-scsi@vger.kernel.org>; Mon, 27 Oct 2025 15:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761579909; cv=none; b=P7ZwMD8mY6Qzx7i3nOUOlhMYSjgDsbhpytLUjdlT+1vm/yQnVrcxxF5lkEbfnm+ii2ayH/cNFwcaVlFkya1h5UGHM0saT7BdoWPZrTTR94zl9osguQ+85MsG0IyYY2UwQwYMALGQygy9MIFwbvOlRwiZx813qWgTKLf1/Im+8Wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761579909; c=relaxed/simple;
	bh=ne2Jse7UVQFn7byV2i/y5n6Ei0DFGdCyY0rPfLMJl/8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TzSNlrxusMmuXqZXZO8j1EH5Uey/82qawkUrm9gOKK4FFB1irCb673y6tdJ7L+qdBkBTdE7+OqNjd2AkgOp1btBtyW/GVJA0tWz68gR0i3S3XFN9/TGBSmKz8xaPQL519HqRnp9CgJjZAxeZEkpfgh8/auON4dV4LG4dIgWW3t0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=2VLnhCRw; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="2VLnhCRw"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cwHrX0Nj7zm0yTm;
	Mon, 27 Oct 2025 15:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1761579897; x=1764171898; bh=ylDij/AU+kocM1XOlFTkr2kZK18wcqckovR
	WauHDQ4Y=; b=2VLnhCRw0KVO4auUQ1pWYPOm0PbNS4I5H0IrxKbnfBS9eFZT8Yo
	qDkjp/Qmx5+Ya97/K7ZrvT9ugiZ8eDhGhsgLY9P+r1kGLhsmprsb0jtYxeVXam+r
	c3s4HaZN6Qq47LuPQZxAJEcjNy5iTMiEd+eJDaxhxKyvITev+VB2+Rokfd9QPBGn
	WMRF0N2q7cLXKZq5j2bs3EplC7T3I5iAP2I0Us/wnAZVDK01kb0SVYiwn9sB7A91
	ZR+xyfLQrgRudYutYGGhpmh/ngKR8pHYVK+NoQP7xkIP+5IpJphiCq8MH+CCLr5I
	MQstzapc22Bk7rnp7d/YjYXkxnClZnr47tA==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id YY_UUsaGnihO; Mon, 27 Oct 2025 15:44:57 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cwHrK3Yfbzm0yVV;
	Mon, 27 Oct 2025 15:44:48 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	"ping.gao" <ping.gao@samsung.com>,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Po-Wen Kao <powen.kao@mediatek.com>,
	Stanley Jhu <chu.stanley@gmail.com>,
	Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH] ufs: core: Fix the UFSHCD_QUIRK_MCQ_BROKEN_RTC implementation
Date: Mon, 27 Oct 2025 08:44:34 -0700
Message-ID: <20251027154437.2394817-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.1.851.g4ebd6896fd-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

ufshcd_mcq_sq_cleanup() must return 0 if the command with tag 'task_tag'
is no longer in a submission queue. Check whether or not a command is
still pending by calling ufshcd_mcq_sqe_search().

Fixes: aa9d5d0015a8 ("scsi: ufs: core: Add host quirk UFSHCD_QUIRK_MCQ_BR=
OKEN_RTC")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufs-mcq.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index d04662b57cd1..cd47b7e438f4 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -36,6 +36,9 @@
 /* Max mcq register polling time in microseconds */
 #define MCQ_POLL_US 500000
=20
+static bool ufshcd_mcq_sqe_search(struct ufs_hba *hba, struct ufs_hw_que=
ue *hwq,
+				  int task_tag);
+
 static int rw_queue_count_set(const char *val, const struct kernel_param=
 *kp)
 {
 	return param_set_uint_minmax(val, kp, UFS_MCQ_MIN_RW_QUEUES,
@@ -553,9 +556,6 @@ int ufshcd_mcq_sq_cleanup(struct ufs_hba *hba, int ta=
sk_tag)
 	u32 nexus, id, val;
 	int err;
=20
-	if (hba->quirks & UFSHCD_QUIRK_MCQ_BROKEN_RTC)
-		return -ETIMEDOUT;
-
 	if (task_tag !=3D hba->nutrs - UFSHCD_NUM_RESERVED) {
 		if (!cmd)
 			return -EINVAL;
@@ -566,6 +566,10 @@ int ufshcd_mcq_sq_cleanup(struct ufs_hba *hba, int t=
ask_tag)
 		hwq =3D hba->dev_cmd_queue;
 	}
=20
+	if (hba->quirks & UFSHCD_QUIRK_MCQ_BROKEN_RTC)
+		return ufshcd_mcq_sqe_search(hba, hwq, task_tag) ? -ETIMEDOUT :
+			0;
+
 	id =3D hwq->id;
=20
 	guard(mutex)(&hwq->sq_mutex);
