Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB68E33DED9
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 05:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783403741; cv=none; b=N8Cr1gURCIUM8ve7zTwsmYdCVVhfjynDIeR+amZGMMEuwsdzk4OBREuV/Pe5TEIy3XWG/2+3HxtqlpC4ShR+4Mjvsc41zFHuRzgsHI+vtaP4pDmYpFgOf4FDvclKKrmuwBTR7cKwG6wk977MVzYJ6QvzzzwD8+lvWZ+qoH8efeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783403741; c=relaxed/simple;
	bh=8HGtM6iTtc2c6uUlJfqgVnpkfVXju9gDP3Jm62V/huk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gnPqnni5YKOsaJfdNfzKzO2lRVapiUCxcO5W77afq+r/NRtrDbhcty9T8rZK6Y7qxwVkKYwLh/ObHa80u+SvGvQIjdlIoGlamRlMBUnGBgI9vbUft/pcR182ZtK2dpJ1tyNqG4hSlnqWfRYVpOQsaUlIXbQ9vA3jCaj13IoJ38I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=VjtFbAUi; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="VjtFbAUi"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66748kVr1656479;
	Mon, 6 Jul 2026 22:55:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=k
	CbG6SZVeLItbZyEKgK+TdBy0myqo/wUMcvNXjTacR0=; b=VjtFbAUif7io90nif
	0nhYUo8YOtMRhkC1V+slnDkQ7w4ErXb8rmf9A7mAkbInosxuuuF+Kwu9hr1CuYsQ
	+syKBOCCqTInOKVoef9uut6dykBLKIp22fwrkGbI7H5Bs8CJacQgRKQWU4bOBUB7
	mA1R/OMjNNJfEa4dh2G70tWDggVHnUHNH5YzsOaQ2UH0LN3YoNxPMIJg+NC6OLrP
	PWT8IPzcxt0tJ5NoezLB8gBsl2cGLsaLNGgvif24K6grzxQEhBHdlMK0AXxPGl3K
	wPmsScZyOGkRzeke4uYS69kTKmOHoL7zsP+Nh9HwGioM7E1K0JMLtnXRR9VD/tRR
	2JmJw==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4f71phqdty-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Jul 2026 22:55:36 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 6 Jul 2026 22:55:36 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 6 Jul 2026 22:55:36 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id BB0443F7067;
	Mon,  6 Jul 2026 22:55:33 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v3 12/88] scsi: qla2xxx: Skip image-set-valid attribute for 29xx
Date: Tue, 7 Jul 2026 11:23:19 +0530
Message-ID: <20260707055435.2680300-13-njavali@marvell.com>
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
X-Proofpoint-GUID: 4FHIALB8C6SDWSKqVLqyDNdx-iyU5Gcc
X-Authority-Analysis: v=2.4 cv=Hf4kiCE8 c=1 sm=1 tr=0 ts=6a4c94d8 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=QXcCYyLzdtTjyudCfB6f:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=PjqBlKwVE8k9D4kk4N4A:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: 4FHIALB8C6SDWSKqVLqyDNdx-iyU5Gcc
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA3MDA1MyBTYWx0ZWRfX+nb2q6u8w377
 aMhUsEY5hddxP87rgxT8VzQKzS5HBSbcmjTcBy8rarLGdFF+aRh7dBvhxM6WMo0dJDyQ6tCtT4j
 pAEzENKJjC32PyUl48Bh2T+Szti6trY=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA3MDA1MyBTYWx0ZWRfX05DKGcNC9PU8
 beOhiqaNP7H1kXWZFBIkgzUHYhz2yOZyLYmK4PbQH5R7lmO0zQNdhtgIUQZ/giZELni0KL0Qjt+
 I/ClrpMQG5S0Rz7ieeiq1LGhfJbDyfsOvi8raDFXs7PjQGzP2uOAvfGQIUiBQQ/TPAFfz0aV32T
 +CKoVXO5YqDg7UgViO4U3iFKKUFKYJSh3qqK+AJOFUCvQVlI0L9A7DpO/vgtOlpfGIulQtY76N6
 lHMRz8T0wjGkEHkm+wxiORj0tvNqjjnzxIf550N/iOhhRv9Qt3N7NrbGyru4lh9QU/ow4EAel8B
 TLt1RNc2jqoXyAYokVJmYGXlc2Hv9jGbEC7jlhNiTGdZSzwy2CewAgUGJeARf88+4Q3azxOmk3w
 lcpaaxzSQjPcheDZHDMDyw+SKKdf8sKTWn1q1+Y30ivQ2n3hLt9KoW0X3yTxHJzzKx2haCb//6w
 e4F624J8/jp4PXql7kA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_01,2026-07-06_02,2025-10-01_01

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
index 5c6aedb3179a..8a969174a261 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -2952,11 +2952,14 @@ qla2x00_get_flash_image_status(struct bsg_job *bsg_job)
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

