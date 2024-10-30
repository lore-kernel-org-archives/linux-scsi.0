Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [96.44.175.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2BDA1E22FF;
	Wed, 30 Oct 2024 10:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=96.44.175.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730285886; cv=none; b=EU7i660KB1+U9GcokaCm7EagaAHMD9+cgGOWD9qBWlAw6gHDMLYry2DSLZ/HxPSdVUVQ79603gGiJ7SboGsaXsL6qfAA7LVB93JY2LqW4ivBqs4o/i2FRH/kDGTZ8WhF6YsGvn9+4dPE68kv78JSuG+8XRftjiyAflLItLN/ylQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730285886; c=relaxed/simple;
	bh=LU89oiIC9/VWlU3cPF95wh6+bbcGtwdZ1Mg192tt/7M=;
	h=Message-ID:Subject:From:To:Cc:Date:Content-Type:MIME-Version; b=j+IbwqcsIsMh30yhqtH0fxMoArpOlh+KV1JNjSyMuOBnor/EqLawDL+PFB5thbt5rPU495CbHiV3O3vsAxp0KJuAKFcUxKyItQOkh92sSwHK9B9ees538JQOp7J97Mt3isi+1mScBX1w3xagdY6b0M5Ak6pJupzfE5GQXSqSWI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=JoH7eWQm; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=XI0R4ZDp; arc=none smtp.client-ip=96.44.175.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="JoH7eWQm";
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="XI0R4ZDp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1730285883;
	bh=LU89oiIC9/VWlU3cPF95wh6+bbcGtwdZ1Mg192tt/7M=;
	h=Message-ID:Subject:From:To:Date:From;
	b=JoH7eWQmloNFjJ4oYH3ea8cZl7eautQ6o5ns8wfF8+F3SRgpG7N/Mb2Zi5axrM/Qv
	 WlrhOi0x0Eq2oI96h/bnoC1J/hGSzd+2RyY5bUEQesu7EhlcUrNAGW2joXnSdOqq0B
	 L90bC9gaYFSaDE46g42yxyngn7kiGHTK/l107k+0=
Received: from localhost (localhost [127.0.0.1])
	by bedivere.hansenpartnership.com (Postfix) with ESMTP id 0749812819B1;
	Wed, 30 Oct 2024 06:58:03 -0400 (EDT)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
 by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavis, port 10024)
 with ESMTP id MHCH1RQ-0XkO; Wed, 30 Oct 2024 06:58:02 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1730285882;
	bh=LU89oiIC9/VWlU3cPF95wh6+bbcGtwdZ1Mg192tt/7M=;
	h=Message-ID:Subject:From:To:Date:From;
	b=XI0R4ZDpotmSSS3DcuBtn0+8hQBC0qz5aECa0qun3czMKT5nZXH0rA2GblZBE3J9B
	 PYOOc5pfgOK+SGdsVF+TrF4ztlzARPlrcP1Op6P0ily8JlqtRaaDqIwHbEe0nzzLen
	 Lt9HNjM84L+w3Ptny25EnCn9twF6h9gsy1PD7Tz8=
Received: from [10.250.250.46] (122x212x32x58.ap122.ftth.ucom.ne.jp [122.212.32.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 17DC812811B1;
	Wed, 30 Oct 2024 06:58:01 -0400 (EDT)
Message-ID: <c82f3c57c5febcefdc95cf4a0b8eff0cdf4689a1.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 6.12-rc5
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds
	 <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel
	 <linux-kernel@vger.kernel.org>
Date: Wed, 30 Oct 2024 19:57:59 +0900
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

Two small fixes, both in drivers (ufs and scsi_debug).

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

John Garry (1):
      scsi: scsi_debug: Fix do_device_access() handling of unexpected SG copy length

Peter Wang (1):
      scsi: ufs: core: Fix another deadlock during RTC update

And the diffstat:

 drivers/scsi/scsi_debug.c | 10 ++++------
 drivers/ufs/core/ufshcd.c |  2 +-
 2 files changed, 5 insertions(+), 7 deletions(-)

with full diff below.

James

---

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index d95f417e24c0..9be2a6a00530 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -3651,7 +3651,7 @@ static int do_device_access(struct sdeb_store_info *sip, struct scsi_cmnd *scp,
 	enum dma_data_direction dir;
 	struct scsi_data_buffer *sdb = &scp->sdb;
 	u8 *fsp;
-	int i;
+	int i, total = 0;
 
 	/*
 	 * Even though reads are inherently atomic (in this driver), we expect
@@ -3688,18 +3688,16 @@ static int do_device_access(struct sdeb_store_info *sip, struct scsi_cmnd *scp,
 		   fsp + (block * sdebug_sector_size),
 		   sdebug_sector_size, sg_skip, do_write);
 		sdeb_data_sector_unlock(sip, do_write);
-		if (ret != sdebug_sector_size) {
-			ret += (i * sdebug_sector_size);
+		total += ret;
+		if (ret != sdebug_sector_size)
 			break;
-		}
 		sg_skip += sdebug_sector_size;
 		if (++block >= sdebug_store_sectors)
 			block = 0;
 	}
-	ret = num * sdebug_sector_size;
 	sdeb_data_unlock(sip, atomic);
 
-	return ret;
+	return total;
 }
 
 /* Returns number of bytes copied or -1 if error. */
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 706dc81eb924..0e22bbb78239 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8219,7 +8219,7 @@ static void ufshcd_update_rtc(struct ufs_hba *hba)
 
 	err = ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_WRITE_ATTR, QUERY_ATTR_IDN_SECONDS_PASSED,
 				0, 0, &val);
-	ufshcd_rpm_put_sync(hba);
+	ufshcd_rpm_put(hba);
 
 	if (err)
 		dev_err(hba->dev, "%s: Failed to update rtc %d\n", __func__, err);

