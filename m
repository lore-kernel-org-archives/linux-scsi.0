Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9455118C356
	for <linux-scsi@vger.kernel.org>; Mon, 17 Jun 2024 21:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718658578; cv=none; b=Vz46co1dlpChz6NcIh5tN8+TmL5C3OQGQqHKOCKK7AT8pdf3rb9V4T9qBjhW09kehtlqyjqcXAs/Ecmibj2q9R8XldRm0nO/YtR/GTA0sFMrVwwEKIP6qTzq40Wagd6ihzHefxD3VJvRoyIXZ3rVpeDgqksYo0NoNL1PmNO4Wao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718658578; c=relaxed/simple;
	bh=T9WrfpuBDHAe4xeZm3YN8pMCpcrsE0CX5iaqAirKMB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bcVhOXfTZjtdlIMQvqjCpnh5OeRW4TXMczQOyMA0mI+T01TMEr2TL9Qgsbr5MS+8/GWkRoYYMS64i3qjmlLssq86RHPsDLVJiatH53IM9gn8btB9PyOyNqVbv5hcyQHrSSp7TuQAOpTeW8BKNY7Th9vslS0kzdvobQkKYSRy1OU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=EbzvC5iM; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="EbzvC5iM"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4W32ZS2bVXz6Cnk9B;
	Mon, 17 Jun 2024 21:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1718658574; x=1721250575; bh=0gyQs
	VhGa672wbZSWf6EJ1bspdIdFZwvR0VKtj2LVjM=; b=EbzvC5iM+imUYi2HJeVu0
	31BoZPeHClpCjA2LTJeVAcua94Je2fDPTWkbwSGiy6VtYIkGodLCXr0q9yE+9zRm
	gqEoZu6WSsuI8ZyBGenVWMdYwSscrih6422iU5tj70+XZ2QCrghlX9/5lJIjY6g7
	ylp6iP6JdFVv2BK/rMfLa8rLZya5zqrLMuSNr8IdsGQJNztSkOUB4Q163TNcRiux
	VkrLTmppUWlLgOOnDtR8gFSDI0eSPh2CY8tn1Uzz4s5hzT2ksFEEGf2n6oKzI+gT
	yM7T9B3Zu0RjbmSlRswc/nJg58qdmv9yXU4UA+OpvKHYb1Nu8EErhMTxgn4FqhY+
	A==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id W8H4rV7233iW; Mon, 17 Jun 2024 21:09:34 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4W32ZP6h9Mz6Cnk98;
	Mon, 17 Jun 2024 21:09:33 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Keoseong Park <keosung.park@samsung.com>
Subject: [PATCH 5/8] scsi: ufs: Declare ufshcd_mcq_poll_cqe_lock() once
Date: Mon, 17 Jun 2024 14:07:44 -0700
Message-ID: <20240617210844.337476-6-bvanassche@acm.org>
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

ufshcd_mcq_poll_cqe_lock() is declared in include/ufs/ufshcd.h and also i=
n
drivers/ufs/core/ufshcd-priv.h. Remove the declaration from the latter fi=
le.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd-priv.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-pri=
v.h
index a1add22205db..fb4457a84d11 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -72,8 +72,6 @@ u32 ufshcd_mcq_read_cqis(struct ufs_hba *hba, int i);
 void ufshcd_mcq_write_cqis(struct ufs_hba *hba, u32 val, int i);
 struct ufs_hw_queue *ufshcd_mcq_req_to_hwq(struct ufs_hba *hba,
 					   struct request *req);
-unsigned long ufshcd_mcq_poll_cqe_lock(struct ufs_hba *hba,
-				       struct ufs_hw_queue *hwq);
 void ufshcd_mcq_compl_all_cqes_lock(struct ufs_hba *hba,
 				    struct ufs_hw_queue *hwq);
 bool ufshcd_cmd_inflight(struct scsi_cmnd *cmd);
