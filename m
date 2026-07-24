Received: from mail-m49198.qiye.163.com (mail-m49198.qiye.163.com [45.254.49.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0067B4483B0;
	Fri, 24 Jul 2026 15:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784906027; cv=none; b=DUkJuLaskHhseXJK5QXlYfgRVUhWhpyy/uJuxymrHqC6VZCd9cBPBiyiaUKyhYh/F6QjjlHl8AYKdDBTUtIdw2N3ZjOGwyg3C78ip080JOPJoj6zHwzDiQciAMi+reUa/cDhATHrAZ834IP2mRmAs8T/2Hnwr4J39JeGwa48d4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784906027; c=relaxed/simple;
	bh=wNrh7vu+oTt22L9Os0fB066mS5rAdpvci2879T0M4CE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=e1Cpszpg/zfaFLZgTXNHe8p99n6Xrns/Kr2gIQMwMHRZXuFwXLe9S5uP/uj2SOztAGYogdTyJjtguhH7WCHkzJHBxlkO8SQntho0Uwj0WBpk8OI/HVwU23vwQ4jVCG2S2whIbZWLw6XXgwOJvZ7ss75rX9eEyYoA7ywyf9S0WUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=iLMijvOL; arc=none smtp.client-ip=45.254.49.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="iLMijvOL"
Received: from ShouCheng-Lab.localdomain (unknown [218.2.107.243])
	by smtp.qiye.163.com (Hmail) with ESMTP id 477b224c4;
	Fri, 24 Jul 2026 23:13:39 +0800 (GMT+08:00)
From: Jiancheng Huang <jchuang@seu.edu.cn>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] scsi: core: validate VPD 0x83 descriptor bounds
Date: Fri, 24 Jul 2026 23:13:31 +0800
Message-ID: <20260724151331.1445730-1-jchuang@seu.edu.cn>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9f94b0713f03a2kunmac9d63b8457a0
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlDThpOVkMeTUxLHx0YTkpKSFYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVSVVKS0xVSU9IWVdZFhoPEhUdFFlBWU9LSFVKS0hKTk
	xOVUpLS1VKQktLWQY+
DKIM-Signature: a=rsa-sha256;
	b=iLMijvOL0OtVf/prIgpxwQ5yeKFtzIJRKomRty76gX+2l/XB9wHZeYFDRwoqcATfdPVueCvKflzoYKrbVsfm/DPezxVnFYcrVcTXyMMEak2VW+VB9T6jEq3hEviiVAwa0nlhQYcwusIp/nAJqRT4VjyKS39LsnqOFaTz0fvEijY=; s=default; c=relaxed/relaxed; d=seu.edu.cn; v=1;
	bh=YTpq5ijudyh6zYdC01VW/EtnwPARh9WD22XV3AmkhBU=;
	h=date:mime-version:subject:message-id:from;

scsi_vpd_lun_id() advances through VPD page 0x83 using each descriptor's
length before proving that the descriptor header and body fit in the
retained page. The priority helper and formatters can then read beyond a
truncated descriptor.

Reject pages shorter than the four-byte page header. Track the page end and
stop before calling designator_prio() unless both the descriptor header and
declared body are present.

Fixes: 9983bed3907c ("scsi: Add scsi_vpd_lun_id()")
Signed-off-by: Jiancheng Huang <jchuang@seu.edu.cn>
Assisted-by: Codex:gpt-5.6-luna
---
Changes in v2:
- Add the relevant public mailing lists to Cc; no source changes.

Evidence (v7.2-rc4 KUnit/KASAN oracle under bounded QEMU):
Source: confirmed/scsi_vpd_truncated_designator_sysfs_oob_raw_excerpt.log

[    2.628665] KTAP version 1
[    2.628739] 1..1
[    2.631405]     KTAP version 1
[    2.631565]     # Subtest: scsi-vpd-truncated-designator-sysfs
[    2.631858]     # module: scsi_mod
[    2.632142]     1..1
[    2.634467] scsi_vpd_truncated_designator_sysfs_test: invoking sdev_show_wwid oracle
[    2.635065] ==================================================================
[    2.635366] BUG: KASAN: slab-out-of-bounds in string_escape_mem+0x84d/0xb60
[    2.635782] Read of size 1 at addr ffff8880019b87e0 by task kunit_try_catch/64
[    2.635919] 
[    2.635985] CPU: 0 UID: 0 PID: 64 Comm: kunit_try_catch Tainted: G                 N  7.2.0-rc4-dirty #3 PREEMPT(full) 
[    2.635985] Tainted: [N]=TEST
[    2.635985] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[    2.635985] Call Trace:
[    2.635985]  <TASK>
[    2.635985]  dump_stack_lvl+0x53/0x70
[    2.635985]  print_report+0xd0/0x630
[    2.635985]  ? __pfx__raw_spin_lock_irqsave+0x10/0x10
[    2.635985]  ? string_escape_mem+0x84d/0xb60
[    2.635985]  kasan_report+0xe5/0x120
[    2.635985]  ? string_escape_mem+0x84d/0xb60
[    2.635985]  string_escape_mem+0x84d/0xb60

 drivers/scsi/scsi_lib.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index daeb3693f..5e0b84e2d 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -3365,7 +3365,7 @@ int scsi_vpd_lun_id(struct scsi_device *sdev, char *id, size_t id_len)
 {
 	u8 cur_id_prio = 0;
 	u8 cur_id_size = 0;
-	const unsigned char *d, *cur_id_str;
+	const unsigned char *d, *cur_id_str, *end;
 	const struct scsi_vpd *vpd_pg83;
 	int id_size = -EINVAL;
 
@@ -3382,11 +3382,21 @@ int scsi_vpd_lun_id(struct scsi_device *sdev, char *id, size_t id_len)
 		return -EINVAL;
 	}
 
+	if (vpd_pg83->len < 4) {
+		rcu_read_unlock();
+		return -EINVAL;
+	}
+
 	memset(id, 0, id_len);
-	for (d = vpd_pg83->data + 4;
-	     d < vpd_pg83->data + vpd_pg83->len;
+	end = vpd_pg83->data + vpd_pg83->len;
+	for (d = vpd_pg83->data + 4; end - d >= 4;
 	     d += d[3] + 4) {
-		u8 prio = designator_prio(d);
+		u8 prio;
+
+		if (d[3] > end - d - 4)
+			break;
+
+		prio = designator_prio(d);
 
 		if (prio == 0 || cur_id_prio > prio)
 			continue;
-- 
2.43.0
