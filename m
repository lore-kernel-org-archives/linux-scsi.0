Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9296735C19B
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2026 23:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790724214; cv=none; b=IHjEDsRuFrRWMnJ6RKIsgO6RAMSiJBCu0qhkJAV0R5hZK2qfbfdD4cSmkvvWmkuRhVtJB+socUj7tmut8aWDDA46tJzhR4bb1McA+IMg/Te4BktO8zkrei2G77v3h1t2oKIpBJR593YwpXN/AAF6Z9FeqQRnVamK/67v+35tvjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790724214; c=relaxed/simple;
	bh=1us5vsfIXdsX8ojR17a8DVYPNIlkJ7ifH/gVhxQxkmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dwigp7pL2tZ7oOU3G1P0ECLWJJ0dexyCsvFfbvUaN+y8tJP6iDMH2Y9XEkYoXgPB3nJUb7wud8zTaxilx+gBVEFQvN8oGjdOdDKeYsWt65VTqFnYgpR8/NyJd1HLslHdKDyzqTkOGvzGxWC+retdjK7dR2o8FneydMCjYG1ay6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=iZE4AJ9H; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="iZE4AJ9H"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hvZ450n4Sz1XM30h;
	Tue, 29 Sep 2026 23:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1790724208; x=1793316209; bh=K0RXk
	D716CH8J+AsqGa7q0unxwTaAVtqehwda4DKopI=; b=iZE4AJ9HXmPMApsfJRWxn
	GkDtsGw8jZU+Zzt/E6791S+lyShxCSlzDc6q1EowCYlrP1uJ3A2jQT39IW0LgKBg
	mfi/K2T5rvLVOlgYAp5/R+gQcaMEEFG+hADCU+h4Ma95UAOLh+6DdBSrR+Q4mv0K
	BJ13I6cG5z/Vwg0oPDUPNWxsRj6u0NiEbuDXaY2nerZh6eZkU25h5G+D6fSdjLA3
	SFS/nx3FRAKdfsWMNoKvUGfozJnEIjX9va0D+TTU0DJg3OASMSLVjjvHjaUZ2BQz
	P8NubT3MBhkfoEHaVHG9OYqdd8xcwA4+RhRsnpdF1Q/8Y1NS23YLSdB9R2PHRGkl
	A==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 0VClFJf_Thb7; Tue, 29 Sep 2026 23:23:28 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hvZ3w72Hjz1XM5kW;
	Tue, 29 Sep 2026 23:23:24 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Christoph Hellwig <hch@lst.de>,
	John Garry <john.garry@linux.dev>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Subject: [PATCH v3 3/7] scsi: scsi_debug: Split corrupt_lbas()
Date: Tue, 29 Sep 2026 16:22:59 -0700
Message-ID: <0e54fcd159b5ec1073919eb7648042c7b258320a.1790723966.git.bvanassche@acm.org>
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

Move the inner logic of corrupt_lbas() into a new helper function
__corrupt_lbas() and call it from separate locked and unlocked branches
in corrupt_lbas(). This patch prepares for enabling context analysis.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: John Garry <john.garry@linux.dev>
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
