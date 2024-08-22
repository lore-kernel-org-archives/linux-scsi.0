Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B34F14B964
	for <linux-scsi@vger.kernel.org>; Thu, 22 Aug 2024 21:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724362613; cv=none; b=JBHipj49YOIXPld0krPNU5A2S9WXqSRLQ735R1pwpKOKN4vgzQfTMm0huulvpxFJLsKb/sEJIK45zdg6M2GQFB3OcgZBw4PVDHb2a+yONIBH6wzXfv3jSKl7HlmaDdvp5z45avy+Jd/51tZQlcJCRfvVId+uJWY0fU5f+1lu5XY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724362613; c=relaxed/simple;
	bh=sbxZ6hzX6G89KBlDVEKSP+2jIKwJBjL9FNTyocDelPg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=d7+mystfjYm3HQpHhGebdWOgxphup6laoZnrRtLGNjV6vO1+1fOYX2MTxHPNxygo1CyvteLwdhGEMpnSx5EbcxMIPOVCb7l0cqMnx7ZkOLXYIXHalzrbE42+/38QN1lRDzc4gsg7d84oToOh/Q1OhUU8e8xy7+kuNdbCzXBySyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=QoZ9eJzZ; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="QoZ9eJzZ"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4Wqc3R4BxDzlgVnf;
	Thu, 22 Aug 2024 21:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1724362610; x=1726954611; bh=bkZJJabxwVyS2Gk63XkaHzs6KQrs2AXA0j/
	+ASmg7wU=; b=QoZ9eJzZn6uE1kP/KUfjJr+R4mhckREA7iz/BrUO8DBttsb6dIt
	+WyUVyV7E+SDvn/E/NHPr68kUSur++UZVlxoFdcKiHVpLsl92BwOqlLGwf24xHzp
	yhzpBWgmtkFPY9LcPZ74ueQvpmIYNRbXA28z3H900JtyP5T6flClPlOaKRty27bG
	yWuFUCfrJ4MrWrJ5OPWO9BZWe2QKvimNz/Le7r4D29dUtNr8yKOoTFc8oeYbSh8c
	hcSGDBdDpQ4smXT35qHQQrcUYlWrDBkA0KDV1S0LUVI0yd9aYue2zN6ExZ0Q5Ros
	KzVadlgwVnIooa3gVM8gSjwCy5Cn9AwDC0g==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id vRDbDN_azOzW; Thu, 22 Aug 2024 21:36:50 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Wqc3Q0Q5NzlgVnK;
	Thu, 22 Aug 2024 21:36:49 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 0/9] Simplify the UFS driver initialization code
Date: Thu, 22 Aug 2024 14:36:01 -0700
Message-ID: <20240822213645.1125016-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.46.0.295.g3b9ea8a38a-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Hi Martin,

This patch series addresses the following issues in the UFS driver
initialization code:
* The legacy and MCQ scsi_add_host() calls occur in different functions. =
This
  patch series reduces the number of scsi_add_host() calls from two to on=
e.
* Two functions have a boolean 'init_dev_params' argument. This patch ser=
ies
  removes that argument from both functions by splitting functions and by
  pushing some function calls from caller into callee.

Please consider this patch series for the next merge window.

Thanks,

Bart.

Changes compared to v1:
 - Fixed a compiler warning reported by the kernel build robot.
 - Improved patch descriptions.

Bart Van Assche (9):
  ufs: core: Introduce ufshcd_add_scsi_host()
  ufs: core: Introduce ufshcd_activate_link()
  ufs: core: Introduce ufshcd_post_device_init()
  ufs: core: Call ufshcd_add_scsi_host() later
  ufs: core: Move the ufshcd_device_init() call
  ufs: core: Move the ufshcd_device_init(hba, true) call
  ufs: core: Expand the ufshcd_device_init(hba, true) call
  ufs: core: Move the MCQ scsi_add_host() call
  ufs: core: Remove the second argument of ufshcd_device_init()

 drivers/ufs/core/ufshcd.c | 269 ++++++++++++++++++++++----------------
 1 file changed, 154 insertions(+), 115 deletions(-)

