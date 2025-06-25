Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 916EF2D023;
	Wed, 25 Jun 2025 01:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750816080; cv=none; b=BsrHrwT4aZzcvLuRYc9DDv5EzRSe97s+tfqr1xN6uHK1+pdNaOETof8Yg4Lybk/aFK0qpcsVqkOTdWyAPf/B/vmVwJnQagxVWpMMGcNTsX2AknNYGdGkDHzWCM+w4nv/9GGWgYja8Qj/trjDe0APiduQ556T8y7fiDrTCYBePpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750816080; c=relaxed/simple;
	bh=FoMdZK89CDofsALYCxxw6GHAC9z7eOQKb1LUaRq7vPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o1CHj+x2zcvQpbC6/qSDsr12oNbZAc7VAG6d8xVK5GNiHio2zIgagJQcejB4ZZs6YpGhGFzc76aatZDs+1NqBd7IG32xFiDfIRY+BvX8gHq3mnR7nZF0ZeFP4lmQjdV3yQl52ZAVI5tQ3kssH2ErqBY5jcPky4aMVytr6Gl7omI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=AMsbPspK; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AMsbPspK"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55OMieW1029821;
	Wed, 25 Jun 2025 01:47:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=x/fylcGv3cuv13lUCrRHZnJOOYgvYQvP0yWO4FnS2j0=; b=
	AMsbPspKmLWHK4y3JJrSh6oIK9YX6bdIsuu/AZ/uZ3JKM1UHkrClYUFXESgiKrYo
	IfmsIv+UbIzuyXNt1f3kC82pVpgIcsldpkYBL7blBv/9cFZuUbPojt4xjE9VwvsL
	tUqFvPLFrwpRB3/YejyhpGRzLKd7twKzp8dRID069LxX4kcJpg9syf/cRJCCMWFs
	pxF6/03WFw4nS62NWFtXrdFkfbNcLr4JCAnUvQq6gKjaD6CFwlJxJVcVb9+LJdsD
	klWaneaqFlGcWsI/O1V3S8eYD5BUCe6E5H3/r6RtYaL5L3dxNCT3wltog7KL3YyL
	v0q3Ax8mfQ/ufuB4693ylw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47ds8y6d3v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Jun 2025 01:47:55 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55P1WKd2024347;
	Wed, 25 Jun 2025 01:47:54 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 47ehkre6kb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Jun 2025 01:47:54 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 55P1lr8Z038193;
	Wed, 25 Jun 2025 01:47:53 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 47ehkre6k4-1;
	Wed, 25 Jun 2025 01:47:53 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Thomas Fourier <fourier.thomas@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Joe Carnuccio <joe.carnuccio@qlogic.com>,
        Himanshu Madhani <hmadhani@marvell.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: qla2xxx: Fix dma mapping test in `qla24xx_get_port_database()`
Date: Tue, 24 Jun 2025 21:47:31 -0400
Message-ID: <175081602589.2445192.16311407209189613959.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250617161115.39888-2-fourier.thomas@gmail.com>
References: <20250617161115.39888-2-fourier.thomas@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-06-24_06,2025-06-23_07,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 adultscore=0 malwarescore=0 mlxscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2506250012
X-Proofpoint-ORIG-GUID: mmuoRPUdYynaU9egHQvcro4cuG8bqT3J
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjI1MDAxMyBTYWx0ZWRfXxQDufyiVK/xV XiMJFrNSiWO0JC4MqEc9ceLc8N94OMWEZ6JnYdxikDK2yy5psoiVbG9LIE8L/dTXIPgRzlOLW+d ogS43cU6+wf2m5TjUEKhtI2q9OtQbr735YikG5s4j8ZDeGOlCT1coW3ZR9p+nJpIV7l97cBMr3r
 JEx2JNzxq2liTxkAzilMMkQVbPh4Exo5/KTO3y/7C5m1KQBHvWntGUaOC/UepIgpuZDxw2qVrTf 3s3uQ5GeJTkVhELhFAYImzgXthIBRjXihfjLdFO3fRnp+D7Pmn4MKve13tfXMksj9/OpSPkcyVV TbtUmB2un+QHRkuGSVMZVgIOqF07kWTE1thgG6h1jyiwnLzQSNYUgW994kJQb/Dx6t1mk7ku101
 IGphXzeXoMcQMgervgF+TDWKIngrhmPM6QURNyyaKEMDMGzV+fsRoxi+IZn6yvp/US1mWgDS
X-Proofpoint-GUID: mmuoRPUdYynaU9egHQvcro4cuG8bqT3J
X-Authority-Analysis: v=2.4 cv=PqSTbxM3 c=1 sm=1 tr=0 ts=685b554b b=1 cx=c_pps a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=VwQbUJbxAAAA:8 a=Q_JNAB6JL72KtPgALHsA:9 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:13207

On Tue, 17 Jun 2025 18:11:11 +0200, Thomas Fourier wrote:

> `dma_map_XXX()` functions return as error values DMA_MAPPING_ERROR which
> is often ~0.  The error value should be tested with
> `dma_mapping_error()` like it was done in `qla26xx_dport_diagnostics()`.
> 
> 

Applied to 6.16/scsi-fixes, thanks!

[1/1] scsi: qla2xxx: Fix dma mapping test in `qla24xx_get_port_database()`
      https://git.kernel.org/mkp/scsi/c/c3b214719a87

-- 
Martin K. Petersen	Oracle Linux Engineering
