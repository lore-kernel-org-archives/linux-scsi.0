Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C0BF3128A0
	for <linux-scsi@vger.kernel.org>; Wed, 10 Dec 2025 10:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765361803; cv=none; b=JwgkPworBriQS6Y56YUUfsxwi0l4JQhutNswVAwXsIK/s/Anz8FE2p2nzis88wTcSJtXFNU10Rv4HX+bXquUJYcsh3mXWZWI4u4tViIVcMOMF98Biddo8mrRLarg1FDm3UihP3AMTmHolJ3oVEFY4jy2nu/thpzHzPsJDlCqIWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765361803; c=relaxed/simple;
	bh=e4M9Mt/i9V7FvDoCZRo+6rLtVqbcKM9h++QYel3nsPw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n6rm4lFlcL/xzeoUA7JnYBfbsCA5OpzdjBkDmFKYAtuSN+K8LXsbIP8qn3oM7v4i1czhG0tHddvKO1Pp8XnlI5J5o8oS8JCKYz01UuoXCFVbAI4MGCMeOID/3vmq9IIRv8qISMvg8H6mntNgx90iNeBo6btzCeFMOoIkK7Acjms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=UCGEKYku; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="UCGEKYku"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BA4afgE3664264;
	Wed, 10 Dec 2025 02:16:40 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=H
	CL51M8E1UM/HWuQmU7/ktrtmgSWycsU7n34HT2cJ9A=; b=UCGEKYkumVcZalXW9
	7NKI6Th+0i5hchryy7R2KPRp5tePE/b0M8ndvL2+f70yVdh8d6Q/UvSDeHR09/ol
	MHg5vmvCQd3TRdquY/e7Gnopech+S+DozjpI+ENAdUmFGRUUR1S8uU1dtJuhxUn1
	y46YPL4DkcrKQGLeHQs32tgIzaICq1NU/77eVqlbq54KlxfzwprY3RZe+tFtgaJJ
	fMTbi/QpMlhwNRMFKIXwC5ZG8nuOzWczegHMuYT/44W8GGeVVHYh18HqJAE/sD0g
	WZN+paF7k+Hkiub/q0wdklsU0NBDsbg5unSJBet6tIMvG0eKJf8d86Cj2TDtZQx0
	YRkGw==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4ax8ckg5yu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Dec 2025 02:16:39 -0800 (PST)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 10 Dec 2025 02:16:52 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Wed, 10 Dec 2025 02:16:52 -0800
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 47BA13F709D;
	Wed, 10 Dec 2025 02:16:37 -0800 (PST)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>, <emilne@redhat.com>,
        <jmeneghi@redhat.com>
Subject: [PATCH v3 08/12] qla2xxx: free sp in error path to fix system crash
Date: Wed, 10 Dec 2025 15:46:00 +0530
Message-ID: <20251210101604.431868-9-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20251210101604.431868-1-njavali@marvell.com>
References: <20251210101604.431868-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Authority-Analysis: v=2.4 cv=W8c1lBWk c=1 sm=1 tr=0 ts=69394887 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=pGLkceISAAAA:8 a=T9IcfguAtBVHYGVSdbkA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjEwMDA4NSBTYWx0ZWRfXxFb0vaa2I/9Z
 a57s5/OimZXn9gjuOvolZ919mUuzKi0Ujhkq3nEDVNUY/lgy55zbAcEAfGy9T3EYj75bOjBcroI
 v9CODbYTR/OsLgR+OVoHBcjmpby/bfp1v3dorZJB85pQt42BsblkJhzpaPdpxMfZsZYTkfNfB27
 mhs9KO5r7MfBGwyQGH8GPfibJ+Qem4H1MrNJpVwi/trOIlIVKlm28zk+uvcgSv47hcthFQiErxd
 WT/PsODxBxp0sCLlUnLepB6LLwGPQDRcOaEGhboP8kXDy/Re2oUnHhdZ3bDcct/ShG0XxTSFK86
 VGVe1SpTia+ftHoJO5W6eezjbvE0rq0gTsaI28KplK0Lx9+TAFR+eIamfhaRpYm/yZq18NHGXRw
 4fKLl2EYMNkxnLMdOIUDGTeIfBNpsA==
X-Proofpoint-ORIG-GUID: qjZki4Gn7h8TnPhDFiKCTDZ3zwWqorB0
X-Proofpoint-GUID: qjZki4Gn7h8TnPhDFiKCTDZ3zwWqorB0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-09_05,2025-12-09_03,2025-10-01_01

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
Reviewed-by: Himanshu Madhani <hmadhani2024@gmail.com>
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

