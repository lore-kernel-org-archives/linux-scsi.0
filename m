Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89EF21A38F9
	for <linux-scsi@vger.kernel.org>; Thu,  3 Apr 2025 21:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743715209; cv=none; b=BXOxz0Vx0X2FNNFkp3Sd7m0Uz32FdlubMJwThAagB0jzEJ7vK1reUP46KBbgDqNR0OQ3SwKPu2dLj6T4s7YcF7nHsyjgGvcPq4w1nYsDUj2RWS6cAsiW+qj1TtpxhwxYN7p63MgV7wxHq+ltP4tBbX9VlDDXDNGCDdZ9kzOXKrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743715209; c=relaxed/simple;
	bh=mD4q98WPARrnvfqimjVQsQ8CsdnvqYJZELSMuZd8aFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MCev44lHliTKfwGYlhEh6Kt51WVbWSWbxRYm3IirVra/ixxgdfuY9DaMgJs0X555JuV4K4BzCNc4x8WJZGXOw78EO3kK/zu36BF359wE89t7dlqqbIQVIMjvcqRw5ahTe1JRm0OiCagao7etueQAcHVL8OmJcfuRmr4/Nuxb5HE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=cx2URvjf; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="cx2URvjf"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4ZTF4k3LV8zm0ySc;
	Thu,  3 Apr 2025 21:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1743715205; x=1746307206; bh=a293I
	sMzdzvdZJVqEL8+UR+/09/ytO/ovyajV1n+sxU=; b=cx2URvjfL8sN8vzIFrKMm
	QxvgCl5eXRviS+QZGCxd8s+OW+wFSjfUza0fuvmUZ4TgPk1prWLrFMInkN3pFEUb
	/qYhVfs6LyzC77G6SRBSgB9he0+DgZnVWpntenSW/nVQaWeRUudAh/6ZOinQ3vi4
	2z+4BlKP+AvFbjnv5Qr8PIGpzcd69zVIqaW0hvXBN5eJUKdmyx42pkDyBcVuGVTe
	BXvhS5kayAotuVlFBHRVcgq83od6Ei2BJ22WqKqF4+e/1G/BC6iTSEjekty2XjK4
	iF1kFWJIlw057QhtecGcwYUmF6m5QHBsZA9H6q+sOj7hyWUEwoc1fyJskdSfcHRW
	Q==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id mIMKKvZNGAX7; Thu,  3 Apr 2025 21:20:05 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4ZTF4Z6lLdzm0jvW;
	Thu,  3 Apr 2025 21:19:58 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Hannes Reinecke <hare@suse.de>,
	John Garry <john.g.garry@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 03/24] scsi: core: Use scsi_cmd_priv() instead of open-coding it
Date: Thu,  3 Apr 2025 14:17:47 -0700
Message-ID: <20250403211937.2225615-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
In-Reply-To: <20250403211937.2225615-1-bvanassche@acm.org>
References: <20250403211937.2225615-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Improve code readability without modifying the behavior of the code.

Cc: Hannes Reinecke <hare@suse.de>
Cc: John Garry <john.g.garry@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index be0890e4e706..1da26f300287 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1674,7 +1674,7 @@ static blk_status_t scsi_prepare_cmd(struct request=
 *req)
 	 * a function to initialize that data.
 	 */
 	if (!shost->hostt->init_cmd_priv)
-		memset(cmd + 1, 0, shost->hostt->cmd_size);
+		memset(scsi_cmd_priv(cmd), 0, shost->hostt->cmd_size);
=20
 	cmd->prot_op =3D SCSI_PROT_NORMAL;
 	if (blk_rq_bytes(req))
