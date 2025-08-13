Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B61101DFE09;
	Wed, 13 Aug 2025 02:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755052012; cv=none; b=azPXUm43bZy0JbGdxBEVdYNtr1QBaTmtxH0NE8Ozf/7g2bz7Atbb80nb6SxADGkptDmNpaQd/Pyf+awI9nRuS/+ehrqDVtWvXTK14u5mk0DTXnncZ8siAmOYNhVFAFHHIIDdIHoHWk3hTkaiNZO0Vtdbkp03fDqrsPy1itRI5S0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755052012; c=relaxed/simple;
	bh=qZ/ufpn8BKzL1WoHIgc6fius6PHeGC33aJ9tGGnau2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e8iLEMyp00MjOSbMAIoHl3/6yUDGqazS5Cnpwew39uLC+QQepd27+rgRELV+zQ3yxGDFaeUp9HETRJ9PPeQAeV7yFg9LjENUvO8ihCxDE8xd5pKl4cqbBsbQbcuSM99fEa8koh/xD6PBX0/XRBMHR0zy0xrfecSmqgunP72VwO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Eo+1ssNh; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Eo+1ssNh"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57CLR71U027960;
	Wed, 13 Aug 2025 02:26:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Um7Ftz2a9Gxqh6yDazlSEYLyO0pibTwEm7GgOmUbkzk=; b=
	Eo+1ssNhN6650v8o/LMZx2FW9gAWagdhwNRLl+ubpPrY4O+R5K9N12zEhNjAvV4r
	dtrr4WzVJVfhjTuyez6fyzEmLgbUFEh9RlugPT6oj63Rct+QYcvKSlJzwP/2irTj
	ZoTf/2B87ytlFe+ZNlnqiprvIk7gaKW8a7jvGaekzQslF4HfTyuxDqseu4D9k3u8
	Cf9ecZ2tym4s7iltwX68Vp+uCgAFFt6/R4K7duOSTLfkwwadVHRtYRBVa+YCCQSj
	9G3/nwQurZOpUhuFDi0QHBs0fRExmFFvVFIZvjwss6i7LDmeQ8CE8ij7bHhppTWx
	DrS0t45YOPv3Hw524ZA7Ng==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48dxcf69hr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Aug 2025 02:26:40 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57D25ou5030254;
	Wed, 13 Aug 2025 02:26:40 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48dvsarqrd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Aug 2025 02:26:40 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 57D2QaNc004410;
	Wed, 13 Aug 2025 02:26:39 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 48dvsarqpw-3;
	Wed, 13 Aug 2025 02:26:39 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Waqar Hameed <waqar.hameed@axis.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, kernel@axis.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] scsi: ufs: core: Remove error print for devm_add_action_or_reset()
Date: Tue, 12 Aug 2025 22:26:28 -0400
Message-ID: <175504926155.959040.11869002718065823267.b4-ty@oracle.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <pndtt2mkt8v.a.out@axis.com>
References: <pndtt2mkt8v.a.out@axis.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-12_08,2025-08-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 adultscore=0 mlxscore=0 bulkscore=0 spamscore=0 mlxlogscore=916
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508130022
X-Proofpoint-GUID: BAvCVtlCWjQMdT78Yj-y5SpCg0e8lXSu
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODEzMDAyMiBTYWx0ZWRfX90KX3tldT5V2
 +gp4jwn8nYHU0cs2Uh+huTOO03M52QdVUqZuemmxDi71vbSD5f7TPZFk6P20KajFnL5XGZ2dTD9
 lEDr+AgJvIAgYqxwjIJvBV0mRSIf5MLXXVLUF9oWXC3MayB9r1ndM2fW0XwMoPrnFw0XshYNPx3
 8onHik0DfGVJCc2UFRHEo9/dQb5WzvLvmn5yR02z32UqYrYcR7n/Km8ay8/TdAx/XQ73WDdOcHM
 YaBH6wlBh7t3sbWk09OStb73G6fUnJVBDcMs9icK4JElaVSHgBoSuucbm55Era2IuQ4/EGPfkIr
 ltMFjYkkwVOeHc4xHNLgNIiajCvhAOCajQ1Ng+HoBOLstJ3tEdu0Ndm0WIcUjFUd6pRcKAaidRx
 EeIbV/t9cLR77qcz04m4g0g4osTTKqzJrLeMo4oVSWjiYUIUMjvLlwRUd6T9rZP1BypLyXT6
X-Authority-Analysis: v=2.4 cv=W8M4VQWk c=1 sm=1 tr=0 ts=689bf7e1 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10 a=VwQbUJbxAAAA:8 a=mpvREF5a7mMPylFIW4IA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: BAvCVtlCWjQMdT78Yj-y5SpCg0e8lXSu

On Tue, 05 Aug 2025 11:33:36 +0200, Waqar Hameed wrote:

> When `devm_add_action_or_reset()` fails, it is due to a failed memory
> allocation and will thus return `-ENOMEM`. `dev_err_probe()` doesn't do
> anything when error is `-ENOMEM`. Therefore, remove the useless call to
> `dev_err_probe()` when `devm_add_action_or_reset()` fails, and just
> return the value instead.
> 
> 
> [...]

Applied to 6.17/scsi-fixes, thanks!

[1/1] scsi: ufs: core: Remove error print for devm_add_action_or_reset()
      https://git.kernel.org/mkp/scsi/c/72fc388d8bc0

-- 
Martin K. Petersen	Oracle Linux Engineering
