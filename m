Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59B57198E81
	for <linux-scsi@vger.kernel.org>; Thu, 31 Jul 2025 04:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753937079; cv=none; b=qvRlU07Jk5Z8dELjl8a4fMl0f/IAPUcEDr3ZjDV8RlRMrStkt7FPZoBYfRwyqmqZkm8tP9AeirhPu+4518ZVzWN+kiW+wXWa98Yb1FIEGi0A3eKyPbn40pEmUJnVT/ZdtTQbftLrj9XJjmXq07d0Hzuxw7OlawkCq3JE8Q5HmcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753937079; c=relaxed/simple;
	bh=Q8yujG33uJUgVtjlp8u9jjWA/p6IcGvGve7/mR/yPmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JMncPfxVfc2k8dDT/uVt5Otc3fDqoK2eqRyhXN2WthTTJ39KLBRcVx3SugP7NZN/JiTCxKvqZYKiywjIR7LZJgxGd7EBaHKWDhws9W6DIjW6lWU4PhJxov8iIeCCi3IUD3M7WGUUckVej4r3BUyUcWUvi3NyXxaloEP0BCBGXFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=PR9EE2nl; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PR9EE2nl"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56V2fwma031487;
	Thu, 31 Jul 2025 04:44:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=gqctjd2l6Q9PbZBbeCLicrQ5oNyknplccmiPK/xTqJw=; b=
	PR9EE2nlrGO20Q4BbJcdSo3fGdo+RtTnivJbJ8qWfN1ZwC6CI+QGwUB83F4nhlo8
	f4mZeR56lLmLtsUijS67gNneGDETEueQeADkQM0gyfi/kQwRpwlwTS8dnZqCb3Dy
	vuYoHICpvt/nUjsJntWaBQKdUPsFQS8SEdEdBj22uyDfKBk+3I4LS5JVJm8xVEQy
	1bwE1HNwFQIYUmd4Vs3q6WpAlmo9YEUe9TOnhRbrmEkYzlB6LXG2L/8Us4h68D+I
	EIt3GwCcRkfcKCfqPQSIJqBzjVoQZtQs1LdwN36qGOOZLO3ADynM/JkriySCwNLp
	ustwg+XPiB8FNhMhZ88tqw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 484q4yk9n2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 31 Jul 2025 04:44:35 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56V1G9Y6016851;
	Thu, 31 Jul 2025 04:44:34 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 484nfjb2tr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 31 Jul 2025 04:44:34 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 56V4iX3v035411;
	Thu, 31 Jul 2025 04:44:34 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 484nfjb2tg-2;
	Thu, 31 Jul 2025 04:44:34 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, John Garry <john.g.garry@oracle.com>,
        Damien Le Moal <dlemoal@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v4 0/5] libsas cleanups
Date: Thu, 31 Jul 2025 00:44:20 -0400
Message-ID: <175375581149.455613.4788347274951217568.b4-ty@oracle.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250725015818.171252-1-dlemoal@kernel.org>
References: <20250725015818.171252-1-dlemoal@kernel.org>
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
 definitions=2025-07-31_01,2025-07-30_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 phishscore=0 suspectscore=0 mlxlogscore=838 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507310030
X-Proofpoint-GUID: zcgLZFy9tjMSir8gIZQev6nMfyIf0vVf
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzMxMDAzMCBTYWx0ZWRfX2OHDpTFbwkj9
 Lh8tMddAlmNhK6PXSbHXwlf7QoJKUDEOAL9TPaqws6Y113czZHQU7JcwU3YTxpqZnbg4W9bNU70
 GukBV0XwTxeN9Dg/qT72KbzR9VTGziZx2+HlgzYw0CJNk22Puynz3IhRyBHk8p9k9CPNygpAVXl
 TFNF20PbmFWSBQbPH/gAw3R7KqkBldXrGaynIVEKu6fA7PSVmZSgZmxb20aOzNgGx/anWcwxCt1
 asyArVOMfBWthD4Iqy1uvXzrAHrZmo1rKydj61vQTdcpc7Aq2PS7LCthpvHuzFOle81rTyixazK
 zZ9ULhAs5oPUhL01+L6g61TM/Jg1TQxaXAi9VKuEKiEFyPMhVkigsr9o9l26bfArvzjhhUKfqal
 deKJJO2mzpODygU4INu2BkGJpOizDfRcRt0dcYc6bqWeHpC+D+LwASubIzsXV17PW3R3v9EY
X-Authority-Analysis: v=2.4 cv=ZMjXmW7b c=1 sm=1 tr=0 ts=688af4b3 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=VwQbUJbxAAAA:8 a=Hmj5j2q6NjVHxVe-fuYA:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12070
X-Proofpoint-ORIG-GUID: zcgLZFy9tjMSir8gIZQev6nMfyIf0vVf

On Fri, 25 Jul 2025 10:58:13 +0900, Damien Le Moal wrote:

> Martin, John,
> 
> While debugging an issue with the pm8001 driver, I generated these
> cleanup patches. No functional changes overall.
> 
> These patches are against the 6.17/scsi-staging branch of the scsi tree.
> 
> [...]

Applied to 6.17/scsi-queue, thanks!

[1/5] scsi: libsas: Refactor dev_is_sata()
      https://git.kernel.org/mkp/scsi/c/54091eee08ac
[2/5] scsi: libsas: Simplify sas_ata_wait_eh()
      https://git.kernel.org/mkp/scsi/c/0dd03570512a
[3/5] scsi: libsas: Make sas_get_ata_info() static
      https://git.kernel.org/mkp/scsi/c/bd31394aabf3
[4/5] scsi: libsas: Move declarations of internal functions to sas_internal.h
      https://git.kernel.org/mkp/scsi/c/704ed03abf6b
[5/5] scsi: libsas: Use a bool for sas_deform_port() second argument
      https://git.kernel.org/mkp/scsi/c/75fe230b9bed

-- 
Martin K. Petersen	Oracle Linux Engineering
