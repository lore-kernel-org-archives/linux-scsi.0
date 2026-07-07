Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C43627466A
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 05:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783403862; cv=none; b=APkKllXh/Alb//pu5hWjGBC28tX1WXUWnA4JimXxZRqCm2gBg6w28IEnQntobq+Dy7q+TtfVX3HQ614EEznCNefx9hT3UbeKZHFeKQlWOageKarPaTB5xpCIcqyE6nGmTxO/VyChOhj/BtKxX8pvo9PoQO5qe+gdrfRXeQWTsPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783403862; c=relaxed/simple;
	bh=/GNOwif3g6q8A7V8fnWLBh6/DGipzhWPzs1T+udCf7g=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ohYf7JLlgUvn/XPKSaTvKKgrQ2A2e60raMtsmkVPI9D/Bg2P4mi+pHNYBkYu6D6Ok/AIPWEbV4Kp3i/tjLBo1LBtlFv8o34xPRksyQY6GTY0vYvyBW/0J7CM2uL2IgulPLJFWbEcEd5V4hqcTafBgZvh5FHmTjoOG3Lpq5nEQL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=BjILMReu; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="BjILMReu"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 667482Ge872799;
	Mon, 6 Jul 2026 22:57:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=d
	4Y+NcquIPufgNwPhBZYrEVUhh37AB9jcXiVzu2kkl4=; b=BjILMReuggvARusqP
	pvrkEe55dE5cQn6NavU7O5BJOVYmEaQeAS9S/1RDRDle5b3QQ2MXMelADw6ebcrb
	dT8ggxdFblVKRRlTSM5yeBFjPzosS3WyZG92wMescoNFcMJaQ+AP9jZbcGon4ghk
	3OUocTA7KYBngN+DVvrRyZ03t0PUZzb4HzMBHk/QR0d0zNX0naP5yo1kHJOljADM
	RgtZs57oeQtAKE39wzv/xXliOP6cmyM+1BbsjfVpN3SlkLetfMcA7e5ubQYb5KoL
	alb6Ba8xQpPHXtsOYQdwm3dGu0Aezh4xR8nf3rdl5IN9MD6xW3lhAMhPMykGjNnn
	O58kg==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4f8f9waa6w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Jul 2026 22:57:38 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 6 Jul 2026 22:57:37 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 6 Jul 2026 22:57:37 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id E35EE3F7066;
	Mon,  6 Jul 2026 22:57:34 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v3 54/88] scsi: qla2xxx: Fix BSG job leak on validate flash image error path
Date: Tue, 7 Jul 2026 11:24:01 +0530
Message-ID: <20260707055435.2680300-55-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260707055435.2680300-1-njavali@marvell.com>
References: <20260707055435.2680300-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: qLFV425yH29u2_wbZ710iEtMCADlhQTJ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfX7NfZo9753m1g
 +VZAXPjABuZf3cKRz+pcw+plYjK8dCtpUn2/boRMswF14m7//Cssbf2YOckcdknIjI0kPaMDAO4
 m4SXr1qVKMaYXVyXYgMHUddcI9mM+qjQSNefkxTF/gp4v8RM4RCzSWlm6C4SQzSO2IqYp7iMwCk
 foy8JKkxyykiUkXoPTtZUBGHGu7bpoG61DPL8UTfqMe8BCFkR8wsMKNatPCSATcvqZAggh5mSpC
 hefxzYoWPGWGcOlPm9sNFBF6g5xVYVEAuZwVAlbVTq6iumkEnCAYgJLk7M7M8nnswL2qKLOHX/D
 WrRphnFwRu44piJ65AqGW/EETIcfpWBy/6PBfkxvbOc+aUl4mSRcmWhP5s5v0gb2dhiMtGf9v4e
 uURk/tGbWqvVV1g1uVDu1cYqr2q43KhtHy7hHvxtJF/OAqqgR8F6z122ehNVRowZLczn7DlkntX
 XEadV9TpupvRPu0jWQA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfXxtga2f05I19r
 RZ8LsHU0Hxu5OZ5QnLcjvfFaFWSkdIXdn/vpv0AylhwkC2gAjmaLacIJ95C5x/BQFAHXH4vzc4n
 aLA0hnIkWkJmBIjx20SEQoCwj4o6AOs=
X-Proofpoint-GUID: qLFV425yH29u2_wbZ710iEtMCADlhQTJ
X-Authority-Analysis: v=2.4 cv=SY/HsPRu c=1 sm=1 tr=0 ts=6a4c9552 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=qit2iCtTFQkLgVSMPQTB:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=YLGBn9Xrq-Gyn1ev87cA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_01,2026-07-06_02,2025-10-01_01

qla28xx_validate_flash_image() returns QLA_SUCCESS (0) unconditionally,
telling the FC BSG transport (fc_bsg_host_dispatch()) that the driver
owns and will complete the request. But bsg_job_done() is guarded by
"if (!rval)", so on the error path (rval == -EINVAL) neither the driver
nor the transport completes the job. The request dangles until it times
out, leaking block layer resources.

Commit c2c68225b145 ("scsi: qla2xxx: Fix bsg_done() causing double
free") added the "if (!rval)" guard to a batch of BSG handlers. That is
correct for handlers that also return the error code (the transport then
completes the job once via fail_host_msg), but this function returns
QLA_SUCCESS unconditionally, so the guard turned a correct single
completion into a leak.

Always call bsg_job_done(): bsg_reply->result is DID_OK and the error is
reported in vendor_rsp[0], and since the function returns 0 the transport
will not complete the job a second time.

Fixes: c2c68225b145 ("scsi: qla2xxx: Fix bsg_done() causing double free")
Cc: stable@vger.kernel.org
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/qla2xxx/qla_bsg.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index e7739cead967..0c9174d6c887 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -3782,9 +3782,8 @@ static int qla28xx_validate_flash_image(struct bsg_job *bsg_job)
 	bsg_reply->result = DID_OK << 16;
 	bsg_reply->reply_payload_rcv_len = 0;
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
-	if (!rval)
-		bsg_job_done(bsg_job, bsg_reply->result,
-			     bsg_reply->reply_payload_rcv_len);
+	bsg_job_done(bsg_job, bsg_reply->result,
+		     bsg_reply->reply_payload_rcv_len);
 
 	return QLA_SUCCESS;
 }
-- 
2.47.3

