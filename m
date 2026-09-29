Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 486014DDB25
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2026 23:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790724211; cv=none; b=p/uCYd5Jj8mrHVAilFRTg+O36ZyIdBAAUcKYuI0BKkHXejjU23pUcFx1PQGdjgNcneEFeHzE4nZTSY83+fPGyWwQmrenajjNstPgd5t/0DNz7Q1eeVChaiJZiFQWu8Sj43+6wbnmfba8MlAPetq5DfW6C2SWiVjLNsklEw46UjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790724211; c=relaxed/simple;
	bh=5mfNA12SCJvAY6CRjJeGiEt8yT2ELRINciEhcfVij7k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GgkNWFXRlGrYvvpFp+8hc2yQXXOMO5Zelo7veOCUjcsfLRD5J2lWQYvHLcJ6g7vNRhsN3TB/f1g6msRMesuFXVUVOBHWfudCSAyOKAjCXm6Ha3waocn5p1mNUa/y78lIRDXk7Ey0pwrPtUJAxxepO7lcn5ZogJwJWaCl5ZgEVkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Zqr0bVmM; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Zqr0bVmM"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hvZ415hd6z1XM5kD;
	Tue, 29 Sep 2026 23:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1790724204; x=1793316205; bh=HLJ3+
	+bq25OIry03q6sxCsba7ynSWdTw5q81qzFEOJE=; b=Zqr0bVmMfUhAnU0m32Z7m
	FxLh1oOeelaCXdFeCkgGWXDpsJYnmef2GTl34iXhjuY+lmbi/9zJ70CPtBowpL4L
	YgI6tlkRFc5A/coDPMUwt8dARCcx5WphUqK/A10mFpVa6GseD2YSspO1CUkAG83z
	lACA+xR3Sxp1XCtIiTnsnuKHEJWPcuznSitwrxAa6ZokHahDHq9Gk5VWFxF0w+o8
	dQY7DAUhIAA7UbiyB866fXg8xoSgRuDfjrnkFDD7S7MFg9CrsQoD00qo8mfTCknt
	N0Gp8m1HMD5/iajpr8TDmeODaIc+SoSBnf+3lHcZMcFXwAgsbIy65KjlKgkU5cvU
	g==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 2OdgtWOn-__h; Tue, 29 Sep 2026 23:23:24 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hvZ3s57nJz1XM4Sx;
	Tue, 29 Sep 2026 23:23:21 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Christoph Hellwig <hch@lst.de>,
	John Garry <john.garry@linux.dev>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH v3 2/7] scsi: scsi_debug: Split resp_write_same()
Date: Tue, 29 Sep 2026 16:22:58 -0700
Message-ID: <3745a99e44c3141431ae0d0760fb968323dd6e1d.1790723966.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
In-Reply-To: <cover.1790723966.git.bvanassche@acm.org>
References: <cover.1790723966.git.bvanassche@acm.org>
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
 drivers/scsi/scsi_debug.c | 34 ++++++++++++++++++++++------------
 1 file changed, 22 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index ed8d69f305f8..d0d2cbac487b 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -5360,8 +5360,8 @@ static int resp_write_scat(struct scsi_cmnd *scp,
 	return ret;
 }
=20
-static int resp_write_same(struct scsi_cmnd *scp, u64 lba, u32 num,
-			   u32 ei_lba, bool unmap, bool ndob)
+static int __resp_write_same(struct scsi_cmnd *scp, u64 lba, u32 num,
+			     u32 ei_lba, bool unmap, bool ndob)
 {
 	struct scsi_device *sdp =3D scp->device;
 	struct sdebug_dev_info *devip =3D (struct sdebug_dev_info *)sdp->hostda=
ta;
@@ -5373,20 +5373,14 @@ static int resp_write_same(struct scsi_cmnd *scp,=
 u64 lba, u32 num,
 						scp->device->hostdata, true);
 	u8 *fs1p;
 	u8 *fsp;
-	bool meta_data_locked =3D false;
-
-	if (sdebug_dev_is_zoned(devip) || scsi_debug_lbp()) {
-		sdeb_meta_write_lock(sip);
-		meta_data_locked =3D true;
-	}
=20
 	ret =3D check_device_access_params(scp, lba, num, true);
 	if (ret)
-		goto out;
+		return ret;
=20
 	if (unmap && scsi_debug_lbp()) {
 		unmap_region(sip, lba, num);
-		goto out;
+		return ret;
 	}
 	lbaa =3D lba;
 	block =3D do_div(lbaa, sdebug_store_sectors);
@@ -5422,9 +5416,25 @@ static int resp_write_same(struct scsi_cmnd *scp, =
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
+	int ret;
+
+	if (sdebug_dev_is_zoned(devip) || scsi_debug_lbp()) {
+		sdeb_meta_write_lock(sip);
+		ret =3D __resp_write_same(scp, lba, num, ei_lba, unmap, ndob);
 		sdeb_meta_write_unlock(sip);
+	} else {
+		ret =3D __resp_write_same(scp, lba, num, ei_lba, unmap, ndob);
+	}
+
 	return ret;
 }
=20
