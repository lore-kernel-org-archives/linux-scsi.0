Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BCB946BF
	for <linux-scsi@vger.kernel.org>; Tue, 22 Jul 2025 03:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753156062; cv=none; b=XEKNkrf3y3+AB8J6vJLvG+XQvCoPZXeEOh47zdCt9HvT+rTC3WZggwmm+k3Wq7zTjSGaf71GzVtPX5XQXHlFEu/oyAizgJxezWYNwDMqVcmOArWQYqERvG/eplsrv6juB81crwBah2HZ7+p6qUojtWZiuRzvlLdfRwcKrgbJl90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753156062; c=relaxed/simple;
	bh=XW5ATPvmYjw6IOb3lPPKeNlDSkXOl9b6ztOaINnJceA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QNH+13KXpu79YhTJHietypDVZgTbcerSs7XwCGKqCxX8QTnV7/1NoftUbMIQJ1/b1O7f/S4A3RQ4d3UrVrqk3+kxxEIKCRucKi1tgb5Ijf6wOP4WCN58jHjKI61ktj6NU71f40c62mg+6Qtu2AbVrt39D3hAE4zt6fEczanPB7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=lVr3liui; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lVr3liui"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56M1Ca7H020462;
	Tue, 22 Jul 2025 03:47:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=CWjcEG7EG7/o5RhE9gsd/REDMMSnkegd4eQn4OmJWJQ=; b=
	lVr3liuiyjtVQBbWtfTQCRhx8VSfxP6LHHtgKYXX5bG4OCMqIwrTRNizzahsl8pA
	0f01BxWrNvFBUgXYIAtFBXqfnJ7wAEU/+K3XC+w0wYZL8eYCplXoWBdydQh25jQt
	B6SVLp9HcXBAOY9mst78PLl8kUFxA5KytmVwwD9JTJdVw8o9U77gxzLDngAWvXQy
	3JNWOYxbUr9rFgGtJ5lGbEZyf4Pp0wAninNSxP3q1+Ig2xpw79XL24BD8k6GZ0FA
	7xjaTLt0gg1GGn0Cxao4oy88n7CVVqhO8OiBdGdJrX8cycxMZVsfLZ8X6WK/U2yi
	VU/Lg/YHHzDcYDS5hgt9AA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 480576m5vr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Jul 2025 03:47:38 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56M1dc96038427;
	Tue, 22 Jul 2025 03:47:37 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4801t8te9x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Jul 2025 03:47:37 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 56M3lZj7031915;
	Tue, 22 Jul 2025 03:47:37 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4801t8te8u-5;
	Tue, 22 Jul 2025 03:47:37 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, "Ewan D. Milne" <emilne@redhat.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: scsi_transport_fc: Change to use per-rport devloss_work_q
Date: Mon, 21 Jul 2025 23:46:58 -0400
Message-ID: <175315388531.3946361.15807029882877097653.b4-ty@oracle.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250707202225.1203189-1-emilne@redhat.com>
References: <20250707202225.1203189-1-emilne@redhat.com>
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
 definitions=2025-07-21_05,2025-07-21_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 suspectscore=0
 bulkscore=0 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=843
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507220028
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzIyMDAyOCBTYWx0ZWRfXzqlT2fiBaQwk
 uMwL45mcV6PJtxRgHpyuPROuzlXK2meLjssvxfjkhNA2RjCt2MxOCRRExfhXxkPRV3fPRWd1q9a
 LhURjI07ht9yPFpeBO4wravFzJc6F18MVvIE7TLXTnuwxhQUJlWvS3+THcBWFD+zP/JQJN/EOzm
 2vLsdrkUVu9VV4fiDQ8vNje2aeSCa95hoBd24jwRVEa0zWoHXn4Xe2CvjeWa6phadW8KMv6vB15
 XLgjtAnkePpDuqvb1nqeC8sBaPIRuZ+OLd9JkpDSju6mUeEvIS37ivsHulHwa81yUZrVlqqtmxZ
 rOJk3a35jRxKzuJ0hWc9HMo1lblPLhr+ZxvNZmjNj6okMdxrV4MZV/rRgJSOc/FvOc7m+F3dpTW
 tB323CBhSzzio6dZh3l3tHrEe4SyiqwALZ0t9Nrjzq5nTXTPL3wF13/ZRmqSye1aRJPB0rzr
X-Authority-Analysis: v=2.4 cv=doDbC0g4 c=1 sm=1 tr=0 ts=687f09da b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=VwQbUJbxAAAA:8 a=6nEJLLgwpvFBk0gHnXwA:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12062
X-Proofpoint-GUID: EFJzS2dgrqBJlyl4h6EBAV2HybN1JtIU
X-Proofpoint-ORIG-GUID: EFJzS2dgrqBJlyl4h6EBAV2HybN1JtIU

On Mon, 07 Jul 2025 16:22:25 -0400, Ewan D. Milne wrote:

> Configurations with large numbers of FC rports per host instance are taking a
> very long time to complete all devloss work.  Increase potential parallelism
> by using a per-rport devloss_work_q for dev_loss_work and fast_io_fail_work.
> 
> 

Applied to 6.17/scsi-queue, thanks!

[1/1] scsi: scsi_transport_fc: Change to use per-rport devloss_work_q
      https://git.kernel.org/mkp/scsi/c/25236d4844ad

-- 
Martin K. Petersen	Oracle Linux Engineering
