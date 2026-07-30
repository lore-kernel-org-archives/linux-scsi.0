Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE3E43939DA
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 16:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427228; cv=none; b=TZyP3mTYfrxpRWXYJ685niyufGgycV+b+BGSyunIs9cMOq1Zpds71R5eo86uLGnEa/JEyq5VpEU/jLeV/BqZMdm90sedpd5K/Knz2mKLEMfksTOqvHkJNjZhyaUc/WnMzduHI1SlXxHWSEhFHoJ7dK2X5H1cfuf4IpCBrKyREWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427228; c=relaxed/simple;
	bh=R5Rb3G2GzJP2vQaJ857f3s6fLeJAnCgHzb9c1nXBMXg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uT8VU1LnW/2b0aeyJWtaQ6ZqsBNcRoc584eJFogRzAMLqqqnbWa95IihxocppFXuf0BHDHgoRhSoGRcKYpfLPaA5vnYkA7DMoyPc0ZjpUXhz8s3Rmwl8KoqIub5aN1YQWdfibUDa974U/aBAGOvTJ+XFk9DQJDCvTxk8oUTxYqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=QBkXBY69; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="QBkXBY69"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66UFW9rg3113489;
	Thu, 30 Jul 2026 09:00:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=S
	ET365Hr54Eq2omYAFxl0szkIwMQsaTG05TFXFKHZV8=; b=QBkXBY69eV+AwnAFL
	YpLkLgxyrDjPg9ag9rfG1Nj8FVMWOw8dMuavxQRfJBq4Fnfqf67fSy4qYQypFBqo
	0NRm/QhIK3iLQgC6Pz7BmxAJBG9xw3wDy1Qu/1UNKwhYCJeESRlP71o/nBMEEOmy
	VznKuGoGOrZ1pK+nNRfwnUbEY7YGENadGnEOt9OXbg97iIvuYdypLkdTgpoLlW/B
	eHofaRsIEiw0q3SMaLiOTre9iMIAzHeDs0GGW5nvqtv570PqZhvWn3wWdCF42USc
	ogPOf8j4UoEOO1cO93JmNRsx3oL+unVTcfSdduX/xJ3b7gm930scREGlp3/PLg4+
	SSkFA==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4fqu7c2s76-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jul 2026 09:00:23 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 30 Jul 2026 09:00:22 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Thu, 30 Jul 2026 09:00:22 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 7A02E3F7052;
	Thu, 30 Jul 2026 09:00:20 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH 29/33] scsi: qla2xxx: Zero-init bsg stack buffers to avoid info leak
Date: Thu, 30 Jul 2026 21:28:34 +0530
Message-ID: <20260730155838.2119230-30-njavali@marvell.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDEyMSBTYWx0ZWRfX9XrUXSaCNPwd
 ReOz//992tznegiDyEEfgEd/yP/ezps08YtipIVHFbfPxz/ClIUZOCud/Ew3HYFBDASAUcOZ9Bk
 /gk7LzwUl4+5l9nbGaWpdq96csfq9Lg=
X-Proofpoint-GUID: pI9FZvPOlN95JRAMIh8_d-v6WyRQ4OWH
X-Proofpoint-ORIG-GUID: pI9FZvPOlN95JRAMIh8_d-v6WyRQ4OWH
X-Authority-Analysis: v=2.4 cv=HtRG3UTS c=1 sm=1 tr=0 ts=6a6b7517 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=qit2iCtTFQkLgVSMPQTB:22 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=M5GUcnROAAAA:8
 a=9b41JRgduu3byCn4YH4A:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDEyMSBTYWx0ZWRfX98ITpFpcV0Gn
 sgtb0joxOXFyJKcxOlBI05EalI4shbptDpq/LF9ME1oRlQm6Jq4aHfb5EQnsXbA1NjTf3eIlzLl
 7assO1DhtvI/S9/Xcjt6G8Z+Z8caQ/iHu7RrIEibpMef9Jr7RzXXuTtrc6mWRGI52ln6++pBTAt
 9IWNV1BGNS7Ev0kz6S4XcHTAg37UCVFdzOXL7EP1ioGNNtYjP+PNwxTu4vr1sMUYhAkjGwOTbLH
 qDz/+U8dUqyzkEq1vgaINgj7g4iYBoG3a8ZYpSarm9cylP7VA5WfiEhe/sIVZOJ1SH7jy9xBb7O
 3QWmqkhS4ZQj6L0/gv8j7Kt43kwuGIOVwXY/XWiOU+OiVGdRKOMF4aZeaMjrlMtuwh90roZSz+J
 RjXH4wfqwbn86edw5CZ04MDi1QmpgXU+xHxXQOz900OyqlDGE3qIdLaQ/2UH0weawSWdT+U7CJb
 +ynrDTY4q7fuXiWbYlg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-30_04,2026-07-30_01,2025-10-01_01

Several bsg handlers stage their request/reply in an uninitialized 256-byte
on-stack buffer (uint8_t bsg[DMA_POOL_SIZE]) and fill it via
sg_copy_to_buffer(), which only copies as many bytes as the user-supplied
request payload. When the request is shorter than the structure, the
remainder of the buffer is left holding stale stack data.

qla2x00_read_fru_status() and qla2x00_read_i2c() then copy the full
structure back to the reply payload with sg_copy_from_buffer(), leaking the
uninitialized stack bytes to user space. The write/update paths do not copy
the buffer back, but can feed uninitialized fields to the device.

Zero the stack buffer at declaration in all five handlers, mirroring the
heap kzalloc() approach, so short requests can no longer expose stale
memory.

Fixes: 697a4bc69159 ("[SCSI] qla2xxx: Provide method for updating I2C attached VPD.")
Fixes: 9ebb5d9c69f1 ("[SCSI] qla2xxx: Add I2C BSG interface.")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-dev@google.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_bsg.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index f9b693af8db1..49f66f37b1a7 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -1973,7 +1973,7 @@ qla2x00_update_fru_versions(struct bsg_job *bsg_job)
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
 	int rval = 0;
-	uint8_t bsg[DMA_POOL_SIZE];
+	uint8_t bsg[DMA_POOL_SIZE] = {};
 	struct qla_image_version_list *list = (void *)bsg;
 	struct qla_image_version *image;
 	uint32_t count;
@@ -2033,7 +2033,7 @@ qla2x00_read_fru_status(struct bsg_job *bsg_job)
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
 	int rval = 0;
-	uint8_t bsg[DMA_POOL_SIZE];
+	uint8_t bsg[DMA_POOL_SIZE] = {};
 	struct qla_status_reg *sr = (void *)bsg;
 	dma_addr_t sfp_dma;
 	uint8_t *sfp = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &sfp_dma);
@@ -2084,7 +2084,7 @@ qla2x00_write_fru_status(struct bsg_job *bsg_job)
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
 	int rval = 0;
-	uint8_t bsg[DMA_POOL_SIZE];
+	uint8_t bsg[DMA_POOL_SIZE] = {};
 	struct qla_status_reg *sr = (void *)bsg;
 	dma_addr_t sfp_dma;
 	uint8_t *sfp = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &sfp_dma);
@@ -2131,7 +2131,7 @@ qla2x00_write_i2c(struct bsg_job *bsg_job)
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
 	int rval = 0;
-	uint8_t bsg[DMA_POOL_SIZE];
+	uint8_t bsg[DMA_POOL_SIZE] = {};
 	struct qla_i2c_access *i2c = (void *)bsg;
 	dma_addr_t sfp_dma;
 	uint8_t *sfp = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &sfp_dma);
@@ -2177,7 +2177,7 @@ qla2x00_read_i2c(struct bsg_job *bsg_job)
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
 	int rval = 0;
-	uint8_t bsg[DMA_POOL_SIZE];
+	uint8_t bsg[DMA_POOL_SIZE] = {};
 	struct qla_i2c_access *i2c = (void *)bsg;
 	dma_addr_t sfp_dma;
 	uint8_t *sfp = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &sfp_dma);
-- 
2.47.3

