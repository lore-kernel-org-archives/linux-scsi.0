Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D4FA634;
	Wed,  6 Aug 2025 02:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754448005; cv=none; b=OuX3kmnhz35h/FvTrJxkMcQCQbLIDFMCwnTkf5dHcC5tLoKuGBmGQmGPLJ82gUv45W5xGM5Ub2BGCKXBKmO63ngpoHvHju/POabR/TED6t7i0RmxG/NJIRU6f3LL6qN1WfFfH2E0w6lVMRCIaeoglSsVUAceqpjNt+ofPZfaqRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754448005; c=relaxed/simple;
	bh=TScl6WT5fMvhhtj80KIs92ZxyqjNc1Ln8O0B3W5aa3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V95p4qJ3TAjKh02XKj4goU2Rp0u0hLx1pkajw5IJEn3U35czE5ufNO9GMRnU9pdKUMGX08R0kgvpNFsfreMXafCTsCwJ3Mm/9sRC2JKmh+Q9BzSkSk1pQ/yODRPhYZ9NvBNUuu1uYCULC0Q3hhJQ4TM5HBxV5qRqssnE4bgipKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=N++u2mrk; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="N++u2mrk"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5761u1Cs018467;
	Wed, 6 Aug 2025 02:40:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=DVITaBZdDzAcSs4UgMdNi67PLUGqO1WHv6glpYsKHyE=; b=
	N++u2mrkCfVbo1j9qOe8BoLLdOZpZZgXPx7oRu8qwQoE6gZsBGIpOVcT7zNkTend
	0LCg62gKqY/ybQoOMeP1np3NFCyuj9fiIVW4GLaOXMk4Tby8j9CMLVJLhMi8LGAO
	T21X+0hskpUQNMIsC4uE60IQqUsEOg841OoHjEGI+9kcTYWr3PVyTzZ8NkF6d58Z
	clnnMcvuHkkORTiWC4DCaQAcvEaIQYEFQ+Lsi9pBdsP1MDlA0rRPEZ5XQQwTK863
	b40iuqWlwtXcX6pV8wCJcvqufg7ZaqoScyw9h7bCp6bwQzs/1sel1jf70TqzSmt2
	gc3W8RKmDaRYSzaIKpN7zA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48bpve0mfs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 06 Aug 2025 02:40:01 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 575NU8uH032102;
	Wed, 6 Aug 2025 02:40:01 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48bpwpx5xm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 06 Aug 2025 02:40:01 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5762e0Pv004349;
	Wed, 6 Aug 2025 02:40:00 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48bpwpx5w1-1;
	Wed, 06 Aug 2025 02:40:00 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org, Colin Ian King <colin.i.king@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] scsi: scsi_debug: make read-only arrays static const
Date: Tue,  5 Aug 2025 22:39:48 -0400
Message-ID: <175444522420.711269.16118078546275539899.b4-ty@oracle.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250729064930.1659007-1-colin.i.king@gmail.com>
References: <20250729064930.1659007-1-colin.i.king@gmail.com>
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
 definitions=2025-08-05_05,2025-08-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 mlxscore=0 malwarescore=0 bulkscore=0 mlxlogscore=949
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508060017
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA2MDAxNyBTYWx0ZWRfXxTU3YOLLh5Vv
 ABDxuhuIbGOv0+RKt/djZA2jC3Q1VjcUEMdUIwssMlSBM7hPiMhqIJYJRciVks+A0plqRTsM4VU
 oDqWabOu0UcmsiT1MsfnvyVLOhit8uFHpZ4LenXSssH6O/XyrLQ1Tp/aWyhG6NR6XxC3bNPIokq
 CPle+MTDXiz19QuVgkrXbVcvoSB5s1T/lGLMHE1J/2WrWbwrW2bEeLwCwkrKimGQAx/YbaDYqyB
 qQj4AuI+tzCsOBHsXKpVJo0L397ml+b8k6Yx0PmU8mdo010sFFYxxkt8xgXbvS9Jh2fnsIrog3r
 FoU3D5XwM3OUYL+tovg5Tw07+t/dpo0pnzDAe8c//qN91xTL/mluqFKCQf6e/T65bPEXI9kP4Oj
 rPSyDNkQtcgTnTfcKnyVGeHNOJDY38WlpH+NTufll/LwpYWRf1bxJke7475BGHukE8FOCFHm
X-Authority-Analysis: v=2.4 cv=ApPu3P9P c=1 sm=1 tr=0 ts=6892c081 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10 a=VwQbUJbxAAAA:8 a=bI-zSHDjrE_-D2aRJPUA:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13596
X-Proofpoint-ORIG-GUID: a5gKXukGVQ7c2NkExE6ukS1zEGte1TJ1
X-Proofpoint-GUID: a5gKXukGVQ7c2NkExE6ukS1zEGte1TJ1

On Tue, 29 Jul 2025 07:49:30 +0100, Colin Ian King wrote:

> Don't populate the read-only arrays on the stack at run time, instead
> make them static const. Also reduces overall size.
> 
> before:
>    text	   data	    bss	    dec	    hex	filename
>  367439	  89582	   5952	 462973	  7107d	drivers/scsi/scsi_debug.o
> 
> [...]

Applied to 6.17/scsi-queue, thanks!

[1/1] scsi: scsi_debug: make read-only arrays static const
      https://git.kernel.org/mkp/scsi/c/383cd6d879a1

-- 
Martin K. Petersen	Oracle Linux Engineering
