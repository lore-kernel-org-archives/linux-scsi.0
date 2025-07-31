Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAF4D24110F
	for <linux-scsi@vger.kernel.org>; Thu, 31 Jul 2025 04:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753937083; cv=none; b=WFlji1l4rcPQIF83BWIsy7eXX4xieLx8emmprRV9fU9usiNcx+dcpgo9FAsORFuOPRBrxsa7W9A89q0Ya1zEIkiN24IgzDZ023bNnCxV6BlIlRVPi5hVfnITK+SXxpuNOPTCxQWjViwxwq1AdiFTFWlkjBlq+6MmZe2yrNGzbpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753937083; c=relaxed/simple;
	bh=NLkyrzstVIcBF4ypLeXw/ovkjTWN+X5dQrVseo+5nHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AeCkZ+HFiQlJFtu5aXGdQUmGHFu60rF4W0b3JDKZrK9W4GxG2tuUUJCbyxX4jvjTYrRJNqYFBcvYcv7hqij2UrKZDGGcaonvMcPTWzEMGhoVj5cS2BU+dTy7LB9tpF7g38GH0HO4QUVk63DXG2axCUBklQH7X6QdFSWyIxkgFl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=HIYTJxdc; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HIYTJxdc"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56V2fwwB021472;
	Thu, 31 Jul 2025 04:44:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=QWtCz9JDHl5UYfuHu4YfYQW4q8JOaN+skjadmYjVFAE=; b=
	HIYTJxdcwamDFICMPwOkN9Hhc1Jy+G7WwCmqX9QznV4r63vItSUR88GRknUz8Va7
	ICNDaY5vFKD1Q/alqzhEVM153Oc8XQoV5nLhEt6Uy7EvuDUB6cbRIfBZJC1+mLOa
	6ZHg7v9McjNOitE+ffBnRxMf0SZis/joi35u7idthXHj0XdzkAtE0b6Not0m8Tha
	/P6KUPPiEj+wRyJ8/CmHE3yzLihxAlMunJSfDiFC2wsfjrT0fzstWs5qh6SUVgR+
	QV/97C7k6eu+7NFwcqwflGmbi/kkN9X9nUo/Sf0sXgDbKB81veNXyjjOvCwb3vfA
	1iqHGFIzHv0RfdlHsrSL0g==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 484q733bd7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 31 Jul 2025 04:44:38 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56V149PB016739;
	Thu, 31 Jul 2025 04:44:37 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 484nfjb2v5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 31 Jul 2025 04:44:37 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 56V4iX4B035411;
	Thu, 31 Jul 2025 04:44:37 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 484nfjb2tg-9;
	Thu, 31 Jul 2025 04:44:37 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        rajsekhar.chundru@broadcom.com, sathya.prakash@broadcom.com,
        sumit.saxena@broadcom.com, chandrakanth.patil@broadcom.com,
        prayas.patel@broadcom.com
Subject: Re: [PATCH v1] scsi: Fix sas_user_scan() to handle wildcard and multi-channel scans
Date: Thu, 31 Jul 2025 00:44:27 -0400
Message-ID: <175375581119.455613.10576880936642116391.b4-ty@oracle.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250624061649.17990-1-ranjan.kumar@broadcom.com>
References: <20250624061649.17990-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-31_01,2025-07-30_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507310030
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzMxMDAyOSBTYWx0ZWRfX+6GsXE16tig0
 kurXV4G0GnDj4dz2P7GxkZQtdSylz7YwkV6WaZpLUFvSRzlhv341fuquv4gYFSTUThdUCXQP8R8
 BDCYfJze7wwef/M10CA5tzc35cl6pKZxYX4TaT5Nh3jzpa+pHtXryNO2N7nAxNrfQOzr40KWUJy
 rbWlV5IMigiHSvPkromuI6wsKeqMNz9kkq09scfyGUeSYMkrj7T4oFrtC08mmyOyTtMJPMCQIZP
 w+0OKF9dAryZg452j/ZcwfEdPf0kdjOZO3V9vTCmmUdL1jSuA3FBjNkdnW5b6Xg8fEwLzwZ/fQM
 sigoeHntWqJcdXWL/Y2wK7UXwLaHieEvuj3Ccn8L5oJfpqYRXmE+F8ASzl67JDWpZC7J4ajTmZA
 qGuRRguOAo0zTf7EazJ/daJxMdBvu2U7WZccYe/pY9fzy0NQi8uz7jNb25PUfMHBgLr8zMYO
X-Authority-Analysis: v=2.4 cv=ZO3XmW7b c=1 sm=1 tr=0 ts=688af4b6 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=VwQbUJbxAAAA:8 a=IVqxFDQYhgF-jG3GFIgA:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12070
X-Proofpoint-GUID: kErO0Oqg67k7B9S61Q_FtCRnzRcUiu5o
X-Proofpoint-ORIG-GUID: kErO0Oqg67k7B9S61Q_FtCRnzRcUiu5o

On Tue, 24 Jun 2025 11:46:49 +0530, Ranjan Kumar wrote:

> sas_user_scan() did not fully process wildcard channel
> scans (SCAN_WILD_CARD).When a transport-specific user_scan()
> callback was present.Only channel 0 would be scanned via user_scan(),
> while the remaining channels were skipped, potentially missing devices.
> 
> user_scan() invoke updated sas_user_scan() for channel 0,
> and if successful,iteratively scan remaining
> channels (1 to shost->max_channel) via scsi_scan_host_selected().
> This ensures complete wildcard scanning without afftecting
> transport-specific scanning behavior.
> 
> [...]

Applied to 6.17/scsi-queue, thanks!

[1/1] scsi: Fix sas_user_scan() to handle wildcard and multi-channel scans
      https://git.kernel.org/mkp/scsi/c/37c4e72b0651

-- 
Martin K. Petersen	Oracle Linux Engineering
