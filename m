Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BE79371D1F
	for <linux-scsi@vger.kernel.org>; Thu, 24 Sep 2026 22:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790290506; cv=none; b=bX9izR8v1snln7vnp0jgLIcYPh58eWdoUm6b+403/OySaEL3gg4F5nM2xj7JG0LkwNM7OwHsKQeMFYnZwxZCCjT52Pb4Vq7QCx7P36OxNEiCXt26b7q0V7lVWrXxvnxVdAJ1KeAVY/DTGkDaLQFG8kLBxImFdHKoTnCFCePupNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790290506; c=relaxed/simple;
	bh=GMiwsnHmevpGF4RFlkRweyPmS/OvXkMv2aJAXCwHbic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=slp5ur+64Rt6BwaQaZq8D/GcsXlIbQolsaqAaSZ+lqmii2ZkDtQuY2X/uNwPLulA6ZqyC2qxpt/quyZpGW14qg2b/dfwVpr/miEWP6T8ncwd55Rmmc0ae+B1h+zaWIfLCE/dL5eXMqQE0yyxpOrmulq4xEdQA4TZCKTMUEjR+qQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=MoaLXx4h; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="MoaLXx4h"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4hrTgX6K8jzlfvpS;
	Thu, 24 Sep 2026 22:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1790290500; x=1792882501; bh=zqUk+
	F9B2sJd0nJHUkmZXz59fHfdlZbjlg9Dka9Bg4I=; b=MoaLXx4hyJ26At+8DV/S9
	sCocm4D+kmPe5BkX9UrKvvhliLiH8X/RYRA1f9jfs33ElN1Wuka0Yu0Dluz3/Aci
	riTkMZq3VNmAe0OjCCiHTyhyDbujDTq008Tm7zOb2uaTHbqukBwzVkwna0x8R8N9
	zvJPqLZRv3HLc9Rlr+drjXboAyFG0bWt24Rqo6nnd7J4uXiJGds8dXSPnj8Zo/U+
	gIC6L+9y0On+4MYEvNJpCRU/BvEWID6THdrkX2Xqx4SLYGEBcBdDyDf3LZxjJvbr
	foUG1yoLIQfQNXU0H5hSZOl3cdxhGqVZO/xq/7QAAlcWR4QoHIt+dAd3dsQbprE0
	w==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ehLPwFcyZcUN; Thu, 24 Sep 2026 22:55:00 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4hrTgR1Lx6zlfvpG;
	Thu, 24 Sep 2026 22:54:58 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	John Garry <john.g.garry@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 3/7] scsi: scsi_debug: Split corrupt_lbas()
Date: Thu, 24 Sep 2026 15:54:39 -0700
Message-ID: <9484940ad7bb464786c9f52211129015ce8ec006.1790290090.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
In-Reply-To: <cover.1790290089.git.bvanassche@acm.org>
References: <cover.1790290089.git.bvanassche@acm.org>
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

Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_debug.c | 42 ++++++++++++++++++++-------------------
 1 file changed, 22 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index d0d2cbac487b..0f4637d1265a 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -4948,39 +4948,26 @@ static int resp_write_tape(struct scsi_cmnd *scp,=
 struct sdebug_dev_info *devip)
 	return 0;
 }
=20
-static int corrupt_lbas(struct sdebug_dev_info *devip, u64 lba, u32 num,
-		u32 nr_bit_errors, s32 reftag_adjust)
+static int __corrupt_lbas(struct sdeb_store_info *sip, u64 lba, u32 num,
+			  u32 nr_bit_errors, s32 reftag_adjust)
 {
-	struct sdeb_store_info *sip =3D devip2sip(devip, false);
-	bool meta_data_locked =3D false;
 	u32 block, num_mapped, b, i;
-	int error =3D 0;
-
-	if (sdebug_dev_is_zoned(devip) ||
-	    sdebug_dix ||
-	    scsi_debug_lbp())  {
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
 	if (scsi_debug_lbp() &&
 	    (!map_state(sip, lba, &num_mapped) || num > num_mapped)) {
 		pr_err("can't modify unmapped logical blocks: %llu:%u",
 			lba, num);
-		error =3D -EINVAL;
-		goto out_unlock;
+		return -EINVAL;
 	}
=20
 	/*
@@ -5018,9 +5005,24 @@ static int corrupt_lbas(struct sdebug_dev_info *de=
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
+	int error;
+
+	if (sdebug_dev_is_zoned(devip) || sdebug_dix || scsi_debug_lbp()) {
+		sdeb_meta_write_lock(sip);
+		error =3D __corrupt_lbas(sip, lba, num, nr_bit_errors,
+				       reftag_adjust);
 		sdeb_meta_write_unlock(sip);
+	} else {
+		error =3D __corrupt_lbas(sip, lba, num, nr_bit_errors,
+				       reftag_adjust);
+	}
 	return error;
 }
=20
