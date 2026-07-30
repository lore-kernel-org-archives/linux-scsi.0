Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D8243D5221
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 22:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785451742; cv=none; b=acNKqVDi4PG/XKEQUiU30ZCTa94tuAYQeaTqeigbgUiwuSKfc0MPAsfHJ6HYVj1wR5FiaO1oSU56nxkLig51D1YLsl2KWO4k+Q4KmxJFlsbVh+Bxch8Lp9Gcj6Sc/NfBtcS+/Ugzi1VC0q1Erp/EbPYoNA1C1QGnsfJ+DPviH80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785451742; c=relaxed/simple;
	bh=mnMsN9029eYqZeaQU162Wa8kx7blIxbw/zG1pl14J3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TmGjMnPk1Gdg2z3ukmC55AUSEDg/8cbUeC/D+/vuwDpgUz8SPG4wk5CtRQltFf6LN1uQdesBV/gBdN5BY6aKUYjCYb8sJ9yjNa1D+pIZfk0HKsouHhdlSS4uyLi9bIHImQUJH48vTu0MM6CjBT08rprpSniRVumXUUQGrMKumFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=wviCfOaH; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="wviCfOaH"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hB4BN71FMz1XM30r;
	Thu, 30 Jul 2026 22:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1785451737; x=1788043738; bh=1vk4j
	Gf210R78kyYSnZGs2t7DF7maJC+x8hnNV+29lk=; b=wviCfOaHsQY9eTbyQ3yt+
	vUtngiicd0PBjt2y1KxSF+F7yv0dse4OiVge1X1tmG01TSv0kEYr1F9P54fgapei
	Fl5FTenhBlH2pbtR72Uq38LZsF7mCpYQeR3eN2841IHREcfiU4ehwwOcA66KwT8t
	waN6E5+Eu6kWBPq6qvyRYilAi39WJUoAOah6ieItDoHtEVsY0QMS/1U9bbtuGkha
	4Bf4FGItdSIHv825HXTgIZ3/XRVYgXfXGpV+rZnFtCsfqzbrLZCZhpQpjlYh8jbq
	/RLCNPvdyNK+IOET0dThwwkZI1XprSpBJ7czyH+4Kra3F4EpJC1E0CcHHrh042xx
	w==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id qkLVAfzDWw0p; Thu, 30 Jul 2026 22:48:57 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hB4BH1rNRz1XM6Jm;
	Thu, 30 Jul 2026 22:48:54 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Marco Elver <elver@google.com>,
	linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Saurav Kashyap <skashyap@marvell.com>,
	Javed Hasan <jhasan@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v3 45/57] scsi: qedf: Enable lock context analysis
Date: Thu, 30 Jul 2026 15:45:28 -0700
Message-ID: <59fcc3d0f7ed8e8555b959f01f95f934ffddf421.1785451174.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
In-Reply-To: <cover.1785451174.git.bvanassche@acm.org>
References: <cover.1785451174.git.bvanassche@acm.org>
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
