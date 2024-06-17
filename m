Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 917181990AA
	for <linux-scsi@vger.kernel.org>; Mon, 17 Jun 2024 21:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718658580; cv=none; b=IkMYlADobhCJvo2fm/0xeaBwKsQHZ/6J0jk7BmsmAq7fAtf/9ZGnScIZfEWSDBPTS8Ssqxj+xcLMYxcHkyB2GhezCZknQ2J4EChibO5Z7IkKlzNnZCeg5DpiqJGlmzuJAAKSZ6ULzmV1gHm7Fexajml9Yjaqp7nkj0DCYJmLJE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718658580; c=relaxed/simple;
	bh=2zKDr8TmKteVUKVH/MAwKAaBSZyj490W7Dnu5Frhw20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IXH4PYx7AYv0W2BJNDoZXHa8Inl9noNAUySL5hGaF+6IMlVtlbkORwpoIws7o92yetEKSlhdMXXQVmeyOInIX0qYoWfj7we9rugZf9mCPJfURFpVeCHNVJTdf0HM5LNGxeGxqcuSgfpfy6QaHcI+lh47/du9WON0uT4fG+IQU+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=sJlgJhgV; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="sJlgJhgV"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4W32ZT6wWSz6Cnk8y;
	Mon, 17 Jun 2024 21:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1718658570; x=1721250571; bh=oY0f7
	FaDNCyBr1Oi4AJhOqe+7IsMJ9NaLgyilxl9+SE=; b=sJlgJhgVqfJJl33Z6BoJS
	2GHCug4LHBO8mjyxczLrtFdRyphimFMqXTOuMdlJzl24sKopWk0H0ecCy/YajdGU
	bwguvazj6zuHen1PgrLI8wSoyKf1nD4+KsRgnSupJjq/+8bqiD9XgVqCksqGEX6h
	FJ3fcqb/5gqpMLhEZ2QDV1ZSsBkLY9f1CiRIkkOtH64Pu9WRyWni47LdkgeHIxGU
	LtHCwFSeOA/3fYPThf7PdIhWpe3+dFMEKAKG2MT0KOZmRm0uKLwEPKZfTKJDmUpZ
	yZlZ2iURTBSuAi5cAipvd3+657j7paSfTlRTwD1WUw6Anl0uaNnJZCxVqscapjsU
	w==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id PTi_Naww_Y4z; Mon, 17 Jun 2024 21:09:30 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4W32ZJ594cz6Cnk95;
	Mon, 17 Jun 2024 21:09:28 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Minwoo Im <minwoo.im@samsung.com>,
	Peter Wang <peter.wang@mediatek.com>,
	ChanWoo Lee <cw9316.lee@samsung.com>,
	Yang Li <yang.lee@linux.alibaba.com>,
	Po-Wen Kao <powen.kao@mediatek.com>,
	Avri Altman <avri.altman@wdc.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Maramaina Naresh <quic_mnaresh@quicinc.com>,
	Akinobu Mita <akinobu.mita@gmail.com>,
	Bean Huo <beanhuo@micron.com>
Subject: [PATCH 4/8] scsi: ufs: Make .get_hba_mac() optional
Date: Mon, 17 Jun 2024 14:07:43 -0700
Message-ID: <20240617210844.337476-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.45.2.627.g7a2c4fd464-goog
In-Reply-To: <20240617210844.337476-1-bvanassche@acm.org>
References: <20240617210844.337476-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

UFSHCI controllers that are compliant with the UFSHCI 4.0 standard report
the maximum number of supported commands in the controller capabilities
register. Use that value if .get_hba_mac =3D=3D NULL.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufs-mcq.c | 12 +++++++-----
 include/ufs/ufshcd.h       |  4 +++-
 include/ufs/ufshci.h       |  2 +-
 3 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index 0482c7a1e419..d6f966f4abef 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -138,7 +138,6 @@ EXPORT_SYMBOL_GPL(ufshcd_mcq_queue_cfg_addr);
  *
  * MAC - Max. Active Command of the Host Controller (HC)
  * HC wouldn't send more than this commands to the device.
- * It is mandatory to implement get_hba_mac() to enable MCQ mode.
  * Calculates and adjusts the queue depth based on the depth
  * supported by the HC and ufs device.
  */
@@ -146,10 +145,13 @@ int ufshcd_mcq_decide_queue_depth(struct ufs_hba *h=
ba)
 {
 	int mac =3D -EOPNOTSUPP;
=20
-	if (!hba->vops || !hba->vops->get_hba_mac)
-		goto err;
-
-	mac =3D hba->vops->get_hba_mac(hba);
+	if (!hba->vops || !hba->vops->get_hba_mac) {
+		hba->capabilities =3D
+			ufshcd_readl(hba, REG_CONTROLLER_CAPABILITIES);
+		mac =3D (hba->capabilities & MASK_TRANSFER_REQUESTS_SLOTS) + 1;
+	} else {
+		mac =3D hba->vops->get_hba_mac(hba);
+	}
 	if (mac < 0)
 		goto err;
=20
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index d4d63507d090..d32637d267f3 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -325,7 +325,9 @@ struct ufs_pwr_mode_info {
  * @event_notify: called to notify important events
  * @reinit_notify: called to notify reinit of UFSHCD during max gear swi=
tch
  * @mcq_config_resource: called to configure MCQ platform resources
- * @get_hba_mac: called to get vendor specific mac value, mandatory for =
mcq mode
+ * @get_hba_mac: reports maximum number of outstanding commands supporte=
d by
+ *	the controller. Should be implemented for UFSHCI 4.0 or later
+ *	controllers that are not compliant with the UFSHCI 4.0 specification.
  * @op_runtime_config: called to config Operation and runtime regs Point=
ers
  * @get_outstanding_cqs: called to get outstanding completion queues
  * @config_esi: called to config Event Specific Interrupt
diff --git a/include/ufs/ufshci.h b/include/ufs/ufshci.h
index c50f92bf2e1d..899077bba2d2 100644
--- a/include/ufs/ufshci.h
+++ b/include/ufs/ufshci.h
@@ -67,7 +67,7 @@ enum {
=20
 /* Controller capability masks */
 enum {
-	MASK_TRANSFER_REQUESTS_SLOTS		=3D 0x0000001F,
+	MASK_TRANSFER_REQUESTS_SLOTS		=3D 0x000000FF,
 	MASK_NUMBER_OUTSTANDING_RTT		=3D 0x0000FF00,
 	MASK_TASK_MANAGEMENT_REQUEST_SLOTS	=3D 0x00070000,
 	MASK_EHSLUTRD_SUPPORTED			=3D 0x00400000,
