Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F405326B756;
	Tue, 24 Feb 2026 16:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771951682; cv=none; b=Sh9Uax89pf6D4Nj6t/Y1n6QqogsyRW8haFrd1Z6dLsHKKJWojHIkH69T26eyDL+PMZ8Tx5wWYeotAPXHOoNvtHCCSwMrLDoNELTx6EBjaxnKHoZO0VwuuSXlb8uLGy869T+sxfsiVtEmQeO56I1IlyMsb9lnTjMNYUy+VoWkjHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771951682; c=relaxed/simple;
	bh=YZqzSUw9Wsmmvx6DZhyaILgyldMKVArTOO15zAMamuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K1Y6WxoerWl0HGif0mcJv4dm14hhM/ZgEKWnv9LnsSbYVcwsn+gwTF6zVtLI/42KUovE0ca5m9+wQP1TKN9zsve6/WIRJB0gX82KYWd3v9r2ZZ9z/+DVe6u1Ht+mrfzonZNgcxFYWs43eH9hKtJddYIztGrgDepNJfQPnF0N1bA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=rNlD2Sa2; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rNlD2Sa2"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61OENrlr4098666;
	Tue, 24 Feb 2026 16:47:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=o+xcm4B0TSnuCRn1PCXPpkS2lcTD13W5V31ViWtmr/s=; b=
	rNlD2Sa2RGosMqJ3CwMUaj+GErjAumj1ONt+v2KVu6OnU9tMYmI3ttJA9oH6/kAP
	qar8zX76dL3C41A2iJn1Yg5TyB6+yPUyYAlEWChPvlMKKx13WO5vRHPy3j9MKaYo
	WyxEQf43wa9VTbcySpxIfe0pUUCVsIxaC4aVJg1WtwvsCh2FXRvwnlPxwbptkJXE
	5Z8uSyKRB/u6xUnFjeLmhQj9R0TFd8IW/SantU3Gmc6nB2lzutQAWlgKNzESRKB2
	sUicBab5ssko4RlI9vgRUtuoaSucCaQXHbuOH4HhuBk+6hMQqn+sJUYxGKqVD0PW
	WaWo+tjiQRt23ycBPp4PvQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf4k5vhh4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Feb 2026 16:47:57 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61OGACm2015907;
	Tue, 24 Feb 2026 16:47:56 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35a6km4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Feb 2026 16:47:56 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 61OGlt4f012936;
	Tue, 24 Feb 2026 16:47:56 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4cf35a6kjb-2;
	Tue, 24 Feb 2026 16:47:55 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Thomas Fourier <fourier.thomas@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: snic: Remove unused linkstatus
Date: Tue, 24 Feb 2026 11:47:41 -0500
Message-ID: <177195161255.1154639.15799618915676793518.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260216141056.59429-2-fourier.thomas@gmail.com>
References: <20260216141056.59429-2-fourier.thomas@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-24_02,2026-02-23_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 spamscore=0 bulkscore=0 mlxlogscore=672 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602240139
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI0MDEzOSBTYWx0ZWRfX8Ya5RnpJBJAU
 mRTQ5AI5INxFcExKDNkKpzoJYZTqdAKacBZH6oKIe9rWnsogzgDoG9152wwmJPuNulMwFv7Zl5B
 p5zwkDP57tSLduGu4GD7rnLBH1o9g3LEVdwHIxv4usBVd7nYDk3D2QNKY5TLFSMPvHQzTy0mG1o
 0aUmKO9X/p5G/cm+h5+qay71SObZKClwb5FZsXIdrEMg0isBayvsOU8ODnteRg468E8Q4EGX/6n
 G2LvkuqQR3CxdEhWrqYMqH9r6U2QRuiAu1SpU7CEF0brqY1SJiZmXBydn+IsdRTppGdCf3sYpap
 ydtAHG57FKtMxq8AcUuzclpxXYf7a6XCNP9IKkiMFICvRx8fbEGXNVdi4pwXt7/gvyfY4p0fS/7
 OQHELxTC45hh1ep0rXylPTIEKAV6K1SX2W3P8m+uhfqThHkft498CXsRoeL6zDHQ067D6c2RCre
 f6VhLHx6GQuu0y2vX4Q==
X-Proofpoint-GUID: u8jHnFFBaHEtIjuiWKEHPTJWnqSHdChj
X-Authority-Analysis: v=2.4 cv=b9C/I9Gx c=1 sm=1 tr=0 ts=699dd63d cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8
 a=FypdnLkI3WuhgSNUjt8A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: u8jHnFFBaHEtIjuiWKEHPTJWnqSHdChj

On Mon, 16 Feb 2026 15:10:55 +0100, Thomas Fourier wrote:

> The (struct vnic_dev).linkstatus buffer is freed in
> svnic_dev_unregister() and referenced in svnic_dev_link_status() but
> never alloc'd. This means (struct vnic_dev).linkstatus is always null
> and the dealloc the reference in svnic_dev_link_status() is dead code.
> 
> 

Applied to 7.0/scsi-fixes, thanks!

[1/1] scsi: snic: Remove unused linkstatus
      https://git.kernel.org/mkp/scsi/c/af3973e7b4fd

-- 
Martin K. Petersen
