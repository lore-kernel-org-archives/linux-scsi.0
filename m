Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ABD3136A
	for <linux-scsi@vger.kernel.org>; Fri, 26 Apr 2024 02:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714096862; cv=none; b=mfSsbO/G22667BbsKL5FyYlRhihCJBGDLfs/6omQjGLoR3RgGfv9i7WTdNzsSagCdHMtpbRrv7pPGhOh9PpOzsqh2Nx7pY4cLl8MsW7ruiZIVSHBxjeOJ0MEQMYnfE7CRHFmilYs4ZiEEYiQbiFhVH0cpywbacFv2XVXp5RRQus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714096862; c=relaxed/simple;
	bh=GQfuH5YTSGhHallDCU2fAesfsmKI6zWPza9fM9rj8WM=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=AUkPM8BYQsAR/oxi0WVkSJGpWtMxtOxIZ61u2/oOmBvBc0pQE+lZYnW7Pv4eyrkfdh9VHbBh20oGwhTEWiVyn/PM8Ykhi74PmjsOZzuGMc9YGCxenaajKqqFc1fUuXklNqVBNy96nemAHWbsWyS/6uT+HiIOiJ0XVxO35QmTcCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ftagARx0; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ftagARx0"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43PKr798009048;
	Fri, 26 Apr 2024 02:00:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : mime-version : content-transfer-encoding;
 s=corp-2023-11-20; bh=c13dEa2aprHDGTV6QJiaJjcK0eFnUNt3FKwbyLGwYCg=;
 b=ftagARx08W46gmsVA1q2rWIBZskrlNu7bjNNM2RVtaKuoXy1boKsSfEtwNJ9BDOMLr8w
 mKLI3APOLAE7iPkMuhiOv6FKUTlfOtQGw2QG2RfvbTlp4gq1HafhRwLe1fv20CX5R0NP
 4LyHb1xDHjBsTr6zIcmcgH1joQ2IhB0Fw/lCuDyk9yB/pJsO68uiwIQakxIipol8q3fo
 tLsCMJ5G3W6EoZqMuUAW4PIq0zUvB+ZHeRIKNXNwmIJ5m5gWGZlVBkNvnGSELFa3loUo
 t44z8V8sWyba7uOeNLPRtUhEPobQabsvMhpjmMdRABkuf8rkexujIS4MgWLgtcLQQ9tR EQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xm44f4ccf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 26 Apr 2024 02:00:58 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43Q023ak030866;
	Fri, 26 Apr 2024 02:00:57 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xm45b616w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 26 Apr 2024 02:00:57 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43Q20vrQ002527;
	Fri, 26 Apr 2024 02:00:57 GMT
Received: from hmadhani-upstream.osdevelopmeniad.oraclevcn.com (hmadhani-upstream.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.255.48])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3xm45b616b-1;
	Fri, 26 Apr 2024 02:00:57 +0000
From: himanshu.madhani@oracle.com
To: GR-QLogic-Storage-Upstream@marvell.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH] qla2xxx: Fix debugfs output for fw_resource_count
Date: Fri, 26 Apr 2024 02:00:56 +0000
Message-ID: <20240426020056.3639406-1-himanshu.madhani@oracle.com>
X-Mailer: git-send-email 2.41.0.rc2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-04-26_02,2024-04-25_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 mlxscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2404010000
 definitions=main-2404260011
X-Proofpoint-ORIG-GUID: IEYAs-sm-M3FUb3MnfcVdtJ8x0AYxcOZ
X-Proofpoint-GUID: IEYAs-sm-M3FUb3MnfcVdtJ8x0AYxcOZ

From: Himanshu Madhani <himanshu.madhani@oracle.com>

DebugFS output for fw_resource_count shows:

estimate exchange used[0] high water limit [1945] n        estimate iocb2 used [0] high water limit [5141]
        estimate exchange2 used[0] high water limit [1945]

Which shows incorrect display due to missing newline in seq_print().

Fixes: 5f63a163ed2f1 ("scsi: qla2xxx: Fix exchange oversubscription for management commands")
Signed-off-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/qla2xxx/qla_dfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_dfs.c b/drivers/scsi/qla2xxx/qla_dfs.c
index 55ff3d7482b3..7375d00fe30f 100644
--- a/drivers/scsi/qla2xxx/qla_dfs.c
+++ b/drivers/scsi/qla2xxx/qla_dfs.c
@@ -274,7 +274,7 @@ qla_dfs_fw_resource_cnt_show(struct seq_file *s, void *unused)
 		seq_printf(s, "Driver: estimate iocb used [%d] high water limit [%d]\n",
 			   iocbs_used, ha->base_qpair->fwres.iocbs_limit);
 
-		seq_printf(s, "estimate exchange used[%d] high water limit [%d] n",
+		seq_printf(s, "estimate exchange used[%d] high water limit [%d] \n",
 			   exch_used, ha->base_qpair->fwres.exch_limit);
 
 		if (ql2xenforce_iocb_limit == 2) {
-- 
2.41.0.rc2

