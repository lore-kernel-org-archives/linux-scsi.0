Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0C0449BD93
	for <linux-scsi@vger.kernel.org>; Tue, 22 Sep 2026 23:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790119631; cv=none; b=TXpU7G7gaJ5A3w9zfTv7FszFTrD/QEEBUONMKQNBHPgXXixzfDvJoSxIwmGQ0KpraLBk697GKNvYpTq+Xq+64Csjgjc7zrh19XqJATMWHGCaMU0JuKnocuGxysLmuYoKy2/0xRiF5E6N7O64TLjUs88nzcBfXbrGCK4pXjcl6vI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790119631; c=relaxed/simple;
	bh=bPYBcPao+DUsS6wP+Lk9GQR7UduMvT7rT94dBuqHauY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mvfsiq+pIif62bx7kWhl/712E4h1lIAV3Cwy2zqJw9fhmUlLhRuNWHIJW0jthbCdCbozeaXV3sR1mk33jrEgR/ZXpWD1N0KlR7dHMzv5PEbSIDK6YUshlU/i1i+MrCmWZLOHYUyB94nC9Ccx3g/1NKAtLEi+JzYsxjonm6GIvqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=HweBAOxV; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="HweBAOxV"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4hqGT16DSBzlfvpW;
	Tue, 22 Sep 2026 23:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1790119602; x=1792711603; bh=V7/nH
	5pexFPYbgJla4cSaxXXNUSQEh+88kcIqdTqiSo=; b=HweBAOxVWKaGSXRK433Hf
	zVQdllE5O0VfIzSrf0UMcgBKVc84YcyT6GeCdV7jsfJrCaDDApMjE9tGErdXuLEH
	RnYciP/Ow7lIwX4n2WpXxdfFQqOMhizENHWKQqBK03EXHBu5bMsLmpN3ADPAIq2T
	xfbcXAJcJv2Ilg65QLydUMLru3LhFBIFbUhjJa995AwwkBKW485/PrKwE9IOwtEC
	ijmZjvMJ6QHKf6fGCjevPGR/ZnHhg1uMwZfQk+GljoiLAqu7XQvbiQR0GC+DpaiV
	Xs8efnzgZhlTp+Cfco0Dl4fdQw57V5lHVnbM+QaxLlNoHxzgPh+YPiyNa3FTc1no
	w==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id M0rPF7mrIwHv; Tue, 22 Sep 2026 23:26:42 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4hqGSx2TFdzlfvpH;
	Tue, 22 Sep 2026 23:26:40 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	John Garry <john.g.garry@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 1/7] scsi: scsi_debug: Fix a locking bug in resp_write_same()
Date: Tue, 22 Sep 2026 16:26:21 -0700
Message-ID: <295c14b6d2d011597284f09f7a3de42a49e08863.1790119506.git.bvanassche@acm.org>
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

If fetch_to_dev_buffer() fails in resp_write_same(), the function jumps
to 'out' without releasing the data write lock acquired earlier via
sdeb_data_write_lock(). Jump to 'unlock' instead so that
sdeb_data_write_unlock() is called on the error path. This bug has been
discovered by building the scsi_debug driver with Clang and modified
lock context annotations. The modified lock context annotations are
available in patch "scsi: scsi_debug: Improve lock context annotations".

Fixes: 84f3a3c01d70 ("scsi: scsi_debug: Atomic write support")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_debug.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 6941809dfdb7..b854102e6caa 100644
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
@@ -5419,6 +5419,7 @@ static int resp_write_same(struct scsi_cmnd *scp, u=
64 lba, u32 num,
 	/* If ZBC zone then bump its write pointer */
 	if (sdebug_dev_is_zoned(devip))
 		zbc_inc_wp(devip, lba, num);
+unlock:
 	sdeb_data_write_unlock(sip);
 	ret =3D 0;
 out:
