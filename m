Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9584E132114
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jul 2024 01:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721697863; cv=none; b=oU5FO0B/5CH2QS2+ZPkmC7m5xVjyPJ3jHfA0bwz6UIHt8RCSdGwANixvwkbUiCr62r5gvkvFGdNwyozWhNSc4jZE0fZKGxM8lpEk0b1K+lOSYT1gSeHKAHKsKI7yKzjlImacCzjZzxdhcGeWkC9Hrx1rCq6YcBT+ixdNr1u+3TE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721697863; c=relaxed/simple;
	bh=jOyuhlqYTZADZ7GHGWkAeSDxB6R9qEQP9GfAatxIzlA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bqi7TPZe26bTmjjewbe+vtd7gr+sbxDGSIPbsLA2Z2tKvRiKKonxmt8DFGx8drZB0UBpJ2aerjsyFa8tindHqfF1q9kXI89KuPm4iU7eR+E9xumuE0MQ41Jfn6ujuxrH3nb38U1yT2S0syRQL+W4mWFBi8i4yUx+LmqziLjK3Pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=H+icMT1N; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="H+icMT1N"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46MKtWTP018334;
	Tue, 23 Jul 2024 01:24:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=
	corp-2023-11-20; bh=3LAwEMcZJkSTIaC24bJC8J76h4QJhnUANf3s/HLb6zo=; b=
	H+icMT1NsPA/DcWx3mBB6b4accEvzxWv6TP4gaHKjEow9bZ9eK54ZD5I8hQMc1G3
	UYNKWzvvYfDr0JcWHafg1d7e6kCvGE5a9ckoMgSjqXc54Ab6E2zydB7biP8hTWOj
	DGE9fgH/O1LwgP5nLBPU36sjFjwRANHxDp/+8B9q1yAPAf0mweHzakXd9xwPgnpR
	mUnAtKrZQ8Tg0HPVBPwWtL1C7Ao8IoyWGIcHyopWqz2NQ72CEey3mHDcqIKaphVh
	iUSDLjx3zMu5Ko7zKFkYAB3CIkR4FpaOUb+t3Cvh0efh/IsryxkrTKSNbbt+aqur
	xL3w6Nfe9fJM5u40vKGVbw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40hft0ccm1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Jul 2024 01:24:10 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 46MMvS3F018835;
	Tue, 23 Jul 2024 01:24:09 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 40h27xysqn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Jul 2024 01:24:09 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 46N1O683005270;
	Tue, 23 Jul 2024 01:24:08 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 40h27xysph-2;
	Tue, 23 Jul 2024 01:24:08 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, avri.altman@wdc.com, alim.akhtar@samsung.com,
        jejb@linux.ibm.com, peter.wang@mediatek.com
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
        chun-hung.wu@mediatek.com, alice.chao@mediatek.com,
        cc.chou@mediatek.com, chaotian.jing@mediatek.com,
        jiajie.hao@mediatek.com, powen.kao@mediatek.com,
        qilin.tan@mediatek.com, lin.gui@mediatek.com, tun-yu.yu@mediatek.com,
        eddie.huang@mediatek.com, naomi.chu@mediatek.com,
        chu.stanley@gmail.com
Subject: Re: [PATCH v1] ufs: core: bypass quick recovery if need force reset
Date: Mon, 22 Jul 2024 21:23:21 -0400
Message-ID: <172168235253.1161648.8454083361308890112.b4-ty@oracle.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240712094506.11284-1-peter.wang@mediatek.com>
References: <20240712094506.11284-1-peter.wang@mediatek.com>
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
 definitions=2024-07-22_18,2024-07-22_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 spamscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2407110000 definitions=main-2407230008
X-Proofpoint-GUID: A3DPHEDrOlJye2nXTwnDGsw_dPbV0wfl
X-Proofpoint-ORIG-GUID: A3DPHEDrOlJye2nXTwnDGsw_dPbV0wfl

On Fri, 12 Jul 2024 17:45:06 +0800, peter.wang@mediatek.com wrote:

> If force_reset is true, bypass quick recovery.
> This will shorten error recovery time.
> 
> 

Applied to 6.11/scsi-queue, thanks!

[1/1] ufs: core: bypass quick recovery if need force reset
      https://git.kernel.org/mkp/scsi/c/022587d8aec3

-- 
Martin K. Petersen	Oracle Linux Engineering
