Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 723BE156C71
	for <linux-scsi@vger.kernel.org>; Tue,  4 Feb 2025 03:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738640195; cv=none; b=KVC6MftSzg360vUESM73mfDQiyN+O1lyDpQYLFFbFW+jbFaoiy9m2YqSV0fSdA60xV8fwKMywBPd1Slh73foAfCmvB6/K9b9cDbRc5/Y4VO+COHA7SEPLciMdK8Gl+xhdYx7BUydSqi33sWWUmiSwDR0aOgttKjWjlb9AUk839c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738640195; c=relaxed/simple;
	bh=yqhR/uty9W3M8I89VagXMchuSIflmFk/D7y6TMP8BgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z5cviZXqneo14UMJ0NZx3fV4qC8k20nYzmu/K5myVVnHyCoo1cE9nI/glhwZL1TM/wSlksNc5wuqeNNlaK4DdH5/wrly3zbHP4hmtYVAm/SmWaejsnybSqbXmejyL0m2B9B5LgE/w7aQiJ/JFG39MxpiWEqPCF/2XSRFZe8HJOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=SAWqZruA; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SAWqZruA"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5141MvGj028224;
	Tue, 4 Feb 2025 03:35:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=MJZQFjz1JvJEkIxcaUzpcC1IrtBuXyM2E7pzh8dyejA=; b=
	SAWqZruAePerSflIxMOmRSmnQJiYGsAnV4KnTp8l1yCI8fS0hNcCCg4AolkJfNNl
	GmmZGbBBS9Fj0NDWI2zo2ymyqr7d1ZpjB2KBjBXoanI3G9+5pXYLl/u/MsLWR/NN
	Qktg9aPj9LnxyHuRyKJ2TySVJEDAencOV2JGjFaSdq6sG9xgffGvjAHFIXoXFZmV
	4bLotkS9SnLWKUO4m/dBSjqNUq6pdNIpxfj2pWqIJB5+xJmzHuP1/Ws+5cm7qRRj
	zT150d1sRA0Tn5c+T+tTfgjYtS14dVRRP96WpiqoeYsPmos0eLmEpP9iGkQMCnmO
	SGhMhAfVw439COp6ODtTYQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44hhsv41qw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Feb 2025 03:35:32 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5140EmZW038895;
	Tue, 4 Feb 2025 03:35:32 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44j8e76fyf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Feb 2025 03:35:31 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5143VlxK009625;
	Tue, 4 Feb 2025 03:35:31 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 44j8e76fxf-3;
	Tue, 04 Feb 2025 03:35:31 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
        Mike Christie <michael.christie@oracle.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/1] scsi: Add passthrough tests for success and no failure definitions
Date: Mon,  3 Feb 2025 22:35:08 -0500
Message-ID: <173864009026.4118838.4051102904195290794.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250113180757.16691-1-michael.christie@oracle.com>
References: <20250113180757.16691-1-michael.christie@oracle.com>
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=834
 phishscore=0 adultscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2501170000 definitions=main-2502040026
X-Proofpoint-GUID: Uj_yysqiFW_KDwTs0BAyUsPdQ2PZ_YAX
X-Proofpoint-ORIG-GUID: Uj_yysqiFW_KDwTs0BAyUsPdQ2PZ_YAX

On Mon, 13 Jan 2025 12:07:57 -0600, Mike Christie wrote:

> This patch adds scsi_check_passthrough tests for the cases where a
> command completes successfully and when the command failed but the
> caller did not pass in a list of failures.
> 
> 

Applied to 6.14/scsi-fixes, thanks!

[1/1] scsi: Add passthrough tests for success and no failure definitions
      https://git.kernel.org/mkp/scsi/c/b893d7ff853e

-- 
Martin K. Petersen	Oracle Linux Engineering
