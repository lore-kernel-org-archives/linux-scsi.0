Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 192592FBDED
	for <linux-scsi@vger.kernel.org>; Tue,  2 Dec 2025 05:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764654378; cv=none; b=KoPTZpueAHl1M1rleVJJkuu5FelT720YPWx11fw/0Q8mzYVOb78quNVPJ3RdFuUpa5QmsqcvX5TzfqssRvOptHixjT0oIyeXqC58Nv5ZgHflJkVn7leoePM2ukHWevKPbzrmmL3MO7FDojlqwhIUH0azBqEhF71LnA0ulP56Z7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764654378; c=relaxed/simple;
	bh=Qu83BbMgRAiE0yKmEvCpxLWR4h//HtEEHrSEBfeRbeI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CMQmufYOM9Lu0oULBWLOefzJ+IYMfvcQvho0iCj1PPYGKEs+7l4PT5fLIUC45tU4VPXefy6ZtI7LmPJuGbz40qk7sj+talChhxl38m9QC5AZ5tBlZrkkSbc+nZzLmTeUMB6xn8b/6stgn+57uvKgnfkAIWyRQj6vcL40Vjhb668=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=jt1HFw03; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="jt1HFw03"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B1NSBs32365008;
	Mon, 1 Dec 2025 21:46:13 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=b
	8faaOqeoS3yuOKxW40cySv3hBWLK6PMSaDKlVIGAzU=; b=jt1HFw03JBYagWMlz
	HhsYIulGf8vy2l6xRpnzUu77LsscwG8PjNAi5n9d4FzkfW9lveLhppZsmJdwlFVE
	wTEccZPEVa/lhCIRicOjS+IRMiArvlHi4BHRW0sfaqjZxHASVfn2AAWb84FF+TIw
	k2mkWWtlAA7uEAi57UTrJfPuxmT73u72swO7HSpKVIvHW8HsWZgOTh9CslmqGB5F
	X+D8y9In6CUtOTar41rkLV3iniRDL62YaO4/ay5T2nqjquMfUGbNMwUKwq8xXZED
	f28ZJQlAQ4VmvRYw8IoewwUgvhd4Qt14bzzNTbzg+9Ktp7QKtTg8pSaMshhV+/wL
	bKcAg==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4asmqh8m2q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Dec 2025 21:46:12 -0800 (PST)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 1 Dec 2025 21:46:25 -0800
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 1 Dec 2025 21:46:25 -0800
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 0A2E35B6975;
	Mon,  1 Dec 2025 21:46:09 -0800 (PST)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>, <emilne@redhat.com>,
        <jmeneghi@redhat.com>
Subject: [PATCH 08/12] qla2xxx: free sp in error path to fix system crash
Date: Tue, 2 Dec 2025 11:14:40 +0530
Message-ID: <20251202054444.1711778-9-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20251202054444.1711778-1-njavali@marvell.com>
References: <20251202054444.1711778-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Authority-Analysis: v=2.4 cv=HMnO14tv c=1 sm=1 tr=0 ts=692e7d24 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=T9IcfguAtBVHYGVSdbkA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: BL-xJ9-Ogc9PRgmvQGdsM2A3X4P88-YH
X-Proofpoint-GUID: BL-xJ9-Ogc9PRgmvQGdsM2A3X4P88-YH
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjAyMDA0MyBTYWx0ZWRfX8FbQrsIA3E37
 JUd3acFWGLwCZkES2eA0iVNb8D3HomopLFP8vQE/CM/nYQ89NsxQxIMHfkVNvFg4bopKyUd4qWd
 ig9bOZVUJAww56VJsl5eKjID8kDfJq1yt60U8s5LJby8mPm6Xr7iMxwrSqJOYs9XlyobpDGtiYD
 shjFVQkv6hAYGoOj3bhj77b+bKLf7AROMqfytFuO5MjboWpFTKGuyhgp1MffzNAO06LGwDUwREZ
 kh4JRk8w2mwM9id6XfbpcJ3/j31iOzuyhyCtLJMxjPx4X+8tao1Q0KotpGxYPBMKeJf78Ngovlo
 ZRu/p8MXxe5nogpK+fTVkQB5Njc8vE5iCPv+j2biHeJwnGAMXe4Tsl2SJbIzIbnGcV1UQxW+b2B
 VxdLyNk62lzPWp5lbLEH2fGGNHMSiQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-28_08,2025-11-27_02,2025-10-01_01

From: Anil Gurumurthy <agurumurthy@marvell.com>

System crash seen during load/unload test in a loop,

[61110.449331] qla2xxx [0000:27:00.0]-0042:0: Disabled MSI-X.
[61110.467494] =============================================================================
[61110.467498] BUG qla2xxx_srbs (Tainted: G           OE    --------  --- ): Objects remaining in qla2xxx_srbs on __kmem_cache_shutdown()
[61110.467501] -----------------------------------------------------------------------------

[61110.467502] Slab 0x000000000ffc8162 objects=51 used=1 fp=0x00000000e25d3d85 flags=0x57ffffc0010200(slab|head|node=1|zone=2|lastcpupid=0x1fffff)
[61110.467509] CPU: 53 PID: 455206 Comm: rmmod Kdump: loaded Tainted: G           OE    --------  ---  5.14.0-284.11.1.el9_2.x86_64 #1
[61110.467513] Hardware name: HPE ProLiant DL385 Gen10 Plus v2/ProLiant DL385 Gen10 Plus v2, BIOS A42 08/17/2023
[61110.467515] Call Trace:
[61110.467516]  <TASK>
[61110.467519]  dump_stack_lvl+0x34/0x48
[61110.467526]  slab_err.cold+0x53/0x67
[61110.467534]  __kmem_cache_shutdown+0x16e/0x320
[61110.467540]  kmem_cache_destroy+0x51/0x160
[61110.467544]  qla2x00_module_exit+0x93/0x99 [qla2xxx]
[61110.467607]  ? __do_sys_delete_module.constprop.0+0x178/0x280
[61110.467613]  ? syscall_trace_enter.constprop.0+0x145/0x1d0
[61110.467616]  ? do_syscall_64+0x5c/0x90
[61110.467619]  ? exc_page_fault+0x62/0x150
[61110.467622]  ? entry_SYSCALL_64_after_hwframe+0x63/0xcd
[61110.467626]  </TASK>
[61110.467627] Disabling lock debugging due to kernel taint
[61110.467635] Object 0x0000000026f7e6e6 @offset=16000
[61110.467639] ------------[ cut here ]------------
[61110.467639] kmem_cache_destroy qla2xxx_srbs: Slab cache still has objects when called from qla2x00_module_exit+0x93/0x99 [qla2xxx]
[61110.467659] WARNING: CPU: 53 PID: 455206 at mm/slab_common.c:520 kmem_cache_destroy+0x14d/0x160
[61110.467718] CPU: 53 PID: 455206 Comm: rmmod Kdump: loaded Tainted: G    B      OE    --------  ---  5.14.0-284.11.1.el9_2.x86_64 #1
[61110.467720] Hardware name: HPE ProLiant DL385 Gen10 Plus v2/ProLiant DL385 Gen10 Plus v2, BIOS A42 08/17/2023
[61110.467721] RIP: 0010:kmem_cache_destroy+0x14d/0x160
[61110.467724] Code: 99 7d 07 00 48 89 ef e8 e1 6a 07 00 eb b3 48 8b 55 60 48 8b 4c 24 20 48 c7 c6 70 fc 66 90 48 c7 c7 f8 ef a1 90 e8 e1 ed 7c 00 <0f> 0b eb 93 c3 cc cc cc cc 66 2e 0f 1f 84 00 00 00 00 00 55 48 89
[61110.467725] RSP: 0018:ffffa304e489fe80 EFLAGS: 00010282
[61110.467727] RAX: 0000000000000000 RBX: ffffffffc0d9a860 RCX: 0000000000000027
[61110.467729] RDX: ffff8fd5ff9598a8 RSI: 0000000000000001 RDI: ffff8fd5ff9598a0
[61110.467730] RBP: ffff8fb6aaf78700 R08: 0000000000000000 R09: 0000000100d863b7
[61110.467731] R10: ffffa304e489fd20 R11: ffffffff913bef48 R12: 0000000040002000
[61110.467731] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[61110.467733] FS:  00007f64c89fb740(0000) GS:ffff8fd5ff940000(0000) knlGS:0000000000000000
[61110.467734] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[61110.467735] CR2: 00007f0f02bfe000 CR3: 00000020ad6dc005 CR4: 0000000000770ee0
[61110.467736] PKRU: 55555554
[61110.467737] Call Trace:
[61110.467738]  <TASK>
[61110.467739]  qla2x00_module_exit+0x93/0x99 [qla2xxx]
[61110.467755]  ? __do_sys_delete_module.constprop.0+0x178/0x280

Free sp in the error path to fix the crash.

Fixes: f352eeb75419 ("scsi: qla2xxx: Add ability to use GPNFT/GNNFT for RSCN handling")
Cc: stable@vger.kernel.org
Signed-off-by: Anil Gurumurthy <agurumurthy@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_gs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 02a52c215797..e5ebb9c5b650 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -3532,8 +3532,8 @@ int qla_fab_async_scan(scsi_qla_host_t *vha, srb_t *sp)
 	if (vha->scan.scan_flags & SF_SCANNING) {
 		spin_unlock_irqrestore(&vha->work_lock, flags);
 		ql_dbg(ql_dbg_disc + ql_dbg_verbose, vha, 0x2012,
-		    "%s: scan active\n", __func__);
-		return rval;
+		    "%s: scan active for sp:%p\n", __func__, sp);
+		goto done_free_sp;
 	}
 	vha->scan.scan_flags |= SF_SCANNING;
 	if (!sp)
-- 
2.23.1

