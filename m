Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F9E1326D55
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 05:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784783234; cv=none; b=aKCKN+IaT7efHwwGsU1f/lujqADmfOrAoeBmR546fKvvU3ORrYFzzz4Ctu03I9zhToDs8cfwSRY7HL5I+uO6BVJqhKk0ONZBIostAW4jTEBmgGCRxDt+9yiCQe+PcDGxKKoPsUVejzzcBwGNEoUsf8WRaGnGj71lnKKNGvopjnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784783234; c=relaxed/simple;
	bh=XSgJCV9fefYodIUvPk739N7GPSmfhXmMKV3HkJtkyB4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ByOuZ/dwwvMjreNAWjKH4TvA7X/UHSn49EtJtlrYk3Iu+EMEx//dCADG82ZxJNXiQgGMM3ay/td5yrPS/sWtEr7E5WjGXqeYWQC2fff1IxxUpilgucQBNi+CxX3mZ4DEFaAm0+FXKPZHtrLx2OrtbTEPEka3KYgiBbaDJziZS9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=doSLzQ6y; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="doSLzQ6y"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66N4w0E9422579;
	Wed, 22 Jul 2026 22:07:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=y
	zypOhXesuJA4HQKtKyZHOEh68UFLvhNyNjquJW/xOc=; b=doSLzQ6y9fxuS1ScF
	becARGLMS+IXz/rCOO4jb5JeMuIYChXsfchvoyI72YlzQU2Zh4z8TFCmtERbQZA6
	PU8JFATD9jBWecXW1KHUVmp99yJhyT904oTIG5xZtfQ7sR+/ulqdDMLwvi4E8N8X
	Yw9IHJmWWN+WmZbFv/pEUF8wzq1wWUpulmB8AFQBFPcsPGpDztWIseSLFuPpkPKQ
	vTb/V/u7zyMltdc5enKRzmfHViqGqVBkVPyk2c5iABUTGavIiq+anEQ+0Sp44B2F
	Rt5UVfveAHn8TEDpGrhS/8fxHG3LQ1cWvb1lxtIObDiorakHzKM//DcRCR7UU2AJ
	xhDGQ==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4fjjf8c8j3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Jul 2026 22:07:09 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 22 Jul 2026 22:07:08 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Wed, 22 Jul 2026 22:07:08 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 486355C68E6;
	Wed, 22 Jul 2026 22:07:06 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v6 55/56] scsi: qla2xxx: Bound image count in qla2x00_update_fru_versions()
Date: Thu, 23 Jul 2026 10:34:12 +0530
Message-ID: <20260723050413.3897522-56-njavali@marvell.com>
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
X-Proofpoint-GUID: pzUytNRFQINpeIT6ZaZuPWt8NpTXR30c
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDA0OSBTYWx0ZWRfX+5+SCx04Qxr2
 KgENFwjIu4ApRPdq6GzOvi7zI7OTfMdAMAFrSL45kVuC/VMmu9gWbbfyXA1IHrwZPqmtPYa5n9x
 1/gmyVexpIkA7NEY9UtTaBa/L0aMFqo=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDA0OSBTYWx0ZWRfX7FZe3UJ6/b/d
 6s0HVP+Ytr0hdtb3E93ROa2eiQ3UJIVbz4lGBptWIE3TpQGsJAyax5nXiQ1iBSx58FrVvGWxP+Q
 D0ivaBDwkn2+EtXNy3TduwDzMgTLXOAC44LM5ExkcI0GS1pSlT5hOkcIqDrD+LQJ3XSqOYKRycR
 59HS21HXAqswrqkArrXuRU1j4EDy+woDfUIGzckLX+qosgSnj7NRgJAj0FvmogCnp360kKZL4JK
 WZK0Az3QWFEbjNcNpcJ4yYzYPO3xjms5Xyh5P8UEQHtPWNo2udnuECErAm/PhdDzcdKWhcYRYjv
 jDTmr2xj2gOEiKtgYe2KCNjOyKxdUNU/FiaxNIRN/sluSJj9JVHYZOrsxBWFmHgh3elVHXgm0TG
 6IqSEfrNsYm1BCCREVydlwFeMYYWtAzieXBx6C2OrPA6TlyUO++GwEAcM2LX5Kq5R1iG8o3P1Vo
 M1VCib/dqASXwB+QJqg==
X-Authority-Analysis: v=2.4 cv=Rov16imK c=1 sm=1 tr=0 ts=6a61a17d cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=TtqV-g6YmW1Jfm2GSLaY:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=494MX3Unkl1U6TuN3o0A:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: pzUytNRFQINpeIT6ZaZuPWt8NpTXR30c
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_02,2026-07-22_02,2025-10-01_01

qla2x00_update_fru_versions() copies the user-supplied BSG request into
a fixed 256-byte stack buffer (bsg[DMA_POOL_SIZE]) and then iterates
list->count times over the qla_image_version array embedded in that
buffer, advancing the image pointer each iteration. count is taken
directly from user input with no upper bound, while only
(DMA_POOL_SIZE - sizeof(list->count)) / sizeof(struct qla_image_version)
= 6 entries actually fit. A larger count walks the image pointer off the
end of the stack buffer, reading adjacent kernel stack memory and
sending it to the device via qla2x00_write_sfp().

Reject requests whose declared count does not fit in the buffer.

Fixes: 697a4bc69159 ("[SCSI] qla2xxx: Provide method for updating I2C attached VPD.")
Cc: stable@vger.kernel.org
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/qla2xxx/qla_bsg.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 76c57e574c22..f9b693af8db1 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -1991,6 +1991,13 @@ qla2x00_update_fru_versions(struct bsg_job *bsg_job)
 
 	image = list->version;
 	count = list->count;
+
+	if (struct_size(list, version, count) > sizeof(bsg)) {
+		bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =
+		    EXT_STATUS_INVALID_PARAM;
+		goto dealloc;
+	}
+
 	while (count--) {
 		memcpy(sfp, &image->field_info, sizeof(image->field_info));
 		rval = qla2x00_write_sfp(vha, sfp_dma, sfp,
-- 
2.47.3

