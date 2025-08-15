Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDB50288C06
	for <linux-scsi@vger.kernel.org>; Fri, 15 Aug 2025 15:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755273538; cv=none; b=RlxuQUopxdUlupa3U6kYoK7s3lClu5SO0jH+m7TjbFx5f9cSWzdlmvGkTatofdOlPfyZg/wMpv9xOSmwMMy2y3AUO7B/mxzWYFE5kSGk1toK4sDcuHpK6zeGMwuFB5GnfrD+ipDFsLJbALh3VOKKPeOpKaOFTlo3hYMYpF3OVI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755273538; c=relaxed/simple;
	bh=ySQ2sCb8lK8neUtqoFV2z4RATN9UqQze5yAmH9uMEIk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ZWHtT9y0/Uiio6XoIWwl7WGhuy+mAQQkUf2ch/316KBT/jJ74mDhmyaM4B2G/IrZ/QfX4FetyyrCv3kcwRfGaSBPnUCprhkoCQqnpW5/os5r9rVHTZnrepyeSFwsq0YRlK0RlrtwVaQdV2CGe56Qy5xed8h/XYocSG/SxsqVunE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=keGcJZlW; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="keGcJZlW"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4c3RcJ01b0zlgqVS;
	Fri, 15 Aug 2025 15:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:mime-version
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1755273534; x=1757865535; bh=diU/U
	HPAVOLYOeue+KfMNEHHdm36Y9V7oXa7dD89+4Y=; b=keGcJZlWLCaeJVC7BrMaf
	VFvIKQrKr5ZsZ5xWnuxXuIqv+6XQ2XMa726G5O3EFhUIlYkyqUWoOrCNhsS//rtT
	nH3eas3sf/ivxsVEr2v+Tf8/PkqEWaAvk/JlGpdjE+6BJ9+0wujF4Q5LfkcQBV5k
	HS+DXryVjH2Mw8mgicNTWyJB2ZYh39Kfdtmxuk3xLV9WSeDa0Q0O/Z1SiRByLlEB
	53AoLcoHntimxFI/3RL0srk+IMFjiLFisWzhcyJfbWE4Hw10uMW8cHasd4HsxJuL
	SC+tRzmR1MIwF87+5Exq8bVhTIphOJ5XBG98C0m8FmM4IP1nHT/9hjXbKX+algn5
	g==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ZWQJWUW0dmVO; Fri, 15 Aug 2025 15:58:54 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4c3RcF23bdzlgrtT;
	Fri, 15 Aug 2025 15:58:52 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v3 0/4] UFS driver bug fixes
Date: Fri, 15 Aug 2025 08:58:22 -0700
Message-ID: <20250815155842.472867-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.rc1.163.g2494970778-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Martin,

This patch series includes three bug fixes and one rename patch for the U=
FS
driver. Please consider this patch series for the next merge window.

Thanks,

Bart.

Changes compared to v2:
 - Reposted this series because not all v2 patches made it to the mailing=
 list.

Changes compared to v1:
 - Improved the return value documentation further.

Bart Van Assche (4):
  ufs: core: Fix IRQ lock inversion for the SCSI host lock
  ufs: core: Remove WARN_ON_ONCE() call from ufshcd_uic_cmd_compl()
  ufs: core: Fix the return value documentation
  ufs: core: Rename ufshcd_wait_for_doorbell_clr()

 drivers/ufs/core/ufshcd.c | 76 ++++++++++++++++++++++-----------------
 1 file changed, 44 insertions(+), 32 deletions(-)

