Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BF6015B7
	for <linux-scsi@vger.kernel.org>; Fri, 12 Apr 2024 00:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712880184; cv=none; b=JNKNEsQXAkVtRmI1vvmNKUwZUa7CUzcqEsTlRVvv8KcytAnAAqUVM5/KDSsYsJix2QfmFQTs2VfkhHISb+atgOvm04t3NFdHJxB5R2pvQ2m8aq0QuaBpVog6NXNv+eJsrMXmUYBhTyWEhpnqG8SP0Of08wPZlpt6Yjp6o8Mowb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712880184; c=relaxed/simple;
	bh=T9WrfpuBDHAe4xeZm3YN8pMCpcrsE0CX5iaqAirKMB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ClHUhNE1KCJec1pX5RMTlaY/d55ihKLGELi2vFLY6MTBT6HOaOUlVPp4SftjcsTIh2niG1zQloCyOiz23l+nn/Yl+LEJr07jWZ64t3sCO4pLgzBQb31xFGfuzvqOJQXz46fClqooiuVMk6amVEXQ+yKZeGZbI9h+H8BHMivcDjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=QVDJL7O1; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="QVDJL7O1"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4VFxbV301gz6Cnk8y;
	Fri, 12 Apr 2024 00:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1712880178; x=1715472179; bh=0gyQs
	VhGa672wbZSWf6EJ1bspdIdFZwvR0VKtj2LVjM=; b=QVDJL7O16K5+o0E93kU/3
	ovnCsBamBlHobQf+31lIAx0L+IhGhvOVRH6jNoMNZfnaV+5YFfbMk5PuNM6B1s3u
	5am5nYbRZZzqRGVNTO85ZLptngCToegzQjFyhMrBHD4oTIIGI4+4yxFD92/mrvwI
	vgKPi8tptwKsrK9l38MCi+enjKfzzDs2UE9D4Ax952lPW4826rYCQs/DwJr1Kmrb
	emaL6s7Sv6frSsjlHQtBPiF8p7IfYckV6M+pl0Y2XEKbqVR8+IHx+lmwJe52tHqS
	UPxuxOagjd0nDfTL6qNvnQ4nbsX383YEy2Xrc/09HWaDs5qV+D8XeA7myTCCHu04
	w==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id L5fT2N8GLn8i; Fri, 12 Apr 2024 00:02:58 +0000 (UTC)
Received: from bvanassche-glaptop2.roam.corp.google.com (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4VFxbN1j6Zz6Cnk8m;
	Fri, 12 Apr 2024 00:02:56 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	Stanley Jhu <chu.stanley@gmail.com>,
	Can Guo <quic_cang@quicinc.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Keoseong Park <keosung.park@samsung.com>,
	Po-Wen Kao <powen.kao@mediatek.com>,
	Avri Altman <avri.altman@wdc.com>,
	zhanghui <zhanghui31@xiaomi.com>
Subject: [PATCH 1/4] scsi: ufs: Declare ufshcd_mcq_poll_cqe_lock() once
Date: Thu, 11 Apr 2024 17:02:21 -0700
Message-ID: <20240412000246.1167600-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.44.0.683.g7961c838ac-goog
In-Reply-To: <20240412000246.1167600-1-bvanassche@acm.org>
References: <20240412000246.1167600-1-bvanassche@acm.org>
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
