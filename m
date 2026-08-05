Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CE1E3EDAB3
	for <linux-scsi@vger.kernel.org>; Wed,  5 Aug 2026 21:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785965867; cv=none; b=HG15GBRFIFDay+BzmbO5Wy3C8KRJgmHRs65Qe6xoAEauwT7Tg1Xh4xTTs1GONGDa4mCkdZH0aKUqueQ37QijqdLv3jdNJmDPyA07YGUbTFQPzV2b/JUaCofnBW5GsuG/ycIPJjIcePi9HufjPofPM8mz4rei6Iv16952xD8qPEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785965867; c=relaxed/simple;
	bh=vYIiQWlJr/XycWWGdM7rLkc0d1D6hKk127BwmCCtvRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CpRlhFTBBHemNQVpamrpX9/s/UZP7H12TtYhUPbS4DNmm7y7sjMZNa9oW1L3gR0zqGJ6itl0qlamTUsXCh7NbS4GKm7kxXpWoZPAMW+0fT9lQdN9QaZGHKX3ZsxcZCh6w1xtmMXdnP1Ed/2j+1qKCrihAocNkRJQFi+wL00DrnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=QtKs7lfJ; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="QtKs7lfJ"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hFkKP53DBz1XM6Jk;
	Wed,  5 Aug 2026 21:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1785965853; x=1788557854; bh=+Ycua
	ZlTpye+dnNlkK4Suyi34UJKEkKdFfL6E0RxSkg=; b=QtKs7lfJSzuVQ6u7x/mqb
	nVmoVptesuPhR8XdP9O30fQw2W+I/YiZfMyQne3IsMYOFjEbcn9ATOasAK+7x4Qv
	BWeHixNOSV5mFpSJ9UEm8TdRqzX8/i/xvl9oDDRGijO10nBAG5Wnkz36znoUuJch
	NaWS28Rvn+t3RTDna/j+HCfaPXWIJBmvmQlVpwHdhgbUEl+1+nA1nophFs6sbavK
	wHOydfV5ylPU+Vy9SzkAlvcpPpsVyVtCK8n6WesorKxYw1uscy9KR7Gce9Jr8KAQ
	qNv8pZV5AQsUARgoGo324jYFbldPiIc1vReNg29ymEev++UGdP3i7Jndyga4gdlj
	g==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id W3kTtT2r0-Xa; Wed,  5 Aug 2026 21:37:33 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hFkK55SZ8z1XM30n;
	Wed,  5 Aug 2026 21:37:29 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: John Garry <john.g.garry@oracle.com>,
	Marco Elver <elver@google.com>,
	linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Peter Wang <peter.wang@mediatek.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Bean Huo <beanhuo@micron.com>,
	Can Guo <can.guo@oss.qualcomm.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>,
	Ajay Neeli <ajay.neeli@amd.com>
Subject: [PATCH v5 2/6] ufs: core: Enable lock context analysis
Date: Wed,  5 Aug 2026 14:36:49 -0700
Message-ID: <586ee9962a952a6b31b7136ba6193c51a20ec811.1785965531.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.55.0.629.g250fe7f194-goog
In-Reply-To: <cover.1785965531.git.bvanassche@acm.org>
References: <cover.1785965531.git.bvanassche@acm.org>
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

Reviewed-by: Peter Wang <peter.wang@mediatek.com>
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
index 5f99aad26d57..b34e2da4c320 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1354,6 +1354,8 @@ static int ufshcd_wait_for_pending_cmds(struct ufs_=
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
@@ -1378,6 +1380,8 @@ int ufshcd_pause_command_processing(struct ufs_hba =
*hba, u64 timeout_us)
  * This function resumes command submissions.
  */
 void ufshcd_resume_command_processing(struct ufs_hba *hba)
+	__releases(&hba->clk_scaling_lock)
+	__releases(&hba->host->scan_mutex)
 {
 	up_write(&hba->clk_scaling_lock);
 	blk_mq_unquiesce_tagset(&hba->host->tag_set);
@@ -1447,6 +1451,9 @@ static int ufshcd_scale_gear(struct ufs_hba *hba, u=
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
@@ -1476,6 +1483,9 @@ static int ufshcd_clock_scaling_prepare(struct ufs_=
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
@@ -3283,6 +3293,8 @@ ufshcd_dev_cmd_completion(struct ufs_hba *hba, stru=
ct ufshcd_lrb *lrbp)
 }
=20
 static void ufshcd_dev_man_lock(struct ufs_hba *hba)
+	__acquires(&hba->dev_cmd.lock)
+	__acquires_shared(&hba->clk_scaling_lock)
 {
 	ufshcd_hold(hba);
 	mutex_lock(&hba->dev_cmd.lock);
@@ -3290,6 +3302,8 @@ static void ufshcd_dev_man_lock(struct ufs_hba *hba=
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
