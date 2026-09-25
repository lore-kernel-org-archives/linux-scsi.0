Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55D2C3D79E9
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 18:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790361171; cv=none; b=DAGKY8Ma/LJ7ubkbWQwzecJXsFTZQbnNDD/uOIxdnxc73TW313fxQfYH77sVKIJF9CbnR4ysSZ+sgejg1G8JogXJRjf7rtXpfLPqYt5yzOdrZY5VtyMSBks7fCRQcpRaCezSKb7x7avGHCBs8EmxeXwCe6wvcGK2ZH6gW3lZ6WI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790361171; c=relaxed/simple;
	bh=mnMsN9029eYqZeaQU162Wa8kx7blIxbw/zG1pl14J3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wyah4QsC6dPudKozD+M6Car7KWdOJI/arhAj2AENMOF66Cs2m6IEboUrzGbbaR3gbrbfiKc8l9c4n9WUade3AOfh7E7D/r1Wm4XWQogFLA6+S5ZRa2MgGlDmVOt226fBS1A+Dg/Ja2MKmPPEc3ggzr58afE53a5GWFAXv80l8sQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=YHBCg8JK; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="YHBCg8JK"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hrzpT0YTsz1XM5kW;
	Fri, 25 Sep 2026 18:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1790361165; x=1792953166; bh=1vk4j
	Gf210R78kyYSnZGs2t7DF7maJC+x8hnNV+29lk=; b=YHBCg8JKYDh18TJe0Cegs
	DNUEtgsiR1WRwuQHz91m6sDJ77TWzJYZWae1fiYIoUTk1V8N4yOtfEp1Vn2m8Hki
	c2FXNhTEdj5kbLhlogZV+ZjWmNkDMnUKFK06fP4MhOr6Bx7NE6eKeBie9CkThZ6l
	6Z2rfbmK77WpzTkwUqYhtAUUFazBoDHVKP9XOq5qr3N1/FI5h5C2BhP0kGIdL/3Y
	lFKfMS4UHTRJs4FzxeaeJR++1Y3Wxr8ZtsboHWp5mKTPZ0+RWG+CO4EW24mDSUjO
	QfI3z7MqDmEANm5R7sieTkbKqAQcV6BAxj7M39V/CDZvm6RPitH4he4RV51MV1Cg
	g==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id I2-Vawlpj6_U; Fri, 25 Sep 2026 18:32:45 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hrzpK6tBcz1XM5kt;
	Fri, 25 Sep 2026 18:32:41 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Saurav Kashyap <skashyap@marvell.com>,
	Javed Hasan <jhasan@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Subject: [PATCH v4 44/54] scsi: qedf: Enable lock context analysis
Date: Fri, 25 Sep 2026 11:26:22 -0700
Message-ID: <a85d74900f96562d7ecc34cd6b16dd4b2f642d57.1790360262.git.bvanassche@acm.org>
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
 drivers/scsi/qedf/Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/qedf/Makefile b/drivers/scsi/qedf/Makefile
index c46287826fb8..465982ba5dae 100644
--- a/drivers/scsi/qedf/Makefile
+++ b/drivers/scsi/qedf/Makefile
@@ -1,4 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
+
+CONTEXT_ANALYSIS :=3D y
+
 obj-$(CONFIG_QEDF) :=3D qedf.o
 qedf-y =3D qedf_dbg.o qedf_main.o qedf_io.o qedf_fip.o \
 	 qedf_attr.o qedf_els.o drv_scsi_fw_funcs.o drv_fcoe_fw_funcs.o
