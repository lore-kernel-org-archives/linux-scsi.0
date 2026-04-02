Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CDD93E5EFB
	for <linux-scsi@vger.kernel.org>; Thu,  2 Apr 2026 17:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775150070; cv=none; b=bhm7dCxEkm9ibnhMdRrjC8icMHpaYDRGq/qZPT+N5gYqobvy7NtLng5wTVw2fKhm3ncvvP6mIemk7NJRp6uz61hWgOlxGbdJMC8y3Mt5xr1GOqQtdFRhxrJW3VrigF54Y6jjLUVfBcvzu1jqoV3ChGjgbHSdd9WIN5QKrGBHD4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775150070; c=relaxed/simple;
	bh=RoP1zGCDU8m8loXful8Rcx2brlNSJyTAmvzN6yBjd0I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rxkaRTboxSeDgEdDcbpjbT7WHXujXB/WejvjSRg1KFu/YsvIXfCVSjjszn71HbiOTCYIJ+jaZTvdUnHyeI47xJHytSLOlrWYKbwupQkdlk0gnxTiDy+xVjHq7dek5E3oC6cAxn5X0519gABPJKGE312SaVjCWin2Ould76CIEQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=g+iVc+EW; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="g+iVc+EW"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4fmpP63NNMz1XM6JX;
	Thu,  2 Apr 2026 17:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1775150056; x=1777742057; bh=INtLxnaz235+D82BNhzknrQ9Go4rp33YsHQ
	qAOyeu8M=; b=g+iVc+EW6A782t7LoT/XMyaEh/P8Cv5D8xCY3Kjd3xjHIyGYCUu
	PHNi9yGerDTlzOmV6YECsmFR/eKsXLHxV0TSxYTveKMxkUDP9davvUy8tgaHi3O0
	QqRmvEB762imv3UQRbLjxvHJcCMtoVtlSDUXdQAGUwvOU16z+BpgmmHODknREOH1
	Jt6RqfDjl32hb8amJurO7OpGF98pqG0CqNsszE7FnhoUtdOOkL9lViTHBPt34+T2
	cVL+2jR4s/pWMDKu1zEh3yB15zkBdpeMCPASpYVHCL8tQ5rlLuxKDas8ydPrmoBA
	jv8p73xI1QPb6k51qDn6+QSBl9L08iVk4xw==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id NWKUzGdxNm3O; Thu,  2 Apr 2026 17:14:16 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4fmpP34R03z1XMFjY;
	Thu,  2 Apr 2026 17:14:15 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 0/2] ufs-qcom: Reduce interrupt latency
Date: Thu,  2 Apr 2026 10:14:00 -0700
Message-ID: <20260402171404.3008494-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.53.0.1213.gd9a14994de-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Hi Martin,

On Android systems it is important to keep the time spent in interrupts s=
hort.
This keeps the user interface responsive and prevents audio stuttering. H=
ence
this patch series to reduce the time spent in the UFS interrupt handler. =
Please
consider this patch series for the next merge window after test results h=
ave
been shared by Qualcomm.

Thanks,

Bart.

Changes compared to v1:
 - Dropped the ufshcd_mcq_compl_all_cqes_lock() changes.
 - Renamed ufshcd_mcq_poll_cqe_lock_n() into ufshcd_mcq_poll_n_cqe_lock()=
.

Bart Van Assche (2):
  ufs: core: Introduce ufshcd_mcq_poll_n_cqe_lock()
  ufs: qcom: Reduce interrupt latency

 drivers/ufs/core/ufs-mcq.c  | 14 +++++++++++---
 drivers/ufs/host/ufs-qcom.c | 33 +++++++++++++++++++++++++++++----
 include/ufs/ufshcd.h        |  3 +++
 3 files changed, 43 insertions(+), 7 deletions(-)

