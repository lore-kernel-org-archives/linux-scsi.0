Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB10818DF71
	for <linux-scsi@vger.kernel.org>; Mon,  9 Sep 2024 23:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725923514; cv=none; b=A7VTrM5eBT9uNpnsHHKoZeqtDLpkTBRFwTj2+nNBMps23ypESg+WcBx5Mo3KtsqFACbsq07WRw9EC4hpZn0BveWjRgIqBygo9MQk/DAE4rGLPQs3BC2s5Wqh394jjHAyb1fZ51GFFNJXNQe/5L4fBqmGOxNHGNKvUjvV+YJ1tEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725923514; c=relaxed/simple;
	bh=EXvkP8XuNAYBCPkM3FaNZQZiZshG/TJHBx/V4UIaS1k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=C1+tRYgyLR38JxUI+P49VgHanK/F76XAm7FnYT6MEc9CLJN+JRnwiFd7Gz9G7j79ps7Z0gffpnFr8/29qM07hAMNK9IAQk7KQlaJ38siI3mWjcKxU1Jen8iBEK+HSo/+g1jrjvHOaDLVx+NRGwA+1nO3Us1Rh0HsodKlEOUyuCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=a3EjogEv; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="a3EjogEv"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4X2jJl1fLDz6ClY8r;
	Mon,  9 Sep 2024 23:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1725923509; x=1728515510; bh=E2F2/YYzJWOQBgdTV0Tvn1hD1ukuhri7E+q
	+wPz4WcU=; b=a3EjogEvd0eM3blfzOwbaP9OafOrqDVJhnN2xeCVezGCmhQKXu0
	6+r93qoqHR2VFAuKZ1A3wOOb47f1DBU4+Kyd/oyDRnT1Po/wvT9/TGfaz/Hc6xOi
	rItWQWf9IzEcbxg4UHzI/E0y4/Lk/o6SY9O+Oi2+4/f/yPr3lg1jxvzKfI40pFCl
	fDXrrWV0M+0EO2tlA3l882DiuIlakF8CqRcR9Z/QGZKF2bHtlzyq29co+iFAO+BD
	BpiuWUaYFOjtVFVBAE7ghVljkyVJdZ8IEHop8ce2JWRC3s4Ri6zlUfFaxcNJq8hy
	V5VquVAOzvXmlvowhEg7du8wWPrmU3bXAwA==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id YKeRB8iyMblo; Mon,  9 Sep 2024 23:11:49 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4X2jJh57NZz6ClbFf;
	Mon,  9 Sep 2024 23:11:48 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 0/4] Improve the UFS driver link hibernation code
Date: Mon,  9 Sep 2024 16:11:18 -0700
Message-ID: <20240909231139.2367576-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Hi Martin,

UFS controllers can behave as follows with regard to link hibernation:
(a) The UIC completion interrupt is not generated after having submitted =
a power
    management command.
(b) The UIC completion interrupt is generated and reenabling the UIC comp=
letion
    interrupt does not affect the link hibernation state.
(c) The UIC completion interrupt is generated and reenabling the UIC comp=
letion
    interrupt causes the link to exit the link hibernation state.

Support these cases as follows:
 * Support (a) by setting UFSHCD_QUIRK_DISABLE_UIC_INTR_FOR_PWR_CMDS in t=
he
   host controller driver and by disabling UIC completion interrupts befo=
re
   submitting a power management command.
 * Support (b) and (c) by leaving UIC completion interrupts enabled while
   submitting a power management command.

Please consider this patch series for the next merge window.

Thanks,

Bart.

Changes compared to v1 of this patch series:
 - A patch that improves the struct ufs_hba documentation has been added.
 - Patch 2/2 has been split into two patches.
 - Instead of leaving the UIC completion interrupt enabled, disable it if
   UFSHCD_QUIRK_DISABLE_UIC_INTR_FOR_PWR_CMDS has been set.

Bart Van Assche (4):
  scsi: ufs: core: Improve the struct ufs_hba documentation
  scsi: ufs: core: Make ufshcd_uic_cmd_compl() easier to read
  scsi: ufs: core: Always initialize the UIC done completion
  scsi: ufs: core: Change the approach for power change UIC commands

 drivers/ufs/core/ufshcd.c       | 47 ++++++++++++++++++++-------------
 drivers/ufs/host/ufs-mediatek.c |  1 +
 drivers/ufs/host/ufs-qcom.c     |  2 ++
 include/ufs/ufshcd.h            | 13 ++++++---
 4 files changed, 41 insertions(+), 22 deletions(-)

