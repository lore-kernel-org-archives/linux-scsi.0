Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16F3337C902
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 05:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783403722; cv=none; b=jW2RBAVl9x1an/lcNvL8MdFVL2pumZVCMtGCq2OWqunR0cVDtkyGjuI/rXcQxoCMEcR9IaZKiDYeg/XkfeGCPrRJBZM/96vniAjD6tthMXZ/itkMIemw9zGflu+40obFvRgGyV7b11f8Ss+5DZm8uKxC5W9wnl8AajgnyZ034po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783403722; c=relaxed/simple;
	bh=uOgiFMTdwtVZ8U/oFutaGQDWkePj1vhsDcIEctqlGc0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sL8o1LpHmJo10yVhEaKv9tsMkgoCi9uyUo2ieBwdsAmuPLWHOepmGALBFo9rHIrOOVQsnAwHzekWG1x6nKb5XC2iu1x9zDlEuTMEqNLkDdt4TekwVoDFaDgu/4AWDUexoBynhvycp342lpgoFJOgWiDBm7PBuRW0nrVJvBsJITo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=Cpsn4d27; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="Cpsn4d27"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 667481Pi872631;
	Mon, 6 Jul 2026 22:55:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=e
	GceIkWFP5+sCcf7Rblqie67ZO+wFzIqvS2AGOw+tos=; b=Cpsn4d27aNAZ1BvG8
	46esXEPMTUsfLgBRO/eemWfohsS4UjHuMOqXhqr1qHeSyzmNZaBQyOG5Mry9tjjj
	nzSgvZ4W2LHpIbM9PsGurgTcDKB86OAZtrILH2gUlRLF6pJNG6HgXAx6U04k0bqB
	mJyPE6K71X3It7e7JW57joV4T9o2lJrWeUoQKwncedMambvH8xq+Y2aqtfR9SioV
	rS1SNVoMduRqgd0Km2GR8pw39CD5HhIixp+lXTg3blxNNEEWmxnI+mvU6qxgsrQh
	8Lw0pbiB0eDmDRWiYqadhfLRlKG8HQdf8jpQb0AdWGdZUC2q6TfGSUATmou/1oZp
	HO3ig==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4f8f9wa9ym-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Jul 2026 22:55:18 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 6 Jul 2026 22:55:17 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 6 Jul 2026 22:55:17 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id C9D383F7077;
	Mon,  6 Jul 2026 22:55:14 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v3 06/88] scsi: qla2xxx: Remove redundant VPD flash read in sysfs read path
Date: Tue, 7 Jul 2026 11:23:13 +0530
Message-ID: <20260707055435.2680300-7-njavali@marvell.com>
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
X-Proofpoint-ORIG-GUID: NDw4HCiEIZD7r6F7YxUX6N-knyxytL1H
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA3MDA1MyBTYWx0ZWRfX/J/BdPzLqQNq
 gUDaXvT+hjEhuOVodoagn6nTULkCz36lyOPnDFAZ64k7vv0UpUyPDamKB67rcEMP4aZszI6OyqM
 mDteQnu01Jm3vt5z6oudCpCdZ0qyhaErx0hBlmmE2ihPv0rgMFhFfXl9E3FuYPYz5plKG3GI4eU
 /QLBN+kKCJnSgOQsxS3/Nbhf80eP3gWVwCE4qc3U+wM5lTD87Z+stVbS2+x5+pGVCcOzYY5y/ZD
 maO9kUKnhu2cDCM2X0gbMbUstMoVYFTN1wp7NAd/4uxbul2DfyHo1XrxRaoBLf0ODUN7O0dXY2T
 1i1RFr1Wc2mePb25hFvvu3E0QOueLsLYxPXdJzWDmG13ttLz7D4aXOVhYZOq1lOtmGeqTmd3BU1
 d61Fcwu6wQMmzvBH+bpJmwLPnZ0CuNMlrBwwlqrZ4y3G1n31Nuq/yGQgIUOYJqm26VAWaWxkKsg
 UzIMgY9ipg60BadL0mQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA3MDA1MyBTYWx0ZWRfX4j3UglGu1AqH
 1MAUiOUxsN3foTsjDqU/kM+CoRBoNRxkJM3pFArxI0DWgucSFGJq7E6Fu0OfwChzgEKXkG5B+jU
 /JU47iVwaJSCCDJY18Se4CThVMinh6U=
X-Proofpoint-GUID: NDw4HCiEIZD7r6F7YxUX6N-knyxytL1H
X-Authority-Analysis: v=2.4 cv=SY/HsPRu c=1 sm=1 tr=0 ts=6a4c94c6 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=qit2iCtTFQkLgVSMPQTB:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=eVv-LjW39nYWXZrQooYA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_01,2026-07-06_02,2025-10-01_01

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

