Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4824D2836B1
	for <linux-scsi@vger.kernel.org>; Thu, 15 Jan 2026 21:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768511063; cv=none; b=j0ucoMq+9Uyfw84ExbHalSiwfrjmYiAPXn6/17iqOjpBFQELugEcf9GExGJ7+3gvC7lY4iOS2gBA1ZnMwG4CyWl2CA+XUXz+jWd6+cOxKF+m52TRQCwNnCa8cwZOUnehJwY7hkCGZ0u8QctWOq5m4METQwJzyfcthFC+8bcmGfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768511063; c=relaxed/simple;
	bh=YGsxnKYLHhE/THH6hM744Es1iDaC0MAFce/PxYP0FTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UZcAqD7SdhJLF6BAx+fGkK/1h3gNiuMo1BapXvCcO6QVPakdLAXnTpWDhxeZKVJJKAtqvfE1m7d1L0F30331b3EnDz01TV58jWEYYa2IVXvykw70G+ox78p6E2NZWdHLblXLCiKn6hoLpQNSwBC4G66JGiRK5Ux1I8GL11jLees=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=qYO+IE8D; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="qYO+IE8D"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4dsb8567Pvz1XLwWq;
	Thu, 15 Jan 2026 21:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1768511059; x=1771103060; bh=TZ2Kg
	XGOlg5qDEu4jY01u6FMc0/ajdhjKNG29UrRbXY=; b=qYO+IE8DuAOaCwKjpOP9v
	56dmKyu4cIW8ggq9j4mfG9tWLjWhBb7AKbprBAOHUjUJoGgsVOP1xSLy6jA64fNM
	IXyoSJlbcDiNYe3/09+axa1LNOSE3dhaMoI/NZe974pPprA9e0rAkz42DZuowDHb
	P6IO1KtTgDsG1d9QUbgFc/Tpqd4GsbkDg4xyPZCx+dmE6+CdYzjjUWp9zj3TZWy9
	l8Im/EGiL3VI4VOFddDU5kMqwk7cj6m+7OcEeDZHx0rzdOUVK18kKqXKurEoNojK
	KvKxFoicTMxJHGa/ieMNzz8eyCPG+BYb+iDy0vLrlARssNlXyhy11KWER7yA9n36
	Q==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 3ZjAr02Fndxl; Thu, 15 Jan 2026 21:04:19 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4dsb811RqLz1XLwWt;
	Thu, 15 Jan 2026 21:04:16 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	John Garry <john.g.garry@oracle.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	Chandrakanth patil <chandrakanth.patil@broadcom.com>,
	megaraidlinux.pdl@broadcom.com,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v2 3/5] scsi: megaraid_sas: Return SCSI_MLQUEUE_HOST_BUSY instead of 1
Date: Thu, 15 Jan 2026 13:03:39 -0800
Message-ID: <20260115210357.2501991-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
In-Reply-To: <20260115210357.2501991-1-bvanassche@acm.org>
References: <20260115210357.2501991-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

.queuecommand() implementations are expected to return a SCSI_MLQUEUE_*
value. Return SCSI_MLQUEUE_HOST_BUSY from megaraid_queue_command_lck()
instead of 1. This patch doesn't change any functionality since
scsi_dispatch_cmd() converts all return values other than SCSI_MLQUEUE_*
into SCSI_MLQUEUE_HOST_BUSY.

Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Sumit Saxena <sumit.saxena@broadcom.com>
Cc: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Cc: Chandrakanth patil <chandrakanth.patil@broadcom.com>
Cc: megaraidlinux.pdl@broadcom.com
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/megaraid/megaraid_mbox.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megarai=
d/megaraid_mbox.c
index b610cad83321..722d3b5acea3 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -1516,7 +1516,7 @@ megaraid_mbox_build_cmd(adapter_t *adapter, struct =
scsi_cmnd *scp, int *busy)
=20
 			if (!(scb =3D megaraid_alloc_scb(adapter, scp))) {
 				scp->result =3D (DID_ERROR << 16);
-				*busy =3D 1;
+				*busy =3D SCSI_MLQUEUE_HOST_BUSY;
 				return NULL;
 			}
=20
@@ -1599,7 +1599,7 @@ megaraid_mbox_build_cmd(adapter_t *adapter, struct =
scsi_cmnd *scp, int *busy)
 			/* Allocate a SCB and initialize passthru */
 			if (!(scb =3D megaraid_alloc_scb(adapter, scp))) {
 				scp->result =3D (DID_ERROR << 16);
-				*busy =3D 1;
+				*busy =3D SCSI_MLQUEUE_HOST_BUSY;
 				return NULL;
 			}
=20
@@ -1644,7 +1644,7 @@ megaraid_mbox_build_cmd(adapter_t *adapter, struct =
scsi_cmnd *scp, int *busy)
 			 */
 			if (!(scb =3D megaraid_alloc_scb(adapter, scp))) {
 				scp->result =3D (DID_ERROR << 16);
-				*busy =3D 1;
+				*busy =3D SCSI_MLQUEUE_HOST_BUSY;
 				return NULL;
 			}
 			ccb			=3D (mbox_ccb_t *)scb->ccb;
@@ -1740,7 +1740,7 @@ megaraid_mbox_build_cmd(adapter_t *adapter, struct =
scsi_cmnd *scp, int *busy)
 			 */
 			if (!(scb =3D megaraid_alloc_scb(adapter, scp))) {
 				scp->result =3D (DID_ERROR << 16);
-				*busy =3D 1;
+				*busy =3D SCSI_MLQUEUE_HOST_BUSY;
 				return NULL;
 			}
=20
@@ -1808,7 +1808,7 @@ megaraid_mbox_build_cmd(adapter_t *adapter, struct =
scsi_cmnd *scp, int *busy)
 		// Allocate a SCB and initialize passthru
 		if (!(scb =3D megaraid_alloc_scb(adapter, scp))) {
 			scp->result =3D (DID_ERROR << 16);
-			*busy =3D 1;
+			*busy =3D SCSI_MLQUEUE_HOST_BUSY;
 			return NULL;
 		}
=20
