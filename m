Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4D671FF1C7;
	Fri, 20 Mar 2026 02:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773974227; cv=none; b=XjqDkPNvuTz2U0t9hvLGD2USD5lOwG90NOyjQLeSk2n7O+5igEMhGerZp6y3aLEL6miNoDxD4lnqXzKcPx+j/4/bQh0vR53Rt7v0/zL4ZLfoMbqjcMVs2MBsSWf+qCMyAP9DxualBYO+n2w3xDow0IKDLIR4yf/Tt+b1s+FtS8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773974227; c=relaxed/simple;
	bh=RssIeHhVbvBpdoBKs8o38zT+df3pz8geSBV2NPAL4dE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YqWiSNYQF2QcSgr+cQESsjSoU57fhkjlVWtK2Y9EruFEYaeusaov0WIPz9dPMuy9VxMn07XoqazpvtPVrn4gtgYyfwgd+JCNvaI+/p/vr3ahbzA3C9gGufpoXWAqrCxVsGUORausGlDtTcaaqRKMmDHDeS1NzGbGmRJjtK2djnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=oR/uqy1l; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oR/uqy1l"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62JFpE9R313531;
	Fri, 20 Mar 2026 02:36:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=w1Gk0oESh7NdIUQp7mbqUwqsOc9aBJiU/lM2AKx0YME=; b=
	oR/uqy1lnQko/MRfBJPSNoO5AIpZbyw61+DoXKMmlnzlGL4VqOAc742h0XTXLBKv
	0nrAPUVmvomw3KjGLO27YOq/e/9tf8XQAvrWX8SFI2ZNSPDmJ8Qaqj4c5TxXAcat
	xJJrgZFDRefz+tZIFyTP3WW2h67UNMC68UyMFuCjqfnKEqW0ufG2YFtHTHLDL1sZ
	R1pti3dPHBloSaOpIbLW+o9xzLnUXosb77YjFbuY0y/rY7ToOfVt4TR9wkXHDmP+
	3nUNnz0cs7eYVgfQ9E9E2sM97G72o0ri6xvgY4QcmUvZraw82xeJrV4ONDp1/+5c
	LSPgsnYr6fN3FMpzNepAAw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cvy9s0sgs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Mar 2026 02:36:14 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62K0BXMG001131;
	Fri, 20 Mar 2026 02:36:13 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cvx4dp7by-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Mar 2026 02:36:13 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 62K2aDRJ020555;
	Fri, 20 Mar 2026 02:36:13 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4cvx4dp7bq-1;
	Fri, 20 Mar 2026 02:36:13 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        stable <stable@kernel.org>
Subject: Re: [PATCH] scsi: ses: Handle positive SCSI error from ses_recv_diag()
Date: Thu, 19 Mar 2026 22:36:00 -0400
Message-ID: <177397393944.2929898.5492898463128783556.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <2026022301-bony-overstock-a07f@gregkh>
References: <2026022301-bony-overstock-a07f@gregkh>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-19_04,2026-03-19_05,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=749
 adultscore=0 phishscore=0 malwarescore=0 suspectscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2603050001 definitions=main-2603200019
X-Authority-Analysis: v=2.4 cv=X5Vf6WTe c=1 sm=1 tr=0 ts=69bcb29e cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=VwQbUJbxAAAA:8
 a=tzoFckrENWJE1e--0mkA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzIwMDAxOSBTYWx0ZWRfX7M9E62M15Tyq
 LXzTbd0kEwLtbDbSulkf44QyOgL88HWOhKLKVtRTevSBnxQUzTMRRCjtEEvE3h16JBFIMJ9/01S
 b9eD86mxtqqHf0NcBvz7jFSxcokpiX6gou8kWg5tUv5mx8hoAC70A+59owwccaDHF4tt4XDF22u
 VviVVD1/zqpy2orPjDCqNtZk07KraunOULsCSxlkXy1s8EKASP5cxoUBsk8xLXK5++DKYwhdA9J
 QktIpA3wFl7tFXd5M8tlT9njJ16CBZ6q4uosqhgj2O2xCVl9HsjN9XKDt2b3Cp4igF+XJYTf1pF
 I/iS37tLmMzzKopGOGEn/AshH23Pxgfd3+TAV3BIEFF3DRbPegKXOMddFXaiqXArWaRQcvb86CU
 doNZ4EGD+PECTxv9uezasW+FazpQ4l+MPJE8UZY9NGklKpRdek6JwjLJ+vSj27S6kik4sPq3l4Y
 1tloiDn3B47SgIHOWoQ==
X-Proofpoint-GUID: n-1q0_Zf3pkcFsago0eYtIRG2cqTE_dA
X-Proofpoint-ORIG-GUID: n-1q0_Zf3pkcFsago0eYtIRG2cqTE_dA

On Mon, 23 Feb 2026 16:44:59 +0100, Greg Kroah-Hartman wrote:

> ses_recv_diag() can return a positive value, which also means that an
> error happened, so do not only test for negative values.
> 
> 

Applied to 7.0/scsi-fixes, thanks!

[1/1] scsi: ses: Handle positive SCSI error from ses_recv_diag()
      https://git.kernel.org/mkp/scsi/c/7a9f448d4412

-- 
Martin K. Petersen
