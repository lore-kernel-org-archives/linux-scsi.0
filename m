Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBA211CAA78
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 05:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783403833; cv=none; b=UAuu59MjPy+8xtv7AUch4J6YqozR9poTv2y795uf2ARTqEP7Fm4XjhiY23AeOJuEosoAj+GvN5+s/zJ2WTIIOBLUzJGh49xmNqVvZAgxNGmJ/9Kmf1pAGyAINJikBKCzLmbRH7UwxALv1U7IoSuM58v1NTXoZKToNERtACSSFO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783403833; c=relaxed/simple;
	bh=SjXzWtcDt9OoYMtfBSgnjCi0jMHn25c1hRjpPsSVBIA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u22DNP2MRZkpJ3qg9A7/mSE3PsUgN4LvZfifJw2EZ+h5kHjdT7DVoDg86YTwwQPSpvJ/KdkhKoSl885WBNHMGg+jwL7W12nBUscKsRAcFC2zsGTFrgx4cQF6P+yxREDvVgrSFH2v2YkXlktaEDetYY8lj0FTo+5C5sDUV8eFuWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=NaOil0dQ; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="NaOil0dQ"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 667482Ga872799;
	Mon, 6 Jul 2026 22:57:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=7
	lNBOpd0qmXgvHGByy2wPK3qD43UeOs3DeOlDxEoTg8=; b=NaOil0dQ33uF/R5H+
	COuQ1ncHxCfpbKt0sdStlZU4HQ8nQ1pRWNAxSV+wp5iB3hFNE+ZGo8uQXRusLuxR
	IXzDS2KvQDSc0FvFbrLKD1VBq239BR+rNCAr0YUKUto3WSmuVIwhm64DzG2znJSS
	v4lb/AqtDS+pgN/pa25nPXZDmRuOW7yKGbHImKM9xsIhsWkVOVOjYYR44V1Nfu7d
	he0tAApD0VbqCVxVLLVAACZRuAjSDfIiUMBiXOvKazlWRW34ljHE/mC9Sr8ARMkH
	P6MXRLzEt68IJt0FWYqYQHB0hnUNBfFcO++TqDUR0DB2Fpv38sRfZfo2yannJj6G
	cWGmw==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4f8f9waa55-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Jul 2026 22:57:08 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 6 Jul 2026 22:57:08 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 6 Jul 2026 22:57:08 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 9424E3F7068;
	Mon,  6 Jul 2026 22:57:05 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v3 44/88] scsi: qla2xxx: Add 64G/128G port speed setting support
Date: Tue, 7 Jul 2026 11:23:51 +0530
Message-ID: <20260707055435.2680300-45-njavali@marvell.com>
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
X-Proofpoint-ORIG-GUID: X6xrsOxjSxPD_zdmuq-CVXvT7lK_55BZ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfX0EVcI/5JWouA
 lEN9N1Q7BFagTSofxqtsw5lMyUxs8OCa5YzDjsd33uqC2+p/KqcLgjS1tc9LIaeGzGpyvWdlAlj
 r3MojHanOY0rTIO0DwtL4cFdlgKY4yWDIxjeZ+bVRbg+sOuhTftGs7EjZmzwuY/PvPSs6bN44PZ
 pbF3u2Gp61Y4aMnuH2GPwMTws+YaGmsYB8VeqKSrHxSQYYOf3SkcFHPSjKknIJLaBSUgZ6QN8Di
 yWgyyMd7PfJLxlZ9zn0e2EHuHnXMJOy9DxVc+smylj0LG2WU4Aw8lVCQd867zo+JUyyEIWPvY6D
 ZNoz12FKa3qTSH2r+KkUS5hnX6gECNYUoK/K7Lv4CmEQb8JNxIg22Ki8JHhlyKHlWmX9l9hlroP
 C8ZPuCkND/mHk/tJFWEsy/IdVCdlbxTEFS1a2SnX/1rmucdgRWVH0Ku+ldAKmSZX3I0G/aMsm/b
 sSXAvDHCD3xSMu9qi/Q==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfX9veeZujjNW3w
 Qpd5WGvLTToxyFGDbbIgDAQPkZeE0l9XqXLS/+q9Ajsocy5Qoun9yhRCei+ZI8Z5cMQ/GFa4sR8
 lI20vvB48phzSiEwDak0LByhSYwdkRY=
X-Proofpoint-GUID: X6xrsOxjSxPD_zdmuq-CVXvT7lK_55BZ
X-Authority-Analysis: v=2.4 cv=SY/HsPRu c=1 sm=1 tr=0 ts=6a4c9534 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=qit2iCtTFQkLgVSMPQTB:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=7PhB5BXe-91c5wGr4VEA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_01,2026-07-06_02,2025-10-01_01

The port speed setting paths topped out at 32G: qla2x00_port_speed_store()
only mapped sysfs inputs up to 32 (and their no-loss-of-sync forms up to
320), and qla2x00_set_data_rate() only accepted PORT_SPEED_AUTO/4/8/16/32
in its switch.  A user request for 64G or 128G therefore hit the default
arm and was silently downgraded to auto-negotiation.

Map the 64 and 128 sysfs inputs (and their /10 no-loss-of-sync forms 640
and 1280) to PORT_SPEED_64GB and PORT_SPEED_128GB, and accept those
values in qla2x00_set_data_rate().  The firmware validates the requested
rate against the adapter's actual capability.

Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/qla2xxx/qla_attr.c | 8 +++++++-
 drivers/scsi/qla2xxx/qla_mbx.c  | 2 ++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 6cf74f8c9628..3b24e8a5e29b 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1835,7 +1835,7 @@ qla2x00_port_speed_store(struct device *dev, struct device_attribute *attr,
 		return rval;
 	speed = type;
 	if (type == 40 || type == 80 || type == 160 ||
-	    type == 320) {
+	    type == 320 || type == 640 || type == 1280) {
 		ql_dbg(ql_dbg_user, vha, 0x70d9,
 		    "Setting will be affected after a loss of sync\n");
 		type = type/10;
@@ -1860,6 +1860,12 @@ qla2x00_port_speed_store(struct device *dev, struct device_attribute *attr,
 	case 32:
 		ha->set_data_rate = PORT_SPEED_32GB;
 		break;
+	case 64:
+		ha->set_data_rate = PORT_SPEED_64GB;
+		break;
+	case 128:
+		ha->set_data_rate = PORT_SPEED_128GB;
+		break;
 	default:
 		ql_log(ql_log_warn, vha, 0x1199,
 		    "Unrecognized speed setting:%lx. Setting Autoneg\n",
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index d0894cc90470..ba822c196894 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -5720,6 +5720,8 @@ qla2x00_set_data_rate(scsi_qla_host_t *vha, uint16_t mode)
 	case PORT_SPEED_8GB:
 	case PORT_SPEED_16GB:
 	case PORT_SPEED_32GB:
+	case PORT_SPEED_64GB:
+	case PORT_SPEED_128GB:
 		val = ha->set_data_rate;
 		break;
 	default:
-- 
2.47.3

