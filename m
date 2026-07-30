Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A757F5464C
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 22:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785451763; cv=none; b=DyT+n0zZ9zp6i5R1OvqZCdEjsMW+vfQAM0Jl0KSEBtSQqUHmFVMX7e7NjPyEGxBblgfZacjEiQodT3MVHrnx6mHdhx1gxsY76qBvVHD/d80EamNgeFevNAIl0DFuC/hR6LQ7r5X4z1erezBRkKSAJNXdeY3+37S6gHjszS4swOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785451763; c=relaxed/simple;
	bh=lm7XMzqJ1R2AKa1VhOz8N7DFX8wez0wHjEDNboLB8Zg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FnELtpXTcz7g/hFkzRV+4Y0oclZY11e9zEqtmgoa13k15lRtQM0vJrKKKvAjON4MtypYDaY9q9kDfkverjvomCi8Kt+h7v35ogKC/RZIMHUy2Q0Tg//+LEcu46e2ugmzykOx5W3JkPWbX7z5oSmMX6bHodP4rjBNRB+pntFAbhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=vq7srF7x; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="vq7srF7x"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hB4Bp2wXDz1XM2FN;
	Thu, 30 Jul 2026 22:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1785451758; x=1788043759; bh=noWLL
	NfcOLm8kA793LP/Iih2xwxFqezecaOX49Tv9oA=; b=vq7srF7xCCVb03Cln8ifz
	P9RKGkPlyIanWy6o/qChlMJUYpKnvUn+k9MSNClsJDYJuGaveGMw8i+hmxJ786y8
	Vcwg/En2PvStW2f2vHTlbyApiBLUtiqseolx54AE5uaOJAjD30BYKNx2dt1CSW9z
	/QLXwhSt0b9rIpxCIoEHVcxd8EFtPoCe2vxB2sTbne+V0MvjcKR7+t4qzOe8wcNT
	UvZ8/gDNKo6jaPnfjKwOB+ADMTgRFnV5LRP0aczpAla08dbsel5sSAUcKsu2lCKB
	QGp76gg8/xNZxIVkb81AcMXCfVvbKedw5hPQvopa5yIzgJ2rd3bhr9At8+dRmi/5
	Q==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id J_95woY7CM1D; Thu, 30 Jul 2026 22:49:18 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hB4Bh5yKbz1XM30r;
	Thu, 30 Jul 2026 22:49:16 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Marco Elver <elver@google.com>,
	linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Lee Duncan <lduncan@suse.com>,
	Chris Leech <cleech@redhat.com>,
	Mike Christie <michael.christie@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v3 51/57] scsi: iSCSI transport: Prepare for enabling lock context analysis
Date: Thu, 30 Jul 2026 15:45:34 -0700
Message-ID: <068c1230f0c04356f01d9c46eada7c48b1001e99.1785451174.git.bvanassche@acm.org>
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

Document locking requirements with __must_hold().

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_transport_iscsi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_tran=
sport_iscsi.c
index 8aa76f813bcd..ade69c7b65b4 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2243,6 +2243,7 @@ static void iscsi_ep_disconnect(struct iscsi_cls_co=
nn *conn, bool is_active)
 static void iscsi_if_disconnect_bound_ep(struct iscsi_cls_conn *conn,
 					 struct iscsi_endpoint *ep,
 					 bool is_active)
+	__must_hold(&conn->ep_mutex)
 {
 	/* Check if this was a conn error and the kernel took ownership */
 	spin_lock_irq(&conn->lock);
