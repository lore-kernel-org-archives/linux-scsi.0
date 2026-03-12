Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CA0B3CA4BE
	for <linux-scsi@vger.kernel.org>; Thu, 12 Mar 2026 21:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773350293; cv=none; b=O/pGwoFeFBjQelSCluB3lyttzh+2o5eP8t9FCBNaHDZIBMjqq/nuSepEZ2NBdudofi0qFgpayeWsuwjZPK5JTyEQdX4SfCstDdlU9zzsUiY9kbHsUdztf4eh6kdSvHhED1AxiSQu7x5BxuwUKLrlfv47UK6zWy9OhTiyDsAUAKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773350293; c=relaxed/simple;
	bh=lUr6Yg+j6QknZUMXj7pZWFPwzdUWLxYR3dAOdAZ47Eg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OxNKz8jYx67kpvD5uNoY1/y1p+xJ6ZzJbe+AF0dxLO79lwU1S7drRW0FMWmPUJoy2ac+3e1zWj2WNtEmoD9vBoBLMKd1wuxlJPh/6psP6EfF5fOV38UhzyUrGVzDYl+HGqc/ZjGHUYFUQn627jjtZ6v3S0iIiNjtIbCCf8zpKCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=UKVzk2zf; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="UKVzk2zf"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4fX0pD1fMVzlfl5V;
	Thu, 12 Mar 2026 21:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1773350289; x=1775942290; bh=sl24F
	Sc40CSaoQpszzomHrcUuskgwhuv5OT/UvFfs8s=; b=UKVzk2zfS5q7weBGFKJjM
	Asavt1jLlmSSA2fwo6iEF9Y6LWjEReQXdEK4qI003HsnK+DkQ6wrY0xk3AgpOUUs
	QnTt3ChkMeN9N19NQoEzehWQqtkFVvYDXhEc/kBMnLd1JgYr3GQcPRdLBctm+oD1
	iZSpH5abLbdJ9rEh+8DQoie3oJcGNIQUrepzxb+3CnIufYh+3bAccLS6aYSsdt4b
	CO3OTzVOyqm9MkdL3KqReh5aFvuy9zTL3wgUUxgOlzo8Ot969UpAZ2lGDRVwdnos
	mhmeBc6H79mkYgmRBcTgsfd/DEk6erm/ZLKSkbPMglcdfZ8ZlnXOD1yqVitWTKjO
	g==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id TcEfw6QHvfK2; Thu, 12 Mar 2026 21:18:09 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4fX0p73q7tzlfl5h;
	Thu, 12 Mar 2026 21:18:07 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Nilesh Javali <njavali@marvell.com>,
	Manish Rangankar <mrangankar@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 28/36] scsi: qedi: Prepare for enabling lock context analysis
Date: Thu, 12 Mar 2026 14:15:39 -0700
Message-ID: <20260312211636.3245119-29-bvanassche@acm.org>
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

Annotate qedi_cleanup_all_io() with __no_context_analysis since it
performs conditional locking.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qedi/qedi_fw.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index 854efa4f61d8..3223951cab14 100644
--- a/drivers/scsi/qedi/qedi_fw.c
+++ b/drivers/scsi/qedi/qedi_fw.c
@@ -1134,6 +1134,7 @@ int qedi_send_iscsi_logout(struct qedi_conn *qedi_c=
onn,
=20
 int qedi_cleanup_all_io(struct qedi_ctx *qedi, struct qedi_conn *qedi_co=
nn,
 			struct iscsi_task *task, bool in_recovery)
+	__no_context_analysis /* conditional locking */
 {
 	int rval;
 	struct iscsi_task *ctask;
