Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AB4E35C19B
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2026 23:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790724210; cv=none; b=iB6AzglHK6mHx4GPXpP3Ri78rrdgeROW8QlziP4KNS6if56kwrsTspxMc1yVBJfQaRZax8WUJzROtXBWOu1Uu9rlQmVA1vxV6n4TKCr0DEojAQwz3b50UT33usGyrxfZul7LIqrEnSEVdHnfcmxtPdbbs5LQ9pFSep7oNiveiPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790724210; c=relaxed/simple;
	bh=YfaoJaeqaLrPi7WRwwcj/r/iTOaLWko9hr6IUDswtxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nY2QDU3jSO9gNNt7Be3eb5I8RQNtHsG504yGHRonyvQzsqGQT2lJisKz5zPiyJ7O2BaVt+5WGTIMF9ZkOHV6n8FQwTaICugiDqE+Dkf68+l3CRXaTZgnBX6hg7Aa4oi0lGKDPYahreQjMwHKZOtrStcjr2/AVuYmxvxO4ExIJbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=36F3yBLh; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="36F3yBLh"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hvZ40070Hz1XM5kt;
	Tue, 29 Sep 2026 23:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1790724201; x=1793316202; bh=Ps9AK
	qCLMKctqcsDXb1hekw8lOYRgQjqJIF24FtviH4=; b=36F3yBLhXXLRp0BvyDqiD
	N6akNcWy8g8YF6DeEqZWlpe/TxeElt/gybeCMv+EY6WYABVx3FBLG3sF7lSOvYGU
	ah433shE3D5xxuXZ2g3TM/dlV20IdXGEKRTXcKExHqd8yBhMd5kzSo5ahOpsYDDp
	TCwXI8W08pYdwR8Ea3f3rIg8WLxELUqcGCUt1Pn8XqfO+gq/xCW5lfCP5n48fPV7
	7BizJbEH2ClMFNJxN9OsmObiRehs749hZ/tAdoqeqmdMMsvZ/x15nfeKDQDJidXL
	ZBi8v78VZufjzuk+DdeY6ezPaTE5iuRmH3LGZcAMHqy3Pne9IHlFFF2cDoiwb5ja
	A==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id KDe81gxs9nH7; Tue, 29 Sep 2026 23:23:21 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hvZ3n0BH3z1XM5kD;
	Tue, 29 Sep 2026 23:23:16 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Christoph Hellwig <hch@lst.de>,
	John Garry <john.garry@linux.dev>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Luis Chamberlain <mcgrof@kernel.org>,
	John Garry <john.g.garry@oracle.com>
Subject: [PATCH v3 1/7] scsi: scsi_debug: Fix a locking bug in resp_write_same()
Date: Tue, 29 Sep 2026 16:22:57 -0700
Message-ID: <d1b6d3041dab4496ad46e51846c24b722961a839.1790723966.git.bvanassche@acm.org>
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

If fetch_to_dev_buffer() fails in resp_write_same(), the function jumps
to 'out' without releasing the data write lock acquired earlier via
sdeb_data_write_lock(). Jump to 'unlock' instead so that
sdeb_data_write_unlock() is called on the error path. This bug has been
discovered by building the scsi_debug driver with Clang and modified
lock context annotations. The modified lock context annotations are
available in patch "scsi: scsi_debug: Improve lock context annotations".

Fixes: 84f3a3c01d70 ("scsi: scsi_debug: Atomic write support")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: John Garry <john.garry@linux.dev>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_debug.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 6941809dfdb7..ed8d69f305f8 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -5402,7 +5402,7 @@ static int resp_write_same(struct scsi_cmnd *scp, u=
64 lba, u32 num,
=20
 	if (-1 =3D=3D ret) {
 		ret =3D DID_ERROR << 16;
-		goto out;
+		goto unlock;
 	} else if (sdebug_verbose && !ndob && (ret < lb_size))
 		sdev_printk(KERN_INFO, scp->device,
 			    "%s: %s: lb size=3D%u, IO sent=3D%d bytes\n",
@@ -5419,8 +5419,9 @@ static int resp_write_same(struct scsi_cmnd *scp, u=
64 lba, u32 num,
 	/* If ZBC zone then bump its write pointer */
 	if (sdebug_dev_is_zoned(devip))
 		zbc_inc_wp(devip, lba, num);
-	sdeb_data_write_unlock(sip);
 	ret =3D 0;
+unlock:
+	sdeb_data_write_unlock(sip);
 out:
 	if (meta_data_locked)
 		sdeb_meta_write_unlock(sip);
