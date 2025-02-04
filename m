Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2ADE17C219
	for <linux-scsi@vger.kernel.org>; Tue,  4 Feb 2025 03:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738640048; cv=none; b=HEszJoKe9svJoTKLlSwJn7n5BM7IFaVXkCIkdL9v6Hjmb2GveUSU+5kniY8G+97UsB15+jfLz89F1i++WEQ7Vub9D+G4y5fGOOgugp5czJr+7se7kSfKwh5EvWYDLhGWYEwbWS/nT4wrIxElqsA0JusK6JlXwU0sCj7Bpusyla8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738640048; c=relaxed/simple;
	bh=bRLM6p0CNUIPWiAWxUdXod3cUhnm1K0tIPJBNATBtXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TH8GgqOFvfr5bIq/eJGWzD7dckG/RXdtPvsPnsFpwezsiSL4axB0eKI1FOgSTmVd2yxMIbhaWEKGYu61QO2KUIxZ/oWuAcQdsoN2NEnB0dKLOPbtvCeDHyIGHk5PM5sZ+iixovUlEkck7d6NBYQnRYkn6gLT4sl67IWThZ3x5gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=YaMFRJfe; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YaMFRJfe"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5141NOqp008628;
	Tue, 4 Feb 2025 03:34:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=vhrVGqePNZvqZzwdrfY5x0TSVVEGomMra2RZ91XAMCc=; b=
	YaMFRJfe+lfQcanqne+8buF1oRzT+alykLr/cXg97+ZWR630msoWZ7X9F5uvVUnV
	1LI4ZuZ23j/ZUG90XMM+R02SwXAqyV1tePTi/gSTrrJ/p4hpDD5qzfg3dWd7Lbnt
	BcLjoTxWhbqZ1A9WGMDhaZQvaDy966iC8iZnsyFSGVGPyKcbgJvbwXXd6KvvMGJi
	jo4r3V20BaCnmoB5soSv4ZPnDv/b0zkVWXLwjSSrYBWezCPjBoZSusndoOATSdWC
	qmtYXPoeMgtOs0NRYlVtCXrAUpWTsDNM/Ua3ki8wBn1BFNFh2QAz45zUFEK5zjDG
	fbFTScsvEsDe03APdvKXEg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44hfy83xtc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Feb 2025 03:34:01 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5140a4rE039034;
	Tue, 4 Feb 2025 03:34:00 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44j8e76f1p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Feb 2025 03:34:00 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5143Xs6u015172;
	Tue, 4 Feb 2025 03:34:00 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 44j8e76ex2-6;
	Tue, 04 Feb 2025 03:34:00 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, Seunghui Lee <sh043.lee@samsung.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] scsi: ufs: core: Fix error return with query response
Date: Mon,  3 Feb 2025 22:33:09 -0500
Message-ID: <173863996290.4118719.17998886860886629623.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250118023808.24726-1-sh043.lee@samsung.com>
References: <CGME20250118023817epcas1p1a7cb68709776f01c5ebeeb02908ed157@epcas1p1.samsung.com> <20250118023808.24726-1-sh043.lee@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-04_02,2025-01-31_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=996
 phishscore=0 adultscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2501170000 definitions=main-2502040026
X-Proofpoint-GUID: Vvy_EW0lD6lQU5sN_Ftj9LufdyGC3iO5
X-Proofpoint-ORIG-GUID: Vvy_EW0lD6lQU5sN_Ftj9LufdyGC3iO5

On Sat, 18 Jan 2025 11:38:08 +0900, Seunghui Lee wrote:

> There is currently no mechanism to return error from query responses.
> Return the error and print the corresponding error message with it.
> 
> 

Applied to 6.14/scsi-fixes, thanks!

[1/1] scsi: ufs: core: Fix error return with query response
      https://git.kernel.org/mkp/scsi/c/1a78a56ea652

-- 
Martin K. Petersen	Oracle Linux Engineering
