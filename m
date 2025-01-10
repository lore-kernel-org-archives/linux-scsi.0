Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19E43192D9E
	for <linux-scsi@vger.kernel.org>; Fri, 10 Jan 2025 21:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736543804; cv=none; b=q+LTfdkleVhOiAzEwqF5XNFma6le4vEaZMKYozrmEPXVPs5xCEDv+EHkEfYSRWqtvsrnOVpbj6zgyZS4E1wX6ryaq3nH3JIXcd07KvgWx+oUYMkzvSmeI5oAVXbx8nHyz0/CxcOxcQCd9P9MyOPPdtcAhtHIYUmoTu4dUVFWhTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736543804; c=relaxed/simple;
	bh=8s0IlPS2AtXxZ1eouQ21qiuYXdKD/xnWtw1c/ciPtcg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lTsHSJpWiE5PZ21gG1LmnGmWb2zaHGM9fag2JjgzJ2K45y4xApH/aC92vBvXYrhHGcyVWrzFNrDBd1U12DIOq+CF0KGQO2E2fwbTiapI5e4kYZjVrYGOdY0tIj2a4GP68WNj4oL00+s3ANEu0bQxFSSgiuoiS0Oy+e9uTydLRsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IXQRA7PX; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IXQRA7PX"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50ALBnRW018749;
	Fri, 10 Jan 2025 21:16:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=BlwmBqihq9YQJhPv9mKmdpF7Zo5CSmfO7zXT2qyGDCg=; b=
	IXQRA7PXnHKoJUCoy6q+vIwMNfvLMaoXFwUaGAjp/g/c0mSCETAPM4NDm4bOrlXl
	Lrc7+oVKmzeNWMilWND3qI+zE2bzPpAQeb4Q6Mlblce4GhZ0WKKFylnHpGQIlBmk
	NHVq3LOeA3BDVcrvxDNgtPW0Ve5bZXboCnDaMbL96pRZHONKtDo4AxCJdkyFBQYG
	VcCdbPG4ODAgflHnoVtAdIsPmMMcNCWNyOK/9p5JRj9eizEbrVKwQvpMaY8ZXMUv
	1/SOL6K6/7nvOTWEYdxaYkvW6ZWpVZuLW966CYykQn5C5Kvspdyz4CcGOoJ0a46b
	ZCaBVvmgRXsxxkj9g8Rg0Q==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 442kcxabbk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 21:16:24 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50AJNbIv020026;
	Fri, 10 Jan 2025 21:16:16 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43xueka8rj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 21:16:16 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 50ALGFfs021917;
	Fri, 10 Jan 2025 21:16:16 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 43xueka8r5-2;
	Fri, 10 Jan 2025 21:16:16 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
        Mike Christie <michael.christie@oracle.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Kris Karas <bugs-a21@moonlit-rail.com>
Subject: Re: [PATCH 1/1] scsi: Fix command pass through retry regression
Date: Fri, 10 Jan 2025 16:15:49 -0500
Message-ID: <173654052309.609313.1654952382560559169.b4-ty@oracle.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20250107010220.7215-1-michael.christie@oracle.com>
References: <20250107010220.7215-1-michael.christie@oracle.com>
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
 definitions=2025-01-10_09,2025-01-10_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501100164
X-Proofpoint-ORIG-GUID: 1zQYfJt4f9ja30hQ9OKPwn6JB75U-yH7
X-Proofpoint-GUID: 1zQYfJt4f9ja30hQ9OKPwn6JB75U-yH7

On Mon, 06 Jan 2025 19:02:20 -0600, Mike Christie wrote:

> scsi_check_passthrough is always called, but it doesn't check for if a
> command completed successfully. As a result, if a command was successful
> and the caller used SCMD_FAILURE_RESULT_ANY to indicate what failures it
> wanted to retry, we will end up retrying the command. This will cause
> delays during device discovery because of the command being sent multiple
> times. For some USB devices it can also cause the wrong device size to be
> used.
> 
> [...]

Applied to 6.13/scsi-fixes, thanks!

[1/1] scsi: Fix command pass through retry regression
      https://git.kernel.org/mkp/scsi/c/8604f633f593

-- 
Martin K. Petersen	Oracle Linux Engineering
