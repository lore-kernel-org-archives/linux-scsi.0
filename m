Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C93AC322DB7
	for <linux-scsi@vger.kernel.org>; Sat, 17 Jan 2026 04:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768624629; cv=none; b=t8n6RBvqlcv0TIIgd+ExvGNDvUjZP1cfURNB7F0d2zqyddO3OoFoFD5fxRme9vnt0S9FKwpCdjHf5P+zeaLjlkR54QZtwvkccmBZK0fboIlamMdLeBl5VFBfuIb3LPjUZuWqv757nyEzk3rYHLs3/nnimE1znwqHb4Ijnj9axpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768624629; c=relaxed/simple;
	bh=gGFgiMuY2ZSEv8jZeXjpTTQ2+Vlmtq38nKZDfw4Q0lg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=meRl152Ah93j2Jxrt9msYwqlDUDBX6nWNCAdJBW1i/0NJAp1bpL3cErNmowNlHpjjsFZAcX8UiqqATDO9XJSyyuH6STjvzSpA1DIYjTEsc19sK6Wy81/MgVG0+D1Phnxrt1HzWl7hTht1MTs42pblZXYsTGNTVi7nzouLmBsvcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=kGzFe3Gl; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kGzFe3Gl"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60H25Xeq105369;
	Sat, 17 Jan 2026 04:36:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=uL/LlKIggxz57pnNismDc4nfKZLQH/LB7pGhRGpd64M=; b=
	kGzFe3Gl3eL/+/TpyFdWESVVl1QxxLxmQytNlNHPyhWu2EdZuoE/cyYcZkwDg8Is
	2dMFhmkCrG/4VQZLca9R/ZtdoNeqg7BUCo5Q84TGee2ZLmhHrKBfM/CxV37NvEho
	Tj9pVp4NBT9nZ9JWdwBl5nSXDa8ZddO5nW2XNyghjEfeCAoYj9h6O795VTgexzNF
	95kbNLFMOeMmh9CGpGMbMcK/9zQpysP/X0DFBX9GK4GTyrm2VmDkYtD/Y8sROCMC
	r9BAwGvc70TRLTzFcp+urqmuwu4GIfYuY0S2AFzSmINPNxRdBtrI5g9QAWhpXwC9
	b6WoujBDipRsGOhvync36w==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br1b883at-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 17 Jan 2026 04:36:56 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60H1XlGE008417;
	Sat, 17 Jan 2026 04:36:55 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4br0v6bk4u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 17 Jan 2026 04:36:55 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 60H4at7H005851;
	Sat, 17 Jan 2026 04:36:55 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4br0v6bk4d-1;
	Sat, 17 Jan 2026 04:36:54 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: mpi3mr: Simplify the workqueue allocation code
Date: Fri, 16 Jan 2026 23:36:45 -0500
Message-ID: <176862008996.2331811.12995982356124283742.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260106185723.2526901-1-bvanassche@acm.org>
References: <20260106185723.2526901-1-bvanassche@acm.org>
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
 definitions=2026-01-16_09,2026-01-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=861 mlxscore=0 spamscore=0
 malwarescore=0 bulkscore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601170034
X-Authority-Analysis: v=2.4 cv=WbcBqkhX c=1 sm=1 tr=0 ts=696b11e8 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=KB8hJxlyT7t6aYlWqOwA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE3MDAzNSBTYWx0ZWRfX73m+VtnlWxR4
 qe08pDe1Ok2Gfb2x8sgctZW6F9mslvXd4a55Gm5L4m8a9/fraV57D0GgJUhQT/G+oeyaWZedL8t
 rqsDKxwwnXm37AaJi+epoyuiQqoFni2GYuiZijow+IxKZ5jn2jKg/i6K0K/vwJfeykQKtcq7TNk
 ikrzOeLo+dgSLIjrNRBzskjzoUoWiccYB/vAoSFiZO4DtP1WSZtZzkBvi9VZZCujmqnPituZ2y6
 GE4n18Mzz01UEu5Lg74mmOwHh5Hh7kViAUf9XPMklFKzOIQBzpkBgWQGNkknRKqJEeBnNnzypZv
 iB/6BSYsccOqvmCBMDnkA7rUbouDvtvd2Bs27bAXD97QNSsXMMfNUk4x3d4KxVCS7EURJ5zeQ8t
 SAsp4oMBTZ7lzm1E3E6pfKEAZEMGueYsamEBsgpalnSTIOqkoCvAIyDvMlyWg20MBOIj7/gkOrZ
 vHIdlGQRwicNhuh8pvw==
X-Proofpoint-ORIG-GUID: ZuTEjC_FfO1y1Al6NS8trof6QdeuIg_5
X-Proofpoint-GUID: ZuTEjC_FfO1y1Al6NS8trof6QdeuIg_5

On Tue, 06 Jan 2026 11:57:22 -0700, Bart Van Assche wrote:

> Let alloc_ordered_workqueue() format the workqueue name instead of
> calling scnprintf() explicitly. Compile-tested only.
> 
> 

Applied to 6.20/scsi-queue, thanks!

[1/1] scsi: mpi3mr: Simplify the workqueue allocation code
      https://git.kernel.org/mkp/scsi/c/8d0aecdebc0f

-- 
Martin K. Petersen
