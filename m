Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B217949620
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 15:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784302293; cv=none; b=RDwOUIQPdtZhoO7abCMY5gh866S3WBZ3+QlB9GJ2umy3qgYial6rkwUjaIRdhaD6nP2s4VarPm63m5ehmIHSdzhWgA2bbm0ORUilFeSH8iGBN9gK3xfWOh0iq/Wx9ZWQttxCe7tdCASOvvrufUyqB78twaET/+MoaU4wxDIQfPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784302293; c=relaxed/simple;
	bh=1JGkPanv0nZvGUzSBZRdho4T5+VnfDpluLGpPvjdPI4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TaMOz5UCYLFz9rveH85TPL/PUrZGvni2yxOM/+lU+gELu5vc7Sdt0RQ74PrG3nECLQBc+ZyOqrxOvDS2cf4326vGI7KmJAhC8u0LEttzYSHB4b5cFPgVeH+MSWs4hfLtjZmL8Uc2QSFVO6ti8PiBGPyYws9E/apK3N9bo5ySsug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=M+C0otRP; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="M+C0otRP"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66HE7kPA094617;
	Fri, 17 Jul 2026 08:31:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=c
	1+/DMWvJSBGxBqfj98Deil5FGXFLRJNlV+ymLVo8po=; b=M+C0otRPUu+nWE/17
	VKo3r4AT2Df0afSX02LToZ2lP9EglGuYezn50zwt1T8qRfpfiLpqs/U6NeOPM6DF
	kPdTr9/fiW7iBhdirIAIzdpH2FzB9hS31VhELQxFyxD+EIEk1QM7LUhK9IRaISUy
	ioAygUX3YEG7WQ4jA1jqfQJGGYbjGwTKVvj/hzCVdGYs6xD/fwJkvB7is/zu1GQ4
	KU4K2ywZrMN0F8BEE+YHl/iRYcyypLloIzolkUzMOYNrZxdCbD0QVk1nbakTRNwj
	P4kg6VLF5OTccwCGcimmrUT2X40B71w+aGOcGIw9F1MOOt/iyx29ECb628uy+Vow
	2NiZA==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4ffhg8rxj0-5
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jul 2026 08:31:28 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 17 Jul 2026 08:31:27 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 17 Jul 2026 08:31:27 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id F3B695B693B;
	Fri, 17 Jul 2026 08:31:24 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v5 49/56] scsi: qla2xxx: Check entry_status in qla24xx_modify_vp_config()
Date: Fri, 17 Jul 2026 20:58:57 +0530
Message-ID: <20260717152904.3155730-50-njavali@marvell.com>
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
X-Proofpoint-GUID: OdPZJUh9cRK5sUEhBmJkcjDcWvVZsB7c
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE3MDE1OCBTYWx0ZWRfX8hBGYdnDNSlQ
 MYIca7fXQfKbIpX+Cd1U2i91YFcqNj2iytKJ1rjjOZqcRPsWNlJPm5mYuWYTjkePmczd57dQNTP
 fVvwys++tEtq0npxnG609Ta/cTVRwTw=
X-Authority-Analysis: v=2.4 cv=SpKgLvO0 c=1 sm=1 tr=0 ts=6a5a4ad0 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=EAYMVhzMl8SCOHhVQcBL:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=45oI07BRoqxegsLmdCIA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE3MDE1OCBTYWx0ZWRfX5Pqn1djvbDym
 b99EX6UapZPDPiwNkrPdCaxsiCySpDNRfXvn2BlBGsW4+2/MNVvEGwT73x/8+jjdtaFHww2jVBu
 ljBk0Hg4sJeggRl1ZbQ7x2o7fZVYO/bBSgv0eZnoV61OwDhHs4wS8kE5pPZreqy1m+kpS9dBmgi
 N+IJLEUGOuD1Ij1CDqFilGRX21bA901O7Q2ZYOXYh0aw+8kb4RRvBYrUcApaXnJFZq8m4dQvayD
 k/wN4ACbUsJIqVAnp2cErtHGqS1MPWS/LDO8yty5Hg5B/s6xGkd3qWMAhmvGskt4jry/0WQF6ba
 HwUltbGi2R5JLcyRZO0pEouwdicE2fKyLFM0n+lvE3sbgrHv5wZITJf/Y2LX0OojXrHrBWrwHue
 GSYutfpG1GvgKMaZIUXr7sifA4dadoayCveonB4EzHP3GYZTGgfClsBZLQfv3W3lJZdOtAlVf9h
 bJsmgNx35sgX1pLXOHg==
X-Proofpoint-ORIG-GUID: OdPZJUh9cRK5sUEhBmJkcjDcWvVZsB7c
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-17_04,2026-07-17_01,2025-10-01_01

The Modify VP Config completion handler labelled its first error branch
"error status" but tested vpmod->comp_status instead of
vpmod->entry_status. Because CS_COMPLETE is 0, the following
"comp_status != CS_COMPLETE" branch duplicated that test and was dead
code, and entry_status was never examined at all.

When firmware rejects the IOCB early it sets entry_status while leaving
comp_status zero. As the IOCB is allocated with dma_pool_zalloc(), both
comp_status branches evaluate false and the handler falls through to the
success path, calling fc_vport_set_state(FC_VPORT_INITIALIZING) for a
configuration the firmware never accepted. This can leave the virtual
port enabled on top of an invalid config and surface later as login
timeouts or follow-on firmware errors.

Test entry_status in the first branch, matching qla_ctrlvp_completed()
and the login/logout/abort/reset IOCB handlers; the comp_status branch
then becomes the live completion-status check.

Fixes: 2c3dfe3f6ad8 ("[SCSI] qla2xxx: add support for NPIV")
Cc: stable@vger.kernel.org
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index b32ca8ed274d..59023492c5a9 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -4401,10 +4401,10 @@ qla24xx_modify_vp_config(scsi_qla_host_t *vha)
 	if (rval != QLA_SUCCESS) {
 		ql_dbg(ql_dbg_mbx, vha, 0x10bd,
 		    "Failed to issue VP config IOCB (%x).\n", rval);
-	} else if (vpmod->comp_status != 0) {
+	} else if (vpmod->entry_status != 0) {
 		ql_dbg(ql_dbg_mbx, vha, 0x10be,
 		    "Failed to complete IOCB -- error status (%x).\n",
-		    vpmod->comp_status);
+		    vpmod->entry_status);
 		rval = QLA_FUNCTION_FAILED;
 	} else if (vpmod->comp_status != cpu_to_le16(CS_COMPLETE)) {
 		ql_dbg(ql_dbg_mbx, vha, 0x10bf,
-- 
2.47.3

