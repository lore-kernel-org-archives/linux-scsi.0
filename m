Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 653E8531631
	for <linux-scsi@vger.kernel.org>; Tue, 22 Sep 2026 23:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790119640; cv=none; b=u3OmR010X84gRlYj9XJefTw86Hak6ACcv5K+qUSP241EGujveSCF5g56kK0LOyGA6Xs1jcafzmh4AlA6axUpAn2v7qHK6cNzSU2g1FdZVYnq4GhkMsrESD4X3KYfsthKZhEz20UkVZt49ormmKE6AQ+ld3TkjjKAc/wySS6kkq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790119640; c=relaxed/simple;
	bh=KHULU4dlOSd6XmQijJAdcECyIn+qDTsA7nODUwQszck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CtOtPCgdK/EhxJ3QdQSE/MtCrcF/zMKH0/aWK44pBGIn/BWhB0K77Yc7o8GO8iyGFC0MenMhpqsqCZ62bjkWgLc46MyiKTQNb57oBXEB3O90j+UWdy5x67j7thuC0GOLC5rWUPhzvzp2I/U3ZQM9bb5YXRVGOBMzo29xk5j/owQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=t0gMNFjy; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="t0gMNFjy"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4hqGT6455Fzlfvpn;
	Tue, 22 Sep 2026 23:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1790119606; x=1792711607; bh=QPMlK
	TE/TM2jHdXPqSquGiR4l6O3S8RIWYD/GOzfwG0=; b=t0gMNFjyu1zEvXK4Ef7zd
	kdvo1GMnlfVCkcH50+/457tETtCWiXaDSYNwGW5EVbdcM19US4NZRQ2/LIuQvFM5
	jZhMq92iRLmTvpGKfE41/5rkrZ3eyv43dccckNA9/ETyaJJZ6kLhZQhkAbtnQ5aT
	U5zTwsD+SXad8AL49JK3CfkurTXkwYfxvspNtXjwckf18+umSet41Fh8xD29cYAd
	5BVXlkPTdvXhwjvKjIBam+P3duRXBDIKdblWDIS9JhjSTg1g9FA9ggYqyGbkDIix
	/m5JapsOv+HAA3y6Rb/HLj9KOzMyEJxwIL6KV1vQytHUxJJDeL15pv6kLevaBB4w
	A==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Uyw3rtzxiz-G; Tue, 22 Sep 2026 23:26:46 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4hqGT12f6LzlfvpG;
	Tue, 22 Sep 2026 23:26:44 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	John Garry <john.g.garry@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 3/7] scsi: scsi_debug: Split corrupt_lbas()
Date: Tue, 22 Sep 2026 16:26:23 -0700
Message-ID: <af8894f1d243ebc61862c8c207dfb5b188539972.1790119506.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
In-Reply-To: <cover.1790119506.git.bvanassche@acm.org>
References: <cover.1790119506.git.bvanassche@acm.org>
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
index a44886a4c853..fcfb49df9ee1 100644
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
+		u32 nr_bit_errors, s32 reftag_adjust)
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
