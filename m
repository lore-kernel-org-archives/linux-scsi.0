Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA2E41A0B08;
	Thu, 19 Sep 2024 15:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726761239; cv=none; b=I3TtWr+9s8RldTXotbI2Tk6rhdxrwQ6hWxrZugjX9OoHIam1hJc2v8D60+Ep9hTjnvBQdw8axM3gYddYDtkKLVmoG30gtWx0yzsjHe1XAcTNFN+QCLwgux+j6x1yVghfY6GQn3qXPjBphTQIV47tn9Ge1M5EfXwHmTIlTVFkAyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726761239; c=relaxed/simple;
	bh=MQ0TYBY+b4NHfId4+GkirOKNEatlRIBVy5OEbKW50WE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NTpnsfk9RTl8UzuQVCHWOyqFywzUsArY3gcDrjWLpBvwqXx4jv3jCvhK4CwHW1/ufCYaRn1YSpUyw/XufqTUlMA/IxOyT41XPlCdewvBnp7egBwsRI8xbb1xSNz42uaZB65CYK4n98rZVE2j4kBd1zHR9VTbA5aFAHzv+/N2JL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=cBDrm6do; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cBDrm6do"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48JFpR4t015008;
	Thu, 19 Sep 2024 15:53:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=
	corp-2023-11-20; bh=pk1RtDV+cJsnu8ZLDKnw0RB5mZAUynl8/AAsD49sOfE=; b=
	cBDrm6doZNE+cr3m2vLEKEp9dcgGPfC0VHYHvhHAG/E43T/g1aGhg/rSLyfyAopu
	Ocw7YZmdwa9mM2AvLxyUM8y8noNu2LnbF8JV+s5lVVEPRcempd+7CLg5Kto9aHkA
	t9h/isbc9A9G6g5ZhG27D3ldBos6y8n5Bx+SUoSVLfWP7UA2r/c/1juqUhPZuEPW
	IlmPlmcf8VsC4XQ7NxgLsNbiDwlFHdHCuK6rDUuB2jjAgAtPjZ9HqCIzC5Uk6VTK
	uILJHoDKYmsdNDqrNTw/z5YI0JNBTiGdTsTGo2eZGSrEqnvTb0K+FhAHzUqAr4HM
	hOiEj4yCXOjSJViKHY7LRw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41n3sfvgct-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Sep 2024 15:53:53 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48JFYPES011136;
	Thu, 19 Sep 2024 15:53:52 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41nyb9xje5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Sep 2024 15:53:52 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 48JFri8r031813;
	Thu, 19 Sep 2024 15:53:52 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 41nyb9xj7h-8;
	Thu, 19 Sep 2024 15:53:52 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Saurav Kashyap <skashyap@marvell.com>, Javed Hasan <jhasan@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org, Colin Ian King <colin.i.king@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] scsi: qedf: Remove trailing space after \n newline
Date: Thu, 19 Sep 2024 11:52:54 -0400
Message-ID: <172676112046.1503679.1243446610762821813.b4-ty@oracle.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240902145138.310883-1-colin.i.king@gmail.com>
References: <20240902145138.310883-1-colin.i.king@gmail.com>
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=946 bulkscore=0
 adultscore=0 malwarescore=0 suspectscore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409190105
X-Proofpoint-GUID: XITylMY0eOvXd0diOzM9ykrzkMcje-_7
X-Proofpoint-ORIG-GUID: XITylMY0eOvXd0diOzM9ykrzkMcje-_7

On Mon, 02 Sep 2024 15:51:38 +0100, Colin Ian King wrote:

> There is a extraneous space after a newline in a QEDF_INFO message.
> Remove it.
> 
> 

Applied to 6.12/scsi-queue, thanks!

[1/1] scsi: qedf: Remove trailing space after \n newline
      https://git.kernel.org/mkp/scsi/c/fa557da6b050

-- 
Martin K. Petersen	Oracle Linux Engineering
