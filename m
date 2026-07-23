Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8949D30C37C
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 05:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784783219; cv=none; b=V3zaFBH7VB+UJhvU4WqPKGFTnK1jSKu5qzKmtugcnvaJkbnbzEH12Kqu8xnJfptEKI7GXB5tSGfTOpOaUakrPW1D4XN54XazsyrB3mYw+B/ylL8+eOWQqnykTIHMMHkhhP2NIYROZh1vnU5W2OVERxFo1ojs5oLi/anqq5K86OE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784783219; c=relaxed/simple;
	bh=bth8I2vlzrUu5pK8kyAsedcGMv4TPY/iMgbiqbUl65c=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UfbnMxZr+9TaOzeBMz07fMwWOs2U9svPGXjIwarKNNdppPxTz4sQymgFFLuUtQEoMf/Qdc9mX7wv83KT1KKfgWS4U5iugpTVzKl4+/rLuI6GLNp9xV25zHhL/EK9T+uTNVt9RBNScHQ2FcrFVtmC+m3SWy65oY4pGLUJJG4y2SU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=SEmmrqIR; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="SEmmrqIR"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66N4vkD02441525;
	Wed, 22 Jul 2026 22:06:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=c
	E6ElIxdMYvwan2KbOePrnoPyWuboL7zOXzLZnV7jrE=; b=SEmmrqIRKABHFhCoL
	uM3K2NVvehCM/oB1SPXzLQY+1/StshwfkDobPSaVXx8yw5+HAjsaVfus6jiwQVj+
	7mjWV49UdJu5oiFnnBFa1zPdOx25aubEiG1wvpLePc9dubw15IHUcSZiRzxyiqa4
	DOAr2pP1MQkv3YISSQkrVDVlMAZlwcJTkvqMFegCr7xwbSXpr0vfS9rj7qfqkEl/
	QmwIZT2iPeDfaMf6ql41tdmSy4cUsYtZQI79a85dETuN7pd5LA56/tFFsqp622Yp
	NSl5tdZhCyBoAWDRmp664/raJKJ8F0ajVTqMBQcjvmVsBm2zkzf0SA+4SbbNTgPR
	Zevyg==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4fk7jkrm4c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Jul 2026 22:06:54 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 22 Jul 2026 22:06:53 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Wed, 22 Jul 2026 22:06:53 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 95D715C68E6;
	Wed, 22 Jul 2026 22:06:51 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v6 50/56] scsi: qla2xxx: Hold vport reference in qla24xx_report_id_acquisition()
Date: Thu, 23 Jul 2026 10:34:07 +0530
Message-ID: <20260723050413.3897522-51-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260723050413.3897522-1-njavali@marvell.com>
References: <20260723050413.3897522-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDA0OSBTYWx0ZWRfX4hz+/X/BKNOx
 8hV+deT+DFp8LY62mwQJD1HoMUDQec3T7etH93JXxeqy0UyjMBGHQhUYhipmecjsxo8VJSEYjGP
 XUf6QpXCh6jlTSnU/WOs824f3IdgSV0vGFtdbWnETYwU0QqyPFydS2Wl3+466lQpAXAVjgiIHN4
 nJ7UdAKLnPQeLRJGOsLTLvrExKorI6Bo950xRfXI0Lqoiotk8yb1dgeMGD+EfMiMiEEKtWlnrVs
 hMi/3kvHw83fIq1vPOx5vxvIBgV6du+zjSB3iHp0v4t1w3i6wmSv1p2b1M+exkEG7YESSFpMuCN
 SbxYyj1Rs8K9tRgTGZ+x9gRFgqfDMtHig0jo7iurpSH3VO/VL7TZcVYo53PwpjB1GIvgDa9xZIE
 pgyPoVaq3s2oTq0s83GoVIKH6ym7ea5o7BHMBqwMf4BFttt1jXLbuWTgvyzsjQvoy2YsERHYRaG
 QbM+wcShVst8DtpVKCw==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDA0OSBTYWx0ZWRfXzhfuIC93Qa7D
 EEDNBUIEp8DIbQX4PwxDhkUBajn5Di/AZKVAOGM+J7TVzpsXxYQ7gpNwF41FWvdWC2P+f6bEjF3
 DVFZF6JLq5220wtGQ+vZcrEOyNopOvE=
X-Proofpoint-GUID: 5B75f0Xoo3A5DhOwBAtPVrNdvbCkYyA6
X-Proofpoint-ORIG-GUID: 5B75f0Xoo3A5DhOwBAtPVrNdvbCkYyA6
X-Authority-Analysis: v=2.4 cv=Zrzd7d7G c=1 sm=1 tr=0 ts=6a61a16e cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=EAYMVhzMl8SCOHhVQcBL:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=YJRZzWe3zzYL1BDS6CoA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_02,2026-07-22_02,2025-10-01_01

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

