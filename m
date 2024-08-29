Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B9061BC58
	for <linux-scsi@vger.kernel.org>; Thu, 29 Aug 2024 02:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724899889; cv=none; b=oKZP1711ZUWROLJ4olaxl9tUB+2bO6NYbp7BrRNJyDaoAGb8Iqr08ufW2TmN1GXXIxQ7w6dXEpUqbMkDOGipwqqbylJcuLkKRwRYbkOc4mCycwZJizlTJHOKxyGxUvE9qH1rAEU9JnQavaGqK3s6V+YxPqQmUd/NW+Zr5Aq9yZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724899889; c=relaxed/simple;
	bh=p6tTg41qtcKl+Z4LusMalY2IvkNr6xYgkix8JTkstrQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g3Y1kAUte4OEggucyhsp5nLyYxpbo/jX5P6cJqiVazO1epyNOHs9xQ2hszRCgjv5CkV/9lF2obeL8UcztdfrIl09FcVjeum0U9jxg195SoPcvHs6MT2Im4ctk2J2wR4Y8h2B4zURM1WjcaW4A6YDTwJR0hjvsTyCiK6pFg7qoe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=A/hLsoEU; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="A/hLsoEU"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47T1fUgi010605;
	Thu, 29 Aug 2024 02:51:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=
	corp-2023-11-20; bh=IcnjNUbM2hyz5OOFNP8I7vZ2ebIqwMxIrdxhVybRE7A=; b=
	A/hLsoEUFnutUO41WxK6OnnqoJ2AXOsoIFJ1HuoALm492/tBAW4zt9K33D2l1D6b
	zlpKeQAhienQxB/RmUHK+lpydg+2KpWEW8dvJ6pzNLpaTnLcVUxtRriqpQzxLYhm
	XFb8bf6yA8rvd2sHBW5eDSa26ZT8qkqXCB+BBXWb1Hl2QJ7KySFLUuyuWdtks3cc
	VmvmZrRAciWhHJJPE6be6beEL4/c3g6DXZ+dLvZUif5GF5xnDguxoEi0zOe47A6O
	zA4kuA0Q5vX6m1HwbdwWB9aYzGsWXvuvoRpnKFGfrvDwngCk4cnh22K3S8KYvfu3
	75kkP5+T8cVgK49kzdBjKQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 419pugu7re-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Aug 2024 02:51:22 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 47T249GK010667;
	Thu, 29 Aug 2024 02:51:22 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41894q4qka-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Aug 2024 02:51:21 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 47T2pKYm013333;
	Thu, 29 Aug 2024 02:51:21 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 41894q4qje-2;
	Thu, 29 Aug 2024 02:51:21 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v3 00/18] Simplify multiple create*_workqueue() invocations
Date: Wed, 28 Aug 2024 22:50:43 -0400
Message-ID: <172489245036.551134.17219231951489022487.b4-ty@oracle.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240822195944.654691-1-bvanassche@acm.org>
References: <20240822195944.654691-1-bvanassche@acm.org>
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
 definitions=2024-08-29_02,2024-08-28_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 spamscore=0
 mlxlogscore=832 adultscore=0 suspectscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408290020
X-Proofpoint-GUID: 0z9tNfTeUDCt_8S7Q3k2cP-mYtig3amr
X-Proofpoint-ORIG-GUID: 0z9tNfTeUDCt_8S7Q3k2cP-mYtig3amr

On Thu, 22 Aug 2024 12:59:04 -0700, Bart Van Assche wrote:

> Multiple SCSI drivers use snprintf() to format a workqueue name before
> invoking one of the create*_workqueue() macros. This patch series
> simplifies such code by passing the format string and arguments to
> alloc_workqueue(). Additionally, the structure members that are only used
> as a temporary buffer for formatting workqueue names are removed. Please
> consider this patch series for the next merge window.
> 
> [...]

Applied to 6.12/scsi-queue, thanks!

[01/18] scsi: Expand all create*_workqueue() invocations
        https://git.kernel.org/mkp/scsi/c/b97c0741c7dc
[02/18] scsi: mptfusion: Simplify the alloc*_workqueue() invocations
        https://git.kernel.org/mkp/scsi/c/dec523975b85
[03/18] scsi: be2iscsi: Simplify an alloc_workqueue() invocation
        https://git.kernel.org/mkp/scsi/c/66088e7b9182
[04/18] scsi: bfa: Simplify an alloc_ordered_workqueue() invocation
        https://git.kernel.org/mkp/scsi/c/70fbb7c11507
[05/18] scsi: esas2r: Simplify an alloc_ordered_workqueue() invocation
        https://git.kernel.org/mkp/scsi/c/4cb1b41a5ee4
[06/18] scsi: fcoe: Simplify alloc_ordered_workqueue() invocations
        https://git.kernel.org/mkp/scsi/c/d77381c2f62a
[07/18] scsi: ibmvscsi_tgt: Simplify an alloc_workqueue() invocation
        https://git.kernel.org/mkp/scsi/c/5615cfb3cbad
[08/18] scsi: mpi3mr: Simplify an alloc_ordered_workqueue() invocation
        https://git.kernel.org/mkp/scsi/c/1bd289620e42
[09/18] scsi: mpt3sas: Simplify an alloc_ordered_workqueue() invocation
        https://git.kernel.org/mkp/scsi/c/b3b359ac7267
[10/18] scsi: myrb: Simplify an alloc_ordered_workqueue() invocation
        https://git.kernel.org/mkp/scsi/c/c57a617fd53f
[11/18] scsi: myrs: Simplify an alloc_ordered_workqueue() invocation
        https://git.kernel.org/mkp/scsi/c/f30679166255
[12/18] scsi: qedf: Simplify alloc_workqueue() invocations
        https://git.kernel.org/mkp/scsi/c/8bbe60bbd43d
[13/18] scsi: qedi: Simplify an alloc_workqueue() invocation
        https://git.kernel.org/mkp/scsi/c/19d7cda1c630
[14/18] scsi: snic: Simplify alloc_workqueue() invocations
        https://git.kernel.org/mkp/scsi/c/6411307b6328
[15/18] scsi: scsi_transport_fc: Simplify alloc_workqueue() invocations
        https://git.kernel.org/mkp/scsi/c/06d53789761c
[16/18] scsi: stex: Simplify an alloc_ordered_workqueue() invocation
        https://git.kernel.org/mkp/scsi/c/0ef9b0186dae
[17/18] scsi: ufs: Simplify alloc*_workqueue() invocation
        https://git.kernel.org/mkp/scsi/c/1aa992cbc272
[18/18] scsi: core: Simplify an alloc_workqueue() invocation
        https://git.kernel.org/mkp/scsi/c/ba52850cb6b4

-- 
Martin K. Petersen	Oracle Linux Engineering
