Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBB56371D1F
	for <linux-scsi@vger.kernel.org>; Thu, 24 Sep 2026 22:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790290504; cv=none; b=q6zxYRGDKfRuoho8ctKfxTp+lcJhqnSV3YP0aTZC42bAdYu3w4L5u5q6oYZNUPNP09A9wOuu9OB11gY0Wk4EqK4DJcVXC4SBgoDKsQRpqLGTHFJQBGoi0hIGfLSDs8BTPv3cixUfhTG9PEFkkg1K9JZVVVPzx+FcbINR9zmZksc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790290504; c=relaxed/simple;
	bh=m1w+ly0pyYLWD73B1YpLrQsXciuA081eoUDb+e+KSQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bdm7Nl2gpb5Pin3JercU6N0KRSbtkJgTFKnygQvMd1Xf6ohFafLF33s0BWYAZnNn3x8+2Mg4qy1vEiW8fKWu2XvPOe4E1FFEg7TctlbacfJ1yTlO4vO0+qO0q6cBP6APP+AOdimdWPOQCA8CB4uvo0SBsqSV5Qia4ZJ2vSyZXIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Yet8ihRu; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Yet8ihRu"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4hrTgV3BphzlfvpS;
	Thu, 24 Sep 2026 22:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1790290498; x=1792882499; bh=unnrb
	eow9GLZbfB797ByFeCCWfJ0OPbFK1BXLlNLcXo=; b=Yet8ihRu54EfMw43X//IC
	1jyWi8i56oYDw0AY+dg2twcUnJBuXvzMVNtWJZ5wwtniZOg0kYJJe/e48ZViFBdp
	D71dxFkd13QtQrq5P+djoZeMUjPDdHO23gAFCXXdB1Kdvh04hq/un6GHSIb5E/wr
	9wOvInvGUmcrFPHDJnu3r5c7WcuTsb6iw+XegMPnkKV1amaTfYhMzQmdMcyeA1sy
	1Vb34PSvpST5HWAcDnDcvvA0LCm2urEo1Wv04wkuUSSjbq+dIi2podtuvDldUfYv
	b6ICHp5oPCXJPwNrp+71aaJoMS/GZ9KFyHqwSUhSxF+EJEcQJOIuFpb7TrqVRjPn
	w==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id wX-1bVvt4Y0K; Thu, 24 Sep 2026 22:54:58 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4hrTgP0zY7zlfvpN;
	Thu, 24 Sep 2026 22:54:56 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	John Garry <john.g.garry@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 2/7] scsi: scsi_debug: Split resp_write_same()
Date: Thu, 24 Sep 2026 15:54:38 -0700
Message-ID: <20122153e730550db9b05401ed14d0a8a20d4773.1790290090.git.bvanassche@acm.org>
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

Since the Clang thread-safety analyzer does not support conditional
locking, split the function resp_write_same() such that all locking
statements end up in the same branch of an if-statement.

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
