Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 675683FFAA4
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 18:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790360956; cv=none; b=sGBPOeL12VLYZOteK8I/RxXsXMGuqnC/R9wN1TN3X7m2u4ISiEi+lVse/cEYs7Jvjcj/JOA7/YEcQk2XihMnhd/RJgu0lJXihnJkZ+J0AK/8sxdrzVUP3lFIqiDnWhpsYlVRanr6lK2frbMncf2gdzvN7UWlbz8IkVmtlXh2LM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790360956; c=relaxed/simple;
	bh=unfSmNwsN5hy3g7Wiv/75mYslku8d9kqXyOfDxdpdf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qpMFPq+WORbW/Lrls/T+BwBOci9V0dLyjkTD950nMVkhQS4g9MyEDoZY10RUcDymYoNHJJWgJp2/gl7XUbT0g9CqQ2gtA2GIAOtVcd3pfFI5oxRyrcw1MUSG7Hwn1F3LwLmWwA/UC4HWRlS2Henbm97CGj8w8Lq/vHAq0DATIdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=S4rHMzkl; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="S4rHMzkl"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hrzkL5vymz1XM5kW;
	Fri, 25 Sep 2026 18:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1790360949; x=1792952950; bh=fQrnp
	tR4BVhJ94/sRfbCXBsosHuYbhJRh67A6R6A+zE=; b=S4rHMzklLJI6jxRpVR0zT
	mqGdNMv3uO4iKO8ziE0M0ZtRp55SgA6F3gsc4QtJabXo/5MJtnH9jC1yHJb1apel
	VjMF0tTtNztpbdh7i4amIz1YxmvV2IgccK/8m/egHmSWgkKvIouKiskO1+FVgLUV
	GAJW7kZeKcrRRnArGo6ThGlBg6s6Wl/A+4PvG/F0CpRQHk05iQe5ouwSUhQ6n8W2
	yf8mfic5Yj5xv4DL9poVfFXmEJ0TaWE5IvEQJQUOgj/JcusRigZ5tOPGmZOkqqK+
	MkqBTqz+gTDF2LDqhvqqWseKbb+1ppm92p5X5pLInDjHEunw4UQDMwPcLPZTtn+b
	Q==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id PayffZICKbBH; Fri, 25 Sep 2026 18:29:09 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hrzkD0SWqz1XM4Sx;
	Fri, 25 Sep 2026 18:29:07 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Khalid Aziz <khalid@gonehiking.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Subject: [PATCH v4 05/54] scsi: BusLogic: Prepare for enabling lock context analysis
Date: Fri, 25 Sep 2026 11:25:43 -0700
Message-ID: <abe0bc09b63eb55f278a883b65b881b94ce1c31b.1790360262.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
In-Reply-To: <cover.1790360262.git.bvanassche@acm.org>
References: <cover.1790360262.git.bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Document locking requirements with __must_hold() annotations to
prepare the BusLogic driver for enabling compiler-based lock context
analysis.

Cc: Khalid Aziz <khalid@gonehiking.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/BusLogic.c | 6 ++++++
 drivers/scsi/BusLogic.h | 3 ++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
index 75aaf35383a9..4179f29b3066 100644
--- a/drivers/scsi/BusLogic.c
+++ b/drivers/scsi/BusLogic.c
@@ -277,6 +277,7 @@ static void blogic_create_addlccbs(struct blogic_adap=
ter *adapter,
 */
=20
 static struct blogic_ccb *blogic_alloc_ccb(struct Scsi_Host *host)
+	__must_hold(&host->host_lock)
 {
 	struct blogic_adapter *adapter =3D (void *)host->hostdata;
 	static unsigned long serial;
@@ -310,6 +311,7 @@ static struct blogic_ccb *blogic_alloc_ccb(struct Scs=
i_Host *host)
=20
 static void blogic_dealloc_ccb(struct Scsi_Host *host, struct blogic_ccb=
 *ccb,
 			       int dma_unmap)
+	__must_hold(&host->host_lock)
 {
 	struct blogic_adapter *adapter =3D ccb->adapter;
=20
@@ -2599,6 +2601,7 @@ static void blogic_scan_inbox(struct blogic_adapter=
 *adapter)
 */
=20
 static void blogic_process_ccbs(struct Scsi_Host *host)
+	__must_hold(&host->host_lock)
 {
 	struct blogic_adapter *adapter =3D (void *)host->hostdata;
=20
@@ -2830,6 +2833,7 @@ static irqreturn_t blogic_inthandler(int irq_ch, vo=
id *devid)
=20
 static bool blogic_write_outbox(struct Scsi_Host *host,
 		enum blogic_action action, struct blogic_ccb *ccb)
+	__must_hold(&host->host_lock)
 {
 	struct blogic_adapter *adapter =3D (void *)host->hostdata;
 	struct blogic_outbox *next_outbox;
@@ -2884,6 +2888,7 @@ static int blogic_hostreset(struct scsi_cmnd *SCpnt=
)
 */
=20
 static enum scsi_qc_status blogic_qcmd_lck(struct Scsi_Host *shost, stru=
ct scsi_cmnd *command)
+	__must_hold(&shost->host_lock)
 {
 	void (*comp_cb)(struct scsi_cmnd *) =3D scsi_done;
 	struct blogic_adapter *adapter =3D
@@ -3194,6 +3199,7 @@ static int blogic_abort(struct scsi_cmnd *command)
 */
=20
 static int blogic_resetadapter(struct Scsi_Host *host, bool hard_reset)
+	__must_hold(&host->host_lock)
 {
 	struct blogic_adapter *adapter =3D (void *)host->hostdata;
 	struct blogic_ccb *ccb;
diff --git a/drivers/scsi/BusLogic.h b/drivers/scsi/BusLogic.h
index 6ace3c307a90..455d442525f6 100644
--- a/drivers/scsi/BusLogic.h
+++ b/drivers/scsi/BusLogic.h
@@ -1279,7 +1279,8 @@ static int blogic_sdev_configure(struct scsi_device=
 *,
 				 struct queue_limits *lim);
 static void blogic_qcompleted_ccb(struct blogic_ccb *);
 static irqreturn_t blogic_inthandler(int, void *);
-static int blogic_resetadapter(struct Scsi_Host *host, bool hard_reset);
+static int blogic_resetadapter(struct Scsi_Host *host, bool hard_reset)
+	__must_hold(&host->host_lock);
 static void blogic_msg(enum blogic_msglevel, char *, struct blogic_adapt=
er *, ...);
 static int __init blogic_setup(char *);
=20
