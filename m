Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1154E28C5BA;
	Tue, 22 Jul 2025 03:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753156095; cv=none; b=Fmnxp5Eg18aDm/flFWnwKX2tEsST/1loObZYlAbN+vpZKrKsWMpRcpByjw0o1y+b9KJTibdCxQsMMeNfVNaLiF+BUbx1nPS1Clu6PutCfIdtpGxh+8nLCIZjsYtnMmZpy+dW7Rnp6xOkD9chO5v1GrOSIJsowmjeZnrVtuiyvM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753156095; c=relaxed/simple;
	bh=nMTpBvmEyHmy3mz/eDr1eefFfEwp4f3uqukjHu9rE7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Isyh+/cQWOLaIb6jKj8PPQFoUbt0muIl9ibrsp6vQVY91BLorFxF0cCqGB2jlnAUAdSSifzPkEmlhx4i59JzW/Lt8PW8SsYgJp4E89+83DRpyKttfBpu652ESAzppIA1stSwFTcMZgwM08UDGu7aTE9a+HbQpcJti0oJfldpnJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IzoxpbOG; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IzoxpbOG"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56M1CDOG019999;
	Tue, 22 Jul 2025 03:47:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=QaOeKe/LADZxV7af5YdvnH+BxzvHHG9K6c4HKPtj/0E=; b=
	IzoxpbOGTeoceIDMhoe6PnCZY0W3DtS1DYhxqrKY4xWMWHzuZTAAId6ww0WiL/ws
	OdGg90YyHAVwwnmtzhNzsCN2RDyyXmi3OmN7Jj4JjPXfB2LBot5/a/x8uIKu7ZtZ
	E/w3OeCOkHulu2mDfpHamEUPLcU2QHfQx5VfDNL0tilpP4XfNeSVlL0oe+Yv9Wni
	AILNPOCEjZm/wsh03lqYj+4+MjIcgSVzigeuXR3bR0S9H0mjDHNZ00Xrm5G6pKy1
	WotN5tBferE9TBwhVRShGIOTyXeTYVuzl9+9rGs86JiPoZvpCYGaf/X5dZri9vXo
	eQOnHXnSS3aeeiNXJqZomQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4805hpc8ss-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Jul 2025 03:47:39 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56M25WFL037696;
	Tue, 22 Jul 2025 03:47:39 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4801t8teaf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Jul 2025 03:47:39 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 56M3lZjF031915;
	Tue, 22 Jul 2025 03:47:38 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4801t8te8u-9;
	Tue, 22 Jul 2025 03:47:38 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Thomas Fourier <fourier.thomas@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        "Dr. David Alan Gilbert" <linux@treblig.org>,
        Jeff Garzik <jeff@garzik.org>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: mvsas: Fix dma_unmap_sg() nents value
Date: Mon, 21 Jul 2025 23:47:02 -0400
Message-ID: <175315388536.3946361.8784053444176657918.b4-ty@oracle.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250627134822.234813-2-fourier.thomas@gmail.com>
References: <20250627134822.234813-2-fourier.thomas@gmail.com>
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
 definitions=2025-07-21_05,2025-07-21_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 suspectscore=0
 bulkscore=0 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=582
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507220028
X-Proofpoint-ORIG-GUID: I9TDTn7H8zyuJGeuqBM_2XVWqwdP8oXR
X-Authority-Analysis: v=2.4 cv=YY+95xRf c=1 sm=1 tr=0 ts=687f09dc b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=VwQbUJbxAAAA:8 a=HazmFS4AVfT1MZ3w-mIA:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12062
X-Proofpoint-GUID: I9TDTn7H8zyuJGeuqBM_2XVWqwdP8oXR
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzIyMDAyOCBTYWx0ZWRfX/ts4us1sj6iU
 MRURbsW4nC2NguKmuZZRvv0iPioV6IaHNJzbaxM8BK+FvOazV1SNJIdDv8Y20T0ClF6Vic0qag2
 lb3+aOVXMcwnZhLo8A4sZz+/PcmZW2azUPQMDm8Wx9M2bWoJTEdjYXWN27VEwePb2+z0889h+Ta
 sCZAnib7f7elfgbqXDgJA8Ko3zFvHOyeWaLoutkqnmR2TBJA/KbWrfFs3je26T0nYoL+U2cmj6G
 BSZqCuDtA7EuRzwAhu9XC6KUBx4wY9f2Ad2gn/zqqCIrdsI6O5dG5h/GediUr3+8t+DnPjWWnB7
 2opUnjPiBXsQxP6Wj4ryUgIQfIasqT0x1SxSxm+seecxYimrTRI0+7lar+NA4/1TPL3QsyELOtC
 myGFW9H69DX0Ia79a+rk7iRa5WzDbVBqhQIPDQtSR3z5c+RdxjBDdkw/k4AAvNITdDyeMz5F

On Fri, 27 Jun 2025 15:48:18 +0200, Thomas Fourier wrote:

> The dma_unmap_sg() functions should be called with the same nents as the
> dma_map_sg(), not the value the map function returned.
> 
> 

Applied to 6.17/scsi-queue, thanks!

[1/1] scsi: mvsas: Fix dma_unmap_sg() nents value
      https://git.kernel.org/mkp/scsi/c/0141618727bc

-- 
Martin K. Petersen	Oracle Linux Engineering
