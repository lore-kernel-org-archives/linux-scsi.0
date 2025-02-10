Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD580148FE4;
	Mon, 10 Feb 2025 02:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739156360; cv=none; b=YfN274MkU9Xb9IAn6zMn6mCfbcB0Q9G0Trh7/FgVfGOzK4AJ+6COewIradFKt2pzv4kQpi2wLiFR7oPKoLoxF4iGTIzAIPRX/gAYAvoArtnrBRVEmr9o7/qiVgkKBgcAW7a/efhpg1PSPRZr3xUTBArX4iNB20BLKMm81ctHhM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739156360; c=relaxed/simple;
	bh=p9BLQCZbwi9b/N1yTOtCfKYEnvJcb/RY6aeaaLnUBJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ELK5A254QMM0nDs/0LLPjcgDOYIIZ27K3hir2MCovmnqikcnXfb46cSLHlA1FddL0V2l8JuNdbGarbghmuS7FIDchh5dAi7vJBI9NK7xdGk5DvaZxVHVdAZKqtXf+PiWKVBY0ogjKoxIRvs9UJSbFUCt8s77G0FpVTwSOGEtihY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=OhJbWWi1; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OhJbWWi1"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 519NQl1b001244;
	Mon, 10 Feb 2025 02:59:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=vCFvcnxVSw2IgHT7CSTHZwZYjKpuOTAp4AlalaYLFtY=; b=
	OhJbWWi1+rj7Tbq8ZjbkhiStgRJcRx1m+KPm+UnSYvfW1H7AUk0vikwvSOa8TFu7
	lKANt+2r3NvfWceuszJu32Xy67IorQVx8Nptk2rpcQQ5gfg4U3WKWcIlFdbIMDHV
	g0b2GileeRZEWdPv9XRYppoRJRs/Sek+LOm5TElLqm3hVFz+StugsBjcoej5EUgp
	ttrj8vrwp+NKT/EBYCDjCaIMLyBmA2GHR/vYcdpKQ+hjKIJ25iYmoRsOboB5GMIU
	5r4yPzgUWkHUBamv9wYPuboRbW1EENwkyFWlGwEJYq0RwMABOY0bfUR+Vtfut4TE
	NJqTWaaU8r3Sd/mvN+++iQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44p0qyj40j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Feb 2025 02:59:06 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51A2C9xK012543;
	Mon, 10 Feb 2025 02:59:05 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44nwq6uadu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Feb 2025 02:59:05 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 51A2vwAZ033952;
	Mon, 10 Feb 2025 02:59:04 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 44nwq6uacs-2;
	Mon, 10 Feb 2025 02:59:04 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Ketan Mukadam <ketan.mukadam@broadcom.com>,
        Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
        Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
        James Smart <james.smart@broadcom.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
        Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        mpi3mr-linuxdrv.pdl@broadcom.com, MPT-FusionLinux.pdl@broadcom.com
Subject: Re: [PATCH] scsi: Constify struct pci_error_handlers
Date: Sun,  9 Feb 2025 21:58:24 -0500
Message-ID: <173915612132.10716.10485033554569373348.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <efdec8425981e10fc398fa2ac599c9c45d930561.1737318548.git.christophe.jaillet@wanadoo.fr>
References: <efdec8425981e10fc398fa2ac599c9c45d930561.1737318548.git.christophe.jaillet@wanadoo.fr>
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
 definitions=2025-02-10_02,2025-02-07_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 spamscore=0 suspectscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2501170000 definitions=main-2502100023
X-Proofpoint-ORIG-GUID: qs0p-4R71-lCUVzfIwruwlo8nBf0E8-N
X-Proofpoint-GUID: qs0p-4R71-lCUVzfIwruwlo8nBf0E8-N

On Sun, 19 Jan 2025 21:29:39 +0100, Christophe JAILLET wrote:

> 'struct pci_error_handlers' are not modified in these drivers.
> 
> Constifying these structures moves some data to a read-only section, so
> increase overall security, especially when the structure holds some
> function pointers.
> 
> On a x86_64, with allmodconfig, as an example:
> Before:
> ======
>    text	   data	    bss	    dec	    hex	filename
>   39049	   6429	    112	  45590	   b216	drivers/scsi/aacraid/linit.o
> 
> [...]

Applied to 6.15/scsi-queue, thanks!

[1/1] scsi: Constify struct pci_error_handlers
      https://git.kernel.org/mkp/scsi/c/14807b4a4e03

-- 
Martin K. Petersen	Oracle Linux Engineering
