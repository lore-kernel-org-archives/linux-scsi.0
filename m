Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F07031DF980;
	Wed, 28 May 2025 02:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748398862; cv=none; b=YMEeanHE+7hyTe1acL11yhlmjxiG/BDdHpPO3wEr1Z/O0UGTM0QrlzNiQXNeKt4jazZFXJsnYps/YN8a0Y56iMCOBVcHa+xLyZ07jrBTabNdFMpBBnkXOYvpyiqvt5Mm5kUB6zCQOIQfKZrjg9AZLrD0QiLFSTPAAsYDLUM3mDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748398862; c=relaxed/simple;
	bh=T3R5hl5OqwlZWGCC6jYE7Z1yOXRC9dicdJ7b+ks2qvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TJCdOFm+vc4nOBEhYg4EZeJfdBJRiDVENSmAYZZLxIr/W03b4RodSYwHS+HLOLJK+hLRWvMYDsKVUzsUxKjxHrQegX0fXqXk/XTuE99w70oNUS/5vJbL6Ocd9t0WIqVb4CoduwrtLOreVg75mS4flRtrPZ3NEtT/7Yy3rga0Q8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RDEhSfoY; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RDEhSfoY"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54S1ft9r016679;
	Wed, 28 May 2025 02:20:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=c4CSaspeu4a2Fi0ivD8Ae+GLFPSMXg+I1Snj/Anszt4=; b=
	RDEhSfoYIj5EcG0Edz2G77cMgLxZxAOibZ37Vze/ZcbwLnGQXlqDqUlxCLa1nqFL
	INqJe9SS9cyKMgQweerJgjHxrcOh2pVHvjwQ6X8/I09hzKaS85iojTsQsJGUQcSS
	a0Tjsv8DwhQBU9R8j1QSHzgQZMK5iHS0nXssvnIaJBzBi1tsyRQQKwQTwZeWqU9a
	7MY2K34c4Dfnd64adG+Yfmcr/tImGvHYm5tsENjOXZAvgD4OgTW71710rx4LNLMX
	IEAyM8D/UkcTeIijsqcehCxvwoqSczVEIwYrbAxTM9NnXu2yPua5I3Piq8OcJxOv
	zcN6c4MylnYKgf+k/j72Xw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46wjbcgx0e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 May 2025 02:20:55 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54S163U9021123;
	Wed, 28 May 2025 02:20:55 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46u4jgb22g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 May 2025 02:20:55 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 54S2Kq1A017834;
	Wed, 28 May 2025 02:20:54 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 46u4jgb21n-6;
	Wed, 28 May 2025 02:20:54 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: dgilbert@interlog.com, James.Bottomley@HansenPartnership.com,
        Chen Ni <nichen@iscas.ac.cn>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: sg: Remove unnecessary NULL check before unregister_sysctl_table()
Date: Tue, 27 May 2025 22:20:20 -0400
Message-ID: <174839736812.456135.17953304102014989404.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250514032845.2317700-1-nichen@iscas.ac.cn>
References: <20250514032845.2317700-1-nichen@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-28_01,2025-05-27_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 phishscore=0
 adultscore=0 suspectscore=0 malwarescore=0 mlxlogscore=868 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2505280019
X-Proofpoint-GUID: GUjfo9xS6TfrWnZ-MQtj9FfaTbMZP3sc
X-Proofpoint-ORIG-GUID: GUjfo9xS6TfrWnZ-MQtj9FfaTbMZP3sc
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTI4MDAxOSBTYWx0ZWRfXw396fxfjnATX 4LBKgF65PZ3n3uyUIGIzxmwA8Z0JjRuB2NbB3DUhGbdVYppMQpBmWHwnOM4rjLhfnvNltADe7Qw RBZgHpmOS/YubQmJDskiZVoYOY+QKzkxbnYJYXjsskioSqqBEa9cOdiUkN+l/a+LqRW7avF1BUH
 3DLixY050m146RA2Njs8wRws/UQ72ZPNZrf2QdpIRAtaarcI7OOL+gmKdZk31td9o1fP2leK0c1 M5hVSt1Ax+DPtmkUCwQrOUfXg0HDhGDM4e0KrtaX7Q4L0WCvsgVN1eMmUQ8FqFCoPa5xJUKLy6q anwjJX4sHvTMVpabMeCWLSYYEq2sxmM3ef7GbTschGcVKmIx35EwEHQLXJgl7wXxxM5MRJnsQGZ
 z1taNfxidU4AEEJjOCyYdM4BYM8YsVC/m9J/wzXSXOpa9rlmMLXfvNBehh4bX5EOUn5/GsAK
X-Authority-Analysis: v=2.4 cv=c8qrQQ9l c=1 sm=1 tr=0 ts=68367307 b=1 cx=c_pps a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=VwQbUJbxAAAA:8 a=UoBXO3_-y8Jir2PnDl8A:9 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:13207

On Wed, 14 May 2025 11:28:45 +0800, Chen Ni wrote:

> unregister_sysctl_table() checks for NULL pointers internally.
> Remove unneeded NULL check here.
> 
> 

Applied to 6.16/scsi-queue, thanks!

[1/1] scsi: sg: Remove unnecessary NULL check before unregister_sysctl_table()
      https://git.kernel.org/mkp/scsi/c/25c2758e6e72

-- 
Martin K. Petersen	Oracle Linux Engineering
