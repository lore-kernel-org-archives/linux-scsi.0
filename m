Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9779432A3D7
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 09:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784023001; cv=none; b=o7BZQ1GeGsuwMAQIgYiMHbTsOBQoQDx6EXlqwqCf9MtVAMHBLOSEvh6c9JlGg1P8uOGZrh6jTiGqwHlpTodT2vDDzzT7ISUTpimtv3Y7p4Jv1Mu0nZCcJyQpZU1FxcvtKSvuiqdiqSze6DmjKfoJe/TnEq3Juh+Kd/SQngeufso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784023001; c=relaxed/simple;
	bh=bth8I2vlzrUu5pK8kyAsedcGMv4TPY/iMgbiqbUl65c=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ucb1apcA9BB0jkii60y3tcEZD1EwGl5HO5TzO1fJbdypFeyPOXEAJIAVox0pCLFP7ukU1SlXNjCwZCTBGHL1StjtId5y5N2Kdgpi/FXtHyfeA/YeQnYRePX5gad7PjPuI5owS7Vm3KFORp3FSUekn0yAzloGnev2KrAhdZ0Aq98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=iMFFgaGB; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="iMFFgaGB"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66E6UZTP2408260;
	Tue, 14 Jul 2026 02:56:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=c
	E6ElIxdMYvwan2KbOePrnoPyWuboL7zOXzLZnV7jrE=; b=iMFFgaGB0pO+ZI7BL
	EDwVy4MAtg1QcvHQ6mPbkO3M8AAnOr+SaqNkEz4qVKVXri1SeX2HKBzP8Il/I0El
	QmZgbaA2x8s9F5FM3Ay+0/vudX109oXDBMo8SGfS/R7zDUP8MggeHiP4Yar4VfKu
	oHD5aGnQrSuQZz7oEqAqdD7O5edYIO9CJp1DanqgaKCYnjg9e9nz3Z9wfwYQFCcT
	1RDOnbEPaCTC1Ggr/maxdSBJrnZE7WuMN2lv/1usK3gr6JiMQqdTdIYVH8w4R384
	+WYVy8Z+UdJ39kNVU3VweMBIhQ8Ro27Vw791yLr2bXVDQtwc7kjZSoLw90aj16+J
	BtrIQ==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4fc6k9nq9n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Jul 2026 02:56:37 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 14 Jul 2026 02:56:37 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Tue, 14 Jul 2026 02:56:37 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 88CE85E6867;
	Tue, 14 Jul 2026 02:56:34 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v4 50/56] scsi: qla2xxx: Hold vport reference in qla24xx_report_id_acquisition()
Date: Tue, 14 Jul 2026 15:23:47 +0530
Message-ID: <20260714095353.289460-51-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260714095353.289460-1-njavali@marvell.com>
References: <20260714095353.289460-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 9mcs2_sFZCDWTCm4bQN4GJZWCCfoC3Or
X-Proofpoint-GUID: 9mcs2_sFZCDWTCm4bQN4GJZWCCfoC3Or
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE0MDEwMyBTYWx0ZWRfXwk4dE3nILwO0
 F8ydG3/yaYz4MciQBJ8cDE2nXzI2vs7VALYY5gA6Iknlx9/PNLY10OuPe60CXsae1qM5wG/HkUo
 UU3CO00qRb5jEj/wVAkKA5HFZH6AUFg=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE0MDEwMyBTYWx0ZWRfX6Y1d7MdMbgwm
 iVdwlyYDo9T4AT1/wqiuUSiasBDKKV7b6qa+CAMaGgWTlf+0MwYlf1bYwNBZheqfqpodnP6PYhG
 UFrs2SuAUwIHRlfw/JNDJ8s7kdZF0exmPnGuPoYgfcHZtkL2/w0HPxTetNtxeF7pKC5YqAhg1Cs
 JdOAMqFwO4G07RUoBp6rf1Egp1Cy99fVqb1C4QTTM9mDkO9wxHFmM5jGoqvDFAp7QCvU2cXr6GF
 xF/7CvZ9/6+KURVxHwgCCOUkN19CGmsoAw6C67EQPZY74IQbSO7Z1anyY12dZMYBSV1G54ML/e+
 GeVvlG2WIXkdbKFnxIVROSHWWUU8TKRglr9rMChB1wEU/Mpx24mcik9Jsqc4Q7aKx3GO9ARc3qN
 U8FeJw+XqsSiUdQbk9lSiuqeH4qEiQqxWy9RrnX3MH0x3gbN0alJqScxg4Bed0oKtDnuGmaBhbF
 CEWi222KH5OXxJAW57g==
X-Authority-Analysis: v=2.4 cv=ULLt2ify c=1 sm=1 tr=0 ts=6a5607d5 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=qit2iCtTFQkLgVSMPQTB:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=YJRZzWe3zzYL1BDS6CoA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-14_02,2026-07-10_01,2025-10-01_01

In the format 1 path, the virtual port is located on ha->vp_list while
holding vport_slock, but the lock is dropped before vp is used:
qla_update_host_map() is called and VP_IDX_ACQUIRED/REGISTER_FC4_NEEDED/
REGISTER_FDMI_NEEDED are set on vp. No reference is taken across that
window, so a concurrent qla24xx_deallocate_vp_id() can tear the vport
down and free it, leading to a use-after-free.

Take a vport reference (vref_count) under vport_slock when the matching
vp is found, and drop it after the last use of vp. qla24xx_deallocate_vp_id()
waits for vref_count to reach zero before unlinking and freeing the vport,
so the pointer stays valid. This matches the reference idiom already used
by the other ha->vp_list traversals.

Fixes: 2c3dfe3f6ad8 ("[SCSI] qla2xxx: add support for NPIV")
Cc: stable@vger.kernel.org
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 59023492c5a9..ba4a4764de1f 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -4267,6 +4267,7 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha, void *pkt)
 			list_for_each_entry(vp, &ha->vp_list, list) {
 				if (vp_idx == vp->vp_idx) {
 					found = 1;
+					atomic_inc(&vp->vref_count);
 					break;
 				}
 			}
@@ -4284,6 +4285,8 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha, void *pkt)
 			set_bit(VP_IDX_ACQUIRED, &vp->vp_flags);
 			set_bit(REGISTER_FC4_NEEDED, &vp->dpc_flags);
 			set_bit(REGISTER_FDMI_NEEDED, &vp->dpc_flags);
+
+			atomic_dec(&vp->vref_count);
 		}
 		set_bit(VP_DPC_NEEDED, &vha->dpc_flags);
 		qla2xxx_wake_dpc(vha);
-- 
2.47.3

