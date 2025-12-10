Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A6DE312824
	for <linux-scsi@vger.kernel.org>; Wed, 10 Dec 2025 10:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765361802; cv=none; b=fYEdBLnGYu0NNFI2p8THOVuSMXOtsbYBi1SoiHVvriVsieIwlt+2FZWOHjK7RCH+0hlUC6calZduQgI2WIjG3BqrzzCFVo+/ac0UDDYXZ/pZThJ9U2JTtEAkpIFROoSPGkQnTDqzJ2/gPngpG439WgWTqnimPHEaw/mO46l03hA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765361802; c=relaxed/simple;
	bh=HtLacOxJRLZtZ40cLfUkxeGplkaKhfk/TTcdjAIDZlc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NMgqgp1sLGUlcQHYaHKmLZHi/4H4gSPgKN5mxK3Iy5rZvRImI1mnLYjuBaZVs4pF0yrirh6d/lM82mM0e9OKEQ2IoxBC4pLIzQPISYUDFrdQdxOIqGQRtnVJI7ogmcFcv7fNevla6lfEOw5dkOl5VIMj4RTMOGwgLBpUVcRBQUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=fail smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=FDDA811T; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="FDDA811T"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BA4aLJ03329360;
	Wed, 10 Dec 2025 02:16:38 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=W
	pXqJZ3FPWy3CFg4YvWlbiDTbPL+vWRn68BUIUVdAus=; b=FDDA811TFMALCZdpC
	QJpKqgu4VN+qMEppxcpdZs/dQIKNqaHuFzz8ihQ34VBGO4NEhxFA60/w0eao7/5y
	+YXOWxui8aaPc6VB6mXx7gHBSZcePxfwWSolrqj9+KVyakb8uGHKjBHH9fMR1FKe
	V99bEjZBbaFN7k2jEnN/4e5SHuy2TJmziuoa5O+v8xGtXEohzZYLwE4b/4wHKr3U
	TNH85w/KhA27QD9/N1186WBGFmuQgFCcXqSRI02JIlcYyxv3JEsFoWGQFutohdem
	BlV7J8WX5z312cq37m43HL63qtx+VwV/lCINbAY51lKHNBapA4jc5ZCCeJtzcc85
	5BSFQ==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4axuknhj18-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Dec 2025 02:16:37 -0800 (PST)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 10 Dec 2025 02:16:50 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Wed, 10 Dec 2025 02:16:50 -0800
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 9DEEB3F709D;
	Wed, 10 Dec 2025 02:16:34 -0800 (PST)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>, <emilne@redhat.com>,
        <jmeneghi@redhat.com>
Subject: [PATCH v3 07/12] qla2xxx: Delay module unload while fabric scan in progress
Date: Wed, 10 Dec 2025 15:45:59 +0530
Message-ID: <20251210101604.431868-8-njavali@marvell.com>
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
X-Proofpoint-GUID: 1HRT6SGj73vgAdlQQgjnFmgoEQFK5Qwn
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjEwMDA4NSBTYWx0ZWRfXwUY1tQU9OUPn
 hWkWNEygvVgmMvcyPeYXXtub58oSjj7jYxe7eerDBnKf9spcWsiO6+kKd2qNtTwuE21pj1GO4z8
 qqKRK1lLeUgInbPjItGlf91KITwGjXHcc0WtnX8Cg7NuvZaCOqCno7pT2u32mdoWlIhtubfN3Cz
 6OFEpDQqWjrLJimezrsiYzbNItXgdDtqbpplXKd2Yi7j8QcT3IpPAMflb5tyIPbiIh+h8gqLwSI
 5COepv7wH1tGMQP1sbNRST5b2OEF112IfHfEl0Ityeo4snDDbq+xU48oBFLLxhJmEOSSH2eclNi
 ADt5vCfuAPwo6C4G1cqnMqvZ0QOqz6srL/uQgdek3uD9WWZELuDTvhQGPOiG3pwxdL+xsUVwnny
 QDXHEWfLHgW7tscRtbyOH+B88w4mDQ==
X-Proofpoint-ORIG-GUID: 1HRT6SGj73vgAdlQQgjnFmgoEQFK5Qwn
X-Authority-Analysis: v=2.4 cv=P483RyAu c=1 sm=1 tr=0 ts=69394885 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8
 a=M5GUcnROAAAA:8 a=KKAkSRfTAAAA:8 a=pGLkceISAAAA:8 a=-DQe6t740v65wb3uHhAA:9
 a=OBjm3rFKGHvpk9ecZwUJ:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-09_05,2025-12-09_03,2025-10-01_01

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
The free occurred in interrupt context leading to system crash.
Delay the driver unload until the fabric scan is complete
to avoid the crash.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/all/202512090414.07Waorz0-lkp@intel.com/
Fixes: 783e0dc4f66a ("qla2xxx: Check for device state before unloading the driver.")
Cc: stable@vger.kernel.org
Signed-off-by: Anil Gurumurthy <agurumurthy@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <hmadhani2024@gmail.com>
---
v3:
fix warning reported by kernel robot and Dan Carpenter
v2:
fix warning reported by kernel robot
 drivers/scsi/qla2xxx/qla_os.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 5ffd94586652..5f5f3b3bb043 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1182,7 +1182,8 @@ qla2x00_wait_for_hba_ready(scsi_qla_host_t *vha)
 	while ((qla2x00_reset_active(vha) || ha->dpc_active ||
 		ha->flags.mbox_busy) ||
 	       test_bit(FX00_RESET_RECOVERY, &vha->dpc_flags) ||
-	       test_bit(FX00_TARGET_SCAN, &vha->dpc_flags)) {
+	       test_bit(FX00_TARGET_SCAN, &vha->dpc_flags) ||
+	       (vha->scan.scan_flags & SF_SCANNING)) {
 		if (test_bit(UNLOADING, &base_vha->dpc_flags))
 			break;
 		msleep(1000);
-- 
2.23.1

