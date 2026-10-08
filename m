Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2544847884C
	for <linux-scsi@vger.kernel.org>; Thu,  8 Oct 2026 22:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791499365; cv=none; b=CqrjuiTbcZaPD0VfmnWqRr77YbpwX2zQfeWWYuvt4qc604fGleh0HGtvrCgXkR4Yqxy+if8Q0e4GqWQOt5tKfcKTTOTTIV9SUYpW+cXB/1BjX4427v98/2XsUUEZTZPykr1PKoZNn3reppptwsJoUhiRUINKlxv0xkAWyEN/mVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791499365; c=relaxed/simple;
	bh=t1zpA4WImOAAxgjeaKqPtCejyeZvBBT/600fkuzeQ74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qbPFaTHOc9aadz8XetpDtCTbTZ05T9xNcTFibxcqLQZRcM6gFQlqPkEgNtavw5Uuy5/63pwbHy+eVn6C2bIHCS17R24mvnXaCwqNt/Zs768/A4tF8c3uDj8UwBdW0I6xDtK910/ICUKiI8mly3KbhOq3QG9AFC3t3GYkcWfLpfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Cdc+ZC3Z; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Cdc+ZC3Z"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4j14km6GZsz1XM30w;
	Thu,  8 Oct 2026 22:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1791499357; x=1794091358; bh=JDw9G
	pgNyr8q40iz/3bABpdw3HtBSBBoVVCkR+fZMao=; b=Cdc+ZC3ZK4MUr5ajYAsIy
	nZm0Mw13tIq+VlBVRlGu2sKkhkhh8UoywJxImiVzz+4JBuAuL7sf1TwadqpvklG3
	aQ1HSUu8D0DHJwvNSAZfjRktLDMweY0bBIo9mp6Ik9agJXUY9gr2Jd1yHDF44ZyY
	wFx1O2gH4nzT/B+FFDPlNBfE/f2MFJx+w3oD5TpdbLVCX1NNBGJd7VHguSOSivj8
	pbXOstHlUbnQ25Z2Cuv36Dq8P3rtZM1S7JSQe8HmxCA18EZqITrivhT3seCOCmhR
	ImO5sWVLuY+JE3HuFk6roCModEGJOQNWR+48rYZ9j9q7JDXRqmufDhvZeHzYNCc4
	A==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id qXm6HtNv967l; Thu,  8 Oct 2026 22:42:37 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (245.199.118.34.bc.googleusercontent.com [34.118.199.245])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4j14kg5bQtz1XM30j;
	Thu,  8 Oct 2026 22:42:35 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	John Garry <john.garry@linux.dev>,
	Christoph Hellwig <hch@lst.de>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v5 3/8] scsi: scsi_debug: Split corrupt_lbas()
Date: Thu,  8 Oct 2026 15:42:14 -0700
Message-ID: <fe8629d9d7d0a54e8c5c14539953b40c09a6855a.1791499174.git.bvanassche@acm.org>
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
