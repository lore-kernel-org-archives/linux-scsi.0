Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3513184DF5;
	Wed, 12 Jun 2024 20:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718224668; cv=none; b=nnjYSxVuLiXPsqEj068PXIvKvcvocNRLC5fI22Zn01BOcNCduGo9BhB6kG50Jhk7X4EO8QP1JBkvT42NQhRuEPUg8qASlMVWBEmp4H44aCY5Z3tgUi6WyyXXIpuSw15HX0lgnsUqcnQYdyHQwXSWsjzakkbvvpZNpz7cVPaPERk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718224668; c=relaxed/simple;
	bh=I9vtZK+uFJhlUDA6Aq9Yv/UiojMLeWsojGZayi8gHJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rTY9MLo2duFFiYQ0I1VYg15D3BCjf+aefkXSrx0ZzmEATBLTL9LG4f7MMWSIPEphQQdA2vdavg79HMgSLzAqCHbGAQXDuVsJBrhsVNB+oYmRAF2hUNHvt6fWi+GSxGscd0scmZmRXJy7/Y5oRDTNiYVlbbbE7os1SBw3jlTVhSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=oK1YEjXY; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="oK1YEjXY"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4Vzy623cBPz6CmR5y;
	Wed, 12 Jun 2024 20:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1718224662; x=1720816663; bh=v0Yvf
	BIqi7u4xDYwG1sC+9Zr+vG5gtgS/Rw5D0SEHGo=; b=oK1YEjXYCDxcx0aUpxFfS
	n/vVRZ3wqRk/QckmO0NrzmycOZoZqR2RQfnyqim33T3MJyuoBRqLauxCevCQ37u7
	BsfetTpcGD4ph9u6YFKJbEzlB2k7bfSVPssCwjIp3HGF4sIslObaUGKg1OgWoCQI
	TYhrPBq9FBPMhw3MAfMRmBHHKjUrGItKosDXK7P2gGFfBwIDRqIlkGF+2D9brfRJ
	G42KILdyy/RS7t7TMrwkoSpuqthyRw2CaBgxlCb9gW3HpVNcDXgaDAcMskaTqrem
	ddct6aIbrrXf/snxOOwz2VwRdzNAEl4piG9co3uqXFIV+ap6wCGTLP1fZyG7J6RK
	w==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id apDGLXOOMCJN; Wed, 12 Jun 2024 20:37:42 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4Vzy5x6nfZz6Cnk9X;
	Wed, 12 Jun 2024 20:37:41 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
	linux-scsi@vger.kernel.org,
	linux-usb@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Christoph Hellwig <hch@infradead.org>,
	Avri Altman <Avri.Altman@wdc.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v2] scsi: core: Fix an incorrect comment
Date: Wed, 12 Jun 2024 13:37:32 -0700
Message-ID: <20240612203735.4108690-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.45.2.505.gda0bf45e8d-goog
In-Reply-To: <20240612203735.4108690-1-bvanassche@acm.org>
References: <20240612203735.4108690-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

The comment that scsi_static_device_list would go away was added more
than 18 years ago. Today, that list is still there and a large number
of additional entries have been added. This shows that this comment is
incorrect. Hence fix that comment.

Cc: Christoph Hellwig <hch@infradead.org>
Cc: Avri Altman <Avri.Altman@wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---

Changes compared to v1: addressed Christoph's review feedback.

 drivers/scsi/scsi_devinfo.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index a7071e71389e..90f1393a23f8 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -39,13 +39,12 @@ static LIST_HEAD(scsi_dev_info_list);
 static char scsi_dev_flags[256];
=20
 /*
- * scsi_static_device_list: deprecated list of devices that require
- * settings that differ from the default, includes black-listed (broken)
- * devices. The entries here are added to the tail of scsi_dev_info_list
- * via scsi_dev_info_list_init.
+ * scsi_static_device_list: list of devices that require settings that d=
iffer
+ * from the default, includes black-listed (broken) devices. The entries=
 here
+ * are added to the tail of scsi_dev_info_list via scsi_dev_info_list_in=
it.
  *
- * Do not add to this list, use the command line or proc interface to ad=
d
- * to the scsi_dev_info_list. This table will eventually go away.
+ * If possible, set the BLIST_* flags from inside a SCSI LLD rather than
+ * adding an entry to this list.
  */
 static struct {
 	char *vendor;
