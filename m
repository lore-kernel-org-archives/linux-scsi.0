Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AB14481BD
	for <linux-scsi@vger.kernel.org>; Tue, 27 Feb 2024 16:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709052115; cv=none; b=HIIl0VClbaf+CHwxcxpOz2AN6efcgyBK+EYNlM8Z82JBYDyouK7DzIUdaqT2719TgpvHig3676z+A434VNhLLRlKlnHvvebWZGfZf2B4+XA53LTiDWDgMaFQL6K/8EqhBvY91MDlwWs8SqyCMqmC8iSYvzNEFo0JjAU1vn06fRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709052115; c=relaxed/simple;
	bh=2SV8yhk9a0EyvKAlsPMIixvEDx2v2NlwFahcRaQxqaY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oKBZeQ1LgsFcZNUppc+omeaAjPJjTK9903X/k9Ha6bWuece8jahtlrhfteLPiNB9xRy5kz1y/txO7DEDbWl+LqUxn0DEwc5Q4SN3UNAf+Vjy04Isd3uFCXyf5p81GHM0vFW6bt2BPz4DBOGexlhernP9YhQ1niWgaGvhWMEpk1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=Sw5+vTJY; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="Sw5+vTJY"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 41RG2Yrj023996;
	Tue, 27 Feb 2024 08:41:51 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding:content-type; s=
	pfpt0220; bh=aaxsmp3O9vWv+8sDyUmfWNWenCnkNSSKpzM0KDMVhps=; b=Sw5
	+vTJYG+8iv4lDohJVGGi03QYpdake6piMZsDSwRSfkGn2cdDbeWpwxf0qbryqNDe
	8Z5GiGB14zsDPdJvgsGzOZc5VR3go2kjm8vozEgPtq54dKo1BqZE/io2bqUdpwms
	VUTVXMk35PYm3Ka6+nT4K0XLP4VVP6qIkqIO55bBjEPFrdc05K7Vm/VUo+TE65pN
	iFy2pRnGYUx+eAJv9Mr5AZN4xjuTN/wtqNQBmxhZ3uXEkRcDBZFfJOJ1kscYcHAi
	3q++gEOWlsP1STtg3dQzrCqXLvGWsO60qzj/5epRMys3ZO4d0j/VhO7UzGy9iyi6
	c6qkT9lR0aVp+QMLm8A==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3whjwdg5xe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 27 Feb 2024 08:41:51 -0800 (PST)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.12; Tue, 27 Feb 2024 08:41:49 -0800
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1258.12 via Frontend
 Transport; Tue, 27 Feb 2024 08:41:49 -0800
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.187])
	by maili.marvell.com (Postfix) with ESMTP id 2031D3F7099;
	Tue, 27 Feb 2024 08:41:46 -0800 (PST)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>, <emilne@redhat.com>,
        <jmeneghi@redhat.com>
Subject: [PATCH v2 04/11] qla2xxx: Update manufacturer detail
Date: Tue, 27 Feb 2024 22:11:20 +0530
Message-ID: <20240227164127.36465-5-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20240227164127.36465-1-njavali@marvell.com>
References: <20240227164127.36465-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: v1FTb41tXSbFTTrpOOSNC3EdoAdinXoF
X-Proofpoint-ORIG-GUID: v1FTb41tXSbFTTrpOOSNC3EdoAdinXoF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-27_03,2024-02-27_01,2023-05-22_02

From: Bikash Hazarika <bhazarika@marvell.com>

Update manufacturer detail from "Marvell Semiconductor, Inc."
to "Marvell".

Cc: stable@vger.kernel.org
Signed-off-by: Bikash Hazarika <bhazarika@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/qla2xxx/qla_def.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index deb642607deb..2f49baf131e2 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -82,7 +82,7 @@ typedef union {
 #include "qla_nvme.h"
 #define QLA2XXX_DRIVER_NAME	"qla2xxx"
 #define QLA2XXX_APIDEV		"ql2xapidev"
-#define QLA2XXX_MANUFACTURER	"Marvell Semiconductor, Inc."
+#define QLA2XXX_MANUFACTURER	"Marvell"
 
 /*
  * We have MAILBOX_REGISTER_COUNT sized arrays in a few places,
-- 
2.23.1

