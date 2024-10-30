Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91D1E1991DF
	for <linux-scsi@vger.kernel.org>; Wed, 30 Oct 2024 22:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730325819; cv=none; b=GMVlgh008ZstFPp6jq+Fc5ivYq53c0e6fBnARqkM+Tlm8YPMngnonFW1swulpa7k+tgNt1aLS3hv30bipeb2GHlechr+Zf2h++Hv/xhPU6rIlquJcW5auve/TtOVNNFDoO7kJCiMV0PM0OV3zRhPpEvHCOpSyxM6Hx2B6RsQIUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730325819; c=relaxed/simple;
	bh=IS7+NnAQDvnqe4jpVdXgZI25hBvGzY5cUHEkcJ1tImo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Z48jVyDxHQqbwl/kYJ/bY17pNJVkclwpwRjcGXLK32mhK/4yqsnaSx+lorPkme6DFSnYHjb6LLeyQ8rP+H/6ccjOhqmsqoRHv5hqTfklQRE+67wm7qv7/O6ZpeslEByifyzaE+UEPq8EZvR+w5kkbmxMlmme/L/uaaSaBsvsZ1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=T49Nng5Z; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="T49Nng5Z"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4Xf1NS6wCdzlgMW3;
	Wed, 30 Oct 2024 22:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1730325813; x=1732917814; bh=HKNpsaRoB0Mq0U1sRMbUzma/WvNOP8AxD/P
	QMMOAH+0=; b=T49Nng5Zg3b7f4YaELkN01s3bky6CSQ67PeNlXVIs+ShTyXekwj
	kQwFht9kkBUnAI9IIrX4D3YP3pWqy3WHRlEHUi8xWnrjV0LJDAcdxPxiQq9A8WcK
	z3cxtgNbyWuvLk9DlPr3P00erek0hvEKEqzY/NbtEDE8MwpxpKgNRoSyypl7z+rT
	TCuJllYjGSU0gM8e52OP5cRw9k39mqAVNnH+KLMcC543nvASUUgOzTO3AORTpDhu
	7F2x5/mADLSjVM2miMlDAd6TlQBJA1ylEAv7Stus6RVZcZ4Mfu1u6+BDuC83BLLm
	g8Xbja0c6UitCSaaMH8n2XU0RqaMfPb9+XQ==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id TSUVaObl7R5I; Wed, 30 Oct 2024 22:03:33 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Xf1NL6YrSzlgMVx;
	Wed, 30 Oct 2024 22:03:30 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	Douglas Gilbert <dgilbert@interlog.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	James Bottomley <James.Bottomley@suse.de>
Subject: [PATCH] scsi: sg: Enable runtime power management
Date: Wed, 30 Oct 2024 15:03:10 -0700
Message-ID: <20241030220310.1373569-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.47.0.163.g1226f6d8fa-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

In 2010, runtime power management support was implemented in the SCSI cor=
e.
The description of patch "[SCSI] implement runtime Power Management"
mentions that the sg driver is skipped but not why. This patch enables
runtime power management even if an instance of the sg driver is held ope=
n.
Enabling runtime PM for the sg driver is safe because all interactions of
the sg driver with the SCSI device pass through the block layer
(blk_execute_rq_nowait()) and the block layer already supports runtime PM=
.

Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Fixes: bc4f24014de5 ("[SCSI] implement runtime Power Management")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sg.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index f86be197fedd..84334ab39c81 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -307,10 +307,6 @@ sg_open(struct inode *inode, struct file *filp)
 	if (retval)
 		goto sg_put;
=20
-	retval =3D scsi_autopm_get_device(device);
-	if (retval)
-		goto sdp_put;
-
 	/* scsi_block_when_processing_errors() may block so bypass
 	 * check if O_NONBLOCK. Permits SCSI commands to be issued
 	 * during error recovery. Tread carefully. */
@@ -318,7 +314,7 @@ sg_open(struct inode *inode, struct file *filp)
 	      scsi_block_when_processing_errors(device))) {
 		retval =3D -ENXIO;
 		/* we are in error recovery for this device */
-		goto error_out;
+		goto sdp_put;
 	}
=20
 	mutex_lock(&sdp->open_rel_lock);
@@ -371,8 +367,6 @@ sg_open(struct inode *inode, struct file *filp)
 	}
 error_mutex_locked:
 	mutex_unlock(&sdp->open_rel_lock);
-error_out:
-	scsi_autopm_put_device(device);
 sdp_put:
 	kref_put(&sdp->d_ref, sg_device_destroy);
 	scsi_device_put(device);
@@ -392,7 +386,6 @@ sg_release(struct inode *inode, struct file *filp)
 	SCSI_LOG_TIMEOUT(3, sg_printk(KERN_INFO, sdp, "sg_release\n"));
=20
 	mutex_lock(&sdp->open_rel_lock);
-	scsi_autopm_put_device(sdp->device);
 	kref_put(&sfp->f_ref, sg_remove_sfp);
 	sdp->open_cnt--;
=20
