Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C30225661;
	Sat, 26 Oct 2024 01:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729906711; cv=none; b=lp2e0gJ4pzW8PYUnXB3WnchAh+XCHG5r/NLt163Eg8l4poXYQJDTtQz+2zdEfDjh8JA4JlaiKdpBo1xI8ITqHaIItAACZcDF5QFQ0MEoZOa3d7vPQlGRXXJfE9MTWJeNa3ArnGsa9E7yyc1dZRI9rjghGUXxMlcW6L0ZWsPfAUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729906711; c=relaxed/simple;
	bh=wb4akTMMtMLY5/X2OzJP82QeJCBNfgQi0AWeJuOG8KE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pjAVQjsp7thFOa9KqtG+X4qWKnD6kcuO+hpWNfxU4X3jbsd9tDjChpNlRu49Dp0bcXbRJdfK+TNPNLpocUKw6agLWuBK/qL3wzvPJfXMlr7raKvSPuyXIN5VmyEg+v17obR0b2dSd1T+/X8H/2IrLcDnGsHaOtL8EoUIRWRlXpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=gsTvCHv9; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gsTvCHv9"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49Q1KDjf018834;
	Sat, 26 Oct 2024 01:38:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=Se0MdpLE9psWHH4ylcGBK+1owS6hQ7H91iMUvop86+0=; b=
	gsTvCHv90knr3wxWfg7LJ262yQFvTILLAMX1Z/fGKOZD9gBonf9p0IbcukznDlE2
	tSi17Rhb27sY+HylGzN7C56nYoHbDIGsnDirjn5auJayD9sM1uoLc1++QptJBiH4
	ufYOIjT+XPs9HialEhj4jcbgxTLIQezoQOafIpxkmFyukQRZNeS/wQi4YoPy7/JA
	drZe/QM8BejWU6vjkP+ijTgDv5DZ+oIJFDOHDvfI38Uuldr/ChfWkJjIyPjtVZnG
	79ptMguAF0w0/CuAM1jfcP3ZJ1Y9FZYYJIKMD5Csm2tNuVLb9zdleWYFExZw1xl3
	o753jHrk5M0nK7i+dZnPuw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42c5asp63m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 26 Oct 2024 01:38:24 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49Q1XAIF017072;
	Sat, 26 Oct 2024 01:38:23 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42gpv4035r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 26 Oct 2024 01:38:23 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 49Q1cMKZ028982;
	Sat, 26 Oct 2024 01:38:22 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 42gpv4031v-1;
	Sat, 26 Oct 2024 01:38:22 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: anil.gurumurthy@qlogic.com, sudarsana.kalluru@qlogic.com,
        James.Bottomley@HansenPartnership.com, linux@treblig.org
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] scsi: bfa: Remove deadcode
Date: Fri, 25 Oct 2024 21:37:26 -0400
Message-ID: <172952538715.1368542.9279479717529298715.b4-ty@oracle.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240915125633.25036-1-linux@treblig.org>
References: <20240915125633.25036-1-linux@treblig.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-25_14,2024-10-25_02,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0
 mlxlogscore=869 mlxscore=0 suspectscore=0 adultscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2410260012
X-Proofpoint-GUID: RJoZ44kKm1fdU9_37OcoHjzfzWY-EJT9
X-Proofpoint-ORIG-GUID: RJoZ44kKm1fdU9_37OcoHjzfzWY-EJT9

On Sun, 15 Sep 2024 13:56:28 +0100, linux@treblig.org wrote:

>   This removes a pile of dead functions in the SCSI bfa driver.
> These were spotted by hunting for unused symbols in a unmodular
> kernel build, and then double checking by grepping for the function
> name.
> 
>   It's been build tested only, I don't have the hardware, but
> it's strictly full function (and the occasional struct) deletion,
> so there should be no change in functionality.
> 
> [...]

Applied to 6.13/scsi-queue, thanks!

[1/5] scsi: bfa: Remove unused bfa_core code
      https://git.kernel.org/mkp/scsi/c/f3845d7d7145
[2/5] scsi: bfa: Remove unused bfa_svc code
      https://git.kernel.org/mkp/scsi/c/0604cf11cd56
[3/5] scsi: bfa: Remove unused bfa_ioc code
      https://git.kernel.org/mkp/scsi/c/b74448006a67
[4/5] scsi: bfa: Remove unused bfa_fcs code
      https://git.kernel.org/mkp/scsi/c/372dcc01616e
[5/5] scsi: bfa: Remove unused misc code
      https://git.kernel.org/mkp/scsi/c/8d7cfe95217c

-- 
Martin K. Petersen	Oracle Linux Engineering
