Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C2A3364957
	for <linux-scsi@vger.kernel.org>; Thu,  9 Apr 2026 02:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775702617; cv=none; b=UQv+GSr5Isp6pXUqbusg5Vujnu41Epkf85hzrQksuJrYN8ImV/pJtem5EkYDDrxf//tXiA+gTUXRlOgCKZA4YFjp6DVtBbLFKx+EeZqA7I61ZBRoQBnIejR5CXL1rwUHZP7iMHPyA7akhJgtKRFNrah/AIwIxfeyNXfuEcCwrFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775702617; c=relaxed/simple;
	bh=SNGYl3FkJubVLFn/zsoZXEVLxG80UM7vNmhUZy2It4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s6vxslioAHKFvVqgDDxkmSNSpxvZVq4mBGlN2djSDGEAoF28Vd9zqFAjKDh8xW2ydVj03kFmUldZLy1GVAepnfeXgzReXLfxbvROSEoutlnUzt9i+mHcwG6VC5LsAsVu+CVn0ylkIZNHyLLLxlIaIw33ifGk7VdJyDtSmOke+DM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=LKWHTLGl; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LKWHTLGl"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 638NtX62051802;
	Thu, 9 Apr 2026 02:43:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=6uSey2O/Uv7dyNh3uShPvbqGKBYp7v8iFJ+lRh5fblg=; b=
	LKWHTLGl1DZD9uecCFeCeIh5saq07NpjKJp9P1WzFEvNUSZzGkGCKu97e4fidwdG
	4p9isHzEnYca87pbobetnHR2q3kFS4X9AnPuaEjaNK+5eEdD1EDcDplUMoxroKbU
	2k0EbRdcaiDokT9EtD8jtbo1/i+v81lTTPVTS3MvtDnHxT3E15wsV8J7sb8g7eSr
	5Im1+62l8uzBnmtZlsve2mkUtSkQXd/FZH0Fb7GYOpblGJsYSynj4uXVIyrr04FJ
	TRTxTcY9y66wWJAK7E/X6DrJ4Gni5RE2D4SKWTPLPipUt3pReoe7z7Uh0EUIAQe/
	pie21oHmDeyQBEtTN4qkYQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dcmqamx8x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 Apr 2026 02:43:31 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6392JwjI003594;
	Thu, 9 Apr 2026 02:43:30 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4dcn5xhrb8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 Apr 2026 02:43:30 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 6392hSUp031599;
	Thu, 9 Apr 2026 02:43:29 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4dcn5xhr6t-2;
	Thu, 09 Apr 2026 02:43:29 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: aic7xxx: Fix compiler warnings triggered by user space code
Date: Wed,  8 Apr 2026 22:42:58 -0400
Message-ID: <177569866591.3870441.13127875731387506565.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260402153341.2909184-1-bvanassche@acm.org>
References: <20260402153341.2909184-1-bvanassche@acm.org>
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
 definitions=2026-04-08_07,2026-04-08_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 bulkscore=0
 mlxlogscore=996 phishscore=0 adultscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2604010000
 definitions=main-2604090023
X-Proofpoint-ORIG-GUID: i5xahVgEQvFyyEyvSw95nLjM0U6q4nVR
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA5MDAyMyBTYWx0ZWRfX+yZfPF9n5Q1Y
 xGzZNHpfsOFU6axAD7ehcPIrV3zGWMwuLOgmUG6Q0MnUjlAej0aMkQaP+G8us0ujnUAAyKagD0V
 sK7Tp3LOw6qmXl4GPldgXq8H4HHrIh1grHHs6YYq4pDOzinhm2cNs8a7iBV9AeJQ1eMDNq0bggd
 4OaumvBV1/nNK3Xz7H3XJVW60SP2fcAkAYT8XsyCYoT8grWukN1EhIZTxGZh3FQuenBizwpDACg
 U7NZi1SYhF9P9nQIBTp75o/R1gjCbSvL9jLxEUDhmASgSO9SohHbzbq1lEtPSPiBqEmXyNBGYhH
 BrjbS1RCGOAFBNXpzdRfGVFLI6uCUcNfIOsLmmcgmUaMnKJVzBZ1mXoCvUDo7k7x0OzC/g6US8A
 iq0DLBcjvkGI2x6s/R5uicD2KqpndO9APnA2zLJiqfkJF2YQWuVyb/mNYp7O1vb3cbNql5SKGyp
 qvhmDe0u4GaqTXkVfFWYYOLxkvxsYij1bMAmcm70=
X-Authority-Analysis: v=2.4 cv=AsTeGu9P c=1 sm=1 tr=0 ts=69d71253 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=VwQbUJbxAAAA:8
 a=64w2iFItjkudNtCUkW0A:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12291
X-Proofpoint-GUID: i5xahVgEQvFyyEyvSw95nLjM0U6q4nVR

On Thu, 02 Apr 2026 08:33:33 -0700, Bart Van Assche wrote:

> Fix the following compiler warnings:
> 
> aicasm_gram.y:1107:24: warning: comparison of different enumeration types
>       ('scope_type' and 'enum yytokentype') [-Wenum-compare]
>  1107 |                  || last_scope->type == T_ELSE) {
>       |                     ~~~~~~~~~~~~~~~~ ^  ~~~~~~
> aicasm_scan.l:392:14: warning: using the result of an assignment as a condition
>       without parentheses [-Wparentheses]
>   392 |                                 while (c = *yptr++) {
>       |                                        ~~^~~~~~~~~
> aicasm_macro_scan.l:153:1: warning: non-void function does not return a value
>       [-Wreturn-type]
>   153 | }
>       | ^
> 
> [...]

Applied to 7.1/scsi-queue, thanks!

[1/1] scsi: aic7xxx: Fix compiler warnings triggered by user space code
      https://git.kernel.org/mkp/scsi/c/1821f77fdaec

-- 
Martin K. Petersen
