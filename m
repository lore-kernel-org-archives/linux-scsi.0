Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBB9A1BF58
	for <linux-scsi@vger.kernel.org>; Tue, 26 Mar 2024 01:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711416197; cv=none; b=YX/yeUOC5/4J5V8JsnicZMBeMJxcDkwnIEWE0KBAIeqS6yWNMma15St/axcvRv4BfBnL7G9lHnOahfI+tCt6ryGoA2wJfj6WMk/2VxZ3pmIDu7ELEAV80zecewRRmqWOolszqd7cowx/51oSiM/vik3kdmTyj4o7KF+iH3gOoUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711416197; c=relaxed/simple;
	bh=9i84oC58FYE0hg+bLuOY5NT9EmgMwP6LVqDZuB01wKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kxg1rtfnd3J3UuNIb0HH4l2ErI8laaullVi/6mrAmJhh2t1Szu5m7yN2Pp+bxDKOFiFqU34QCyduEA8tRgy+3VKXvsoxHMAhc8AL72dIFUlTwb6gtPDpJUfXpfTsnx3jCCLEB23UTWydVFgB/duk+Iwxcu8edpAuNqF9wNqdk5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=gIVJV7fq; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gIVJV7fq"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42PLG26g002315;
	Tue, 26 Mar 2024 01:22:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-11-20;
 bh=zXHdVQNEuzp2VssEb9YhnIRWOkED5LBtUy+IJW96VWo=;
 b=gIVJV7fqJJBJ4tsJTJablvORFzGhZkpZkCo3fAv++8ptd5+OVTsQBCAXCHLOI/o65mrJ
 WgDUjgkio1Jp/fYIosg4dGhM7U1UxZKvf0kn3Y5GUC6S2MzJHT/OnJXxozyZQ39EZ1TB
 r6O0Dt47scyBTiH3czBdWEOHHf9zVTP6OhPyW2oF3kzxVdPem15ebDucz9nbG1I9Bl5z
 U92jY8x/vbehMc3q/GoZ8til6qSiQzC9ejAymdT57CqLxy5CI4bwqeOq7LmJjSEp6a8V
 pfrwrF1vU/6fVSDiKMSZZAxuBWScQkkWoZEZXy8q3wMTvP2FnCMpwsvnD//fZwf/S44q Bw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x1np2c0bx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Mar 2024 01:22:06 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42Q17Sxw024221;
	Tue, 26 Mar 2024 01:22:05 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nh6hftq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Mar 2024 01:22:05 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 42Q1Lx4G002449;
	Tue, 26 Mar 2024 01:22:05 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3x1nh6hfkw-5;
	Tue, 26 Mar 2024 01:22:05 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Saurav Kashyap <skashyap@marvell.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        GR-QLogic-Storage-Upstream@marvell.com, linux-scsi@vger.kernel.org,
        Guangwu Zhang <guazhang@redhat.com>,
        Nilesh Javali <njavali@marvell.com>
Subject: Re: [PATCH] bnx2fc: Remove spin_lock_bh while release resources after upload.
Date: Mon, 25 Mar 2024 21:21:47 -0400
Message-ID: <171141606221.2006662.16842567261279463197.b4-ty@oracle.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240315071427.31842-1-skashyap@marvell.com>
References: <20240315071427.31842-1-skashyap@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-25_26,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=699 mlxscore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2403260007
X-Proofpoint-GUID: lkk-nEt3NDaXV5AOXbJ2fSIsDyU-L6jQ
X-Proofpoint-ORIG-GUID: lkk-nEt3NDaXV5AOXbJ2fSIsDyU-L6jQ

On Fri, 15 Mar 2024 12:44:27 +0530, Saurav Kashyap wrote:

> The session resource are used by FW and driver when session is
> offloaded, once session is uploaded these resources are not used.
> The lock is not required as these fields won't be used any longer.
> The offload and upload call are sequential, hence, lock is not
> required.
> 
> This will supress following BUG_ON.
> 
> [...]

Applied to 6.9/scsi-fixes, thanks!

[1/1] bnx2fc: Remove spin_lock_bh while release resources after upload.
      https://git.kernel.org/mkp/scsi/c/c214ed2a4dda

-- 
Martin K. Petersen	Oracle Linux Engineering
