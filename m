Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71B8030DEBA
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 05:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784783138; cv=none; b=c70VX3jc7NnZPYll9tUrR8WK6c44VpQW0pE+q1ituSlN5XpiDhGeD7ZwACW1BTO+OKvrrWCPqaaHYB5+8BsacDsI+Udx8OuFu5NPYNLcrC+QcIrO20ozJSa861EgJqHV/oP8WxqocuPchCedgetvYCkZk7EDZrxMZrKlLcWlY1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784783138; c=relaxed/simple;
	bh=XBweKRoe2iV+j+QDP57gNIPWkFSpzqNvh5kItWbGoY8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ty1jVXo8LoHb4jXf61uk626JBYPRmxQc5l1G2D+IlVytmV13+skmBkW9UPx1kAH4Jf4DLfevUs4ynUhDx6a1zNpZPOCdUr7/8eMg+x1Fuq4hJGoyN7nymuCYDQIjS4t8jT5N5NaB2N9Mjnd8CcRWLjfERIrPcriQ1Z/y9JPy6eU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=S4YSODDw; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="S4YSODDw"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66N4wAh92443057;
	Wed, 22 Jul 2026 22:05:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=T
	G9Rjbv/gWTuYO3pC+FOHAYqPLzfSVkpZiKVpas+3tk=; b=S4YSODDw+KDs+PX42
	aKY8S4YqDZBeuq5wGOBILflNcti36slRZZY6QHRumjjMURk/MwG0uIc+rYSQtYu8
	9/+odmXGCm3snJcINrTOo8xqySWVFZpMutvFMgoVflQvXuvrsDWVlckgGpy11Bfh
	3vr3cTPOU4fIKc+8HVTBfOw02vtlUuAdc4XaxEJPAT/HQSMglVD4/5trrEJsXvEp
	tTl411wTczUZ6hkvvMzbVkC1JQtufYSn2Ry511EwEdfc0I4eIIe+03JoG5HHiDPD
	J2k5TIUlYDIRDLwMOz245Vb2VHQFOyjoUnX9NQaP8wPrjLf6g6JE1BUpUuJZrHUu
	GV+MA==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4fk7jkrm1p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Jul 2026 22:05:31 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 22 Jul 2026 22:05:31 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Wed, 22 Jul 2026 22:05:31 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id E47095C68E6;
	Wed, 22 Jul 2026 22:05:28 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v6 22/56] scsi: qla2xxx: Enable qla2x00_shutdown for 29xx
Date: Thu, 23 Jul 2026 10:33:39 +0530
Message-ID: <20260723050413.3897522-23-njavali@marvell.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDA0OSBTYWx0ZWRfX8V1QA3YUUHo9
 b79H0f+0k6nLC0eBx30URFj4UityA6e1/cFpkpzF8SsAS+yLjhZpbLYBWO9iUHlrI2luro3me9/
 Vi2gi0SJSWOiwFxDhvXdHep/3LbCNTubL17NAdNPrskhdNPd0KJ4ldAn3yX5WppKPN5GPinXxbO
 OQWB9gOOPTOE1Pc7hM/q00GaVRjX6cbqLwpU0T976rbA9gvy7q3oldi6Jfoavjyo7l4TOKy+/7V
 wONofNamU3lLTUJRCvtHQ4hCSuX7d4q4Uk3XOzRKlVSNNkV+gr4vVEYJhlN1KnkpzIm/iwSHyY5
 xkJnS9FrEIoS3OfWHn2cpSXo2XZFcWOHg5+LKMd5PXkC5FO/XLiSkbE8ekSvqnunTXP9p+iKvpE
 vaDShLrtuSJoUIe2f5xuG0OKVQ1p7k+5eDEN5VZGQ2/1Ez/xnCnBAeHnpcKHWCi9L13eCSHG5Sh
 Yg0zQuZcao5x6yMKgbw==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDA0OSBTYWx0ZWRfXz/mZCH04NqaM
 3+D6M51kadRPBEq5cJd9cXUhsI/sPNKg3xkbr2FUhZfCSJskSEjBojMZfCoXtVDwI/hcL99mbyU
 fJYoNyA504Viq813PYKodsZCz9bOgxk=
X-Proofpoint-GUID: LVI4sSnrDo8uEhUaesF2xXet45ZFenBq
X-Proofpoint-ORIG-GUID: LVI4sSnrDo8uEhUaesF2xXet45ZFenBq
X-Authority-Analysis: v=2.4 cv=Zrzd7d7G c=1 sm=1 tr=0 ts=6a61a11b cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=EAYMVhzMl8SCOHhVQcBL:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=C3ITPKR1BmyQqgtea3sA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_02,2026-07-22_02,2025-10-01_01

Enable qla2x00_shutdown for 29xx adapter by adding IS_QLA29XX check
to the shutdown path that performs firmware abort cleanup.

Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/qla2xxx/qla_os.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 146701445485..5450c40259bf 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3840,7 +3840,7 @@ qla2x00_shutdown(struct pci_dev *pdev)
 		qla2x00_disable_eft_trace(vha);
 
 	if (IS_QLA25XX(ha) ||  IS_QLA2031(ha) || IS_QLA27XX(ha) ||
-	    IS_QLA28XX(ha)) {
+	    IS_QLA28XX(ha) || IS_QLA29XX(ha)) {
 		if (ha->flags.fw_started)
 			qla2x00_abort_isp_cleanup(vha);
 	} else {
-- 
2.47.3

