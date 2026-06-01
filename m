Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 901C035200A
	for <linux-scsi@vger.kernel.org>; Mon,  1 Jun 2026 10:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780309828; cv=none; b=WIPiNXDapxlWmnYEp124Xv2+HEWRN1FSOzwpjuyu2mrDnntUL+3C9i0piS7al8BXY1mMHP4xm6DdUTxyk5BpOIWUZ6/AXqCO/7exl/AuBrP1FueiR/SzvCG6DAjgz8Jw7DIxIVdIAUozZkwB2MAWvpUTjosXDiTyjl23R/beXZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780309828; c=relaxed/simple;
	bh=5KT9u44TucJ30QNoqPWOuCfUc5rUp4HCv58ApZHNSxQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QnaUZwKf3NTNkYaJRgJqQU59Rc6Xm/3oNTlNgzsdaD3IdqL7xL7kd8XLm65Z5qKViEuMn7ObYqBNPjukkH08vD5VffMabA3nZzIZnbkbwAAq+ZICZMSBxzyLYIAjjQ2mCV/S/zhFR6vugHwUP/6RcgMFjkkUMFb9CbzfAUlf6ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=H/yFtKOo; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="H/yFtKOo"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64VKsAHN907080;
	Mon, 1 Jun 2026 03:30:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=y
	2koGxK5wOpgFQ09SlJs3ukLFfqM/dpmRDNrTAihEjc=; b=H/yFtKOosa8HskAZ/
	uSeSad3DjWNaif4dJPCa5tI65KZlCATaF9/EeufK7PXslVezfGAv8WUKPTvZGSLF
	jY6lphetbZXGpLVeexzM9HXkRph+W7G9LdcLRSMuKkiwX/EVgjge3FguAqL/p5oP
	hjg2hVlMVaUqW4NYca3l7ksDpeGSNxW0ic7IBdZtk1IcR519+doN0f9hJsR/SXvA
	Kz9BstyNHSfKCI0gHzif42TAwdP26d4wlYIxVolwl2BRE64I2a41wgW8vTsrG2HK
	kSzj7h06XL0SAhcgI/ixspLm7bAoALnRHuwF13F3pHZP4F03GMlWIWzMskPpSAlO
	Bpviw==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4efw8hwppd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Jun 2026 03:30:23 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 1 Jun 2026 03:30:23 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 1 Jun 2026 03:30:23 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id B6ACD3F7057;
	Mon,  1 Jun 2026 03:30:20 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH 22/44] scsi: qla2xxx: Enable set_els_cmds and echo_test for 29xx
Date: Mon, 1 Jun 2026 15:58:31 +0530
Message-ID: <20260601102853.328426-23-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260601102853.328426-1-njavali@marvell.com>
References: <20260601102853.328426-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAxMDEwNSBTYWx0ZWRfX16b6TLOCRrK1
 cW4FXEGbKQ0UoIFpWz3/VWkcvHkiWIya0x5M/Ouubs7FuhepuviBoAOZcfdNqr4HXjeff8xs8H8
 qsDvkk8UzocnYtDrx9afL1xsRlxIqTXRzbIRKDZO7sL4isgvlwK3MRtbENoeOYD39DQg8dCJYm5
 W51WNNxFUYeRXr5iCZUZML9BhmZgRsa1evAenqMWEOzTK1VIuLPBJEMmxaZb32Xzmx2eRtwSKyV
 aVTxAMD8Q1mddqCOnzKejhbpqH5j/OiL3d2XEKr9yROzCs2fA9qB1oBeCLteZKi7K5tOQ3XNTha
 2BLRPhlp/Vw4TN1HijOSZ1UnX/kP+3hGobCoEaKeN9jumYKREszJgb200hWcDauxUwGG+zT/4rZ
 BaklRTNWisDF2HF4VcvhzNqNbG00scG3ZIVvQp0lLiWPYY6pO3pDb0ERGVclp9SrjHWXj5FxSW4
 zotyQ0ZfM85lBRmvtuw==
X-Proofpoint-GUID: lQI_q7waYD8iybbC76hiLNjHjDDkdXkI
X-Proofpoint-ORIG-GUID: lQI_q7waYD8iybbC76hiLNjHjDDkdXkI
X-Authority-Analysis: v=2.4 cv=F99nsKhN c=1 sm=1 tr=0 ts=6a1d5f40 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=EAYMVhzMl8SCOHhVQcBL:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=UohhYlrJZoq7yYDAghQA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-01_03,2026-05-28_03,2025-10-01_01

Add IS_QLA29XX() checks to qla25xx_set_els_cmds_supported() and
qla2x00_echo_test() so that ELS command support and echo test
diagnostics are available on 29xx series adapters.

Cc: stable@vger.kernel.org
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index b631b41e4c58..330371c29c6b 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -5087,7 +5087,8 @@ qla25xx_set_els_cmds_supported(scsi_qla_host_t *vha)
 	struct qla_hw_data *ha = vha->hw;
 
 	if (!IS_QLA25XX(ha) && !IS_QLA2031(ha) &&
-	    !IS_QLA27XX(ha) && !IS_QLA28XX(ha))
+	    !IS_QLA27XX(ha) && !IS_QLA28XX(ha) &&
+	    !IS_QLA29XX(ha))
 		return QLA_SUCCESS;
 
 	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x1197,
@@ -5492,10 +5493,10 @@ qla2x00_echo_test(scsi_qla_host_t *vha, struct msg_echo_lb *mreq,
 
 	mcp->in_mb = MBX_0;
 	if (IS_CNA_CAPABLE(ha) || IS_QLA24XX_TYPE(ha) || IS_QLA25XX(ha) ||
-	    IS_QLA2031(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha))
+	    IS_QLA2031(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha) || IS_QLA29XX(ha))
 		mcp->in_mb |= MBX_1;
 	if (IS_CNA_CAPABLE(ha) || IS_QLA2031(ha) || IS_QLA27XX(ha) ||
-	    IS_QLA28XX(ha))
+	    IS_QLA28XX(ha) || IS_QLA29XX(ha))
 		mcp->in_mb |= MBX_3;
 
 	mcp->tov = MBX_TOV_SECONDS;
-- 
2.47.3

