Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B2AF2563;
	Thu,  6 Jun 2024 00:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717633519; cv=none; b=SKnF/45GtFWDQfGOqLi5NPfOoZnuPmldHAgB0NVlxcB+NVzAm6q33zStcS+6ipedTUIBo1a81SeMP9hCSRzMTFXOQo436BnQ2fnrj+WTsvGN6asGhN9jRpkaHh8DE6bcConQlI+qyi1OWAwN7NFWhsoBf9xXHxYjs6qx8FE32Mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717633519; c=relaxed/simple;
	bh=3wZVavp6tao9ffC1YphaeS9zPVgycL7M4c8WdP2SgWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dumPdWXo4Uxi0lHZV6UR74bdgmERBrPsPBMPpQC2HxmPDccMobzUf8CDv+XqBGk2MYh4IDQtlTCBqB0VppQMHCh/BA9QgEQO3AgExq845CzoidcZvZRteUtmdcK1x0YSn7ug0vfZy7ogTCV110C++DSVv6A7GM5QhH9IPFBzxJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=XXAxGoeQ; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XXAxGoeQ"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 455JINiP015747;
	Thu, 6 Jun 2024 00:24:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc :
 content-transfer-encoding : content-type : date : from : in-reply-to :
 message-id : mime-version : references : subject : to; s=corp-2023-11-20;
 bh=1Ww9Rdq98RgqCia4UdhAvlzFlQ7oc3WmT+CLtqus8As=;
 b=XXAxGoeQxY1ylnW621TgDu2TX7CRHbPEikIp5gxSzri56vfRkviA+lFrcCmVYmJ5Fh1g
 ov1BQ7xKbLgZtktlOzKlAhqbx6hnVjt9Fe+PFHIZIoDO0qfJjBh2v9E53rzg2BpPBbH4
 LUcxtvf2QdhtaAXTsMX9etjK4/fOfzld5hcjrkf9n9KXZQAisrl2FvClCaX+62OqqBTS
 VkUwpIYZhttx43q6+WByP3EzU8g3NzCaB2QMVZ5xjJGN9+ZbTlhXU+5xofK66MkDl+tV
 pMMBTr0rEQukzrNEt+Ywjla4O03Ct3+Qd5KyJcR+TRBTn4s/aOoRoY0zY8RvDXeQ0ttS 3Q== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3yjbsyaf9w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Jun 2024 00:24:59 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 455Mat8Y015719;
	Thu, 6 Jun 2024 00:24:58 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ygrjeg0qq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Jun 2024 00:24:58 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4560OwH0004414;
	Thu, 6 Jun 2024 00:24:58 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3ygrjeg0py-1;
	Thu, 06 Jun 2024 00:24:57 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Chaitra P B <chaitra.basappa@broadcom.com>,
        Breno Leitao <leitao@debian.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, leit@meta.com,
        stable@vger.kernel.org, Keith Busch <kbusch@kernel.org>,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mpt3sas: Avoid test/set_bit() operating in non-allocated memory
Date: Wed,  5 Jun 2024 20:24:19 -0400
Message-ID: <171763343411.4164272.12258794227278624618.b4-ty@oracle.com>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240605085530.499432-1-leitao@debian.org>
References: <20240605085530.499432-1-leitao@debian.org>
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
 definitions=2024-06-05_02,2024-06-05_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=586 phishscore=0
 adultscore=0 bulkscore=0 spamscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406060001
X-Proofpoint-GUID: HNWNmYom_xalhO768Wrbf1PkPwmQ6GyN
X-Proofpoint-ORIG-GUID: HNWNmYom_xalhO768Wrbf1PkPwmQ6GyN

On Wed, 05 Jun 2024 01:55:29 -0700, Breno Leitao wrote:

> There is a potential out-of-bounds access when using test_bit() on a
> single word. The test_bit() and set_bit() functions operate on long
> values, and when testing or setting a single word, they can exceed the
> word boundary. KASAN detects this issue and produces a dump:
> 
> 	 BUG: KASAN: slab-out-of-bounds in _scsih_add_device.constprop.0 (./arch/x86/include/asm/bitops.h:60 ./include/asm-generic/bitops/instrumented-atomic.h:29 drivers/scsi/mpt3sas/mpt3sas_scsih.c:7331) mpt3sas
> 
> [...]

Applied to 6.10/scsi-fixes, thanks!

[1/1] mpt3sas: Avoid test/set_bit() operating in non-allocated memory
      https://git.kernel.org/mkp/scsi/c/4254dfeda82f

-- 
Martin K. Petersen	Oracle Linux Engineering
