Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85E391A0AE6;
	Thu, 19 Sep 2024 15:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726761239; cv=none; b=rHyv27Vp/sEpHHCA3f4u/fj2cVGJ7lwhO4/ICDr3tYLfh9k38r1W/1rWZE6mcSji4pB7GOs6Cze/3C/MElXGqqrCDRw52QB6ixc15N+JWQIy5Rpzd6XqqChmBQhfUx9SzZE/HOiV1eyVLuqk+FefX4Dv7e47cBcP+BlhL3Ez95A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726761239; c=relaxed/simple;
	bh=mCn5pk6WNntLOh4aUzdtq+OQ7gGIiQPU3i5aslis3ng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dHc9k/lUaFGQWirdC0xjbw3yjaYF4Xi2/KNxYWSfHuaSLIXxnLNtcAAHwwGPbSj5dLvL3+G8fF0xa7c6sZptjlP1BY+DojOEv/bLBfrQ2vTQwQ1vGaTFmv87H9k4A0FjXXLYbOQIcpjYq33tXmJG2Sr2S0tfp2Ujnbk23hw1l9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=nb95QZz9; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nb95QZz9"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48JEkUkP014391;
	Thu, 19 Sep 2024 15:53:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=
	corp-2023-11-20; bh=I40Joi25ajWs9UwCVbGs/5vaUnAg/0dbWQggJKwNm1E=; b=
	nb95QZz98p5qpoHpS7nTCaLo6CSm235l5cMux4ADtghms/CVbcadeISRxoz2LV5H
	M7fdhI8UYH9ZPo7n6RfqmuhYD1iJ091e8qW25l7edoWWn2ENcCCWYsWdE0dF/fdQ
	KnjCQyH5zJqA0tHLEpYqMawbjP6PNu1UHWF9UxNj/k04Bbn+61T/NK+e0OIBFxjR
	OqQm2B8sbpIgya5ZPgWzK3svCOlRSF3K4vbl14bQzmnCcmstxx7wZGqXzyBUN99G
	yFL3mqQ0Cfy9/fLLXCP6TO0A3Cx4vHrJFqpYFFphj8opLiCl1mkTc7ccFFAJn+xQ
	A5R75W1M1/OCPC8GpnjDyA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41n3n3mhy0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Sep 2024 15:53:49 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48JExYnj011112;
	Thu, 19 Sep 2024 15:53:49 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41nyb9xjbv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Sep 2024 15:53:49 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 48JFri8l031813;
	Thu, 19 Sep 2024 15:53:48 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 41nyb9xj7h-5;
	Thu, 19 Sep 2024 15:53:48 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Yihang Li <liyihang9@huawei.com>,
        "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org, Colin Ian King <colin.i.king@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] scsi: hisi_sas: Remove trailing space after \n newline
Date: Thu, 19 Sep 2024 11:52:51 -0400
Message-ID: <172676112044.1503679.1812318536856252647.b4-ty@oracle.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240902144153.309920-1-colin.i.king@gmail.com>
References: <20240902144153.309920-1-colin.i.king@gmail.com>
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=952 bulkscore=0
 adultscore=0 malwarescore=0 suspectscore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409190105
X-Proofpoint-GUID: ZgFatyDQ4JF7UqnHN6rHNXMRJW25PL5_
X-Proofpoint-ORIG-GUID: ZgFatyDQ4JF7UqnHN6rHNXMRJW25PL5_

On Mon, 02 Sep 2024 15:41:53 +0100, Colin Ian King wrote:

> There is a extraneous space after a newline in a dev_info message.
> Remove it.
> 
> 

Applied to 6.12/scsi-queue, thanks!

[1/1] scsi: hisi_sas: Remove trailing space after \n newline
      https://git.kernel.org/mkp/scsi/c/d2ce0e5ab505

-- 
Martin K. Petersen	Oracle Linux Engineering
