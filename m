Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE3EC2BE7D5;
	Thu, 13 Nov 2025 02:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763002047; cv=none; b=I6p+fFxGFH4wcdP6HKoo1fOJQxie6i2P/vLWRcdjoJrz5ZWZzjFqctUbjto1SSs+WFeB2Dk3HU22CRH74E28nntTgGhNy4YLSEGBzXujx1+PCFCe6+5pFVRJ1GB+7xI4XnNROu30dPEOAxj5MhBsHFH7SwpqyHG5fEZIlnKENys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763002047; c=relaxed/simple;
	bh=PXWcE/xI7qkP7H6CI7kmLxfiuTDER0C2S+hKw35Fahk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SxO7gM3yZmu9PGJGQ2h0E1vvtjZOvIACtjIE/zXHYjwHU8FbxiMsXJ+TQX0bE2QoUhUa/vFANQ6NCNK3uFPGD9xQf9Ir7QiACKowIPWywa7QdYPVeOxrxkHUXbuM1ByKveBTgEFS9wTKdtqp3Jav5of3DjUmkFmnxkX25Xrq8L0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=KsQM89OY; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KsQM89OY"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AD1grOG031441;
	Thu, 13 Nov 2025 02:47:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=d/EyH9HtGO4bDIUEDXbWspVbjMX5fyl8rLRVJo82uv8=; b=
	KsQM89OYUQl1L2+RQLtKa8T0joTBcb1l2j7/9qIVQ5rClKmv/eBXImej1oYp9SiZ
	2lv7PVrajJ4j0dx2eVrJMDIGC44QNS+fgjmQIMFN4dkkjeFcyNd4L/DUz+xNPaVS
	i9YAJfqZctjV65LMsQtm2rc+VHvpLwCFPZLBoN4/Rr2R5A3x81hsMHcDI4MOtf91
	ODdvfG+Qqd8IgCq1661RmTanlI7zD7EHyJcYSWeWhv+gVGhW+zxtE9nQ+ej7D1Ws
	CeYUJjNYtOxp51EinnGLOAb5oG0sRihtPGpyfkEjly3FxchMrY8iAYfSf1MOIeOd
	LDVfRpw1gkExAy27+NT+sQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4acyra8qd2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Nov 2025 02:47:15 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AD0jNem032464;
	Thu, 13 Nov 2025 02:47:14 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a9van9qct-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Nov 2025 02:47:14 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5AD2lB8P038323;
	Thu, 13 Nov 2025 02:47:14 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4a9van9qab-7;
	Thu, 13 Nov 2025 02:47:14 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Thomas Richard (TI.com)" <thomas.richard@bootlin.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Udit Kumar <u-kumar1@ti.com>, Prasanth Mantena <p-mantena@ti.com>,
        Abhash Kumar <a-kumar2@ti.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: ti-j721e: Add suspend-resume support
Date: Wed, 12 Nov 2025 21:46:56 -0500
Message-ID: <176298170730.2933492.8039610617716621792.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251106-scsi-ufs-ti-j721e-suspend-resume-support-v1-1-6f395f51219e@bootlin.com>
References: <20251106-scsi-ufs-ti-j721e-suspend-resume-support-v1-1-6f395f51219e@bootlin.com>
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
 definitions=2025-11-12_06,2025-11-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 mlxscore=0
 phishscore=0 mlxlogscore=623 spamscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511130017
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEyMDE1MSBTYWx0ZWRfX82cZyTXQreNi
 WKQR4qg82O0h5ZG2791KZ6yGePxYNm2HUiS3HZT/sgbjHMrYRCQWeR/ghNbeOfqwx7aNJX4b2vx
 zzQaoO0gsT8Lrfhj4x1FkzfusvHoHhUrJ7J1afuHf4SJa9NhZa/Dmh5UQqDj86/sVMGJgfbmBku
 J0puSWuXOstiOeTFesGkc3Q862LS54svCntnwD8kuILJpB6JHazv2Kpp+fpwZ4vPguP1rcV+ZHu
 eA7eZI//OOxaFGAKIwC6ToUAazOFW+JNw6mHaktxS/jXM6r4Pgv0tDsrj/binHaCrYJzYpm4MkT
 niyTcEUioAyu09J6sjysa2+OOFGNtNFN9aR1/cYMwXEdMkUVLJFHv01kVxfoLjGnBv+SABW/cNJ
 PwywQ4AYmreVHn0BVdIFMpi37JHlseJBszmntQYEEv7myqeXBqM=
X-Proofpoint-GUID: LJ897odEBxO3IynBlpa9F2eMNh45Bfi2
X-Authority-Analysis: v=2.4 cv=ILgPywvG c=1 sm=1 tr=0 ts=691546b3 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=sozttTNsAAAA:8 a=xs16cRyXXLn8cRT4bnAA:9 a=QEXdDO2ut3YA:10
 cc=ntf awl=host:12100
X-Proofpoint-ORIG-GUID: LJ897odEBxO3IynBlpa9F2eMNh45Bfi2

On Thu, 06 Nov 2025 15:21:54 +0100, Thomas Richard (TI.com) wrote:

> Restore the ctrl register to resume the TI UFS wrapper.
> 
> 

Applied to 6.19/scsi-queue, thanks!

[1/1] scsi: ufs: ti-j721e: Add suspend-resume support
      https://git.kernel.org/mkp/scsi/c/02880c083c13

-- 
Martin K. Petersen
