Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B61336B909
	for <linux-scsi@vger.kernel.org>; Wed,  7 Oct 2026 05:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791349673; cv=none; b=YtKG3mERxx9kdYSChohnsGziiIJTCwbOGGnc8RK7XZdNUmZLnfMtrXOSpJ+2359iTaEJh5g/KfF3aM08wzKKa8w522ITw0CSbADxRus1XOJ9YoT6VFqMNCOxtkJSoRTxcaQ0XkCCb8E4D3u3Wi/SLtrR7oyyx5JkMxNM6ylr5+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791349673; c=relaxed/simple;
	bh=z/z8K94O/OS44HuPLEV4Zg+9CmFxKexTkoVgcGcBfhs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pg8IrmlCC9FCPTxY5S5GKKnzh4HGRsWomiFlp6UYfvv6BeBtOMgAuM/qaMC8hTpoOIBTxO2kz1phpSc3tlTZy3n88Ud/K8p61y7Cs01NWtJ7//rsulQ6/yYjtXYk2hQ8SAoa2ckzollziVW6lNTcWi26hHngY3GFGv3ysXXqbCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=AMg+dzTF; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="AMg+dzTF"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4j01N73dn3zlfh8S;
	Wed,  7 Oct 2026 05:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1791349668; x=1793941669; bh=3qV5e
	pnncEV69P2a3UntMjMdAkV2GZEHYoCMj5Tk+4w=; b=AMg+dzTFFB+fCVGk8qd/4
	+9nELQCl3xpaAXufcU2jiM5EmCsblVoUVja9ck6sdSaLPfE55+zC4L4+EF9CDSBi
	sZhKZrQLi8853qype/tn0IX1hYoZMAmg+xfuScLW3E8tktAheu+xtVK2RW5OgYH2
	NjDsTrRgCFrHRAFMzNGe8xysaPdnuCdtLliMPoEuLTrWl2Y3yU3GawJy8TYG8fxi
	cdh/0/x5bACHHQAyRNk5Ntv4VABcqhjZ7/ao7hcs/gJi2kwihY2gSrkCSTMw5VPV
	gczq+6ammPperorws9uEqOx97RQlhbZV3BLvmvzC8nBvUSUgxXOHgKxAxkJ8Yfau
	Q==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Mum_ut-Bt7WM; Wed,  7 Oct 2026 05:07:48 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (245.199.118.34.bc.googleusercontent.com [34.118.199.245])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4j01N22WCdzlfvpN;
	Wed,  7 Oct 2026 05:07:45 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	John Garry <john.g.garry@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Bart Van Assche <bvanassche@acm.org>,
	John Garry <john.garry@linux.dev>
Subject: [PATCH v4 1/8] scsi: scsi_debug: Fix a locking bug in resp_write_same()
Date: Tue,  6 Oct 2026 22:07:23 -0700
Message-ID: <271ea11d3bc147d950a89419181f0c3f5a1ebf3b.1791349129.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
In-Reply-To: <cover.1791349129.git.bvanassche@acm.org>
References: <cover.1791349129.git.bvanassche@acm.org>
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
