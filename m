Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0C713A782B
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 18:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790361199; cv=none; b=ATswS3+Z5eSh+ONGwxJIctaZqNnSpUF5xtL/lLkYC9y83FM7YBeun9NIhpj6iBGbKPrnP+YLY1Adb09NXjAMldiAsTvTBiMCogATOmht6q50hYugzyAbvs7jkH7+XASfvqpz34tBDS+ZPqZBkAf5EsLUBfdOgV91UjzK6wvcvTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790361199; c=relaxed/simple;
	bh=A8yrtAMH4FO7lLZ1lN3spPan1Aen/bd6ugNJAhUUHcg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EsI7ku4M3YbTshcQSfxOdRybDlNQgOJCBFXM15NLkB4MH2heR2EblL1AWLSkjsh0y6LMa8dIz/CYONGflxHRbv+dLdNTkqqEI3up8W8qPH9ApVvHnJvOpfB2haN7sNFIhWeFbU9yS4CqS9Zyr/hoSh06gCB4DmYQcBgU9wNANHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Wx+Drm/M; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Wx+Drm/M"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hrzq13B2Bz1XM4Tl;
	Fri, 25 Sep 2026 18:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1790361185; x=1792953186; bh=eI5W0
	pTdgERPwOAys4aZQCt5L7Pq+LxA5M7f9sx6XlU=; b=Wx+Drm/MA6KDvhdF6WKCx
	vFX5nJkhZmfIVooj20Peon/8/SOnVZxC2+IGexYzvzxE31yYelHlrUC8yr6AD9Pr
	yWV5wXg/b+YISPTE4od0JtzPZe/c2/wJ+1oy9Dt9ixHe76r1nrMJxwlH1sqxHVF6
	RqYWwPJVE8lPEIjYXGBUCWQwBLKPc0OAA7gKiH2MKv9XhQ6kRg2v2lCQ9gmskmbQ
	PZl5NMV3llMBWJCOiAmpLmPfMLVxiTvPcsxh+G4ZYt48/btDhhONPVL2HpvUw2WG
	/eZj4wPDnAqSV8yXVpAFB7p3WNkU23hvi9K6g1qwV4BZTG9nuJlgKKAvCfKYpSpA
	w==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id zFv-swEm_fl2; Fri, 25 Sep 2026 18:33:05 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hrzpl4gPnz1XM30g;
	Fri, 25 Sep 2026 18:33:03 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Tomas Henzl <thenzl@redhat.com>,
	Don Brace <don.brace@microchip.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Subject: [PATCH v4 51/54] scsi: smartpqi: Enable lock context analysis
Date: Fri, 25 Sep 2026 11:26:29 -0700
Message-ID: <4fd694d95bafa1b09d4e3ff997b10dcd04bc8f8e.1790360262.git.bvanassche@acm.org>
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

Document locking requirements with __acquires(), __releases() and
__cond_releases(). Suppress context analysis complaints with __acquire()
annotations. This approach has been chosen because this driver uses the
mutex API incorrectly. Fixing this driver falls outside the scope of this
patch series.

Cc: Tomas Henzl <thenzl@redhat.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/smartpqi/Makefile        |  3 ++
 drivers/scsi/smartpqi/smartpqi_init.c | 67 ++++++++++++++++++++++-----
 2 files changed, 59 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/smartpqi/Makefile b/drivers/scsi/smartpqi/Makef=
ile
index 28985e508b5c..71db5cd96284 100644
--- a/drivers/scsi/smartpqi/Makefile
+++ b/drivers/scsi/smartpqi/Makefile
@@ -1,3 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
+
+CONTEXT_ANALYSIS :=3D y
+
 obj-$(CONFIG_SCSI_SMARTPQI) +=3D smartpqi.o
 smartpqi-objs :=3D smartpqi_init.o smartpqi_sis.o smartpqi_sas_transport=
.o
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpq=
i/smartpqi_init.c
index d8d0fe915805..9401d9347404 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -97,8 +97,12 @@ static int pqi_aio_submit_r56_write_io(struct pqi_ctrl=
_info *ctrl_info,
 	struct scsi_cmnd *scmd, struct pqi_queue_group *queue_group,
 	struct pqi_encryption_info *encryption_info, struct pqi_scsi_dev *devic=
e,
 	struct pqi_scsi_dev_raid_map_data *rmd);
-static void pqi_ofa_ctrl_quiesce(struct pqi_ctrl_info *ctrl_info);
-static void pqi_ofa_ctrl_unquiesce(struct pqi_ctrl_info *ctrl_info);
+static void pqi_ofa_ctrl_quiesce(struct pqi_ctrl_info *ctrl_info)
+	__acquires(&ctrl_info->scan_mutex)
+	__acquires(&ctrl_info->lun_reset_mutex);
+static void pqi_ofa_ctrl_unquiesce(struct pqi_ctrl_info *ctrl_info)
+	__releases(&ctrl_info->lun_reset_mutex)
+	__releases(&ctrl_info->scan_mutex);
 static int pqi_ofa_ctrl_restart(struct pqi_ctrl_info *ctrl_info, unsigne=
d int delay_secs);
 static void pqi_host_setup_buffer(struct pqi_ctrl_info *ctrl_info, struc=
t pqi_host_memory_descriptor *host_memory_descriptor, u32 total_size, u32=
 min_size);
 static void pqi_host_free_buffer(struct pqi_ctrl_info *ctrl_info, struct=
 pqi_host_memory_descriptor *host_memory_descriptor);
@@ -312,12 +316,14 @@ static inline void pqi_save_fw_triage_setting(struc=
t pqi_ctrl_info *ctrl_info, b
 }
=20
 static inline void pqi_ctrl_block_scan(struct pqi_ctrl_info *ctrl_info)
+	__acquires(&ctrl_info->scan_mutex)
 {
 	ctrl_info->scan_blocked =3D true;
 	mutex_lock(&ctrl_info->scan_mutex);
 }
=20
 static inline void pqi_ctrl_unblock_scan(struct pqi_ctrl_info *ctrl_info=
)
+	__releases(&ctrl_info->scan_mutex)
 {
 	ctrl_info->scan_blocked =3D false;
 	mutex_unlock(&ctrl_info->scan_mutex);
@@ -329,11 +335,13 @@ static inline bool pqi_ctrl_scan_blocked(struct pqi=
_ctrl_info *ctrl_info)
 }
=20
 static inline void pqi_ctrl_block_device_reset(struct pqi_ctrl_info *ctr=
l_info)
+	__acquires(&ctrl_info->lun_reset_mutex)
 {
 	mutex_lock(&ctrl_info->lun_reset_mutex);
 }
=20
 static inline void pqi_ctrl_unblock_device_reset(struct pqi_ctrl_info *c=
trl_info)
+	__releases(&ctrl_info->lun_reset_mutex)
 {
 	mutex_unlock(&ctrl_info->lun_reset_mutex);
 }
@@ -436,11 +444,13 @@ static inline bool pqi_device_offline(struct pqi_sc=
si_dev *device)
 }
=20
 static inline void pqi_ctrl_ofa_start(struct pqi_ctrl_info *ctrl_info)
+	__acquires(&ctrl_info->ofa_mutex)
 {
 	mutex_lock(&ctrl_info->ofa_mutex);
 }
=20
 static inline void pqi_ctrl_ofa_done(struct pqi_ctrl_info *ctrl_info)
+	__releases(&ctrl_info->ofa_mutex)
 {
 	mutex_unlock(&ctrl_info->ofa_mutex);
 }
@@ -2305,6 +2315,8 @@ static void pqi_update_device_list(struct pqi_ctrl_=
info *ctrl_info,
 	 * requests before removal.
 	 */
 	if (pqi_ofa_in_progress(ctrl_info)) {
+		/* What guarantees that &ctrl_info->lun_reset_mutex is held here? */
+		__acquire(&ctrl_info->lun_reset_mutex);
 		list_for_each_entry_safe(device, next, &delete_list, delete_list_entry=
)
 			if (pqi_is_device_added(device))
 				pqi_device_remove_start(device);
@@ -3672,6 +3684,8 @@ static void pqi_process_soft_reset(struct pqi_ctrl_=
info *ctrl_info)
 		pqi_save_ctrl_mode(ctrl_info, SIS_MODE);
 		rc =3D pqi_ofa_ctrl_restart(ctrl_info, delay_secs);
 		pqi_host_free_buffer(ctrl_info, &ctrl_info->ofa_memory);
+		/* What guarantees that &ctrl_info->ofa_mutex is held here? */
+		__acquire(&ctrl_info->ofa_mutex);
 		pqi_ctrl_ofa_done(ctrl_info);
 		dev_info(&ctrl_info->pci_dev->dev,
 				"Online Firmware Activation: %s\n",
@@ -3683,6 +3697,10 @@ static void pqi_process_soft_reset(struct pqi_ctrl=
_info *ctrl_info)
 		if (ctrl_info->soft_reset_handshake_supported)
 			pqi_clear_soft_reset_status(ctrl_info);
 		pqi_host_free_buffer(ctrl_info, &ctrl_info->ofa_memory);
+		/* What guarantees that these mutexes are held here? */
+		__acquire(&ctrl_info->lun_reset_mutex);
+		__acquire(&ctrl_info->ofa_mutex);
+		__acquire(&ctrl_info->scan_mutex);
 		pqi_ctrl_ofa_done(ctrl_info);
 		pqi_ofa_ctrl_unquiesce(ctrl_info);
 		break;
@@ -3693,6 +3711,10 @@ static void pqi_process_soft_reset(struct pqi_ctrl=
_info *ctrl_info)
 			"unexpected Online Firmware Activation reset status: 0x%x\n",
 			reset_status);
 		pqi_host_free_buffer(ctrl_info, &ctrl_info->ofa_memory);
+		/* What guarantees that these mutexes are held here? */
+		__acquire(&ctrl_info->lun_reset_mutex);
+		__acquire(&ctrl_info->ofa_mutex);
+		__acquire(&ctrl_info->scan_mutex);
 		pqi_ctrl_ofa_done(ctrl_info);
 		pqi_ofa_ctrl_unquiesce(ctrl_info);
 		pqi_take_ctrl_offline(ctrl_info, PQI_OFA_RESPONSE_TIMEOUT);
@@ -3700,25 +3722,32 @@ static void pqi_process_soft_reset(struct pqi_ctr=
l_info *ctrl_info)
 	}
 }
=20
-static void pqi_ofa_memory_alloc_worker(struct work_struct *work)
+static inline struct pqi_ctrl_info *alloc_work_to_ctrl_info(struct work_=
struct *work)
 {
-	struct pqi_ctrl_info *ctrl_info;
+	return container_of(work, struct pqi_ctrl_info, ofa_memory_alloc_work);
+}
=20
-	ctrl_info =3D container_of(work, struct pqi_ctrl_info, ofa_memory_alloc=
_work);
+static void pqi_ofa_memory_alloc_worker(struct work_struct *work)
+	__acquires(&alloc_work_to_ctrl_info(work)->ofa_mutex)
+{
+	struct pqi_ctrl_info *ctrl_info =3D alloc_work_to_ctrl_info(work);
=20
 	pqi_ctrl_ofa_start(ctrl_info);
 	pqi_host_setup_buffer(ctrl_info, &ctrl_info->ofa_memory, ctrl_info->ofa=
_bytes_requested, ctrl_info->ofa_bytes_requested);
 	pqi_host_memory_update(ctrl_info, &ctrl_info->ofa_memory, PQI_VENDOR_GE=
NERAL_OFA_MEMORY_UPDATE);
 }
=20
-static void pqi_ofa_quiesce_worker(struct work_struct *work)
+static inline struct pqi_ctrl_info *quiesce_work_to_ctrl_info(struct wor=
k_struct *work)
 {
-	struct pqi_ctrl_info *ctrl_info;
-	struct pqi_event *event;
-
-	ctrl_info =3D container_of(work, struct pqi_ctrl_info, ofa_quiesce_work=
);
+	return container_of(work, struct pqi_ctrl_info, ofa_quiesce_work);
+}
=20
-	event =3D &ctrl_info->events[pqi_event_type_to_event_index(PQI_EVENT_TY=
PE_OFA)];
+static void pqi_ofa_quiesce_worker(struct work_struct *work)
+	__acquires(&quiesce_work_to_ctrl_info(work)->scan_mutex)
+	__acquires(&quiesce_work_to_ctrl_info(work)->lun_reset_mutex)
+{
+	struct pqi_ctrl_info *ctrl_info =3D quiesce_work_to_ctrl_info(work);
+	struct pqi_event *event =3D &ctrl_info->events[pqi_event_type_to_event_=
index(PQI_EVENT_TYPE_OFA)];
=20
 	pqi_ofa_ctrl_quiesce(ctrl_info);
 	pqi_acknowledge_event(ctrl_info, event);
@@ -3749,6 +3778,8 @@ static bool pqi_ofa_process_event(struct pqi_ctrl_i=
nfo *ctrl_info,
 			"received Online Firmware Activation cancel request: reason: %u\n",
 			ctrl_info->ofa_cancel_reason);
 		pqi_host_free_buffer(ctrl_info, &ctrl_info->ofa_memory);
+		/* What guarantees that &ctrl_info->ofa_mutex is held here? */
+		__acquire(&ctrl_info->ofa_mutex);
 		pqi_ctrl_ofa_done(ctrl_info);
 		break;
 	default:
@@ -8893,6 +8924,8 @@ static int pqi_ctrl_init_resume(struct pqi_ctrl_inf=
o *ctrl_info)
 	}
=20
 	if (pqi_ofa_in_progress(ctrl_info)) {
+		/* What guarantees that &ctrl_info->scan_mutex is held here? */
+		__acquire(&ctrl_info->scan_mutex);
 		pqi_ctrl_unblock_scan(ctrl_info);
 		if (ctrl_info->ctrl_logging_supported) {
 			if (!ctrl_info->ctrl_log_memory.host_memory)
@@ -9653,7 +9686,11 @@ static inline enum bmic_flush_cache_shutdown_event=
 pqi_get_flush_cache_shutdown_
 	return SUSPEND;
 }
=20
+#define TO_CTRL_INFO(dev) ((struct pqi_ctrl_info *)pci_get_drvdata(to_pc=
i_dev(dev)))
+
 static int pqi_suspend_or_freeze(struct device *dev, bool suspend)
+	__acquires(&TO_CTRL_INFO(dev)->scan_mutex)
+	__acquires(&TO_CTRL_INFO(dev)->lun_reset_mutex)
 {
 	struct pci_dev *pci_dev;
 	struct pqi_ctrl_info *ctrl_info;
@@ -9687,11 +9724,15 @@ static int pqi_suspend_or_freeze(struct device *d=
ev, bool suspend)
 }
=20
 static __maybe_unused int pqi_suspend(struct device *dev)
+	__acquires(&TO_CTRL_INFO(dev)->scan_mutex)
+	__acquires(&TO_CTRL_INFO(dev)->lun_reset_mutex)
 {
 	return pqi_suspend_or_freeze(dev, true);
 }
=20
 static int pqi_resume_or_restore(struct device *dev)
+	__cond_releases(0, &TO_CTRL_INFO(dev)->lun_reset_mutex)
+	__cond_releases(0, &TO_CTRL_INFO(dev)->scan_mutex)
 {
 	int rc;
 	struct pci_dev *pci_dev;
@@ -9715,11 +9756,15 @@ static int pqi_resume_or_restore(struct device *d=
ev)
 }
=20
 static int pqi_freeze(struct device *dev)
+	__acquires(&TO_CTRL_INFO(dev)->scan_mutex)
+	__acquires(&TO_CTRL_INFO(dev)->lun_reset_mutex)
 {
 	return pqi_suspend_or_freeze(dev, false);
 }
=20
 static int pqi_thaw(struct device *dev)
+	__cond_releases(0, &TO_CTRL_INFO(dev)->lun_reset_mutex)
+	__cond_releases(0, &TO_CTRL_INFO(dev)->scan_mutex)
 {
 	int rc;
 	struct pci_dev *pci_dev;
