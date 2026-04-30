Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A42123FADF6
	for <linux-scsi@vger.kernel.org>; Thu, 30 Apr 2026 18:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777573534; cv=none; b=XWfCx4etICHrbk3ZN/KtFZRKkecQzVW68H45YJCfTcPAM+VDKpu+ZcBGKwxCw1Aq5m+VNC8xtJOyXhCe4X6bhNxLvDn03JSHfPCg0uWlT0ccbrbvIhyHWga1jWsRVY0M+k2wyNeywJGGZQUnnisM+lzx0KzBnEqvOmcKbPPH9RA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777573534; c=relaxed/simple;
	bh=b6dH2xbhsEeSxS42zXIMJs8QwUPQFAT+H6Kmq7pe/As=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k76fQCjzkJawpth7rSN+vXao1t5dF+wfGiHsLkc6B+n/BKwhbudb0YjgzD3tzxds3ygoFOMG2mrjl0M4MeR6hCa2uaKIhPKnT1o1i7L18kO4haxUQZ8TQF7IbmDF1f5eaCMJuZDIuI44/SOQ+Ba6wxGre1B8DmERZKaBUD55SgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Ux9nOsBI; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Ux9nOsBI"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4g62fN36sqzlgyGq;
	Thu, 30 Apr 2026 18:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1777573523; x=1780165524; bh=ak5xN
	c5em8E3/S5aMwYyt/RFCH7TOIASBbZPDtwMadk=; b=Ux9nOsBIZrhAOeFWVOVBS
	wZVydIlIUozUQFOTqLMDQMguosA/JXAqFjM3sixGLCD5ITw7uEwPtHEJFc9rWH1R
	zFdz+ZH663/OPrJ5siM5GydYh5sUL6L4iL210txdI/W49shn8bpJgsjDydqebnhQ
	MbSFKaBP2PZ0/ci3+r4WJmrraXd3/YUiKhIhRnh4321c+Xvj/tqGaa8w3EaBy90K
	ie6db8B/ZC9+DnDFdhJIYtJD1QPsN41E3OzwJgoapyFIvT4+ihBnXfIvdb/KNoc6
	StZHe0ori2AGeZbaP1EtzJw5upuJqulLdH1O/RXPleOCICBF73oIkDVuVf1Az6Hf
	Q==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id AnPFUYiBXcTJ; Thu, 30 Apr 2026 18:25:23 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4g62f52SmCzlfvpH;
	Thu, 30 Apr 2026 18:25:17 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Marco Elver <elver@google.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Can Guo <can.guo@oss.qualcomm.com>,
	Bean Huo <beanhuo@micron.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ajay Neeli <ajay.neeli@amd.com>,
	Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>
Subject: [PATCH v2 50/56] scsi: ufs: Enable lock context analysis
Date: Thu, 30 Apr 2026 11:20:20 -0700
Message-ID: <20260430182130.1978347-51-bvanassche@acm.org>
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

Annotate functions that modify the state of a synchronization object.
Remove the struct semaphore annotations because lock context annotations
are not supported for semaphores.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/Makefile      |  2 ++
 drivers/ufs/core/ufs-debugfs.c |  8 ++++++--
 drivers/ufs/core/ufshcd.c      | 14 ++++++++++++++
 drivers/ufs/host/Makefile      |  2 ++
 4 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/Makefile b/drivers/ufs/core/Makefile
index ce7d16d2cf35..67ab9ffbdf5d 100644
--- a/drivers/ufs/core/Makefile
+++ b/drivers/ufs/core/Makefile
@@ -1,5 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
=20
+CONTEXT_ANALYSIS :=3D y
+
 obj-$(CONFIG_SCSI_UFSHCD)		+=3D ufshcd-core.o
 ufshcd-core-y				+=3D ufshcd.o ufs-sysfs.o ufs-mcq.o ufs-txeq.o
 ufshcd-core-$(CONFIG_RPMB)		+=3D ufs-rpmb.o
diff --git a/drivers/ufs/core/ufs-debugfs.c b/drivers/ufs/core/ufs-debugf=
s.c
index e3dd81d6fe82..814816810388 100644
--- a/drivers/ufs/core/ufs-debugfs.c
+++ b/drivers/ufs/core/ufs-debugfs.c
@@ -65,8 +65,10 @@ static int ee_usr_mask_get(void *data, u64 *val)
 	return 0;
 }
=20
+token_context_lock(ufs_debugfs);
+
 static int ufs_debugfs_get_user_access(struct ufs_hba *hba)
-__acquires(&hba->host_sem)
+	__cond_acquires(0, ufs_debugfs)
 {
 	down(&hba->host_sem);
 	if (!ufshcd_is_user_access_allowed(hba)) {
@@ -74,14 +76,16 @@ __acquires(&hba->host_sem)
 		return -EBUSY;
 	}
 	ufshcd_rpm_get_sync(hba);
+	__acquire(ufs_debugfs);
 	return 0;
 }
=20
 static void ufs_debugfs_put_user_access(struct ufs_hba *hba)
-__releases(&hba->host_sem)
+	__releases(ufs_debugfs)
 {
 	ufshcd_rpm_put_sync(hba);
 	up(&hba->host_sem);
+	__release(ufs_debugfs);
 }
=20
 static int ee_usr_mask_set(void *data, u64 val)
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 4805e40ed4d7..6fed3f38c010 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1376,6 +1376,8 @@ static int ufshcd_wait_for_pending_cmds(struct ufs_=
hba *hba,
  * On failure, all acquired locks are released and the tagset is unquies=
ced.
  */
 int ufshcd_pause_command_processing(struct ufs_hba *hba, u64 timeout_us)
+	__cond_acquires(0, &hba->host->scan_mutex)
+	__cond_acquires(0, &hba->clk_scaling_lock)
 {
 	int ret =3D 0;
=20
@@ -1400,6 +1402,8 @@ int ufshcd_pause_command_processing(struct ufs_hba =
*hba, u64 timeout_us)
  * This function resumes command submissions.
  */
 void ufshcd_resume_command_processing(struct ufs_hba *hba)
+	__releases(&hba->clk_scaling_lock)
+	__releases(&hba->host->scan_mutex)
 {
 	up_write(&hba->clk_scaling_lock);
 	blk_mq_unquiesce_tagset(&hba->host->tag_set);
@@ -1469,6 +1473,9 @@ static int ufshcd_scale_gear(struct ufs_hba *hba, u=
32 target_gear, bool scale_up
  * Return: 0 upon success; -EBUSY upon timeout.
  */
 static int ufshcd_clock_scaling_prepare(struct ufs_hba *hba, u64 timeout=
_us)
+	__cond_acquires(0, &hba->host->scan_mutex)
+	__cond_acquires(0, &hba->wb_mutex)
+	__cond_acquires(0, &hba->clk_scaling_lock)
 {
 	int ret =3D 0;
 	/*
@@ -1498,6 +1505,9 @@ static int ufshcd_clock_scaling_prepare(struct ufs_=
hba *hba, u64 timeout_us)
 }
=20
 static void ufshcd_clock_scaling_unprepare(struct ufs_hba *hba, int err)
+	__releases(&hba->clk_scaling_lock)
+	__releases(&hba->wb_mutex)
+	__releases(&hba->host->scan_mutex)
 {
 	up_write(&hba->clk_scaling_lock);
 	mutex_unlock(&hba->wb_mutex);
@@ -3301,6 +3311,8 @@ ufshcd_dev_cmd_completion(struct ufs_hba *hba, stru=
ct ufshcd_lrb *lrbp)
 }
=20
 static void ufshcd_dev_man_lock(struct ufs_hba *hba)
+	__acquires(&hba->dev_cmd.lock)
+	__acquires_shared(&hba->clk_scaling_lock)
 {
 	ufshcd_hold(hba);
 	mutex_lock(&hba->dev_cmd.lock);
@@ -3308,6 +3320,8 @@ static void ufshcd_dev_man_lock(struct ufs_hba *hba=
)
 }
=20
 static void ufshcd_dev_man_unlock(struct ufs_hba *hba)
+	__releases_shared(&hba->clk_scaling_lock)
+	__releases(&hba->dev_cmd.lock)
 {
 	up_read(&hba->clk_scaling_lock);
 	mutex_unlock(&hba->dev_cmd.lock);
diff --git a/drivers/ufs/host/Makefile b/drivers/ufs/host/Makefile
index 65d8bb23ab7b..7d8db67eb23c 100644
--- a/drivers/ufs/host/Makefile
+++ b/drivers/ufs/host/Makefile
@@ -1,5 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
=20
+CONTEXT_ANALYSIS :=3D y
+
 obj-$(CONFIG_SCSI_UFS_DWC_TC_PCI) +=3D tc-dwc-g210-pci.o ufshcd-dwc.o tc=
-dwc-g210.o
 obj-$(CONFIG_SCSI_UFS_DWC_TC_PLATFORM) +=3D tc-dwc-g210-pltfrm.o ufshcd-=
dwc.o tc-dwc-g210.o
 obj-$(CONFIG_SCSI_UFS_CDNS_PLATFORM) +=3D cdns-pltfrm.o
