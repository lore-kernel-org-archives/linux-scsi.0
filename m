Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFAF731E823
	for <linux-scsi@vger.kernel.org>; Thu,  3 Sep 2026 23:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788479593; cv=none; b=DaxMiv3f/pdQOgs4O+QbQbqFIbGTNu0I217GxW3AH2wcDcDvgMgPEGnWVRsIIGBLT1RQ8S0L53QPX78529g27PQYoJgAVyC/m+uKB/TtS5MTC2Qf6lyRmaWd//zJQ1CIyAsiEBrTZL9G0Iwrw5enCdO0f1aYxbEzbpgJnYrCAXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788479593; c=relaxed/simple;
	bh=+kIP7y78ResGK0mg1X+wjST5HlfTny0oUXjSjO/YqeU=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=cknHvYem8ml8AFhL6qF1xoPCPGr4dzaT9SbXR0oWAwH82dxUHxHYDmX7d8RTH/2s4xIiraEwNMyN3Hjtv7mV1jUhd2o/5zUxermVwrhm4MffM0gjUMi/zGjNoMhxEm179jrz40opazwSR4ZI+7hfh9INPUj+AD15cxdJnouQzn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Wo7ztnGc; arc=none smtp.client-ip=209.85.216.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Wo7ztnGc"
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-396901263b6so660523a91.2
        for <linux-scsi@vger.kernel.org>; Thu, 03 Sep 2026 16:53:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788479591; x=1789084391; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=2UV+8BVa840QAWI1056d4zVig0jh8eLQSYzgvwbA6Us=;
        b=Wo7ztnGc0rh3an/h5qIhecSfPAwDVw1PF/NSCg8gK/2ya8fsg9zeHclXix54LVmlT+
         wESpecTrdY2tcnPG5g7a0k+rjSjNNKGPrq4rH9X1vhhqZ4fYWwkRfEs3kXlsEIXzrfD3
         WPX5G7TK5RyT4GM/vHwoI/tlhCZ3nqfK/DxtUY4YybQn3F6zuW2wRE+Q2ucK4QFkfUvG
         r6627KKX8VsGm9ZYwx6KG7G47V7dWypfxiZsFaRzjK+5mb3vdF61h8iboBhGlMPWAzkg
         cGeMI8MtyolaOcDj1wsS84lslVZBp3luhb8YAQNOvBQWPZGfflzCI6SuuwXXt2YM5gJy
         MkQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788479591; x=1789084391;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2UV+8BVa840QAWI1056d4zVig0jh8eLQSYzgvwbA6Us=;
        b=f8+fRXkjlQTrSxhqf/p3PBR5Swv6GbLCi2woPfKHCEcPaNgadF3ovR2CFuKIOh1e82
         JXN1l3ENZVAfcwOQU8vbwTfbzBfdfkoaCJPKMLFGG9GHnt88ZUyVSucC13zh2wL4lsWV
         +FI1rZ3zss9Au3PMPJxO0uKrgDGLYraJbnuN8SwDquZBNnq4N2y2Xk3dyAlgY47wnqBw
         Di89sRpajwSHxud5tXY8/q3y5QJ55Y9T3eXx+3rKFwKWwfWD2qCQOFsiV+PTYqYHn1sg
         CLKU4C/9aB7quMtCDsKO922BD88NjyhE4bjPZDXtKckxxrGRx3Vo5iM6DjyM9JVbY/1L
         /S9A==
X-Forwarded-Encrypted: i=1; AKwUvBzaRLw/2kIjEggOPEM54nWbGN8fV1C3k6BreKtzezGByR65yPKtZ3qvLdi4uivp0O1Jr/CDWgulERH0@vger.kernel.org
X-Gm-Message-State: AFuF++l9/944rgMiZ7DlfgJxy3afPrLatW3NaiKghkYa8yqdSaWZUTvf
	6+MK/Be+cOk/6ZnN+CXxMHvZOHj675dl714V80xE7QmKUSCy8uBUrx/dzK7E1RLXojCEPAei7ph
	NAIuk4BI4LjaM6EjEabkWAw==
X-Received: from pjbqi2.prod.google.com ([2002:a17:90b:2742:b0:39b:1f3d:2676])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:2ccb:b0:398:9be8:ea64 with SMTP id 98e67ed59e1d1-39b261d8533mr3377437a91.17.1788479590823;
 Thu, 03 Sep 2026 16:53:10 -0700 (PDT)
Date: Fri,  4 Sep 2026 07:53:08 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.979.g7e5102b832-goog
Message-ID: <20260903235308.1240963-1-stanleyjhu@google.com>
Subject: [PATCH] scsi: ufs: core: Add fault injection for task abort failures
From: Stanley Jhu <stanleyjhu@google.com>
To: "Martin K . Petersen" <mkp@kernel.org>, 
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Bart Van Assche <bvanassche@acm.org>, Alim Akhtar <alim.akhtar@samsung.com>, 
	Avri Altman <avri.altman@sandisk.com>, Peter Wang <peter.wang@mediatek.com>, 
	Bean Huo <beanhuo@micron.com>, Can Guo <can.guo@oss.qualcomm.com>, 
	Hyeoncheol Jeong <hyenc.jeong@samsung.com>, Po-Wen Kao <powenkao@google.com>, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Stanley Jhu <stanleyjhu@google.com>
Content-Type: text/plain; charset="UTF-8"

Commit 045da3077bc5 ("scsi: ufs: core: Make fault injection dynamically
configurable per HBA") added fault injection support for UFS error
handling and completion timeouts. However, there was no fault
injection capability to simulate task abort failures.

Both legacy single-doorbell mode (in ufshcd_abort()) and MCQ mode (in
ufshcd_mcq_abort()) invoke ufshcd_try_to_abort_task() to query device
status and execute task aborts.

Add fault injection support for task abort:
- Add "abort" module parameter and "abort_inject" debugfs attribute.
- Hook ufs_fail_abort() at the entry of ufshcd_try_to_abort_task() to
  short-circuit task abort with -EIO. This universally simulates task
  abort failure across both single-doorbell and MCQ modes without
  incurring query polling delays.

Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
---
 drivers/ufs/core/ufs-fault-injection.c | 15 +++++++++++++++
 drivers/ufs/core/ufs-fault-injection.h |  6 ++++++
 drivers/ufs/core/ufshcd.c              |  2 ++
 include/ufs/ufshcd.h                   |  1 +
 4 files changed, 24 insertions(+)

diff --git a/drivers/ufs/core/ufs-fault-injection.c b/drivers/ufs/core/ufs-fault-injection.c
index 55db38e75cc4..25ae763da4f6 100644
--- a/drivers/ufs/core/ufs-fault-injection.c
+++ b/drivers/ufs/core/ufs-fault-injection.c
@@ -34,6 +34,12 @@ MODULE_PARM_DESC(timeout,
 	"Fault injection. timeout=<interval>,<probability>,<space>,<times>");
 static DECLARE_FAULT_ATTR(ufs_timeout_attr);
 
+static char g_abort_str[FAULT_INJ_STR_SIZE];
+module_param_cb(abort, &ufs_fault_ops, g_abort_str, 0644);
+MODULE_PARM_DESC(abort,
+		 "Fault injection. abort=<interval>,<probability>,<space>,<times>");
+static DECLARE_FAULT_ATTR(ufs_abort_attr);
+
 static int ufs_fault_get(char *buffer, const struct kernel_param *kp)
 {
 	const char *fault_str = kp->arg;
@@ -49,6 +55,8 @@ static int ufs_fault_set(const char *val, const struct kernel_param *kp)
 		attr = &ufs_trigger_eh_attr;
 	else if (kp->arg == g_timeout_str)
 		attr = &ufs_timeout_attr;
+	else if (kp->arg == g_abort_str)
+		attr = &ufs_abort_attr;
 
 	if (WARN_ON_ONCE(!attr))
 		return -EINVAL;
@@ -65,9 +73,11 @@ void ufs_fault_inject_hba_init(struct ufs_hba *hba)
 {
 	hba->trigger_eh_attr = ufs_trigger_eh_attr;
 	hba->timeout_attr = ufs_timeout_attr;
+	hba->abort_attr = ufs_abort_attr;
 #ifdef CONFIG_FAULT_INJECTION_DEBUG_FS
 	fault_create_debugfs_attr("trigger_eh_inject", hba->debugfs_root, &hba->trigger_eh_attr);
 	fault_create_debugfs_attr("timeout_inject", hba->debugfs_root, &hba->timeout_attr);
+	fault_create_debugfs_attr("abort_inject", hba->debugfs_root, &hba->abort_attr);
 #endif
 }
 
@@ -80,3 +90,8 @@ bool ufs_fail_completion(struct ufs_hba *hba)
 {
 	return should_fail(&hba->timeout_attr, 1);
 }
+
+bool ufs_fail_abort(struct ufs_hba *hba)
+{
+	return should_fail(&hba->abort_attr, 1);
+}
diff --git a/drivers/ufs/core/ufs-fault-injection.h b/drivers/ufs/core/ufs-fault-injection.h
index d0c870e19f0e..56725e3d4556 100644
--- a/drivers/ufs/core/ufs-fault-injection.h
+++ b/drivers/ufs/core/ufs-fault-injection.h
@@ -12,6 +12,7 @@ struct ufs_hba;
 void ufs_fault_inject_hba_init(struct ufs_hba *hba);
 bool ufs_trigger_eh(struct ufs_hba *hba);
 bool ufs_fail_completion(struct ufs_hba *hba);
+bool ufs_fail_abort(struct ufs_hba *hba);
 #else
 static inline void ufs_fault_inject_hba_init(struct ufs_hba *hba)
 {
@@ -26,6 +27,11 @@ static inline bool ufs_fail_completion(struct ufs_hba *hba)
 {
 	return false;
 }
+
+static inline bool ufs_fail_abort(struct ufs_hba *hba)
+{
+	return false;
+}
 #endif
 
 #endif /* _UFS_FAULT_INJECTION_H */
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 2ba244cf40ac..a25b6a0cb5c6 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -7990,6 +7990,8 @@ int ufshcd_try_to_abort_task(struct ufs_hba *hba, int tag)
 		return -EINVAL;
 
 	lrbp = scsi_cmd_priv(cmd);
+	if (ufs_fail_abort(hba))
+		return -EIO;
 
 	for (poll_cnt = 100; poll_cnt; poll_cnt--) {
 		err = ufshcd_issue_tm_cmd(hba, lrbp->lun, tag, UFS_QUERY_TASK,
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index dfd302f2dc7c..dbf326efdbc4 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1245,6 +1245,7 @@ struct ufs_hba {
 #ifdef CONFIG_SCSI_UFS_FAULT_INJECTION
 	struct fault_attr trigger_eh_attr;
 	struct fault_attr timeout_attr;
+	struct fault_attr abort_attr;
 #endif
 	u32 luns_avail;
 	unsigned int nr_hw_queues;
-- 
2.55.0.970.g62bdec98f9-goog

