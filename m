Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA71D324B25
	for <linux-scsi@vger.kernel.org>; Fri, 12 Sep 2025 18:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757701524; cv=none; b=BqlKVnvIhtlO0GfNAXcrDo0T5hReMIWkfEJys2g2LHQjX4JhNtU2Z2telQTaz0okgWL2/Mf0jXdaoI14gyQZrmdc7CmtQO4SFxUVYctqDmW20nVHGhE2+bYqmc9sN1TYC5QXARGlETgjkFcBZflrm24ZOXXzaEI1DO941qyQEDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757701524; c=relaxed/simple;
	bh=ax9VT8b2VHL78la8wCpD1Niyew1h/eZ2sWcD1Kcnyd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qNbMMyW8fMRzQrOxWJ5zkBRq0HE6BViwm7g/UbQbrw+HcmbggNoW+wGqCuCVxgQ+JRPczFKaBdDmT/lYbU83pujLVtRY+PByDugNFS9C+QOoD95yP6kw32WlxvI/PHjiWqC8JlKv6RPoyDfUhicDfcWjBNw6EtpXsn+9cLSu3mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=p23RoqNn; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="p23RoqNn"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cNjXL0bc9zltJQj;
	Fri, 12 Sep 2025 18:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1757701520; x=1760293521; bh=fPgkd
	eXKjzB8PaxDplBe5HF2wcpM84YM9xFIP27x9M4=; b=p23RoqNnvyiUUf/UhmSFM
	jHVbd9ETvRBdO1fGI4JoH95DJ3IKG2YPhccAteOrxQ+bwlnAlnUCu0oN6AGi0E/b
	MhXlcG+/NmdhVtZdnTlasoHGabH+PXUKlaDXQ8dI+58F3c89bOz8h1OaQuoyp9ML
	ivC1bcmF2qL55qZfitb0i0RFJ5I2uhxSLXr+R5oAdMNOGFcPJIfr3N2QP40sPO1O
	ccru5I36YRNeXMvbA4F4Cnpbnu8WqNpsXenpjl/jfI9NpA6bft4ddhEW6khZIpzX
	r8UVUsDWRwd7dlAbzuoufuR/K6A696amJyIXDFss+en8oAO6KacgoRkJQ2kIk/HW
	Q==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id DlTJD9DrE0pN; Fri, 12 Sep 2025 18:25:20 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cNjXG5nM0zlgqyC;
	Fri, 12 Sep 2025 18:25:18 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v4 07/29] scsi_debug: Allocate a pseudo SCSI device
Date: Fri, 12 Sep 2025 11:21:28 -0700
Message-ID: <20250912182340.3487688-8-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
In-Reply-To: <20250912182340.3487688-1-bvanassche@acm.org>
References: <20250912182340.3487688-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Make sure that the code for allocating a pseudo SCSI device gets triggere=
d
while running blktests.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_debug.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 2a8638937d23..3f7884025d19 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -9197,6 +9197,19 @@ static int sdebug_fail_cmd(struct scsi_cmnd *cmnd,=
 int *retval,
 	return ret;
 }
=20
+/*
+ * The only purpose of this function is to make the SCSI core allocate a
+ * pseudo SCSI device.
+ */
+static int scsi_debug_queue_reserved_command(struct Scsi_Host *shost,
+					     struct scsi_cmnd *scp)
+{
+	WARN_ON_ONCE(true);
+	scp->result =3D DID_ERROR << 16;
+	scsi_done(scp);
+	return 0;
+}
+
 static int scsi_debug_queuecommand(struct Scsi_Host *shost,
 				   struct scsi_cmnd *scp)
 {
@@ -9416,6 +9429,7 @@ static const struct scsi_host_template sdebug_drive=
r_template =3D {
 	.sdev_destroy =3D		scsi_debug_sdev_destroy,
 	.ioctl =3D		scsi_debug_ioctl,
 	.queuecommand =3D		scsi_debug_queuecommand,
+	.queue_reserved_command =3D scsi_debug_queue_reserved_command,
 	.change_queue_depth =3D	sdebug_change_qdepth,
 	.map_queues =3D		sdebug_map_queues,
 	.mq_poll =3D		sdebug_blk_mq_poll,
