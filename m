Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C0F9526AB0
	for <linux-scsi@vger.kernel.org>; Tue, 13 Oct 2026 22:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791929428; cv=none; b=TCdn9llutJdBKXyllK9y1ROyFeWbEOuk/T2eG72R7g0lWKQaipuwty7yhI4BEnp+Hx3gvZ/TazWIGm0BaZKEO6qh0yu7Xdq7PpFEFxxK+1lq9JLEnenmw/3vnsSRy4+T4fTF0rX8MvU05fOlbBYUWeu54rpN6zLC4od1jelqc04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791929428; c=relaxed/simple;
	bh=z/z8K94O/OS44HuPLEV4Zg+9CmFxKexTkoVgcGcBfhs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YwX2MAQkwnqDE7YDlTS9ixLyXEP5DP/4NhtgzKobR2IzJFA1utjy5sg4aiYAPD7u27acdfhm3qZpQ1l3ddC9QHX8/BUpFzoHta3dS960PPwk6+c428MrRcEoZ2enyV6wP8HC35tvf1q1dn7iIW4YPlfNMSqEr4PNbWyXZ5JnZDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=FMRw7NDB; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="FMRw7NDB"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4j47nG2gPLzlfvq7;
	Tue, 13 Oct 2026 22:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1791929423; x=1794521424; bh=3qV5e
	pnncEV69P2a3UntMjMdAkV2GZEHYoCMj5Tk+4w=; b=FMRw7NDBcpab8K+i67/Ai
	HZMJv/E37tEt3+zBIIsaG/46uiEjj7ZaQ2yJH+GW3me5wwfE1HuGJgLAImLaUPr/
	O8dRBbrX/PjKSHZzF9XyqHmpft8oQy7DgxMBIZ41Ab0/7e8xmp94YpF5pdeycMi3
	ZJMDuYYTpxWzoMnedI2a1V9zYTeKwClpYR0GT9+Wrwl+QVaLHZ0Zf9r9HYwz7+Fg
	Ax1Tm291ADTmuSbs4/o0wrydb+zRerWRIFrUHWZYISsWboKUOjEMvxIiVz7kwHiD
	gLXIKB0G9SNuUbPXj5KHMGGAsIzivXSAXleBY1jJWY5SOQTTXyezY9YGlXpNjOpS
	A==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Sa627ALsN27c; Tue, 13 Oct 2026 22:10:23 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (245.199.118.34.bc.googleusercontent.com [34.118.199.245])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4j47nC2MFYzlfvpK;
	Tue, 13 Oct 2026 22:10:23 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	John Garry <john.garry@linux.dev>,
	Christoph Hellwig <hch@lst.de>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v6 1/8] scsi: scsi_debug: Fix a locking bug in resp_write_same()
Date: Tue, 13 Oct 2026 15:10:02 -0700
Message-ID: <271ea11d3bc147d950a89419181f0c3f5a1ebf3b.1791924924.git.bvanassche@acm.org>
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
index e679df1993aa..44b4587b53c6 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -5455,7 +5455,7 @@ static int resp_write_same(struct scsi_cmnd *scp, u=
64 lba, u32 num,
=20
 	if (-1 =3D=3D ret) {
 		ret =3D DID_ERROR << 16;
-		goto out;
+		goto unlock;
 	} else if (sdebug_verbose && !ndob && (ret < lb_size))
 		sdev_printk(KERN_INFO, scp->device,
 			    "%s: %s: lb size=3D%u, IO sent=3D%d bytes\n",
@@ -5472,8 +5472,9 @@ static int resp_write_same(struct scsi_cmnd *scp, u=
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
