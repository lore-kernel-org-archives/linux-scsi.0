Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16FA13C5532
	for <linux-scsi@vger.kernel.org>; Thu, 12 Mar 2026 21:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773350298; cv=none; b=T8USZhm1dO0yhTGcnWQj4W+X7F1gCsOTgT0CyU6VWbU6RREfAXpf4FdlRBl+QXF6WbAMy1skELc3Okp84xMYjAI09FQ8jnhHbrsslsyxYKGt/z2RBi7L0RMglTM9Gqk6VX5sOB9C165PpDbX3lHZ1d698Cp5iZRl6mcFdEzUWB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773350298; c=relaxed/simple;
	bh=jMrHqoz0zsVDHnNtZbYr13UHEooXJTgqusWI0nkVrfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i3IFR6ITGY6gyf/HK4HRM9/rkQt8yDXSk+8LqXh9BSUMc9lF1fDWoMzoDSIljgQZkZVIOxjbD/rprvl430IP1NzaHlzW7gg9AoeHjXcZXXo9XSP/M2Gv99Fdk8zAtlY4Og1DInuuRVCRHMZwMyt1h+CuyU16Q7Xvqe53fnrZGKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=hX/oRRPa; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="hX/oRRPa"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4fX0pJ5xjTzlfl8L;
	Thu, 12 Mar 2026 21:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1773350294; x=1775942295; bh=p/yLz
	G0rrFadUH0R+NPExYvwFs1Ykng9DQo+bfoDO9g=; b=hX/oRRPahq5E0mElf2r6I
	KUhWPdqrjUYUZWM+a9NX2EFki4WL6kvuKmTPMIWbtia2y2TcPA+7w01uosYkjwtX
	IpVGjwEzJs8hQj9tPtNw5xMviO8Egotm+zl4Ong85GtGk4SLnHsnxQyIRP+T8cDc
	QQzVVXibKcLYu5L+a5f66B7fXUoJ2N2xGCX2rcE+551eHRtOieifS8zj5QM91QIF
	/xLFlRXpl7GUadZ7gkr/aIavns+IVzskWjYGW5IHNyPZaYS45onLHelYTF0ZfzHM
	kPvlEK3VIEb8Ah2M0iRlOP1aCJq/rHiOT8sl2/AaTzn/3U9IH2+WXAQ6p3BopEOb
	Q==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Ew4sJZhDqaqV; Thu, 12 Mar 2026 21:18:14 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4fX0pD4vKXzlfl5W;
	Thu, 12 Mar 2026 21:18:12 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Nilesh Javali <njavali@marvell.com>,
	Manish Rangankar <mrangankar@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 31/36] scsi: qla4xxx: Prepare for enabling lock context analysis
Date: Thu, 12 Mar 2026 14:15:42 -0700
Message-ID: <20260312211636.3245119-32-bvanassche@acm.org>
X-Mailer: git-send-email 2.53.0.851.ga537e3e6e9-goog
In-Reply-To: <20260312211636.3245119-1-bvanassche@acm.org>
References: <20260312211636.3245119-1-bvanassche@acm.org>
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
 drivers/scsi/qla4xxx/ql4_nx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_nx.=
c
index f7340cfc990a..bf0538959e85 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.c
+++ b/drivers/scsi/qla4xxx/ql4_nx.c
@@ -406,6 +406,7 @@ void qla4_82xx_crb_win_unlock(struct scsi_qla_host *h=
a)
=20
 void
 qla4_82xx_wr_32(struct scsi_qla_host *ha, ulong off, u32 data)
+	__no_context_analysis /* conditional locking */
 {
 	unsigned long flags =3D 0;
 	int rv;
@@ -429,6 +430,7 @@ qla4_82xx_wr_32(struct scsi_qla_host *ha, ulong off, =
u32 data)
 }
=20
 uint32_t qla4_82xx_rd_32(struct scsi_qla_host *ha, ulong off)
+	__no_context_analysis /* conditional locking */
 {
 	unsigned long flags =3D 0;
 	int rv;
