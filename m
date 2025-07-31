Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EDD4198E81
	for <linux-scsi@vger.kernel.org>; Thu, 31 Jul 2025 04:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753937091; cv=none; b=s7bkNfq/hlE/v/agHMXrq9WV8/G0eiJXvF2JGEnte8smA7czhRwAtLRi6UjPU8/MoTo8m4mK4qn2DhaSRkDzhlj/LrI5vF+m/XF2whli5eUJAts7dkhR6M0Irl3tH3HZZ4hA4NkVd+nZUVlzqE4sNTI9Bg/J3irlWSLcbWMX+tI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753937091; c=relaxed/simple;
	bh=bJJ43t5azEGyf8n/hFL7jyFulyRwBP74cezHhYiSsSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oDGvzPrFbfYTy+1d6hyhHBuRKZtuhkMD3IzTwbeXCbaP09o4mUA0g/s8gX/Uoj4EhMKt83OcWxjmLsJCuKrgdhTU6oGZSbB7l1OSFarVpmV3DHsZA+gWCfRHzuCsrVgjTce8erR4TjvOhFQ633rTd/ktWmV52+7B4m7myg1S7So=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=NNqs/Xf8; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NNqs/Xf8"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56V2gN3Y031797;
	Thu, 31 Jul 2025 04:44:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=xJ8iu3jZoiRrtYFwj61oSYpGXm8vhe4hBIcesrlQsFI=; b=
	NNqs/Xf8Jell3KNpCRRlUw4zf2VQcyz/4tgqCHUHjRY7ynvfBlyveXxvYbcKWgBI
	M5AUxWl/yZaxQhIUG3FWr3WiWS1BbsEEUoQZnE5lzNg+h6tQ8a5kaXL2DE8AgecC
	7Zk19BCqbJr64PsocaJYmQDeQupbmrYvZh0oymUBOkr2VITWHqqcl2Rv44oDc3gj
	wFjELXQ4rv4x73Yc2PWdikb3Cfa3hHY5w5BK3i4CthQCgtA9TFV6J24jBWV2qdbj
	RRbHun1JJQB1NoX26gxQaoNTxbuCAxAs3wOd6Uw8EXkkFGURYWyngCJJcp5mfryr
	vQ8+gtBOjH6c+6wzTAZm8g==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 484q4yk9n5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 31 Jul 2025 04:44:38 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56V4eJOg016759;
	Thu, 31 Jul 2025 04:44:37 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 484nfjb2uv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 31 Jul 2025 04:44:37 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 56V4iX49035411;
	Thu, 31 Jul 2025 04:44:36 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 484nfjb2tg-8;
	Thu, 31 Jul 2025 04:44:36 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, peter.wang@mediatek.com
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
        chun-hung.wu@mediatek.com, alice.chao@mediatek.com,
        cc.chou@mediatek.com, chaotian.jing@mediatek.com,
        jiajie.hao@mediatek.com, yi-fan.peng@mediatek.com,
        qilin.tan@mediatek.com, lin.gui@mediatek.com, tun-yu.yu@mediatek.com,
        eddie.huang@mediatek.com, naomi.chu@mediatek.com, ed.tsai@mediatek.com,
        bvanassche@acm.org
Subject: Re: [PATCH v4 0/9] ufs: host: mediatek: Provide features and fixes in MediaTek platforms
Date: Thu, 31 Jul 2025 00:44:26 -0400
Message-ID: <175375581133.455613.799244421685167637.b4-ty@oracle.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722030841.1998783-1-peter.wang@mediatek.com>
References: <20250722030841.1998783-1-peter.wang@mediatek.com>
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
 phishscore=0 suspectscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507310030
X-Proofpoint-GUID: 6FEtWkgKqFa5YhMAPJA5i4fVrs5NV5eG
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzMxMDAzMCBTYWx0ZWRfX30e6SzO6ITaZ
 QuXAP1UZ+llrR0aD37/KMlwVBUMIr+1HkPDKrx2ou3qqtHREC0SDeaqfXgD6rZ9o0DPmhUM+CFt
 4P3Au1Sn7H/uHTFarorzuIsgymSwwFqNAFsFK0g047PYMwBDC4Qcp1IvAT0i5d1Wtt8UM/4IVmk
 O066788j2OtQ8v1WGhBAMQbE6r6RU0RUa/2DHeo+eRLZjCJnTOzKDDn2WQZHakdGwnFvut07FGi
 C3YXhcT6b82PFBffUKu5oZGzGyQnr1F7Mui0xKyvawlgV1hJklJOJlM2Y/mWTgghb1fjgx/ma/b
 4v1ZY/0p4I2NKL4hmxQ9qGfXgurtd0Pu0wbD7WYO0whm6KUKG/ISUATzK1OFpNQnPPEvdFxEye9
 Da6Epr+11fD6CyCdDz+nhr+7gE9EBSiwlGfd89QXGEyfYvyrC6O851m12apJ8jNGnno63fSj
X-Authority-Analysis: v=2.4 cv=ZMjXmW7b c=1 sm=1 tr=0 ts=688af4b6 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=VwQbUJbxAAAA:8 a=mpaa-ttXAAAA:8
 a=M1Cv4AyAfq6yeDsx1bgA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12070
X-Proofpoint-ORIG-GUID: 6FEtWkgKqFa5YhMAPJA5i4fVrs5NV5eG

On Tue, 22 Jul 2025 11:07:15 +0800, peter.wang@mediatek.com wrote:

> This series fixes some defects and provide features in MediaTek UFS drivers.
> 
> Changes since v3:
> 1. Fix comment message in patch:
>   ufs: host: mediatek: Simplify boolean conversion
> 
> Peter Wang (7):
>   ufs: host: mediatek: Simplify boolean conversion
>   ufs: host: mediatek: Change ref-clk timeout policy
>   ufs: host: mediatek: Handle broken RTC based on DTS setting
>   ufs: host: mediatek: Set IRQ affinity policy for MCQ mode
>   ufs: host: mediatek: Add clock scaling query function
>   ufs: host: mediatek: Support clock scaling with Vcore binding
>   ufs: host: mediatek: Support FDE (AES) clock scaling
> 
> [...]

Applied to 6.17/scsi-queue, thanks!

[1/9] ufs: host: mediatek: Simplify boolean conversion
      https://git.kernel.org/mkp/scsi/c/262893939604
[2/9] ufs: host: mediatek: Add DDR_EN setting
      https://git.kernel.org/mkp/scsi/c/a84a9ba7888f
[3/9] ufs: host: mediatek: Change ref-clk timeout policy
      https://git.kernel.org/mkp/scsi/c/16b30c7a4c56
[4/9] ufs: host: mediatek: Handle broken RTC based on DTS setting
      https://git.kernel.org/mkp/scsi/c/a44ff97f895b
[5/9] ufs: host: mediatek: Set IRQ affinity policy for MCQ mode
      https://git.kernel.org/mkp/scsi/c/66e26a4b8a77
[6/9] ufs: host: mediatek: Add more UFSCHI hardware versions
      https://git.kernel.org/mkp/scsi/c/7996746394df
[7/9] ufs: host: mediatek: Add clock scaling query function
      https://git.kernel.org/mkp/scsi/c/ff40f31216ff
[8/9] ufs: host: mediatek: Support clock scaling with Vcore binding
      https://git.kernel.org/mkp/scsi/c/31a20e9f7c76
[9/9] ufs: host: mediatek: Support FDE (AES) clock scaling
      https://git.kernel.org/mkp/scsi/c/5e5976f5242d

-- 
Martin K. Petersen	Oracle Linux Engineering
