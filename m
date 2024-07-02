Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CD871CF8F
	for <linux-scsi@vger.kernel.org>; Tue,  2 Jul 2024 20:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719952867; cv=none; b=qxzkbGNSe9uAO6yaDFT5z7VEAD+4ccUmoGVqznrPN7ymtG25yW3oMqFo6ZXUyezAEIz9hSc3o0kJ5PzwODmCI3SBKNP4KcydngZwdjmKKT9FuIOo+J9ALDDR3tqRafVgZj6xP6JRCsDgVa2fBTjx8P9Z+nPUAm7PVavpqxG//FY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719952867; c=relaxed/simple;
	bh=BAsc5MLO+gwJmiwQcYML31t1QPduHNpHmT0E31XYwoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dN0Yx3yaoElIEGBK45qGRjvtb95efcORGRl7D7oneP8PqRWg/UxKEiUYNXiKiHJ1MTtZUMHnYhvfvZxN8U/BFVFHCbPmrHqcDdLAL40FQgxj2bPERqh6a7EuGpYbMO2QGZxJVUkNY7Ln6GYMPxrAlYkrAUjlJKEpNXB+gcbJBzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=bIIkIxlp; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="bIIkIxlp"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WDFDc67zsz6Cnv3Q;
	Tue,  2 Jul 2024 20:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1719952861; x=1722544862; bh=d2wWr
	BfTigkQD5z/WfCBGOH20AyrfifTkBSPKGeJhzQ=; b=bIIkIxlptPuF1EiQcFUAr
	FbjVwllJlikvqtyNTxwmmM5iiDhXFP1iLxDmXt3DwqpHWAdJIYIaJmWKcspyX89Z
	BPTFgnvGVcGaaFMru8bHrDEcfG/hiUw0DBId9UbYYuLq5yhvDh3+wayXiz6hVAv0
	/cmgS5MYVNUKdkfSV8BVP4PLPNAr/H+1QcQ7AAHGti51fbHyaQvJae/aWN1YMu24
	712j/d7MUlumy7wvMZ5KVNCTT/ZLB1KIhnUNT9zef25DDvQo+B3oWg1Tv+4WDcqI
	O4adnhw/V9KTC/gpyH5Rw8jeV7EQJ38UalPS0xveAAWVwJlB5/8DUmbCJigX1Vj0
	Q==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id NubCWLbfKFMb; Tue,  2 Jul 2024 20:41:01 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WDFDY2Mmxz6Cnk9X;
	Tue,  2 Jul 2024 20:41:01 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Peter Wang <peter.wang@mediatek.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Subject: [PATCH v4 1/9] scsi: ufs: Declare functions once
Date: Tue,  2 Jul 2024 13:39:09 -0700
Message-ID: <20240702204020.2489324-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.45.2.803.g4e1b14247a-goog
In-Reply-To: <20240702204020.2489324-1-bvanassche@acm.org>
References: <20240702204020.2489324-1-bvanassche@acm.org>
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
