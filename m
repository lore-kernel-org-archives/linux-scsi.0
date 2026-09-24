Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AC31401A18
	for <linux-scsi@vger.kernel.org>; Thu, 24 Sep 2026 22:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790290501; cv=none; b=pZXivvdwcBE91LbnS+J/P6LP3jGt6T2XkYUOPlxmhuwFGcLWKqCOQobaM7fAn0CCs08Lq3aqQe51R4B2oQjQ/aJKW3hlf66ytJcsNpcZSPMM3Tbl4x6ywdGF7hvGm9fVWg5QbSXKu416won97Pol9RETzNgiDvGnyDBELeJSTdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790290501; c=relaxed/simple;
	bh=zJmV5mobwyqL4tGp27G6hfEOe6aSk3LTUZsXmtmI03M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vm7nitJmbaTk+E9D3We/nKB+Vmn/XAqEaqWbdjHyE9xFKNTHStL7tRLCI7ZIJ6bIdfOnb88Opyv70a2UAAc1lJs8U7P05bKaciS5fCKazrdVXEADTmJzgHu1iaSQVEboGZ+UDSNra3At8LFokqLK5OXNpT05/98FpvsOnHl+AxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=bO0t5LiN; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="bO0t5LiN"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4hrTgR5vd4zlfvpT;
	Thu, 24 Sep 2026 22:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1790290496; x=1792882497; bh=xZAat
	+ZuUF3OXRk7QJNEcYgpuJbM0fvEeNwOH+793f0=; b=bO0t5LiN7J1GZynBDlpmD
	iennn0P0nryQU/iUmDwQ/K1mAW8uARI0JL1DvTZu6v8oZhTsB+TZUGqcBAjryZZv
	NT9e1TtOz44HOyG1VBHtRLWAAp+wBCy+dUhBzSeKLu/JOH5cDlycbcwKf6qczDge
	2k8kuwtPfafN5W4BW7k0kQUSHfZdxkQzkbkx2eehRrflOmxdV+pgfhPMyIJvPV8N
	IAyyhSl/r83YozJviu5ecyhtR+fNrYsyUARDYXZL9QGVA/72OQLFV/p93lV5bXZj
	NSujJXEcDhHiWr8eEQTpSam6gCgg5wxQthFuFVxcMDdLJjiFWfSm+vUrRtPBBz1i
	A==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id y6JbZrT831Za; Thu, 24 Sep 2026 22:54:56 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4hrTgM19PNzlfvpK;
	Thu, 24 Sep 2026 22:54:54 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	John Garry <john.g.garry@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 1/7] scsi: scsi_debug: Fix a locking bug in resp_write_same()
Date: Thu, 24 Sep 2026 15:54:37 -0700
Message-ID: <f3cedcaf09495936f46898a4242cd83da9145989.1790290090.git.bvanassche@acm.org>
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
