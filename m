Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62A5E395AF0
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 18:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790361185; cv=none; b=UTeK+X3PJeXEGIYKpw34QlqW9iOl2qLqZCsEKSG7m8Aw7kCMTnikxaijVddCB9twrd4eOq+EJ9Ha6f/RmDJ4MYO/+ECkSW9myqC3uHcNoPsCmHZash0IgH10VL1eL0DFfbr5K5xG29afbiDzD5pxpVKP66dHFLk6vpX5hunDDhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790361185; c=relaxed/simple;
	bh=57ICqdF20/CbIGt8ZXZWBh7rIN8i9fbmUF48Dm2iQl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JCotH+033oYXFdw490mS5BqmBSTY+yvCwT8Z9Nly5D5SAgNC/daAZQYzJvw2ncM3lYZbUYfmZxh7J8fAD4+vMASzHA9eDdsKCVE9ln6fdpunNzfXgpgS+ujc9cZdBIXqyFngrls56/HCsvWEhFKM+ZuP5hqQ3ggsU5n7LEpFrgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=lsanPc5q; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="lsanPc5q"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hrzpl6tg8z1XM30h;
	Fri, 25 Sep 2026 18:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1790361179; x=1792953180; bh=alGJp
	CGqJBCBTJUkbVc8/IyIM92o7aHtKCZrQMVcPQE=; b=lsanPc5qV8A+4tG7Vq4OA
	CzSChCfPmCeR9S1CahhZGZgKrKfWbmGgQ/XOugqLinZ3pwZc5KdGzknK70oZuzyD
	NizNl92/7LOq/vfrZiNiW3IQVaeYvE6TqTf+8d3HmhrcS0hDRI7pz4p6oqBQylZX
	3GZPFpTB5fMLkBj63kkTIUZi9OevSM/WrvCyo6O+2kDcZURG7Suo4mxkiuvBXmk+
	UUU8LEsFKAfTI8FiXUuBK5jEgNJ2wfHY69mVRPI7hbS0IYaZ2cRAS2fWH5ENma0y
	Y+kNSJ8tpgTgJM3aDZclNVHHGuMMz25i/bEUIECeeAYiv4iptVvgp681p7f/oJ+R
	A==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Wuv-jHFdubjE; Fri, 25 Sep 2026 18:32:59 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hrzpc5dm1z1XM5kt;
	Fri, 25 Sep 2026 18:32:56 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Nilesh Javali <njavali@marvell.com>,
	Manish Rangankar <mrangankar@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Subject: [PATCH v4 49/54] scsi: qla4xxx: Enable lock context analysis
Date: Fri, 25 Sep 2026 11:26:27 -0700
Message-ID: <1136d8587d266c50935680d246161def1c760f05.1790360262.git.bvanassche@acm.org>
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

Annotate the functions that perform conditional locking with
__context_unsafe().

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla4xxx/Makefile | 3 +++
 drivers/scsi/qla4xxx/ql4_nx.c | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/drivers/scsi/qla4xxx/Makefile b/drivers/scsi/qla4xxx/Makefil=
e
index 1f8a9096c744..2178d139f3ca 100644
--- a/drivers/scsi/qla4xxx/Makefile
+++ b/drivers/scsi/qla4xxx/Makefile
@@ -1,4 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
+
+CONTEXT_ANALYSIS :=3D y
+
 qla4xxx-y :=3D ql4_os.o ql4_init.o ql4_mbx.o ql4_iocb.o ql4_isr.o \
 		ql4_nx.o ql4_nvram.o ql4_dbg.o ql4_attr.o ql4_bsg.o ql4_83xx.o
=20
diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_nx.=
c
index f7340cfc990a..6aeb8097a73d 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.c
+++ b/drivers/scsi/qla4xxx/ql4_nx.c
@@ -406,6 +406,7 @@ void qla4_82xx_crb_win_unlock(struct scsi_qla_host *h=
a)
=20
 void
 qla4_82xx_wr_32(struct scsi_qla_host *ha, ulong off, u32 data)
+	__context_unsafe(/*conditional locking*/)
 {
 	unsigned long flags =3D 0;
 	int rv;
@@ -429,6 +430,7 @@ qla4_82xx_wr_32(struct scsi_qla_host *ha, ulong off, =
u32 data)
 }
=20
 uint32_t qla4_82xx_rd_32(struct scsi_qla_host *ha, ulong off)
+	__context_unsafe(/*conditional locking*/)
 {
 	unsigned long flags =3D 0;
 	int rv;
