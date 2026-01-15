Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51BEF31AF1E
	for <linux-scsi@vger.kernel.org>; Thu, 15 Jan 2026 21:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768511060; cv=none; b=tRv+0Z6BUvg1lFrulU3KE6qalJfp2KPoHE6tg52sJpDAK65UK9G9klmsoTunHp00wIAhj8j7IkG8j/CDD6bQ2Ehwyi9fp9Y0QjweB0Q757ppLxFHbImnlCfbu/iXm7kgTPDSpHU0qE2diMt9yJAr40C1p0boQW1GUlDK9zE4nvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768511060; c=relaxed/simple;
	bh=nxKi0Hj7Vh272tlyqJKDwqGWNDLZXFiuHHJOUkdoLSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aLRMN35GlW9vf8oxIQr4vsRkwDrP93HYttuVjbhUjYK2LGjhWx7oGkTnmzBmDAMSOYyhWFiVUD83S/jFQEI9meEE+I0m87PBxGiydnlfBUe5omgIpK52KlWd6jyjF8W4sj6D97oR8zgperczmXbJaQkr2b1g5WZmus0AFag5EQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=hA2E/5lK; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="hA2E/5lK"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4dsb826565z1XLwX9;
	Thu, 15 Jan 2026 21:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1768511056; x=1771103057; bh=pL4Oj
	6TOaS+YcouJn5da8fc7IStw3pggCO8EyG0QeTw=; b=hA2E/5lKkj8GS9qGHrDT6
	O5qt35hlinlpnBSf1RXPtYs36f75FCqc/dcaHsxUmtOgtsgItox5b6erIT7/uY6y
	DA7glcFMSJZpuHmWpqR4GNB6Dp5VYHdkkdyny/CYP3BBMFltwgZ9xyjaPZcGSV8u
	dM8VqikmIhThvdNlGpPwubLLtMNizGh7qlbw7Jg/TJ9gpbZqOE4Vr0d/YOV7+VNM
	s0Hfs+oOb+XOZsT9Fzpzjkdv0BUYI083HBcGK2sUTfrUfgNuaH9POShvHPGyXzE5
	uF/u3yogI0BmnAwG8cro5KEwQrlEfOouEbZUwVOn2YaU+w0aAd0XLWez+PoOpKjK
	w==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id w9CZlH1h9-57; Thu, 15 Jan 2026 21:04:16 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4dsb7y3Qfdz1XLyhS;
	Thu, 15 Jan 2026 21:04:14 +0000 (UTC)
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
Subject: [PATCH v2 2/5] scsi: megaraid: Return SCSI_MLQUEUE_HOST_BUSY instead of 1
Date: Thu, 15 Jan 2026 13:03:38 -0800
Message-ID: <20260115210357.2501991-3-bvanassche@acm.org>
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
value. Return SCSI_MLQUEUE_HOST_BUSY from megaraid_queue_lck() instead of
1. This patch doesn't change any functionality since scsi_dispatch_cmd()
converts all return values other than SCSI_MLQUEUE_* into
SCSI_MLQUEUE_HOST_BUSY.

Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Sumit Saxena <sumit.saxena@broadcom.com>
Cc: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Cc: Chandrakanth patil <chandrakanth.patil@broadcom.com>
Cc: megaraidlinux.pdl@broadcom.com
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/megaraid.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index a00622c0c526..54ed0ba3f48a 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -640,7 +640,7 @@ mega_build_cmd(adapter_t *adapter, struct scsi_cmnd *=
cmd, int *busy)
 			}
=20
 			if(!(scb =3D mega_allocate_scb(adapter, cmd))) {
-				*busy =3D 1;
+				*busy =3D SCSI_MLQUEUE_HOST_BUSY;
 				return NULL;
 			}
=20
@@ -688,7 +688,7 @@ mega_build_cmd(adapter_t *adapter, struct scsi_cmnd *=
cmd, int *busy)
=20
 			/* Allocate a SCB and initialize passthru */
 			if(!(scb =3D mega_allocate_scb(adapter, cmd))) {
-				*busy =3D 1;
+				*busy =3D SCSI_MLQUEUE_HOST_BUSY;
 				return NULL;
 			}
 			pthru =3D scb->pthru;
@@ -730,7 +730,7 @@ mega_build_cmd(adapter_t *adapter, struct scsi_cmnd *=
cmd, int *busy)
=20
 			/* Allocate a SCB and initialize mailbox */
 			if(!(scb =3D mega_allocate_scb(adapter, cmd))) {
-				*busy =3D 1;
+				*busy =3D SCSI_MLQUEUE_HOST_BUSY;
 				return NULL;
 			}
 			mbox =3D (mbox_t *)scb->raw_mbox;
@@ -870,7 +870,7 @@ mega_build_cmd(adapter_t *adapter, struct scsi_cmnd *=
cmd, int *busy)
=20
 			/* Allocate a SCB and initialize mailbox */
 			if(!(scb =3D mega_allocate_scb(adapter, cmd))) {
-				*busy =3D 1;
+				*busy =3D SCSI_MLQUEUE_HOST_BUSY;
 				return NULL;
 			}
=20
@@ -898,7 +898,7 @@ mega_build_cmd(adapter_t *adapter, struct scsi_cmnd *=
cmd, int *busy)
 	else {
 		/* Allocate a SCB and initialize passthru */
 		if(!(scb =3D mega_allocate_scb(adapter, cmd))) {
-			*busy =3D 1;
+			*busy =3D SCSI_MLQUEUE_HOST_BUSY;
 			return NULL;
 		}
=20
