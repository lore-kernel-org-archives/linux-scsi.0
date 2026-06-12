Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC325339844
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 09:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781258086; cv=none; b=PzwSXNLXau8MWM8k+UcGWSIESDWcPNRA1XdbEyEZua6oj+/DRStq0w6HEvc8Zf80Ry57++TNUVseyDdMSP3gHXABOW8Ejq32o4zHXWY1RvnxYUfvWkJ0/WslrZtyE53W3DCbXVyBfz2KqfJ4uXXdsGjPjgNMfCr6BdU1aASk4OA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781258086; c=relaxed/simple;
	bh=eo4ef0jVBG5moKBj5GdR7XMgxYKcn2+x5DQ1e3t0XV8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PGJwLuydxddwT93TRsq2pBsgYzyDJ9uLbk7NZz1kjn65IvbQuFlkVH6/zEF61tvcYi7ToK0EzRizZcIDoxhNzAMDWfzYZK3zmTOqt6eACgfru6njXv15qa9qDhYqlxd3owf1Hdh4yVirK30LIqLTgJRcTB+0aKKncdzoUYPCOG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=jNB1XRYs; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="jNB1XRYs"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65C38x5S3678669;
	Fri, 12 Jun 2026 02:54:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=B
	rn/LOkIF16Ich4BWgUBcLELNjhoELYWVCDinnYxqwc=; b=jNB1XRYs1jHwfu77n
	STjuKGhCEsDz3+x0SxY/GRVulodU5nW5WoKkaK+m9q2W8CQW+XgVWGz1JZtu5gtU
	z+jNHPk62859agPqqXIvLZmTBlIHPwAuSAb3sWk97JB87ornWg3T8BP73KSa7naO
	tMvYQHVf7YjqMXE9SfZP5S0iCA2AkprtT3XKlkd+nTm26YdWlycMN15TaVX5jx3M
	iL739F2qC/7U+x4R5HB2KHFRKDVBljij8KebZn+3bWSosQTh3oy73JnLTqySawZo
	uCNw2R+wkuOOQcR1PU/c/bTOt9hqQKLxFqByOZhFiGQfSLBELCCl4/fwMV/jZaMo
	MQbdw==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4er9qn92gw-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 Jun 2026 02:54:41 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 12 Jun 2026 02:54:39 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 12 Jun 2026 02:54:39 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 9F1923F7040;
	Fri, 12 Jun 2026 02:54:36 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v2 14/60] scsi: qla2xxx: Skip image-set-valid attribute for 29xx
Date: Fri, 12 Jun 2026 15:22:47 +0530
Message-ID: <20260612095333.1666592-15-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260612095333.1666592-1-njavali@marvell.com>
References: <20260612095333.1666592-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: R4UM006Xpiujk_IPqg1IZ8B4ljW-FVCO
X-Authority-Analysis: v=2.4 cv=Y9HIdBeN c=1 sm=1 tr=0 ts=6a2bd761 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=TtqV-g6YmW1Jfm2GSLaY:22 a=M5GUcnROAAAA:8 a=PjqBlKwVE8k9D4kk4N4A:9
 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjEyMDA4OSBTYWx0ZWRfXxThlDU7TAupG
 FJSRDBI4nw4yKPqcj3oOZQdDHx+C7c8Yh//q5E2LiJqr68DqmzUa2Xo/YwlUnvxmRIfjePlXfYo
 XqbG4oarbE3FcNm5Ao5D/VIrgRjJvZk=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjEyMDA4OSBTYWx0ZWRfXyTbQawe54yeg
 a6pLQglea+WNM6NYz18JqEmEMy9gHDSQzkfAgbcWSFbj7V2T1b3EWHjylCAX/V6DKfoz0AqEVXS
 qHdQknzmMEdo4pL8807mW49p+cKcJvfaSVEjqQ6mxhZMY9mqNZ7ZV5fysXBzC/OU4ajrRxTHWmv
 nAebvgWyBI2URK7dAnmer3DEMUC7QhoMjQyb2NIkVAy55ZD/DkNKzFeVGRAIMXd45qPmOBBqtXy
 WMWWFg2qz3TNnMdj46hSLXQDtvtgU6QI6EBUwJCcafs+ZCEUEQw5qdWvVaxhZyPAkNhzwfPDJbm
 4pcjJbK9SlZuffS1t2WwZPMi7R/qquQ1OgFqhrNRW3buQlWZD/0XV0PjSZ9+BWhm+76RFXO03HK
 PT5nPOLlj5wvN3W7P0wuEYm2QWPxi8C+qjEUIYDZQXWLteKM455wf1GVftsiQiapxKWtDf24WGs
 n7wHsQ2e4LbwY6H7BZA==
X-Proofpoint-GUID: R4UM006Xpiujk_IPqg1IZ8B4ljW-FVCO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-12_01,2026-06-11_01,2025-10-01_01

The 29xx adapter does not support the QLA_IMG_SET_VALID_SUPPORT
driver attribute.  Gate the attribute behind an IS_QLA29XX()
check so that userspace applications querying driver capabilities
via BSG receive accurate information.

Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_bsg.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 92a0bc6dc7bc..00e980f0cd78 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -2904,11 +2904,14 @@ qla2x00_get_flash_image_status(struct bsg_job *bsg_job)
 static int
 qla2x00_get_drv_attr(struct bsg_job *bsg_job)
 {
+	scsi_qla_host_t *vha = shost_priv(fc_bsg_to_shost(bsg_job));
 	struct qla_drv_attr drv_attr;
 	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
+	struct qla_hw_data *ha = vha->hw;
 
 	memset(&drv_attr, 0, sizeof(struct qla_drv_attr));
-	drv_attr.ext_attributes |= QLA_IMG_SET_VALID_SUPPORT;
+	if (!IS_QLA29XX(ha))
+		drv_attr.ext_attributes |= QLA_IMG_SET_VALID_SUPPORT;
 
 
 	sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
-- 
2.47.3

