Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73A9B4A5C42
	for <linux-scsi@vger.kernel.org>; Fri, 16 Oct 2026 12:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792154778; cv=none; b=Yfo0F0ukW7yY4nlqYLFvIi5qL19bdAxW93mVvg7Vlwpwyh2RUBt1o+URTgo1ZO/xMeQO/yjWA3LFwnW/BpJcIQjfjSyDNamX6JDxriAI5uKyTRng1qqGmFX6U5675RHGQzRYPLH4lcLH7yvODWjsaHlPo0ZkdMFlcjemqvFwXAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792154778; c=relaxed/simple;
	bh=g/A2LNTpg/TBBWsof9UO+iJupz/JhBE9bEfYXnOvlvk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lIxKsc3gfVgKN7YTJwplJdqZgX17Wpdp4FuQn/hvZCW7eJ7Ei3hn4s2LocudzfLhfdj8RJfspPv1enLeCM0Pv4lhvBOhrPFVBGn9gVNcFRGa1BZWATuGT6t14jdasEaZRoYj475WV+Dj38l0HB4IL/tcqgN0Xzj61FLFKgIrWvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PPiZgMhJ; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PPiZgMhJ"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-cc502d509c0so1444839a12.2
        for <linux-scsi@vger.kernel.org>; Fri, 16 Oct 2026 05:46:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792154774; x=1792759574; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=U9uelrnhVgBO69REznhFRhGJ0U4UCFyoo6ufjAB5aFI=;
        b=PPiZgMhJGO1DZn+ni3QL4jrdTbWZx/nfVOzdxu48kKJGgXpa/RfAzumq5L327kOkmU
         UeSGyPU6P99RIl8m8dRxI1m8di3hMMW5WwdKfxG3BPiqa04vbaKHq1ZHNfL+/Xd3m26n
         SNYApLqyflGHFSS/O2fsyjZUmzveV2YORI3s2Il+VGCHfWFE6sCGyRObLpMZr2m7EVU2
         pF3AkINSodeSDJ+nAoTNEbzoQq8jdYju2yHS6cE2Gdnmp7UyvPG1xYGHFp1qTL6Wd2Jt
         oG668bSVPgw9Dn7GIA4aLdp1qXnq6yCzxKFdu9aYYeih3KmKzIAqLAsyFr/Q4X84aEO6
         VVVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792154774; x=1792759574;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=U9uelrnhVgBO69REznhFRhGJ0U4UCFyoo6ufjAB5aFI=;
        b=deg8WvhkyJqC3UcfatATm1Woi0h1mYpW9JwvaUShOmx6f+X7jQjHG2aBA8/rThvKv6
         6a4EXWPJy3UpR65SJTEYhiiCMccVT4zRBxgK1tCZyO4903bVB0DR1jlVMwsMxdJ4Uf1n
         ByG8cfdsm/mvHSer95UOKq6dg2cBcTVwvjfGgRBIUobSwDaRN2VKrPom2bkKV24aF1JE
         ICB7FXtS+zCh9HGo71AvxcMj7wh96ZreiUda7togxAnPz5uXN7YX466wBry+SHaWgHqo
         e9ClGsO3bjPR+XGrW8iWqGuXZjQlfrWUBKqldYpwXv0SC99AmEuqbCY4ncWz3xuxbbCP
         MPKw==
X-Forwarded-Encrypted: i=1; AKwUvBzxDQHuKBGK/0KXpZojFMhVManRw0EwFQgHvo7hC1pasJFv32WL33kj3yBVHrkSttUmw5xGqiRVXlkj@vger.kernel.org
X-Gm-Message-State: AFq9FYIDLCHWRWojCGAQPLwIHNqtc8BK/M1wR8wkP7m22WPmX2BaAoaV
	tM8ddjYCALiaZ7r5fk4Zj8GzTzxOsXKL+qlo2s14Lo1honxMHHvkzAWA
X-Gm-Gg: AYBFou0mCY5pqErvBTsZmyLfFwK/0intjRxK3kiddYAllV1huXNv6tle6VEkt1i1pyy
	8tU6axCkhIXlChJp36d6c8/HB+0hM4eCrR/Jp7ESrjgKOysg8PhklEfjHYLa9VJx/iT9Q4Q3XzL
	wLiukLycIyy5ckbYexpHBhfy4Cp2aONWsd1/Zf4Jsdm8IztkZAJJNtoUlu98fZwrpw8Vy1Sy5iW
	E/kehVrPqYyCq3s03jlWY7lyiJ90Sb+4/u83YLrveWDjfMMeUjOX6lxrFUJBaMN5OOS6s94kXCr
	pkYnr6ou1VYXjDMRBS9u/6dXvhCR/nKF09dv99xibpSRVA4BPcg9TXIZjcr0udyEkAkzNjSIOZ4
	EpTUD2RQTPuhQj52WzJnWAv3WvURhfH07Mu2aoaphtJ7Zn9VO9vshlnVE1nugJjbMDMZKVZDw4c
	YJeV0GWiw1H+R/Rg29SqPy2JYlGDKsTnKCgoVFRAGIH8WbTnGmgcOW1YQ+zAC1GYJFwuTIg3g7V
	0a3RvRUKfJiVQZMA5+rrROV
X-Received: by 2002:a17:90b:2cce:b0:3ac:8af9:4a77 with SMTP id 98e67ed59e1d1-3ac8af94f43mr6385936a91.10.1792154773600;
        Fri, 16 Oct 2026 05:46:13 -0700 (PDT)
Received: from DESKTOP-NM9EKIA ([125.134.240.130])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3acc9d266d6sm1756414a91.1.2026.10.16.05.46.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 05:46:13 -0700 (PDT)
From: Joonhoe Kim <26rote@gmail.com>
To: James.Bottomley@HansenPartnership.com,
	mkp@kernel.org
Cc: alim.akhtar@samsung.com,
	bvanassche@acm.org,
	beanhuo@micron.com,
	stanleyjhu@google.com,
	peter.wang@mediatek.com,
	can.guo@oss.qualcomm.com,
	mani@kernel.org,
	linux-scsi@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] scsi: ufs: core: Fix a deadlock between clock scaling and device commands
Date: Fri, 16 Oct 2026 21:46:08 +0900
Message-ID: <20261016124608.46-1-26rote@gmail.com>
X-Mailer: git-send-email 2.55.0.windows.5
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since commit 08b12cda6c44 ("scsi: ufs: core: Switch to
scsi_get_internal_cmd()"), device management commands go through
blk_execute_rq() on the pseudo SCSI device, which shares the tagset
with the logical units, while ufshcd_dev_man_lock() holds
clk_scaling_lock for reading.

ufshcd_clock_scaling_prepare() and ufshcd_pause_command_processing()
quiesce the tagset before taking clk_scaling_lock for writing. A device
management command holding the lock for reading at that point is never
dispatched and never times out, so the writer waits forever with all
logical units quiesced. On a Lenovo Legion Tab Y700 Gen 5 this ended in
a hung task panic.

Take clk_scaling_lock before quiescing the tagset, and in
ufshcd_clock_scaling_prepare() also wb_mutex, which is always taken
before clk_scaling_lock. Release them in the reverse order. Commit
b52d695d0620 ("scsi: ufs: core: Keep internal commands dispatchable
during error handling") fixed the same problem in the error handler.

Fixes: 08b12cda6c44 ("scsi: ufs: core: Switch to scsi_get_internal_cmd()")
Fixes: dc5dcac53278 ("scsi: ufs: core: Add helpers to pause and resume command processing")
Cc: stable@vger.kernel.org
Signed-off-by: Joonhoe Kim <26rote@gmail.com>
---
Reproduced on v7.3-rc4 with out-of-tree board support, using short fio
write bursts and readers of the exception_event_status attribute while
devfreq scales: a deadlock within 10 s without this patch, two clean
600 s runs with it. The pause path was only checked by reading the
code, and the reversed release order only by building it. Sashiko
flagged this lock order in [1] and [2].

[1] https://lore.kernel.org/all/20260723130641.92FD31F000E9@smtp.kernel.org/
[2] https://lore.kernel.org/all/20260813222950.8C1581F00A3E@smtp.kernel.org/

 drivers/ufs/core/ufshcd.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index cc75384c6502..87f78ffc8cbd 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1360,13 +1360,13 @@ int ufshcd_pause_command_processing(struct ufs_hba *hba, u64 timeout_us)
 	int ret = 0;
 
 	mutex_lock(&hba->host->scan_mutex);
-	blk_mq_quiesce_tagset(&hba->host->tag_set);
 	down_write(&hba->clk_scaling_lock);
+	blk_mq_quiesce_tagset(&hba->host->tag_set);
 
 	if (ufshcd_wait_for_pending_cmds(hba, timeout_us)) {
 		ret = -EBUSY;
-		up_write(&hba->clk_scaling_lock);
 		blk_mq_unquiesce_tagset(&hba->host->tag_set);
+		up_write(&hba->clk_scaling_lock);
 		mutex_unlock(&hba->host->scan_mutex);
 	}
 
@@ -1383,8 +1383,8 @@ void ufshcd_resume_command_processing(struct ufs_hba *hba)
 	__releases(&hba->clk_scaling_lock)
 	__releases(&hba->host->scan_mutex)
 {
-	up_write(&hba->clk_scaling_lock);
 	blk_mq_unquiesce_tagset(&hba->host->tag_set);
+	up_write(&hba->clk_scaling_lock);
 	mutex_unlock(&hba->host->scan_mutex);
 }
 
@@ -1461,16 +1461,16 @@ static int ufshcd_clock_scaling_prepare(struct ufs_hba *hba, u64 timeout_us)
 	 * clock scaling is in progress
 	 */
 	mutex_lock(&hba->host->scan_mutex);
-	blk_mq_quiesce_tagset(&hba->host->tag_set);
 	mutex_lock(&hba->wb_mutex);
 	down_write(&hba->clk_scaling_lock);
+	blk_mq_quiesce_tagset(&hba->host->tag_set);
 
 	if (!hba->clk_scaling.is_allowed ||
 	    ufshcd_wait_for_pending_cmds(hba, timeout_us)) {
 		ret = -EBUSY;
+		blk_mq_unquiesce_tagset(&hba->host->tag_set);
 		up_write(&hba->clk_scaling_lock);
 		mutex_unlock(&hba->wb_mutex);
-		blk_mq_unquiesce_tagset(&hba->host->tag_set);
 		mutex_unlock(&hba->host->scan_mutex);
 		goto out;
 	}
@@ -1487,9 +1487,9 @@ static void ufshcd_clock_scaling_unprepare(struct ufs_hba *hba, int err)
 	__releases(&hba->wb_mutex)
 	__releases(&hba->host->scan_mutex)
 {
+	blk_mq_unquiesce_tagset(&hba->host->tag_set);
 	up_write(&hba->clk_scaling_lock);
 	mutex_unlock(&hba->wb_mutex);
-	blk_mq_unquiesce_tagset(&hba->host->tag_set);
 	mutex_unlock(&hba->host->scan_mutex);
 
 	/* Enable Write Booster if current gear requires it else disable it */
-- 
2.43.0

