Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5FE9328B60
	for <linux-scsi@vger.kernel.org>; Tue, 21 Oct 2025 09:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761037451; cv=none; b=OVIG4sCDuN01QedF00+dg7bglhibgTN42gST1RTnGols1iakkxkyCyib5NcAvy0xlxSqTFunRoqxTQO1qgLKKBPcob0PW0jGVRN3ESaWcX81l1X7aAqb4mzPWSint1LYR0oxGLT+GxlsNo4jikEhrzLyGQkEId7tHoAC6x19VBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761037451; c=relaxed/simple;
	bh=bCeNdLTBRxMqsPFj4rM52R+pn7iSnYsbKA8vcgSIk9o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sInvoGoGh7TfMcAr65ga2KKW2ZU3eEQEjEocelUGk64JbRtpsTviyY5f5H2JthnOX901lCCE1CwmCRCS3gba5skw/i5bTAfpZvfDf44gUkFdKYHSS0oYT8+KnnVquBTa4FazphdsvD8gYnzCF/kPlD2T4VBKK4S+EftMY7Y70xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bXd5uZH9; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bXd5uZH9"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59L7uV7U021080;
	Tue, 21 Oct 2025 09:04:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2025-04-25; bh=sC591/Oj8ShPzyoQ8/69A0Ck1uPDi
	a6mGUhI81SDGpw=; b=bXd5uZH9hjJMDNWe4qJPCzbUUNljX9FwcqjASUs3aWiaS
	M7ePcgKB+6WsZDx9gEHEB02HEwDXx0A3L3HTAvYkkgSwA7OLf4R8XyZ1O5I6Uitt
	4XHDXyNUVOkyHl/HzTeSlybUdfFjBOcI71GY7bAgyRuXs17PIZgVPPSb75VtAIEt
	X5AD/vqWfM1i6ITwJxqlK1sC1SFBBWUpkbOzeo2KlAM/AJgUf38NL5nQAmltDP1Y
	1J/8+1W+VBnLHPbbIC+ny6IvzFSVIBdCjzbJW46XaF3Rlh/h5m0rJ2WNFSsoeLb8
	dp+7NwP3EeToQn/D4KOIv5r2UgRzmgGjGA55nuUkg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49v3074ebm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Oct 2025 09:04:04 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59L727qb013779;
	Tue, 21 Oct 2025 09:03:57 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bbmmm8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Oct 2025 09:03:57 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 59L90lEa017673;
	Tue, 21 Oct 2025 09:03:57 GMT
Received: from ca-dev112.us.oracle.com (ca-dev112.us.oracle.com [10.129.136.47])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 49v1bbmmkh-1;
	Tue, 21 Oct 2025 09:03:57 +0000
From: Alok Tiwari <alok.a.tiwari@oracle.com>
To: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com,
        njavali@marvell.com, mrangankar@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, linux-scsi@vger.kernel.org,
        alok.a.tiwari@oracle.com
Cc: alok.a.tiwarilinux@gmail.com
Subject: [PATCH next] scsi: qla4xxx: Use correct variable in memset for clarity
Date: Tue, 21 Oct 2025 02:03:52 -0700
Message-ID: <20251021090354.1804327-1-alok.a.tiwari@oracle.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-20_07,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 suspectscore=0 spamscore=0 adultscore=0 bulkscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510210071
X-Proofpoint-ORIG-GUID: tXiWf45us0jg2ybJsfOEl3A0buoLzx36
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMyBTYWx0ZWRfX+jgnPUCg4gzz
 Xs1WkO9hG69UcZ7PR49WD5m/+/U0TARL6tb+TRftS/apHkZouwNaQ+RZ4Dq+R3iw7WTrhrB4S9W
 6fq0Gs3Px7ZrQv7DId0RKmIyC6ArHKfvXneWNTITQ0sfYfqrsBzSitzczCCEfWogcB0b8Q2ylBe
 f4VIBNJCkE956uQzuCeCfF1F3lD+cPy6rBR4ZLW1KoWVUXgXQsegB3mj0nJQLunLbxxF8c3fRqi
 6gFX2LwHeB0ra11LDLTlYnDxeZSRXy1CYSNrZ7eP3VGyh2iLt4GZfbXRWehOT9spwSJ8bF+Ib9L
 U7aN/+zykCZVGS5xSORyWXYeXskwi4Gh4iVxKQSJwAZa3JbQPTZtHBnR2aC8ZxF4+1Sf/dXnNii
 iskOwbz8ZHjsEDg52nN2bWj5/mtdsg==
X-Proofpoint-GUID: tXiWf45us0jg2ybJsfOEl3A0buoLzx36
X-Authority-Analysis: v=2.4 cv=csaWUl4i c=1 sm=1 tr=0 ts=68f74c84 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=ClOKymlBMIXVmhuFdJgA:9

Both mbox_cmd and mbox_sts have the same size, so using sizeof(mbox_cmd)
when clearing mbox_sts did not cause any functional issue. However, it is
misleading and reduces code readability.

Update the memset() calls to use sizeof(mbox_sts) to make the intent clear

Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
---
 drivers/scsi/qla4xxx/ql4_mbx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index 75125d2021f5..7febc0baa9d6 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -1016,7 +1016,7 @@ void qla4xxx_get_crash_record(struct scsi_qla_host * ha)
 	uint32_t crash_record_size = 0;
 
 	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
-	memset(&mbox_sts, 0, sizeof(mbox_cmd));
+	memset(&mbox_sts, 0, sizeof(mbox_sts));
 
 	/* Get size of crash record. */
 	mbox_cmd[0] = MBOX_CMD_GET_CRASH_RECORD;
@@ -1099,7 +1099,7 @@ void qla4xxx_get_conn_event_log(struct scsi_qla_host * ha)
 
 	/* Get Crash Record. */
 	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
-	memset(&mbox_sts, 0, sizeof(mbox_cmd));
+	memset(&mbox_sts, 0, sizeof(mbox_sts));
 
 	mbox_cmd[0] = MBOX_CMD_GET_CONN_EVENT_LOG;
 	mbox_cmd[2] = LSDW(event_log_dma);
-- 
2.50.1

