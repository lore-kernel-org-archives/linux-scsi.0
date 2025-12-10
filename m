Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E50FF30BF59
	for <linux-scsi@vger.kernel.org>; Wed, 10 Dec 2025 10:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765361791; cv=none; b=Xp1bkjmghVzkYjIcKKZHkZBg/gLZtI5SsXoynWGEDPWwbYJe8b195Hvv9+mDfqJ2WXcNBEgYze63xid4CqDjsgeIkKv0LeLy2OOicfdLb/hRg27ca92venz6hnT6ZGCckeV4ZEzErxeMbEYkL2EiIvBTZHlrB8/WPpFOyNn+9AE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765361791; c=relaxed/simple;
	bh=A+kcgW+7ocnhpYDb7Ur9tPk95CGaUK/Ted7wMxeTJ7k=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m3dLovBwhBJdUZAIOcvZCJRW/pY/5rwInScX/Dsk+/+vOL9XdgZ1hkxvqd1I7vEpT3x2gTEznyMzZLVn8ABdzE/0bJSlggOY0lXmLL8QiLFIs9vM5g8lxlBMsW7cV+tpr3VDlOsxGgzlScIZNUpDKaMzwoEK0S8V9HUN1Zqe+vA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=ItURtiWD; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="ItURtiWD"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BA4aPlP164398;
	Wed, 10 Dec 2025 02:16:22 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=J
	cWqJlSwV0r2jSpNNYlgU9Hgrb7dO1SKnZavLVuZzu4=; b=ItURtiWDB5THEoFG1
	wQ/ZIBb2vgcPXvTlFH8Cb4MexGpBJ1uc5GHlwgbXRrpVq3UKcchY6fpAIG+zhWDC
	q5A+5/vJn9UmsVzPTrW40Ouqzq+MSyMxGN07Pqk2fgLYvtAHScIk8qIoxt4PW+65
	E8atOZK3SVsQjrJ8jI78I716zXrdtmsKcyieC0GsImoqLBipjH5B5Zgt1KsDlZq1
	id3t/yGs0JYiJyTJUGB6XGXXDNdmGJxnZ0C8L3tcqwld63oLnuGMGHct5Z+7v6vY
	STQq4ntRdsxTTlUQGSMv+5jGSxXk3g4FzgotcNCDqkHIfJmInO7w1/tN2KCpbwAf
	hDJaA==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4axwgd167u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Dec 2025 02:16:22 -0800 (PST)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 10 Dec 2025 02:16:34 -0800
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Wed, 10 Dec 2025 02:16:34 -0800
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id A1EF03F709D;
	Wed, 10 Dec 2025 02:16:18 -0800 (PST)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>, <emilne@redhat.com>,
        <jmeneghi@redhat.com>
Subject: [PATCH v3 01/12] qla2xxx: Add Speed in SFP print information
Date: Wed, 10 Dec 2025 15:45:53 +0530
Message-ID: <20251210101604.431868-2-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20251210101604.431868-1-njavali@marvell.com>
References: <20251210101604.431868-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: Robedgu4iLDaI8HREMyEUcT8ZpHd0FIR
X-Proofpoint-GUID: Robedgu4iLDaI8HREMyEUcT8ZpHd0FIR
X-Authority-Analysis: v=2.4 cv=OIcqHCaB c=1 sm=1 tr=0 ts=69394876 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=M5GUcnROAAAA:8 a=pGLkceISAAAA:8
 a=DIr9iR-pfdiJ7R9a4dgA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjEwMDA4NSBTYWx0ZWRfX174kxLg4/s92
 uTdsJOFh2pdtblz7BOgfGz01FHcWm+4c6WEKJ80CdPlsJe2h/5lLfyw1jkDls+3Blcg2hk0xNgb
 0jrXrDNXgs6i9lqrwbnFPO8c2ZJJKkvr6DrLVq042cOHeBRrnfgZlmqYFtyfbqcssZl+fGuTfFf
 rX31AUb3Li1sRciz0Uujs2yeVYSkV6Hr2vkCDcG7aqp3NJ4EQGq0Pyk4g/rMABeYm2yPMh7GxSy
 zOlU9ZgJxCHHMdTV94c5iahk5YMDGjVY4FfInnxt/RMz4PyBkZ+VaxpOlTJFOWM2ArIn3vCqPw2
 nohRyEe5plFsf75DE7nNV5cSRRfSfYF/vBG+Lgcdn7O/u5mlcRo/x9TJ/dhEOJQRVM3dcwYPc/i
 vaHbW0MkLa1xEhvMZs26x1/wntWwCQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-09_05,2025-12-09_03,2025-10-01_01

From: Himanshu Madhani <hmadhani@marvell.com>

Print additional information about the speed
while displaying SFP information.

Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <hmadhani2024@gmail.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 6a2e1c7fd125..66eeee84be05 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -4074,6 +4074,20 @@ static void qla2xxx_print_sfp_info(struct scsi_qla_host *vha)
 	u8 str[STR_LEN], *ptr, p;
 	int leftover, len;
 
+	ql_dbg(ql_dbg_init, vha, 0x015a,
+	    "SFP: %.*s -> %.*s ->%s%s%s%s%s%s\n",
+	    (int)sizeof(a0->vendor_name), a0->vendor_name,
+	    (int)sizeof(a0->vendor_pn), a0->vendor_pn,
+	    a0->fc_sp_cc10 & FC_SP_32 ? " 32G" : "",
+	    a0->fc_sp_cc10 & FC_SP_16 ? " 16G" : "",
+	    a0->fc_sp_cc10 & FC_SP_8  ?  " 8G" : "",
+	    a0->fc_sp_cc10 & FC_SP_4  ?  " 4G" : "",
+	    a0->fc_sp_cc10 & FC_SP_2  ?  " 2G" : "",
+	    a0->fc_sp_cc10 & FC_SP_1  ?  " 1G" : "");
+
+	if (!(ql2xextended_error_logging & ql_dbg_verbose))
+		return;
+
 	memset(str, 0, STR_LEN);
 	snprintf(str, SFF_VEN_NAME_LEN+1, a0->vendor_name);
 	ql_dbg(ql_dbg_init, vha, 0x015a,
-- 
2.23.1

