Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AE2138B132
	for <linux-scsi@vger.kernel.org>; Thu, 12 Mar 2026 21:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773350306; cv=none; b=PrQz1hiz2uCdR6ruleONeAQfNDVFmT0t50E4+5a+KAj5mazEl54j4oJp/shXdVKnOWxLxTknTXxa/QAso8b84ad5YZ9eq/RtT486+qgHben0ErrpBm9F3p/NKi7Z349koisB4MuuUE2MxsHxXGf5FGQ7/IslfqH+LoO9BkuYe7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773350306; c=relaxed/simple;
	bh=gjhiACdZ4IgSb4Mh6BMPUTUaioGyOO6nX8h/yQZzW78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rRnARs0FO4c/5afMd3TivUJMENmagII3CgZ5Szk6A6JFeYmNvJa0D/tND7wKDWqFF4Ia54yLuPBd5xoDeP9kEEB3hO7DI+DF8V2c/ObaCTTuc8aZb5IbJtXTguOJiws2oTNvp116gHXpjQe8U0yncoPFqA4WAC6WjwrreXm8ZiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=VMIUoKCn; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="VMIUoKCn"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4fX0pT2hYrzlfl8L;
	Thu, 12 Mar 2026 21:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1773350299; x=1775942300; bh=r/1tz
	KE7crjwPznQmtaiOePzkBhjhvYsLPHmv+PVrnI=; b=VMIUoKCniLOPTZfs0Yh2J
	5xBWOGNO/YFhkWFBVIzyo+Un0vuvGlEFlitA0QBgZtyXkM/oXdIULTomVLLZsZwG
	QG/8md1sTsJyTJIWjJDJGdP+kbuC4y3i7n1HnvN7oPH9tRwnpqWTpBhRQIbaaiwS
	YlrdKbNHfafGpycXBq0HhgPf3yRubdogJDqNuYDgEpxhqCBCQ/5anGiiczdzunDK
	EXFg25CkCFuL1+clJlLemXvgjaO4/FI5ZT3Hmn8Wi1+K8YWFolwKQB8sr1waLjRt
	DeoajtKHEakOwoCbLBPuWrdX0kppWuQa/lmxX7v5VcB3jow4BxpmQ15eMVvM6XXg
	A==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id NvmQs3WzKVlJ; Thu, 12 Mar 2026 21:18:19 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4fX0pK6scQzlfl5W;
	Thu, 12 Mar 2026 21:18:17 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bean Huo <beanhuo@micron.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>
Subject: [PATCH 32/36] scsi: ufs: Prepare for enabling lock context analysis
Date: Thu, 12 Mar 2026 14:15:43 -0700
Message-ID: <20260312211636.3245119-33-bvanassche@acm.org>
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

Annotate functions that modify the state of a synchronization object.
Remove the struct semaphore annotations because lock context annotations
are not supported for semaphores.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufs-debugfs.c |  8 ++++++--
 drivers/ufs/core/ufshcd.c      | 10 ++++++++++
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufs-debugfs.c b/drivers/ufs/core/ufs-debugf=
s.c
index e3baed6c70bd..d003f0450e7f 100644
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
index cf7f0ae46f75..2d8b0eec1017 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1427,6 +1427,9 @@ static int ufshcd_scale_gear(struct ufs_hba *hba, u=
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
@@ -1456,6 +1459,9 @@ static int ufshcd_clock_scaling_prepare(struct ufs_=
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
@@ -3259,6 +3265,8 @@ ufshcd_dev_cmd_completion(struct ufs_hba *hba, stru=
ct ufshcd_lrb *lrbp)
 }
=20
 static void ufshcd_dev_man_lock(struct ufs_hba *hba)
+	__acquires(&hba->dev_cmd.lock)
+	__acquires_shared(&hba->clk_scaling_lock)
 {
 	ufshcd_hold(hba);
 	mutex_lock(&hba->dev_cmd.lock);
@@ -3266,6 +3274,8 @@ static void ufshcd_dev_man_lock(struct ufs_hba *hba=
)
 }
=20
 static void ufshcd_dev_man_unlock(struct ufs_hba *hba)
+	__releases_shared(&hba->clk_scaling_lock)
+	__releases(&hba->dev_cmd.lock)
 {
 	up_read(&hba->clk_scaling_lock);
 	mutex_unlock(&hba->dev_cmd.lock);
