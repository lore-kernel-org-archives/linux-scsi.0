Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 087804A23
	for <linux-scsi@vger.kernel.org>; Sat, 29 Nov 2025 03:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764387021; cv=none; b=IQC5qalX6RtRgLv21iqSK9b669gR+2kKvyFHsYC8ylHqwERe7Jptk4RefIP7m5Eh7CVpw904mmcgnwT+QvQeIQ/EoY5Vavzp+bsPjTmCBzJCX+074leLb4HmjbhlV7nX/ZbvAawOQH7eZtAWo+gA8/22cWdploDz3eC7+ItaQ6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764387021; c=relaxed/simple;
	bh=of/kB53Qvj+kvf2R83WkYVlKGDA6bZCKBuBIv4pmqSU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R+nqdcylWqsKBFGfpdB5Ia3oGhZrcz0kFNj1FOnqU7BCcAA8P5rpHzlNPi5pYbVBO2GNLtxwNYQL1HO/MOoEx+ofTLWV0MwEwMwJifh3ip1ygtgwy5aFaLhZISy//N6Cm+H4LZqqM/HX4csPJowtWJY88zxxDB3Ucj9gshBMOlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=dE6JsDOY; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dE6JsDOY"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AT27nFi630472;
	Sat, 29 Nov 2025 03:30:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=C3eo4n+tlRKM5eQDOH10nKP9tYhe9+82ICp5nyGZP80=; b=
	dE6JsDOYcWXHWru1bagC2gemrBd3pEWX39A8PjyWiBo27zuImERF/YSJD25eMdWT
	DlW1eKjEmQwGpk/0qh/cKf+Y9oc+lK58gtlXXdTKcJ2fkNlDq6qhd6bwu7WwRckE
	H0PJRNeW9CAlUN4c6laA6UcR2dcaNuTZ/hQpeYmOnGJLQsyGtZa861wppFMQBKzU
	xj+12ma0TJ1iW+8mhp940izcsExKu9ALt9bpi8LqfTTouVCeAu/BGmhcy2MJe3Fo
	5YI1jUyKdrMJoZObQoAdxudCc1JrGklbTWRUjSB2DWNlnGcJZRZJLomT/UIcXpQ4
	CK4VukRtjsmhra+1EWcbvg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aqqrb81cd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 29 Nov 2025 03:30:15 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AT1Xk2V032130;
	Sat, 29 Nov 2025 03:30:14 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4aqq961n8g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 29 Nov 2025 03:30:14 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5AT3UEpD015090;
	Sat, 29 Nov 2025 03:30:14 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4aqq961n85-1;
	Sat, 29 Nov 2025 03:30:14 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: Add the UFS include directory
Date: Fri, 28 Nov 2025 22:30:00 -0500
Message-ID: <176438479595.3682470.6579435366401426828.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251119165742.536170-1-bvanassche@acm.org>
References: <20251119165742.536170-1-bvanassche@acm.org>
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
 definitions=2025-11-28_08,2025-11-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 spamscore=0
 bulkscore=0 suspectscore=0 mlxscore=0 phishscore=0 mlxlogscore=683
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511290024
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI5MDAyNCBTYWx0ZWRfX4iEr2UObMFxI
 XJZFrGgJ9odNg9TR0OlNywLdtDJjMCx99vRUsfF3maQPYM1vPEQBT46eyZOlYFv5ClOIGoB+MVc
 cZ6vdc7CQj4MNIrMJS+kIXOVLnBi5T2/2Wc7wOb2iwY173sey0xeprWJfaRVXKdd4KsTx2bFBdo
 Mn5DYaWHC62XpfOjEkPXdD0PahWbGk3/kkGI/YMiL7RLuGYATPligLoRLJEssBJVgvHqzI11qUr
 eaJca/slP9ZdE1Som4Gh7koum4knGUbsgx3TbtbZk/wpr3JMFJv4UwHuz4ZAUS3polWLT5gPZ4R
 9rV2eSsJJx8837GyM65hBwN3LVV1I7rGj/aRsPRgrQ/mMMlwgfZxCej4qhNBa9fxHfyzPAjmvug
 loqkv+MYtPK3XHaKCUylvarMLIEiZQ==
X-Authority-Analysis: v=2.4 cv=O5M0fR9W c=1 sm=1 tr=0 ts=692a68c7 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=Qrfao6EbUTu_bUgEJXsA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: nfoEmpsK7hHjZiadibXffzKTKW2OJkb8
X-Proofpoint-GUID: nfoEmpsK7hHjZiadibXffzKTKW2OJkb8

On Wed, 19 Nov 2025 08:57:32 -0800, Bart Van Assche wrote:

> Make sure that the linux-scsi mailing list is Cc-ed for changes to UFS
> include headers.
> 
> 

Applied to 6.19/scsi-queue, thanks!

[1/1] MAINTAINERS: Add the UFS include directory
      https://git.kernel.org/mkp/scsi/c/38725491e766

-- 
Martin K. Petersen
