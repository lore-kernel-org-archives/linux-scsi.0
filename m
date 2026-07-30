Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64EAA3D5221
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 22:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785451776; cv=none; b=AnRTWKSs/js7ACjTfy9P5ALolDNzcPHOtn22JL8BIPdt8FMLkFHGU3qGMp9kIhgJY9xxf7NIvqwUQiUbCZCSp5C2Qrz4dELJpRneCmgEiMSWvfoMgDoYg6M0rYyM3e2iE4xnPwmW+LpxftQkZKtcp6RmkxJXizqt7wqsmr4D/o4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785451776; c=relaxed/simple;
	bh=7er5vmtwK6Q8Aq7Yr3Fdz8wNQA0GB+cDkBQcQWtAxA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LkyWkeeBbElZpoF6okhMuicf+j/TxmiYrWptuD5NSpO1AUoO08OBrSGTP2q13DaupKM0Z0WED/l/Ghz/EwcZfWh5opdJPlhbEWpFpcc+HyX0M6y7vUrL4Do6LbtW+K00hLsrue447qLgBMfsshLY065u7A909yiyvfls/NXYjvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Y3fBfCZI; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Y3fBfCZI"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hB4C30zr5z1XM2FV;
	Thu, 30 Jul 2026 22:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1785451770; x=1788043771; bh=rs7Re
	JealS/hjpeL89qweTZyK/VvhOmhQbX5/5esvVs=; b=Y3fBfCZImQMYVKATevWpU
	ruyqs6qLh5wTSamwW/D/YTbUz1bqZ83V2HVXGha47F0KncG9kiL3FtNIadTT2oZc
	WS5XrbShy4p+2zuBE+j6gSmdRSzKu10VwqkRXtVoQ9N5nZ4I8H9qQVOizUXfnoW8
	HUTe2UdM4o4xouDocDo/DWuoCnkbM4qEyxaNjuZhDPvcF4nzR8gA1lgCg0f8w8LM
	3MKblwIYkZJoXfh+j1xzAux0NgRLWIGZG8yVJnvWf7H8QmT7ztBX+hpnjQ2ejcc+
	JWUmU9K71l1R8kWZnLmoDFTQueyZwK3l6eMzcuJSq0ulPM/+lVI21jJeH1F5Dpnb
	A==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 12zBXoJh0G71; Thu, 30 Jul 2026 22:49:30 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hB4Bx6C5sz1XM30r;
	Thu, 30 Jul 2026 22:49:29 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Marco Elver <elver@google.com>,
	linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v3 56/57] scsi: core: Enable lock context analysis
Date: Thu, 30 Jul 2026 15:45:39 -0700
Message-ID: <bab84be1d3cff4f1ab78e6508c20307f72aa9778.1785451174.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
In-Reply-To: <cover.1785451174.git.bvanassche@acm.org>
References: <cover.1785451174.git.bvanassche@acm.org>
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
 drivers/scsi/Makefile                | 1 +
 drivers/scsi/device_handler/Makefile | 3 +++
 drivers/scsi/scsi_scan.c             | 5 +++++
 include/scsi/scsi_host.h             | 2 ++
 4 files changed, 11 insertions(+)

diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 842c254bb226..a1fbdf4b0705 100644
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
index a8994c07d415..8096ca51161b 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1195,6 +1195,7 @@ static int scsi_probe_and_add_lun(struct Scsi_Host =
*shost,
 				  struct scsi_device **sdevp,
 				  enum scsi_scan_mode rescan,
 				  void *hostdata)
+	__must_hold(&shost->scan_mutex)
 {
 	struct scsi_device *sdev;
 	unsigned char *result;
@@ -1352,6 +1353,7 @@ static void scsi_sequential_lun_scan(struct Scsi_Ho=
st *shost,
 				     struct scsi_target *starget,
 				     blist_flags_t bflags, int scsi_level,
 				     enum scsi_scan_mode rescan)
+	__must_hold(&shost->scan_mutex)
 {
 	uint max_dev_lun;
 	u64 sparse_lun, lun;
@@ -1443,6 +1445,7 @@ static void scsi_sequential_lun_scan(struct Scsi_Ho=
st *shost,
 static int scsi_report_lun_scan(struct Scsi_Host *shost,
 			struct scsi_target *starget, blist_flags_t bflags,
 			enum scsi_scan_mode rescan)
+	__must_hold(&shost->scan_mutex)
 {
 	unsigned char scsi_cmd[MAX_COMMAND_SIZE];
 	unsigned int length;
@@ -1768,6 +1771,7 @@ EXPORT_SYMBOL(scsi_rescan_device);
 static void __scsi_scan_target(struct Scsi_Host *shost, struct device *p=
arent,
 			       unsigned int channel, unsigned int id, u64 lun,
 			       enum scsi_scan_mode rescan)
+	__must_hold(&shost->scan_mutex)
 {
 	blist_flags_t bflags =3D 0;
 	int res;
@@ -1865,6 +1869,7 @@ EXPORT_SYMBOL(scsi_scan_target);
 static void scsi_scan_channel(struct Scsi_Host *shost, unsigned int chan=
nel,
 			      unsigned int id, u64 lun,
 			      enum scsi_scan_mode rescan)
+	__must_hold(&shost->scan_mutex)
 {
 	uint order_id;
=20
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
