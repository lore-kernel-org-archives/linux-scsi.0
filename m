Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 110223A782B
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 18:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790361074; cv=none; b=JsZ6PFUeKXkWpbzUy33k2MaOM3W063kFXUrq8lT8rBrIY7sg2Xz+DHC7+6XAU/WtHn9odCXeP9q+vSDP7gJD9FcpbsNw8xjihUx0uMXhaIbl7lzr+dMZMtggll2Zd5mEk8cEM26eGHeEHB6qjxrf19TTehUGQD8uBiRFHhfWv7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790361074; c=relaxed/simple;
	bh=cbcqL4QI+no/ZvQ/XpchMGVdbNtQdDoE/vHVIlB9tvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WF/DZ+P2Yu00J0WxRVmjqMtCmHTwS5MLzvh2IZXdObq71O7tp+MqbF4fymYCx/CyBk3qnYyiblACPe5TDv/xUqixu7ZXrTYIDwjiZo54EPTqqG8Syc/e6NCcR+IhkWFKf593kxVeAThvXhxgu8QIO/rMbZOZA5taOCncGAlDRvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=xsybtxuZ; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="xsybtxuZ"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hrzmc5pPJz1XM30h;
	Fri, 25 Sep 2026 18:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1790361069; x=1792953070; bh=32TSW
	CbHjiskeo0J6OtY7X7eOhcxxx0DKaL+PCFqP+0=; b=xsybtxuZ1ySYrzeFc1RZD
	QI1r7EXfd0Xydzc4ymBAkMjWFi6NHumv6iRaedrL4y89NH3HeLamUQxwce2Eln1V
	HCE0l96058Z4Ha7EcAzw/vmieiB+TBPz+nlQWtn2ooQCXUXNL9UBmCLe2F4ZHgo2
	Rg1EmNE/SMCn/Vpv0fb7rS38AFeYvApw5hyF5dH3hEeM/Mp2haqec2XrnWJBXh6Q
	bXcpR4JFH3IM+ZzslGxfnwSSemI8FysarWLSLvA+q8HCj2Zlge1yd1Z6XMhApkZx
	jTRbQPnHSnnUQTRWLiT+jDQniDSCOd+knOZb9Yu5nTZPmRfQrS3FcI8V2oGLLmMl
	w==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id CECyv5oGX1-3; Fri, 25 Sep 2026 18:31:09 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hrzmX17RLz1XM5kt;
	Fri, 25 Sep 2026 18:31:07 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Subject: [PATCH v4 23/54] scsi: esas2r: Enable lock context analysis
Date: Fri, 25 Sep 2026 11:26:01 -0700
Message-ID: <fb1299e4a889b89e9e47b4aff913393a266d0198.1790360262.git.bvanassche@acm.org>
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
 drivers/scsi/esas2r/Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/esas2r/Makefile b/drivers/scsi/esas2r/Makefile
index 279d9cb3ca69..325fa0e634fa 100644
--- a/drivers/scsi/esas2r/Makefile
+++ b/drivers/scsi/esas2r/Makefile
@@ -1,4 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
+
+CONTEXT_ANALYSIS :=3D y
+
 obj-$(CONFIG_SCSI_ESAS2R)	+=3D esas2r.o
=20
 esas2r-objs :=3D esas2r_log.o esas2r_disc.o esas2r_flash.o esas2r_init.o=
 \
