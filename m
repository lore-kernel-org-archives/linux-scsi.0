Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F1E039D6DE
	for <linux-scsi@vger.kernel.org>; Thu, 30 Apr 2026 18:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777573531; cv=none; b=VqjTCRwaDp8kjXSKOJ0XeVEGNbEyoDufhxNBuCovWX4YWWjhQFh6vSjWJ6WHhVXznmWIhu6Bn6f3MAMHny04WF0sXp1O08BVUlwWA7xbsjmwMi1et1aBHgzW0WAD8eawvzUjQPLcvJJujYcLoAMxXAwuPu3FMN/W99UwyK4znnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777573531; c=relaxed/simple;
	bh=PbKAdykBusbAmqhisVoEFEOvGFgol6CBScF3ZCAWZIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RiLsXxhBMdgBVxb/Acmj9qa7yvl1muvSst8lroLokFulmKiZQYo2ObvOUdYdMPBI9or8jBDYlBeGI7gKN1PSB+2i+itk+Km39J74HJXNGHeS1dat0YHzX144P9lXz21MBQeXQHXyPLbLW47z1B4SEOF+nfv95r3XZ0qG+SnG++E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=JnWLCG4/; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="JnWLCG4/"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4g62fK6PC4zlgyGq;
	Thu, 30 Apr 2026 18:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1777573526; x=1780165527; bh=l4dDJ
	5l1JXJSaLrAzg09t6YwGlXJtlQj9cBMKdC8DI0=; b=JnWLCG4/Gt+bTW3vPvGkd
	hIyTxupAVy6M5QMKUo4htZwna8DVnAZ9D9QZ1tATu49nCUIIDSklWX3MeR//UkJh
	RUotc+lSF5r4fuAuCibf3zsRss2/7AEulND9CsQ1iZEuXMdSmmXUqnTNHKArNOzt
	cdbhS06kr20Ztjmu4nkAaXWhx7NrFScjvkoizB7DLR4iSOnz8Vx6wZQBDfXobEML
	QAYrF58YrkuQBVng7Jkzo1A0lkoWZkhk13mnAVBntB+YJuDcQdv4LEt7oPK1paXw
	/dd7o3k71kBFj03frRBVo6c1Gnt8hK2c5rU7kKo9kwt3Hu8tJH3QFMIpRxAquQDj
	Q==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 2GqWXPubr30R; Thu, 30 Apr 2026 18:25:26 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4g62fC5lk4zm1QGP;
	Thu, 30 Apr 2026 18:25:23 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Marco Elver <elver@google.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Lee Duncan <lduncan@suse.com>,
	Chris Leech <cleech@redhat.com>,
	Mike Christie <michael.christie@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v2 51/56] scsi: iSCSI transport: Prepare for enabling lock context analysis
Date: Thu, 30 Apr 2026 11:20:21 -0700
Message-ID: <20260430182130.1978347-52-bvanassche@acm.org>
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

Document locking requirements with __must_hold().

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_transport_iscsi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_tran=
sport_iscsi.c
index 8aa76f813bcd..129f12bb7271 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2243,6 +2243,7 @@ static void iscsi_ep_disconnect(struct iscsi_cls_co=
nn *conn, bool is_active)
 static void iscsi_if_disconnect_bound_ep(struct iscsi_cls_conn *conn,
 					 struct iscsi_endpoint *ep,
 					 bool is_active)
+	__must_hold(conn->ep_mutex)
 {
 	/* Check if this was a conn error and the kernel took ownership */
 	spin_lock_irq(&conn->lock);
