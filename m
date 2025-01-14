Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9B1A1D31A2;
	Tue, 14 Jan 2025 16:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736872858; cv=none; b=Ddz/tEaK+Q5vqgY/9Y1LxpdOWZDRN9VienMxxCk+WANYy0SI49+taQLzZkhfxYmm5QxyS+WyfkvZj0s9lip/KO9m/ou7qgSV/WO2SNWI/K8DrqwSPPBmHllI7HoKTXG7U6KhsI/3J0IE+2dqpgyCWN71h5z2E39j/6h4tTUPBxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736872858; c=relaxed/simple;
	bh=82R+A+GnHTheTxVQh/KAXi2U8RXTk2kqJx7/5OGLhq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HHf8T+sx7MraOFeaOIEHde1dkEQKuzoDAgzST7Tl5V0fFszGwUrM1wffXnRcLTatL6kqYr7TQqlym7/JDQoH6fFneVygwV/CPxT/trVqXVmxT4JJdU/aVg1m0DGZ+sYhzXqQZt+OnQsNMr+Gzs1Oqka/bqUFH12GO8neNBbtEDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IlJ0dlIE; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IlJ0dlIE"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50EC0m9A012495;
	Tue, 14 Jan 2025 16:40:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=eggZD97LqhSUhzJbDbPi6MLeg18UTpZnIZhDysFrDaY=; b=
	IlJ0dlIEw7xHRuHTylE3XQ6JMtUWiHGOvoqN4ts/cGfat8WkmYveIdEEuWShJV6B
	6XIVbW8evEdjok2wHP6+aYJ/zNHVompE2Zh30ADWv9QrST7QlDiDAdPFJpOQgimJ
	O85qNRu6iQxcoSz7VKnjzUGuEk2neYvDPx1cq0QYrx6CFUomWH44wEaPy1QDamLY
	k14gDb3xAFJNh+CEqjgMsz8XXcSqJzbUblNL6OjBjVNBIKtjVqekY1gBRU+9v/nB
	ZRSRNr73gwXN5q3AK36NYAGTQ7U63KR8nIj/8Jqpt+WrMmLSBQopW29grrIpSWqX
	5op6xy65IOrxRW2XjOStBQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 443fe2e7c7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Jan 2025 16:40:45 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50EFBsOw036479;
	Tue, 14 Jan 2025 16:40:44 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 443f38vb6s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Jan 2025 16:40:44 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 50EGegek005685;
	Tue, 14 Jan 2025 16:40:43 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 443f38vb57-4;
	Tue, 14 Jan 2025 16:40:43 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: hare@suse.com, James.Bottomley@HansenPartnership.com,
        wangdicheng <wangdich9700@163.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        wangdicheng <wangdicheng@kylinos.cn>, huanglei <huanglei@kylinos.cn>
Subject: Re: [PATCH] scsi: aic7xxx: Fix build 'aicasm' warning
Date: Tue, 14 Jan 2025 11:40:13 -0500
Message-ID: <173687227221.1044893.11275236400432363115.b4-ty@oracle.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241206071926.63832-1-wangdich9700@163.com>
References: <20241206071926.63832-1-wangdich9700@163.com>
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
 definitions=2025-01-14_05,2025-01-13_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 malwarescore=0
 spamscore=0 suspectscore=0 mlxlogscore=722 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501140129
X-Proofpoint-ORIG-GUID: oKYu2bJWb-oBNEIbOd-4SPGXylZLCVxD
X-Proofpoint-GUID: oKYu2bJWb-oBNEIbOd-4SPGXylZLCVxD

On Fri, 06 Dec 2024 15:19:26 +0800, wangdicheng wrote:

> When building with CONFIG_AIC7XXX_BUILD_FIRMWARE=y or
> CONFIG_AIC79XX_BUILD_FIRMWARE=y,  the warning message is as follow:
> 
>   aicasm_gram.tab.c:1722:16: warning: implicit declaration of function
>     ‘yylex’ [-Wimplicit-function-declaration]
> 
>   aicasm_macro_gram.c:68:25: warning: implicit declaration of function
>     ‘mmlex’ [-Wimplicit-function-declaration]
> 
> [...]

Applied to 6.14/scsi-queue, thanks!

[1/1] scsi: aic7xxx: Fix build 'aicasm' warning
      https://git.kernel.org/mkp/scsi/c/77a4157ac75c

-- 
Martin K. Petersen	Oracle Linux Engineering
