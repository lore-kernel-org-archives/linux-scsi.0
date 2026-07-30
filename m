Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CA61443AAB
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 15:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427182; cv=none; b=bpfpwyaivb/+eysazCEDjzmo3XoToibQ6dNxORSIBP96ygjnEYRyizIGD2nUHHKTagR8OUpM9Apg3lTDZ/ZOZqSFYQlvszgtHxOhg6Km6FIUVJjlgy7k8JJa8yv98JVODd9NAmjxH41CacGMoYq1d9ULnpY2UJ0fsYjzwj401O4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427182; c=relaxed/simple;
	bh=6R/RtFlwYz0BZwwJ64ZkoRIqRUSFqWCsoyzSLr7HXPw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T4PvJIUjpRnv7BWg/wekY+cvg4Gn8bLAbvCRAiE2EZ18nF3ql2M6M5u8jGktq8toNtyo2zNTJYHhd6O+UkT5X+8LUKNs02+cAYMIB7gQ2xfBATLUtpivr1WfJh/r1d0xtxDoKz/5RcU8/03r8pXoDzDfe3QJ6LyfndmUogLQNI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=J4BHkpMV; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="J4BHkpMV"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66UFV6nr1299766;
	Thu, 30 Jul 2026 08:59:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=6
	jtum9cFM7bza+be8N4lah76tHbYnVIDpkhSOeAO7Gs=; b=J4BHkpMV/xH0As2Zt
	F+f8i02Zo4is8mCSBNxQjSvmqyXSBeo2NlS4YMS5x4C5dWV1Cp6sKlztMXoYw6Tq
	CmWU3qlr0+mVRwnREilRNwKBu4IKHXHRnUVT7DFJFDaX4uxx/Jt4wbrU9p+um6uB
	/AveEaCYCdDz1oMyOyi5h90HlDHO7nGiNhxNwavCuwaLZ2fjBBTtm4edQyV/hY2h
	u36+b1uZnglrcpj44Bka138k0kHtS7c1/6z0ehaWC0GOiwoL7oO/Tn7digRR9WtV
	LyU153wHvJ9zUfqZrO03fI4lKn5c8PlVrqQYX1fjNbG85ABQdcxLfh7ZFeJTZ9LB
	JtlTw==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4fq0f08c8e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jul 2026 08:59:37 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 30 Jul 2026 08:59:37 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Thu, 30 Jul 2026 08:59:36 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id A543F3F704A;
	Thu, 30 Jul 2026 08:59:34 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH 12/33] scsi: qla2xxx: Null out freed pointers in qla2x00_mem_alloc() error path
Date: Thu, 30 Jul 2026 21:28:17 +0530
Message-ID: <20260730155838.2119230-13-njavali@marvell.com>
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
X-Proofpoint-ORIG-GUID: 1dY-kBR6ooiMfqWZHt6m-rYRkwneUjaX
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDEyMSBTYWx0ZWRfXxfVhen+L9B/I
 7L1lDBIJZwaAd53Q2dlngsU7eJ0+XvH9Pp7UVh3rDHVA3tUik9O+3rY2geWWQwySYnWdj0pdHGX
 /x0jjr3HrxNmQrNx8vVmNckbt6OlXJhpXEEB0ApIJ9eUXuc4QOS/t0Q3m9itoNKRmWy/CMfaJHa
 51aRCd9O/hw89O9KhJiPht08vXwdCZhNHE+q3dTeN/HjQOgnojrlMS2wJ452AsUft2XCMawkVPp
 ZjfdmxVtC66U5ABjwNwcqBfGX9Nk1NUfrfzc7bl8wiVfG87diArLyk2aDOmnIZ2zzudeLfE26Et
 a+TYhgfkZj3/z4tw73Dvg3YDGvmlalhvHEC3zk4gjkQUZh9f0zB8dntqG5T8AZLAK18n+cHWIk7
 tDYv6b4yO424VJLTBbPwmDVXNh1ejAePhEs1g1ZG/amAm9ST62hly2V+11axh59BmtRuJuK68DK
 oPisYuW3JVOY9H5YArg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDEyMSBTYWx0ZWRfX1JZkyPsBd46q
 hcw01S+YEmsPPS1zmvQ+gfaPUVpwIjWtKvkS3Fza7/lTiMuFgs8wSH9vNzRW1mFnQiF5YcJH1A0
 PKgHWePKvZc6oRW6SA441q+i3XhLf7I=
X-Authority-Analysis: v=2.4 cv=NOLlPU6g c=1 sm=1 tr=0 ts=6a6b74e9 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=QXcCYyLzdtTjyudCfB6f:22 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=M5GUcnROAAAA:8
 a=iV3yYnc7Hkcs7vgRDRAA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-GUID: 1dY-kBR6ooiMfqWZHt6m-rYRkwneUjaX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-30_04,2026-07-30_01,2025-10-01_01

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

Cc: stable@vger.kernel.org
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

