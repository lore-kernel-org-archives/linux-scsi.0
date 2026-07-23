Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 981AD31F998
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 05:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784783132; cv=none; b=PLTwYSBb/6LYhrnbkh+6V3z09pryJqUlknphC72TqhlVwgAK+lQWMaW7xyxowpBoq39tUY06OboCAyFpzaOh21OA8E+MtdNXrn6c8ghHS+3EhtDF9pFbVpaRDlWK4rzl6pG9a8n59ndQ0Csy11i6nBmcOakh/YDruoigBjQYV/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784783132; c=relaxed/simple;
	bh=PKWSxnZNlcUSCnb7l6wdcyEyMNMOpLomovySRtjtgy4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LmO1Prj9/QSf53peHDr6pWn6HmEtkWUfSPMucBvt1A8upttGqT6PFUhtHC+n1bKKlb+amC9kdvY4z8DZLkUFOEJZMTXijv4hS2xW+dyy3RCmxC0lsZzSFZ+eTj3awVj+wVHaCDBVZG0lnehyPkZecqc6YPDzyDfJqDgPFIEte7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=fLMkpGU/; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="fLMkpGU/"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66N4vxq6422564;
	Wed, 22 Jul 2026 22:05:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=V
	sTe/NKpOvzyL2TWgnv5nD3Nj7pJKuoEOmCzQGCLjXQ=; b=fLMkpGU/9bkKQJaC2
	R8kbC8KOtTCthxMFOdCR8+j6TQ+WX9JiHjj1jrR6mdRlrjtJTX49SqcDCeZissGu
	7/zs03mCI2uJ6laA5+AP72ATrMOg3qmUbXaeMfZF7/aoYwxX8EBIqEAV0dEzvrh3
	1gnVrRSjuWHroySbhUCKUNy6ra/3THREIvYBJN3Z55OequCCmm4p1Oqv0JY4NT4U
	xSI9C/Jg6deYA2qADMNKXdfT8iFoAZH11FZm49FB0o3iGmKJiVc9mtIoKzDzA204
	vG1Rx1xg6w/2w+sbbQL/D0zsAHO4QSoNau/eACOINIMWAhTWGXvJCAMEL2H31z6l
	LH03Q==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4fjjf8c8dp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Jul 2026 22:05:26 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 22 Jul 2026 22:05:25 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Wed, 22 Jul 2026 22:05:25 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 3B48C5C68E6;
	Wed, 22 Jul 2026 22:05:22 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v6 20/56] scsi: qla2xxx: Enable set_els_cmds and echo_test for 29xx
Date: Thu, 23 Jul 2026 10:33:37 +0530
Message-ID: <20260723050413.3897522-21-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260723050413.3897522-1-njavali@marvell.com>
References: <20260723050413.3897522-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: u-1QtcAsxLXp5OjTTH6pSHX7G_yvRB6g
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDA0OSBTYWx0ZWRfX6h7JQBu41Xnq
 iyPw3g/3pJsTsWLivMGWqm0bqGhYAv+u+NfhRnBjoSCrQhaG1EmQqKpGmc5tixqwFbCoD2ueGPf
 kfNGHr8SiBjGfLUNeoFhNrcxPUC/9iI=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDA0OSBTYWx0ZWRfXzTk5bBQ25VYG
 B3Dsyo8/ijG3fw0W6+YPLuA6uWMb2xJhNyv2e66cSE0lpW1n1gkWfGP2wa62zubXY1xNpcvWEuJ
 NRov/+gqqgtojqJ74xQ4hPQ3zn5F6qibxF2zJNCv+8u5hywWojSxE6YbiJJzceUMDE0DhyGf14M
 IkRsGc28dQxXdxQUuAYVo4uCtC4mu4ikEkVpsLobx1/ZGfeqOG6qiUDCSDD6LuQ1oLYeP1tvLLN
 AA1P5p1HHVW4Sg392E234EowOLiZ93zJvz/i4iqCWd9OJKbQSab3VcWbPDeVzWPev5dXkTXGkzM
 BGbaJeeJhv7uSrn7YI/sDfxnipjtOKj4Fws0rvJQxgg2uqOrWhRdZdoc6NJGIMMhtWQ0AI2TGar
 3Fb/fdSmHTlTGBxb5ZISMsFJQZMpMUmPoMx9P+eqf0Kwuvl/jUGgoVSViakFtTeDiyrzBj79/oD
 u+iNNZga3Oz6I3Fz7TA==
X-Authority-Analysis: v=2.4 cv=Rov16imK c=1 sm=1 tr=0 ts=6a61a116 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=TtqV-g6YmW1Jfm2GSLaY:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=UohhYlrJZoq7yYDAghQA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: u-1QtcAsxLXp5OjTTH6pSHX7G_yvRB6g
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_02,2026-07-22_02,2025-10-01_01

Add IS_QLA29XX() checks to qla25xx_set_els_cmds_supported() and
qla2x00_echo_test() so that ELS command support and echo test
diagnostics are available on 29xx series adapters.

Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index d195723fc06b..a8dd01cb9a9a 100644
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

