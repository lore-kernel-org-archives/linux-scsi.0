Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70FD733DED9
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 05:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783403900; cv=none; b=hoOAGUQNOjDjlEAMExsgU/9sAmrTOJlWBSIAt46cbA18bMTnE0oUeABuNpe4gEhxpw+8O4rGVQrV+LEh1ayiBL71ryFe2uAsotCjcIB1085FqNuD5ByVQW24wKLm/ACppPC9h16HBDqEbK0WwNM+4DLLSlnQDef4UyyCQshsGTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783403900; c=relaxed/simple;
	bh=brJv5gowyqv69CLFsGNj8XYUBB11Lddl2TXwEolM1a8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I/dFmezwUPEgGuGX71YTkbxb5rH1WSG0CVRm9HiV/AwK0Ax8fo9z0f5C6TKQocuIBn6seTWF7FnHTyftu4uSoaglut20rxrkTNmNAaFB/3dctEKNpMrQ/VVBmOZjo3vVh3QrIMhZ6AOETvxZlfJKXxlcU104vYzv75vxk86TkSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=jJ2rUzhN; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="jJ2rUzhN"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66748mte1619448;
	Mon, 6 Jul 2026 22:58:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=M
	4NA7RvIBNth53CPPHhS2GDeJv9uIaSYi6ajbj1JHqE=; b=jJ2rUzhNbeC66N8O/
	x7GBvPJcqHhn2FzWQWF0wOzYyAUO1DWyqW43YjFrfUrkfH8ZI86OaSm5G3iwfMHZ
	FymhkimVjVtS4K9OBYSfDIOW48/gv503Lyq1QTCjvYwbvvXovDSmjj2fZspyZF6C
	3LEcftdztFNsa9m7s6K6kNvo4cci/VCkH3fIsvnDRwgsdmuBLKDdKJ3CDanVXZeK
	FuTcSiRioCCrpRbgrp8lRY9Ou2nJDSiBgT+yJHG+NUKQQTZMo0EuxEkoVql3aDAs
	GPS/7xCrU5RqUVwEQsCZpz/b8G2gMCF5Nrs7mKh8x90sJPkI5RY3QCPySOCEjJEJ
	TO1HA==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4f8p31gqnb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Jul 2026 22:58:15 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 6 Jul 2026 22:58:15 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 6 Jul 2026 22:58:15 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id B80A43F7066;
	Mon,  6 Jul 2026 22:58:12 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v3 67/88] scsi: qla2xxx: Null out freed pointers in qla2x00_mem_alloc() error path
Date: Tue, 7 Jul 2026 11:24:14 +0530
Message-ID: <20260707055435.2680300-68-njavali@marvell.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfX0rBFlGp4vkpc
 J6X33FLm+xd2TWow8cOeKJ/twUtuz+vuCyJ6nzzrsDRP8+lzR/CNEuBrgpHjQVk81IP+OvnXR5o
 5SBPxGL4tRk0RX1MeTgJ2KRU+nXBpDM=
X-Proofpoint-GUID: m2Qvq3jPPQdn-eQD8-gTvbQWAuXWedrR
X-Proofpoint-ORIG-GUID: m2Qvq3jPPQdn-eQD8-gTvbQWAuXWedrR
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfXzQWSMNOLpOO6
 YVC7MSc7d1WKD4mD0IH74nu9jFcPyVxLWnI0VIgjoW+QT6mz7XJjKpDxixz8DdViDFDk7nu10rg
 egWqWzNGBvFMOy2OwkXA59/YdaxZMcvQYTPlyC3Hk8LRZMpsgBzGd0GxfmSqGUI81igRsImD6wc
 QgUSwOurst9HdK5sHZ/sXfntg4W13a3CXsQxgqMuEkwrGxvOLEv8e2ncmGDGx5Qst0F5RICZbgn
 m3XpBWgtv6Jh9xKexFsYoKHvvZoKQlBJtcUYNO8ZRmo3rmsAIUuOEWHHTuIsWiN6r+bGTU567J4
 5QOuttCs7L4m2zOBp++rN1hPXWI3qhdbt9eoJkHz7S1shiYSvMeiehjE/6Vtl2yxLrGUD/k1ckb
 eCSvC7NusOB1Yvdfl+xFFMJUEUrEACznZjXcuV2zTJqszffldJPbAO9lT8qhtGeruUGe3dBze4O
 gT75Eqm+SgI251XkpJw==
X-Authority-Analysis: v=2.4 cv=c5ubhx9l c=1 sm=1 tr=0 ts=6a4c9577 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=EAYMVhzMl8SCOHhVQcBL:22 a=1XWaLZrsAAAA:8 a=M5GUcnROAAAA:8
 a=iV3yYnc7Hkcs7vgRDRAA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_01,2026-07-06_02,2025-10-01_01

When qla2x00_mem_alloc() fails, qla2x00_probe_one() jumps to
probe_hw_failed and calls qla2x00_mem_free(). Several error labels in
qla2x00_mem_alloc() freed adapter members (elsrej.c, purex_dma_pool,
flt, sfp_data, loop_id_map, async_pd, sf_init_cb, ex_init_cb, npiv_info)
but left the pointers dangling. qla2x00_mem_free() then freed them a
second time. Worse, for the dma_pool members it issued
dma_pool_free(ha->s_dma_pool, ...) after s_dma_pool had already been
destroyed and set to NULL at fail_s_dma_pool, dereferencing a NULL pool.

Clear each freed pointer (and its DMA handle) in the error labels so the
subsequent qla2x00_mem_free() skips them.

Reported-by: Sashiko <sashiko-dev@google.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 4f485e4acf4a..918b00aed8b8 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4619,28 +4619,43 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
 fail_lsrjt:
 	dma_free_coherent(&ha->pdev->dev, ha->elsrej.size,
 			  ha->elsrej.c, ha->elsrej.cdma);
+	ha->elsrej.c = NULL;
+	ha->elsrej.cdma = 0;
 fail_elsrej:
 	dma_pool_destroy(ha->purex_dma_pool);
+	ha->purex_dma_pool = NULL;
 fail_flt_data:
 	vfree(ha->flt_data);
 	ha->flt_data = NULL;
 fail_flt:
 	dma_free_coherent(&ha->pdev->dev, sizeof(struct qla_flt_header) + FLT_REGIONS_SIZE,
 	    ha->flt, ha->flt_dma);
+	ha->flt = NULL;
+	ha->flt_dma = 0;
 
 fail_flt_buffer:
 	dma_free_coherent(&ha->pdev->dev, SFP_DEV_SIZE,
 	    ha->sfp_data, ha->sfp_data_dma);
+	ha->sfp_data = NULL;
+	ha->sfp_data_dma = 0;
 fail_sfp_data:
 	kfree(ha->loop_id_map);
+	ha->loop_id_map = NULL;
 fail_loop_id_map:
 	dma_pool_free(ha->s_dma_pool, ha->async_pd, ha->async_pd_dma);
+	ha->async_pd = NULL;
+	ha->async_pd_dma = 0;
 fail_async_pd:
 	dma_pool_free(ha->s_dma_pool, ha->sf_init_cb, ha->sf_init_cb_dma);
+	ha->sf_init_cb = NULL;
+	ha->sf_init_cb_dma = 0;
 fail_sf_init_cb:
 	dma_pool_free(ha->s_dma_pool, ha->ex_init_cb, ha->ex_init_cb_dma);
+	ha->ex_init_cb = NULL;
+	ha->ex_init_cb_dma = 0;
 fail_ex_init_cb:
 	kfree(ha->npiv_info);
+	ha->npiv_info = NULL;
 fail_npiv_info:
 	dma_free_coherent(&ha->pdev->dev,
 		((*rsp)->length + 1) * rsp_entry_size,
-- 
2.47.3

