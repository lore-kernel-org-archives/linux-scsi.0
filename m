Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 254E947C100
	for <linux-scsi@vger.kernel.org>; Thu,  8 Oct 2026 22:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791499366; cv=none; b=fbYMOLSzqVWXIqbpNzoeSEvn5QOKwE8L/hok/41cRw5ocvuhBZ15F91ntnNn53EXK20Ywunc2jzmqsi4KbaYj2gkvpGUPoFYKet96RHIuuPsgB8Hf17d8OlL5m4R3q9hiq3TYoEOBTVl46LQHyI9KRC71dPSKCcC6DysZsycsxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791499366; c=relaxed/simple;
	bh=IG3+EczdlkdGMUf+J2u8OxNOe51/4CDkNyGrEYRYaXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Djc3oNgDMO+q981eYUYqpPYyL9lMqqQiuC6Sfdw1NWapQJeI83QjH70C5hQ5WbSlCpaKA1PsjOilLBaM0Uy2YoUQIbmGbYj+3nMO4DRd5rrsd3UI5M1keYRM3ZNFo9t5xk/IHphO+2WaI5BhShZ8c3k4IBhU10vNZ5Apy4jC5mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=GCtgc316; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="GCtgc316"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4j14kl5gfFz1XM30n;
	Thu,  8 Oct 2026 22:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1791499356; x=1794091357; bh=1fIlY
	C4aOeGa49nJDKJisVYBGR/0rATwxkMZCXgVu+4=; b=GCtgc316rXAMlyZL0ZD0j
	QAQ+02qBj1Wy7AWjBC9JOvP5nk3kPnwYJwh0xY8iZVqylR1xhZI12oi2b5qE51Vh
	v25aDPiqwFNSvnpqQUGwx9F+pD77nQ7auhA/vRVOztQVLSz2JoaOuXSi2KVoA7p1
	+/MubkLsdEpIPdzaqHtrBeWF+v2jQQBIi0/p/b83g05n24vaGKfjlwEPrdttSkN9
	8uIWT6Ej4zFPuo4kExy+3UK9FwS5/xLAVgOEWJTBchUy4I+IcL1RFj1sAAHyJMwP
	fSikpfrDomS9X6XYR+nRFXHlkrnl3lXHHb33vTspYqMkGCINrImWJeigUibWlaWA
	g==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id d_ECSNcr4VnG; Thu,  8 Oct 2026 22:42:36 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (245.199.118.34.bc.googleusercontent.com [34.118.199.245])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4j14kd5dwwz1XM30h;
	Thu,  8 Oct 2026 22:42:33 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	John Garry <john.garry@linux.dev>,
	Christoph Hellwig <hch@lst.de>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v5 2/8] scsi: scsi_debug: Split resp_write_same()
Date: Thu,  8 Oct 2026 15:42:13 -0700
Message-ID: <1127ce1be450f0c4503845b41eaa24c27aba373a.1791499174.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.56.0.170.g584c36229d-goog
In-Reply-To: <cover.1791499174.git.bvanassche@acm.org>
References: <cover.1791499174.git.bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Since the Clang thread-safety analyzer does not support conditional
locking, split the function resp_write_same() such that all locking
statements end up in the same branch of an if-statement.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: John Garry <john.garry@linux.dev>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_debug.c | 38 +++++++++++++++++++++++++-------------
 1 file changed, 25 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 44b4587b53c6..cadd94e17109 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -5412,8 +5412,8 @@ static int resp_write_scat(struct scsi_cmnd *scp,
 	return ret;
 }
=20
-static int resp_write_same(struct scsi_cmnd *scp, u64 lba, u32 num,
-			   u32 ei_lba, bool unmap, bool ndob)
+static int __resp_write_same(struct scsi_cmnd *scp, u64 lba, u32 num,
+			     u32 ei_lba, bool unmap, bool ndob, bool lbp)
 {
 	struct scsi_device *sdp =3D scp->device;
 	struct sdebug_dev_info *devip =3D (struct sdebug_dev_info *)sdp->hostda=
ta;
@@ -5425,21 +5425,14 @@ static int resp_write_same(struct scsi_cmnd *scp,=
 u64 lba, u32 num,
 						scp->device->hostdata, true);
 	u8 *fs1p;
 	u8 *fsp;
-	bool meta_data_locked =3D false;
-	bool lbp =3D scsi_debug_lbp();
-
-	if (sdebug_dev_is_zoned(devip) || lbp) {
-		sdeb_meta_write_lock(sip);
-		meta_data_locked =3D true;
-	}
=20
 	ret =3D check_device_access_params(scp, lba, num, true);
 	if (ret)
-		goto out;
+		return ret;
=20
 	if (unmap && lbp) {
 		unmap_region(sip, lba, num);
-		goto out;
+		return ret;
 	}
 	lbaa =3D lba;
 	block =3D do_div(lbaa, sdebug_store_sectors);
@@ -5475,9 +5468,28 @@ static int resp_write_same(struct scsi_cmnd *scp, =
u64 lba, u32 num,
 	ret =3D 0;
 unlock:
 	sdeb_data_write_unlock(sip);
-out:
-	if (meta_data_locked)
+	return ret;
+}
+
+static int resp_write_same(struct scsi_cmnd *scp, u64 lba, u32 num, u32 =
ei_lba,
+			   bool unmap, bool ndob)
+{
+	struct scsi_device *sdp =3D scp->device;
+	struct sdebug_dev_info *devip =3D sdp->hostdata;
+	struct sdeb_store_info *sip =3D devip2sip(devip, true);
+	const bool lbp =3D scsi_debug_lbp();
+	int ret;
+
+	if (sdebug_dev_is_zoned(devip) || lbp) {
+		sdeb_meta_write_lock(sip);
+		ret =3D __resp_write_same(scp, lba, num, ei_lba, unmap, ndob,
+					lbp);
 		sdeb_meta_write_unlock(sip);
+	} else {
+		ret =3D __resp_write_same(scp, lba, num, ei_lba, unmap, ndob,
+					lbp);
+	}
+
 	return ret;
 }
=20
