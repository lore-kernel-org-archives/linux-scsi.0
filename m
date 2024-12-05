Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A765C17335C
	for <linux-scsi@vger.kernel.org>; Thu,  5 Dec 2024 02:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733365069; cv=none; b=fVfibHqwjAvcWBIaSgKuVBWoLD8Y2Mdc+i/BoubR3md69lCth4SHpHGBDlugF9k+wkJxuSR2ZBlnM/5MxO/lj0G9xYAVq0EIuBaAW2ury9JkGInYO7sB+GUPVZ3CIntV4n3nX5Dz0G+0jF5j+6Y3cOwYpulgju23bFC6U4M1Gq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733365069; c=relaxed/simple;
	bh=XAoiHAgQefFuucMow30ikXNoWkqR4zxjmmcSv1RVrJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RB4I0vLCSVcTaYmudSbqPUMQLCcEuZm76AtCObt6wmr4XjoedjcjdlTMSVn3FiFzz2tMw5+O7QuFZnXn1Uxmm0X0EGIdmmvcZxjOz64zkPyruq3cwyiwe6wccb0bctPQRM0Dt0lL8uygK7YB7K7DVYmdSzod0kSAe3iVR01vhok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=DIgM91RM; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DIgM91RM"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4B51BrQS008560;
	Thu, 5 Dec 2024 02:17:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=kxqz2Ukgs7gVXxmViLQR0aLNMxs5JHMHwZ1PmYjgPuM=; b=
	DIgM91RMVECcqyZ1QgwIHUvD++os8TAoID4XNWX6Em3bRhTylYUZZ+QmpXludciL
	5WG6uUjMqKElz8AnpSvcIfuTHcPWTEtndT7UktGVxYSeMRkEFf7nWslGNdvcvM3E
	YYDZbIMntUStTs7hKqptv7qvDEaJIme5zjcXXyoe71ScS5OMsS2WWliX0Pv9T8kg
	0YRHBG5FKLKlqzyRzzSqLk1atbtuCMgH9+/bxUn/yhSNizADwj4qkzXbFC/hp/kb
	DDOnxWY98yDSdR6Wm/y4v66lu7Gu4VCmzis9j1uOTFWgScYUhp7CJ0uT4wTINCJP
	quTsvv/24ejLqwaNbhP9nA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 437s4c9sv4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Dec 2024 02:17:45 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4B5055pS001419;
	Thu, 5 Dec 2024 02:17:44 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 437s5a8u8d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Dec 2024 02:17:44 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4B52HbvS018742;
	Thu, 5 Dec 2024 02:17:43 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 437s5a8u3n-5;
	Thu, 05 Dec 2024 02:17:43 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        rajsekhar.chundru@broadcom.com, sathya.prakash@broadcom.com,
        sumit.saxena@broadcom.com, chandrakanth.patil@broadcom.com,
        prayas.patel@broadcom.com
Subject: Re: [PATCH v1 0/5] mpi3mr: Few Enhancements and minor fixes
Date: Wed,  4 Dec 2024 21:17:04 -0500
Message-ID: <173336487628.2765947.12108331392886916798.b4-ty@oracle.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241110194405.10108-1-ranjan.kumar@broadcom.com>
References: <20241110194405.10108-1-ranjan.kumar@broadcom.com>
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
 definitions=2024-12-04_21,2024-12-04_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 bulkscore=0 phishscore=0 malwarescore=0 mlxscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2412050017
X-Proofpoint-ORIG-GUID: aIi3-U_u0tz-3Px8IJxYfY1q_xU-0mRf
X-Proofpoint-GUID: aIi3-U_u0tz-3Px8IJxYfY1q_xU-0mRf

On Mon, 11 Nov 2024 01:14:00 +0530, Ranjan Kumar wrote:

> Few Enhancements and minor fixes of mpi3mr driver.
> 
> Ranjan Kumar (5):
>   mpi3mr: synchronize the access to ioctl data buffer
>   mpi3mr: Config pages corrupt when back-to-back PHY enable/disable is
>     executed via sysfs
>   mpi3mr: mpi3mr: Start controller indexing from 0 in the driver
>   mpi3mr: Handling of fault code for insufficient power
>   mpi3mr: Update driver version to 8.12.0.3.50
> 
> [...]

Applied to 6.13/scsi-fixes, thanks!

[1/5] mpi3mr: synchronize the access to ioctl data buffer
      https://git.kernel.org/mkp/scsi/c/367ac16e5ff2
[2/5] mpi3mr: Config pages corrupt when back-to-back PHY enable/disable is executed via sysfs
      https://git.kernel.org/mkp/scsi/c/711201a8b833
[3/5] mpi3mr: mpi3mr: Start controller indexing from 0 in the driver
      https://git.kernel.org/mkp/scsi/c/0d32014f1e3e
[4/5] mpi3mr: Handling of fault code for insufficient power
      https://git.kernel.org/mkp/scsi/c/fb6eb98f3965
[5/5] mpi3mr: Update driver version to 8.12.0.3.50
      https://git.kernel.org/mkp/scsi/c/0deb37c2f42a

-- 
Martin K. Petersen	Oracle Linux Engineering
