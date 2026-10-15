Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AB3B370D7B
	for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2026 23:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792107028; cv=none; b=cKcKW4wdcjVexIuA98LmdL6VNr7TDBbxm1CZxm3bYbRacWsHuMEXsmyUrnRVVl2W42Ygoos2qtfMsmlNZCqRi4kgzWpFmN4BIirJFNvVj1mxtvXgyows0qbtG+qHg1deFo4hWrfkToFR75/JMvcTh7wn10+hc54emc90S0yj6Vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792107028; c=relaxed/simple;
	bh=ghmwD4QXcqiMM7TeTloGJN8CvpelhLXajaS7zTKBXYE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZxgrkY1CXuzvT7v2k1lmABJF5IV/n9Ox5qhrSmBqYoEDXUVWeSGBOJD+yBmdqmO+g8Ffwa1AEcihuXzSczwXnwGu9Q/7ffnz6ASFbsADqbWZEwG2sYMETnnL8ct0iG8PSCbyr79d2U3HTKagygHToZSA1+kxuA/F7lq7kP9lojY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ExbB+2KY; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ExbB+2KY"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4j5PSX2ykJz1XM5kD;
	Thu, 15 Oct 2026 23:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1792107016; x=1794699017; bh=JGmeaGH+TGQuCI5mjQxK2Pp6NHXmx5dNpfs
	5BvOWxWg=; b=ExbB+2KYVDdpOsAP5laq9nL1tBmdQ78Eutv/Kpu4dyIgsh0m6h/
	eGyIEs7HqfR9FAvht+WMuZ/0de2QiE1NBpry4oH9nfo2z+MqQh4abzD4H8DRNmve
	Pm4sG11ZPQoJpS9DfXHhvETpES4u7ovZ6V/zyxLaSNWri9D1rqY5ZqelRozwF6JP
	CudmvO5gryQ5aTqIuFJGoo9Wpz9H3bT1fqeEjuwvHJzmB+0swloM8VuR8FNu0MhH
	lEtjGDITMHym5kNgbOUFB+mSBkFz+cyfiRdALpWQuICUS/6ETonmfBmoEG0rSNAW
	a/0+Wx1yAKKO0VlCEClZf0j5bjX8LgrFgPQ==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 7BpV2QmNCToV; Thu, 15 Oct 2026 23:30:16 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (245.199.118.34.bc.googleusercontent.com [34.118.199.245])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4j5PSS2bn8z1XM4Tl;
	Thu, 15 Oct 2026 23:30:16 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Brian King <brking@us.ibm.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Subject: [PATCH] scsi: ipr: Fix two kernel-doc comments
Date: Thu, 15 Oct 2026 16:30:04 -0700
Message-ID: <64f80584ea0f557accbdc28c0c35d0d4c1db35ae.1792106985.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.56.0.176.g3575e65682-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Commit e2bb4cd08080 added the SCSI host as function argument to multiple
functions but not all kernel-doc comments were updated. Fix this.

Fixes: e2bb4cd08080 ("scsi: ipr: Pass the host pointer directly to severa=
l functions")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ipr.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 665fc54fcbb3..a68ec85a7780 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -5000,7 +5000,8 @@ static int ipr_eh_host_reset(struct scsi_cmnd *cmd)
 /**
  * ipr_device_reset - Reset the device
  * @ioa_cfg:	ioa config struct
- * @res:		resource entry struct
+ * @host:	scsi host struct
+ * @res:	resource entry struct
  *
  * This function issues a device reset to the affected device.
  * If the device is a SCSI device, a LUN reset will be sent
@@ -5043,6 +5044,7 @@ static int ipr_device_reset(struct ipr_ioa_cfg *ioa=
_cfg,
=20
 /**
  * __ipr_eh_dev_reset - Reset the device
+ * @host:	scsi host struct
  * @scsi_cmd:	scsi command struct
  *
  * This function issues a device reset to the affected device.
