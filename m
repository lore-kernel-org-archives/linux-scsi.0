Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B660013AA2D
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 15:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784302310; cv=none; b=Uz3z6loOkUKLJCF7vi8tGhYCs0ou7VHzis4y7LxTU9QIBxZVMqevypBsqXPIAXoAX6yMluRMaEllkLfAm5irciJrQxWYpOzo7BreBfRdScjQWO3362aaVJxRhjEut6IjHVO5qQzNrr4upCtbUeJVuI7+Si40koDn/fUqdJn0TOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784302310; c=relaxed/simple;
	bh=zR0yUnQDhhWSxNCr1D4AkeeIMg5LLbRUV8PtLDX+DhQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LvcpX8/2krHalS4Z+n9U/JA/hbPAOG9cJJZzxaQEkLDkNPHUfnLgYVS8onj5W2hzbT33hjl1xwW70n8pcPTzFGKu0+68MoCEGOg0GynH8spkbgB5R21nNxeK0VWmMgammDaWwwgEVTTYkOv/0rtZ/JfoqW+uQTlXNXQE4UEGPLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=VbhHOHiS; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="VbhHOHiS"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66HE7jLS094486;
	Fri, 17 Jul 2026 08:31:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=6
	INSyIOV543cVNlh2oZ6+qZm8Vam+bSmW5hLNLEcKf8=; b=VbhHOHiSQ5uJnmc8B
	IOge83Z5WT/o+9JE1DvOXcgKOlhYSRGk3w7TbXG+e2R4xSgtozVq/2A8C+uRm8ne
	Ft1cvK63qZGTPNwiXtaDr+obS5k09yKNjE3Qxc+p1uU/xW+l+lSFGdGTzJ9QPMfg
	/kOrFUn44Fs47RP4sajh6Mdu4z89tGGnNkjcKqxsqTfodnVcniTKHu19xrAznmXj
	xRWBOeUTFtuQxF0HpV+1F2bYTEQSXhluVkCp7invmWSeRPLLcdvXbkGcrxYxGRky
	W6OXJrLIurmQDNMHVrXMUBqVuzPM+t641ZoWnzx5msDQeYseCT8yV18RibsRagLp
	uKVxw==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4ffhg8rxkd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jul 2026 08:31:45 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 17 Jul 2026 08:31:44 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 17 Jul 2026 08:31:44 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 7E6655B693B;
	Fri, 17 Jul 2026 08:31:42 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v5 55/56] scsi: qla2xxx: Bound image count in qla2x00_update_fru_versions()
Date: Fri, 17 Jul 2026 20:59:03 +0530
Message-ID: <20260717152904.3155730-56-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260717152904.3155730-1-njavali@marvell.com>
References: <20260717152904.3155730-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: L_vzlu8aqn8quyKDRhXILbELKGmUKl-Y
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE3MDE1OCBTYWx0ZWRfX0jBXJ4IfGTsS
 ICBTpGc5Y/OVwUUn6YqoZH1HeH0mHcGIT+qeBqXVZCvVu2N7zbk+JdJ5s9JoU8u7NBEOxoS7F7X
 ogKpNk57+hSeAoPKkrzxrJhPJnjKoNA=
X-Authority-Analysis: v=2.4 cv=SpKgLvO0 c=1 sm=1 tr=0 ts=6a5a4ae1 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=EAYMVhzMl8SCOHhVQcBL:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=494MX3Unkl1U6TuN3o0A:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE3MDE1OCBTYWx0ZWRfX3DI+ILHLu0Ql
 PyNb49ZTEE+IucJcTgt+rWUopCaTRx1XCCQJ0pRAu1rrwsMvgIMi6dIATRFhbLYcF9Rsk7nsgbC
 PMA38MjprAv/+MX47FXwKTplcSNuU6zgzLQmxDlBuaUcLZo5EGA6gaN6cA+R2SUKUrKZT4KlXw6
 rd5fyhiiXg6Td1oahP5xyWBvxSz1HDIIzwJIKKForbd/LbksNUzhpCPnV6wxJoHVxj3HTp5Yx4I
 R0dDzcY4ZiJJ8fEbXs4xK/wTewMrVaD+lxJfIhK+aZvjxgVnEfTR4wPGE1bP/7borF4x5toK0e0
 ubDXzWvx24BYAmhqxN64bQRQ2mrq1gmiAay5Fp/o1NQ3OA2BzGOUJkUThkZmKW+P1KlF4OFhLtH
 7atiwPRhyDrd9HunZTp2nr4jWDuwU3EnD0ofoUa8nJELGXIUOd2n66f34P8cskdgoDCVGbWBD1q
 hYRMqkFz+Z8qvHMO5CA==
X-Proofpoint-ORIG-GUID: L_vzlu8aqn8quyKDRhXILbELKGmUKl-Y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-17_04,2026-07-17_01,2025-10-01_01

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
index 2f73c9af418d..95cfdb020319 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -2043,6 +2043,13 @@ qla2x00_update_fru_versions(struct bsg_job *bsg_job)
 
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

