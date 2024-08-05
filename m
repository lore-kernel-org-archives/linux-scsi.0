Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1105816F288;
	Mon,  5 Aug 2024 21:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722892720; cv=none; b=UC4/5/sWRDswLYfWfttURCpvrJHxrPnFvPKxcvvV4pPLLPRnc3wsax+AHLXttaX3waJVTureVIcAvKaNANzIN4QvLjE3df8pL5Kma0HWIbbsGPygt9iWwXJqVFoU1P9TARNFrrQxEJB2K+ksY5EzgXnnZ2AohCUNVgGpo8R6LLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722892720; c=relaxed/simple;
	bh=4Qel4rucoQ/Bm9tZo7yO/q1cOT8+yABNCks6ZBg28ls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bQVVnFaGmMcg+fv2nWWCVfJ0kUltZ4xf57oYQ2+16Pv8tJMmd1jExa5S1C8gu8Dk52SM9fpstXj9h7Be3vlsDGuI29GG23K3lgPe+q9LZcMbG6nTMO17Pm3XRDcIeU8eLkGl9nqjbIHwfZg6lyhFyPXLzc42yfh5CiYI7KQwfL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=hSzzkRYA; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hSzzkRYA"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 475KjRqj005274;
	Mon, 5 Aug 2024 21:18:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=
	corp-2023-11-20; bh=3qZWUo8ekLHKxbADQtUatjril6XW9ogMK8TA6kii3zA=; b=
	hSzzkRYAV0r6Iy1UbRtieJdzGDw/nhU+ZxCn7lll5/dnxxlnUfu7XxlxpdyJ4cwl
	7FyaVXQSegCVRB+MiLAOMymDh5zN10Y4JbDfm4afNyxw2tdX+sUDtIxz311AHUYP
	5eTSp69QcufGQnsfpBJa0e22GjpEPVSbG/CK12Z0a0xdPPkvgcuvqGK/HpwBwT0I
	ZTlk7C/SVy61oCsTM40lmKN/JRH7WV4zf76zOak86XRligvlL+6xkDdw2clmq2M8
	FXy415NfYOZc2va38GjjkqiIbRo98QHz+Xm9pLD+TxNWbOYOSkHQZmFugeuLdf9o
	hml2JnH1IksxU3u8aBxiyA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40sbb2krqa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 Aug 2024 21:18:34 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 475JbvBK034971;
	Mon, 5 Aug 2024 21:18:33 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 40sb07ydmd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 Aug 2024 21:18:33 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 475LINEX035403;
	Mon, 5 Aug 2024 21:18:32 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 40sb07ydcw-8;
	Mon, 05 Aug 2024 21:18:32 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Brian King <brking@us.ibm.com>, Kees Cook <kees@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH] scsi: ipr: Replace 1-element arrays with flexible arrays
Date: Mon,  5 Aug 2024 17:17:32 -0400
Message-ID: <172289240511.2008326.3989315023392784238.b4-ty@oracle.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240711180702.work.536-kees@kernel.org>
References: <20240711180702.work.536-kees@kernel.org>
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
 mlxlogscore=885 mlxscore=0 adultscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408050151
X-Proofpoint-GUID: sD6dBm9-uvmVtQRbqfpWsUVxCIyMnT-3
X-Proofpoint-ORIG-GUID: sD6dBm9-uvmVtQRbqfpWsUVxCIyMnT-3

On Thu, 11 Jul 2024 11:07:06 -0700, Kees Cook wrote:

> Replace the deprecated[1] use of a 1-element arrays in
> struct ipr_hostrcb_fabric_desc and struct ipr_hostrcb64_fabric_desc
> with modern flexible arrays.
> 
> No binary differences are present after this conversion.
> 
> 
> [...]

Applied to 6.12/scsi-queue, thanks!

[1/1] scsi: ipr: Replace 1-element arrays with flexible arrays
      https://git.kernel.org/mkp/scsi/c/c72e13cf820b

-- 
Martin K. Petersen	Oracle Linux Engineering
