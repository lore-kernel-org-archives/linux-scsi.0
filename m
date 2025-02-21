Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4149613A3F7
	for <linux-scsi@vger.kernel.org>; Fri, 21 Feb 2025 03:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740108487; cv=none; b=V4J2q7P5YRJroPKV0SFBfdNIM4E+cN2LfkWcnEzhfP0YOMqAxYDPw9d2zns87XMa8UbIFtwr27QjVfY5he6oo9Ap8TMkmfUVyBtIzKTzCcZAbevt2Ffi9fQnxj63olwI6I6c+FDF3Oo/iUVIJHH/H7BrsHkXct9HtKX4ox0wfCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740108487; c=relaxed/simple;
	bh=mI4IAyXLH3Bhe9Pf/JsrH5D51PtZjJ2eOPlsd1ao+4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=djWlxqOBtY8+doJbL/EEx++WRAExBUGazbXAKas04k3iig8qTWlv8w0tWD7Flzs86VuYez8OCl+cwVVn8A211uPqXCh04qUJMm1faufm6pBjCEsnErBXKNAGNzIFJ1BAMi9f1sPFZZsMBfR4PJQ0ztLwaCjyL35Z/8NShzxYADA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IeSe1DYb; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IeSe1DYb"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51KLrksO014041;
	Fri, 21 Feb 2025 03:27:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=+GnV/s3Yp6zNkg6RCIHa6uvByxq08aNiGZexpoptHAI=; b=
	IeSe1DYbH++w2GQhRIZPWmxtLWf0zOdDddbv4H9zmnC0/g+GqhNqxnZ2PQdu9yMB
	N2E0l0skS4JVWCEOZcBGEQuagWEogqSR2zZIy2LSfAEYI+BtM+GztBgRYXulyCj5
	yWcSHzG2mPURqPTiS/8zSfzY5L7aNxiUhhv4qk1+QQgK+hJJRn0XRdhi8I3TokbK
	AAvPWUxIiUd3KZRHI0MABQedTIvB0NppMv9nl01UVaeE41iIP2Zb1qdeXaXmzqsH
	skt/kJPZs2ztZX2S2VGHH5KgwDTxyn3wbYP86kC6Kspd/V3SD6ySK+5ZMYzMd2xx
	N78Bm/F9VqIz3N2QEWOLcw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44w00nnfpy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Feb 2025 03:27:50 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51L0JGZm025347;
	Fri, 21 Feb 2025 03:27:49 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44w08yu5nu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Feb 2025 03:27:49 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 51L3RmE4001656;
	Fri, 21 Feb 2025 03:27:49 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 44w08yu5n6-2;
	Fri, 21 Feb 2025 03:27:49 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: jejb@linux.ibm.com, linux-scsi@vger.kernel.org,
        Ye Bin <yebin@huaweicloud.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        zhangxiaoxu5@huawei.com
Subject: Re: [PATCH v3] scsi: core: clear driver private data when retry request
Date: Thu, 20 Feb 2025 22:27:25 -0500
Message-ID: <174010841895.1417860.285080719896282100.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250217021628.2929248-1-yebin@huaweicloud.com>
References: <20250217021628.2929248-1-yebin@huaweicloud.com>
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
 definitions=2025-02-20_09,2025-02-20_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 bulkscore=0
 mlxscore=0 spamscore=0 mlxlogscore=999 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2502210022
X-Proofpoint-ORIG-GUID: 6F3CHwirVUSkuHaHzGQDnM9CvkXK9j-Y
X-Proofpoint-GUID: 6F3CHwirVUSkuHaHzGQDnM9CvkXK9j-Y

On Mon, 17 Feb 2025 10:16:28 +0800, Ye Bin wrote:

> After commit 1bad6c4a57ef
> ("scsi: zero per-cmd private driver data for each MQ I/O"),
> xen-scsifront/virtio_scsi/snic driver remove code that zeroes
> driver-private command data. If request do retry will lead to
> driver-private command data remains. Before commit 464a00c9e0ad
> ("scsi: core: Kill DRIVER_SENSE") if virtio_scsi do capacity
> expansion, first request may return UA then request will do retry,
> as driver-private command data remains, request will return UA
> again. As a result, the request keeps retrying, and the request
> times out and fails.
> So zeroes driver-private command data when request do retry.
> 
> [...]

Applied to 6.14/scsi-fixes, thanks!

[1/1] scsi: core: clear driver private data when retry request
      https://git.kernel.org/mkp/scsi/c/dce5c4afd035

-- 
Martin K. Petersen	Oracle Linux Engineering
