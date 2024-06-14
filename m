Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E0B42836A;
	Fri, 14 Jun 2024 02:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718331847; cv=none; b=X15I5JSIgY3MGqMx9gKxRKMegnBlv9ikRWYMGdkhl6TuO1f6POtlFe46/GH7zrpkg77cLe19UrKPjhOXQv13/FCj1ROGFH+PbsQ0zrszUfUHVGxm1f2LPB/Ri8U6EnpD+V/Rf61Qhwyagtm7iocgpzHnqrKEukTSx/w5qkK8Fgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718331847; c=relaxed/simple;
	bh=3FQ3MEtOrZtut3EegPkICwKG9Bx9tibnLwOSZ/KO8Hk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jgvm2EMuppU0G3XNhHYyOF7iKSeefudbhbpoU0LgI1QKrAhzWzq5RrapYqBNAdGUlzgTshiHtKfTXIWBaQ3bJaM27TNuZDA9bZCMtMeKbVQ5utQzv5UAB6iVORO6a3XjqWb9EQH2brBK1n9+o2jk4Gb/hWl4LsaPCKp85vY1jcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=BJLDlIkc; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BJLDlIkc"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45E1fRRS009891;
	Fri, 14 Jun 2024 02:23:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=
	corp-2023-11-20; bh=3wbXBl4iTgVDeRdgFASpmQd/bkRz1fit9xhsn00Vf2s=; b=
	BJLDlIkcV3nwUQ1tmNQv/Yj/FRgeuN/7w9xNfzdSk11fGtSBID98N8V2Ap9wFbyT
	MiW0Lk8yFGvKolOFBAPV0n0N6nVdKi78zSkY4ry8TS7Zm7vOrMJRsugGJTDN6f59
	VLKtJSh5qcBMI/wdnkPyYGCTLv6Zxb8eJ03/qZvFIXAa7tn5W9fVKrjPROvftiEq
	913zD0nHZJUPfuBPjLvs7btdcwDuO9nRbDwbEdsW5ajQGDjuraOo4+N6ItiCYHpw
	GcRxx64XwgQRJYB1Ho45C4vtkrqrhv0Iiual4rokjhRokGeHdM2QDHIVsdnswHnt
	Pc2lGXSpN8podzDnwC7X5Q==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ymh19ar65-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Jun 2024 02:23:46 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45E1dakL012556;
	Fri, 14 Jun 2024 02:23:45 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ynca1vrjp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Jun 2024 02:23:45 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 45E2NhG3009531;
	Fri, 14 Jun 2024 02:23:45 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3ynca1vrfh-2;
	Fri, 14 Jun 2024 02:23:45 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, Joel Slebodnick <jslebodn@redhat.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, bvanassche@acm.org,
        James.Bottomley@HansenPartnership.com, peter.wang@mediatek.com,
        manivannan.sadhasivam@linaro.org, ahalaney@redhat.com,
        beanhuo@micron.com
Subject: Re: [PATCH] scsi: ufs: core: Free memory allocated for model before reinit
Date: Thu, 13 Jun 2024 22:23:01 -0400
Message-ID: <171833164847.271429.16176301177294117604.b4-ty@oracle.com>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240613182728.2521951-1-jslebodn@redhat.com>
References: <20240613182728.2521951-1-jslebodn@redhat.com>
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
 definitions=2024-06-13_15,2024-06-13_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=963 adultscore=0
 phishscore=0 suspectscore=0 malwarescore=0 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406140014
X-Proofpoint-GUID: qKSmDeCooTkvJLEx_S1zgxQ3b7iJ95n-
X-Proofpoint-ORIG-GUID: qKSmDeCooTkvJLEx_S1zgxQ3b7iJ95n-

On Thu, 13 Jun 2024 14:27:28 -0400, Joel Slebodnick wrote:

> Under the conditions that a device is to be reinitialized within
> ufshcd_probe_hba, the device must first be fully reset.
> 
> Resetting the device should include freeing U8 model (member of
> dev_info)  but does not, and this causes a memory leak.
> ufs_put_device_desc is responsible for freeing model.
> 
> [...]

Applied to 6.10/scsi-fixes, thanks!

[1/1] scsi: ufs: core: Free memory allocated for model before reinit
      https://git.kernel.org/mkp/scsi/c/135c6eb27a85

-- 
Martin K. Petersen	Oracle Linux Engineering
