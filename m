Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 978CF233129;
	Tue, 10 Dec 2024 02:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733798185; cv=none; b=cPC+W6Ro301fo+tmrT2SZHu6OikvFuOFkbjPxahElNGDwgOREhLmJyFWgtOUeJ5Fb9pRa8Tg+tP+JekAg4+Bekz6qguYbDNvjSaVb9gWam2+Jrsl5swxfYT4uYWlnQFBM90W3oyqAVVH9Y3srjLiTfK/n2JB1B2UJAaCY16Kp4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733798185; c=relaxed/simple;
	bh=mcalcwQyvsCPfQPmaWHAjBArt5RbhlCvQ9m+9OopiG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ABh+icVYu4AXzW5oONScsOIxYP+kDZZ783l5e5ec2uiMMfmDG15462u0aWPbBmCx+HH4nhpuGh51IVJDtZbe08aw1afRa4mqBJMhTXJekfJx6sQi0XWcSVFrY5UE7YHLsYDHyUK+aHX/3JyrEq8cdzhSumxbPOtwl/ldUSbJwxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Ds3pj++U; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ds3pj++U"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BA1BuEQ005402;
	Tue, 10 Dec 2024 02:36:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=4Ghyt5f3zxawjc9ep1rLd6JCUbKEX/CMMoQi1Eh9nP0=; b=
	Ds3pj++UcXyIIpdqc1G0XGSWDZwgcUhvsUdgDjY5STNDD2GND8Fqib6fA0WQXmVU
	K5TKkF5lRQxiedDSnFKr6XdgIJyqJODNlHhxx9HD7LzfFVrRVY32IaRqB6PqC6Ji
	xo+OLZvmRlrJHVlHWwYaX2reeSoJC8DhW7nDibrNjPa8VaH2ZNnRzMc9EoTewiuI
	3eOI+96hJmbLga4VdVdnfZFY/K4iWVs0pDQ+AQ/lfAELK8gXqrAA7wnLsyYMueyy
	czg5sgDKycZhKbYMSpyylnwcqs4jF9egzZNlcdEls7xecanfcsRLRT8/oh7XjGSi
	DhfCNUcVUPyYWxZegJkrzA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43cd9ams61-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Dec 2024 02:36:21 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4BA2ECVF034949;
	Tue, 10 Dec 2024 02:36:20 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43cctf7y7b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Dec 2024 02:36:19 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4BA2aIun010256;
	Tue, 10 Dec 2024 02:36:19 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 43cctf7y6u-3;
	Tue, 10 Dec 2024 02:36:19 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: James.Bottomley@HansenPartnership.com,
        Prateek Singh Rathore <prateek.singh.rathore@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [SCSI] csiostor: fix typo doesnt->doesn't
Date: Mon,  9 Dec 2024 21:35:34 -0500
Message-ID: <173379777400.2787035.17465894321356068900.b4-ty@oracle.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241123113038.11188-1-prateek.singh.rathore@gmail.com>
References: <20241123113038.11188-1-prateek.singh.rathore@gmail.com>
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
 definitions=2024-12-09_22,2024-12-09_05,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=864 adultscore=0
 phishscore=0 malwarescore=0 suspectscore=0 spamscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2412100017
X-Proofpoint-GUID: 9QITsdFxlqG1RvHsu980k50xUzQJaj51
X-Proofpoint-ORIG-GUID: 9QITsdFxlqG1RvHsu980k50xUzQJaj51

On Sat, 23 Nov 2024 03:30:38 -0800, Prateek Singh Rathore wrote:

> 


Applied to 6.14/scsi-queue, thanks!

[1/1] csiostor: fix typo doesnt->doesn't
      https://git.kernel.org/mkp/scsi/c/a9a099575d4f

-- 
Martin K. Petersen	Oracle Linux Engineering
