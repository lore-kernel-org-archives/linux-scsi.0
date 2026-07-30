Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32183397943
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 16:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427236; cv=none; b=KI5KbGitZvgZRE+XO3xdb5bYwrO/tgidTvBH8fvkZdED1e9DokpGISr8kBXszLJ1OefMPIi+of9pIgBzwd30IdZgjIE6nzB6gO4nJwK3lYhVHlHHvMgwm//doDKg2N2CNpFcHma1Dr0cRAGq1SQRTxLm3dXKDD6UyypmVA99dPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427236; c=relaxed/simple;
	bh=q8j5lESoHN357HeldZpeFuopf8Ast0sr6vUe56XsWA0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TE8/tiYgNRx2vVkbWSeg3XgMnI+2v4sSucc4VAjcVKPkKJIiukPrt/vuKqeX7WA+E8O3cJib6MNlfcv/nf6IPUArdnqYo1ad8Erm3mXCgCEzibhq7KmE0y9+Qf0Bay01XmgX9wNTyMyOZ5f9MKSx4dTKNUK/Akvlt7KnwqCzvDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=i0beH3Ew; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="i0beH3Ew"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66UFV0ht1299535;
	Thu, 30 Jul 2026 09:00:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=p
	VDvu/WtOZQDePOeTE9DSMvMn1SCIjAe0MxHYFHri+E=; b=i0beH3EwDFF0jXAXp
	Lst13MJiKu7ntxd4v2mBB9VvYJxhkuu9Bc52rPpP2QyxW5gOj4OSSFKDZfb4+c8B
	z/u/hCdV4UBYBFjlfaGet6vAYSD1JaMbg6uNWfUCJ0K71YDbbRSFxBa8IY+yH6Lx
	AYMJJ56tSO7a7g1zixQfshaDp94YFhVaDFzF/RpqZOHtGqDxJbuHyBcK9R5KXRcw
	GrQla/zJ53zsRf9+VyoT5jA4f5x4DRdxirxqez5RtdvWrs8uhYHZFTeR18h9eJW3
	8vIFNftZ1zMyyIMGH9exACoLQx+FBhAIoEYBo3gvdRmG1w0qDFD4sppx/76FltCN
	P0c/A==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4fq0f08cg9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jul 2026 09:00:31 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 30 Jul 2026 09:00:31 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Thu, 30 Jul 2026 09:00:31 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id EF8093F704A;
	Thu, 30 Jul 2026 09:00:28 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH 32/33] scsi: qla2xxx: Bound i2c->length in I2C bsg handlers
Date: Thu, 30 Jul 2026 21:28:37 +0530
Message-ID: <20260730155838.2119230-33-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260730155838.2119230-1-njavali@marvell.com>
References: <20260730155838.2119230-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: iGUnI6g2HGicklEVuz5rg-m7DZjo11sP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDEyMSBTYWx0ZWRfX2Q2k6v7wSo7f
 2Tk9ClMldY7baikoIczIoY+exDLVH1iCGz4f5HtrsAL9Y4alSpV04FXdq4zLT+dKgOuRRWOZwBd
 7CSG0jd/Vd1qtUej1jCVRTjjWOUAD2naIB0BOBTxPmYVfjFx4yleBmDaVlF6VD/1Z7wSYLpZVIg
 r50TJPpsNsS+trDJhK8dya1/0fcUWztgxYd8x1tqlSlVtBk6eEEdU+YSyag0hk+YjTythhEH2kZ
 hMqlDt+AHcbV1L7kEhb9LLLiWxIQm7OBFx3qrsmXYEP+ak+4/vDH2PaUjGwRLkzxNi1Y5BOFHyR
 iu+nziElw43ZPkKikNv6q6uTjYRtqPSTLvl39l7MFSiX6Vyz0vjEZRyWSDNuRZ0eORf3u94g7UU
 xQqdBDV4+boG5PueeeD+qNc0Ubuf23C/j0PybKz+7eE27OT59dcDT3tHhlJR8McOL0RgHNiXq+F
 uEJdBnL6zNYzOkcZRAw==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDEyMSBTYWx0ZWRfXzowgiUYh/UJh
 i8jplyaIXHpPM6V18oCMZUSzQB4sS8Ba6NKOMPOHqCYSDjaxewOxhWZKWZC+X+xkXdDqshehrM4
 3/oq8nABRKJ0vyiELIZ1uNyGbFcV/sc=
X-Authority-Analysis: v=2.4 cv=NOLlPU6g c=1 sm=1 tr=0 ts=6a6b751f cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=QXcCYyLzdtTjyudCfB6f:22 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=M5GUcnROAAAA:8
 a=FIsYe-w1_y0ff0Q7JPwA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-GUID: iGUnI6g2HGicklEVuz5rg-m7DZjo11sP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-30_04,2026-07-30_01,2025-10-01_01

struct qla_i2c_access carries a 16-bit length field alongside a fixed
64-byte buffer:

	struct qla_i2c_access {
		uint16_t device, offset, option, length;
		uint8_t  buffer[0x40];
	} __packed;

qla2x00_write_i2c() and qla2x00_read_i2c() use the user-supplied
i2c->length without any bounds check. i2c is overlaid on a 256-byte
on-stack buffer and sfp is a 256-byte DMA-pool buffer, so a length up to
65535 overruns both:

  - write: memcpy(sfp, i2c->buffer, i2c->length) over-reads the stack and
    over-writes the sfp heap buffer, and qla2x00_write_sfp() then DMAs
    i2c->length bytes out of the 256-byte buffer.
  - read: qla2x00_read_sfp() DMAs i2c->length bytes into the 256-byte sfp,
    then memcpy(i2c->buffer, sfp, i2c->length) overflows the 64-byte
    buffer inside the on-stack array.

A caller holding CAP_SYS_RAWIO can use this to corrupt the heap and the
kernel stack. Reject requests whose length exceeds the buffer before any
copy or DMA transfer in both handlers.

Fixes: 9ebb5d9c69f1 ("[SCSI] qla2xxx: Add I2C BSG interface.")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-dev@google.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_bsg.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 59fcc726b682..ab559048dbb8 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -2175,6 +2175,12 @@ qla2x00_write_i2c(struct bsg_job *bsg_job)
 	sg_copy_to_buffer(bsg_job->request_payload.sg_list,
 	    bsg_job->request_payload.sg_cnt, i2c, sizeof(*i2c));
 
+	if (i2c->length > sizeof(i2c->buffer)) {
+		bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =
+		    EXT_STATUS_INVALID_PARAM;
+		goto dealloc;
+	}
+
 	memcpy(sfp, i2c->buffer, i2c->length);
 	rval = qla2x00_write_sfp(vha, sfp_dma, sfp,
 	    i2c->device, i2c->offset, i2c->length, i2c->option);
@@ -2221,6 +2227,12 @@ qla2x00_read_i2c(struct bsg_job *bsg_job)
 	sg_copy_to_buffer(bsg_job->request_payload.sg_list,
 	    bsg_job->request_payload.sg_cnt, i2c, sizeof(*i2c));
 
+	if (i2c->length > sizeof(i2c->buffer)) {
+		bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =
+		    EXT_STATUS_INVALID_PARAM;
+		goto dealloc;
+	}
+
 	rval = qla2x00_read_sfp(vha, sfp_dma, sfp,
 		i2c->device, i2c->offset, i2c->length, i2c->option);
 
-- 
2.47.3

