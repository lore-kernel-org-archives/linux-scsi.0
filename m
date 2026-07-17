Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E46E03043CF
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 15:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784302191; cv=none; b=gehPmsw1it9eo6JUuP88liTjdRU5dYh0LZ3bVmDe9b4JhqTArkozid7Y4CkVFnG84zbm27eIF+V35dfEjsAr7IZcqEJX3U71AWZr/gfHwaLxIG+QsmOO7Mv6QD5ohZws3vN+6Sn8jYUQCdS01yc50xwWN94c/TO4PBiZdthQ3nE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784302191; c=relaxed/simple;
	bh=6TlOK+WuJ0DmM4eTFSM+0l4G5YslW3ViXsAw0rizPP0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lvAIxgsZ3ivZha7Ed1IdHz+w7TpJ8IREhdZcveGJH6nGXxrWr21zwZXSyjPmTO/nedKGg6ieBvp+hpw6x7bYjDsDlzNPa0CiQDWc/Jn5dFZm3JP5/d26yzsqFLBMIDwcnrBemU8Mf7w0EFiKl0eoXO43RNNOZIA5vOEpPOf6Dyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=gKY8ujEG; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="gKY8ujEG"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66HE4Ugs2774314;
	Fri, 17 Jul 2026 08:29:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=o
	2s7MIvBLh7ttQtlSwYOQPF3KySfHCp1VvAbEc5+nAA=; b=gKY8ujEGfpZAx8VT+
	B2XRV7M3pIEz39I2lN5UX0RXPulA7XL4PUbULJCxGF6DR9hP/+q1se2EoKSOsdFh
	nkE49PQHpYvA0ymOoHY4Y2I0Mg78hvNj9xn6RHHqjtTJWEtLGt8YhnFHVjzpWj5i
	9YwZsTnworIZ9FwaIoc3JsWpEpdymUbjxDoELcGgYA9ioloiLa4NsQ7eEBFa9oc3
	UN1A4ESkq9gksvVC6NeFwy42x1UsWedLlpKM1oeAt/YqQWyM+qAqZI93HiJhviTP
	POiwOweEkX5Gi0G3LgeQ+IV1OUx/7m7w/uMMIQRgpM4/pEX2RrSsSDqHet8duD6W
	mlv7A==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4ffm6p0ha4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jul 2026 08:29:47 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 17 Jul 2026 08:29:46 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 17 Jul 2026 08:29:46 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 1AF095B693D;
	Fri, 17 Jul 2026 08:29:43 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v5 12/56] scsi: qla2xxx: Skip image-set-valid attribute for 29xx
Date: Fri, 17 Jul 2026 20:58:20 +0530
Message-ID: <20260717152904.3155730-13-njavali@marvell.com>
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
X-Proofpoint-GUID: KsWe3htBOYr4oH_rEjubeGy0XKYBcOU4
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE3MDE1OCBTYWx0ZWRfX8lOLZJ3a5aaE
 9oVnIDFs6OGYnEnksR2qPXKUeQD3++ucNTGGkFI+xa+GjNIJlDqc7PKNXBJVHrdWqN6rDobzGdp
 IiLaDXcUPK38llLv2Ib7u7k0FzdxLOE=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE3MDE1OCBTYWx0ZWRfXwm4zlVCGk4SU
 wTlWfoqZNr9AzPWdKllO0xQZcWwrSGYhOYinKRItX9MGkM7miSuZCAXSoTJZbECzwKNX/6rVbdK
 Zfl1agsfBevHrX9OSacxZ/z3wawUptNKuhw9LePdWqmYrCUmiHobrTfU8doe7nyDPwR/6lUiFxR
 MdE0oxk3ct0X1rpeTxvIdVn+vNDu/CrBDLgmx0drkJg0COyxSI6IEJtt6L2ygXDrV7iKGsbjdfp
 z5fu5+zpW262TCn0j/bKUweGl9OnxsiDRGNgo4DnCIoReQmVIKEv1cGoSuj4WcAPDBmRALqusfA
 ML2y+3vT1QxP3OQh+KUSPUOdqHV2ZGBhKDNhqXoKYBiOWyY1bKNmfu71O8XPFFR6dOSw2UvUqmm
 qqrIY6vzwWt9QtIBrgYkFZ35ccXquPZuM+mxumSMYtfSWq5M2UmM6tUj5wMGlLQXHt+iVVSUld1
 TnjkVYvv2Tv2uncWlhw==
X-Authority-Analysis: v=2.4 cv=Wa88rUhX c=1 sm=1 tr=0 ts=6a5a4a6b cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=qit2iCtTFQkLgVSMPQTB:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=PjqBlKwVE8k9D4kk4N4A:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: KsWe3htBOYr4oH_rEjubeGy0XKYBcOU4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-17_04,2026-07-17_01,2025-10-01_01

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

