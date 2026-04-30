Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2478347B435
	for <linux-scsi@vger.kernel.org>; Thu, 30 Apr 2026 18:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777573539; cv=none; b=EiCNRB3zH0bheMhbzOykqP5VRM+wPaZnWYCsUQ7AgSX9FzcIgx8TSN2tHAmg/HDmJp4Qh2tTmTK13haxbfAr4aPyXxGng1xVJeXI808rdnF06idGSGHDrH13Ym+vKigXg+F9Vy3UraFae7f18jnfR8XsI6J8jWAoh0etN8otsRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777573539; c=relaxed/simple;
	bh=hTtJ1IQOUKJSbBVrWciWfIcnIKXonkFSz/+A88fYy2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GYjftP5p4j0qZwKmKNNgE5DrzBy1IaBugGBIaeEwrDt7bobKcyh+yyEhdXHsgd0bCrqQc7StLh4FdR9K9cLrTQOY37Z9hNbRYa3omkEAjNTxSpXnbNdmw+ZbJQ+6czJ1enwGzzy6HLPkrjp4bGKTCT3ktsHCIBY966pUZbAtNZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=0huF2o4y; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="0huF2o4y"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4g62fT6YrgzlhpdQ;
	Thu, 30 Apr 2026 18:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1777573529; x=1780165530; bh=E3BKZ
	mcTPyPuuof+uSe5kDw9PSvA/m/ns01CHhBsR/I=; b=0huF2o4yJVoUVRYPjMw0f
	Pbl/8B0/+HWGBt68bAMEUhLp8p4Nh1w5AM6mlGxGtNwT3MRyWXgrIGS8pGCOCUN8
	heT1fOoqZp5+/F4JFb40VvEiMKfltc+gzd54P+LCeZMZmluh1EjAoJkRy5ZqBR2I
	1Df/YLubKVCa1cvPoWbdMMpXB4ooUoziNQYtVHgl00A5F3vskuklRWS/nfOPRDhs
	5eb/7WJzLnxjxACM+nETKw64Zf0TNflExFQoxjGzru94CkNbPj1Fi24EemlR9ODT
	DZ08LJKSMr3BxWHVkKAUnUiQLK7hN/K9ZFPudFs/gXR4UyFVtU16sXKgDbu9WNEy
	Q==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id LWLRK4hfpRCc; Thu, 30 Apr 2026 18:25:29 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4g62fH2BFbzlffvd;
	Thu, 30 Apr 2026 18:25:27 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Marco Elver <elver@google.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Tomas Henzl <thenzl@redhat.com>,
	Don Brace <don.brace@microchip.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v2 52/56] scsi: smartpqi: Enable lock context analysis
Date: Thu, 30 Apr 2026 11:20:22 -0700
Message-ID: <20260430182130.1978347-53-bvanassche@acm.org>
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

Document locking requirements with __acquires(), __releases() and
__must_hold(). Annotate functions that perform conditional locking with
__no_context_analysis.

Cc: Tomas Henzl <thenzl@redhat.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/smartpqi/Makefile        |  3 +++
 drivers/scsi/smartpqi/smartpqi_init.c | 33 +++++++++++++++++++++++++++
 2 files changed, 36 insertions(+)

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
index b4ed991976d0..f99eef39ede4 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -306,12 +306,14 @@ static inline void pqi_save_fw_triage_setting(struc=
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
@@ -323,11 +325,13 @@ static inline bool pqi_ctrl_scan_blocked(struct pqi=
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
@@ -430,11 +434,13 @@ static inline bool pqi_device_offline(struct pqi_sc=
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
@@ -2299,6 +2305,7 @@ static void pqi_update_device_list(struct pqi_ctrl_=
info *ctrl_info,
 	 * requests before removal.
 	 */
 	if (pqi_ofa_in_progress(ctrl_info)) {
+		__acquire(&ctrl_info->lun_reset_mutex);
 		list_for_each_entry_safe(device, next, &delete_list, delete_list_entry=
)
 			if (pqi_is_device_added(device))
 				pqi_device_remove_start(device);
@@ -3661,6 +3668,8 @@ static void pqi_process_soft_reset(struct pqi_ctrl_=
info *ctrl_info)
 		pqi_save_ctrl_mode(ctrl_info, SIS_MODE);
 		rc =3D pqi_ofa_ctrl_restart(ctrl_info, delay_secs);
 		pqi_host_free_buffer(ctrl_info, &ctrl_info->ofa_memory);
+		/* What guarantees that &ctrl_info->ofa_mutex is held here? */
+		__acquire(&ctrl_info->ofa_mutex);
 		pqi_ctrl_ofa_done(ctrl_info);
 		dev_info(&ctrl_info->pci_dev->dev,
 				"Online Firmware Activation: %s\n",
@@ -3672,6 +3681,8 @@ static void pqi_process_soft_reset(struct pqi_ctrl_=
info *ctrl_info)
 		if (ctrl_info->soft_reset_handshake_supported)
 			pqi_clear_soft_reset_status(ctrl_info);
 		pqi_host_free_buffer(ctrl_info, &ctrl_info->ofa_memory);
+		/* What guarantees that &ctrl_info->ofa_mutex is held here? */
+		__acquire(&ctrl_info->ofa_mutex);
 		pqi_ctrl_ofa_done(ctrl_info);
 		pqi_ofa_ctrl_unquiesce(ctrl_info);
 		break;
@@ -3682,6 +3693,8 @@ static void pqi_process_soft_reset(struct pqi_ctrl_=
info *ctrl_info)
 			"unexpected Online Firmware Activation reset status: 0x%x\n",
 			reset_status);
 		pqi_host_free_buffer(ctrl_info, &ctrl_info->ofa_memory);
+		/* What guarantees that &ctrl_info->ofa_mutex is held here? */
+		__acquire(&ctrl_info->ofa_mutex);
 		pqi_ctrl_ofa_done(ctrl_info);
 		pqi_ofa_ctrl_unquiesce(ctrl_info);
 		pqi_take_ctrl_offline(ctrl_info, PQI_OFA_RESPONSE_TIMEOUT);
@@ -3698,6 +3711,8 @@ static void pqi_ofa_memory_alloc_worker(struct work=
_struct *work)
 	pqi_ctrl_ofa_start(ctrl_info);
 	pqi_host_setup_buffer(ctrl_info, &ctrl_info->ofa_memory, ctrl_info->ofa=
_bytes_requested, ctrl_info->ofa_bytes_requested);
 	pqi_host_memory_update(ctrl_info, &ctrl_info->ofa_memory, PQI_VENDOR_GE=
NERAL_OFA_MEMORY_UPDATE);
+	/* This function acquires &ctrl_info->ofa_mutex and doesn't release it.=
 */
+	__release(&ctrl_info->ofa_mutex);
 }
=20
 static void pqi_ofa_quiesce_worker(struct work_struct *work)
@@ -3738,6 +3753,8 @@ static bool pqi_ofa_process_event(struct pqi_ctrl_i=
nfo *ctrl_info,
 			"received Online Firmware Activation cancel request: reason: %u\n",
 			ctrl_info->ofa_cancel_reason);
 		pqi_host_free_buffer(ctrl_info, &ctrl_info->ofa_memory);
+		/* What guarantees that &ctrl_info->ofa_mutex is held here? */
+		__acquire(&ctrl_info->ofa_mutex);
 		pqi_ctrl_ofa_done(ctrl_info);
 		break;
 	default:
@@ -8726,6 +8743,7 @@ static int pqi_ctrl_init_resume(struct pqi_ctrl_inf=
o *ctrl_info)
 	}
=20
 	if (pqi_ofa_in_progress(ctrl_info)) {
+		__acquire(&ctrl_info->scan_mutex);
 		pqi_ctrl_unblock_scan(ctrl_info);
 		if (ctrl_info->ctrl_logging_supported) {
 			if (!ctrl_info->ctrl_log_memory.host_memory)
@@ -8938,6 +8956,8 @@ static void pqi_remove_ctrl(struct pqi_ctrl_info *c=
trl_info)
 }
=20
 static void pqi_ofa_ctrl_quiesce(struct pqi_ctrl_info *ctrl_info)
+	__acquires(&ctrl_info->scan_mutex)
+	__acquires(&ctrl_info->lun_reset_mutex)
 {
 	pqi_ctrl_block_scan(ctrl_info);
 	pqi_scsi_block_requests(ctrl_info);
@@ -8948,6 +8968,8 @@ static void pqi_ofa_ctrl_quiesce(struct pqi_ctrl_in=
fo *ctrl_info)
 }
=20
 static void pqi_ofa_ctrl_unquiesce(struct pqi_ctrl_info *ctrl_info)
+	__releases(&ctrl_info->lun_reset_mutex)
+	__releases(&ctrl_info->scan_mutex)
 {
 	pqi_start_heartbeat_timer(ctrl_info);
 	pqi_ctrl_unblock_requests(ctrl_info);
@@ -9410,6 +9432,7 @@ static void pqi_shutdown(struct pci_dev *pci_dev)
 	pqi_ctrl_block_device_reset(ctrl_info);
 	pqi_ctrl_block_requests(ctrl_info);
 	pqi_ctrl_wait_until_quiesced(ctrl_info);
+	__release(&ctrl_info->lun_reset_mutex);
=20
 	if (system_state =3D=3D SYSTEM_RESTART)
 		shutdown_event =3D RESTART;
@@ -9486,6 +9509,8 @@ static inline enum bmic_flush_cache_shutdown_event =
pqi_get_flush_cache_shutdown_
 }
=20
 static int pqi_suspend_or_freeze(struct device *dev, bool suspend)
+	__acquires(&((struct pqi_ctrl_info *)pci_get_drvdata(to_pci_dev(dev)))-=
>scan_mutex)
+	__acquires(&((struct pqi_ctrl_info *)pci_get_drvdata(to_pci_dev(dev)))-=
>lun_reset_mutex)
 {
 	struct pci_dev *pci_dev;
 	struct pqi_ctrl_info *ctrl_info;
@@ -9519,11 +9544,15 @@ static int pqi_suspend_or_freeze(struct device *d=
ev, bool suspend)
 }
=20
 static __maybe_unused int pqi_suspend(struct device *dev)
+	__acquires(&((struct pqi_ctrl_info *)pci_get_drvdata(to_pci_dev(dev)))-=
>scan_mutex)
+	__acquires(&((struct pqi_ctrl_info *)pci_get_drvdata(to_pci_dev(dev)))-=
>lun_reset_mutex)
 {
 	return pqi_suspend_or_freeze(dev, true);
 }
=20
 static int pqi_resume_or_restore(struct device *dev)
+	__cond_releases(0, &((struct pqi_ctrl_info *)pci_get_drvdata(to_pci_dev=
(dev)))->lun_reset_mutex)
+	__cond_releases(0, &((struct pqi_ctrl_info *)pci_get_drvdata(to_pci_dev=
(dev)))->scan_mutex)
 {
 	int rc;
 	struct pci_dev *pci_dev;
@@ -9547,11 +9576,15 @@ static int pqi_resume_or_restore(struct device *d=
ev)
 }
=20
 static int pqi_freeze(struct device *dev)
+	__acquires(&((struct pqi_ctrl_info *)pci_get_drvdata(to_pci_dev(dev)))-=
>scan_mutex)
+	__acquires(&((struct pqi_ctrl_info *)pci_get_drvdata(to_pci_dev(dev)))-=
>lun_reset_mutex)
 {
 	return pqi_suspend_or_freeze(dev, false);
 }
=20
 static int pqi_thaw(struct device *dev)
+	__cond_releases(0, &((struct pqi_ctrl_info *)pci_get_drvdata(to_pci_dev=
(dev)))->lun_reset_mutex)
+	__cond_releases(0, &((struct pqi_ctrl_info *)pci_get_drvdata(to_pci_dev=
(dev)))->scan_mutex)
 {
 	int rc;
 	struct pci_dev *pci_dev;
