Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8252379993
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 09:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784022890; cv=none; b=MDPV1277wYDRfa6utwNlfjzXdS2sWt2bOI2aGO72PWkMWiCwT4sL1eQADgvdUnG/XPxVoUZmCNG86ceehN4whYyu0f4b5FLbnjvfKMkZViFo4Wrc/zimSobJA6er73YatiPq8mQKrLIWfQ12yFJEcgIMS+Vkwa4vc0XCUK4jD9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784022890; c=relaxed/simple;
	bh=6TlOK+WuJ0DmM4eTFSM+0l4G5YslW3ViXsAw0rizPP0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dWrjiRtV6KkEH6wkkBtPYATrDzh06xuEK/6r/jUSXyotuIlcsqudEDiVjSvVg6Lv1TFox6pUHz8q4mcB2NwQm5n56qGAq7Jp55JCeSdYqLv0tIDF9gOg9uOJ1voKer26gpHBvRjO/HRy0kaALCmDLk2Ii63QxQvtrgEZIMV4jy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=HytziIwq; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="HytziIwq"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66E6UkqV3693372;
	Tue, 14 Jul 2026 02:54:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=o
	2s7MIvBLh7ttQtlSwYOQPF3KySfHCp1VvAbEc5+nAA=; b=HytziIwqBbLczxHSV
	0iAmsFuvYj27z1Oh7h0SFYlcQr9KLpFbN/lenjum686ZwpW5eIHC3BdzzDkPoBOW
	SvxtQFXUxR/QlHHXJyh7ituWUnXzGJESeww0UTlZbYC1hN9Wnbw1wQBWtKH10o2a
	aSwBPeZa0pVMtf64OuSkJ/XOoF0Wc/lfHWAaMKJH+y3DoTIDekUXVkVg7+8pQP6n
	34ocQboOXk5Q9EW7LGXTyVz5DiLt0Uf8Ff9UoXbNahHwAjYk/IEILqXEqnGPxzeL
	YN9LXqAsl40AvbYPuKs8pNTg+CTE92TMaqnLujImhh2/+HWB35r+5S3LY+J4JeDM
	G4xAA==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4fbnbey8h4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Jul 2026 02:54:44 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 14 Jul 2026 02:54:43 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Tue, 14 Jul 2026 02:54:43 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id DAD9A5E6868;
	Tue, 14 Jul 2026 02:54:40 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v4 12/56] scsi: qla2xxx: Skip image-set-valid attribute for 29xx
Date: Tue, 14 Jul 2026 15:23:09 +0530
Message-ID: <20260714095353.289460-13-njavali@marvell.com>
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
X-Proofpoint-GUID: CY6RmMGcqkBCUUEWZRw5TsqhJ2_zkOS9
X-Authority-Analysis: v=2.4 cv=WOdPmHsR c=1 sm=1 tr=0 ts=6a560764 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=QXcCYyLzdtTjyudCfB6f:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=PjqBlKwVE8k9D4kk4N4A:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: CY6RmMGcqkBCUUEWZRw5TsqhJ2_zkOS9
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE0MDEwMyBTYWx0ZWRfX4oebqc7Vi78p
 b0GopDIKV0WYLoRg1vMIN0Q+l3XWb1ZkkzRMKMViKnkYfx66HwGIqUArY8omWVHVGGgORQwKcZ0
 s7EfkMOaxNAgZEswO0Sj1BkC1xG3Lbg=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE0MDEwMyBTYWx0ZWRfX6dg+lTQ14iV2
 VasWLEDV4R4BKirySosnGfb5iX6zhQwPZkCrP/Gy1KY6/f1jEI5dbfZnsgespq5ENDJvLwGP1U9
 deega5ovYdqFJ4c/A7JQ569cxm/Mf4aQI7EMsqAzP0qV93IS5AeNBr5CYykPGQ5tlEcrf0NLuf7
 c+WvZPYmGLPWMPcfiqSFzWoyUrHP7wboNeMgKQzhP4OkoU42NZSMvghC4rSScF/iwzyeBM5LSzw
 cLqItmaGUX0Jjr9ZUgU8U7XXQxUFpXsJZSd4BQx0INi1lKMvjaoqe2z0REmKygOkzD14qk5EhmF
 zDFHp0yPybJFqdyfd058vbI+7R/ozy0HSQHWZiYqxAQC0gRVB5uyVcCi0Rd4zaVlATnYC1Vc2uW
 pTZq7NbFPUypWuzY4t+WpCbBcgqY4DzesLNhRcK56pGcg8E7bbwRGzUTZyr3YXPcXbKYRfGegPI
 KUoYGqqZjceEQ9voR0A==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-14_02,2026-07-10_01,2025-10-01_01

The 29xx adapter does not support the QLA_IMG_SET_VALID_SUPPORT
driver attribute.  Gate the attribute behind an IS_QLA29XX()
check so that userspace applications querying driver capabilities
via BSG receive accurate information.

Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/qla2xxx/qla_bsg.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 5dd7e5e969ab..46eed5df7eef 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -3018,11 +3018,14 @@ qla2x00_get_flash_image_status(struct bsg_job *bsg_job)
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

