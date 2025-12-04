Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A34C27FD74
	for <linux-scsi@vger.kernel.org>; Thu,  4 Dec 2025 15:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764861491; cv=none; b=l1VxSc3nLkItx8+Nz8TsZeMAW3xJCtpL5baPfOAhF1FGCQDnwWXCbsiF0PYYaynS6dbRgKijsjYKoKldeRL+BQReTq+5k0ozMtPe4vN66m3Ksu2t25sYUI5GzzYcX1hbzwtymtSBmhfN8LeK4/CNYjo5crJZUY4cxR9+vyp8i5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764861491; c=relaxed/simple;
	bh=A+kcgW+7ocnhpYDb7Ur9tPk95CGaUK/Ted7wMxeTJ7k=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HIeQc29LtcaZ362kmarvw2JfAAQipdDZte0gmlag1IsNXkEcLRHEJvl2LjeWqbENSIY4fBa5WkVFFDSPKlG0Gy6g651t/zZ3qhsEaMhDtnybXMTX1w0ppUr+4t3NmBTUT7eWXa8NUwksBdj+tEh9c9iV8UvAszNK2ljhijXDxXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=EhoebZDn; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="EhoebZDn"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B48H3PC1156182;
	Thu, 4 Dec 2025 07:18:02 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=J
	cWqJlSwV0r2jSpNNYlgU9Hgrb7dO1SKnZavLVuZzu4=; b=EhoebZDncZ7vcybaR
	QIQwGii5H5BCs7NuOMBRiaLBju4syiAXQc971X/abnsfDrDqdBDlCbU3MMLeLJpY
	VmtdSjyltWlRF2VE4epPeNMTH+eehNOVwzP6mzZZffYXmJ3YLSnb8BM7E77oafNa
	tmGPflgvOJYrN8byiYr2+WpyJJ9ZSlydIMmjczSYELYC7OogaCnCIsger5aDaX0+
	xXusgJQHq8TyiH+18wE+HLNLYSPZNn8Me15nzr0nEoZNKWs/gAX6UkJcYBvbHheY
	he/3LiKY3AdTYSAYa05Ok9VIQHYqGA/fgEl/as0WLRV4zAz+ysYAvqLcfqCqKu4C
	LOzRQ==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4au6n18tfw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 04 Dec 2025 07:18:01 -0800 (PST)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 4 Dec 2025 07:18:13 -0800
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Thu, 4 Dec 2025 07:18:13 -0800
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id A654C3F7074;
	Thu,  4 Dec 2025 07:17:58 -0800 (PST)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>, <emilne@redhat.com>,
        <jmeneghi@redhat.com>
Subject: [PATCH v2 01/12] qla2xxx: Add Speed in SFP print information
Date: Thu, 4 Dec 2025 20:47:40 +0530
Message-ID: <20251204151751.2321801-2-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20251204151751.2321801-1-njavali@marvell.com>
References: <20251204151751.2321801-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: urbSPtgO6xOxMjPLe0B6VDaAXlhIsXdS
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjA0MDEyMyBTYWx0ZWRfX5KQ40rYLZeK8
 RQC/O1i+XMXj5ZqSYh/s1S3bTi+QgMw09eLxLCf/GDLKVO7AJNhzYmW0WY38M19Asf7h4+qw7ZT
 y3PYdzfeMpT/qaevCE1kJnby9oTPTVFK3i/MDT8AaL/r6HoBoNEpuFJ8ij59yU4x+5YI/rV5eWh
 PqXIK6g/svmE8gybDBtx6WTZA1WoxLwfgKGPBGaZ3HvAo8Y3rpOHCoK1BwuTTyBC8CX6MPl9nf5
 vzUMfWU3LEt+LKpVQ3mQYp+vyHJKrwpLyY8rkum8caooDBgbxwAbRQC+Bkl4Z+mz3hklrF4UKht
 LBVuS0oOcLOEi9WzV/qSv19kYYSHwHSpmBC8n3OgpClhhfyuWStYyzvEbHnL48v5j3J11Tgv4+k
 1CVDBFPmj6Pu/1KQUrcPRX4Ad5QVZA==
X-Authority-Analysis: v=2.4 cv=b/O/I9Gx c=1 sm=1 tr=0 ts=6931a629 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=M5GUcnROAAAA:8 a=pGLkceISAAAA:8
 a=DIr9iR-pfdiJ7R9a4dgA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-GUID: urbSPtgO6xOxMjPLe0B6VDaAXlhIsXdS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-04_03,2025-12-04_01,2025-10-01_01

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

