Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 454BE36655C
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 09:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781258215; cv=none; b=sWjQURRdxczz29X94S81IRks/EeRim+NP4c6pVJ5gjD3oye3caJ4lSurkwkRCB/hUw/xJ2PwDDiRFfX/ox3kPhoz3x5pbByY2PpHb9JcH/HEWKpfwm0DXRUO8BNXiI9frxC+zkVO8+NI0ZwJkzHHFomh4GmagPwrEyQYP3d6qQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781258215; c=relaxed/simple;
	bh=cXzn2LHy95JPPdPVNFESfd573b1ln5n8h+qKhcbUh1U=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZwiB8ue/nw4Z/ZTZsJTP36nMHHnXh49c9dcl4/OldenAxgAZdvfOqr4ssz32UONxMCbZB+d40qYwZmlXLO5TODvC49GnEH3AhIwjBG616LBWFoGPHlVraf8hNArmDu50BSPgVhJCEczEibgPQK0JHDzShAarca4KENgcumsw8lI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=kUbki0cY; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="kUbki0cY"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65C3AQI4071108;
	Fri, 12 Jun 2026 02:56:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=d
	eM1hftA2yU5ilTRXis+f22IqLoMNli7MU3gPkWPnYU=; b=kUbki0cYCrweJMCEk
	gWOwdgu1zHYnDYjFseJXeywecU1C7SECpqIHuK0HEHBCC2rYs/xczAkQaspmE8Az
	KETjMcNV/UvI4MsR9un8Iv6j7l+8destPaYj9LfbDqbjKLFF2MEw3l6E+A0l+wxd
	se2ZV3M9RYfNzkQ5m9hvTJoETAi0tkA4O0H5yH8KQ75oPdJZN3Wk/3hvdXoRlbs4
	69xywuwEGZJSoGUrOiNHaUlld9uGY99zm4dB0d8BnsjmFMmAbBWYkK1+k/9FoV2E
	jFSREcTYSGQ/UD0qvCb80VCJaqSgfbbbmPqNHqtxc50wENvFOnfAzuXidPdDaq2I
	qOzgA==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4eqe5vxrrv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 Jun 2026 02:56:50 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 12 Jun 2026 02:56:49 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 12 Jun 2026 02:56:49 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 077B63F7040;
	Fri, 12 Jun 2026 02:56:46 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v2 55/60] scsi: qla2xxx: Hold vport reference in qla24xx_report_id_acquisition()
Date: Fri, 12 Jun 2026 15:23:28 +0530
Message-ID: <20260612095333.1666592-56-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260612095333.1666592-1-njavali@marvell.com>
References: <20260612095333.1666592-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjEyMDA5MCBTYWx0ZWRfX1gZJ/F4jRBZz
 YdDR+cASe6yeWJ7O0ICnofSHVlLXKzg+3AGhu+cAFoSxg+ik1UutRuXcHinOM43fmztB3vqOvzz
 YPy/ciJDhqEmqM+nAOjvktviTGZ33YM=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjEyMDA5MCBTYWx0ZWRfXy70tjFXyIHBH
 bPhes5mHD5BrqKz58823Gx4wK2pY3bN2Vzcf9uH6Gnk/ZJgdumIA6MZnRuVwcsOWPJGdJ217mo1
 U6F+i3Su0vqwf5TxTNo3drfPfw3Wqps61pBpS0YkpZ/uZwb4T/uZ/AvRpl8KYkGZDC9nDqxqcOf
 FwJ62MzhtvyAF8ZPihmYnYWWukIslxS0rNpopepNK0ZCDdI4DpoVZrPb/otm+BFvo4xyVEqrAmu
 8AEw8UfarBVK/BQunS485zSdsfIYaHjivXkZzDlVAYvNIRhbPuwxnw1BS4t1sDdV/RS5uvTfkmv
 qOV3d5gSq+bflX/LmM+1XIRfFpVTz7IBgf+0GWqetnZFRxr9OuhMviAw5aVD7kraBzLu0DOuj9f
 sokWyXSnoX2aSjBEdTbTPAcENgrTvq7coy6jy7QJyld5somMxnUuTwylqHzi3qjZ6aAIvfHpI+N
 BuqRP3GkpB1h5KoJ8Jg==
X-Authority-Analysis: v=2.4 cv=UPDt2ify c=1 sm=1 tr=0 ts=6a2bd7e2 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=EAYMVhzMl8SCOHhVQcBL:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=YJRZzWe3zzYL1BDS6CoA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: FPEkc7xrrquLHugrem5A6tKI13zkt32N
X-Proofpoint-GUID: FPEkc7xrrquLHugrem5A6tKI13zkt32N
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-12_01,2026-06-11_01,2025-10-01_01

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
---
 drivers/scsi/qla2xxx/qla_mbx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 8a001b489fc0..bfb931eb14f6 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -4275,6 +4275,7 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha, void *pkt)
 			list_for_each_entry(vp, &ha->vp_list, list) {
 				if (vp_idx == vp->vp_idx) {
 					found = 1;
+					atomic_inc(&vp->vref_count);
 					break;
 				}
 			}
@@ -4292,6 +4293,8 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha, void *pkt)
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

