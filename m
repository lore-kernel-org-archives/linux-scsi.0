Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A30682D46D8
	for <linux-scsi@vger.kernel.org>; Tue, 14 Oct 2025 22:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760479384; cv=none; b=m8oSyO46f5JXSCwhmMCbFsVck9HbnGUUn+99w7wG35MQ7SOSJd//5kmwVpWPHNOXllaN/AdeJ3G4oP08vc8vimrwuuzkTYUNJ4ZH+FCEh2Zjne/hQpZlqDx+3W43HqLUxHrf+0UdYSC3Bw7ZgNKUddEpDu7ly+0gRsSymqJUvuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760479384; c=relaxed/simple;
	bh=H/5jjFxbjtduep51gE4bMNbrjs/a5o5DnoarlcN5rTk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=nOJg5fJM4A6q0KkQez0UbWnwf5DVfLzW6CXOSwI88RkJUjI+eEYTlRVGKMURIk3mSa/1H69WC5ah5MBorXQQT26C/+vZVlnGLn+m5SuwDrYu9T7MISK5WZWBcDB0hCnP2hfWcxk6Bp0C2kaGnOUc25atT32w4PxFTENeV3VUvO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=sr6T+yjL; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="sr6T+yjL"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cmSrh4Q5QzlgqTx;
	Tue, 14 Oct 2025 22:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:mime-version
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1760479379; x=1763071380; bh=xxi9T
	3ZYmW3z3PJQPrQuh6PSReFXzO0LIJYjTVSqGxE=; b=sr6T+yjLyudEXRrY3wz/Z
	1DVkez0zxZvHPTnnwYDGvqbogP5k4lxstSJXRhx+n+q2/JueyY46LOaD8VSWzaxw
	8njK332GaoNa1Wv1vgpL1I2IN+KdVSamGy4sJznh2PC7RpxfO1XgYt2DLlt2/7yF
	zHDXx55QkpLsvG1ikUEodnP0fNMUFNyqbYsznTSQrawKtaTwYlBE4ceDRzVlK37T
	lMaZxFlpRw2JewMZcFL0FXdzwGuWJAXT2R9eGGGYm39oAAhzoSdWFULs6uZtsKJC
	/7SDcCx+3d/N8Q5cr4Iy3nhGsJ1iwdpWiD6Lvk0R33O/IdQBfIx6kPVzPPhzqH1J
	A==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id aFUrXqbBbnME; Tue, 14 Oct 2025 22:02:59 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cmSrZ0nPBzlgqxh;
	Tue, 14 Oct 2025 22:02:53 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	John Meneghini <jmeneghi@redhat.com>
Subject: [PATCH] scsi: core: Fix the unit attention counter implementation
Date: Tue, 14 Oct 2025 15:02:43 -0700
Message-ID: <20251014220244.3689508-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.788.g6d19910ace-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

scsi_decide_disposition() may call scsi_check_sense().
scsi_decide_disposition() calls are not serialized. Hence, counter
updates by scsi_check_sense() must be serialized. Hence this patch that
makes the counters updated by scsi_check_sense() atomic.

Cc: Kai M=C3=A4kisara <Kai.Makisara@kolumbus.fi>
Fixes: a5d518cd4e3e ("scsi: core: Add counters for New Media and Power On=
/Reset UNIT ATTENTIONs")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_error.c  |  4 ++--
 include/scsi/scsi_device.h | 10 ++++------
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 746ff6a1f309..1c13812a3f03 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -554,9 +554,9 @@ enum scsi_disposition scsi_check_sense(struct scsi_cm=
nd *scmd)
 		 * happened, even if someone else gets the sense data.
 		 */
 		if (sshdr.asc =3D=3D 0x28)
-			scmd->device->ua_new_media_ctr++;
+			atomic_inc(&sdev->ua_new_media_ctr);
 		else if (sshdr.asc =3D=3D 0x29)
-			scmd->device->ua_por_ctr++;
+			atomic_inc(&sdev->ua_por_ctr);
 	}
=20
 	if (scsi_sense_is_deferred(&sshdr))
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 4c106342c4ae..3c6c8e3995c3 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -252,8 +252,8 @@ struct scsi_device {
 	unsigned int queue_stopped;	/* request queue is quiesced */
 	bool offline_already;		/* Device offline message logged */
=20
-	unsigned int ua_new_media_ctr;	/* Counter for New Media UNIT ATTENTIONs=
 */
-	unsigned int ua_por_ctr;	/* Counter for Power On / Reset UAs */
+	atomic_t ua_new_media_ctr;	/* Counter for New Media UNIT ATTENTIONs */
+	atomic_t ua_por_ctr;		/* Counter for Power On / Reset UAs */
=20
 	atomic_t disk_events_disable_depth; /* disable depth for disk events */
=20
@@ -693,10 +693,8 @@ static inline int scsi_device_busy(struct scsi_devic=
e *sdev)
 }
=20
 /* Macros to access the UNIT ATTENTION counters */
-#define scsi_get_ua_new_media_ctr(sdev) \
-	((const unsigned int)(sdev->ua_new_media_ctr))
-#define scsi_get_ua_por_ctr(sdev) \
-	((const unsigned int)(sdev->ua_por_ctr))
+#define scsi_get_ua_new_media_ctr(sdev)	atomic_read(&sdev->ua_new_media_=
ctr)
+#define scsi_get_ua_por_ctr(sdev)	atomic_read(&sdev->ua_por_ctr)
=20
 #define MODULE_ALIAS_SCSI_DEVICE(type) \
 	MODULE_ALIAS("scsi:t-" __stringify(type) "*")
