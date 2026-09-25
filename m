Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A40538E5C4
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 18:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790361188; cv=none; b=FcaY3yZZvlGiSctSmXe2aq5uUIxfEswxrbFGg08KhfEzs5yeoasprkV313pnZZJhavU76mbU5BtM8NaxMljNRvlZu6XdbKvmn1hO+8BThcmp1Izt03sIpCNTfQWOyg6hAniXySyX/Yj1wPqIuXqOJ6IQpdocGpWVjnBGiWSDWOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790361188; c=relaxed/simple;
	bh=lm7XMzqJ1R2AKa1VhOz8N7DFX8wez0wHjEDNboLB8Zg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PU5Wh4iHB6AQAVrMUNb+og/cuIxjDWYqA2G9ligJCvYP3+jeMJ89ieZ49C0BCGLy7fYbvFbi8JrO17C6TFwXxjEImRT015tHxyVvxVH8zznLN72jqVEGXD9FxTYCRke9njBUZ3thnqG7MW+VDePmvdxKei2+lDpCey0ogxFIQac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=wIhS6iGf; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="wIhS6iGf"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hrzpq0qyvz1XM4Tl;
	Fri, 25 Sep 2026 18:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1790361182; x=1792953183; bh=noWLL
	NfcOLm8kA793LP/Iih2xwxFqezecaOX49Tv9oA=; b=wIhS6iGfWe3LsjVqsQmLn
	AfRL2jGIGnGPoKJWjVKMLSUWRuicTyx+2HANlSy6yOsGBVrsCRh0z3zFHT2GG2f2
	+jh2nXaUoIAa/yz8qb7XWRmU7SiUK4Xhsovlm5tajS14q+vRqJTyo6v3WjwHmjLl
	8mkMJ9LGj4BrEjmfEGkZqpGVPlQeiL5HybFB8Eq2pnO3q5VcrAuS2Tfc1If06uhY
	GcRMFHO7UMOjeSQ3XJX+3mTlID/RE5bI213cWSdpaBMxHuxCUemfMItmC91uYepr
	t57Y1zv/j0mrnn1oHIA05xfI42lngd9LA/ssgVo+fSc4LhMQH7RJDBIDWuoyDf3G
	w==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id u7VerPswS_5s; Fri, 25 Sep 2026 18:33:02 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hrzph0CFcz1XM5kW;
	Fri, 25 Sep 2026 18:32:59 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Lee Duncan <lduncan@suse.com>,
	Chris Leech <cleech@redhat.com>,
	Mike Christie <michael.christie@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Subject: [PATCH v4 50/54] scsi: iSCSI transport: Prepare for enabling lock context analysis
Date: Fri, 25 Sep 2026 11:26:28 -0700
Message-ID: <72bd8921b4ed0a58bd83beed2981ec48372b56fd.1790360262.git.bvanassche@acm.org>
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
