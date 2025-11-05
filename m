Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B236C24A069
	for <linux-scsi@vger.kernel.org>; Wed,  5 Nov 2025 04:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762315353; cv=none; b=PtdzCqmnyL/HduZtv087io3KhayXoCqH/ocztx01trCSaxruUFCPUAGyoWB/JzpXswAJQpnBLaltGlQ79qbKFdeeeRlu3kK8BpKvykxS2Phru4rihpIwQklbfFKaRkGB73zX9/qdM0gNAhlYh6DJsKBAN71HRbGwiGM1M+9YudI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762315353; c=relaxed/simple;
	bh=6MhonKbazCgzaZqvUtz+f522OdbYzPLWZgEiyRQaETA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hvJnyZ6pNTVFt8u6p9aFxgEDWzPVKcxBWC3q9Oqyhyii5+ghMGECAC1SwyNuP531umY4nx3Au8YunJ5z7pJegp0sSLqb4/9YiNEjV+jyZZGgRH+K9j9J308d8oCRZ8IA1AWxGSnbq3UwAKLyxyz7r6ACd+IJyvOi/OOlw94l63o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IGJncIBF; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IGJncIBF"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A53TxJ2010846;
	Wed, 5 Nov 2025 04:02:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=c8KtPJMJ4rah00N50A6kt+7Q/nu2fNCMHy4y2uxzqTo=; b=
	IGJncIBFxOLp5phZPTBNLmr33bvxwVeCP0ue/O3Khht1/1C0TTJ203MK+P5gCf18
	b0OaiW42s6FiYaYqS21stnOW/S4hN426uZTjrBXoqbwbCwkJh4eBiaBEVtg05Vcj
	hREilk2F6Y4IktNJ9BfqYU0rEt3ocTn9YaqB7QtSWMSvmcKSw+MbrifcgAOGTKaV
	MySbb2Nu96kkzoLy/yFJPycRVDBNeTYbb4i3Jum5pE6BRSidGVCFLI3KUNrITOSu
	jbCCI8Tmh+X3cjO2buM13+0EbD2O7v//AK1Sq1RvIcHzu3mRbDlLIHekLe15bnUf
	X57sEIbVY6rsS3nu2cH7Yw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a7xqhr158-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Nov 2025 04:02:27 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A51wpK2024984;
	Wed, 5 Nov 2025 04:02:26 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a58ne15hb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Nov 2025 04:02:26 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5A542Prg005395;
	Wed, 5 Nov 2025 04:02:25 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4a58ne15gy-2;
	Wed, 05 Nov 2025 04:02:25 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: core: Improve sdev_store_timeout()
Date: Tue,  4 Nov 2025 23:02:16 -0500
Message-ID: <176231440767.2306382.8136107134434003807.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251031221844.2921694-1-bvanassche@acm.org>
References: <20251031221844.2921694-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-05_02,2025-11-03_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=889 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511050024
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA1MDAyMSBTYWx0ZWRfX2ZQj3TdaWiCV
 PL0kuvzKgEqo8HtVGTWXruvJRkNRQvtcaBwiT81py0K/YAUgbTBXIDPtX3Xl6bL+HkBUZGOZ0VZ
 cs14DD8tcVsEG5ypmkLBkDLeQFRcI5t+ByJoqsGoUz/7tPQg+W9xsFvlVOZajws5KJtPs+ure2G
 EhiCG956dZdbUedXPJFf2lDGlz+fpDOmmyCl8iv+bo5Zlqr32TknHUH2sN2Mm7mXEYAxAcl4WxM
 +w5Pfr4h4PvNHRQGQHzTHrD5S4NLFQyv2asgPxo78DZslwVP17f60X1McQN8rS7yBgOS8xYY1dO
 HxxUUYzwFM+lSkSe2fCDB7AXaYT5mcSwE++6dvzWNxKOCua93RcpB/8RfNmPNl5bsujDFNfCl5O
 EUKmC9rWEkbbd1PRJcOAtC93DRe1atlyo3gqIA47RCAHbdJqGX0=
X-Authority-Analysis: v=2.4 cv=EuvfbCcA c=1 sm=1 tr=0 ts=690acc53 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=0jnZj814PpWq_dt3PzAA:9 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:13657
X-Proofpoint-ORIG-GUID: GC9oDDwn1GIysWjBki48VqUGz-8IPgnl
X-Proofpoint-GUID: GC9oDDwn1GIysWjBki48VqUGz-8IPgnl

On Fri, 31 Oct 2025 15:18:44 -0700, Bart Van Assche wrote:

> Check whether or not the conversion of the argument to an integer
> succeeded. Reject invalid timeout values.
> 
> 

Applied to 6.19/scsi-queue, thanks!

[1/1] scsi: core: Improve sdev_store_timeout()
      https://git.kernel.org/mkp/scsi/c/867e4b1bae4b

-- 
Martin K. Petersen
