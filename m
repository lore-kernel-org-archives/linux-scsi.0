Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1A71136E34
	for <linux-scsi@vger.kernel.org>; Mon,  3 Jun 2024 17:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717435426; cv=none; b=eIiDoxLCbRXhWV7WueCKIPdAgBKiou/fK2ltjCaecygIjZ7ZqXL5R3VVwGez8s96eQUWo8GiZNNQHjdcrAEcpECnyx75zKruExwr1VICSkGKTaQQw8+3UuYiZbs6ZNxkJtOUGCYGuLltsIvX3UeoC1gujWPuvjusk8A+QsYguTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717435426; c=relaxed/simple;
	bh=TyUOq1Yz8oE8LiNM26EYqE5GIP2M3m0HmKEj2xCVJhw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oCqJFzIVniq6iVYJFKBssI6WCTn4MsW3Lt+iWAGF62fQ9rHfUEcsuD+JdjtE/ThSKbUzAfJ5kKNXBRPX9UoN42ByXIfEEuMFgBgtq/4y9901VSDq2nOkn0pFCQQmHmhYLEVMyG9U0/zrwUUUGxNNg0Pma1JqjlG83NNaWAdbvsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=us3NpbEV; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="us3NpbEV"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4VtLDH5YYczlgMVb;
	Mon,  3 Jun 2024 17:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1717435422; x=1720027423; bh=p2KBk
	fdq9iVpXkYSZiC1blWH+q3F2g2Zs2vFFB9Zp2I=; b=us3NpbEVt3D2TXMP3arlM
	beXPoX4R3QsYkzk/mmbobfd83xbY+Hr3uJAPwFi+o5y9djlu9JljEvLsQft/2ueP
	Pa4tFPBFAty5nDZzDbBQVGGLP2jOAOzN/0u43R3oeulXVFtSmVzBwdr8edu7pHjp
	dlQ3hqPAiSEHHLYYhSBa7NQ2rESvN24yMnSmaSqK4pr39bz+i97FEW1uw0PP2nrg
	WtSaRUqz3vWD2rurgtLLo4BvXk7boX3Y+d6lEEfOd7PBzsL3L6cl27tsBAxaNInd
	GQ/i2YXSZ4NXehv+zVjLBv0B4FNtwHtTT2JQi6vcWXOVdTdmh++4yedFwT1vuv/e
	g==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id uHOJ_Xok1LGc; Mon,  3 Jun 2024 17:23:42 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4VtLDF5B9SzlgMVc;
	Mon,  3 Jun 2024 17:23:41 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Russell King <linux@armlinux.org.uk>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 2/4] scsi: cumana: Declare local functions static
Date: Mon,  3 Jun 2024 10:23:09 -0700
Message-ID: <20240603172311.1587589-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.45.1.288.g0e0cd299f1-goog
In-Reply-To: <20240603172311.1587589-1-bvanassche@acm.org>
References: <20240603172311.1587589-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/arm/cumana_2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/arm/cumana_2.c b/drivers/scsi/arm/cumana_2.c
index c5d8f4313b31..e460068f6834 100644
--- a/drivers/scsi/arm/cumana_2.c
+++ b/drivers/scsi/arm/cumana_2.c
@@ -296,7 +296,7 @@ cumanascsi_2_dma_stop(struct Scsi_Host *host, struct =
scsi_pointer *SCp)
  * Params   : host - driver host structure to return info for.
  * Returns  : pointer to a static buffer containing null terminated stri=
ng.
  */
-const char *cumanascsi_2_info(struct Scsi_Host *host)
+static const char *cumanascsi_2_info(struct Scsi_Host *host)
 {
 	struct cumanascsi2_info *info =3D (struct cumanascsi2_info *)host->host=
data;
 	static char string[150];
