Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D0692036FC
	for <linux-scsi@vger.kernel.org>; Tue, 15 Oct 2024 18:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729017593; cv=none; b=joCytwKMPMR7e8GVlyu0BMCSMuGFTQVOnLL3pl9+Oa9i1XN5bnXmt2xAVC21j3h8WCTyNLVX0F3PGqtod23mQ6R5lVb1Z8+uDPIDITC74al6PaEMeTfo+5Na4e9/5EpNPjgWcPMoAa4p7t+X6+hWLdpkL+1wm97pc2e+fvpB3F4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729017593; c=relaxed/simple;
	bh=bTZh3gqCNjMtw7gFqvtDiit7/x5TDjdft6gmr51xsO4=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=uU3VYv+FXfGQTy071l3UKebBc/VjKz6NH/1tbGjse/33AG+ZZntNUWLq68rSr6QbdoDrKLqCdK07HCEgsabna4BPNiFNWLZ1G/OEo0huqqGbxR+/TMlOln0rp0OhwXLZRYBcjJoifVNmQ4PdMyIg6HcbukUZ5NUZDurLvqYvAi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=fn401lH9; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fn401lH9"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49FHtf2l008297
	for <linux-scsi@vger.kernel.org>; Tue, 15 Oct 2024 18:39:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2023-11-20; bh=6ZlEYuWYbY23JPfS356/F2i1VULgU
	hMYZshJa8mKPAg=; b=fn401lH93wlE8N9/mLZb+hY+O/qBJc9VTHqTe6MbYXwcJ
	Mm6y/KRTEab+DEj57482aNahR96gh6PF2KihmKnHcQHb3D4AlpItECR33v6LEebv
	Q7alV39ZJCru7fZaeAQJli6nolsvSZffYLz5nGwEWRDsDjq5NX8QuRFnT9Yvogrl
	2jZ6RAvJauJ9pzxnhy07ZV0ni18Y/U4wbcQYSQY+VjC1ZetBevOu5WwihnLEhiSj
	sAUUue+3kRv8pldZsYkinWNxkPsmmAAcLCLm0QPEw2shVLqccAFI0LTUr189Wvij
	1CRXDC2YECiRaXSLYZoX4/eCGGcocWk74LAiim71g==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 427hnt9ykp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Tue, 15 Oct 2024 18:39:50 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49FH04Cf010433
	for <linux-scsi@vger.kernel.org>; Tue, 15 Oct 2024 18:39:49 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 427fje56g2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Tue, 15 Oct 2024 18:39:49 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 49FIdmh1004669
	for <linux-scsi@vger.kernel.org>; Tue, 15 Oct 2024 18:39:48 GMT
Received: from hmadhani-upstream.osdevelopmeniad.oraclevcn.com (hmadhani-upstream.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.255.48])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 427fje56fq-1;
	Tue, 15 Oct 2024 18:39:48 +0000
From: himanshu.madhani@oracle.com
To: martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: core: Remove unused host error code strings
Date: Tue, 15 Oct 2024 18:39:48 +0000
Message-ID: <20241015183948.86394-1-himanshu.madhani@oracle.com>
X-Mailer: git-send-email 2.41.0.rc2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_14,2024-10-15_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 adultscore=0 spamscore=0 mlxscore=0 suspectscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2410150126
X-Proofpoint-ORIG-GUID: zWEeR0wxlchTEO63C222VtA5Qvber6V7
X-Proofpoint-GUID: zWEeR0wxlchTEO63C222VtA5Qvber6V7

From: Himanshu Madhani <himanshu.madhani@oracle.com>

commit 68a3a9102a689 removed unused host code but
forgot to remove them from the corresponding
hostbyte_table[].

Fix it by removing unused hostcode strings and add
missing DID_TRANSPORT_MARGINAL string.

Fixes: 68a3a9102a689 ("scsi: core: Remove useless host error codes")
Signed-off-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/constants.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index 340785536998..b74c3f505300 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -403,8 +403,8 @@ static const char * const hostbyte_table[]={
 "DID_OK", "DID_NO_CONNECT", "DID_BUS_BUSY", "DID_TIME_OUT", "DID_BAD_TARGET",
 "DID_ABORT", "DID_PARITY", "DID_ERROR", "DID_RESET", "DID_BAD_INTR",
 "DID_PASSTHROUGH", "DID_SOFT_ERROR", "DID_IMM_RETRY", "DID_REQUEUE",
-"DID_TRANSPORT_DISRUPTED", "DID_TRANSPORT_FAILFAST", "DID_TARGET_FAILURE",
-"DID_NEXUS_FAILURE", "DID_ALLOC_FAILURE", "DID_MEDIUM_ERROR" };
+"DID_TRANSPORT_DISRUPTED", "DID_TRANSPORT_FAILFAST",
+"DID_TRANSPORT_MARGINAL" };
 
 const char *scsi_hostbyte_string(int result)
 {
-- 
2.41.0.rc2

