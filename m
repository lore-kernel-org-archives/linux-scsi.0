Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB8F4298CB2
	for <linux-scsi@vger.kernel.org>; Fri,  9 Jan 2026 20:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767991885; cv=none; b=nHuF0wV4RVjrT/3Sn7XctsgFLTzaDtGgZ3TZIt+18ZAWq4G7gyC+uSwB4CPlE0LgrwJNfKgYqUIr2R2OObBdQDdVWqE01IxwHXrES5MIkyypM8goJPKkCKHfNo3EJq/t10bxfFq/yOmfnqh7mDzOQeLmKi+yym8MRozRbq4RRPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767991885; c=relaxed/simple;
	bh=BjOHC/AFWbHmMmTyfqjVRlB/iE/PeONNZayfonAgbOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TLPl8qFNhEdieckp0tJHGxjph8o31GqOhW9ygJ0uLWvd5KH5r8h2rW5+pN4vxmb2RahyhuGP277zUpfcA7ePVoeVIvE4SDBi3wSHTQQrloHxubLLa/hwZuhfpBbGuTYd96TTs/vKEuGhYuLMsj9q+0cBSsaub+yQBI9oFiZq7LU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=YK/E300e; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="YK/E300e"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4dnv7v4SjfzmP4tX;
	Fri,  9 Jan 2026 20:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1767991882; x=1770583883; bh=c5a3F
	lhAS3+2FZ2RinxfVGXruT7Hd2JqKku9i1mnASs=; b=YK/E300eE6+lt3J/3Yd5w
	Ev7mTamK2iq1CqtkCqDtFRLKzbsDPIIp/4P0BSDYxjPpOWkn7Nley4+ACkR0924S
	g156HBsS0YFTsBEzSEl5iyaE7lG1y9CWYZJD2MWAhaX5Da6i0KWxRYZZ9eyyBrg3
	rj2h0Shkf4Rq9KtLpJKdYY3azm/dnCA3sfmiP1xH8xo59qXHBnHY5v7ws2K13bZw
	RDI4UG2npg7mB2Z0INBpSakEvnd/Ii8ZrTag2TQGmzL8oyBBW16GYYwEL+grOhor
	M+KqWeJ2+lpq4D0qxPguztsxYqzj5TLmQKZfipTCcaSql09Tf8+JTlXrQPy2CDc/
	Q==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 0-RElCMo4oNJ; Fri,  9 Jan 2026 20:51:22 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4dnv7s09YVzm109k;
	Fri,  9 Jan 2026 20:51:20 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	John Garry <john.g.garry@oracle.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v2 2/2] scsi: core: Revert "Fix a regression triggered by scsi_host_busy()"
Date: Fri,  9 Jan 2026 12:51:02 -0800
Message-ID: <20260109205104.496478-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
In-Reply-To: <20260109205104.496478-1-bvanassche@acm.org>
References: <20260109205104.496478-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Revert commit a0b7780602b1 ("scsi: core: Fix a regression triggered by
scsi_host_busy()") because all scsi_host_busy() calls now happen after
the corresponding SCSI host has been added.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/hosts.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 196479cbfe6e..4d17f242d191 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -626,9 +626,8 @@ int scsi_host_busy(struct Scsi_Host *shost)
 {
 	int cnt =3D 0;
=20
-	if (shost->tag_set.ops)
-		blk_mq_tagset_busy_iter(&shost->tag_set,
-					scsi_host_check_in_flight, &cnt);
+	blk_mq_tagset_busy_iter(&shost->tag_set,
+				scsi_host_check_in_flight, &cnt);
 	return cnt;
 }
 EXPORT_SYMBOL(scsi_host_busy);
