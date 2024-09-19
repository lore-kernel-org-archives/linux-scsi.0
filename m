Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 625031A08B0;
	Thu, 19 Sep 2024 15:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726761237; cv=none; b=VlrU3HxP+Zv4gWCanA+hu1L9X46ihvlr7hZDqfz3SAU6hDetM3ZkKtD9QaQ1K+Esx4CMwNrfk60Aktxl1DNpLcpAv3pPVr5ynthIdcA5oGJDbcWLNlcHQXX2kyKW5MgoHhHGn1/T/hrsF5zut8fcTFazbnHPq046c7TBlffnGwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726761237; c=relaxed/simple;
	bh=aUSvuiNxuo/jEqU6pLRsAh13WG2PuhEiiYSnCtuCD9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iENV0bSZRvfcVpeThT42AEfRsnZU35aa7EFp1uPnTLiNpaO8pOKoW0PcmgjBfQHvTE9IAviTICCqnZXy5ST8YkSncjH1SqsloeA+/dUDkkWGsPWRQwjQrp4SlDOgSWbOcgDo3IxO0O408FNYxLsUw4JPm3DRlBsKWSEU5QIg+qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=QnHHXCm7; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QnHHXCm7"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48JEiJak014289;
	Thu, 19 Sep 2024 15:53:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=
	corp-2023-11-20; bh=xF/+rlNytVq7Q8SgOYym8loSy/J/j7Tdknv7IRnnTP0=; b=
	QnHHXCm7pJQ23sfVpzmHeig6E0vFDsO7AM59i7gcBJWAkF8G9shg9XvVwS2JVL1h
	WHP4jw6gV54MTVeXKdN3cs1yorEAhuqrtV4EolV5ZfmdK+3zV0gsubzdk0/2hLTh
	jyxVJsTlYy/iFHYKBVYgSQv7l8OxIaCPDw7FHzTtBiFKZhS+np4YpR0/vUYdIBjY
	bdyV/CPSEyYhldLG6LwCuH0Q4ApXCKqopBMfodo4MKW+morVeRi3M5wRyNL1C6ye
	ADtzirzc1zrF8JdjrwKhRbQ4sH+fdsOVrvejakc3qdBP6ul26uSpkfjHNVbwTWGC
	HP22rLbahq9Z5+Gg1LtX5g==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41n3n3mhy5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Sep 2024 15:53:52 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48JEkVEF010460;
	Thu, 19 Sep 2024 15:53:51 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41nyb9xjda-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Sep 2024 15:53:51 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 48JFri8p031813;
	Thu, 19 Sep 2024 15:53:51 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 41nyb9xj7h-7;
	Thu, 19 Sep 2024 15:53:50 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org, Colin Ian King <colin.i.king@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] scsi: pm8001: Remove trailing space after \n newline
Date: Thu, 19 Sep 2024 11:52:53 -0400
Message-ID: <172676112041.1503679.5871873272226427025.b4-ty@oracle.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240902141537.308914-1-colin.i.king@gmail.com>
References: <20240902141537.308914-1-colin.i.king@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-19_12,2024-09-19_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=909 bulkscore=0
 adultscore=0 malwarescore=0 suspectscore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409190105
X-Proofpoint-GUID: T9GGSm6lJ3AN7_lboFdsuSHazEwyWE5a
X-Proofpoint-ORIG-GUID: T9GGSm6lJ3AN7_lboFdsuSHazEwyWE5a

On Mon, 02 Sep 2024 15:15:37 +0100, Colin Ian King wrote:

> There is a extraneous space after a newline in a pm8001_dbg message.
> Remove it.
> 
> 

Applied to 6.12/scsi-queue, thanks!

[1/1] scsi: pm8001: Remove trailing space after \n newline
      https://git.kernel.org/mkp/scsi/c/34f04a9b6e39

-- 
Martin K. Petersen	Oracle Linux Engineering
