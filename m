Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53FB6560AC7
	for <linux-scsi@vger.kernel.org>; Tue, 13 Oct 2026 22:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791929436; cv=none; b=hL6yNBXhDDNzVwYN48hF4ZLYQ5iRFRqRzNVN6UipgQ4bvg9bj2CLZnEKIeboXgCE1N2gKQz67a+pgBujPm35l38EzUZDii41O7dxTBGEAoS1P1Wqbvecl+IAOzFXg8VKFKO7tqZ+ofYXaF9/SVqRFKyKMRIXZmLOkpi1gysv31I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791929436; c=relaxed/simple;
	bh=G/URgl99uAXiywz5oyl3ke9XAIbm/jzCYSmMVmGP3NQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Th1wVCx9FbrlzZaiHpnC4794GY2odAd5VRiMDpWfb2ZDy5lHBr0QR6QBnXQvtASEHcU3nIywP8oOsB/c/QGskNj492gstaklvzULdHoxALc2nx0xK0AIzYvn/x4DG7ZeKFcECUz9mFruNJOVsu1Yf3spI0mQgNr523Yc+E3KHwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=WWrTR15o; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="WWrTR15o"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4j47nN1FqrzlfvpW;
	Tue, 13 Oct 2026 22:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1791929429; x=1794521430; bh=9klLS
	cWxFkTUh2hMFkUUNk868KQRhV+mZ/XWTZ8ovj4=; b=WWrTR15okf3uz9yWAu8+i
	iy1WQHgcqZIBmLRdJGyJkFaeQbvjZ3gXPhyuVZLGiA7fKXm/GVRj1T6Wdi4pa8Nt
	gky0TeBdHA0NpLnqcmfETV9RawRm0oRA9R3110c/tjXGY75hSR8shwMI8ueV2fx4
	T3WNeXM7xe1JF20kaRtdp5x/3cifIk7fiVvL3MbQsaMrlFjwItXPrw+5ypRM8Sry
	7lH+5RpvGMZGVfGBLtDgbyQ8EmkYy8KfPPlRtyGNaQd3OmmQDMWW95AKYCbv3Drk
	eHRJs/WmQE1ixmC0JdAGYmaWEbsyAuZoGvYIxMdGw+gFgOtq53aukUNh/gaWcyTi
	Q==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 3Zli2yfZ1w9o; Tue, 13 Oct 2026 22:10:29 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (245.199.118.34.bc.googleusercontent.com [34.118.199.245])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4j47nF4LpKzlfvq2;
	Tue, 13 Oct 2026 22:10:25 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	John Garry <john.garry@linux.dev>,
	Christoph Hellwig <hch@lst.de>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v6 6/8] scsi: scsi_debug: Split resp_atomic_write()
Date: Tue, 13 Oct 2026 15:10:07 -0700
Message-ID: <bd623851c07c80b3f1bff493e66dc268656e9883.1791924924.git.bvanassche@acm.org>
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

Prepare for enabling lock context analysis by eliminating conditional
locking.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_debug.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 98e4ffaa8b06..cfe6bd154e8d 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -6352,16 +6352,16 @@ static int resp_atomic_write(struct scsi_cmnd *sc=
p,
 	if (scsi_bufflen(scp) < len * sdebug_sector_size)
 		return DID_ERROR << 16;
=20
-	if (lbp)
-		sdeb_meta_write_lock(sip);
-
-	ret =3D do_device_access(sip, scp, 0, lba, len, 0, true, true);
 	if (lbp) {
+		sdeb_meta_write_lock(sip);
+		ret =3D do_device_access(sip, scp, 0, lba, len, 0, true, true);
 		map_region(sip, lba, len);
 		sdeb_meta_write_unlock(sip);
+	} else {
+		ret =3D do_device_access(sip, scp, 0, lba, len, 0, true, true);
 	}
=20
-	if (unlikely(ret =3D=3D -1))
+	if (unlikely(ret < 0))
 		return DID_ERROR << 16;
 	if (unlikely(ret !=3D len * sdebug_sector_size))
 		return DID_ERROR << 16;
