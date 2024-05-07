Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 950AE1FA5
	for <linux-scsi@vger.kernel.org>; Tue,  7 May 2024 02:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715047306; cv=none; b=iamGeWEnTx6SgStVFV6JJSdTN8yUapJDLimXM32DzS5JGod7OifCEfkQS+Mbwc8R8Fit9tYHad5fDl/HgE4BB/5dPYi+YwsqJNwxoarMdjI0sUaP01kwPiNTEERWazhXLYdY+wZldNyYCTPArX9JviIS7G9zXl+H1+ChgNPv99c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715047306; c=relaxed/simple;
	bh=WLFkC8QwFUnwikw+Ha84E46FyVxNtGfWRZ4eLK6FC1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M4l83LJmGiiRcGxfJu8+A1Xl0ypEpwhi/zT6OEngB7fo+UP/Sfptbuo2jR1lr6DJc+u7CVSSOk4X7fJFxiedjix/nhBEJilpfkSfEHsUMkyXcQN0ajSvdyyjln7XrzbvNq4tN6TmZ4QARIMyq+5dCQmp/zKIpR8rCtZX88RSKwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=YCn84KAx; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YCn84KAx"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 446Mmi69018422;
	Tue, 7 May 2024 02:01:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-11-20;
 bh=okNrxqfIv56Hd8kMCBbN669Thv0MvyH1gEtVYgvrcW8=;
 b=YCn84KAxGl7g2QXTEnQBHzbVPtBfQWGMDW1Vltr+FshzRTyeEBe4YSsDMGYJtfxCoy0c
 wshbADQHavHwiG2yyJMYFTDM+sb3NZ+7kQe2ZNh8QFQ+bjmkWO9stnvr3d4aQTfFsp5U
 2B6ZcHcxlGTTNXozntRnRu+0TTIBkhtSqAIDL9eim3uzIAM8kf5Eg/ccuXrcSNh/HwT9
 J9GThXxhorZrUQaXeV3PaF40PuifTWVa5jxHhH7CFjnji42EwtYo11ELToXqxNelMdNc
 +xtToidhtG/ny2y/oTdZWLNi9VcqSI7so5QA4dQbcxMusr0bzgxCyIHKolJOJYx/WxZ1 AA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xwd2duvs7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 May 2024 02:01:18 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 4471AK9p006898;
	Tue, 7 May 2024 02:01:17 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xwbf7dbwr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 May 2024 02:01:17 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 44721Em1034149;
	Tue, 7 May 2024 02:01:16 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3xwbf7dbvc-2;
	Tue, 07 May 2024 02:01:16 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        "Bao D . Nguyen" <quic_nguyenb@quicinc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <quic_cang@quicinc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
        Stanley Jhu <chu.stanley@gmail.com>,
        Po-Wen Kao <powen.kao@mediatek.com>,
        ChanWoo Lee <cw9316.lee@samsung.com>,
        Yang Li <yang.lee@linux.alibaba.com>
Subject: Re: [PATCH] scsi/ufs: Fix ufshcd_mcq_sqe_search()
Date: Mon,  6 May 2024 21:59:49 -0400
Message-ID: <171504445057.1494912.4128809007775189217.b4-ty@oracle.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240410000751.1047758-1-bvanassche@acm.org>
References: <20240410000751.1047758-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-06_19,2024-05-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 phishscore=0 spamscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2405070014
X-Proofpoint-GUID: 8_SM5Ol2a_QnhRGIcB9gHl6Uq3iw4-SZ
X-Proofpoint-ORIG-GUID: 8_SM5Ol2a_QnhRGIcB9gHl6Uq3iw4-SZ

On Tue, 09 Apr 2024 17:07:45 -0700, Bart Van Assche wrote:

> Fix the calculation of the utrd pointer. This patch addresses the following
> Coverity complaint:
> 
> CID 1538170: (#1 of 1): Extra sizeof expression (SIZEOF_MISMATCH)
> suspicious_pointer_arithmetic: Adding sq_head_slot * 32UL /* sizeof (struct
> utp_transfer_req_desc) */ to pointer hwq->sqe_base_addr of type struct
> utp_transfer_req_desc * is suspicious because adding an integral value to
> this pointer automatically scales that value by the size, 32 bytes, of the
> pointed-to type, struct utp_transfer_req_desc. Most likely, the
> multiplication by sizeof (struct utp_transfer_req_desc) in this expression
> is extraneous and should be eliminated.
> 
> [...]

Applied to 6.10/scsi-queue, thanks!

[1/1] scsi/ufs: Fix ufshcd_mcq_sqe_search()
      https://git.kernel.org/mkp/scsi/c/3c5d0dce8ce0

-- 
Martin K. Petersen	Oracle Linux Engineering
