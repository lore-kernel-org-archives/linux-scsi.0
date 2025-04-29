Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 380BF236426;
	Tue, 29 Apr 2025 02:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745892571; cv=none; b=dJAau4B1YZcY89GFgpQVQgB5WXzW2yS+ULyAni55sh50Gu3jMJP3NVU5Y4xRNjHqxi+L95jxoiqq+cajzZySUuuVPZtY9xZlhTBMBKtJgz486Yq4xwMXLp+8u92CDvHRHoH5poAVCJb1AyVPRFtl7Jwr+97dxOTTcKF4oPSK340=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745892571; c=relaxed/simple;
	bh=0WnVZPRNEM08XTLl6uCE6wiR9fswLo5RCubv3YCuzjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Eui1PFJLnR0LOtre+RLadtrMaqw7rAMIxKJA/oSG7W1dDB70gOG6TVPZxQP8Y/2BIJ5l+hjazAkwM5J57YW4it1uY8F/aR4tWzlpaSzOydc7wC6M0HywjxxhDSe/bEnszKtJX0YVqzT02SkZfXw5JeMtTWylM9SsAkxDj/G/dg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=dHUlbHjg; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dHUlbHjg"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53T1rhUY005696;
	Tue, 29 Apr 2025 02:09:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=WA8GO1KyNFROjS3whAArhBJ4Kb6THPDRsdQPdn9RhMw=; b=
	dHUlbHjgA0ss2bYkFcfwjWr8pmDRuwS0Q93DiBD4egAHRElUYBc9qWBDKcdX351L
	xDOK2u5myzeVBrwav40la995MyO9EQkEhvOrFquHLFji08ryGSM3wShXFzchg6ld
	amrURppugQqd+3FiYQYcgNmZpMb8HVRx6JFUZtJFRittmjLzmF+EIAsk019W+0GX
	NlZq1IW6yUmKgYKff5vOVtaBlwyNBn5k/No5YuCMYqrdh9GFi+sOZvuuLH8LiEBU
	GU/542fH3LX+iuMZ8rSiberbG8E8YdWlQoi2cNwgb8OBokzXaoIOqxcuTg2pDKp0
	BEd3ilp4tMJviYJ3ODuspA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46anfwr0my-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Apr 2025 02:09:26 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 53T0KeR0001443;
	Tue, 29 Apr 2025 02:09:25 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 468nx97240-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Apr 2025 02:09:25 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 53T29OCQ020520;
	Tue, 29 Apr 2025 02:09:24 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 468nx9723t-1;
	Tue, 29 Apr 2025 02:09:24 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: sathya.prakash@broadcom.com, kashyap.desai@broadcom.com,
        sumit.saxena@broadcom.com, sreekanth.reddy@broadcom.com,
        Chelsy Ratnawat <chelsyratnawat2001@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        James.Bottomley@HansenPartnership.com,
        mpi3mr-linuxdrv.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mpi3mr: Fix typo and grammar
Date: Mon, 28 Apr 2025 22:08:51 -0400
Message-ID: <174588857925.3470741.15728910938365202490.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250419225906.31437-1-chelsyratnawat2001@gmail.com>
References: <20250419225906.31437-1-chelsyratnawat2001@gmail.com>
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
 definitions=2025-04-29_01,2025-04-24_02,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 bulkscore=0
 mlxlogscore=830 adultscore=0 suspectscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2504070000
 definitions=main-2504290015
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNDI5MDAxNCBTYWx0ZWRfX5VOsZqYUCwNJ 2gTe9cmESjZ5B23c9jMLjYmP84ATkfucrJ3jjzdzSzQXNeoAb9prX/wp/6iC7/A/5duD+1Pukcm 06dfFKQVO55vAZb3POsJj6Sx40grEEF0P7lzTU1TD2ZvK7Y8dtt8jop9a+m1UX+chPAnekg9d5P
 0xYFxvAdHXFxTAcEfeXeuJ3eoNyFc4DjVNrvQVrie45X9qYRl2hK83bNOr1Kn6kFGQfxtGJy35L tPEiYRxVGD6zrko1GA8/zIjZVAKcrQudsDCW/zFxFFg1CCm6lpK5oESezPUjuc+hy6VBD1IFb2j pO1jk+7v790CODr0RKNqHqaBCEbIaXcATOP8K6MEwAauyVYbpJdra+LNQsOGbpZOuYm0jnBq3Jx n6J0Oo2Z
X-Proofpoint-ORIG-GUID: tZLrdrKFz8jKRwaVcQvCBaBTeo9wwPAF
X-Proofpoint-GUID: tZLrdrKFz8jKRwaVcQvCBaBTeo9wwPAF
X-Authority-Analysis: v=2.4 cv=DvlW+H/+ c=1 sm=1 tr=0 ts=681034d6 b=1 cx=c_pps a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17 a=IkcTkHD0fZMA:10 a=XR8D0OoHHMoA:10 a=VwQbUJbxAAAA:8 a=3suowM17ClJyCfmit-8A:9 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:13129

On Sat, 19 Apr 2025 15:59:06 -0700, Chelsy Ratnawat wrote:

> Corrected grammar, spelling, and formatting in the kernel-doc
> comment for mpi3mr_os_handle_events to follow kernel-doc
> style and improve clarity.
> 
> 

Applied to 6.16/scsi-queue, thanks!

[1/1] mpi3mr: Fix typo and grammar
      https://git.kernel.org/mkp/scsi/c/7a497d1649a9

-- 
Martin K. Petersen	Oracle Linux Engineering
