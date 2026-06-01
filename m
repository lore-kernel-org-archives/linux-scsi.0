Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75EBC39A07B
	for <linux-scsi@vger.kernel.org>; Mon,  1 Jun 2026 10:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780309804; cv=none; b=mym4PMXnZ9Jb8C7E2w3Do0EYrOHawnZnkqElMcQrA8SlOvt6gA9nXrONbkl2Lrv1FPKH9kWd7fnqxNhZWkmzGlLsWUfanqmNSdJLoHPycuoAzN8t0sNipLk6OhZAWnDI61jJz9+Lp6jWBqKq4veLTBIfB36PPnXQvbwPzEWiyH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780309804; c=relaxed/simple;
	bh=J4vPBQ3dHjspD4RLmEGuTc4xdqWfqYbnNByeBYLCByY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AgztWH4IiGEhb9CzX23REjbHWaOYQlOPKcgywyxHzwm3ToQjX+xLoTIzM8dI4gnV2Pxl/AoSGQAgzVMElqsOGxGxij+4WogGIde3rFJuiKhOJDqJJQO0vUsf9/CjN17REWNJ07WSXIg71nnkQBJ2nQM4IGpYh3+JNk3Hq/9x1iQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=RCtbB5yW; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="RCtbB5yW"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6510rPb42995274;
	Mon, 1 Jun 2026 03:30:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=U
	yfbPr4FT19V1mx71US63DmFV76DjTRzB4vq8tDT3Xk=; b=RCtbB5yWebopJptE3
	QYXkFC912QZDCRABDTMbO4QM3VrQNaCFRrcdmjp2T69r0xEIcIqiwOuoCqYLSxmK
	NTrxF1rCB06PiRWFT46LM9B6oshQTcZUQyxLnHEFqS+htK+pr7GbeLyEax0k/dj7
	Iiwmbn+8uB9MhTWacREabfdXDq2ua5Q1zgmh4Bb9dGWiin/JrKiofC5PTMeJRzN0
	H6fbG7gFgYOvRnvMVBAD/ZOVAaDa9A8RtmVYbuqSH17DtzTO/C1hgU9G7spUZdH6
	AO9Oh4A7g60wDrCWPO9JuDttK8fr85XUjeELL8Kw1L4zfQXRuebs6yhUfv2Tawlo
	YKQvA==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4egm56jyce-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Jun 2026 03:29:59 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 1 Jun 2026 03:29:59 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 1 Jun 2026 03:29:59 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id A9DE13F7054;
	Mon,  1 Jun 2026 03:29:56 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH 14/44] scsi: qla2xxx: Skip image-set-valid attribute for 29xx
Date: Mon, 1 Jun 2026 15:58:23 +0530
Message-ID: <20260601102853.328426-15-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260601102853.328426-1-njavali@marvell.com>
References: <20260601102853.328426-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: H21-h_uUIWTBX5aEMjKDhBgBbC9PwDUA
X-Proofpoint-ORIG-GUID: H21-h_uUIWTBX5aEMjKDhBgBbC9PwDUA
X-Authority-Analysis: v=2.4 cv=ZeYt8MVA c=1 sm=1 tr=0 ts=6a1d5f27 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=TtqV-g6YmW1Jfm2GSLaY:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=PjqBlKwVE8k9D4kk4N4A:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAxMDEwNSBTYWx0ZWRfX4u9odwwS5seG
 ANdrREjZ8UFd6u8NYTbCkD+6AeuZzqw2kR237opiEtziGmATRS6031QdACKmETiOpIlLMAFVtCA
 byQNrsuZkcIYQloLGIrHKI65pbcxmAtwaxd318tiYph7JtHtqW2r9xVpWCiUW+3OEbVzRWePKM7
 V2R0ayYjq9/13jUdN09uOmvFZtgONRCowZ6fqRbBJPW58KSsnsSBoWoR3ZXJ2IWSu+dY6MucTMC
 1GOHnXI2MYk2yMQLcY3MtY0ssrLOqzk1ql42GJvA2P0Is3PjgOnqZ7R8DkSbo82aTx9WOhVS8gy
 WtI1pOB4q3BVweU2FFb6IekcTmvCHs++sAv0uhaf+hW805OVsfPEMoJ6ZmWYth966tBeBAA1934
 C7SBb9rlgn+vNZRk/n4tllKbvCrkgXTMZrixqAVXQQNZvRL+PrsmKkAqzeWfKzj1GF5C4czS0Ti
 49NOLrotAUAoh31MtIw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-01_03,2026-05-28_03,2025-10-01_01

The 29xx adapter does not support the QLA_IMG_SET_VALID_SUPPORT
driver attribute.  Gate the attribute behind an IS_QLA29XX()
check so that userspace applications querying driver capabilities
via BSG receive accurate information.

Cc: stable@vger.kernel.org
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_bsg.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 5f7ba5c54cb1..733e0921ecef 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -2881,11 +2881,14 @@ qla2x00_get_flash_image_status(struct bsg_job *bsg_job)
 static int
 qla2x00_get_drv_attr(struct bsg_job *bsg_job)
 {
+	scsi_qla_host_t *vha = shost_priv(fc_bsg_to_shost(bsg_job));
 	struct qla_drv_attr drv_attr;
 	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
+	struct qla_hw_data *ha = vha->hw;
 
 	memset(&drv_attr, 0, sizeof(struct qla_drv_attr));
-	drv_attr.ext_attributes |= QLA_IMG_SET_VALID_SUPPORT;
+	if (!IS_QLA29XX(ha))
+		drv_attr.ext_attributes |= QLA_IMG_SET_VALID_SUPPORT;
 
 
 	sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
-- 
2.47.3

