Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64C5FF9DF
	for <linux-scsi@vger.kernel.org>; Mon,  1 Jul 2024 18:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719857074; cv=none; b=fYhvEnjnG1bbUZdA+5WN+KCQqbZrYlllYXImq6FJr4/2gvh87pGDiJpdEkWoATnyPF7yF3oCbBB+ozTpSv5dVoRbytOyF6F7H66R3zyUw/FUiB/UcWeViTt8KOiNOusLqkX4YS7Hdc7HLYE3ZFpIptQtes8WeFRk24GE6N4I3ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719857074; c=relaxed/simple;
	bh=ABBzUPQoIe+SNzSLVsfAQ1NZp0ZsZbUjDwBef9LHq04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kr57mVYe9TrgbL+5E7e+Aui1mkGtqA9dGTkJpCDlaEsLYq4lvXkGHML9EnTegvqUlmuZU7tGfFbPEHEvnP8TNSml4t0ey67Y/+e4AsiyvrQh6XjhLOpxNwa27maz50yIhNFyalTQJQ/SOuV/8QPdcvdCPM1JqXL5VD3Xz5KrgMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=F+C9xg47; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="F+C9xg47"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4WCYpS5gLGzlffm0;
	Mon,  1 Jul 2024 18:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1719857071; x=1722449072; bh=NxEFU
	pD+XWhsdqy770HiHBD2+8wMulA8pEM6qMbDMKo=; b=F+C9xg47Ds02YeOQLZIly
	/jgZSauwUo4jDyVoP39t+HI7Jn1G5WXe+n9V3S1cTg3Bk2KNjW7/YhJ19Br5LydJ
	Eol2iEhMpAezEEC2QPspQ9KpLWuWz95+g0YV5ynwBcpQomXA5ExinQCr8Vj6RKNt
	UFfpb98d4or1t1Ln2dwwKuKqp7dmrGRn7zQU6cK6IasFesuoQGIx2XCj1Q8+k/mT
	D8yHYWr4RZTzd5vfImrar3fOlrD5xL235lXW1KExLgzDaT0aCfDk9Gswf6QSXIHx
	UFWI8pyMMgeYV2PEQxE0yq6EP2aBafl7HlzEk5um15gl/swki7kFDyypidh8t9UW
	Q==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id hyjs5ZAnnhcI; Mon,  1 Jul 2024 18:04:31 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4WCYpQ6y4DzllCRq;
	Mon,  1 Jul 2024 18:04:30 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v3 1/7] scsi: ufs: Declare functions once
Date: Mon,  1 Jul 2024 11:03:29 -0700
Message-ID: <20240701180419.1028844-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.45.2.803.g4e1b14247a-goog
In-Reply-To: <20240701180419.1028844-1-bvanassche@acm.org>
References: <20240701180419.1028844-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Several functions are declared in include/ufs/ufshcd.h and also in
drivers/ufs/core/ufshcd-priv.h. Remove the duplicate declarations.

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
