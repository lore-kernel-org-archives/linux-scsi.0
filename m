Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 206C13FADF6
	for <linux-scsi@vger.kernel.org>; Thu, 30 Apr 2026 18:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777573544; cv=none; b=tVEgi1jCouWL4mxVphemM9jy1sD9l9FHh+gv/xhkXr5vdojMWiC2wmq1vx3SK5Y4eryYrj/l5m5nysI+kWl7MXVNuQ+b2f8sUR9/HE8o3CZtc850ah6kB5Ojqaw+VI6gYLAv8/kLbqZlqePBOltbilLMiUI8/gVrrjgXTkVfkGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777573544; c=relaxed/simple;
	bh=zL/z+Tc2xYAljazJTfNF5v89ChfgdRkvOO18G/cMSBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ntUVJOMzg7+0u6uUwElUaoBvKNNa0E+0phgrMz+grZlER+63vyMrlGdbpj/Q6y+0KNB9vFqTcoHg9ihPavPZ4S/IxaEAj3ZYoPX7emn8lDWD/cY7z5SJIkdetscpgZgdfFnOSiNvcRY2zLYpLbj1QJC6SJv2PELAa894zuT1Yto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=vtzo6rDt; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="vtzo6rDt"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4g62fZ4sTVzlhpdd;
	Thu, 30 Apr 2026 18:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1777573538; x=1780165539; bh=74GzW
	zhVBhfYq0veQCfnxBQMiFqNIoId2B4e+d4QYA8=; b=vtzo6rDth593QvllG9Tuh
	OeRqmC8es98TAikOY+LwiBMs2Th2tVt15vl8dP8tK2i4tCFl555fndhlzJysjCl/
	8i+BGp3h3DvRn4Qw1MnJDRqaXiXopPlS5aGz3yaIgdnC/FHyGRCuQP5fPlncC/Cl
	mcZFHfTjNG+L5ZazsQfzwT6XolMy/r/03F+CMQv9gcTuv9QOP/ozQmv1CUX7z0mR
	KiHUtgAH6g4qf6e2Ve0kH27SsW2LCNxodGtKJICfyCuvzx/xDzV+7rf6OVa54fZc
	X++oSkJW4RqDjXgY8BPI9IVPlMHDJibG+e7JbeL+hgVg5iZHGaxFm6Lk19MXlWz2
	w==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Wk6w4Oc77eRN; Thu, 30 Apr 2026 18:25:38 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4g62fT0NS1zlfvpH;
	Thu, 30 Apr 2026 18:25:36 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Marco Elver <elver@google.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v2 55/56] scsi: core: Enable lock context analysis
Date: Thu, 30 Apr 2026 11:20:25 -0700
Message-ID: <20260430182130.1978347-56-bvanassche@acm.org>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
In-Reply-To: <20260430182130.1978347-1-bvanassche@acm.org>
References: <20260430182130.1978347-1-bvanassche@acm.org>
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
Enable lock context analysis for the SCSI core and also for all drivers
in the drivers/scsi/ directory.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/Makefile                |  1 +
 drivers/scsi/device_handler/Makefile |  3 +++
 drivers/scsi/scsi_scan.c             | 12 ++++++++++++
 include/scsi/scsi_host.h             |  2 ++
 4 files changed, 18 insertions(+)

diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 16de3e41f94c..07e8280bcb1e 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -14,6 +14,7 @@
 # satisfy certain initialization assumptions in the SCSI layer.
 # *!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!
=20
+CONTEXT_ANALYSIS :=3D y
=20
 CFLAGS_aha152x.o =3D   -DAHA152X_STAT -DAUTOCONF
=20
diff --git a/drivers/scsi/device_handler/Makefile b/drivers/scsi/device_h=
andler/Makefile
index 0a603aefd2bb..5aa282a63e24 100644
--- a/drivers/scsi/device_handler/Makefile
+++ b/drivers/scsi/device_handler/Makefile
@@ -2,6 +2,9 @@
 #
 # SCSI Device Handler
 #
+
+CONTEXT_ANALYSIS :=3D y
+
 obj-$(CONFIG_SCSI_DH_RDAC)	+=3D scsi_dh_rdac.o
 obj-$(CONFIG_SCSI_DH_HP_SW)	+=3D scsi_dh_hp_sw.o
 obj-$(CONFIG_SCSI_DH_EMC)	+=3D scsi_dh_emc.o
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index ef22a4228b85..283f9a32d48a 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1182,6 +1182,7 @@ static int scsi_probe_and_add_lun(struct scsi_targe=
t *starget,
 				  struct scsi_device **sdevp,
 				  enum scsi_scan_mode rescan,
 				  void *hostdata)
+	__must_hold(&dev_to_shost(starget->dev.parent)->scan_mutex)
 {
 	struct scsi_device *sdev;
 	unsigned char *result;
@@ -1338,6 +1339,7 @@ static int scsi_probe_and_add_lun(struct scsi_targe=
t *starget,
 static void scsi_sequential_lun_scan(struct scsi_target *starget,
 				     blist_flags_t bflags, int scsi_level,
 				     enum scsi_scan_mode rescan)
+	__must_hold(&dev_to_shost(starget->dev.parent)->scan_mutex)
 {
 	uint max_dev_lun;
 	u64 sparse_lun, lun;
@@ -1429,6 +1431,7 @@ static void scsi_sequential_lun_scan(struct scsi_ta=
rget *starget,
  **/
 static int scsi_report_lun_scan(struct scsi_target *starget, blist_flags=
_t bflags,
 				enum scsi_scan_mode rescan)
+	__must_hold(&dev_to_shost(starget->dev.parent)->scan_mutex)
 {
 	unsigned char scsi_cmd[MAX_COMMAND_SIZE];
 	unsigned int length;
@@ -1626,6 +1629,8 @@ struct scsi_device *__scsi_add_device(struct Scsi_H=
ost *shost, uint channel,
 	scsi_autopm_get_target(starget);
=20
 	mutex_lock(&shost->scan_mutex);
+	/* Tell the compiler that dev_to_shost(...) =3D=3D shost. */
+	__assume_ctx_lock(&dev_to_shost(starget->dev.parent)->scan_mutex);
 	if (!shost->async_scan)
 		scsi_complete_async_scans();
=20
@@ -1754,6 +1759,7 @@ EXPORT_SYMBOL(scsi_rescan_device);
=20
 static void __scsi_scan_target(struct device *parent, unsigned int chann=
el,
 		unsigned int id, u64 lun, enum scsi_scan_mode rescan)
+	__must_hold(&dev_to_shost(parent)->scan_mutex)
 {
 	struct Scsi_Host *shost =3D dev_to_shost(parent);
 	blist_flags_t bflags =3D 0;
@@ -1769,6 +1775,8 @@ static void __scsi_scan_target(struct device *paren=
t, unsigned int channel,
 	starget =3D scsi_alloc_target(parent, channel, id);
 	if (!starget)
 		return;
+	/* Tell the compiler that dev_to_shost(...) =3D=3D shost. */
+	__assume_ctx_lock(&dev_to_shost(starget->dev.parent)->scan_mutex);
 	scsi_autopm_get_target(starget);
=20
 	if (lun !=3D SCAN_WILD_CARD) {
@@ -1850,9 +1858,13 @@ EXPORT_SYMBOL(scsi_scan_target);
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
