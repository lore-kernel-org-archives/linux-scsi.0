Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4633A1F130A
	for <linux-scsi@vger.kernel.org>; Tue,  2 Dec 2025 05:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764654384; cv=none; b=Cvyly4Ky52VVfNjf4j24GkW/7du/Xq+1WCjH26vt/rg2tc+URckv1EsbmgHFdu0c06HHIea9fsbCEo+zLC2me0K5yiHs5XJ+6JP8+bq2CnnSlkrEoYkr4cIpOk1ieOJ0xyV52RU7Nn7aVxr0Cnne12Ayp+WVncD68msTooJWrUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764654384; c=relaxed/simple;
	bh=JUrMMRpNQ9rFKae/QtzP1xV2I4+a3+MzH2kQkTswCq8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NCaKaXiHLX7Ytalkn9+H4NO6uEgu84EEq7fsgLp7OdLFaWe8WVIkEN1zPQVCUoMH9EvxxBJy+Mxf1ZBZRSl82o3pBQloSBFG9SXddUbfz1N8TGl7kRElKwOrXC1wpIQr2vfe9xqshNx7d0Ag9T4nT2mQo4Px3C9dXnrwM+5Y0Uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=UKgU9YFJ; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="UKgU9YFJ"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B1NSBs52365008;
	Mon, 1 Dec 2025 21:46:21 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=v
	NxviH+RUMANBM+NvVaqCk1LEmyO9M0eKHn06l8tc5w=; b=UKgU9YFJ0T1EemUb/
	jTD4Z+7wE5SRx9Kh1SbdvPVOvGV1feoKq8EnD3Ij26nBavS6IejDHQgwcxMNi9WL
	mZYSKCesu6Tq+RcJtgn+uJrhfgqoEx6zbygOtNFohwjNALViKnDIfVEXZvwFS0rO
	1L92yXHzwsj6uvIQ/Z6Zt/dYY1LBktm/q13p7NnW8Brbm9dska11wuxyYsS/Neez
	hYPl3T6GOBmGaPhy1hND5cyrC6ES82bH/HjQALbn+XpbM7rcKRCagie5DhikPBv8
	NdTSKZ+wW/qEovTCTVfBTqCuV9MHvtaFqa+rMbAXBCxvMw+JNIXiVjtCzmkQwyyc
	OLh6w==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4asmqh8m3s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Dec 2025 21:46:21 -0800 (PST)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 1 Dec 2025 21:46:33 -0800
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 1 Dec 2025 21:46:33 -0800
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id E5A055B6972;
	Mon,  1 Dec 2025 21:46:17 -0800 (PST)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>, <emilne@redhat.com>,
        <jmeneghi@redhat.com>
Subject: [PATCH 11/12] qla2xxx: fix bsg_done causing double free
Date: Tue, 2 Dec 2025 11:14:43 +0530
Message-ID: <20251202054444.1711778-12-njavali@marvell.com>
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
X-Authority-Analysis: v=2.4 cv=HMnO14tv c=1 sm=1 tr=0 ts=692e7d2d cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=oK_aeN5Z_2LSqHoCI5QA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: fp1kMMkzeu3uBBJcWP-GHqExuQTPBcd9
X-Proofpoint-GUID: fp1kMMkzeu3uBBJcWP-GHqExuQTPBcd9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjAyMDA0MyBTYWx0ZWRfX2SUiaxdJ05BS
 i7Y6OvARDsNxscV7YVcvc4IEqj3zCqdH4t+iXPhUNGYXonVvYS2jtmHubz2GXK/GTFQinHOiqDg
 NV/ico8CI0fXUGQwYAOGlqZAJWspvICWGUi/rgukAT6ke61hzXmDW8S/qBxMl9Nsze75g26FhO5
 DR6NIHJ1K8pj1adSdAkY7/v1TxdhI0ix83iKsPOXcjqWzHVm4yZsGiXmn5DODolA1kE1N8kUvvH
 kylyyA3eNQK9iVu8pbYSyMT6ouGzKfMtTzU58LzICCVJjYY2aFJNNAFNSzhIo9mHrZfv4auan9B
 lTkj/F9U93d3HgkngGqzhWBBDq9GAxcIHnAQ84IPnZQmp7Y8aARMNWjI06I0Fb1r5/JZMcLp251
 It+toUl3hpZIIMoJtKX3gbJb+tHyHw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-28_08,2025-11-27_02,2025-10-01_01

From: Anil Gurumurthy <agurumurthy@marvell.com>

Kernel panic observed on system,

[5353358.825191] BUG: unable to handle page fault for address: ff5f5e897b024000
[5353358.825194] #PF: supervisor write access in kernel mode
[5353358.825195] #PF: error_code(0x0002) - not-present page
[5353358.825196] PGD 100006067 P4D 0
[5353358.825198] Oops: 0002 [#1] PREEMPT SMP NOPTI
[5353358.825200] CPU: 5 PID: 2132085 Comm: qlafwupdate.sub Kdump: loaded Tainted: G        W    L    -------  ---  5.14.0-503.34.1.el9_5.x86_64 #1
[5353358.825203] Hardware name: HPE ProLiant DL360 Gen11/ProLiant DL360 Gen11, BIOS 2.44 01/17/2025
[5353358.825204] RIP: 0010:memcpy_erms+0x6/0x10
[5353358.825211] RSP: 0018:ff591da8f4f6b710 EFLAGS: 00010246
[5353358.825212] RAX: ff5f5e897b024000 RBX: 0000000000007090 RCX: 0000000000001000
[5353358.825213] RDX: 0000000000001000 RSI: ff591da8f4fed090 RDI: ff5f5e897b024000
[5353358.825214] RBP: 0000000000010000 R08: ff5f5e897b024000 R09: 0000000000000000
[5353358.825215] R10: ff46cf8c40517000 R11: 0000000000000001 R12: 0000000000008090
[5353358.825216] R13: ff591da8f4f6b720 R14: 0000000000001000 R15: 0000000000000000
[5353358.825218] FS:  00007f1e88d47740(0000) GS:ff46cf935f940000(0000) knlGS:0000000000000000
[5353358.825219] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[5353358.825220] CR2: ff5f5e897b024000 CR3: 0000000231532004 CR4: 0000000000771ef0
[5353358.825221] PKRU: 55555554
[5353358.825222] Call Trace:
[5353358.825223]  <TASK>
[5353358.825224]  ? show_trace_log_lvl+0x1c4/0x2df
[5353358.825229]  ? show_trace_log_lvl+0x1c4/0x2df
[5353358.825232]  ? sg_copy_buffer+0xc8/0x110
[5353358.825236]  ? __die_body.cold+0x8/0xd
[5353358.825238]  ? page_fault_oops+0x134/0x170
[5353358.825242]  ? kernelmode_fixup_or_oops+0x84/0x110
[5353358.825244]  ? exc_page_fault+0xa8/0x150
[5353358.825247]  ? asm_exc_page_fault+0x22/0x30
[5353358.825252]  ? memcpy_erms+0x6/0x10
[5353358.825253]  sg_copy_buffer+0xc8/0x110
[5353358.825259]  qla2x00_process_vendor_specific+0x652/0x1320 [qla2xxx]
[5353358.825317]  qla24xx_bsg_request+0x1b2/0x2d0 [qla2xxx]

Most routines in qla_bsg.c call bsg_done only for
success cases.
However a few invoke it for failure case as well
leading to a double free. Validate before calling bsg_done.

Cc: stable@vger.kernel.org
Signed-off-by: Anil Gurumurthy <agurumurthy@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_bsg.c | 33 ++++++++++++++++++++-------------
 1 file changed, 20 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 8afa8a4b8ccb..2c44a379cb23 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -1548,8 +1548,9 @@ qla2x00_update_optrom(struct bsg_job *bsg_job)
 	ha->optrom_buffer = NULL;
 	ha->optrom_state = QLA_SWAITING;
 	mutex_unlock(&ha->optrom_mutex);
-	bsg_job_done(bsg_job, bsg_reply->result,
-		       bsg_reply->reply_payload_rcv_len);
+	if (!rval)
+		bsg_job_done(bsg_job, bsg_reply->result,
+			     bsg_reply->reply_payload_rcv_len);
 	return rval;
 }
 
@@ -2638,8 +2639,9 @@ qla2x00_manage_host_stats(struct bsg_job *bsg_job)
 				    sizeof(struct ql_vnd_mng_host_stats_resp));
 
 	bsg_reply->result = DID_OK;
-	bsg_job_done(bsg_job, bsg_reply->result,
-		     bsg_reply->reply_payload_rcv_len);
+	if (!ret)
+		bsg_job_done(bsg_job, bsg_reply->result,
+			     bsg_reply->reply_payload_rcv_len);
 
 	return ret;
 }
@@ -2728,8 +2730,9 @@ qla2x00_get_host_stats(struct bsg_job *bsg_job)
 							       bsg_job->reply_payload.sg_cnt,
 							       data, response_len);
 	bsg_reply->result = DID_OK;
-	bsg_job_done(bsg_job, bsg_reply->result,
-		     bsg_reply->reply_payload_rcv_len);
+	if (!ret)
+		bsg_job_done(bsg_job, bsg_reply->result,
+			     bsg_reply->reply_payload_rcv_len);
 
 	kfree(data);
 host_stat_out:
@@ -2828,8 +2831,9 @@ qla2x00_get_tgt_stats(struct bsg_job *bsg_job)
 				    bsg_job->reply_payload.sg_cnt, data,
 				    response_len);
 	bsg_reply->result = DID_OK;
-	bsg_job_done(bsg_job, bsg_reply->result,
-		     bsg_reply->reply_payload_rcv_len);
+	if (!ret)
+		bsg_job_done(bsg_job, bsg_reply->result,
+			     bsg_reply->reply_payload_rcv_len);
 
 tgt_stat_out:
 	kfree(data);
@@ -2890,8 +2894,9 @@ qla2x00_manage_host_port(struct bsg_job *bsg_job)
 				    bsg_job->reply_payload.sg_cnt, &rsp_data,
 				    sizeof(struct ql_vnd_mng_host_port_resp));
 	bsg_reply->result = DID_OK;
-	bsg_job_done(bsg_job, bsg_reply->result,
-		     bsg_reply->reply_payload_rcv_len);
+	if (!ret)
+		bsg_job_done(bsg_job, bsg_reply->result,
+			     bsg_reply->reply_payload_rcv_len);
 
 	return ret;
 }
@@ -3272,7 +3277,8 @@ int qla2x00_mailbox_passthru(struct bsg_job *bsg_job)
 
 	bsg_job->reply_len = sizeof(*bsg_job->reply);
 	bsg_reply->result = DID_OK << 16;
-	bsg_job_done(bsg_job, bsg_reply->result, bsg_reply->reply_payload_rcv_len);
+	if (!ret)
+		bsg_job_done(bsg_job, bsg_reply->result, bsg_reply->reply_payload_rcv_len);
 
 	kfree(req_data);
 
@@ -3359,8 +3365,9 @@ static int qla28xx_validate_flash_image(struct bsg_job *bsg_job)
 	bsg_reply->result = DID_OK << 16;
 	bsg_reply->reply_payload_rcv_len = 0;
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
-	bsg_job_done(bsg_job, bsg_reply->result,
-			bsg_reply->reply_payload_rcv_len);
+	if (!rval)
+		bsg_job_done(bsg_job, bsg_reply->result,
+			     bsg_reply->reply_payload_rcv_len);
 
 	return QLA_SUCCESS;
 }
-- 
2.23.1

