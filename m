Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B64A81DFFB
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 05:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784783107; cv=none; b=FO09nLdeYawzVSVPhMq7Txnn1+fqYmyfYpN+/ydnVYJLXy3Mm4hMlgUWmn8FCSBFtpT+c0x4W0QJ2Mv9S9wr3imgyf1vT6tqTrkDIAF3oaVgBX5UAqWLzlENRxwARAZFUpTaxpqO8iC992k+h3AZ2BbKjwpJ9BfM/pVSbSGrMZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784783107; c=relaxed/simple;
	bh=BVRcHXOOBMCjH+4SweKu1+g3HgvRR6LaO5KfPe6Gdd8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EEPZPra+p0XbeQmsq06JvN6AEzxVyBePbKeyCqyqLxk2DxBVf4onFWgrlQh9+tBmo+3YtCmsUNUgAo4e5wI4Fwr6sR8nctbnOE+ihkLGDphvocFUbHoFJ7x9GJUIGGzqp/MxxYuZ7Y7evu5nmr5QQ//I02xXx98XJViyZG8wDuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=UsYWEje7; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="UsYWEje7"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66N4vkCo2441525;
	Wed, 22 Jul 2026 22:05:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=Q
	jL8xR4/6wjSUiH377/4+vBEvzulE1+VevbRbzj5hhE=; b=UsYWEje7lhbnnUjNi
	8puU6X9SfOyOYmjL2FuK2aWFPY/5JxVLOfbYzUabAtxvfiZSuUxwjLs1NgwCA5Xh
	yLgFAdtN4pxnotKTmuWdA3xBmVnjFOZwr2HZDo8ArU7T427uN+BDJDTSO93b+A7W
	q/pyMf5X0TI9W614npopY68I5oIMpzKVW2YX9JRYmIP5ggvRLYOiCUG8+vlLm8gb
	ZAKsVM7JItCduINKxFOXqKsytyzsT5U5UGIoDR8Jc73qMuK8oliLHQLNwyQwLvZx
	9iVcJ2a5mfaasWfhSNZKdmszJHNz8WRNSVH1YrQoETzyh26a9oweNj3EuuGBmsxb
	o2vyA==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4fk7jkrm0u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Jul 2026 22:05:02 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 22 Jul 2026 22:05:01 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Wed, 22 Jul 2026 22:05:01 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 29DC75C68E8;
	Wed, 22 Jul 2026 22:04:58 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v6 12/56] scsi: qla2xxx: Skip image-set-valid attribute for 29xx
Date: Thu, 23 Jul 2026 10:33:29 +0530
Message-ID: <20260723050413.3897522-13-njavali@marvell.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDA0OSBTYWx0ZWRfX52O2e0Nl8pyz
 j5EYJFlVp5nTmd+oI/HKyTeS2IrZau3/hw8V6Gr4b+FixAgHwAfBtKkI2LEl/JPe+Al3HJVGzai
 792Zq9nkfD+Cwh0f5eDRaINJgBJCYMnBbjFvv51GUyAZ8po+8OGR3uvarhX5sVmZcH/zxvGHgFL
 Pd/WeyXYDJuXb/XMC2wCdSefVYDQc3aA7WjJENVzn8InyZgX4bPv8mjj4ThR6wLF2K8iUMzha5R
 7c9LmN4Ys/PzVYm6p4WwVXWGy74DWYnw1kQHWGUcovhUpsT5jU1PQ1IWAmAFj8OcjDcoV0wW9OF
 cOHO2C4IcwaxvRXhd5i5aBhWEXAwMvnXZi+oeh47ndk30WH1rGO4ZTVrXVAFAjHCL/w7pAmQO9B
 2WvBmAPwb/OusLsI17i7RlA6ur5fCXbKgmAJGcYfi5+uBXUECOzGLBYJK3ZonmnuzjnYs/qRQBa
 bxkb4KLIbrWNBuT7qjw==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDA0OSBTYWx0ZWRfX2lUk1/GsXx4s
 3wBzKeg6c2k2jEamv+wnfAGSdmocmXAYLpycfwU3Al7yg6OEKjfREdsv9kP093JwHTKU6dsNic2
 EM74j0fMHCtfaelcBb8WwzY3EasSuMY=
X-Proofpoint-GUID: qy3-tA9OOw1yh2GSLzgRrTpmn5-dnndj
X-Proofpoint-ORIG-GUID: qy3-tA9OOw1yh2GSLzgRrTpmn5-dnndj
X-Authority-Analysis: v=2.4 cv=Zrzd7d7G c=1 sm=1 tr=0 ts=6a61a0fe cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=EAYMVhzMl8SCOHhVQcBL:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=PjqBlKwVE8k9D4kk4N4A:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_02,2026-07-22_02,2025-10-01_01

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
index 8cad9a046ad9..3187909759a0 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -2966,11 +2966,14 @@ qla2x00_get_flash_image_status(struct bsg_job *bsg_job)
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

