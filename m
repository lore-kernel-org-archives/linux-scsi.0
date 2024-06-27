Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 549326CDC0
	for <linux-scsi@vger.kernel.org>; Thu, 27 Jun 2024 20:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719518418; cv=none; b=SqgdVR44XLYAA4WS7vUxNoZAe0RLs7CoHcKfQZydXfYgnX7Hv2g0jSPeTkPi5bcptr4A+K414b+nVF1QfFgtaSulmTs9t5ww38E4YllOZM0i7vutVM9HJsuAy40Li7xl2ddzhV1HDPB04Ha/c2R53TqUhLFT3dQ9Hyn/ls4vJoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719518418; c=relaxed/simple;
	bh=70gx9DD1sqqNI4T9UF6iLImLyGhcVM/49EpFzj95A+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P69cxbqPpCQazCXAZ7ZEX1v0Q1W9XkdSBW3rm7DzrBVvTyN3mfQoD83yREIuMMk5ilq0RKgR4DsA7I5jYshT4yeJbw1hA1VBEW0j7UmTJS+0oX3iYw4dzP9AW6ThRACZ7CRs3mpTdNI7oCBzi3EDpQfe4yU6d1SiBerm6avqt0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=B1IyaNj0; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="B1IyaNj0"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4W98Yq66VpzlgMVW;
	Thu, 27 Jun 2024 20:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1719518413; x=1722110414; bh=Ib1Af
	kKZwcIYq8QMbuAo8sOSkNcr0hYxTnvpFMmDejw=; b=B1IyaNj0ULBm5M3hJLW0I
	eTX6j1xWS3pzjfGonjh2eijnDAJdRHTncXFihoFXXQnYGZlW1PnIJFN7Q3PYt9vh
	Sg5bL3i568qfUUIHACNCS9RkGpYEWqT72I6Q3wfTjJh0CWnT7zsdJqI2ZKQh2kUc
	VO+VuUmPyLLTuCjv3Gcq2fQHd5OVkyme96OuEqnTXv+XN2lpRHuYRJe1I5xyRsYL
	b07cAYMmuMThcDRI0pgNw3oSLmtexZbxGP5ed5VGxAb/UAJro0RJM9rDInXGdsk2
	aZX3iyAYOebsVHNYZvySTtm740e2hN0Zx4JxkYXFiUceMaPY1fSkvINbEu5FZSpv
	g==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id esekzu_yM_H8; Thu, 27 Jun 2024 20:00:13 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4W98Ym1WZYzll9br;
	Thu, 27 Jun 2024 20:00:11 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@wdc.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Keoseong Park <keosung.park@samsung.com>
Subject: [PATCH v2 1/7] scsi: ufs: Declare ufshcd_mcq_poll_cqe_lock() once
Date: Thu, 27 Jun 2024 12:58:27 -0700
Message-ID: <20240627195918.2709502-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.45.2.803.g4e1b14247a-goog
In-Reply-To: <20240627195918.2709502-1-bvanassche@acm.org>
References: <20240627195918.2709502-1-bvanassche@acm.org>
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

Reviewed-by: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd-priv.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-pri=
v.h
index f42d99ce5bf1..0bce72848402 100644
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
