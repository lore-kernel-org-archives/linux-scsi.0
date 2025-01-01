Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AA9B2745E;
	Wed,  1 Jan 2025 09:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735722051; cv=none; b=OIYeTR3yVAdj+gTMJ+rhB5ebcNO7Dv717N0fuu5wK7WgmMydiYMsBZMUjiUIh59wwsnxesmAQNUUywShkothW/XxB6QIdbPUXgnhcvHyxn9Hp2X7HhL01LiMbo+I6DsSKqOmRvMFTK5UaxBtaRUZgAvMpgxptbgG/Z3Ft0Fu3YM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735722051; c=relaxed/simple;
	bh=OM/ncQaS93/yYX7C97hBing4zfeCKVDbh8y3CAYBC0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Bcm0DqW+8ATSrQLA1BBKWobe6eRW3OuchPFWiXGjvoSPnUXj8Y+5cbNQ7H4mFulQke5sDoDVSYslD3uPr2IjI3SQ2+W5Q4Aeh3AGPoQ5/3bdttlxc7p9lj5ywn4USQNPocUbb6tXVXKgI4jTjpiING1IBsDp0PPihzIXGxHr2HU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ciFlmpy/; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ciFlmpy/"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5011t8Go009575;
	Wed, 1 Jan 2025 09:00:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=iGqg76
	U8HlpNEFt4o3OaoIEBorgoInbJRPtcYjSOKAQ=; b=ciFlmpy/+FezSVeriB09YR
	IUuqL55g4y38P8XVzYg4htr1kTjiEsjyac/CYajdV63uXJw3ip3id7qDlgehy+6s
	CI3GF1+IKtXG+udTEUpuNqc2avTv9aZPJW4faeZ992pr+CZ/b0EmhGjR2EsUVWei
	V4i2F7N3Y/RJDaZa7/mg/nPZuVYd1C9d6S0EC7/itYT9UHwONn61s/3zPvCEXx1r
	ZO7rwGKA7K/ftIDETXolwGamwSFY0vT803inua0oSp06JKSaGgzA07dNJSp/foc5
	yGZf4FnDtD5c4su6bCN43nXNFVBS2hphRuQbdWbxNOTg1yzgrD79xgwf0xo+1xHg
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43vtea97y0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 01 Jan 2025 09:00:42 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5016AnFc010191;
	Wed, 1 Jan 2025 09:00:42 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 43tvnndmjq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 01 Jan 2025 09:00:41 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50190aVY61473188
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 1 Jan 2025 09:00:36 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4B95D20043;
	Wed,  1 Jan 2025 09:00:36 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C44A620040;
	Wed,  1 Jan 2025 09:00:31 +0000 (GMT)
Received: from li-c439904c-24ed-11b2-a85c-b284a6847472.ibm.com.com (unknown [9.43.115.214])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  1 Jan 2025 09:00:31 +0000 (GMT)
From: Madhavan Srinivasan <maddy@linux.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, linux-scsi@vger.kernel.org,
        Andrew Donnellan <ajd@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, fbarrat@linux.ibm.com, ukrishn@linux.ibm.com,
        manoj@linux.ibm.com, clombard@linux.ibm.com, vaibhav@linux.ibm.com
Subject: Re: [PATCH 0/2] Deprecate cxl and cxlflash drivers
Date: Wed,  1 Jan 2025 14:30:28 +0530
Message-ID: <173572166175.1873884.15485161198409868012.b4-ty@linux.ibm.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241210054055.144813-1-ajd@linux.ibm.com>
References: <20241210054055.144813-1-ajd@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ZJov24o5csKLm4xMhV3O1Z5ST7_OpKt_
X-Proofpoint-GUID: ZJov24o5csKLm4xMhV3O1Z5ST7_OpKt_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 suspectscore=0
 malwarescore=0 impostorscore=0 adultscore=0 mlxlogscore=611 clxscore=1011
 spamscore=0 mlxscore=0 priorityscore=1501 lowpriorityscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2411120000
 definitions=main-2501010077

On Tue, 10 Dec 2024 16:40:53 +1100, Andrew Donnellan wrote:
> This series marks the cxl and cxlflash drivers as obsolete/deprecated,
> disables them by default, and prints a warning to users on probe.
> 
> CAPI devices have been out of production for some time, and we're not
> aware of any remaining users who are likely to want a modern kernel.
> There's almost certainly some remaining driver bugs and we don't have much
> hardware available to properly test the drivers any more.
> 
> [...]

Applied to powerpc/next.

[1/2] cxl: Deprecate driver
      https://git.kernel.org/pub/scm/linux/kernel/git/powerpc/linux.git/commit/?h=next&id=5731d41af924b764f32532d39d37a15f669c1e01 
[2/2] scsi/cxlflash: Deprecate driver
      https://git.kernel.org/pub/scm/linux/kernel/git/powerpc/linux.git/commit/?h=next&id=f117051514c33c43b7e0c517e0ae9e0189e884da 

Thanks
