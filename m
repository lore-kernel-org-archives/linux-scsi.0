Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CD6A131E21
	for <linux-scsi@vger.kernel.org>; Tue, 16 Apr 2024 17:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713287656; cv=none; b=Enk8ntmS+fwQigdaU2nCtus3UMl+ysJXcQ24WIwMzB8q+wSsrmYb7W8MXNajfBJMHToQXFfwWgkglNm+r61Nv/K8CJB96gbnvDCAu3ppXvYsGGysFAPnQbIxJ+Szd4616qxiDQ5nj3hfeXgZkBRsvd1dBqdMOyWbx5w/biQ68Xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713287656; c=relaxed/simple;
	bh=baOxkUWyV5dY0/hGpNjx/6IGGd1S8Le3AQyGgUaqb7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bpHlf5JM2frxSnz7vaSx+uRiZyJKwIlag0+Gd7W1bo0IrAwWBm2zSjl+L5P/bMvl4+PIrpaycwklWb4+n9j4NSZZm91BM5zAcWzpxE8HtRjVGOHM8o8A0JkGceV3jrJ/v+ahcVA3DRb6cIBumwZ3ky0pB2KSLa36Pz8jK2ZwZYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=vL24pf78; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="vL24pf78"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4VJrHV35Lhz6Cnk8t;
	Tue, 16 Apr 2024 17:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1713287650; x=1715879651; bh=UQCNz
	K5G5FpS+9slQUD0ms6yPU100uT00gQm+PolWdI=; b=vL24pf780nUbN7WGN1pqf
	Ej3ijJ8OzPGsCMhQAQWv6/nMP5Ubqq/0lPnBMQT0RSLqTyWylABytW5/jaiohHyZ
	mgznZAT5U95Pq7dSZoJcl/YIL4zWunWJFBxo6XYcU8FB2QK83ARy8lveNxzt/Jcl
	GxCJc8T4VQypbeNT3GqGfq3LYG/GWwUALi9ycMRkF3ss5D3HZRyrkDvi5NXucU2J
	eJ1rcETR0xJa0gLFzqtmCUMbZSTVzUmQa9kfdkne6xv/7vt4fl2H9vxH0i6FycD3
	vXKMUmuwsWNJqqOhh92wnvzThgP3bpjR1LYbTwEHcCEuPuSk3wmvYgFpjSJHz7BF
	Q==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id R3GlAkvsjaL5; Tue, 16 Apr 2024 17:14:10 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4VJrHP3CTcz6Cnk8m;
	Tue, 16 Apr 2024 17:14:09 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	Avri Altman <avri.altman@wdc.com>,
	Stanley Jhu <chu.stanley@gmail.com>,
	Can Guo <quic_cang@quicinc.com>,
	Peter Wang <peter.wang@mediatek.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Bean Huo <beanhuo@micron.com>
Subject: [PATCH v2 2/4] scsi: ufs: Make ufshcd_poll() complain about unsupported arguments
Date: Tue, 16 Apr 2024 10:13:29 -0700
Message-ID: <20240416171357.1062583-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.44.0.683.g7961c838ac-goog
In-Reply-To: <20240416171357.1062583-1-bvanassche@acm.org>
References: <20240416171357.1062583-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

The ufshcd_poll() implementation does not support queue_num =3D=3D
UFSHCD_POLL_FROM_INTERRUPT_CONTEXT in MCQ mode. Hence complain
if queue_num =3D=3D UFSHCD_POLL_FROM_INTERRUPT_CONTEXT in MCQ mode.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 0819ddafe7a6..165557611ae0 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5555,6 +5555,7 @@ static int ufshcd_poll(struct Scsi_Host *shost, uns=
igned int queue_num)
 	struct ufs_hw_queue *hwq;
=20
 	if (is_mcq_enabled(hba)) {
+		WARN_ON_ONCE(queue_num =3D=3D UFSHCD_POLL_FROM_INTERRUPT_CONTEXT);
 		hwq =3D &hba->uhq[queue_num];
=20
 		return ufshcd_mcq_poll_cqe_lock(hba, hwq);
