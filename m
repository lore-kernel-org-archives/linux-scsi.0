Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEB7D425872
	for <linux-scsi@vger.kernel.org>; Tue, 22 Sep 2026 23:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790119631; cv=none; b=n8qhcmMFlmX0Tr9tRO+MX/+jkHDIc2+L51O5CKI1R9jRuIIpIKnaeVjb6zIx76O+SmMeca+NIhYSMUpLvk+8beQmzjWs+1SR9W32WNCaCAmoYFNC3jr+Z2ux9uK6pm31shnXQkZZ0Q7pJrwqBMq+xEK5aRLdOGEoIHmaBKbj2gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790119631; c=relaxed/simple;
	bh=RBSi75hFcm0GDhHWvGB8HHfU60Tg+CyTh3W4xzAYK0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KVmjGWJJgk2IYqLthiYYlz54KD0D6OlJdH0OGp54J9SgjjW9SgySlPcwdGv7VQcs4orqMKaIjZ1oaUYYkYEcADz4fM+Q4uoVhKKVkavBLFf6kXWBHMRgyGaAnJXEl4aYZCDRq/WHcdlqCUP8uX/OC4gyuywG633T6JpGXv+eeW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=pGWokmxb; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="pGWokmxb"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4hqGT43qkmzlfvpb;
	Tue, 22 Sep 2026 23:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1790119604; x=1792711605; bh=hG9uu
	89f0AsG+qARpx+5qc2IPRAVwbrMAeX0NSM+J94=; b=pGWokmxbrY3UFMyCut0K/
	GnOFVMv7Ki2X69vGMaJX/yJWMl0qGca66OwdU8YFUqD8RoAi4YqnBvh9w1A6htGe
	hpzVXkp7Aupmd+GiagPgVkXB8GpTCCiSarMsp9Rcms7oyL4f6T21fs8CoAbkOheM
	uFRVBMo+02cClfAoAEN4V3GfIivWfYrp1dEGoJ6zDRRTELKDcbMQpenb9ZIk6NXf
	soBfrd52Sc67GFo+QTjmg5+krd0m6oOfhl+9yG0yhhhQX3hwDJYNK7f7PBRcYzVH
	c/Z7EI3XH1/5ZsxHPLocxxs+fdild1giDrkkZW+GbLYitorLp87aMMlNDXy2vlKW
	w==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id i20vipT1OV97; Tue, 22 Sep 2026 23:26:44 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4hqGSz2ZF8zlfvpN;
	Tue, 22 Sep 2026 23:26:42 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	John Garry <john.g.garry@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 2/7] scsi: scsi_debug: Split resp_write_same()
Date: Tue, 22 Sep 2026 16:26:22 -0700
Message-ID: <ffc8a3e12ea887344ed6529de190235944f87b45.1790119506.git.bvanassche@acm.org>
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

Since the Clang thread-safety analyzer does not support conditional
locking, split the function resp_write_same() such that all locking
statements end up in the same branch of an if-statement.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_debug.c | 39 ++++++++++++++++++++++++---------------
 1 file changed, 24 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index b854102e6caa..a44886a4c853 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -5360,33 +5360,26 @@ static int resp_write_scat(struct scsi_cmnd *scp,
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
+	struct sdeb_store_info *sip =3D devip2sip(devip, true);
+	u32 lb_size =3D sdebug_sector_size;
 	unsigned long long i;
 	u64 block, lbaa;
-	u32 lb_size =3D sdebug_sector_size;
 	int ret;
-	struct sdeb_store_info *sip =3D devip2sip((struct sdebug_dev_info *)
-						scp->device->hostdata, true);
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
@@ -5422,9 +5415,25 @@ static int resp_write_same(struct scsi_cmnd *scp, =
u64 lba, u32 num,
 unlock:
 	sdeb_data_write_unlock(sip);
 	ret =3D 0;
-out:
-	if (meta_data_locked)
+	return ret;
+}
+
+static int resp_write_same(struct scsi_cmnd *scp, u64 lba, u32 num,
+			   u32 ei_lba, bool unmap, bool ndob)
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
