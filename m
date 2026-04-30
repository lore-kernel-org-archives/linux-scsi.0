Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 905FF421F06
	for <linux-scsi@vger.kernel.org>; Thu, 30 Apr 2026 18:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777573506; cv=none; b=BPXvXPRHzy+CFXq/aTb0FNkxsCotuHaFPSCq98z5q2L83S8ScWaq+QX2umkpGGD30NhlssZ/u/FP6/ULfwLzPc462dH9LhB+QQwnEp3o2NbPjNANZJYq/Tqz5rtyOUlZwygjx4J2FG2nFZq/LI4P/qepbBqNDrzuAEgq5PQJdd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777573506; c=relaxed/simple;
	bh=HmBE5j63TIiZAA8HKCToDjPubHizXuoaFjOzDOdflgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=elnxaEZEpq6QXs1rYgP1bDg3sd4YE7h3yTzgQ6mGpHPuU1cKqqlogQc4RQ/urWckOGxc4ljg7tbzjpTJgVai8CQtoYSYmvPZY5lqRiSbAToQM4aJrA9Rs2/CZc4x2p4N9nV3WIc7xbOdZgIrnHQTl6F4SzEbNzw3WR1ffoXZ3MU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=SomkT1pL; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="SomkT1pL"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4g62ds2YVczlffvd;
	Thu, 30 Apr 2026 18:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1777573501; x=1780165502; bh=cclPv
	qFh1Z3Tx7n0tIdyY+JV7wzMs7cAqJ9hU5JiPyw=; b=SomkT1pL1n7JkDgqV7zyT
	IHDjh8tVyGAzcXDsw/PwaPZL5zmxjBNsoznvwTiYmpbiXl//YAJmRMV417gmN0m+
	Ss5DjlWidhRs0+ix7eWiKabJvsjd9hczOyZ1w1SJnKyCS9BmYcNktS/bZiQege6i
	NynOmJrSBtDsiQweanK2YIDFzt3mZlwNwgRh0N+8S8hrRD2ZWUe3RQZvF9EhNYF/
	pj8j5wNmz4m9Z75Dln8YdVkbJiOWL27Xzjier6OQELR8KRZ97wneM4zYKL4SsuqH
	qkb7JYJzuZNNTZaIYtkSHzWNpJx7Sc1FFTwHURedWNtYrKmYkETKGG0vlXnWyYeo
	Q==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id JtYrtkIVoCV7; Thu, 30 Apr 2026 18:25:01 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4g62dl2jSQzm1QFR;
	Thu, 30 Apr 2026 18:24:59 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Marco Elver <elver@google.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Nilesh Javali <njavali@marvell.com>,
	Manish Rangankar <mrangankar@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v2 49/56] scsi: qla4xxx: Enable lock context analysis
Date: Thu, 30 Apr 2026 11:20:19 -0700
Message-ID: <20260430182130.1978347-50-bvanassche@acm.org>
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
