Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C0CA3C5DC3
	for <linux-scsi@vger.kernel.org>; Thu, 12 Mar 2026 21:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773350234; cv=none; b=rr9rKkzrHrFgWAyq1B/wOQtHMowBaF4bTB5nHDeIo8eIfIhk214QJmM1Ip9K+PLOkEGwgm71aAzsTAIIipnkvXbLwKyCniCtbzUh50TfVVx5DJxgrjKjsq+Ut8kabA5bGARcWr5fdKdOv6ixMBzctDQgRmVJMDHjeJOvb5dkUE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773350234; c=relaxed/simple;
	bh=UYXON/bYynAx4ajJsMxUeHNaE5k0FciU3xcRCWDZHBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uaxLozGAQoz33GD4LHa0MXratrIJSznKTGNd5DJYy2dAaCRB85RhW6GujUmeOPq2IGFK30W7Zdf/mZzmkt3+laNLBnknkw8zDsUWHX2mO28T+zcU9Ynv0vv4KyOde5N1AURhttR94UgwCIoLjcSdHUxZPpzopncIniFiyMbjJ/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=iayU+U0h; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="iayU+U0h"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4fX0n45VB0zlfl5h;
	Thu, 12 Mar 2026 21:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1773350229; x=1775942230; bh=EfpWM
	UrnOrwSLOCGGrPuxxfEPr2aa7Sd2A+17kt8baw=; b=iayU+U0hjJ9I0C7YOLS5T
	ViCzpFYhUb9862xTQnIKK1ontMh3PNrFGuywE/l468VvWn9ebL8Sj3w4B0qWmlVl
	VphZpUK/S4QUtPjgI1TeSyFro1VlSep9b5eVcj4rz7OU2GvrYyz7OcQd+jJZ0Cls
	nC0Taair1tkAGv9BUWdARGClXrrsiFNSVKaYEWSHAg6+77UhJv51fmJJcF4M9Dra
	0Ua2Yl627aB1gfv6TpyQEwAmhCPiVXU4CddQ361ymUjtnj26MXezeHeQXGXNsw6u
	yulbvWdsWZ1vsurR2smJvUkLdEJC6DnhIxGdMQFC2CnsIm5opJ9Jnf9eNvQGUy39
	w==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id lwOeSohwVvMB; Thu, 12 Mar 2026 21:17:09 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4fX0n04nVzzlfl8L;
	Thu, 12 Mar 2026 21:17:08 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 01/36] scsi: core: Prepare for enabling lock context analysis
Date: Thu, 12 Mar 2026 14:15:12 -0700
Message-ID: <20260312211636.3245119-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.53.0.851.ga537e3e6e9-goog
In-Reply-To: <20260312211636.3245119-1-bvanassche@acm.org>
References: <20260312211636.3245119-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Document which functions expect that shost->scan_mutex is held. Inform
the compiler about synchronization object aliases with __assume_ctx_lock(=
).

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_scan.c | 12 ++++++++++++
 include/scsi/scsi_host.h |  2 ++
 2 files changed, 14 insertions(+)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index efcaf85ff699..738822d547f3 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1185,6 +1185,7 @@ static int scsi_probe_and_add_lun(struct scsi_targe=
t *starget,
 				  struct scsi_device **sdevp,
 				  enum scsi_scan_mode rescan,
 				  void *hostdata)
+	__must_hold(&dev_to_shost(starget->dev.parent)->scan_mutex)
 {
 	struct scsi_device *sdev;
 	unsigned char *result;
@@ -1341,6 +1342,7 @@ static int scsi_probe_and_add_lun(struct scsi_targe=
t *starget,
 static void scsi_sequential_lun_scan(struct scsi_target *starget,
 				     blist_flags_t bflags, int scsi_level,
 				     enum scsi_scan_mode rescan)
+	__must_hold(&dev_to_shost(starget->dev.parent)->scan_mutex)
 {
 	uint max_dev_lun;
 	u64 sparse_lun, lun;
@@ -1432,6 +1434,7 @@ static void scsi_sequential_lun_scan(struct scsi_ta=
rget *starget,
  **/
 static int scsi_report_lun_scan(struct scsi_target *starget, blist_flags=
_t bflags,
 				enum scsi_scan_mode rescan)
+	__must_hold(&dev_to_shost(starget->dev.parent)->scan_mutex)
 {
 	unsigned char scsi_cmd[MAX_COMMAND_SIZE];
 	unsigned int length;
@@ -1629,6 +1632,8 @@ struct scsi_device *__scsi_add_device(struct Scsi_H=
ost *shost, uint channel,
 	scsi_autopm_get_target(starget);
=20
 	mutex_lock(&shost->scan_mutex);
+	/* Tell the compiler that dev_to_shost(...) =3D=3D shost. */
+	__assume_ctx_lock(&dev_to_shost(starget->dev.parent)->scan_mutex);
 	if (!shost->async_scan)
 		scsi_complete_async_scans();
=20
@@ -1757,6 +1762,7 @@ EXPORT_SYMBOL(scsi_rescan_device);
=20
 static void __scsi_scan_target(struct device *parent, unsigned int chann=
el,
 		unsigned int id, u64 lun, enum scsi_scan_mode rescan)
+	__must_hold(&dev_to_shost(parent)->scan_mutex)
 {
 	struct Scsi_Host *shost =3D dev_to_shost(parent);
 	blist_flags_t bflags =3D 0;
@@ -1772,6 +1778,8 @@ static void __scsi_scan_target(struct device *paren=
t, unsigned int channel,
 	starget =3D scsi_alloc_target(parent, channel, id);
 	if (!starget)
 		return;
+	/* Tell the compiler that dev_to_shost(...) =3D=3D shost. */
+	__assume_ctx_lock(&dev_to_shost(starget->dev.parent)->scan_mutex);
 	scsi_autopm_get_target(starget);
=20
 	if (lun !=3D SCAN_WILD_CARD) {
@@ -1853,9 +1861,13 @@ EXPORT_SYMBOL(scsi_scan_target);
 static void scsi_scan_channel(struct Scsi_Host *shost, unsigned int chan=
nel,
 			      unsigned int id, u64 lun,
 			      enum scsi_scan_mode rescan)
+	__must_hold(&shost->scan_mutex)
 {
 	uint order_id;
=20
+	/* Tell the compiler that dev_to_shost(...) =3D=3D shost. */
+	__assume_ctx_lock(&dev_to_shost(&shost->shost_gendev)->scan_mutex);
+
 	if (id =3D=3D SCAN_WILD_CARD)
 		for (id =3D 0; id < shost->max_id; ++id) {
 			/*
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 7e2011830ba4..2bbe7cb0060b 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -534,6 +534,8 @@ struct scsi_host_template {
 		enum scsi_qc_status rc;					\
 									\
 		spin_lock_irqsave(shost->host_lock, irq_flags);		\
+		/* Tell the compiler that cmd->device->host =3D=3D shost. */\
+		__assume_ctx_lock(cmd->device->host->host_lock);	\
 		rc =3D func_name##_lck(cmd);				\
 		spin_unlock_irqrestore(shost->host_lock, irq_flags);	\
 		return rc;						\
