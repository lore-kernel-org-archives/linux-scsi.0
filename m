Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2F0F1A070E;
	Thu, 19 Sep 2024 15:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726761258; cv=none; b=kc0gwxNGEfPOEiPvigkGwxJ1Gx4Fg5IfOPFoTxzHQNpfyuZ/NRXmeX6hzUcH4hnDgoTh3ujVKcsbs8tfn1XLmqIgouRpwO2Q6Z8Fyn1uVQlPkgeSSp3L+WcflyKK5nN5Ha3uBjuMPeQgR4Wuk8rAHmFGyRJCoz9/UTOPwc7Y9Fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726761258; c=relaxed/simple;
	bh=JQO25n3k3vstu4ts+z91Yzk/TvTOV83zbXFRjgSwCNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QQInR6n5iPfWd/ISxNNmnO+6zK46qN4qSZh/Kw3Mh6wfuQv33CAY9jc1T0tv81mCIwOCiJ9qKJuuA5D6hPRS9qVjumAciVQlEm1TtskLpPwMmSeEG1qLLmF4qojOeOFVk21fjGTXVdi0ZjVtx/j7ELFkWlWgw6m7ysz78eCpMKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bGbA0eRC; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bGbA0eRC"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48JEal9J003659;
	Thu, 19 Sep 2024 15:54:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=
	corp-2023-11-20; bh=IY0Aejd7Foz1guIm3ThzIWgT2e9OwO3i6sFiEpk2r7Q=; b=
	bGbA0eRCduD5nVx+F/hxfrrpCydsr3uYTnF7uvZIGY9r1qx7ze1iQb2U0s4U9G3Y
	OYwDfNv167+wqK0NsEK+YSQf/aGm3PoJjfJhilvitxNYnSzI8+zMeh+4kzf/excD
	D4rlQpLY1jofk2qqwpn6CtxVvGIIEUrFPxgG5r0DIU1VBc+w85IL0v41b1odenLB
	Nbx5EMJchAqhm2nlvc+3VVojjvQ+53GQ9Tnee8T3N1Ll3DqihE4M1CYQkXdUexq4
	NswG04UtyTGWeFQ0814v8u48FHMc/NW8PJTfbSAmhdPl5n0kDEthgoQg+riLnRx6
	6+YYRlKANNm5hXqTMnaLbg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41n3nsmkx7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Sep 2024 15:54:01 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48JEeNe9010443;
	Thu, 19 Sep 2024 15:54:00 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41nyb9xjjx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Sep 2024 15:54:00 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 48JFri97031813;
	Thu, 19 Sep 2024 15:53:59 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 41nyb9xj7h-15;
	Thu, 19 Sep 2024 15:53:59 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Kai.Makisara@kolumbus.fi, Rafael Rocha <vidurri@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, rrochavi@fnal.gov
Subject: Re: [PATCH] scsi: st: Fix input/output error on empty drive reset
Date: Thu, 19 Sep 2024 11:53:01 -0400
Message-ID: <172676112033.1503679.5048085390706628215.b4-ty@oracle.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240905173921.10944-1-rrochavi@fnal.gov>
References: <20240905173921.10944-1-rrochavi@fnal.gov>
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 adultscore=0 malwarescore=0 suspectscore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409190105
X-Proofpoint-GUID: IfsKOtBy9IX49kdas-XkpndTWcqfWh0r
X-Proofpoint-ORIG-GUID: IfsKOtBy9IX49kdas-XkpndTWcqfWh0r

On Thu, 05 Sep 2024 12:39:21 -0500, Rafael Rocha wrote:

> A previous change was introduced to prevent data loss during a power-on reset
> when a tape is present inside the drive. This change set the "pos_unknown" flag
> to true to avoid operations that could compromise data by performing actions
> from an untracked position. The relevant commit is:
> 
> Commit: 9604eea5bd3ae1fa3c098294f4fc29ad687141ea
> Subject: scsi: st: Add third-party power-on reset handling
> 
> [...]

Applied to 6.12/scsi-queue, thanks!

[1/1] scsi: st: Fix input/output error on empty drive reset
      https://git.kernel.org/mkp/scsi/c/3d882cca73be

-- 
Martin K. Petersen	Oracle Linux Engineering
