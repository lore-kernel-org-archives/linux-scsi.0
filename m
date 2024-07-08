Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63C564503B
	for <linux-scsi@vger.kernel.org>; Mon,  8 Jul 2024 21:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720473459; cv=none; b=XVH78RAki8ewAWJ4rFfXWLBKD3UXYjmOVAlPbiY00SH9m2zQLYLxFAxfs7uYsaD/ovYkHpjVwuiPGHBsbYcmItF/75RFSinWirc63f0+B/1jftqr3nL47F5w7RemPL1VQJCEVfGdlS0hVoHeukkmhAZH2YcjC8w9do6eF/0a4Tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720473459; c=relaxed/simple;
	bh=BAsc5MLO+gwJmiwQcYML31t1QPduHNpHmT0E31XYwoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LUjAq33jp5gvx4t92j6N1aI+aqAQvXSn0LrzSpFug9AgGNuUY/Nw97N93OXDxeFQEIi01ZY5Ysi8RseCtw0xUYeoA3siWJmdflbuoQ5WiGQ4j9Li4jqbiqgLSfVixgpGOl9sqorwpQ5oXyciZpGo4GHpASgmLk7gj9aHu0LrE/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=1/TJrdkk; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="1/TJrdkk"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WHxm12FLnz6Cnk9T;
	Mon,  8 Jul 2024 21:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1720473453; x=1723065454; bh=d2wWr
	BfTigkQD5z/WfCBGOH20AyrfifTkBSPKGeJhzQ=; b=1/TJrdkkYM83gcEieYbeP
	LWAyEVIdcOmMALm2ssGackqcrsCRHHn8yTyvoksb/HdO9T7eYJpwQCqSZofZG0dE
	cb489Ukb06wqynlFjN/2ZmrmCxYXbb2JnOGPc0FaQUaAEk6igMd3y8bL4eiRi0RA
	F8rO97aO50DSVNIShjDJD+hrt4TxBGHW+RAE2p/TftUn/kf/CD3GVoF1hCNjGNKn
	D4tN3TeSvNalCijJnNv8IzJNvXfAIi2mABQAL206XhagRXy5xuFwMJKKb0SBWJxe
	9mhzi2+kZz3cMC3QU65JwurIfbsvpFWrzVGvcsU7v8iLmS7dZnw7t+kn+5LoAVJa
	w==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id KTIP1d4-nAdl; Mon,  8 Jul 2024 21:17:33 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WHxlv4MDFz6Cnk9N;
	Mon,  8 Jul 2024 21:17:31 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	peter.wang@mediatek.com,
	manivannan.sadhasivam@linaro.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Subject: [PATCH v5 01/10] scsi: ufs: Declare functions once
Date: Mon,  8 Jul 2024 14:15:56 -0700
Message-ID: <20240708211716.2827751-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.45.2.803.g4e1b14247a-goog
In-Reply-To: <20240708211716.2827751-1-bvanassche@acm.org>
References: <20240708211716.2827751-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Several functions are declared in include/ufs/ufshcd.h and also in
drivers/ufs/core/ufshcd-priv.h. Remove the duplicate declarations.

Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd-priv.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-pri=
v.h
index f42d99ce5bf1..668748477e6e 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -66,14 +66,8 @@ void ufshcd_compl_one_cqe(struct ufs_hba *hba, int tas=
k_tag,
 int ufshcd_mcq_init(struct ufs_hba *hba);
 int ufshcd_mcq_decide_queue_depth(struct ufs_hba *hba);
 int ufshcd_mcq_memory_alloc(struct ufs_hba *hba);
-void ufshcd_mcq_make_queues_operational(struct ufs_hba *hba);
-void ufshcd_mcq_config_mac(struct ufs_hba *hba, u32 max_active_cmds);
-u32 ufshcd_mcq_read_cqis(struct ufs_hba *hba, int i);
-void ufshcd_mcq_write_cqis(struct ufs_hba *hba, u32 val, int i);
 struct ufs_hw_queue *ufshcd_mcq_req_to_hwq(struct ufs_hba *hba,
 					   struct request *req);
-unsigned long ufshcd_mcq_poll_cqe_lock(struct ufs_hba *hba,
-				       struct ufs_hw_queue *hwq);
 void ufshcd_mcq_compl_all_cqes_lock(struct ufs_hba *hba,
 				    struct ufs_hw_queue *hwq);
 bool ufshcd_cmd_inflight(struct scsi_cmnd *cmd);
