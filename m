Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58883182D9
	for <linux-scsi@vger.kernel.org>; Tue, 25 Feb 2025 00:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740443628; cv=none; b=REkVqRyOrcpQGpIMVvqT0orPtY687P0AdTl9widz+MYvygTUIQPfJZV5TLZZ/7agt95vHJqNtgH/c7i6eLbLAY3JZgRbSilHms2D3GmfjdKWa73ZGTkUh3wTlB1pppduY1JpSg6lElYt6geOsYZhemq+jBo8pHrLXF99Yt3FSEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740443628; c=relaxed/simple;
	bh=m7RQ1IR9qhtySQSx6DhfGO7hD9YB/WXPy6X9noFb09U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cbUPXgbbCHMs3XsqB7tl+qWTwBZJ/lN/FQD/xk9tW4J9y032uVNviyscSauXd5QbZ78jWdVj+KF6LVHtWmYDyyIFEVeX+wNopZg0WejdYO9zOLd+Zf44Nz9uOlvEpkzOjB4dVYtdeavEGSIYiwdrNSTh8up4RVFOclAz6Hsmn9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=i0CMgggU; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="i0CMgggU"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51OMK0JS012484;
	Tue, 25 Feb 2025 00:33:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=Mzxasuy+e4bRJryQPZfFxX9fVGPe0gdt9N4OvhNBSuM=; b=
	i0CMgggUaeLt0x8x4WYW4OBZ/ciLe7YMSRYs6qY9kOmv2McZGAhgNJ9jRfQ6myBA
	PlL9MWu0AqyJuw0lAm1H0V9VxuMqlHwwqh3tlqFTslOX81yN/bslysRD0X0Samea
	f3sNvwzM25gOVztmZK2qQxRdpnFizF9noD1ZQdVu0twzaxkM3fK0U9KW517D0nHl
	xiwcpypYJpf3CcXS4yKy/0cRNpUgBg5uHmF7yremga3zPQb8XmkCvU/VWCg6M5oy
	Kom/06zV1foPZLKYQeDmCuh/vk3irJbNHPJl/47QN3YbtN+OIZivWPV7YtUSE83C
	QqJQ8LpCtL32vf9nGKNldg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44y6mbkxks-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Feb 2025 00:33:21 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51P0UE08025437;
	Tue, 25 Feb 2025 00:33:20 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 44y51f0q8r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Feb 2025 00:33:20 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 51P0XI1t025171;
	Tue, 25 Feb 2025 00:33:19 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 44y51f0q87-2;
	Tue, 25 Feb 2025 00:33:19 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, avri.altman@wdc.com, alim.akhtar@samsung.com,
        jejb@linux.ibm.com, peter.wang@mediatek.com
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
        chun-hung.wu@mediatek.com, alice.chao@mediatek.com,
        cc.chou@mediatek.com, chaotian.jing@mediatek.com,
        jiajie.hao@mediatek.com, yi-fan.peng@mediatek.com,
        qilin.tan@mediatek.com, lin.gui@mediatek.com, tun-yu.yu@mediatek.com,
        eddie.huang@mediatek.com, naomi.chu@mediatek.com, ed.tsai@mediatek.com,
        bvanassche@acm.org
Subject: Re: [PATCH v3] ufs: core: add hba parameter to trace events
Date: Mon, 24 Feb 2025 19:32:47 -0500
Message-ID: <174044345131.2973737.3696488766957573194.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250214083026.1177880-1-peter.wang@mediatek.com>
References: <20250214083026.1177880-1-peter.wang@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-24_11,2025-02-24_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 phishscore=0 mlxscore=0 suspectscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2502250001
X-Proofpoint-ORIG-GUID: Q1gmIuWKgbbt0rPGSaGicO8IobcucQFk
X-Proofpoint-GUID: Q1gmIuWKgbbt0rPGSaGicO8IobcucQFk

On Fri, 14 Feb 2025 16:29:36 +0800, peter.wang@mediatek.com wrote:

> Included the ufs_hba structure as a parameter in various trace events
> to provide more context and improve debugging capabilities.
> Also remove dev_name which can replace by dev_name(hba->dev).
> 
> V3:
>  - Remove dev_name entry form TP_STRUCT__entry() to reduce the size.
> 
> [...]

Applied to 6.15/scsi-queue, thanks!

[1/1] ufs: core: add hba parameter to trace events
      https://git.kernel.org/mkp/scsi/c/583e518e7100

-- 
Martin K. Petersen	Oracle Linux Engineering
