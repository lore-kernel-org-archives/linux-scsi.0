Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 430CD1C5D50
	for <linux-scsi@vger.kernel.org>; Thu,  3 Apr 2025 21:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743715403; cv=none; b=rZf+sY+PJ3PO+ts4UWnJxsBT0dpLUqxNbhNplHGGhTjfympXz6KldJFOQBvHnGQR269j7MC1zQjftF2i7jQ2A5pKTUp8ZFAB6Q7z1PvMQAAXEthy6gJ/aslf46i3wYxDRAMn2QElnshOciAKRRDwPDMF2fR4Zfks+zMDwQNb0eY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743715403; c=relaxed/simple;
	bh=nhmAx3JNr9boclc24R3JdsWj6QHbz73D9CknCoQS66E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hSkuauP41xAPIX6wDe3LVhHWXbn1QuC4Ir94NkTpiZbXJLIWR2GGUGj8klIky+QsYBbkkWa8kQ01ovVZwFR7+hG09EGIFdv5nlqZKYhmx1fdsWHzADwTFo+0o9LiWeoJb7DFkt0vDDtlTGDkkkL2Pt2dzVEc7gPF71iQqkkhGS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Essa2khw; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Essa2khw"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4ZTF8T1NXpzm0yTx;
	Thu,  3 Apr 2025 21:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1743715399; x=1746307400; bh=pZ+YY
	V+YOoTn+PT6ZEaosJQyMOhWrv8XAV+MyfwCkfo=; b=Essa2khwodOOUGvhto2Vw
	lIerpPa2gP9KGksnRLdfRqppIZmER9K/DlyagPzaL3DFY585g0URsT0qotY6aP3P
	IprpqDilX7Y4WgnS0JARCzgwk9hNHaY4tqnAMRfk3cpDHCAMo1zXy7BWBQ1gH4fB
	sUwX65rXJNPx6OEPuSrY7z3N0rkq8IV7Afm1M0l/HlLOGPyl89UuU804PLOTYoTo
	zy6Fk0SzAhGinLWI5R24LF5frYecbgj/+YMohwd3CXoyQBCdbxUO70mnO7FSLtJC
	I1meBzKYg14uz+x/wOE1iEuTli2JwhM4hZ0UOM8cFntjJrm/mujM+oHUS+mTAH6e
	g==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id aSjLnRjIxdDn; Thu,  3 Apr 2025 21:23:19 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4ZTF8J4kRwzm0pKF;
	Thu,  3 Apr 2025 21:23:11 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Minwoo Im <minwoo.im@samsung.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Chanwoo Lee <cw9316.lee@samsung.com>
Subject: [PATCH 20/24] scsi: ufs: core: Use hba->reserved_slot
Date: Thu,  3 Apr 2025 14:18:04 -0700
Message-ID: <20250403211937.2225615-21-bvanassche@acm.org>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
In-Reply-To: <20250403211937.2225615-1-bvanassche@acm.org>
References: <20250403211937.2225615-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Use hba->reserved_slot instead of open-coding it.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufs-mcq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index cec21bb50cec..3c9d308d84e0 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -547,7 +547,7 @@ int ufshcd_mcq_sq_cleanup(struct ufs_hba *hba, int ta=
sk_tag)
 	if (hba->quirks & UFSHCD_QUIRK_MCQ_BROKEN_RTC)
 		return -ETIMEDOUT;
=20
-	if (task_tag !=3D hba->nutrs - UFSHCD_NUM_RESERVED) {
+	if (task_tag !=3D hba->reserved_slot) {
 		if (!cmd)
 			return -EINVAL;
 		hwq =3D ufshcd_mcq_req_to_hwq(hba, scsi_cmd_to_rq(cmd));
