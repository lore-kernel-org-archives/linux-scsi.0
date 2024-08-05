Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCF1A16EB40;
	Mon,  5 Aug 2024 21:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722892718; cv=none; b=jiC66FDKH3dXL9879Me70bS9OWPo5LkhNgIFNyYzErqIPBxRlQ6jjcqZYK0GaCyyNHCYxIgEfPHZUC2HeBF5hipuYOZNUlW6Dot3TreGIYJ7e0MlZTIfyetaLuedelZS/f34syCK5FzeHl4VvbzTmeX3zHqYDSmooASlKY2Qv8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722892718; c=relaxed/simple;
	bh=zUempoHAJzN1FUAyQWYl5IvOoqItTtskDFh9Y33RBaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NPaiJ0+jm6zSYK1MoPlW/0UrrtJTd/MAR+mreXUZkHt+EA9wy6TZacuHhzq4DM6F9SVzaYJGqvR+kHLYDs0EjjB7xXuSMGr0+ThVHjQ+1rY4HXHL3qpETka+OkX4kHkZCv8gUENCDVw96fmR/TMW2uZeSt0BMj6irbGnifVFHWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=NA2iafj0; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NA2iafj0"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 475KjStA005321;
	Mon, 5 Aug 2024 21:18:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=
	corp-2023-11-20; bh=TriH1Kj1b0cYhLbolFqQPdxoy23fivfmNicsliuUlas=; b=
	NA2iafj0r2qqaTuHCjk656uaqU7qN823zWlGqzaP7NW/1PE0MnLreWCaL7ZYGOWj
	7kXfttwN6eSFX22vzn1CiroSfCRDLN316uqY3a039GTLK9uEa1yc1MYQO3tMn2/9
	IDGNHAOooTqa5FfTjyA8Ezc71P8YiMnNGePUMoy0JEUMjtooZye+miyGK5EGGjJO
	ljiEenyLcZFI133/MAHHqsRHhKsptCwkYuj49W36PJ3BwBGpbhEhNbcmYdYpKG4t
	QyoUisbS4uiCiKQxjgL4JVPvxA/ZqB7I5QscaGF1GPUjxun4IkcQvRvYDKMM1+jt
	9KD0yHHiYRAefStdULqtBQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40sbb2krq6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 Aug 2024 21:18:31 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 475KYCM0035208;
	Mon, 5 Aug 2024 21:18:30 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 40sb07ydkj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 Aug 2024 21:18:30 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 475LINET035403;
	Mon, 5 Aug 2024 21:18:29 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 40sb07ydcw-6;
	Mon, 05 Aug 2024 21:18:29 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        Kees Cook <kees@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH] scsi: aacraid: struct aac_ciss_phys_luns_resp: Replace 1-element array with flexible array
Date: Mon,  5 Aug 2024 17:17:30 -0400
Message-ID: <172289240510.2008326.356426084657481817.b4-ty@oracle.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240711175055.work.928-kees@kernel.org>
References: <20240711175055.work.928-kees@kernel.org>
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
 definitions=2024-08-05_09,2024-08-02_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 mlxlogscore=834 mlxscore=0 adultscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408050151
X-Proofpoint-GUID: eupRp6Kw5yORCGb6gh1q20XnwlnD_lo7
X-Proofpoint-ORIG-GUID: eupRp6Kw5yORCGb6gh1q20XnwlnD_lo7

On Thu, 11 Jul 2024 10:50:55 -0700, Kees Cook wrote:

> Replace the deprecated[1] use of a 1-element array in
> struct aac_ciss_phys_luns_resp with a modern flexible array.
> 
> No binary differences are present after this conversion.
> 
> 

Applied to 6.12/scsi-queue, thanks!

[1/1] scsi: aacraid: struct aac_ciss_phys_luns_resp: Replace 1-element array with flexible array
      https://git.kernel.org/mkp/scsi/c/2e35b43bc9a8

-- 
Martin K. Petersen	Oracle Linux Engineering
