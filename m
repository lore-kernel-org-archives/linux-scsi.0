Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 995E92511F
	for <linux-scsi@vger.kernel.org>; Tue, 27 Feb 2024 16:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709052298; cv=none; b=e/U5IMfNsUypu3t2eJVfwnBToKdcnDB1HOp9svzhjFwPZpcEQBEzIhxmlRNKCTZNbGcWsjqrwuQsHNS8VTUQncfFi05La1QMXdWy5HLYFbx/Cj1lHtOZYcqHVgN/WG7H3NHUGASD4g/n0tzPoqrGqauQt+AOhQNjfGcb7YncDOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709052298; c=relaxed/simple;
	bh=GqXrxkSoGaJjXeKUuVO5SrmsIoB5yHA+Oo3zO+tATcQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ANYaDllUemsg2PgHLDLvxanBS/mOdhwPFpqQmBLhQ/X7DV3n4298GMcHbMnhYp6GJweGgviIgqZkWH3CzQ60euGnJN8a/3B4B6WE2vK+LYSF4CvtmqspRATrELok5MIjB/qQFvH6dXyfehuOCNJ4ybDHUmgn63yAUp8aYut4Le8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=Qy4/8u74; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="Qy4/8u74"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 41RG2Wh8023975;
	Tue, 27 Feb 2024 08:42:00 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=
	pfpt0220; bh=5xi0gdzAW2n2ZetCka52aDZJ3LGCFWepMu9Y/eL/Kzw=; b=Qy4
	/8u74tSiFR/F+50Nqwr2C/bvtF0lta+qr6kUa5JrvH6KNrwJcquJgVu8p6iRwESo
	VFa6aN/IQTsJkbJp9RcKaGSksYCh9LVdTXkbfyntklbtLtbtRLHGw97mh/ZgWvBk
	7IlbifAu+F9K4iud4xSc1QpoCkvbCHU/2pokOFD/PVB4hFMmQmoRn8ReZCFEaMXW
	g6gg8GsSgNNb328Zd1SPnsM8w4I32NNFTinh34w4tM8RhTby31kgO+WZH7cymoIv
	e8+hgUbTdl66a5zqa9r7FjYzBHacWjd1VFam2p76ZgncKiWfDeE42/bbLSkTIXsb
	LPhhDOy7byI7d9ezJ5g==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3whjwdg5y0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 27 Feb 2024 08:42:00 -0800 (PST)
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1258.12; Tue, 27 Feb
 2024 08:41:59 -0800
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH02.marvell.com (10.69.176.39) with Microsoft SMTP Server (TLS) id
 15.0.1497.48; Tue, 27 Feb 2024 08:41:58 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1258.12 via Frontend
 Transport; Tue, 27 Feb 2024 08:41:58 -0800
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.187])
	by maili.marvell.com (Postfix) with ESMTP id 3932C3F7099;
	Tue, 27 Feb 2024 08:41:55 -0800 (PST)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>, <emilne@redhat.com>,
        <jmeneghi@redhat.com>
Subject: [PATCH v2 07/11] qla2xxx: Fix double free of the ha->vp_map pointer.
Date: Tue, 27 Feb 2024 22:11:23 +0530
Message-ID: <20240227164127.36465-8-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20240227164127.36465-1-njavali@marvell.com>
References: <20240227164127.36465-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: BbFNGN-ZAIblS3gB33FT_g9V-LQ6XHx_
X-Proofpoint-ORIG-GUID: BbFNGN-ZAIblS3gB33FT_g9V-LQ6XHx_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-27_03,2024-02-27_01,2023-05-22_02

From: Saurav Kashyap <skashyap@marvell.com>

Coverity scan reported potential risk of double free
of the pointer ha->vp_map.
ha→vp_map was freed in qla2x00_mem_alloc(), and again
freed in function qla2x00_mem_free(ha).

Assign NULL to vp_map and kfree take care of NULL.

Cc: stable@vger.kernel.org
Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index b3bb974ae797..1e2f52210f60 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4602,6 +4602,7 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
 	ha->init_cb_dma = 0;
 fail_free_vp_map:
 	kfree(ha->vp_map);
+	ha->vp_map = NULL;
 fail:
 	ql_log(ql_log_fatal, NULL, 0x0030,
 	    "Memory allocation failure.\n");
-- 
2.23.1

