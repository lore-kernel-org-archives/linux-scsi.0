Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65B8043E9FE
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 15:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427166; cv=none; b=aopdcwqHq1lWO5HSA68zSaKRY84X1tHz7Vz/ws7oI95k2Ara0rGQqnqhgdDdlDw/9ALiEV/RTeDlhehyYzPQ/u8eO3nRuocyuyFgrNXZZUGOPP+GuqFB9pC1qGtAriWWW/Mr2DaxPYJEtdlbCS5MJT3j/jAtQNOsFL1rjPC3iYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427166; c=relaxed/simple;
	bh=KLgOFIq5KzqEXBSaP/AzU9r0IhGR0PiEoMHlUgADZq0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fCPpuFPsBC+WSfCx+98L4XGyIKLmsXeqYs8bDboPBZHW/jCU4cjlvnKjzSs/mCmHmUgy3knHHEsCwLKrh8LkajlxRLjZ3oOj76W/OBI1cchP2/sOYDOzbdGPCB+bVLRD3MFBVLN39l0N01g0bME62XAosE+bBk0Pm7z6rvcJJQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=g309zEDk; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="g309zEDk"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66UFV0he1299535;
	Thu, 30 Jul 2026 08:59:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=b
	99WHclhpKyMMeTAdGF9REMDL6YRUB+N8Ibs1L8KRDo=; b=g309zEDkXZ+VIITrW
	EhnFSMCYLwXWrtqcMgVLMAt3AuQI3d3ARy+jS2gpGQEbGkc+O6SqM6YJN9m5NuyP
	GL6sSeWmgQ/CyjaMvnt1YLeGoJkdDDhv5NzIdMIfX1yl9fy5dRPjrccuxPvctCGk
	WPk40698iMIBqf9erq4m/PHZ4ODxVtxOhWoral4+ylCGHUjszXdlrcfCkOUalXz/
	r8m6K0ODZ33UBGFzI93zr99ff4jbUWmtxVQLkywjaI/KbRy7vOwQG8mlJ3pjgdqh
	ePyTsoUg5z2yaKoka2we7MhdKEqya+R/OelXUC9rhQTiV7+YtlEZ3EPzY4ilf2mr
	eOPHQ==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4fq0f08c7e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jul 2026 08:59:22 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 30 Jul 2026 08:59:21 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Thu, 30 Jul 2026 08:59:21 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 505233F7052;
	Thu, 30 Jul 2026 08:59:18 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH 06/33] scsi: qla2xxx: Fix cs84xx use-after-free on host teardown
Date: Thu, 30 Jul 2026 21:28:11 +0530
Message-ID: <20260730155838.2119230-7-njavali@marvell.com>
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
X-Proofpoint-ORIG-GUID: WYhIxBEfb6OfWhMNBV9ZsUi7hcfU9BTP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDEyMSBTYWx0ZWRfX2ub3MJFNylrh
 RpwdA3OVKxcUEBE5u3g6TDkWwovTxS60GhdM56l1zPHAuPrXSLGjGZDJ9+mebfl4qMuLYVfmdGJ
 HQ33JQObzGEdPkl+EZhZ124nvQMUba6Xe89in+4h2PWmdE/Y+arSHqlNIycrudtck+BMeFVUmh0
 prg0zRLd7TqGkMbfmsIjjyu2DPzl2kLmq3ng5dPf9xI6FpmfuxJtQhriahNB19+xN9GBpxKoeGK
 OnjGe3E3uvM3za8aVJCdHKiSxGB5ueAcH7ovIjnYGoHC892hr4ya2qicNqy4dZpq2eaFj1qYXuv
 fkXKrFUrkv1jr+XJdtxF9SVJN15b7kuvrJvkplkI0hlWD+poF24IMFLUG5g5Yrbvf/yRiL0a8kT
 fcuYUwMht6HxbaECVDFnSXv7PHqtoMDbVAcAcbD7V9jERIJ0Nnq13c95UnrWFAiu9TYRc1oD2qQ
 3vLrabUt8e964yYjwww==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDEyMSBTYWx0ZWRfX2s1e2KfdfRRz
 R/fhBoxm9vz0f3iPNmEGDo9kDAAp+LqQ90PFieRkkJOX5uiR5ZBIjKXEVy1wDVBYOtyJDaee9iC
 LyGfLmojQnEnXoJb/ajViuGNScxMsOw=
X-Authority-Analysis: v=2.4 cv=NOLlPU6g c=1 sm=1 tr=0 ts=6a6b74da cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=QXcCYyLzdtTjyudCfB6f:22 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=M5GUcnROAAAA:8
 a=ad4WSI_q5LBR8ROCVKoA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-GUID: WYhIxBEfb6OfWhMNBV9ZsUi7hcfU9BTP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-30_04,2026-07-30_01,2025-10-01_01

qla84xx_put_chip() drops the last reference to ha->cs84xx and frees it via
__qla84xx_chip_release() without clearing ha->cs84xx. During teardown it ran
before scsi_remove_host(), which is what removes the 84xx_fw_version host
sysfs attribute. A concurrent read of that attribute in the window between
the two calls executes qla24xx_84xx_fw_version_show(), which dereferences
the freed ha->cs84xx, resulting in a use-after-free.

Move qla84xx_put_chip() to after scsi_remove_host() in both
qla2x00_remove_one() and qla2x00_disable_board_on_pci_error(). Once
scsi_remove_host() returns, the sysfs attribute is gone and kernfs has
drained any in-flight show(), so no reader can touch cs84xx; the put still
runs before the host and ha are freed.

Fixes: fe1b806f4f71 ("[SCSI] qla2xxx: Refactor shutdown code so some functionality can be reused.")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-dev@google.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 62c9bd0fe06d..4f485e4acf4a 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4048,8 +4048,6 @@ qla2x00_remove_one(struct pci_dev *pdev)
 
 	qla2x00_dfs_remove(base_vha);
 
-	qla84xx_put_chip(base_vha);
-
 	/* Disable timer */
 	if (base_vha->timer_active)
 		qla2x00_stop_timer(base_vha);
@@ -4074,6 +4072,8 @@ qla2x00_remove_one(struct pci_dev *pdev)
 
 	scsi_remove_host(base_vha->host);
 
+	qla84xx_put_chip(base_vha);
+
 	qla2x00_free_device(base_vha);
 
 	qla2x00_clear_drv_active(ha);
@@ -6995,8 +6995,6 @@ qla2x00_disable_board_on_pci_error(struct work_struct *work)
 
 	qla2x00_dfs_remove(base_vha);
 
-	qla84xx_put_chip(base_vha);
-
 	if (base_vha->timer_active)
 		qla2x00_stop_timer(base_vha);
 
@@ -7014,6 +7012,8 @@ qla2x00_disable_board_on_pci_error(struct work_struct *work)
 
 	scsi_remove_host(base_vha->host);
 
+	qla84xx_put_chip(base_vha);
+
 	base_vha->flags.init_done = 0;
 	qla25xx_delete_queues(base_vha);
 	qla2x00_free_fcports(base_vha);
-- 
2.47.3

