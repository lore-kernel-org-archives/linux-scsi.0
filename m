Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBF3B175A9F
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 15:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784302297; cv=none; b=r4R1fXJ2c1/vt4cxuA8yzec/md3P3Mv1z6vwCW7uaPFB27Z4+lXPhFlnyrxlmpfd9uo/1l6siY1Pg3m/uqbTzk2vCvEmK9WoM5LjVQvT+v4QPCsZkxFYzbvNTCNhqSyiYl2YvDjMyzAZw3sc+TG4ote4OjzD4tYGlpciAwRRmx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784302297; c=relaxed/simple;
	bh=bth8I2vlzrUu5pK8kyAsedcGMv4TPY/iMgbiqbUl65c=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nSkyjkot6BTaR/5sRbkTfuBisbv3fovuGy3LHV8h8XD+4E85CkOGelN+V7AvxT7P+xGzKXBDxRxuO5aLVbhaRUSCsUoQeMrkq9tV9HkqIavsyXVRRjeX+1gDZKqUeB7ElvrdM56ueQAZ32gkUHRYUqLq7I1g7casm+n3tHEefK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=OyzXGAol; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="OyzXGAol"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66HE4VXd2774323;
	Fri, 17 Jul 2026 08:31:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=c
	E6ElIxdMYvwan2KbOePrnoPyWuboL7zOXzLZnV7jrE=; b=OyzXGAolexXsLiT0W
	BZzbEtp6GR2vS5z1ksHa3XZAByZOgZUVX52H+KJCNUsOEkoFoOJupq0tUKc5/JBP
	9AoUArln/xXPFgcn0rb7pOoGf5xq8YEinZiR+MQsiTIi9JdswJefHKgtZBVJMb0S
	nyftbxP6TU2NQ08C+1zBVyq1X3IZsDrU8Ej3qCziZSLCn07scEftwbBg5DaxtT/c
	MBaqlf8+MCFopXJk6KbOT2KRd+7ovaCPoslDDqaK1U20oHcdKFDP0KUExuSH1Yjy
	aBzQ3smOYJ2ZoImvICU752dtcpspUpyigibbs0mSRJx+zGN7VjsEOWwfDO6hjOay
	w3vRg==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4ffm6p0hj0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jul 2026 08:31:32 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 17 Jul 2026 08:31:31 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 17 Jul 2026 08:31:31 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 9D7105B693D;
	Fri, 17 Jul 2026 08:31:27 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v5 50/56] scsi: qla2xxx: Hold vport reference in qla24xx_report_id_acquisition()
Date: Fri, 17 Jul 2026 20:58:58 +0530
Message-ID: <20260717152904.3155730-51-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260717152904.3155730-1-njavali@marvell.com>
References: <20260717152904.3155730-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: wBrvegQEfiVhEHQ7LFDlLObDegMTgIcp
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE3MDE1OCBTYWx0ZWRfX4z1m3WYS9AHu
 EAU5JigTDZJsjBmzQVu/tdd555w9JuDm7N1/qAwuzCswByQ43HUbXjTtqsohs37Ix0x/pJanO+j
 nxJm5LxriQAUq36hq9lVOEKoVPFMud4=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE3MDE1OCBTYWx0ZWRfXyaYSAkYjeI0X
 WBV74aMzbc77oUGpJcQJT7D9FIZyuFjNKd8TMD1d1/0u1DLg4agFHl7uTkD5/tS7PiH0dYaBQ7f
 RlNf4Hbb9VLbeqJQuWv9XNup1fvX1Q7Qx+7uR+45r0qoZL07cdjQ0250CJK8RA/AYzMxvxOVPQf
 q1Xidvr62uI+9Mo6i1VnfgIPYOmGlw4X2CxrbbhmvVMEcoagSI8bYDuO631OYIJVVZYRlw8t4A3
 ZuU2fzrwoPGBZTLmWOspfbQiD6Jaxi8BrBdwaAQbvrbazO5J1fGHMf7OSkdhBQH0i+XiFoCC3xG
 yhQoexlWRUGZ88REqYW0sLnpqUVRyGA88M/ROzwpoMt0rl+PqtOeqeNhS+1OUx+zFzNQuaD/Tb3
 fL0T/NQpR8DbG/Fnw0Zfk/sSvAni7oW3Z/zyuk3sVvIDmM7B6pj1JEKCWTb315uiXJQmD+Uggnm
 oETCy9Xdb1IcdBzk4lQ==
X-Authority-Analysis: v=2.4 cv=Wa88rUhX c=1 sm=1 tr=0 ts=6a5a4ad4 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=qit2iCtTFQkLgVSMPQTB:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=YJRZzWe3zzYL1BDS6CoA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: wBrvegQEfiVhEHQ7LFDlLObDegMTgIcp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-17_04,2026-07-17_01,2025-10-01_01

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

