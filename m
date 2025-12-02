Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49A4B146D5A
	for <linux-scsi@vger.kernel.org>; Tue,  2 Dec 2025 05:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764654375; cv=none; b=hDh9fmvAZ1cAAbC/tIQ1q9IMf/ZN3A/bYQooIrhRlcqCZ9Tk7puH9JXebstsRyisHgyZ87LUw8dmbRvmhdWH1VYq6XGfAnkZIHbgfIbFXlSIHkeFyggoBcBuDyW6ROISWbe6xteNrymHpNQ/M5aqdwpmXza9XBxpR7tTsSOIDFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764654375; c=relaxed/simple;
	bh=fJxoD8iwqDua1tzL+wBP5mWgfrUF8mGfJ1YPiqp2aV8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uVp6+QNoOO2qHlb32dqI312OeGmnH93ayf7T6Fm8sHP0kRiFXAvVT5wEO6Rop5+tNEgCVVISmI/6lpIJnxSRKzdLtYXwibnZnsqJmfIB3AOvacnjqyRp0kuK61VdiqXBpC+O0aufTxQb/XUPLtDrTE5IMDZbIHhSx9YKo2g81Hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=WEAl2c1b; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="WEAl2c1b"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B1NSBji2365021;
	Mon, 1 Dec 2025 21:46:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=e
	/OMSbJtfjmqV5ObjOXo+TAiqPUn8Pz57fp8PJjx9cc=; b=WEAl2c1b/1XhYJZ08
	7M7H0O/kKHHgnCusyL1nBYCQZHVwO6cwPwVR9JwyBD0eIe1O0v6GN1O8IdS+LXEB
	XT346veGQczbSKTA/snoN02zHKTbPfwiSHmfDp7V8La/hOA3NiIb8isHpjLDFCjt
	kpVye8/ynSnnPGCoiM9IdRcfzb/8A6Y3OCLwWBUovHxooAxE2dgce+JCPBDwSRMc
	6jO5KHi9Fshsl1gXJvkdf/o0o+1nW82yP8wAAFgYM6svIDlMPwl3A3XMMQXpqkLh
	pCp/+uV4u/lghk+MldpW1HBfneAuPOa0hLB67CzqMXWDkYeuObCNvgfm7sii6XNf
	uqggA==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4asmqh8m2m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Dec 2025 21:46:10 -0800 (PST)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 1 Dec 2025 21:46:23 -0800
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 1 Dec 2025 21:46:23 -0800
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 63B705B6975;
	Mon,  1 Dec 2025 21:46:07 -0800 (PST)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>, <emilne@redhat.com>,
        <jmeneghi@redhat.com>
Subject: [PATCH 07/12] qla2xxx: Delay module unload while fabric scan in progress
Date: Tue, 2 Dec 2025 11:14:39 +0530
Message-ID: <20251202054444.1711778-8-njavali@marvell.com>
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
X-Authority-Analysis: v=2.4 cv=HMnO14tv c=1 sm=1 tr=0 ts=692e7d22 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=vQnDjoZTav_Nof0fcPgA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: ct3qjHytxWElJ__K_FLefD3M-s9o3uSZ
X-Proofpoint-GUID: ct3qjHytxWElJ__K_FLefD3M-s9o3uSZ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjAyMDA0MyBTYWx0ZWRfX48f6fIgB4h1D
 q6Xd2UlEVGl8nnQuTQxWmdVklxhV+RiX034D/fX/U5rJwoaGZ6taPJ93prYAIt0EqV+bAKhG6Nb
 guawcSUBCcZh/qxzRwjl5mxA8jcsE0ROi00WIizoU80cnxmVbIGXe9pFRZFz8HSrbE+DGDUJwPA
 XH6ittynzOxuSnQvsdROhXG8aLzKc2ynTFtLd3zwsJqiWttBaBOAaMAk9B+K1C7Q6amSLcCni8Y
 gjLOyBO7xqunfzNQdvDOajK0jQTGZTKqN3Q7e6nYXgik4d6x1VbEVEzF2NS/FvyJgdc9F9KeZw4
 HfkZNJY+M218A9VkYEQjrw/E42xEmTo+xngyUo5ldX3xgPvveoGQFuy8kIYhI4Ilk1I7b1y+GAT
 e4riARXlb+4LcnyKNupeuP7ucNalSA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-28_08,2025-11-27_02,2025-10-01_01

From: Anil Gurumurthy <agurumurthy@marvell.com>

System crash seen during load/unload test in a loop.

[105954.384919] RBP: ffff914589838dc0 R08: 0000000000000000 R09: 0000000000000086
[105954.384920] R10: 000000000000000f R11: ffffa31240904be5 R12: ffff914605f868e0
[105954.384921] R13: ffff914605f86910 R14: 0000000000008010 R15: 00000000ddb7c000
[105954.384923] FS:  0000000000000000(0000) GS:ffff9163fec40000(0000) knlGS:0000000000000000
[105954.384925] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[105954.384926] CR2: 000055d31ce1d6a0 CR3: 0000000119f5e001 CR4: 0000000000770ee0
[105954.384928] PKRU: 55555554
[105954.384929] Call Trace:
[105954.384931]  <IRQ>
[105954.384934]  qla24xx_sp_unmap+0x1f3/0x2a0 [qla2xxx]
[105954.384962]  ? qla_async_scan_sp_done+0x114/0x1f0 [qla2xxx]
[105954.384980]  ? qla24xx_els_ct_entry+0x4de/0x760 [qla2xxx]
[105954.384999]  ? __wake_up_common+0x80/0x190
[105954.385004]  ? qla24xx_process_response_queue+0xc2/0xaa0 [qla2xxx]
[105954.385023]  ? qla24xx_msix_rsp_q+0x44/0xb0 [qla2xxx]
[105954.385040]  ? __handle_irq_event_percpu+0x3d/0x190
[105954.385044]  ? handle_irq_event+0x58/0xb0
[105954.385046]  ? handle_edge_irq+0x93/0x240
[105954.385050]  ? __common_interrupt+0x41/0xa0
[105954.385055]  ? common_interrupt+0x3e/0xa0
[105954.385060]  ? asm_common_interrupt+0x22/0x40

The root cause of this was that there was a free
(dma_free_attrs) in the interrupt context.
There was a device discovery/fabric scan in progress.
A module unload was issued which set the UNLOADING flag.
As part of the discovery, after receiving an interrupt a
work queue was scheduled (which involved a work to be queued).
Since the UNLOADING flag is set, the work item was not
allocated and the mapped memory had to be freed.
The free occured in interrupt context leading to system crash.
Delay the driver unload until the fabric scan is complete
to avoid the crash.

Fixes: 783e0dc4f66a ("qla2xxx: Check for device state before unloading the driver.")
Cc: stable@vger.kernel.org
Signed-off-by: Anil Gurumurthy <agurumurthy@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 5ffd94586652..769aaff313b1 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1182,8 +1182,9 @@ qla2x00_wait_for_hba_ready(scsi_qla_host_t *vha)
 	while ((qla2x00_reset_active(vha) || ha->dpc_active ||
 		ha->flags.mbox_busy) ||
 	       test_bit(FX00_RESET_RECOVERY, &vha->dpc_flags) ||
-	       test_bit(FX00_TARGET_SCAN, &vha->dpc_flags)) {
-		if (test_bit(UNLOADING, &base_vha->dpc_flags))
+	       test_bit(FX00_TARGET_SCAN, &vha->dpc_flags) ||
+		(vha->scan.scan_flags & SF_SCANNING)) {
+			if (test_bit(UNLOADING, &base_vha->dpc_flags))
 			break;
 		msleep(1000);
 	}
-- 
2.23.1

