Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B95033CAE80
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 22:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785451751; cv=none; b=eYzTCtatsY0EHwvt4sNd8iOCbKUL/u8fHyv4U0D3VMa04d7VyuSdZGdHBFuDtXScUPVqtKJpO9B2oACMviZT1gQl4jq1BydhirS14fhOdbdHWNFUG3wDxXdxrIOfAduVPQ31m/+e6cZCINCBPuKWmhZMrAQUYho2rGMO0GS+mFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785451751; c=relaxed/simple;
	bh=HmBE5j63TIiZAA8HKCToDjPubHizXuoaFjOzDOdflgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wo9d/7FqI9fprR+tl62CEQYpp5thgn7UMqgjNLAqXOBuXkIEXycg49X5woSYSidHKF49+ygfv9Y32yfbEbcIeb1AIfOf8p3RWI5th3mcQUf8q9cb2be462Knkt1zuEV4+MyfTc3/7FYJXjSEB1WF879s1MgrgHfO2kMT+qsVRzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=RampfJ8q; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="RampfJ8q"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hB4BZ3Zmsz1XM30r;
	Thu, 30 Jul 2026 22:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1785451746; x=1788043747; bh=cclPv
	qFh1Z3Tx7n0tIdyY+JV7wzMs7cAqJ9hU5JiPyw=; b=RampfJ8q+UoakkmUkPwfp
	eMFz7byN+WfNkSnGEmGWKJLv3rk20D+KjSTP6ial8MR0oFVUf25uTpga0piyu8Qk
	e59uNDece399KH4U89mDeYc99FDXruAQPOz2WlSuTIaIBZEkHEzO1k38oHKe8Inf
	P7KVpHiEPMF36v1rPbuGrpCQuzDyaFgxSQlKR/ulns9CWmkL8Qt0CoQbIAJLrfUf
	eOQmRW37bIQQyS210MVdNZDKwMjIDkfqZ8bSKs8egYd72l9RQgHkya791lkeewJb
	nUDSM++qBkPrXO8RY2ZwTzxUlmcgOC0T23nhdGZErIIULknZCv1BcluI/oWZkBsX
	A==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id jZuwgkAnBis0; Thu, 30 Jul 2026 22:49:06 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hB4BS2CZVz1XM30k;
	Thu, 30 Jul 2026 22:49:04 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Marco Elver <elver@google.com>,
	linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Nilesh Javali <njavali@marvell.com>,
	Manish Rangankar <mrangankar@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v3 49/57] scsi: qla4xxx: Enable lock context analysis
Date: Thu, 30 Jul 2026 15:45:32 -0700
Message-ID: <16b4a91a5061399166a31ab2a79368da09ba0089.1785451174.git.bvanassche@acm.org>
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

Annotate the functions that perform conditional locking with
__no_context_analysis.

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
index f7340cfc990a..513e9e95c888 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.c
+++ b/drivers/scsi/qla4xxx/ql4_nx.c
@@ -406,6 +406,7 @@ void qla4_82xx_crb_win_unlock(struct scsi_qla_host *h=
a)
=20
 void
 qla4_82xx_wr_32(struct scsi_qla_host *ha, ulong off, u32 data)
+	__context_unsafe(conditional locking)
 {
 	unsigned long flags =3D 0;
 	int rv;
@@ -429,6 +430,7 @@ qla4_82xx_wr_32(struct scsi_qla_host *ha, ulong off, =
u32 data)
 }
=20
 uint32_t qla4_82xx_rd_32(struct scsi_qla_host *ha, ulong off)
+	__context_unsafe(conditional locking)
 {
 	unsigned long flags =3D 0;
 	int rv;
