Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3642C17545
	for <linux-scsi@vger.kernel.org>; Tue, 21 May 2024 02:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716259265; cv=none; b=mMChBspZbhfGXZQYhwbF/g+0lnuZh7Sak7Ajtgs+UjQnE/szFM7QT4HPtSvLvPlC+JMRO4Z6OuJ//ufY1JAsEQ61maj8ehMjyUSHSB0mvpD/adExXAzZYtaFoj6zS0He09bgm0Uit45bhgEdPbif+CbvuBYkWC5IVpTh1Aq13bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716259265; c=relaxed/simple;
	bh=CAxArys7AACDrns6RZliH4jzDgc0eCF/xx4FSq/2+T0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RpHQT2vEQgLslFdGNOnXPzmmvP4fD1VfkXeRkRiQth1VMtndksXGpo9gBFx2kYijsQkKEWXzqMOxneNwCNLrWejpkm22XilffP8gh9IYyg2dwaYC/UFNyct1l+fDqOYGEXH2zmZ8Lt/EW9QGeD+Xz/tXNh+G1t3XtPoyh79i3kU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=BU+ldhz2; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BU+ldhz2"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44KNKDFl001525;
	Tue, 21 May 2024 02:41:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-11-20;
 bh=y2Olu3a+gifQ3e5TOj2wQ71VmbrR0t1MzgJaxZeUlYc=;
 b=BU+ldhz2C/o6eKbjtEammBNHgCuFgbOo4nGAepf2qMnwE9a1s8dcr/Ztk59BVsaGx69L
 NvbmIti0AnygWcB2z64Iyb51LDSyX9BVfX1w7UotXOCwtrXZ5OSFW4PsoW/7rUJ/AveW
 iALeCVbuI6BmDnYy0tkPiX6udPRmw/aj6gP1dte+SxhKQBFHECljuoSGqowegkCKfNC+
 hLwOWGYgUDSILu8QUeLq9sgqX3rU/PuUt+tVotqCPskcUSZMB2zO7kaeY29tJ/21CvU7
 EnnuvgwButQn6tM/Hk0KpigH6A9vrkn9w9JymyDZv4JPOUZxjX1LVX00fOooSif3NPkB tQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3y6m7b3uq5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 May 2024 02:41:02 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44L2SmNc002774;
	Tue, 21 May 2024 02:41:01 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3y6js72bgp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 May 2024 02:41:01 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 44L2excq013516;
	Tue, 21 May 2024 02:41:00 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3y6js72bfn-4;
	Tue, 21 May 2024 02:41:00 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Saurav Kashyap <skashyap@marvell.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        GR-QLogic-Storage-Upstream@marvell.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2 0/3] qedf misc bug fixes
Date: Mon, 20 May 2024 22:40:17 -0400
Message-ID: <171625915913.2717551.9388300921053108665.b4-ty@oracle.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240515091101.18754-1-skashyap@marvell.com>
References: <20240515091101.18754-1-skashyap@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-21_01,2024-05-17_03,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 suspectscore=0 spamscore=0 mlxscore=0 adultscore=0 mlxlogscore=818
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405210020
X-Proofpoint-ORIG-GUID: PWSAOrxfCRUaCI7P9dspLtCv--3iYUyv
X-Proofpoint-GUID: PWSAOrxfCRUaCI7P9dspLtCv--3iYUyv

On Wed, 15 May 2024 14:40:58 +0530, Saurav Kashyap wrote:

> Please apply the qedf driver fixes to the
> scsi tree at your earliest convenience.
> 
> Thanks,
> Saurav
> 
> v1->v2:
> - Merged uininitalize qedf warning patch.
> 
> [...]

Applied to 6.10/scsi-queue, thanks!

[1/3] qedf: Don't process stag work during unload and recovery.
      https://git.kernel.org/mkp/scsi/c/51071f0831ea
[2/3] qedf: Wait for stag work during unload.
      https://git.kernel.org/mkp/scsi/c/78e88472b609
[3/3] qedf: Memset qed_slowpath_params to zero before use.
      https://git.kernel.org/mkp/scsi/c/6c3bb589debd

-- 
Martin K. Petersen	Oracle Linux Engineering
