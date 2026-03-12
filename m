Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EF0E3CAE73
	for <linux-scsi@vger.kernel.org>; Thu, 12 Mar 2026 21:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773350312; cv=none; b=GJ/dkplCY8Kr0SsY5fK1t+YZ2kJsi985FvT9KvqfU2CH342tpNoM4R0XL/tJcHZfD4l3JBEjiHyd9HOVMlWlXzhRGeackasl4M4b5IKwdElN2GrTKfxsMOt79zpWwRnBlk+/+beZzLu1eXkWX4z5QU/uCYu/s4R6xwSAQB1eWPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773350312; c=relaxed/simple;
	bh=Op2xxYqFGe8XFJMQ/wiLJWfwuVDd+vD9wVTkvqaHgF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s6pktC3C7kJlFkXVb0ATm8ZhUNjd4TO8cKcKxVsLHwMSaNIDBCcoG1w9xaHcGA5Skh+AlKPgHa8z2dmGiSsUUtyUvT4U7bfdMg+ope6VDHh3iF0aDV1AMfDWTWPuO6eztdaWwz24j17sHJUn3dYVJ+QGVpbT5GUS5pL//WRl8g0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=1SklbjSr; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="1SklbjSr"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4fX0pY01mvzlfl8L;
	Thu, 12 Mar 2026 21:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1773350304; x=1775942305; bh=doCpq
	rBDh1frlJt+X+TxP4wpSiPQFsczJ2pfHAK+x04=; b=1SklbjSrMhx9lFh8a8EdD
	AQCQIr+CB7+XU7MqxyiH4ZiNbcBGxb6li8Uz8Nq9QWTPzc6ONh0GSvevbLJVWMv1
	VAzVzlJeosLtCQCUoZhD3svBcnguRmpp15bjqqKM7VOHs/xlT6WBgu/RQYYBwBMZ
	5W7yRqNdpEABuuE5z5zzR8t1DJXwHm8UweuHPA2RCMtdTWRqPT2RfaUpnli/J3Zw
	h467vjXCYijOGa24A3O1wuzheGUK8Fv68JArWv5hm70iAryL1yQ9+ZsO7QEANTpb
	thvs4eKjY/ut68XSDoK/ISLsrdpidgF1AHqbd9BQg+uJ3GmswTxwB5nScp8JrXfE
	w==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id bcn-5CcIGz5N; Thu, 12 Mar 2026 21:18:24 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4fX0pQ30vKzlfl5V;
	Thu, 12 Mar 2026 21:18:22 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Don Brace <don.brace@microchip.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 34/36] scsi: smartpqi: Prepare for enabling lock context analysis
Date: Thu, 12 Mar 2026 14:15:45 -0700
Message-ID: <20260312211636.3245119-35-bvanassche@acm.org>
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

Document locking requirements with __acquires(), __releases() and
__must_hold(). Annotate functions that perform conditional locking with
__no_context_analysis.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpq=
i/smartpqi_init.c
index b4ed991976d0..2a36a798b66a 100644
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
@@ -2210,6 +2216,7 @@ static inline bool pqi_volume_rescan_needed(struct =
pqi_scsi_dev *device)
=20
 static void pqi_update_device_list(struct pqi_ctrl_info *ctrl_info,
 	struct pqi_scsi_dev *new_device_list[], unsigned int num_new_devices)
+	__no_context_analysis /* conditional locking */
 {
 	int rc;
 	unsigned int i;
@@ -3635,6 +3642,7 @@ static enum pqi_soft_reset_status pqi_poll_for_soft=
_reset_status(
 }
=20
 static void pqi_process_soft_reset(struct pqi_ctrl_info *ctrl_info)
+	__no_context_analysis /* conditional locking */
 {
 	int rc;
 	unsigned int delay_secs;
@@ -3690,6 +3698,7 @@ static void pqi_process_soft_reset(struct pqi_ctrl_=
info *ctrl_info)
 }
=20
 static void pqi_ofa_memory_alloc_worker(struct work_struct *work)
+	__no_context_analysis /* conditional locking */
 {
 	struct pqi_ctrl_info *ctrl_info;
=20
@@ -3716,6 +3725,7 @@ static void pqi_ofa_quiesce_worker(struct work_stru=
ct *work)
=20
 static bool pqi_ofa_process_event(struct pqi_ctrl_info *ctrl_info,
 	struct pqi_event *event)
+	__no_context_analysis /* conditional locking */
 {
 	bool ack_event;
=20
@@ -3780,6 +3790,7 @@ static void pqi_disable_raid_bypass(struct pqi_ctrl=
_info *ctrl_info)
 }
=20
 static void pqi_event_worker(struct work_struct *work)
+	__no_context_analysis /* conditional locking */
 {
 	unsigned int i;
 	bool rescan_needed;
@@ -8603,6 +8614,7 @@ static void pqi_reinit_queues(struct pqi_ctrl_info =
*ctrl_info)
 }
=20
 static int pqi_ctrl_init_resume(struct pqi_ctrl_info *ctrl_info)
+	__no_context_analysis /* conditional locking */
 {
 	int rc;
=20
@@ -8938,6 +8950,7 @@ static void pqi_remove_ctrl(struct pqi_ctrl_info *c=
trl_info)
 }
=20
 static void pqi_ofa_ctrl_quiesce(struct pqi_ctrl_info *ctrl_info)
+	__no_context_analysis /* conditional locking */
 {
 	pqi_ctrl_block_scan(ctrl_info);
 	pqi_scsi_block_requests(ctrl_info);
@@ -8948,6 +8961,7 @@ static void pqi_ofa_ctrl_quiesce(struct pqi_ctrl_in=
fo *ctrl_info)
 }
=20
 static void pqi_ofa_ctrl_unquiesce(struct pqi_ctrl_info *ctrl_info)
+	__no_context_analysis /* conditional locking */
 {
 	pqi_start_heartbeat_timer(ctrl_info);
 	pqi_ctrl_unblock_requests(ctrl_info);
@@ -9392,6 +9406,7 @@ static void pqi_crash_if_pending_command(struct pqi=
_ctrl_info *ctrl_info)
 }
=20
 static void pqi_shutdown(struct pci_dev *pci_dev)
+	__no_context_analysis /* conditional locking */
 {
 	int rc;
 	struct pqi_ctrl_info *ctrl_info;
@@ -9486,6 +9501,7 @@ static inline enum bmic_flush_cache_shutdown_event =
pqi_get_flush_cache_shutdown_
 }
=20
 static int pqi_suspend_or_freeze(struct device *dev, bool suspend)
+	__no_context_analysis /* conditional locking */
 {
 	struct pci_dev *pci_dev;
 	struct pqi_ctrl_info *ctrl_info;
@@ -9524,6 +9540,7 @@ static __maybe_unused int pqi_suspend(struct device=
 *dev)
 }
=20
 static int pqi_resume_or_restore(struct device *dev)
+	__no_context_analysis /* conditional locking */
 {
 	int rc;
 	struct pci_dev *pci_dev;
@@ -9552,6 +9569,7 @@ static int pqi_freeze(struct device *dev)
 }
=20
 static int pqi_thaw(struct device *dev)
+	__no_context_analysis /* conditional locking */
 {
 	int rc;
 	struct pci_dev *pci_dev;
