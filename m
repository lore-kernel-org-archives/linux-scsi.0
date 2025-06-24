Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84E4222A807
	for <linux-scsi@vger.kernel.org>; Tue, 24 Jun 2025 21:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750799171; cv=none; b=Xd0Sa9CW8zYfEnkttrWI/xKRIgRO+a158DR/OkRqNqT8AzhpuKUmHOS7PzpbUmVATOwrhJkbuz2iCgi01ws5mXwO2yoBalWND0Nfy+P7AYvZmdawPNBXjTFzkD6CvaECwCU2twf7/T0YeorVKFsJV59elT4v6gJj5dFmizQgh+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750799171; c=relaxed/simple;
	bh=VaATysvULF+NH4C+9ka0oCuDy1j0Gnjo+mtU9ivOgXs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TuDfkbA9UjTlTeVVlDeuBuI7W+vptki2rXb0BRrie0cDPb5DXJ47+cxY2KsXU90LjU5S5EZRjW52Yo8XzszUxa7nFAyn6nHHb3XBONFPdbjRQ0vV63ilgXyk6a6bLAd13dxJRtY33JwpJhtGd4cBzLfEk8P69LR1CvAqhyKePWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=lUEOEyLl; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="lUEOEyLl"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4bRctm2QyFzm0yQ7;
	Tue, 24 Jun 2025 21:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1750799167; x=1753391168; bh=rAUk8zUzP8HIPcnbIK3mp7Yu1hhwglWRD+8
	KGaha02c=; b=lUEOEyLl62LlhCM2T3IpTxMgJtJWIEmY0u9aGiImdXgDVl2S+Bc
	rDGoPl6sUCYXi/ee74iYqhnWGccO/FY/lGygDJiSSAcJn2EtQRgtyCZtmNOg58by
	Hjnsb2JN9PJ/MlCfYTM7EN4Ip3bWnuNLm4qfnjMLoevET8MjgcbeR3keBrFwYiOi
	mEK+1xVMtf1WIx8al0mTPWuThO0qvJs0weoxqO13Z01quxRKe7J6bC3Xi+sHkbuf
	bZVRZDrXRhS5H6G54+ttBlAUkPtrtRB0SRbAoJLg63UVOueKNeEinuStfYHKxybU
	WEk65hzKfYknBuqbJOLllQrnPBzDpUyR4Xg==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id D6uh3Qi8TYzH; Tue, 24 Jun 2025 21:06:07 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4bRcth71b6zm0ySk;
	Tue, 24 Jun 2025 21:06:03 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 0/3] Improve const and reserved command handling
Date: Tue, 24 Jun 2025 14:05:37 -0700
Message-ID: <20250624210541.512910-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.50.0.714.g196bf9f422-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Hi Martin,

This patch series includes three cleanup patches for the SCSI core that d=
o not
modify any functionality. Please consider these patches for the next merg=
e
window.

Thanks,

Bart.

Bart Van Assche (3):
  scsi: core: Make scsi_cmd_to_rq() accept const arguments
  scsi: core: Make scsi_cmd_priv() accept const arguments
  scsi: core: Use scsi_cmd_priv() instead of open-coding it

 drivers/scsi/scsi_lib.c     |  2 +-
 drivers/scsi/scsi_logging.c | 10 +++++-----
 include/scsi/scsi_cmnd.h    | 17 +++++++++--------
 3 files changed, 15 insertions(+), 14 deletions(-)

