Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 278AB326D44
	for <linux-scsi@vger.kernel.org>; Wed, 11 Mar 2026 02:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773194797; cv=none; b=gjiSgCJUN3qyb0ndAxheqhqmYomRfuVcMyL7X+PUZeHfBianxuQNeqx61dOgfnv//wzEmPUqzNwBpQXiaO05nnx7NV89Z1IsjduOkwIJZYC94tTtaz8biL5xLOeIYiLL5nVOc4qOY92ND+B5ZrTKX8MFYIi0UXtpu+I69Zs21wY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773194797; c=relaxed/simple;
	bh=u4j/KJWVI9hg6aw3+noCoZaAXphOZkCZ830XpHMA+0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NNc/GlyqRTKeFtwiDq4UohQN6SlAOa7hepkbZoBRg5rDxAXsrnhr/DRZThO97hBWSgTcazKY6l2yefliaCONciUqYKMpxyuax/c8DMCq1+SaiDTw7Ny25slK+F+dVw953wNy/BdgaMSTXPiQylE6UEXkutKPgzApJ2XvPf2GjV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=W+Ee+oe7; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="W+Ee+oe7"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62AJDUgb2773037;
	Wed, 11 Mar 2026 02:06:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=zRC/6xyncbUgHkSBn8kjqvlQZ/wa/hbZsxrHVcoP5kg=; b=
	W+Ee+oe7TT1zNgOI0qbxhwF+uXMV+k0q2CZNIkMJJjN0yTiNnkKqBXjcEHp5tgx0
	hKf5qGKgsLDAZUf+26qx9dNvYumB61fDh805melEbrATZsGwudJ3xW/y6g6dkq3z
	r0WCFMbZXCNZTyuJByJG40hIGQ0jSmcPuQ6f8+4FLixD7VUk5a8luDfViXHZ9/se
	ICD1ianptdHySJTJghE+WX0XZCIy6xF4qQX1eiiQmEqcfqegFHp2HABAz+S4J6y7
	LXNvahjnkvUeyxjdzhklVFwb6QKNVvuY0HyJQWLVWbPtFIGXdpZ55qLkWXU4akaW
	lUdsBf86E27MwsrYbD6oHQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4csjnum3v6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Mar 2026 02:06:25 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62B07sP3020331;
	Wed, 11 Mar 2026 02:06:24 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4crafewwkh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Mar 2026 02:06:24 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 62B26M5P002770;
	Wed, 11 Mar 2026 02:06:24 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4crafewwj6-5;
	Wed, 11 Mar 2026 02:06:24 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Justin Tee <justin.tee@broadcom.com>, Paul Ely <paul.ely@broadcom.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: lpfc: eliminate kernel-doc warnings in lpfc.h
Date: Tue, 10 Mar 2026 22:06:16 -0400
Message-ID: <177289787689.2131580.17746882537078983809.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260224234954.3606638-1-rdunlap@infradead.org>
References: <20260224234954.3606638-1-rdunlap@infradead.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_05,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=750 adultscore=0 phishscore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603110016
X-Proofpoint-GUID: yec5cvINBEXQ2sJIxW3HmcF9urB8heVv
X-Authority-Analysis: v=2.4 cv=c7WmgB9l c=1 sm=1 tr=0 ts=69b0ce21 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=VwQbUJbxAAAA:8
 a=7scuzT8Q6j0CDX229_UA:9 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10 cc=ntf
 awl=host:12272
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzExMDAxNiBTYWx0ZWRfX5+Tv0HDVCj1n
 AqtXiqQvrvzKVCXfflSbyYS0HW+cP8nRyo4wxLNFF++jhcWP0oMs1NwKn4TO0NHP0nbBgF1E0J1
 oVUX+eQRsD8lSvVoTavTp/O7PzO6V0YPyMSGr+KAdFRSYjmzR7KGy7zYrxt254jq8pPilyI01uJ
 LnYYm24wFe5U8dqe0wWEZPgKzXpqiITW8cL2Vmfh7K3NQchWl1JlhpPXxa6Je+MbiBo2o+OphS0
 +0kY04n8IuzlBnEjjM+EX7/I8V2ri23H3N/E/1VJgeAdu14NoOWZ5wlWltnhYoGOq9eaSTl3/cr
 WiAgEpWfJ7LVvWskjtZZvSkeEc+aIFVXLWjS2OIO+qofwHDCtx00Zt2SbG2Ev0zl5UZxlh0nsAP
 JPNYAZcuyet1cLm5W7yh8g2AcIGwiAfojI2ph95bgcvEBmvmJoJD9Sxi5vLnyGR0aHLysmUQ4iG
 tub5UDEUdQtRh/rv1PBiDUaw0vJy7utYhUKNaSCw=
X-Proofpoint-ORIG-GUID: yec5cvINBEXQ2sJIxW3HmcF9urB8heVv

On Tue, 24 Feb 2026 15:49:54 -0800, Randy Dunlap wrote:

> Avoid all kernel-doc warnings in lpfc.h:
> - use the correct function parameter name
> - add a '*' to a kernel-doc line
> - repair the function Returns: comments
> 
> Fixes these warnings:
> 
> [...]

Applied to 7.1/scsi-queue, thanks!

[1/1] scsi: lpfc: eliminate kernel-doc warnings in lpfc.h
      https://git.kernel.org/mkp/scsi/c/5e0d4fdb98f3

-- 
Martin K. Petersen
