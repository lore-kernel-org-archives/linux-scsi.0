Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B137A25740
	for <linux-scsi@vger.kernel.org>; Fri, 23 Aug 2024 01:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724378218; cv=none; b=cxHYRVBeFuGtJod7L/5uVGlCCit8Gi2cAS1gfEkl9i6Sve0WZ77vpe5gs23zpmeNLLRQGigNGGIK7eTasTXx4qhRdrIOnFgEMOFJIJG2RLgZv59oc4wGJ4mQDqmfU7x+cGNzNRk78YKD1E37MPzc1iGaYkmw3/le88tZXBNaKQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724378218; c=relaxed/simple;
	bh=PI1aGltKC0J2ROjz7Bpz86AN3ibusGIF1jx1xcN7ERg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OqbiEG9CcX/S2yMICRILdp9DNxZAZQDGkCuH9QyduFlltQEPKXyF8hyhMZMjeV0U4px0h6Lw3/pjpA54Z59GJgvy0pjhoRC5bwxOXEjvjHGx7uzgqiGalFS/xgMibiMbJYoAzdr9hZaT5oK7hGPblWa8zpqnu5WWl/n9UC/pdbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=VxHYydbB; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VxHYydbB"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47N0CNkB008274;
	Fri, 23 Aug 2024 01:56:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=
	corp-2023-11-20; bh=rK4TLGlKy5hSZji3VsYAelFCu5oZpcf3eYC7m9vcsiU=; b=
	VxHYydbBcVs8FE6YawRmXQ/jf/f0Noxnw0SucFMQkF+RkUX1QqzFydvd8ilX3+k1
	7KlVbKoE1F/iITajn+rYgqksycxKlPNIbBLfWJBl81iUCBmC1eUf0yBysYfm1hpO
	R3LFPK0lYu6vEn0pWKHJk2iaspSHTAeWIINgKBYckpx8O0nl2n+UDTB5smgDy8ht
	l7b+LyPKoedtLbT4dxl02mQCCwS/HLQ1L1YqXxOOI6E9B0TnVg82NjdeSJCqBvst
	6Af5wRsgeEbm2gGb3azehPojNFpDKRjQ/RS3Gl5m40Ye0lV/yngINLRo+xjB3yaS
	WBCbdJki7pxBQsXrSi24HQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 412mdt3bw3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Aug 2024 01:56:43 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 47N0YEwY012194;
	Fri, 23 Aug 2024 01:56:43 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 416g0e9qn5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Aug 2024 01:56:43 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 47N1ugAs033471;
	Fri, 23 Aug 2024 01:56:42 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 416g0e9qmh-1;
	Fri, 23 Aug 2024 01:56:42 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        Ben Hutchings <benh@debian.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] aacraid: Fix double-free on probe failure
Date: Thu, 22 Aug 2024 21:56:02 -0400
Message-ID: <172437814915.4018943.4501213018691926046.b4-ty@oracle.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <ZsZvfqlQMveoL5KQ@decadent.org.uk>
References: <ZsZvfqlQMveoL5KQ@decadent.org.uk>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-23_01,2024-08-22_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 adultscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 mlxlogscore=823 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408230010
X-Proofpoint-ORIG-GUID: R1uB_xwfRmIjOFQKVYHqiRYgozLr7kSs
X-Proofpoint-GUID: R1uB_xwfRmIjOFQKVYHqiRYgozLr7kSs

On Thu, 22 Aug 2024 00:51:42 +0200, Ben Hutchings wrote:

> aac_probe_one() calls hardware-specific init functions through the
> aac_driver_ident::init pointer, all of which eventually call down to
> aac_init_adapter().
> 
> If aac_init_adapter() fails after allocating memory for
> aac_dev::queues, it frees the memory but does not clear that member.
> 
> [...]

Applied to 6.11/scsi-fixes, thanks!

[1/1] aacraid: Fix double-free on probe failure
      https://git.kernel.org/mkp/scsi/c/919ddf8336f0

-- 
Martin K. Petersen	Oracle Linux Engineering
