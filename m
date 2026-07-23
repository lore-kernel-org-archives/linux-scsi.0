Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ADA830DECC
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 05:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784783207; cv=none; b=IEKBrqRWGTjPT9XHe5/v1Y7ruZqyhE+z/khWUM09MpfSjpiNKueQSmlmOYM6+xf7MvLYRVzgqBHblZRyJB/+dwChhAiC26qrePDCJbtDtELr0Y5kNcbQDcOPRM+4eHwAkJOUG6zZn3Gjo3W0moAehy/H5KnUmbPONFFUEEDBZpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784783207; c=relaxed/simple;
	bh=O4sQGQU4b6fdPzFyaZTPQlMCOUzyLU24c2nhRqRW8Wo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HcofIv0QEgHxk3F/q1SE7T5w/aYhTYTLTt/D+xkbpMkLAaGD4LDGlTYLbx2k6tC8nJa3nvXCRQL2QAvh5ONzmQT/jszQgisiR1SRdK1WhpNbulztyYtepMxxL41xGtGccAkXNtig8jfrO2uH4uRS8aKjPA/QlEJNW8lL2K+DqLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=SXAYw5R3; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="SXAYw5R3"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66N4vkCv2441525;
	Wed, 22 Jul 2026 22:06:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=/
	6Cb0dgXoIC1ZIaQTn5yCtTjRGgeiWdgD+BYAFNDpYA=; b=SXAYw5R3cb7z5q4kc
	PEPlvrwtL1LrV1ov9n16kQm8vl3W7yevK733ihu4iSeq2xHhj/kJZAKZy4QCiPdz
	K54W+oZC3dvRKQ5rgwIBuPtzYK6yx899oMfcWtVIIut/xZRmFrd5/uGnq3E5N35T
	aKkL8MzwyRx6ViDgqfBFGCoptdhHbHOmeDtNWvTwvZ9CSgheWAAdScg8e2rq7qTJ
	q6tpLol3WPIMUe9hPUkPQ5TWrd1cuyV0iBWzJbhlIjGzaZobljTQqeNLIEDzUQaw
	MChneBS1RBWzIEGy/s9qIoUJlqCSfLrKJxbORaLBs/hURLpaDu4ATpbqk881coR5
	AEgng==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4fk7jkrm3v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Jul 2026 22:06:40 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 22 Jul 2026 22:06:39 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Wed, 22 Jul 2026 22:06:39 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 496975C68E6;
	Wed, 22 Jul 2026 22:06:37 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v6 45/56] scsi: qla2xxx: Fix 64G link speed reporting in get_data_rate
Date: Thu, 23 Jul 2026 10:34:02 +0530
Message-ID: <20260723050413.3897522-46-njavali@marvell.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDA0OSBTYWx0ZWRfX3eBhsOUV4wq7
 8XhdJ5izlKmbxlpxLqj229fjv4m8FztamRIbyfJJxCYE4Ba6PI5eo7REt4J13jjtfjQTAQkKcM1
 d53VBxLVNEKKy7bwkBrA7LOUn0S6qDCeZgeWiTwRTik8c/Me9EntEpNGTcy9unB+kS6JfOT7Q3S
 vP2Ri2WQ89jtfkAFYKe45Ltd1RwCzyTiTIo68bznWz8dOQ2t6IKCItgrutiuLYNNJ1dwtbIQwxV
 8/o/QNVdcXW8ZOB7FuCfEC/oEqjld8m9oTwcIxQ2ZYrKZdRXD5aC6Ar21sq8TSs9Q5y+dE5/gx/
 WSGYPAVnajlWu+qNS7Yt/u38rZOhrgNkbYmsWt38Mgp18+4PSgg80gxVPHyg7kUh4n7+53k3qRj
 F0XYX1nuWAJ8QMLiqvi1p6s9704RgpvYv3lPcJhdY8WusWJLnzTN3S79qJx9zK7moTu9SVMI21R
 hYVMBLhiTJp5zPzjNJg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDA0OSBTYWx0ZWRfX+wcAXMeKCnRI
 5Xyx2qDFMHqE57rxHTpbv3cAT3Olcvda4SXQkXi+jIj4ZPgN3XVfdDPCYihKi08l2Es0YXq0rDz
 O+6qQRToSQReoti1VWD2BIplY9WSgss=
X-Proofpoint-GUID: RGuILzltw13ofzF_BeY0viXJV73RfNE_
X-Proofpoint-ORIG-GUID: RGuILzltw13ofzF_BeY0viXJV73RfNE_
X-Authority-Analysis: v=2.4 cv=Zrzd7d7G c=1 sm=1 tr=0 ts=6a61a160 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=EAYMVhzMl8SCOHhVQcBL:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=utjVkuT23_eo-L5YqD0A:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_02,2026-07-22_02,2025-10-01_01

qla2x00_get_data_rate() skips updating ha->link_data_rate when the
firmware returns mcp->mb[1] == 0x7.  That value was a legacy sentinel
from before 64G hardware existed, but PORT_SPEED_64GB is now defined as
0x07 and ha->link_data_rate is decoded with the PORT_SPEED_* encoding.
On a 64G-capable adapter a genuine 64G link is therefore dropped, and
the port speed is misreported (port_speed sysfs, fc_host speed, FDMI).

Only 28xx and 29xx support 64G, so accept 0x07 on those adapters while
keeping the legacy filter for older ones.  Also drop the duplicate
copy of the check at the end of the success branch; it repeated the
first assignment with no intervening change.

Fixes: ecc89f25e225 ("scsi: qla2xxx: Add Device ID for ISP28XX")
Cc: stable@vger.kernel.org
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index ba822c196894..b32ca8ed274d 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -5785,10 +5785,11 @@ qla2x00_get_data_rate(scsi_qla_host_t *vha)
 		ql_dbg(ql_dbg_mbx, vha, 0x1107,
 		    "Failed=%x mb[0]=%x.\n", rval, mcp->mb[0]);
 	} else {
-		if (mcp->mb[1] != 0x7)
+		if (mcp->mb[1] != 0x7 || IS_QLA28XX(ha) || IS_QLA29XX(ha))
 			ha->link_data_rate = mcp->mb[1];
 
-		if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha) || IS_QLA29XX(ha)) {
+		if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha) ||
+		    IS_QLA29XX(ha)) {
 			if (mcp->mb[4] & BIT_0)
 				ql_log(ql_log_info, vha, 0x11a2,
 				    "FEC=enabled (data rate).\n");
@@ -5796,8 +5797,6 @@ qla2x00_get_data_rate(scsi_qla_host_t *vha)
 
 		ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x1108,
 		    "Done %s.\n", __func__);
-		if (mcp->mb[1] != 0x7)
-			ha->link_data_rate = mcp->mb[1];
 	}
 
 	return rval;
-- 
2.47.3

