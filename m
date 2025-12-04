Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 091EA2D0C95
	for <linux-scsi@vger.kernel.org>; Thu,  4 Dec 2025 15:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764861502; cv=none; b=gEbR1fN8jc6WrI+iDFKZHEgiGmcxGJApWIw644cCNNTLX+8ScU8s6pJmjA/EYXxYWw8lf4hhZzZ68XCaBMpAkTJ5ufAx1EtuYd37SxJPHodElhGH4c8Q73mJY4Hxfe5soXqte1+v5Zfbcss4j7QQPrIHaTcUqMnso3S2k/D+iwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764861502; c=relaxed/simple;
	bh=dY3qrTQAb8/tS9rLL5NZPzYziRQg8yQTWQHPGW2xvqs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Cw4Dzzw4hoNkHu+V4BR0kBo5WVXH9EfDSYMm0XPQQiNMxNSyh10AxKZbs8Vo3X9+hWRQvCQ6DrVHANgMNMgYLpLrOu8kQr+TAiDVVgfQNkRkylNHndbDXv4RvmpVyNEeHoPeyEK4KySNBPbLXvt3FpdLS4ypAkhBM0T4XC1+RX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=QO061wFy; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="QO061wFy"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B46ZVAd3332972;
	Thu, 4 Dec 2025 07:18:18 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=P
	Bq4GbMXfrdupdHWxie2XSJT5VxIbdbFhpwPCcNchmA=; b=QO061wFyc+0LFLS6h
	wD4J1LvCIewF3k2ajsle2qfdGCPzMtvVMc0APrYHfTrkhrWL3oXjk+IE9n1Ysiym
	2gGkh99gXbH+uHX0IcOtlpJR/mGwVrSsSgG4KuAbOpW3JyR3+1uZKt4hiZZdJwgr
	Fxi3rDQxQeqzxDyn0aPnjl2W1G8Ku+YMLmwd7yS6UPXmw52KDVfx2KHCkcDYfevf
	KhaqM7uXLzWglut0cIc9TvIwPYOrybfRAZdca7cqZ8GFbLY598GFG+h2Z57iYYpR
	XuJTxsFOpF5JFN07wyIimar+syv4H/NzsTgvf9fkBKVCOBx45/0I5LR4LjIcXz+k
	JGHrQ==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4atjuu3n4t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 04 Dec 2025 07:18:18 -0800 (PST)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 4 Dec 2025 07:18:29 -0800
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Thu, 4 Dec 2025 07:18:29 -0800
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 873CB3F7074;
	Thu,  4 Dec 2025 07:18:14 -0800 (PST)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>, <emilne@redhat.com>,
        <jmeneghi@redhat.com>
Subject: [PATCH v2 07/12] qla2xxx: Delay module unload while fabric scan in progress
Date: Thu, 4 Dec 2025 20:47:46 +0530
Message-ID: <20251204151751.2321801-8-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20251204151751.2321801-1-njavali@marvell.com>
References: <20251204151751.2321801-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjA0MDEyMyBTYWx0ZWRfX9xNi2cxBdfXu
 v7c2xhDX755Z8UF39NClcQE9gW1ZXnR0HAmp373FgrEbGMd6yAHLO3JX59FZNhltoMEIrn7WxW8
 L6/P8jReOAdel3tetzE/2fkJz07HibJJPuVuCP03fwq0V/j/g1bwS0qPDOi2WfPoxYa5ceV6NTo
 lhcFijkfLVYLMVBA35r1dvMA3cbgKiFq34RJFe5A4Vjbx8P/RFR+mLtivBz/Tz7uo8Du0WbmeIs
 jHRBgPp/1eSZ7FOc0pXzqiNKSoq8+6841UvOSzFJMk7OnB0VJXVZuOZIoMt8OEsEiXGshNX/qMC
 nN5whBPnUvlGdJrttzV6ha/j830nmk9EHXO9VEMO/V9+URXTVDbL8qnaG99e//Z5SRczKwHgZ+A
 hh5RBs+0QU/zZW/kGmXrMnNKetPyYA==
X-Proofpoint-ORIG-GUID: Ft_9I5uPqXxXKvhhio1zVS9Xf02_lLex
X-Proofpoint-GUID: Ft_9I5uPqXxXKvhhio1zVS9Xf02_lLex
X-Authority-Analysis: v=2.4 cv=E/nAZKdl c=1 sm=1 tr=0 ts=6931a63a cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=pGLkceISAAAA:8 a=vQnDjoZTav_Nof0fcPgA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-04_03,2025-12-04_01,2025-10-01_01

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
Reviewed-by: Himanshu Madhani <hmadhani2024@gmail.com>
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

