Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46B33470EB2
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 05:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784783089; cv=none; b=CnOLFwohIFB36kwxqJdAcGCh1Gj8FGngEwdyqjlC/7wkGImQhIvaYET2Km284xQlVd9JuKBlEqTBM9keukLXFu//GBCNxF0/L4In5Q1DslrVjMdtly0pIXINcRxhbsQDt3RZ7DjL+XhJgX+6ao/HIR5VLE2TFZVz4PYh7G1NKnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784783089; c=relaxed/simple;
	bh=uOgiFMTdwtVZ8U/oFutaGQDWkePj1vhsDcIEctqlGc0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FIsvWCtEwUugzhftxdEN9N59+mqV6b9woVwm1/TmKfkEhiwbfaGjysuoMxNlXw0rLOz+IjCiKNGwgGjQ2PpfwYZ1a9CaOuk+wn10y3b5wPQpHM2mbSOht0wMUVdohLxI2eIibL1SDp9U8TeLV7pLER6Nq2Ktr9HZfB+lCxcK+l0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=M3I/mD+l; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="M3I/mD+l"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66N4w0Dw422579;
	Wed, 22 Jul 2026 22:04:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=e
	GceIkWFP5+sCcf7Rblqie67ZO+wFzIqvS2AGOw+tos=; b=M3I/mD+lInbKM8J6w
	Tdo4QSO0buLTI+ymzvfw9s/nuIUk7xEI4kIiO/JencpBSd5mmlIKnq3fcVSVWrKk
	XM+oJ0VaGO49e+cn+fseZu0+CTh4atB1FWoitUGgprhwQKA71SW1Rx4tbMKEuFQx
	ofb6jEK+8pxD28MZLn5tXZI1KMDnzfAbufu+NQNCW9z6g0vNwSKLC60a2N9vLQM7
	cKz3rrmX0gUe/MkWcxrG8coaCxpOb4mBiQtwV4NSWGXdsEN6rnXIeNmUtCESI9TV
	JvBWxrvV/S2vpAh5oC0PyrF1/C48iG64z6BoPlsoFST02XoV6APBosoXshEU6Zxl
	b95WQ==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4fjjf8c8bw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Jul 2026 22:04:43 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 22 Jul 2026 22:04:42 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Wed, 22 Jul 2026 22:04:42 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 353165C68E6;
	Wed, 22 Jul 2026 22:04:39 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v6 06/56] scsi: qla2xxx: Remove redundant VPD flash read in sysfs read path
Date: Thu, 23 Jul 2026 10:33:23 +0530
Message-ID: <20260723050413.3897522-7-njavali@marvell.com>
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
X-Proofpoint-GUID: LNZ8ATwFZ5HH1g3ynKr2xvXTbNVO5I8g
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDA0OSBTYWx0ZWRfX0IrpA7Rv2LF8
 id/0fPv4pG1xRDftk6iVkSE6vi6u2ftLwyOTqMCLfdWo33qBhSwr0dv/zXQbz0hd+CYKeAGRoIC
 a7q42DIPoo7E7/fazf+zGQm38eiRgZQ=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDA0OSBTYWx0ZWRfX+RHEJi1ugRZ2
 joFOgKd+5w9QCBoyFlVBInusqfGR5giuoKgO1isTK/dQHt68ocPCGfOqZg4zcwA3NPO4btmEtwx
 nrU3uKq+vnppIDBsJvLsGby0qZhNk2MN2m2j1qStclwwTLAZqCU7PjLhVcFeIFui4ID5EjXMoBV
 2+AjkFYzaK1l/RNpcgF9/ChbSEPEn1cAJ4AoBlPIG0PlD9OT0EoeMSPalIEfm0a9BvshncgHak0
 1jPJAio96zhaJZsdYKtdvGaZIne/KT+Tx1Wr72Q0UhTh+0hLNwnwKnrYiBYxQRlOFe1F7rtwEUr
 VDYdtNYdVgo9LdS05SH4aNIksnotadYTxtY77aCofv/opf8uYjkTO27TtIoK2+EJ34KYXUNgDll
 8S16cEOITwynNsLpG0BQODtYb0CJIeRlflF1nhkyPpGD2IHxNjVJ8G7vHuJzp77Etwu+yIun95u
 4qGKkz5dpRA0GIAuPyA==
X-Authority-Analysis: v=2.4 cv=Rov16imK c=1 sm=1 tr=0 ts=6a61a0eb cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=TtqV-g6YmW1Jfm2GSLaY:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=eVv-LjW39nYWXZrQooYA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: LNZ8ATwFZ5HH1g3ynKr2xvXTbNVO5I8g
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_02,2026-07-22_02,2025-10-01_01

From: Manish Rangankar <mrangankar@marvell.com>

qla2x00_sysfs_read_vpd() called ha->isp_ops->read_optrom() a second
time after releasing optrom_mutex. The repeated read is redundant and,
unlike the first, runs without optrom_mutex held, exposing flash access
to concurrent optrom operations. Drop the duplicate call.

Fixes: 5fa8774c7f38 ("scsi: qla2xxx: Add 28xx flash primary/secondary status/image mechanism")
Signed-off-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/qla2xxx/qla_attr.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 6a05ce195aa0..800751ab562a 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -580,7 +580,6 @@ qla2x00_sysfs_read_vpd(struct file *filp, struct kobject *kobj,
 	ha->isp_ops->read_optrom(vha, ha->vpd, faddr, ha->vpd_size);
 	mutex_unlock(&ha->optrom_mutex);
 
-	ha->isp_ops->read_optrom(vha, ha->vpd, faddr, ha->vpd_size);
 skip:
 	return memory_read_from_buffer(buf, count, &off, ha->vpd, ha->vpd_size);
 }
-- 
2.47.3

