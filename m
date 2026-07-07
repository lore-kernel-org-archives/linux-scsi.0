Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15113386C31
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 05:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783403766; cv=none; b=m/WvmKMkovFYOGr/XUfaEWX4pmBvv3cT46SJSPv3kTExQKNCQVnA5Hb0i7TbXomyky38Sg27nptaniHQXdJlA/nYdSwlcRIZz+CfmRfu2Yrxb9x+u1jFBu7uF8YoUgo7dyy5K/f8MltFWtKOy9d1WXpWvi8xPeINMa/St9azqOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783403766; c=relaxed/simple;
	bh=Xfy9uLdNjUEc2nD+QPUu0NBTmq/9tt9lpIVRGQG/4pA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XwYCMKHpqaT9wTO9UTqEYvSFJ+fCkNzyoJGVvA39a7mINp2KO6D4Ki33YrEHGvduYdDeWQ8E5K2ai7Zm8HeO/fgsEdu5q+8AF8LbV1sHJcbgJeNapnbDMdlwMpxECs7o4iSZGd2Ct6lyL3LSp1ZlnMg6w7p+XMqTqRlLMd6hzOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=avV7Sy+n; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="avV7Sy+n"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66748VkR873616;
	Mon, 6 Jul 2026 22:56:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=g
	IlgUz5/LX1h9XgPYAlGT4HN+RslK3jts+4+taAZt88=; b=avV7Sy+nPtHSXr3wm
	B4R6hkBzkcCTdLQPHyx6SIjTuqedeoIreK3q4oyIMAGHVzwy0/o4sbvBATznMWEu
	IhyQMRLupWdyLgaD4TJv5k0GcRfJMz7S/Uc18dch+wKtxjl+wkCV6W+/DDlB2Crc
	JANnrF/kwMdHNffOdfxQSPlAbcqVmAcJsIRmRCel9Zy7cDOQuCBTXmzXgMM1C4E9
	gtCbwbrallVFHVVwsL36YtRJfT+eVl5hCi8opbhGXKOee1n3Qg9LeVl172Em4J1v
	9ak1m4wYDXocIoGKVUc6lsBccRUya4ikNteRsfY7aRgBtylPGtlHjA8ZS1lWVQjD
	UF6yA==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4f8f9waa1r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Jul 2026 22:56:02 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 6 Jul 2026 22:56:02 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 6 Jul 2026 22:56:02 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 7533B3F7066;
	Mon,  6 Jul 2026 22:55:59 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v3 21/88] scsi: qla2xxx: Add support for QLA29XX in data rate functions
Date: Tue, 7 Jul 2026 11:23:28 +0530
Message-ID: <20260707055435.2680300-22-njavali@marvell.com>
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
X-Proofpoint-ORIG-GUID: noLxHjxkNoD7-OtM_olE4FuSJ_ZjLAS-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfX8zVXaszE1yEk
 kOOE8m7JiLHaNB2F63JEl9qOzdtBm/yrACApDAPM6DriHzpveVzJf3vKSSlBbHUr/WI/dQqAzG2
 ++bt2M7CV+LpTYW/Ahd76Y11rfLYC8vT/9it0VS1Y3bixZ1je2pnvvSqvIDWjw4Ti2/cd8DMwmN
 +kzODN49k43ChtPxR25YhwzjLyVtbYYKi+Ag1yj/EOk9l9nuEyS1S3+cWrI4cbuJZVTbUR/qoKN
 WznS29/yIm7UdBs0BMS3/4An8cIsJ5lPtz5BsVKQ+6CQD+YQjnUqTQc6XdQgtyJcGEv32qVRPWZ
 bNt6dWSSn8FA9EsP05+VGPPcD6vF13ooMUILx70+eymeYpGVywiOEh8P6hcsfBV/fwsTXQ/p/Ri
 TKN7HovtYC8gecFBaJQZFuWZnKh+FP4ytlOq0qBCxXKeUp8udqqKzdDQGFgXIeBJZufLLFl9vFe
 /+/ZN053uqpQ1GZKjqA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfX3ZmeTzPdN4Js
 p/ZAnaJwp7rIdZ2dyiec1aWKfhZ4DTCsZZlAlVkJAsTwpn/q6kn7SuuH7By+nGJ8sT3cGSvByWO
 xrFSNBwumGk7h0bKPkkrPRRAeMc20ss=
X-Proofpoint-GUID: noLxHjxkNoD7-OtM_olE4FuSJ_ZjLAS-
X-Authority-Analysis: v=2.4 cv=SY/HsPRu c=1 sm=1 tr=0 ts=6a4c94f2 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=qit2iCtTFQkLgVSMPQTB:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=5V5adwN8R4nwDDm8v28A:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_01,2026-07-06_02,2025-10-01_01

Enhance the qla2x00_set_data_rate and qla2x00_get_data_rate
functions to include checks for the QLA29XX series adapters.
This modification ensures that the mailbox commands are correctly
configured for the 29xx series, improving functionality and
compatibility.

Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/qla2xxx/qla_attr.c | 2 +-
 drivers/scsi/qla2xxx/qla_mbx.c  | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 5a934f40323e..c32930f9e9f9 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1824,7 +1824,7 @@ qla2x00_port_speed_store(struct device *dev, struct device_attribute *attr,
 	int mode = QLA_SET_DATA_RATE_LR;
 	struct qla_hw_data *ha = vha->hw;
 
-	if (!IS_QLA27XX(ha) && !IS_QLA28XX(ha)) {
+	if (!IS_QLA27XX(ha) && !IS_QLA28XX(ha) && !IS_QLA29XX(ha)) {
 		ql_log(ql_log_warn, vha, 0x70d8,
 		    "Speed setting not supported \n");
 		return -EINVAL;
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index a8dd01cb9a9a..c073dc35ef8e 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -5683,7 +5683,7 @@ qla2x00_set_data_rate(scsi_qla_host_t *vha, uint16_t mode)
 
 	mcp->out_mb = MBX_2|MBX_1|MBX_0;
 	mcp->in_mb = MBX_2|MBX_1|MBX_0;
-	if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha))
+	if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha) || IS_QLA29XX(ha))
 		mcp->in_mb |= MBX_4|MBX_3;
 	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
@@ -5721,7 +5721,7 @@ qla2x00_get_data_rate(scsi_qla_host_t *vha)
 	mcp->mb[1] = QLA_GET_DATA_RATE;
 	mcp->out_mb = MBX_1|MBX_0;
 	mcp->in_mb = MBX_2|MBX_1|MBX_0;
-	if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha))
+	if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha) || IS_QLA29XX(ha))
 		mcp->in_mb |= MBX_4|MBX_3;
 	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
@@ -5733,7 +5733,7 @@ qla2x00_get_data_rate(scsi_qla_host_t *vha)
 		if (mcp->mb[1] != 0x7)
 			ha->link_data_rate = mcp->mb[1];
 
-		if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
+		if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha) || IS_QLA29XX(ha)) {
 			if (mcp->mb[4] & BIT_0)
 				ql_log(ql_log_info, vha, 0x11a2,
 				    "FEC=enabled (data rate).\n");
-- 
2.47.3

