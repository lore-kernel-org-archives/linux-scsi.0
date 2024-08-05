Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C96B916F0C1;
	Mon,  5 Aug 2024 21:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722892719; cv=none; b=TwW1zaLmr8xEIRKIqh4p0CveVk6Y1jPzN/irlUwMeGVhS8uOciL67+G1y889C1+NrA2yL5QFsTfqLr3pAVxnprrzpOgJnaryOHplfPCFC7Cy6LAzPkOxxuJvIQ95KFjCU+G43QMUTx01ZwqZPxTBxHvhJ1gqNFsXKPQKdXTRVS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722892719; c=relaxed/simple;
	bh=cSzx99ezuLvE8quaQgxBDstq60ZsZ4cIyt3nHW1xCnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lG5hHb4wB9go3//1T58hNGnUpEd0lTSRGf9s9ghx1oPqa4s3k+OmXYz24hg6nHmq6gnS8JyU/MlWET/pekKeVyL0GcLfCMHmzEouKVKNsFoMKSUGCt2w+0G02pFQEuyHGp2bNbF9EEih/2kbIfEfJNWuhZShV4ZVRlWx7+Y0Qa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=HamPhnLO; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HamPhnLO"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 475Kj0TW021864;
	Mon, 5 Aug 2024 21:18:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=
	corp-2023-11-20; bh=FREeHHQkHK5BRHD6WEqyWsKgeEIPCTpzbiCmpK4vpFA=; b=
	HamPhnLO8Ku5ywr0DIpO2zqfGWSn8SSEDhapWdRN5PSVEcvVLOr45MVijVC0Yux6
	ln8mnpdJ6J9uIRVOkMvJ7cqVgxnp/qRRKrFeDl5cQ3oFixXdkH+2JgFb9Y73n0zZ
	n8hixN7Jq9d1NRRjQr90/aT4cE9FXXiR9Sa+ysf1y/4CzIqRixZoyK4i9an3CQNz
	F0QmfAAHqaYfpmtqSIn+6A2yUZyRY8FBuKgf42+OkOQv9Jgv3wSGy9DOrYF643Dn
	WKaSiU7KY3YJkDJ60GB+CBqFz7J/yfNVaCPgm8/xGy/FQHDSi4cjZQDEpg44F8JM
	LzPgGEvcrw2bQiQHZJVVRA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40sc5tbq5q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 Aug 2024 21:18:32 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 475JpYCF035119;
	Mon, 5 Aug 2024 21:18:32 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 40sb07ydm3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 Aug 2024 21:18:31 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 475LINEV035403;
	Mon, 5 Aug 2024 21:18:31 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 40sb07ydcw-7;
	Mon, 05 Aug 2024 21:18:31 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        Kees Cook <kees@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] scsi: aacraid: union aac_init: Replace 1-element array with flexible array
Date: Mon,  5 Aug 2024 17:17:31 -0400
Message-ID: <172289240510.2008326.5832494789959615752.b4-ty@oracle.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240711174815.work.689-kees@kernel.org>
References: <20240711174815.work.689-kees@kernel.org>
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
 mlxlogscore=629 mlxscore=0 adultscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408050151
X-Proofpoint-ORIG-GUID: BqniId9ebzzigtWafz-zrfwhbgKYdhw_
X-Proofpoint-GUID: BqniId9ebzzigtWafz-zrfwhbgKYdhw_

On Thu, 11 Jul 2024 10:48:23 -0700, Kees Cook wrote:

> Replace the deprecated[1] use of a 1-element array in
> union aac_init with a modern flexible array.
> 
> Additionally add __counted_by annotation since rrq is only ever accessed
> after rr_queue_count has been set (with the same value used to control
> the loop):
> 
> [...]

Applied to 6.12/scsi-queue, thanks!

[1/1] scsi: aacraid: union aac_init: Replace 1-element array with flexible array
      https://git.kernel.org/mkp/scsi/c/575b9be63684

-- 
Martin K. Petersen	Oracle Linux Engineering
