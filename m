Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84F701A3A8D;
	Thu, 19 Sep 2024 15:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726761242; cv=none; b=eX4+FXChG91/40zGprbpJAQTNW7p0iewV/o25ll7NXzFn+abJZo2oELljyH7ZviGc9Zvs62CCw9n0CymCS7ykYc/JErRHMTpfqxUg9Bzqvmx08bHmNRPqNTqrZG+PLwekya4MuXxmAc3A2PdcvNjsMryL/pfjMb2QbVIHeQFwpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726761242; c=relaxed/simple;
	bh=XXf+CrkEJowAZq1tpgIeCO3Bkr+nrD5AJByDeVP+n94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XzzQ+k86k78Oy1DrfDfxQKoZNc4iy20041nZyD9R6NY8Ss+XCpTQRw/EoSrzQP1JwT1p10qK/JsiVH603APtMV1P/HOgThshT+zChBt4+dd448KUxjOLe7ZPWDpQCAH+MiSL7xqG1BhGagRPHL04Z6q9IxCXovsM/pHeaqTpjDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=BkHk34p6; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BkHk34p6"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48J9P5X1015064;
	Thu, 19 Sep 2024 15:53:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=
	corp-2023-11-20; bh=KAhnDswcdiztt0d6ghFdFvkTaxTMJiA9bqO6NbfgZa8=; b=
	BkHk34p6qP4iMyBDvMnmT7znVmT4Rvx7jztZHBrZpsV7Zx7Vr8RHxXLUxVKqzlQe
	hNgu81fq+6kxCv01eYz1TQCirYQGmdHrZWmjq4erVSj0NHJyaJcAIu4qxDMBhkGI
	artOgVKCfQCaYQc/shUOT2HUeoAUn1bq+3JFf+OvfoD6ABWJPKuKUvD1JOYXPQyS
	WO9PZsf9ir07s5xmdScmkMQMji8ny/lW2OkbTMvRrn9RXfLjwDkRcqaW/qVH0HlI
	hASbUQJXG0H6fBkivrrTcq3hjUHudmeLtXHcZheAoBhL7vUT86/NbN5VAgM3jCaW
	HxAjkSMItcSI3WyJzgq9ew==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41n3sfvgd4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Sep 2024 15:53:57 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48JFcDRU010442;
	Thu, 19 Sep 2024 15:53:56 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41nyb9xjg7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Sep 2024 15:53:56 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 48JFri91031813;
	Thu, 19 Sep 2024 15:53:56 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 41nyb9xj7h-12;
	Thu, 19 Sep 2024 15:53:55 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: James.Bottomley@HansenPartnership.com, Chen Ni <nichen@iscas.ac.cn>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: pmcraid: Convert comma to semicolon
Date: Thu, 19 Sep 2024 11:52:58 -0400
Message-ID: <172676112049.1503679.17284268616344061238.b4-ty@oracle.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240905023521.1642862-1-nichen@iscas.ac.cn>
References: <20240905023521.1642862-1-nichen@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-19_12,2024-09-19_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=867 bulkscore=0
 adultscore=0 malwarescore=0 suspectscore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409190105
X-Proofpoint-GUID: tJn9SOnOv8ptX7jxt39t06svOof8KeZ7
X-Proofpoint-ORIG-GUID: tJn9SOnOv8ptX7jxt39t06svOof8KeZ7

On Thu, 05 Sep 2024 10:35:21 +0800, Chen Ni wrote:

> Replace comma between expressions with semicolons.
> 
> Using a ',' in place of a ';' can have unintended side effects.
> Although that is not the case here, it is seems best to use ';'
> unless ',' is intended.
> 
> Found by inspection.
> No functional change intended.
> Compile tested only.
> 
> [...]

Applied to 6.12/scsi-queue, thanks!

[1/1] scsi: pmcraid: Convert comma to semicolon
      https://git.kernel.org/mkp/scsi/c/4708c9332d97

-- 
Martin K. Petersen	Oracle Linux Engineering
