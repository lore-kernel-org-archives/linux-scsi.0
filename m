Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 876451A23A6;
	Wed, 13 Aug 2025 02:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755052004; cv=none; b=t/0DpGygRizkVzE1dvbjBRFcd0fdVTG72dEtKyq2EvIBYNSw+44ktJV/MuakSekLZMxy8syTTWTm3/L2coDhisdIbbQYrsI6/7El/mLrkDWv0zC6A6X0S/hSS5ws/+Giuw2cK9fiUBtSCaOFe7IPhoB5S8L5/OzHMpmj9MXln7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755052004; c=relaxed/simple;
	bh=8ArkzmJg+3YtGE9V7c+QleBD0CKmJU3WsT2mXUJZFWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iQR2AUvc98qytA3jdJeSmJwhGH6oljA1FGY4GX0XYTs9FcxMGzFCj0vAmLVMGsdsk7tgPJ6u8IcHvswEghm+i64Ab1EDD6KNNQF4HA9Ahc6S/krFbFuYSRyxkq/awt/ShlJyxXSTnwJbUQ/XYjZWFkOwPF/9gKGLh/WvttaAtfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=meMRg+s9; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="meMRg+s9"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57CLR3TB005322;
	Wed, 13 Aug 2025 02:26:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=vj3hmSPNTV8YLRr3JR6vfBr0AZ2RzLr2XCBSfE0011Y=; b=
	meMRg+s9VbOegh1btfKsniapdQbrqfoAOzD7fM3U5GOV8j8OyCUvvQeiySxZUDba
	zGyamyKVBUyqB1hKtGIdGe3mGbrK4gvmPsQNU4AQIYL8RcPADeg50XSfUe9imKot
	FMcGSuwHEKxxbpTPanDO7OpkWDOoAzXBTwPgaGc/UamzOWj9HwHXNahQJyVXeRf4
	vtMDS0qYuZRYlNEpgYLVdRE1wArj7xsBCprEd10YkxJJwn2AADd0nUdiSiEtDpGX
	u+KJfa3rSPYkLErwHuR862n0jx8azazR/534zCLQY+XnhO6ftHIwqYenDthbr1pK
	tS5fsn8NADIjAiswnPf7Ew==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48dvrfx6b8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Aug 2025 02:26:37 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57D10E3U030242;
	Wed, 13 Aug 2025 02:26:37 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48dvsarqqd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Aug 2025 02:26:36 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 57D2QaNY004410;
	Wed, 13 Aug 2025 02:26:36 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 48dvsarqpw-1;
	Wed, 13 Aug 2025 02:26:36 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, Jean Delvare <jdelvare@suse.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: lpfc: Fix wrong function reference in a comment
Date: Tue, 12 Aug 2025 22:26:26 -0400
Message-ID: <175504926140.959040.17675997595494377981.b4-ty@oracle.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250731133311.52034cc4@endymion>
References: <20250731133311.52034cc4@endymion>
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
 adultscore=0 mlxscore=0 bulkscore=0 spamscore=0 mlxlogscore=540
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508130022
X-Authority-Analysis: v=2.4 cv=B/S50PtM c=1 sm=1 tr=0 ts=689bf7de cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10 a=VwQbUJbxAAAA:8 a=9vGR7LhBC7VkbwwelnIA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: DXp7BaAbPSdi0teP5ZnpROehXcGAmyZ9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODEzMDAyMiBTYWx0ZWRfXwCsB583CC/7N
 Uc0+VUWHWbOyubiY7ErGpn5McZvtwq4cmc9rSWJpq7ihDzg3NdafRKhzSjdu7j0ny5pqr4l90oa
 emQWzVXLKeEd97q+IKB6sY+8eOAqAD7PikFFXGUX+XmiznoeeWwS4T1MLYjWAE+HYwCXSdpq5YH
 +TfZS8+Wvvdwqri174s7j2pHGuuSFGBQyzdzbF5d4ht78l6IBs5NfrvBoINYtsp259TBP492Zw2
 jFw/Z/rDwhPGnkLxPMXpeh+jWN73ZREnUSWvB/TdhY8aDdy56eBMXrnOprLY0bobtszASNg/8Pr
 bTv2I+oAiZzn02C64ouoabD7W6eWkxYrKLJyBqxnCl8FkXozXZlkxZnzVTRbBBwvXLGuw1+/6p/
 I7dprVZl0shGBlWM9ji9x4WRfS1x8P/+Zn8gZdHPfI452PUe/X5u17PpDgsnMoeYEhW085i9
X-Proofpoint-GUID: DXp7BaAbPSdi0teP5ZnpROehXcGAmyZ9

On Thu, 31 Jul 2025 13:33:11 +0200, Jean Delvare wrote:

> Function scsi_host_remove doesn't exist, the actual function name is
> scsi_remove_host.
> 
> 

Applied to 6.17/scsi-fixes, thanks!

[1/1] scsi: lpfc: Fix wrong function reference in a comment
      https://git.kernel.org/mkp/scsi/c/a59976116a01

-- 
Martin K. Petersen	Oracle Linux Engineering
