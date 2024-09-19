Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF23C19F48B;
	Thu, 19 Sep 2024 15:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726761238; cv=none; b=fX6UuD5+DEwO7QIAdYOeJxnIQjrmlMBcQhf7FPVuq6+qpxFv4IfLst/dVwaZt4z7cbsnK0Q0aln/u0pOxKcOeWJv+p/HRcejTURHztXnFE439ilpzrtRBiFpENf+X6ghJRS+ZsriWP+igGc07IWzY61ttGbC5xldB9Qlzq7sR5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726761238; c=relaxed/simple;
	bh=zVEQrw60kxsl1CHQ6HIuRwS9WUna+raI1w5AQCgTfPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s068RK2Mrz+73CAWzmp3VYWqOQF/1+/QJxAEOT/ocivhnyaTh5xib2DMxl02R3V2scXpDFnqYWGaql3sAACqOSQjtn3trA6G7OsNH04ioinyd0J3O6iwxbzyOEegqkqYeroeH83L3HHvfrteCoRTrrbwxlBxpijC3wYxujtP3nE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=dc4V6tCq; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dc4V6tCq"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48J9LYYi011988;
	Thu, 19 Sep 2024 15:53:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=
	corp-2023-11-20; bh=tryf5cIGdDYFQkJ03qgbJZ1tlpYLNfvFJcEkNYA8CGQ=; b=
	dc4V6tCq080oTDQlLVnbRQxyqOWwEZuwvwW+zJX/cTicVuUUQNmFOfQ8p5KE1gN6
	34qLSJs8ix3fOovKoDu66QHFi/q/QAkeItsi26QmJWnlRVpdwe6bZeFClKObn6Q8
	a8Yyuh9rduuOr+rhQQfriS0xPCnZsfC7IOcYUU/1DWIGDcvKMz6CJVfkJUsIE0JG
	auNYiisohvISNgnnWoJuwcB6C6xwb+tCzTU+K9WH2ddYOvKfGOBXYHnPuqK1RaAR
	AEAvlC+uhLAoVcQj/8sXPzSrPQeH8PhZbI6m/tsvhK7SWmCrEDU4L7Mh2HAqDs4l
	dZ/wrvcb7LAUWewcZWTZ7A==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41n3sfvgcw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Sep 2024 15:53:54 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48JESdaT011058;
	Thu, 19 Sep 2024 15:53:53 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41nyb9xjer-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Sep 2024 15:53:53 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 48JFri8t031813;
	Thu, 19 Sep 2024 15:53:53 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 41nyb9xj7h-9;
	Thu, 19 Sep 2024 15:53:53 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org, Colin Ian King <colin.i.king@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] scsi: zalon: Remove trailing space after \n newline
Date: Thu, 19 Sep 2024 11:52:55 -0400
Message-ID: <172676112040.1503679.16855048011099883592.b4-ty@oracle.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240902141202.308632-1-colin.i.king@gmail.com>
References: <20240902141202.308632-1-colin.i.king@gmail.com>
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=932 bulkscore=0
 adultscore=0 malwarescore=0 suspectscore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409190105
X-Proofpoint-GUID: gyXogmA7GsFCFjHNpyVuy17CTfer_yC0
X-Proofpoint-ORIG-GUID: gyXogmA7GsFCFjHNpyVuy17CTfer_yC0

On Mon, 02 Sep 2024 15:12:02 +0100, Colin Ian King wrote:

> There is a extraneous space after a newline in a dev_printk message,
> remove it. Also fix non-tabbed indentation of the statement.
> 
> 

Applied to 6.12/scsi-queue, thanks!

[1/1] scsi: zalon: Remove trailing space after \n newline
      https://git.kernel.org/mkp/scsi/c/57bada8a5e69

-- 
Martin K. Petersen	Oracle Linux Engineering
