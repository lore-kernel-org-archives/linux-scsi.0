Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B16C74D8DA2
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 18:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790361165; cv=none; b=mOnjKl006J0DbFpYzqpIlKbvKUlaIcz8XqxtwpGCefAv5Qjwg0CDj0o5tMZxGW75l90OApf91KjcCaU8Q/nC1BV0/z6rEf+jRQU/ID9SJNdZpZRChowHkXJaOw9RbMgo1nGp4n3r98NjPiXqlm6U/h6svYhquBvEclvUTW5DgWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790361165; c=relaxed/simple;
	bh=rKL7Un/25EVlg8BoZQ3yIJdADOjUgx3f75ypUeGOCgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B2uUSAfGsrpMiPoIVMGliDpZ66Kph/QjbgSa2uq926g14m75daR753o7l6mO1uABj4z4WNIuOZI5uAQy7UhBnJP7QQ1Zu5Y4skA32IedualfZoISGpaRE22NQHmJFTU/Xg7hzlz513E0hnj4OdGE8hk3JVImqDhSa+cGTBlxj20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=KuTZ88Yi; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="KuTZ88Yi"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hrzpK49Qxz1XM4Sx;
	Fri, 25 Sep 2026 18:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1790361158; x=1792953159; bh=+T9qp
	0MI3Op598YBfIGU6wwUsIu/3chuKe4V8rg3h1Y=; b=KuTZ88YiheV63DV+YVB0I
	bjh/NGe4PKWBUW3hdAKulBRD4OLbxuea2U1lqxTjGvBsWs3O1CW78pKa+K7Qix/E
	I3QvaPuX/W8FIgqgrSqf1IPRnvejt1RVkQ1G2cbZPrhVHQ8FJf+ZUHojG1TdnYO6
	dlQLg7Vn+2IDNkZcUboHlLPDygfDQc1p0oOVGmWwubsmrDZ5ImMStV3woRfO4W22
	b7Eyxan/SlsmK4kwhzn9XoL5wH0LJBSAbFIsLAFLoTdXycRuqkBJOLVvsM+BJ+d2
	yIKrkRCKnG87wTkCIz0Bt9LfSoIb72cecwqnYpSEvSEgxj9PZ++ofKWEn3q9w3Jj
	w==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id a4Ptr1joXObh; Fri, 25 Sep 2026 18:32:38 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hrzpD6kCsz1XM5kt;
	Fri, 25 Sep 2026 18:32:36 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Subject: [PATCH v4 42/54] scsi: pcmcia: Enable lock context analysis
Date: Fri, 25 Sep 2026 11:26:20 -0700
Message-ID: <a6c7c5f042af4d8504c29e7fc0c6f84be2c0f153.1790360262.git.bvanassche@acm.org>
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
 drivers/scsi/pcmcia/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/pcmcia/Makefile b/drivers/scsi/pcmcia/Makefile
index 02f5b44a2685..06ea2bfcd42a 100644
--- a/drivers/scsi/pcmcia/Makefile
+++ b/drivers/scsi/pcmcia/Makefile
@@ -1,5 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
=20
+CONTEXT_ANALYSIS :=3D y
+
 ccflags-y		:=3D -I $(srctree)/drivers/scsi
=20
 # 16-bit client drivers
