Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1AAA3D5221
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 22:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785451774; cv=none; b=QxsceDTC70XqcD/9eEvCx9a2qv8Oy9rpNvqJ+6glyhHRnKCcmT25VU3rqgqlRzDyNl3EK7wLSorbvGK8Zt/Fk07sTmCbWzNmh+/cQlhmSn6ttmnQdZ8gmU6i4JEp0j1mxiM1OtQItZ7hZkPm73QH3fMxOSxNN1faU6LuST5Pbrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785451774; c=relaxed/simple;
	bh=a4e5TyR3mLeC+Buil+vOoeCRj9/Bc0HBtO3S50QFfSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZRWH5gxuL7Dhb1BDaJkkiT1spsdgOD77wW2BeiypY3jH3XsqVEgJ23WT/ym9dCXlzWPGHtCfamAzTMLHVOV3q/LRM2wzru4JmLt1jAF2vJXVfG6yNMG6Tzgf9eqnv0cUBI+qM+bW17ScSr6HaoNi/P/MCfvlJylAE3WZ+HA1XX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=lh1wJJKU; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="lh1wJJKU"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hB4C03ktYz1XM0ny;
	Thu, 30 Jul 2026 22:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1785451762; x=1788043763; bh=z4gGB
	DHDAkVaUkWFuZe0Z1xQVy89Xb8n3HBAIFWbi0M=; b=lh1wJJKUu1lcAlcyfJ7je
	TaVHMLgCuVBn/l5ih11GW1DX+cBBTiBA3A/Xe3qv+TNHG5dOgYyVmCY3fLi2scv9
	MOjCWPszvumI3P9jnjQkE2lwbCvY3xLJFCCcIxBHBA9hbX7P3qlxuRmKSnVY7QP4
	p3dm0LCElLWRkpVXlHJb3CaEDAFiGM+uZJMeYY9bZSM2T+qIV/T2dQET8FT0KrGb
	MSONTFpIUOvk/OduNM61VtTnXPFgvP1R65N2dN/jeW0sw1LqSMerw6UCb4Ksp5TB
	0p0O2OYZxwMbXCRYtRZDnz8TBp3ghlYD2fLbfFkqDO2kY62HXF9J98XcoW9UOd1m
	g==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id wa-cke1AEwNU; Thu, 30 Jul 2026 22:49:22 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hB4Bl3Njrz1XM6Jb;
	Thu, 30 Jul 2026 22:49:19 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Marco Elver <elver@google.com>,
	linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Tomas Henzl <thenzl@redhat.com>,
	Don Brace <don.brace@microchip.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v3 52/57] scsi: smartpqi: Enable lock context analysis
Date: Thu, 30 Jul 2026 15:45:35 -0700
Message-ID: <47e31945d3981b05b9e1a94045f0e2f62bcd8cca.1785451174.git.bvanassche@acm.org>
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

Document locking requirements with __acquires(), __releases() and
__must_hold(). Annotate functions that perform conditional locking with
__no_context_analysis.

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
index 140e8a6addbe..ba0d248efc8f 100644
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
+	__acquires(ctrl_info->scan_mutex)
 {
 	ctrl_info->scan_blocked =3D true;
 	mutex_lock(&ctrl_info->scan_mutex);
 }
=20
 static inline void pqi_ctrl_unblock_scan(struct pqi_ctrl_info *ctrl_info=
)
+	__releases(ctrl_info->scan_mutex)
 {
 	ctrl_info->scan_blocked =3D false;
 	mutex_unlock(&ctrl_info->scan_mutex);
@@ -329,11 +335,13 @@ static inline bool pqi_ctrl_scan_blocked(struct pqi=
_ctrl_info *ctrl_info)
 }
=20
 static inline void pqi_ctrl_block_device_reset(struct pqi_ctrl_info *ctr=
l_info)
+	__acquires(ctrl_info->lun_reset_mutex)
 {
 	mutex_lock(&ctrl_info->lun_reset_mutex);
 }
=20
 static inline void pqi_ctrl_unblock_device_reset(struct pqi_ctrl_info *c=
trl_info)
+	__releases(ctrl_info->lun_reset_mutex)
 {
 	mutex_unlock(&ctrl_info->lun_reset_mutex);
 }
@@ -436,11 +444,13 @@ static inline bool pqi_device_offline(struct pqi_sc=
si_dev *device)
 }
=20
 static inline void pqi_ctrl_ofa_start(struct pqi_ctrl_info *ctrl_info)
+	__acquires(ctrl_info->ofa_mutex)
 {
 	mutex_lock(&ctrl_info->ofa_mutex);
 }
=20
 static inline void pqi_ctrl_ofa_done(struct pqi_ctrl_info *ctrl_info)
+	__releases(ctrl_info->ofa_mutex)
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
@@ -3667,6 +3679,8 @@ static void pqi_process_soft_reset(struct pqi_ctrl_=
info *ctrl_info)
 		pqi_save_ctrl_mode(ctrl_info, SIS_MODE);
 		rc =3D pqi_ofa_ctrl_restart(ctrl_info, delay_secs);
 		pqi_host_free_buffer(ctrl_info, &ctrl_info->ofa_memory);
+		/* What guarantees that &ctrl_info->ofa_mutex is held here? */
+		__acquire(&ctrl_info->ofa_mutex);
 		pqi_ctrl_ofa_done(ctrl_info);
 		dev_info(&ctrl_info->pci_dev->dev,
 				"Online Firmware Activation: %s\n",
@@ -3678,6 +3692,10 @@ static void pqi_process_soft_reset(struct pqi_ctrl=
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
@@ -3688,6 +3706,10 @@ static void pqi_process_soft_reset(struct pqi_ctrl=
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
@@ -3695,25 +3717,32 @@ static void pqi_process_soft_reset(struct pqi_ctr=
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
@@ -3744,6 +3773,8 @@ static bool pqi_ofa_process_event(struct pqi_ctrl_i=
nfo *ctrl_info,
 			"received Online Firmware Activation cancel request: reason: %u\n",
 			ctrl_info->ofa_cancel_reason);
 		pqi_host_free_buffer(ctrl_info, &ctrl_info->ofa_memory);
+		/* What guarantees that &ctrl_info->ofa_mutex is held here? */
+		__acquire(&ctrl_info->ofa_mutex);
 		pqi_ctrl_ofa_done(ctrl_info);
 		break;
 	default:
@@ -8888,6 +8919,8 @@ static int pqi_ctrl_init_resume(struct pqi_ctrl_inf=
o *ctrl_info)
 	}
=20
 	if (pqi_ofa_in_progress(ctrl_info)) {
+		/* What guarantees that &ctrl_info->scan_mutex is held here? */
+		__acquire(&ctrl_info->scan_mutex);
 		pqi_ctrl_unblock_scan(ctrl_info);
 		if (ctrl_info->ctrl_logging_supported) {
 			if (!ctrl_info->ctrl_log_memory.host_memory)
@@ -9648,7 +9681,11 @@ static inline enum bmic_flush_cache_shutdown_event=
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
@@ -9682,11 +9719,15 @@ static int pqi_suspend_or_freeze(struct device *d=
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
@@ -9710,11 +9751,15 @@ static int pqi_resume_or_restore(struct device *d=
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
