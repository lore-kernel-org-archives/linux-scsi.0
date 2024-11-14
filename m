Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A18DC1E9061;
	Thu, 14 Nov 2024 02:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731552679; cv=none; b=oCkWq4p3SObXgMdJGwSOis7wqIrDRQaHjbiJItUFk3bNWiDu6uKdbrj2N2WASkn04Du+ea1s+AfvHNh6aRvwcR3CCBfqGLJ7HtSGxGcUTYIjdwF9kr9rY0GUJdkn3ZeOEoVD0VARlxRWwC7TD39y/zP8M7+KERU0/YmLM8l4lhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731552679; c=relaxed/simple;
	bh=H6DBNCPZGNERlsPtd3z0WPU3Z3iSUEj5bEcXV0m9LXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HMQ7vZIu+z9iS4hNAg5JuT2/zGNnEkqa3+Iv8SE2cbRttpIiUNP9YN15GlAWVQnLC0MtPQMWu007jmmZ0g3/MAQqcHkbtC2KmdVACOF2/kHDg+o7fq56l3GbMYy4S2B67B7oyZdVsLtOm4L94jk4kWlYCyThWk36d6nCHIOXai4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Q3fVOdjM; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Q3fVOdjM"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AE1fmb0001312;
	Thu, 14 Nov 2024 02:50:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=eMWpl/7Zg3vVe/Ep++BPsCq2npXZ9GfGvkFWuhGIMzo=; b=
	Q3fVOdjM7Brre7R/1uY55MJ/j2xRyOCo2fI/NvRaIg5UQqIErnYUj07hH8ypm+Yd
	RNndOZAipro/JBS0ICh5F0VAqIreQg+9I8qJaSTsRH+EzQMv4OdiHO9cxzcQWtNU
	sg4NDhUFgXK2vyhBcslUJZnhgJH+eUZ/ddZelyO3ssi2Bo+9NQ/N8TKdwap1Qn5K
	otRNOfV2h71B91pp+NU0RDJv2nXDjiLeCko/mkjyJWTraV5qQdNAjYUgidZQ6nyH
	9V9cJ67EppKETCYotgK177g7/cbKq5kgirn1dO15jjNWfWgqEaIdILi02mpkOqOD
	LwYylgsZIpW/HKz1heWWCg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42vsp4hw3t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Nov 2024 02:50:57 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4AE1C6Tk023937;
	Thu, 14 Nov 2024 02:50:56 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42vuw0p22f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Nov 2024 02:50:56 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4AE2ojZ0003527;
	Thu, 14 Nov 2024 02:50:55 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 42vuw0p1vg-9;
	Thu, 14 Nov 2024 02:50:55 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Minwoo Im <minwoo.im@samsung.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Philipp Stanner <pstanner@redhat.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: Replace deprecated PCI functions
Date: Wed, 13 Nov 2024 21:50:02 -0500
Message-ID: <173155154789.970810.9790026959679246230.b4-ty@oracle.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241028102428.23118-2-pstanner@redhat.com>
References: <20241028102428.23118-2-pstanner@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-14_01,2024-11-13_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 adultscore=0 phishscore=0 malwarescore=0 mlxlogscore=780 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411140021
X-Proofpoint-ORIG-GUID: UFI0a4tInzIB9yJGqQhKhE3mF1sgg8Bp
X-Proofpoint-GUID: UFI0a4tInzIB9yJGqQhKhE3mF1sgg8Bp

On Mon, 28 Oct 2024 11:24:29 +0100, Philipp Stanner wrote:

> pcim_iomap_regions() and pcim_iomap_table() have been deprecated in
> commit e354bb84a4c1 ("PCI: Deprecate pcim_iomap_table(),
> pcim_iomap_regions_request_all()").
> 
> Replace these functions with pcim_iomap_region().
> 
> 
> [...]

Applied to 6.13/scsi-queue, thanks!

[1/1] scsi: ufs: Replace deprecated PCI functions
      https://git.kernel.org/mkp/scsi/c/84c1e27e6c64

-- 
Martin K. Petersen	Oracle Linux Engineering
