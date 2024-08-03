Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 868F15227;
	Sat,  3 Aug 2024 02:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722651328; cv=none; b=Q6GY24LSm+Kebl1rSUsR/iG6sRHmINz1DWnYeuciqBmAX5D0GjaLlsxLIg6ZA7AwIt+jg/VYO8Ms2Hefu1ktUhOMhLhI83oSAZHEhG2Zc8xI9wG/7lsg4JMkCxDYgFadd/xHSMUvedY1WD7tOfihnF9MW9L5CROY/7Kcbg5xSlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722651328; c=relaxed/simple;
	bh=tNimnsiAMmRVdakKd4ahST0jFVcd0Epz8Jwvt88N4g8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a+TwREXAJZzL8i4UWQyN1BU2Sw6ob9pVqLnwaZMKKpEj1K2eHYbAYJuxMadCOmpE4exumB+zLVfzmZYOFrMuWpq3/TuJa2jkbAUVQQX9Q1LixbzYe8jT0il4KW6pwhb7u3VyLRmcnDh20LIL1a26zTDAxo0F3WeTyKHw3lGYCp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IDRdvAEc; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IDRdvAEc"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 472GtV7l010173;
	Sat, 3 Aug 2024 02:15:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=
	corp-2023-11-20; bh=Zu1GHe3N2sT3hH2OSbrYWoCLnqUCg189gddrdjfP1qI=; b=
	IDRdvAEco+PdRHviYzAmbgCTXFWR4YDzvg3G3cYmWamcV5EDl0byyd7gwv06e0Nl
	nJUWQD/wr2g81kPx+iJ/tekN98O0hCU6PoaSGkMdSgXuuPSDhDludzkc/LSNiVku
	WLzu4qK0zHkcO14CV5m0LDudxSlfRwdXSff2jkRNT2RgEo5ILPCH1uUr7iHAnSbr
	RaQrfJDwXL1ImUiCECT5FyPGfD8h43Lpn7Q7EcXJSr7OLDY8zLH7pDQRm/BYBrBL
	+SHLF3Ou4oTCUEEVxgDm3ws4JKThRRZiuIrtKRtaaUVDwmfv7h0lcsN4CWej7YFe
	sKrBpKuxBcINkMpzB6BuAw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40rjdsag2v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 03 Aug 2024 02:15:19 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 4731XetV017008;
	Sat, 3 Aug 2024 02:15:18 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 40sb06rmjn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 03 Aug 2024 02:15:17 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4732FHjG012583;
	Sat, 3 Aug 2024 02:15:17 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 40sb06rmj0-1;
	Sat, 03 Aug 2024 02:15:17 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Jens Axboe <axboe@kernel.dk>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Li Feng <fengli@smartx.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        Damien Le Moal <dlemoal@kernel.org>
Subject: Re: [PATCH v3 0/2] scsi discard fix
Date: Fri,  2 Aug 2024 22:14:45 -0400
Message-ID: <172265125626.1953059.2949355133355915568.b4-ty@oracle.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240718080751.313102-1-fengli@smartx.com>
References: <20240718080751.313102-1-fengli@smartx.com>
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
 definitions=2024-08-02_20,2024-08-02_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 adultscore=0 bulkscore=0 malwarescore=0 mlxlogscore=516 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2407110000 definitions=main-2408030013
X-Proofpoint-ORIG-GUID: 8RxsGp45wAyJitc2xhKF73VH9MntqQAu
X-Proofpoint-GUID: 8RxsGp45wAyJitc2xhKF73VH9MntqQAu

On Thu, 18 Jul 2024 16:07:21 +0800, Li Feng wrote:

> These two patches have been reviewed but have not been merged into
> linux-next. Can they be merged into 6.11?
> 
> Thanks,
> 
> v3:
> - rebased to the latest linux-next branch;
> - put the separate patch2 in this patchset;
> - add reviewed-by tag.
> 
> [...]

Applied to 6.11/scsi-fixes, thanks!

[1/2] scsi: sd: Keep the discard mode stable
      https://git.kernel.org/mkp/scsi/c/f874d7210d88

-- 
Martin K. Petersen	Oracle Linux Engineering
