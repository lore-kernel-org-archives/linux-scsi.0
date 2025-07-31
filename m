Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73501222590;
	Thu, 31 Jul 2025 04:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753937086; cv=none; b=rsaXa3pI9vyiH/Yq87Tz+jMzRK0Ori/uVvE7TCy2jP2Y70s+TvZaca9EjEkL4is8DZt64IjM00Q2dXK5Rz2AAkY8Z/kdoVwSCqiNuyeiYnNrlpUJxqWYt7h2jw7N08okj2edSrGSUMwfQmY8p2n3wWvFQbbjD+8FoPdB2O9PvCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753937086; c=relaxed/simple;
	bh=4ePIgsOTx81UCOccPAReoAmWj/7vj6Mb1P9NvTDgchc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aQUdFanoj/diJhbcNHzNyVDYgbImGEmCbJ8sIA/iKKzFdd3Bl0jiX3lfHduC3dSI2zfS+RNWxjlCiggmsuAtlF5+8TLkxsWiWaVQWaZcMjmImHWJFrbCmWIHDdxlP0r1iHoEwx/u72ohuEQkAygHwFGKt+IcfA0Jfj3Af5SWPhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=MCC1v0IW; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MCC1v0IW"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56V2fwJJ031484;
	Thu, 31 Jul 2025 04:44:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=fYzsVtBsMaFfIFd7x+D4NuDkY/l4Y+dzkBUZJw5qAgQ=; b=
	MCC1v0IWRw5IhfIjvwzGkXKvPe0b72HJ7IQHOSAiMFS3YHoyMnDsMTulHN+SobYC
	09wZ8SZJcpWfzUYh28Z3wdnFb1yK2rNuDZSvpy92nYh6AYRqOqsTg2v6GBm2J96W
	8Ug/v0ll+fORtGBtBjN0Bc92hIwhSZBKzQ7LVfb2Ruys1a+nqlZu2EoABAsl61mh
	H/NDhbFKpaIoOD4hnqfMX4xzgymFU0BbO8eA7zGSpAEeDZc910DhfaqseMgrvS0B
	6l2A63pZESBXEPb/ltSoU4sD4VaeOuK3Gtx23iU247bxKF8cgNZbVjeLXOf5hwx+
	npiLJROriad+Sz2YnlKY4g==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 484q4yk9n4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 31 Jul 2025 04:44:37 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56V1Tmdq016816;
	Thu, 31 Jul 2025 04:44:36 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 484nfjb2up-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 31 Jul 2025 04:44:36 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 56V4iX47035411;
	Thu, 31 Jul 2025 04:44:36 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 484nfjb2tg-7;
	Thu, 31 Jul 2025 04:44:36 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Maurizio Lombardi <mlombard@redhat.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        michael.christie@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mlombard@bsdbackstore.eu,
        d.bogdanov@yadro.com, bvanassche@acm.org
Subject: Re: [PATCH V3] target: generate correct string identifiers for PR OUT transport IDs
Date: Thu, 31 Jul 2025 00:44:25 -0400
Message-ID: <175375581111.455613.3596595120583339473.b4-ty@oracle.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250714133738.11054-1-mlombard@redhat.com>
References: <20250714133738.11054-1-mlombard@redhat.com>
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
X-Proofpoint-GUID: yzwk1-O8bSXQSiEX0rPlShJhXOfqVa3U
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzMxMDAzMCBTYWx0ZWRfX6iTwi6qnFSu3
 b2KHez7vJ61vGlZWL6YY7kG6QaFJUwjlZmOleh356A43xXl3WEwe1mRoFCS6xVEomtUlma3U8QM
 x9Z3fxgviudVTDETXzGkcVEXEHbhhfbcpmlGtpOanjrwG1RcYwdG9VUujqkZT5e4Jws4IXyGTTZ
 K3CAiqgRT5MgVuERLxufoJwEFHkSWu4m7m5jw1cw/hR9MYXbXYjPzJZopHSDrgB0BfKqMdZ2EEL
 tnnpMNAy8A1O81ZSv5XOTcCT1n4BordWl/Tv8T8uY85qG1BMck7ZfUqrZPr+7uMyFhc9y6VVkj5
 7iRH9lZ7sajY6Q76sN/hJL7/I8cQ90MV+SUqaM70Emn+XKWFJRxa+45bM113G/4TGwT/1eUO1Ql
 sYNPsGkT9TodgyeTvBJndQrgUsdfGOf1+WtZomahg8ndEYgvaj3jTjIUDK3hgFOj7K/9RWez
X-Authority-Analysis: v=2.4 cv=ZMjXmW7b c=1 sm=1 tr=0 ts=688af4b5 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=VwQbUJbxAAAA:8 a=wxa0T5COSi94SIt-_a8A:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12070
X-Proofpoint-ORIG-GUID: yzwk1-O8bSXQSiEX0rPlShJhXOfqVa3U

On Mon, 14 Jul 2025 15:37:38 +0200, Maurizio Lombardi wrote:

> Fix target_parse_pr_out_transport_id() to
> return a string representing the transport ID
> in a human-readable format (e.g., naa.xxxxxxxx...)
> for various SCSI protocol types (SAS, FCP, SRP, SBP).
> 
> Previously, the function returned a pointer to the raw binary buffer,
> which was incorrectly compared against human-readable strings,
> causing comparisons to fail.
> Now, the function writes a properly formatted string into a
> buffer provided by the caller.
> The output format depends on the transport protocol:
> 
> [...]

Applied to 6.17/scsi-queue, thanks!

[1/1] target: generate correct string identifiers for PR OUT transport IDs
      https://git.kernel.org/mkp/scsi/c/6e0f6aa44b68

-- 
Martin K. Petersen	Oracle Linux Engineering
