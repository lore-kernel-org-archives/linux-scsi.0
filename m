Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C67833611D
	for <linux-scsi@vger.kernel.org>; Wed, 27 Mar 2024 09:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711530679; cv=none; b=oser2iUdldt/crJUBTQAXU6s9HpT8Jp1yaYYJEB5heO/Ue9hU3SIov9U/I1b2Au5coFWeH7YDyEPSIpyD6m3RDtxxFkIwSadW2L4NYEO3FmXhC9Hu7JnNb8F0v+P0zbdAdR2hT/HVU9gOreBnBBiwNSZEaeMMUo16f/vOAsqJJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711530679; c=relaxed/simple;
	bh=pIPjA7MwFjWF7WRNdUbKWwDRcs+6/FVCdeIgmgFA1DI=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=KgXmDFs1BS7hqXfIQO+icqw8sQJPbKxzlF9db6F/vPUW+Xx0Yj6FvKcvFy07pZgsr/6BH1AtFC/DJRyN6zKiJppmM6Mo4L4gSzEQfymGpZDJ+z669+1ReVnvqs4/8DNcF07fgv5EuPPgKNTPumN/PCPoEGvSFkHf217bSpR5T7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=SL++ZvX9; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="SL++ZvX9"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 42R6nE7k009885;
	Wed, 27 Mar 2024 02:11:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding:content-type; s=pfpt0220; bh=5pVzo863
	eQq1C6CNbaunQc4ilcgrZ1N6/mj2oHhMZqk=; b=SL++ZvX9VZeY71lPyJsotgHE
	u9v/nc5zAdHkOPzkOz7JBXBe90dKGPpTRWRrFHjjJpZdvyVXwk/j9QSaukpMnAk6
	55Bked9FQJoqvcwf+vK4D3UTUOIx/W8ZzZntZBibWk9rrWKT2/oAaKZeX2ajIErM
	q8NK8HXMkjyWh5G091jKADMDgz6Q0poYpjYpYVDgVUyeUlszVo6SHrhtDs6N16r3
	SUs+aAGXXdb4uiAWMHYW22bfFjypccg7tKZHkrJrjDveh6xSNbsPvUGUjZj878Jp
	11VyeeSz23ZnfWslwRfnnJLHJLXq9o/JYBtrUSppPrsfooYTFLuG3KP73ahW4g==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3x3hy1y33e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 27 Mar 2024 02:11:14 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Wed, 27 Mar 2024 02:11:13 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Wed, 27 Mar 2024 02:11:13 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.187])
	by maili.marvell.com (Postfix) with ESMTP id 584003F704B;
	Wed, 27 Mar 2024 02:11:11 -0700 (PDT)
From: Manish Rangankar <mrangankar@marvell.com>
To: <martin.petersen@oracle.com>
CC: <GR-QLogic-Storage-Upstream@marvell.com>, <linux-scsi@vger.kernel.org>,
        Manish Rangankar <mrangankar@marvell.com>,
        Martin Hoyer <mhoyer@redhat.com>
Subject: [PATCH] qedi: Fix crash while reading debugfs attribute.
Date: Wed, 27 Mar 2024 14:41:00 +0530
Message-ID: <20240327091100.14405-1-mrangankar@marvell.com>
X-Mailer: git-send-email 2.23.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: LXsVOxxoWdEAUvQ9YNNtfo7csyB4k_mB
X-Proofpoint-ORIG-GUID: LXsVOxxoWdEAUvQ9YNNtfo7csyB4k_mB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-27_05,2024-03-21_02,2023-05-22_02

BUG: unable to handle page fault for address: 00007f4801111000
PGD 8000000864df6067 P4D 8000000864df6067 PUD 864df7067 PMD 846028067 PTE 0
Oops: 0002 [#1] PREEMPT SMP PTI
CPU: 38 PID: 6417 Comm: cat Kdump: loaded Not tainted 6.4.0-150600.9-default #1 SLE15-SP6 6b4f1850a99c4e4121f832c3fb6a8cf64ec22338
Hardware name: HPE ProLiant DL380 Gen10/ProLiant DL380 Gen10, BIOS U30 06/15/2023
RIP: 0010:memcpy_orig+0xcd/0x130
Code: 08 4c 89 54 17 f0 4c 89 5c 17 f8 c3 cc cc cc cc 66 66 2e 0f 1f 84 00 00 00 00 00 66 90 83 fa 08 72 1b 4c 8b 06 4c 8b 4c 16 f8 <4c> 89 07 4c 89 4c 17 f8 c3 cc cc cc cc 66 0f 1f 44 00 00 83 fa 04
RSP: 0018:ffffb7a18c3ffc40 EFLAGS: 00010202
RAX: 00007f4801111000 RBX: 00007f4801111000 RCX: 000000000000000f
RDX: 000000000000000f RSI: ffffffffc0bfd7a0 RDI: 00007f4801111000
RBP: ffffffffc0bfd7a0 R08: 725f746f6e5f6f64 R09: 3d7265766f636572
R10: ffffb7a18c3ffd08 R11: 0000000000000000 R12: 00007f4881110fff
R13: 000000007fffffff R14: ffffb7a18c3ffca0 R15: ffffffffc0bfd7af
FS:  00007f480118a740(0000) GS:ffff98e38af00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f4801111000 CR3: 0000000864b8e001 CR4: 00000000007706e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
PKRU: 55555554
Call Trace:
 <TASK>
 ? __die_body+0x1a/0x60
 ? page_fault_oops+0x183/0x510
 ? exc_page_fault+0x69/0x150
 ? asm_exc_page_fault+0x22/0x30
 ? memcpy_orig+0xcd/0x130
 vsnprintf+0x102/0x4c0
 sprintf+0x51/0x80
 qedi_dbg_do_not_recover_cmd_read+0x2f/0x50 [qedi 6bcfdeeecdea037da47069eca2ba717c84a77324]
 full_proxy_read+0x50/0x80
 vfs_read+0xa5/0x2e0
 ? folio_add_new_anon_rmap+0x44/0xa0
 ? set_pte_at+0x15/0x30
 ? do_pte_missing+0x426/0x7f0
 ksys_read+0xa5/0xe0
 do_syscall_64+0x58/0x80
 ? __count_memcg_events+0x46/0x90
 ? count_memcg_event_mm+0x3d/0x60
 ? handle_mm_fault+0x196/0x2f0
 ? do_user_addr_fault+0x267/0x890
 ? exc_page_fault+0x69/0x150
 entry_SYSCALL_64_after_hwframe+0x72/0xdc
RIP: 0033:0x7f4800f20b4d

Reported-by: Martin Hoyer <mhoyer@redhat.com>
Signed-off-by: Manish Rangankar <mrangankar@marvell.com>
---
 drivers/scsi/qedi/qedi_debugfs.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_debugfs.c b/drivers/scsi/qedi/qedi_debugfs.c
index 8deb2001dc2f..37eed6a27816 100644
--- a/drivers/scsi/qedi/qedi_debugfs.c
+++ b/drivers/scsi/qedi/qedi_debugfs.c
@@ -120,15 +120,11 @@ static ssize_t
 qedi_dbg_do_not_recover_cmd_read(struct file *filp, char __user *buffer,
 				 size_t count, loff_t *ppos)
 {
-	size_t cnt = 0;
-
-	if (*ppos)
-		return 0;
+	char buf[64];
+	int len;
 
-	cnt = sprintf(buffer, "do_not_recover=%d\n", qedi_do_not_recover);
-	cnt = min_t(int, count, cnt - *ppos);
-	*ppos += cnt;
-	return cnt;
+	len = sprintf(buf, "do_not_recover=%d\n", qedi_do_not_recover);
+	return simple_read_from_buffer(buffer, count, ppos, buf, len);
 }
 
 static int
-- 
2.35.3

