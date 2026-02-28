Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52A6A34DCD2
	for <linux-scsi@vger.kernel.org>; Sat, 28 Feb 2026 22:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772317356; cv=none; b=Ms68Wj+DGM82brFQEfAZNXFvNFk07TBQs2W07+UnpUJAbfq7sHE/2WtJNT0QC8y9xvXhTtvFzcLUDKJpYyiaIOplNiTPlFpmnuFIyRyOruEuC0oXnpu88JnWLqJxGNelnrRliGF0t/m+LWJo55q09R+8h0aW54e4wFIBCEmGfWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772317356; c=relaxed/simple;
	bh=MC3W+xnaMfJ7Chl2dXLXZHGosbDRHS0evtyTpQriHB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mzpLsB+Yhlws85J106rXTbxsEro8rmRSJ2VRLDe78cUx8ycYO4rz+E/Sr3rkuvgP2xdOeyiLUOoW79Au4ZWh2wK0AssGTRDshrhMNc8cXdQ/0gMWidAnObFyHADV79jiUaxKePRnmO/QEIr29aF+4yfDJz3XFLOxPwuk1tXaPIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZurTbsg0; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZurTbsg0"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61SL98iu3793294;
	Sat, 28 Feb 2026 22:22:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=bwUkbaTki6TTnhaRVp0leO5Xd4rs/qy/Oc0xfqrFu94=; b=
	ZurTbsg01mltRI1cdZCb6R4ksFE2rHSmN/fGWIBxEPw8B6kPUGgh8qqPUEe8tPRZ
	uMN7UIM2M39sBhiyaeQSIG0BIXtgNyozvyO6ebV63uLzAsQcBqa+hmWYFaYlRTE6
	XTdLjid7iMDy5pyteRdEQcBlNmUXRSFY/gb61+xZup5JkasHWHNdktBDrI246Cnf
	2mtv3VXKlVg/YUTeaeyObCiTHaYZHIAzWv7P2ay1g9eNXd8KL+CDE8ojIapl7ebq
	biQXykHAw7+oZeFUTqfFAzffQSUF517lOEelcLjRPeMmdUuqRB8Yzn+BXcOdQPUH
	f2hmCPBPFaeJ6a1Vb2q9kA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ckshbrkf4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 28 Feb 2026 22:22:18 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61SL0h8H036986;
	Sat, 28 Feb 2026 22:22:18 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ckpt7bhe9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 28 Feb 2026 22:22:18 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 61SMHlvb018394;
	Sat, 28 Feb 2026 22:22:17 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4ckpt7bhc9-5;
	Sat, 28 Feb 2026 22:22:17 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, avri.altman@sandisk.com,
        alim.akhtar@samsung.com, jejb@linux.ibm.com, peter.wang@mediatek.com
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
        chun-hung.wu@mediatek.com, alice.chao@mediatek.com,
        cc.chou@mediatek.com, chaotian.jing@mediatek.com,
        tun-yu.yu@mediatek.com, eddie.huang@mediatek.com,
        naomi.chu@mediatek.com, ed.tsai@mediatek.com, bvanassche@acm.org
Subject: Re: [PATCH v2] ufs: core: support UFSHCI 4.1 CQ entry tag
Date: Sat, 28 Feb 2026 17:22:05 -0500
Message-ID: <177231727974.1778274.1876634781735565722.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260210071834.1837878-1-peter.wang@mediatek.com>
References: <20260210071834.1837878-1-peter.wang@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-28_07,2026-02-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=0
 spamscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602280208
X-Proofpoint-GUID: 3VOD1ymBdAtUzsH06FX_sysFlP3o3V0W
X-Proofpoint-ORIG-GUID: 3VOD1ymBdAtUzsH06FX_sysFlP3o3V0W
X-Authority-Analysis: v=2.4 cv=Qaxrf8bv c=1 sm=1 tr=0 ts=69a36a9b cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=VwQbUJbxAAAA:8
 a=mpaa-ttXAAAA:8 a=QqvJkLw1XXo513EEspsA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI4MDIwOSBTYWx0ZWRfX4GdiTL/4Gpk+
 /KRhDWc1HCxXZqzToOL7iAcMboAsrMfWyL2s6xflIYFZs7QQ4BfQu9aGtN/0o2tZN5DZp07OO3v
 XHhRu+CQtxTPad3cBE/Ii6XbXtHjXuE1/lsoeWa0TwPIOv8xb2uFSkCqmJ9SjOQwhzwS0R5i0+u
 OGyORTayGyDLueJ8x7dqRlgFojARt+5AVf/MP+yTLBrtadC64KguXZaIiuQwYYs7Ua6OHSecIoM
 dXn2DNA0B0f8UktQG78qJTFP4I3atD5LqFTMgiHWTG6kuLm5tJjhCtoOuCNQatAr+6ypWV7HIz0
 repL6Qy+7Ne3HNx6JEYmd/IHYhT0o+0Ia6450iCLMoK1jDqz3jzmi2SQdquiJ60XC/TTikf39Kj
 Mky00SPmDgaVPRHbXChfv62h50uaqf7QDDIoWQjVGB3rMmAvSnlvPvPN9QMFSrbo47p4JrltXxw
 Rj2UpxGgpIp7eeNWRQQ==

On Tue, 10 Feb 2026 15:17:30 +0800, peter.wang@mediatek.com wrote:

> The UFSHCI 4.1 specification introduces a new completion queue(CQ)
> entry format, allowing the tag to be obtained directly.
> 
> 

Applied to 7.1/scsi-queue, thanks!

[1/1] ufs: core: support UFSHCI 4.1 CQ entry tag
      https://git.kernel.org/mkp/scsi/c/f707860ebc84

-- 
Martin K. Petersen
