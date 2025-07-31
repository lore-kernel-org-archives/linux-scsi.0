Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59B038F6C;
	Thu, 31 Jul 2025 04:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753937080; cv=none; b=KdEZEs46+iDUfxDhJSKeBt2Bi7Bu9jL1LrVLKGzDe767x3PlXH3GGEb2B0O7V1VRTmtZSD0WB4R4RWT2uCheSHg2oPGJ3jvOphNcv1VFzEKQITbreUyQ9+MBfyx1DPaD3wlYTwvDaalVD46Htn0ep9XV8I8jKc3oMERFUZpYDn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753937080; c=relaxed/simple;
	bh=fBSYGyyPfH733eaORbzWckWeJTLyOqy6r0d/faDBVvM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Za2KZw2KJZIIyQ3zk7VwYIDPwbhWQ+Yl9cdvyGUcNQKk+TepYuNHFntSH5bitxtzLgmLuMxi6hFMFsg5QgAc6O0ZXzffZRizf65+naFbKCd+EVGNry224Fdd6AwUKAcGy0tDiwsHvr1NyARb/I9/iKrbAgk5GiaMmSiCO92Zmvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=MByvlGgM; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MByvlGgM"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56V2gQZG002650;
	Thu, 31 Jul 2025 04:44:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=FGjvsVGLgeHtU138sIhDi2ENfvXyfv5S4McBo3Ah6Os=; b=
	MByvlGgMErZpYqKa0YyQqqlusqT3Wj54XpZ9eBn30erSU33enEm3+PpewUKowqDA
	DAx5ORA+DRD9rK8/OgEGOyC3Sby+cP+PtHRbI/MmPv4YX7KRN+YqSZM8QdxMKvKj
	aRH6DAr6zN1U/0uC9ItzCkTnLJoUEpPFK/pyrPlV0oIhyNQF5MYt5UcUaPBJdXyc
	nDvGcXbZzUTbnJrcfquHxrePzWS41kAveZKA6oZtZNalVro580Ro97xrGil3xU5W
	WMAz/cC4aUZw7jRrmkNFIgsPycRuN/ehgFrdsiR+WmB2+fn/ItCQjHpWJmn0M2l5
	UKalztgwRtv1tUNXkhjfMg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 484q2e3h9v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 31 Jul 2025 04:44:36 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56V38PX1016791;
	Thu, 31 Jul 2025 04:44:36 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 484nfjb2ug-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 31 Jul 2025 04:44:36 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 56V4iX45035411;
	Thu, 31 Jul 2025 04:44:35 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 484nfjb2tg-6;
	Thu, 31 Jul 2025 04:44:35 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/1] target_core_iblock: Allow iblock devices to be shared
Date: Thu, 31 Jul 2025 00:44:24 -0400
Message-ID: <175375581100.455613.13607310447557977195.b4-ty@oracle.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250721185145.20913-1-michael.christie@oracle.com>
References: <20250721185145.20913-1-michael.christie@oracle.com>
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
 phishscore=0 suspectscore=0 mlxlogscore=716 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507310030
X-Proofpoint-GUID: CsjfJhHiaCmovBM6NSeKQ98rDxIZ0l85
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzMxMDAzMCBTYWx0ZWRfXwqxiBAVavXy8
 Gz+1xI6YjexOAJQP8U51oKu/xpcUfZ/WxkZ+x97vlGcnX6aM32GPiHgikzPH4N+WDo4BncOWu/P
 BHSQ6nxrDsasN9lRN8Bk8bthljPIiL9jggVhECfRvc+QYJU9XAweW/kIppYaS3FGvLscv1Nbwvo
 CeFERIRGrCeIspzTbEXqvCnm1xKz8a2WGTJwMG86+BdXeeFejFHVpYwkmXlC69GYdK2j2PY22XW
 f8dZqiTdElc1i6XTx7ntwpg8jVWED/DqrSrZM0dZijPgCXB0n4s14nDc/5a98fl/FIgHnWJiNDz
 cOXqPExpqMqGTL2t9SvSu5YS1usi8L+/5VJ9NLTzTPi67PfFSlUfoD0vXqSML5R4T8IXwvAufC4
 Cr1XlZbGZfSyrI+tEqoreHMrzmkTPYOGcd4Z6PjX2GJGdtvm9muJSfgMj9+adJR77VrHE9UQ
X-Proofpoint-ORIG-GUID: CsjfJhHiaCmovBM6NSeKQ98rDxIZ0l85
X-Authority-Analysis: v=2.4 cv=A+5sP7WG c=1 sm=1 tr=0 ts=688af4b5 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=VwQbUJbxAAAA:8 a=jKF6tYFBvyWcmNe9yJsA:9
 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10 cc=ntf awl=host:12070

On Mon, 21 Jul 2025 13:51:45 -0500, Mike Christie wrote:

> We might be running a local application that also interacts with the
> backing device. In this setup we have some clustering type of
> software that manages the ownwer of it, so we don't want the kernel
> to restrict us. This patch allows the user to control if the driver
> gets exclusive access.
> 
> 
> [...]

Applied to 6.17/scsi-queue, thanks!

[1/1] target_core_iblock: Allow iblock devices to be shared
      https://git.kernel.org/mkp/scsi/c/7ffbf335e325

-- 
Martin K. Petersen	Oracle Linux Engineering
