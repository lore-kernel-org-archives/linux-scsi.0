Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC20C283FCD;
	Tue,  9 Dec 2025 03:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765250484; cv=none; b=SLqLvJteYuAcUePGU6zKzLrUm6ZyLQeiLAaktKOkJku4sIoEwn/1h/jbQuae5jo/xWQH7zwvdOmVv3/DtVK4v3hICy7o0pCqek09v92+/Hoa7tw3yOb6dKDq/ICU+kfqIeJxOhR2/ccOmpYTZs28YgzHdBPsyTrOE+XU1ToiJnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765250484; c=relaxed/simple;
	bh=mm3SDlR+DkV3pFzETdcKVL0hV1mHBNZtiO7LfWcPi34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Gr9RBBB9TRK5rUDpwWQT1nQz+VQZQJculymjl6PnnYB4zGQZaFgZdkN/w/JG82U0MxQXf/ldzN6E2ruIXVpP9aMGjzuJQkb3M9vbXf1Jzfk9OQKJTd2HA+P6WoDe9YDLyUNsOvD/hTgnb5iarhsr/8Ugfk2DUTMZ18x5HnXDQ+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=FRpOn5fJ; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FRpOn5fJ"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B936wWG4028620;
	Tue, 9 Dec 2025 03:21:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=TxwDhZ/W0MweUhil70KiI3eunGvjvXJbARa8Y29S0t0=; b=
	FRpOn5fJQTwsB+5ZE5rdHtb//Aaf2LcG5e3Bk8neL2POwwJzS9PXNCEXj6wXFmTq
	sHpNyt6IWxuLnWg8ZRVAGwoOmb93tAGdnyTonvcwO7mguYWJp/jslXuFTDcnPrzm
	HHpVuFx2Re2EpI/Q1MjZkMoLBVORYyoylZSFyP5WbtOIqacjyfYXWQG5E6HbkrGm
	P6xa1JSI2K4ajEs3oQOgM6MEqydCZEPyWi0M5+6GUfmBx6Qlna91TDLrxnraXK1f
	w4a/u6e5bqVk7dZ402ta2QbWcWBYflcRLz8VBUk73X0VKhZAioAo/N8CjNrM0VWp
	yGsyOJFEaxJEtfWDWXmpRQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4axbjvg0ac-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Dec 2025 03:21:20 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5B91hhOm038245;
	Tue, 9 Dec 2025 03:21:19 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4avax8j01g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Dec 2025 03:21:19 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5B93I4FW022652;
	Tue, 9 Dec 2025 03:21:19 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4avax8hyys-5;
	Tue, 09 Dec 2025 03:21:19 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: njavali@marvell.com, Shi Hao <i.shihao.999@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, mrangankar@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com,
        James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: qla4xxx: use time conversion macros
Date: Mon,  8 Dec 2025 22:21:04 -0500
Message-ID: <176524933137.418581.17220947366658388847.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251117200949.42557-1-i.shihao.999@gmail.com>
References: <20251117200949.42557-1-i.shihao.999@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-08_07,2025-12-04_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 mlxlogscore=646 bulkscore=0 spamscore=0 adultscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2512090023
X-Proofpoint-GUID: TM2qMgUgSn2d1J-oVWAPKp6xhXd96OH9
X-Authority-Analysis: v=2.4 cv=X/Jf6WTe c=1 sm=1 tr=0 ts=693795b0 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=8rP87g1ZLsSEJHvpKYwA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: TM2qMgUgSn2d1J-oVWAPKp6xhXd96OH9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjA5MDAyMyBTYWx0ZWRfX2/SgzxlkVu3C
 wJo7pFBHV0gXmgQ69i8mK02AzDvj5uN5P+yBJM5tJG+b1TCW3cVcpar7MOOoill7iug+tMbnM86
 +5698gbyoJ7KnE0cS6sO3xWBbt2c2nuj49aClyfPFoi070bt0+4zEasUx9gWgF6B39tedPuCw4+
 CyDjz9fjOUD1UqC/HOjLwKN+6x63MxJNCOKPsbl/9jpL9Y+kyKnL4uWHxfTQPksRSucCq0JlWx2
 i85NHalu3wpbYj/62e/BpuPJxJ//hIMwXwaexJayKoKMfBrObbTKKCuOQFOAWSZIpNDGqtgRlvY
 aXARmpvZLCGH/lucyXV4M2AaoKpwnCDy9wReCHedhowtq5xOGucn6lclAy6nQg2ORQo3b1FIPgG
 IJPeJEhzOFXab6Sfle8oiiQC/Cb+4A==

On Tue, 18 Nov 2025 01:39:49 +0530, Shi Hao wrote:

> Replace the raw use of 500 value in schedule_timeout()
> function with msecs_to_jiffies() to ensure intended value
> across different kernel configurations regardless of HZ
> value.
> 
> 

Applied to 6.19/scsi-queue, thanks!

[1/1] scsi: qla4xxx: use time conversion macros
      https://git.kernel.org/mkp/scsi/c/9086cac895c3

-- 
Martin K. Petersen
