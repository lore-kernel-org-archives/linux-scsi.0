Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B4FB3074B5
	for <linux-scsi@vger.kernel.org>; Tue, 24 Jun 2025 21:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750799185; cv=none; b=fj0asKvMZRPCEEOlTxCg2UoxZD8DB40jX3lIfrMHD0NGGIrzWBekJ/gOVqI58m5cOhJHxab7T8JpKyYsaIsjCBcg0rQRHoTaTSvGandrDpftxi3Phe8K3Mdj8PMCFH5b7rutMYTXC9SX2p8O6YHlnELBMe+zVyAAGarJEso6tMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750799185; c=relaxed/simple;
	bh=n5rKRnAHYC8d/kHXbNlEBM4PZdBZlXyyMNPyBxsfCIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FeIpMaOa3nuRiJjVL8qLhg1AoPvE8/wRiXOcxkhCCvNE3Ow7YuuzWlawWMojQwe/iQCycX/5HtzoJ5ZjGhoWqtjYmK/DUqZ/5XOrOrE7k6u67zfISE5cO2kIIDaazkY/kJl/XwcdnuJMr8mkwaX5+952he6wJNpViV7xOFbQ0us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=y3yLrU6P; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="y3yLrU6P"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4bRcv32nbPzm0jvG;
	Tue, 24 Jun 2025 21:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1750799181; x=1753391182; bh=9PY+I
	JuLTC2rHqfM9qEeq3GZ14HPO88KGq4PB6wXhm8=; b=y3yLrU6PCuhXT/pHICP6F
	xQx4bH13bNagmZGp1DQ8t5uA8MWapxE3jOzXhvtZmPkc+yysHsNTbsS5AaJQpInV
	iAkGqINi7xI+gJNgOQfzn4dhNvshOBDQSZBEHfXHFfl7yS/G79WmEXmrFmOGwgy1
	GpOAglzpotKqMsR9OTN+sMOEVeV0wgvy43s49iHewy9ijUfpH8A7DH9v8UIXfeVT
	nN2y9kYRaDcfbV085HPwA4SpsuiiBwzazlT7PHXELJ+8+dvduvB3VfnqiulUc4pZ
	8yrKoY3pOhXEYR3NtM7I0qhMVSTqaJqxhmY+ib8I1tI6bOfREzglxIBWMNPNrGTC
	A==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id gNn-ffNgzvp7; Tue, 24 Jun 2025 21:06:21 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4bRctx6WtJzm0yTj;
	Tue, 24 Jun 2025 21:06:17 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Hannes Reinecke <hare@suse.de>,
	John Garry <john.g.garry@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 3/3] scsi: core: Use scsi_cmd_priv() instead of open-coding it
Date: Tue, 24 Jun 2025 14:05:40 -0700
Message-ID: <20250624210541.512910-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.50.0.714.g196bf9f422-goog
In-Reply-To: <20250624210541.512910-1-bvanassche@acm.org>
References: <20250624210541.512910-1-bvanassche@acm.org>
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
index 144c72f0737a..0c65ecfedfbd 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1843,7 +1843,7 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_=
ctx *hctx,
 	 * a function to initialize that data.
 	 */
 	if (shost->hostt->cmd_size && !shost->hostt->init_cmd_priv)
-		memset(cmd + 1, 0, shost->hostt->cmd_size);
+		memset(scsi_cmd_priv(cmd), 0, shost->hostt->cmd_size);
=20
 	if (!(req->rq_flags & RQF_DONTPREP)) {
 		ret =3D scsi_prepare_cmd(req);
