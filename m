Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E561F3A782B
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 18:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790361100; cv=none; b=BRVtJhz5ToF69npWPwdkpCFPSeaM/V1Qyi3RUmUA/v6cE8gwIl4M5JAbdfvdI3Y1Uc72Yp59A43P4AlcZKavpHGA2WG5G6opQ+ruFRFh3F9vP+WnreqeDO2bhbLE8au4VjIURCbEToFbxDN8FII+EdZEA3eb/107N/EPTWxuBaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790361100; c=relaxed/simple;
	bh=S8s9Evt9q6E9ThD59drqkw4KAmBOa9WrUWu/y3I8FGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AKyXJ3DUJwEsID1jPWTZxPM11mAv7gyryZfQK2p4CzB1m0g3GzHP7cIAs57F/8cvxpPiz5y3+j9PfrPQRpSmpRb5+VhNS1h/6wLgk9QXzMlkl/q08UVRrF58fyMSBQTy8GUZe1hY3lhe4aW6RFB7anpwdeEjZjLxhT/3JGkpMy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=osP1XQn7; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="osP1XQn7"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hrzn63BMwz1XM30h;
	Fri, 25 Sep 2026 18:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1790361095; x=1792953096; bh=RVmcU
	AOb7A/6iFXQs8RCS0FKx9GP3tYcdj9zAlZo2Zc=; b=osP1XQn7qaAPQF441H/vH
	HI1ITYHI6TR8Y0h/BtnWGr7c1ofGavMQTLTp2KgmqBvRxmYfzy3lZD6NS7Ic6z4j
	hJQ/QWKqWAj3RoZCYhYZ/1gKmlE6HAW1IF+CjUSGrPAcobWZZa2eMUfTuGYBJTBP
	ew7WDisb4Bqy5Sdn4Vg1ik7GcVf6o9qOtOsIBvh3ZShwvcoYHb8CzsAL+aaX0DxK
	knICyVT7AuGJSf7y7xHVltzgrUG+srxaXXFCQzsymSnv8iBDF48oOvRhWzgaLt3D
	OA0ZpcaZv0XzR66KY55XcoQRuV22wQA6uTdcPjkPsgGdDBKuc0y1o1Wav7G0BM1S
	Q==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id nlw0bxu1p0DP; Fri, 25 Sep 2026 18:31:35 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hrzmy1pkbz1XM5kW;
	Fri, 25 Sep 2026 18:31:29 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Subject: [PATCH v4 29/54] scsi: ibmvscsi: Enable lock context analysis
Date: Fri, 25 Sep 2026 11:26:07 -0700
Message-ID: <9651d7f88d22a9ebce8a8198f53338ad14164b88.1790360262.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
In-Reply-To: <cover.1790360262.git.bvanassche@acm.org>
References: <cover.1790360262.git.bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ibmvscsi/Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/ibmvscsi/Makefile b/drivers/scsi/ibmvscsi/Makef=
ile
index 9408c7f4cdee..de6ed9e64b63 100644
--- a/drivers/scsi/ibmvscsi/Makefile
+++ b/drivers/scsi/ibmvscsi/Makefile
@@ -1,4 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
+
+CONTEXT_ANALYSIS :=3D y
+
 ibmvfc-objs :=3D ibmvfc-core.o ibmvfc-nvme.o
=20
 obj-$(CONFIG_SCSI_IBMVSCSI)	+=3D ibmvscsi.o
