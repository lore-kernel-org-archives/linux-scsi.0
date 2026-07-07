Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6F963101CE
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 05:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783403851; cv=none; b=c87g1x1SWAQXrq8QE+d/shOWBZHu5zUBTrlcgvMuHsllnqUG8ka8cA2HuAblQVWA5NEGqNPhLDbWU5EqKd+vJ0Zv+1U/RUhKxRegCNGSkXscDaf5tBQEoSc4nzkA1gSdKZfkLHWNUTbt6vBVuwrIkktIoFvlDbKHtY2kdcnK4jU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783403851; c=relaxed/simple;
	bh=bth8I2vlzrUu5pK8kyAsedcGMv4TPY/iMgbiqbUl65c=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t3Oh/2QkD/mGjXjY9ShxQRP07bUdVlb6E9Sf3nce2Omz0Pxjb/KC8aFSGqX2YpppA8QVW7TZ1PEitwil/sYDgsoeVXG1BjCT9fqyC3zXG6MCJil9W3nO3gszWrz5DWhpVSSJH27qRyB/rNBI3+3fj9Z9bE8Uh3nOo5lvM3Kv+/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=KyUU69PG; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="KyUU69PG"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66748itb1619388;
	Mon, 6 Jul 2026 22:57:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=c
	E6ElIxdMYvwan2KbOePrnoPyWuboL7zOXzLZnV7jrE=; b=KyUU69PGM99iup+l1
	102Mg9ehC7Htut9nfmHn/Vpzd9tsYnwm6ZDl4FBUBcU567DslvD4yYRyEEwvCQO+
	zpGlnBZELFB3uOMfzr85QtLJUqTc0r2NDv2O0rApGLvssn1SMz7feIRds2EXY5yd
	ItWk4DoPMHHArDeMpz8sZ9P9WzCbGqj6ROIb9IPW0v9kmHdQGLbmvg7WtjCYuoBv
	tEcbmMk46P+RPvs6x0TdzhxFivc+odDawX7SSYGj10nFx9XNW5rwlK81R5nhz8hd
	9a0dLmY8JMDfKgkZJwEw4/FYyifORf6iGouVUr7XN/nCNsejNYHdSrvdUXOaeGRa
	UB0Lw==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4f8p31gqke-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Jul 2026 22:57:26 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 6 Jul 2026 22:57:25 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 6 Jul 2026 22:57:25 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 77FFC3F7066;
	Mon,  6 Jul 2026 22:57:23 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v3 50/88] scsi: qla2xxx: Hold vport reference in qla24xx_report_id_acquisition()
Date: Tue, 7 Jul 2026 11:23:57 +0530
Message-ID: <20260707055435.2680300-51-njavali@marvell.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfXxjApSK18hvnv
 p6RP9ddYxeLLBy8ovFgb74R0xsfAqCg10aIToH1RXwyatYicqUo0SAo6/qK5PUuSIBlAuI32Vu2
 e7OqllBxMLafG6A6Pw/EhbD/Dx/wrhk=
X-Proofpoint-GUID: q2thaC4mW8LLByaka58y1HO5XEL8ICcQ
X-Proofpoint-ORIG-GUID: q2thaC4mW8LLByaka58y1HO5XEL8ICcQ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfX+Db2G9tR9ZEm
 7LE+f+FLJhUvqBnFO/kF0YrWN/vPwqKjcFJOWzbwggww72sBT/e1wjlmCLlfrzNPM9VC/Pk3td5
 F4M0LIq72vIVvsEfYe1hfnS3I9UzhIvCqGdiTVpUXuPEVJ2ewIpefR0SPuiMDkgdnmtmGzeefeF
 Lr/N/lR4lpILaNqJb/GdgIFDM13Gk/Em1Gn8HyxyQSByDPRggpqnJqovq7+AoNMTDiyIvEuOWkf
 Sy/wVnejYJ6q2zYlfn+jTfhWOyGIU7rD8JjzKIsBHA8Dt1XuwztCvfJHJ1Hc8Sarh1rBRkgC+92
 0Ootfgq3vz/Duq159evOKZGxg6tO8NwfpWCmWSmyFWv+mv+BKbul2dGBoZAa86eWfLeC89m2gxc
 hry1C9t2ngyja+HhIDh07T2tzIiOr0qocu4QLJB6E3KhlSXLScIvCrSm9v5OEMAwikFoFUYtU84
 bgBGKj1Ot0x5GfhVm+Q==
X-Authority-Analysis: v=2.4 cv=c5ubhx9l c=1 sm=1 tr=0 ts=6a4c9546 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=EAYMVhzMl8SCOHhVQcBL:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=YJRZzWe3zzYL1BDS6CoA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_01,2026-07-06_02,2025-10-01_01

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

