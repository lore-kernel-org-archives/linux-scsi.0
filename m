Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D67844D688
	for <linux-scsi@vger.kernel.org>; Thu, 30 Apr 2026 18:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777573349; cv=none; b=rjJ1cmpVELGQ0fnDaUJM6QRhSv7fHTt5onqBmYz7UB0Q4u1miF/nYguDePS/VdPShp7tovNBg2QvylAIOt3aGU9ZKczH7NtfdrnpzE6aI33GCErScCkTynTjKebNQbKnP3BFtCKG9RL19HXbluAoXRMQ1ZsL95Il0iUjO25t/hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777573349; c=relaxed/simple;
	bh=vVHxKg/CcHvIDsO2xzGwGN5dyt7ejLDBb/8mLOkUXrs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rQYg2gxyAoCRH0QiJpOkXqdfA8wegEzb0f9dlemZBiosVV2X4wFB9bLudIdHV3/8YlbTdB74BNSnKwPMxufzlh9y9scYRNBAKWgfwRxcPZkmzgXRXUhUqskHGugxKXheWi6/yICHAPeGVA9L0eNaZB70XKC4l+BlRWoHvGj10xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=YQ8MJpA5; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="YQ8MJpA5"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4g62Zr212QzlfdfN;
	Thu, 30 Apr 2026 18:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1777573345; x=1780165346; bh=vVHxK
	g/CcHvIDsO2xzGwGN5dyt7ejLDBb/8mLOkUXrs=; b=YQ8MJpA5NKgwxIvcxKuc4
	5KvF3vkgY0htIiD0xMuvxcsCAfgllUqI7WXsAm1ty+Jnn+Ht2+RTqXKuxJcjWJNJ
	CaWvFm3wXeEPHroJiqVzoQ/ea4IXY+xAllX84dX2dqfTiwVB6xSvO0+Qgss5xC+6
	qnl2u7bmSrWoAjcuB0KQEICPltkY7CPIntjY2T6W6pAHPfg1n2w5O4FNmUt3byIR
	psyKySlPcgtoooH1nn71Qw7V2MuO0fO+d8C45RCrWNiJcU9uUUbxqDeveWbPmR/z
	IM3eMaaUrt5NxdnXnYVXSIV9pEMP00FRYrORY41VWP0dDzlS9/2H9PUnfu5m8jSG
	w==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id TTTdFzkvYuaz; Thu, 30 Apr 2026 18:22:25 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4g62Zm4rMvzlfftl;
	Thu, 30 Apr 2026 18:22:24 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Marco Elver <elver@google.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v2 12/56] scsi: aic94xx: Enable lock context analysis
Date: Thu, 30 Apr 2026 11:19:42 -0700
Message-ID: <20260430182130.1978347-13-bvanassche@acm.org>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
In-Reply-To: <20260430182130.1978347-1-bvanassche@acm.org>
References: <20260430182130.1978347-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/aic94xx/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/aic94xx/Makefile b/drivers/scsi/aic94xx/Makefil=
e
index db9fbe3a8e4c..4ab04ce6edf2 100644
--- a/drivers/scsi/aic94xx/Makefile
+++ b/drivers/scsi/aic94xx/Makefile
@@ -6,6 +6,8 @@
 # Copyright (C) 2005 Luben Tuikov <luben_tuikov@adaptec.com>
 #
=20
+CONTEXT_ANALYSIS :=3D y
+
 ccflags-$(CONFIG_AIC94XX_DEBUG) :=3D -DASD_DEBUG -DASD_ENTER_EXIT
=20
 obj-$(CONFIG_SCSI_AIC94XX) +=3D aic94xx.o
