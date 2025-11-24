Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CA433176E4;
	Mon, 24 Nov 2025 18:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764008564; cv=none; b=k3OG5COupDLpP9fPkUwSRxqr6qV96h07fBFozXvSYA5HrDjtE79Tedgp9x3sV+NKLfO2rZcF3I9KXfohSY8zmwGUMRZM9Zpp22CyiE/Zuh7G63+y5N5TdcEX7C5bJikbxc5JbmrnWPG2AImlTAnjwJaW+TUZ4vqUdlD6TCSuB1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764008564; c=relaxed/simple;
	bh=Ru4RDHuMzKsP+ogzapGU0bEZdvfMWO13roszpxot/Co=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mWBeSmwfO/9w0qzgcsqEyBx0ZuxIGIbO9FLdEtR436JrMM8S9m/FUmI+BmRbpIiKQvZZ3V/1MeBo97WppiaRSTBCwb9Obhkpd3r6BWaudS1OpJX4l8dRl/tWm3pRCHr2kgn0mkY4v0S9R4ZMrMouc5K+1QsS1Fa347HVz4Q1zPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=BkiUQJu6; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="BkiUQJu6"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4dFZ1Z1jqkzlgqVd;
	Mon, 24 Nov 2025 18:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1764008560; x=1766600561; bh=UvBH0
	B95DuOBiHb6es9YCvEtr6seWtXhiEMbncBm2dU=; b=BkiUQJu6h3f6ql/FJVzw/
	wAbdL5XetR8pPDg0AXBW8NluqhfGydYpy/2Q8T2LcLqbFQQWa9GYV+VQwX2L0HGt
	DZWfm/y4eXsN1sV6D4NNLY/J3g0bFtIMcNca3xPqhrnj4+pdJraH+BrI7NisGn57
	6SBxPG5hg5pMlfDiDMdjkx4ByqsJNvSvFCLGd3DIvSr5vF+7YdxSElg8jqheiRcL
	l+v/iDvszS33SJDLWPm094w4rF4YNcsb89LO2eu7QKtS4YPbEAgTL8ZeaLMniZaN
	rLmmx64UvTx0icPNe+0VD5Le9wgsTfBTFleOQ6u18dB2D5XdXVUSek39RjdTYzjH
	g==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 1I2rVVGXhmdK; Mon, 24 Nov 2025 18:22:40 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4dFZ1P4WvXzlgqVJ;
	Mon, 24 Nov 2025 18:22:32 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-block@vger.kernel.org,
	John Garry <john.g.garry@oracle.com>,
	Hannes Reinecke <hare@suse.de>,
	Bart Van Assche <bvanassche@acm.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH v2 3/5] libata: Stop using cmd->budget_token
Date: Mon, 24 Nov 2025 10:21:58 -0800
Message-ID: <20251124182201.737160-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.52.0.487.g5c8c507ade-goog
In-Reply-To: <20251124182201.737160-1-bvanassche@acm.org>
References: <20251124182201.737160-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Since a single hardware queue is used by ATA drivers, the request tag
uniquely identifies in-flight commands. Stop using the SCSI budget token
to prepare for no longer allocating a budget token if possible. The
modified code was introduced by commit 4f1a22ee7b57 ("libata: Improve ATA
queued command allocation").

Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: Niklas Cassel <cassel@kernel.org>
Cc: John Garry <john.g.garry@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ata/libata-scsi.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 026122bb6f2f..90f5422fa08b 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -744,22 +744,16 @@ static struct ata_queued_cmd *ata_scsi_qc_new(struc=
t ata_device *dev,
 {
 	struct ata_port *ap =3D dev->link->ap;
 	struct ata_queued_cmd *qc;
-	int tag;
+	int tag =3D scsi_cmd_to_rq(cmd)->tag;
=20
 	if (unlikely(ata_port_is_frozen(ap)))
 		goto fail;
=20
-	if (ap->flags & ATA_FLAG_SAS_HOST) {
-		/*
-		 * SAS hosts may queue > ATA_MAX_QUEUE commands so use
-		 * unique per-device budget token as a tag.
-		 */
-		if (WARN_ON_ONCE(cmd->budget_token >=3D ATA_MAX_QUEUE))
-			goto fail;
-		tag =3D cmd->budget_token;
-	} else {
-		tag =3D scsi_cmd_to_rq(cmd)->tag;
-	}
+	WARN_ON_ONCE(cmd->device->host->tag_set.nr_hw_queues > 1);
+
+	/* SAS hosts may queue > ATA_MAX_QUEUE commands. */
+	if (ap->flags & ATA_FLAG_SAS_HOST && WARN_ON_ONCE(tag >=3D ATA_MAX_QUEU=
E))
+		goto fail;
=20
 	qc =3D __ata_qc_from_tag(ap, tag);
 	qc->tag =3D qc->hw_tag =3D tag;
