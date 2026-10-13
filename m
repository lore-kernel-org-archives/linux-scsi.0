Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23F99413230
	for <linux-scsi@vger.kernel.org>; Tue, 13 Oct 2026 22:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791929431; cv=none; b=oL6h4+AH78dFfo+m57UYc3ob1zIGpCU9mxg4uTVSWJNTtArhO7A2Kn2lgbMWa0T6IXlxmT2mveoFlfmP5twnbN103M6o86huDluomFmVc8BkgHvOWaX/BJsegnk2WfbDq4yKZqf/ekjMFD/r29IMX5UaVrgwv7kc7/ZuA6FcyhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791929431; c=relaxed/simple;
	bh=t1zpA4WImOAAxgjeaKqPtCejyeZvBBT/600fkuzeQ74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PTDPZOhIlJjXVdUD2zcJ6EYPoeeTr3tUX0NszrE//wn3Oyskz6JmLsdDysC/1D/VWW0l7WNy2+Y7RgCRnmaw1UUdL12on7e9WOrk5diGFcmzFtGKV3V5hr5IjQM8cd9xdNSJYk7eRdIqQ4LW+pf3AlpUiwQeljOhrnSID+b/wVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ySSkIYD6; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ySSkIYD6"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4j47nK4ffbzlfvq9;
	Tue, 13 Oct 2026 22:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1791929426; x=1794521427; bh=JDw9G
	pgNyr8q40iz/3bABpdw3HtBSBBoVVCkR+fZMao=; b=ySSkIYD6QOXDRKY17EP+V
	fY2TMZ5vCdRdCpg4ukiMTzW11QbYL4+cOLvf2CNThUxgd6x+e7VilEfxuAQ03pKw
	BWyDNBFHAXsfMyzL//6wO7qJwXjOngSoDTp/GcENJDRQRKq/WgRMxzQ6eUDhv7Ab
	9xldgt7J9ZN+VLVFh/aP4Ki0SQk2+SQ4vnjca3XwoWg5IlZd2fan7Hrj0X+FqMGQ
	oZXSCETdEoVzR/FPBPK2bcXFbMIbeIzR5Ay0sZmsmknDYw1YJlYO12UqGSppukPj
	qqqX6L4z4xxVTarbdx5lBXZjwBNS2Du99tgMYtO3Vm1Cz7veh8q2/tkE3ckl4ySo
	A==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id kiG6iWRyhn23; Tue, 13 Oct 2026 22:10:26 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (245.199.118.34.bc.googleusercontent.com [34.118.199.245])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4j47nD0wQxzlfvpT;
	Tue, 13 Oct 2026 22:10:24 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	John Garry <john.garry@linux.dev>,
	Christoph Hellwig <hch@lst.de>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v6 3/8] scsi: scsi_debug: Split corrupt_lbas()
Date: Tue, 13 Oct 2026 15:10:04 -0700
Message-ID: <fe8629d9d7d0a54e8c5c14539953b40c09a6855a.1791924924.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.56.0.176.g3575e65682-goog
In-Reply-To: <cover.1791924924.git.bvanassche@acm.org>
References: <cover.1791924924.git.bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Move the inner logic of corrupt_lbas() into a new helper function
__corrupt_lbas() and call it from separate locked and unlocked branches
in corrupt_lbas(). This patch prepares for enabling context analysis.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: John Garry <john.garry@linux.dev>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_debug.c | 42 +++++++++++++++++++++------------------
 1 file changed, 23 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index cadd94e17109..eafcadc6ef07 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -4984,37 +4984,25 @@ static int resp_write_tape(struct scsi_cmnd *scp,=
 struct sdebug_dev_info *devip)
 	return 0;
 }
=20
-static int corrupt_lbas(struct sdebug_dev_info *devip, u64 lba, u32 num,
-		u32 nr_bit_errors, s32 reftag_adjust)
+static int __corrupt_lbas(struct sdeb_store_info *sip, u64 lba, u32 num,
+			  u32 nr_bit_errors, s32 reftag_adjust, bool lbp)
 {
-	struct sdeb_store_info *sip =3D devip2sip(devip, false);
-	bool meta_data_locked =3D false;
-	bool lbp =3D scsi_debug_lbp();
 	u32 block, num_mapped, b, i;
-	int error =3D 0;
-
-	if (sdebug_dev_is_zoned(devip) || sdebug_dix || lbp) {
-		sdeb_meta_write_lock(sip);
-		meta_data_locked =3D true;
-	}
=20
 	if (!sip) {
 		pr_err("can't corrupt with fake_rw\n");
-		error =3D -EINVAL;
-		goto out_unlock;
+		return -EINVAL;
 	}
=20
 	if (num > sdebug_capacity || lba > sdebug_capacity - num) {
 		pr_err("logical blocks out of bounds: %llu:%u", lba, num);
-		error =3D -EINVAL;
-		goto out_unlock;
+		return -EINVAL;
 	}
=20
 	if (lbp && (!map_state(sip, lba, &num_mapped) || num > num_mapped)) {
 		pr_err("can't modify unmapped logical blocks: %llu:%u",
 			lba, num);
-		error =3D -EINVAL;
-		goto out_unlock;
+		return -EINVAL;
 	}
=20
 	/*
@@ -5052,9 +5040,25 @@ static int corrupt_lbas(struct sdebug_dev_info *de=
vip, u64 lba, u32 num,
 	}
 	sdeb_data_unlock(sip, false);
=20
-out_unlock:
-	if (meta_data_locked)
+	return 0;
+}
+
+static int corrupt_lbas(struct sdebug_dev_info *devip, u64 lba, u32 num,
+			u32 nr_bit_errors, s32 reftag_adjust)
+{
+	struct sdeb_store_info *sip =3D devip2sip(devip, false);
+	const bool lbp =3D scsi_debug_lbp();
+	int error =3D 0;
+
+	if (sdebug_dev_is_zoned(devip) || sdebug_dix || lbp) {
+		sdeb_meta_write_lock(sip);
+		error =3D __corrupt_lbas(sip, lba, num, nr_bit_errors,
+				       reftag_adjust, lbp);
 		sdeb_meta_write_unlock(sip);
+	} else {
+		error =3D __corrupt_lbas(sip, lba, num, nr_bit_errors,
+				       reftag_adjust, lbp);
+	}
 	return error;
 }
=20
