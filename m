Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E276437D1A5
	for <linux-scsi@vger.kernel.org>; Wed,  7 Jan 2026 17:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767808097; cv=none; b=MNILaR3g1Cel/hCC+0cq2GrzuEJNrZL71E3711MSAxoPNPSBv1HN/5FBkbf4aJAF8T77EhyFXc0sI8PUO39Yq2sXMdkAwTYivu8GpFVohK/1zOusmMzfKg5V5+dWgdboEhoWzluUR4/1WMAkzVukORNSoieAfGcOvRuRz4NqelU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767808097; c=relaxed/simple;
	bh=nnhh/P6OY/c6vEecAK0uAxCU31gPShhMfZiIomlh7JE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lL+ocXjfiFyJ9OoISflTZrkhIknovGJcWcrGsXW5MM0EvcO/8+yaFynT0ECeeH6wLy5L8QBTgXLOJSffQd3H/4YoPkvMvJLy+wfQfn2LhXwcHO1FxR8R959QYi7LRcNM9O+cI3hwsogw3t1bennsauzOsCuebzZBLuTbbpjkSrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=lXczur9s; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="lXczur9s"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4dmb9L0fM4zlkSBG;
	Wed,  7 Jan 2026 17:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1767808084; x=1770400085; bh=eprGaQODeuOAksTzB/ZzqzPvlbfojdRS9yx
	0+iaqtJs=; b=lXczur9sZ2hSoHiuPyGYh+9ENxtGPqVi5tyUfh4ARr6K1XxjGkU
	TbKcB5G15Z1YgVLiRxq/T5UkQAVc6xdkMGWTaPJvhebi6rbUPGbyGxbfQDoflDwO
	98vG/AzJAOWdnn5Hl5yX8JPpDifMUpKh8TBaQ0WXhFAoAEblb2GbNzKzCrun/vuP
	K9JU74bUtqV6ylnePza1damPPWg42zUBfq5y3NuUrR2wFWkNK1cURfepCzfpNx/n
	c2r+Mzaj6vbYS5Rxo6WuZ6sBqNT9gn0Jwb92uOfgYzFzkiP3mZwZwx0JxQ9cQhSe
	djOoyDBruSfyrpOfG1PGCw+AHQDdxSS9e1w==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id L8eQbw3bljip; Wed,  7 Jan 2026 17:48:04 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4dmb9J1j6qzlkMXy;
	Wed,  7 Jan 2026 17:48:03 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	John Garry <john.g.garry@oracle.com>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 0/2] Call scsi_host_busy() after the SCSI host has been added
Date: Wed,  7 Jan 2026 09:47:49 -0800
Message-ID: <20260107174753.3089238-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Hi Martin,

The UFS driver is the only SCSI driver I know of that may call scsi_host_=
busy()
before the SCSI host has been added. Hence this patch series that modifie=
s the
UFS driver such that scsi_host_busy() is only called after the SCSI host =
has
been added. Additionally, commit a0b7780602b1 ("scsi: core: Fix a regress=
ion
triggered by scsi_host_busy()") is reverted because all scsi_host_busy() =
calls
now happen after the corresponding SCSI host has been added.

Please consider this patch series for the next merge window.

Thanks,

Bart.

Bart Van Assche (2):
  ufs: core: Only call scsi_host_busy() after the SCSI host has been
    added
  scsi: core: Revert "Fix a regression triggered by scsi_host_busy()"

 drivers/scsi/hosts.c      | 6 +++---
 drivers/ufs/core/ufshcd.c | 6 ++++--
 2 files changed, 7 insertions(+), 5 deletions(-)

