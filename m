Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 437623A9014;
	Tue, 24 Feb 2026 16:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771951725; cv=none; b=O6aL6PW+0XRGVGuFlP1mfo/orvw1MqSPhyjeGgqwC6ZEXNAaY+w8Wc6kXlOYyITEBxSpCd6a9bxTiuJxijgCMXf3v+zDnyeIKu3KXQBeReYSlESWhBZQ2tUJ409max4wRJndO0zJ6/gqTh7KPi3+x8YqTvn5H8i8dc+qjBi18Rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771951725; c=relaxed/simple;
	bh=RtvXueMkqgNBUC5C4HEPQpC29MFR8R/6b/n7GSlv2Vs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ec2PJv4KIV5uPlwXBi41bCgxEFEM60rLnBwNEJb++yhY7Rt6jcK+p5OM9YqMA8l02SSRZ9RbEcOtxyCWkQamIJ9nMxyPXek26xmDI6mx5u/DrXrK300GXABvnRY2t7bSKKeHvfubPROe3Z4HBLWRnl8oj926tcAP8GiwlG+ys2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=oQ55hGOa; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oQ55hGOa"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61OEMrDv3553354;
	Tue, 24 Feb 2026 16:48:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Ol6g1BRW0NVLF/YpYhxQYJqzYDIfIfHnqjOXuYUJMkY=; b=
	oQ55hGOaVsdBgQz7AmWRX5q9lw/ldpCAUGzu2BQqpNYdHReuOVmA1A+5OxjE5PJt
	jWfAsI/k36z1bvN8YD2vTfW8NwbNt8xs3cr9MHi0HoA/XnWZaQNwKsgD3wf0/SOP
	wyzLt1QndDWUf525jviPZtqQuMVEOlu4n+LbnaNLakqnOwhtqPq/zQqDCB4N5Txn
	MUUadPQrUTXO9T3GViNiOuWSewSisfXuz7CJeU5ejYThZwemiCFr8Y+TA1bNdx9Z
	HuJPG1SBRl6Bcn/O5wiuTJBHD8yOW/8AUWKoFwfAD0hi3gQrl+wyYaCkhWAqgQq3
	AhPzGF3hAh8D/WnKs5CWMg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf3a04n35-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Feb 2026 16:48:34 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61OFiDvB015761;
	Tue, 24 Feb 2026 16:48:33 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35a6m6j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Feb 2026 16:48:33 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 61OGlt4t012936;
	Tue, 24 Feb 2026 16:48:33 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4cf35a6kjb-9;
	Tue, 24 Feb 2026 16:48:32 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: ALIM AKHTAR <alim.akhtar@samsung.com>, avri.altman@wdc.com,
        bvanassche@acm.org, James.Bottomley@HansenPartnership.com,
        peter.wang@mediatek.com, beanhuo@micron.com, adrian.hunter@intel.com,
        quic_nguyenb@quicinc.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jinyoung Choi <j-young.choi@samsung.com>,
        Jeuk Kim <jeuk20.kim@samsung.com>, Won Jung <wone.jung@samsung.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: ufs: core: Reset urgent_bkops_lvl to allow runtime PM power mode
Date: Tue, 24 Feb 2026 11:47:48 -0500
Message-ID: <177195161214.1154639.16641690739618569948.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <1891546521.01770806581968.JavaMail.epsvc@epcpadp2new>
References: <1891546521.01770806581968.JavaMail.epsvc@epcpadp2new>
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
 definitions=2026-02-24_02,2026-02-23_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 spamscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602240140
X-Authority-Analysis: v=2.4 cv=IskTsb/g c=1 sm=1 tr=0 ts=699dd662 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8
 a=-L6MuwTYVIaK99d2qzQA:9 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10
X-Proofpoint-ORIG-GUID: p7Lj8UX3_xPzPNsKD512bU4TzeY3A24M
X-Proofpoint-GUID: p7Lj8UX3_xPzPNsKD512bU4TzeY3A24M
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI0MDE0MCBTYWx0ZWRfX3ehNWvIAT9qZ
 fut8xt5QQL5XzT/oi2JRfm3pfZQuQ65YGPcJnCpreprmgkaa+sayxmE/HL227sc/rhXjuEim63f
 E4LKwUWNrdxgMEkhE74AOJqYyh0vTdwaiRSP2X9VFntNT0hsFO5QTtxFzJC1liguLaa2y58vF4I
 ZQnWbxSULUmSdwYnXDl/gxFkMjyvOOQmw4xS5x77fZ8HTmWgzzU3VYW/G6mDoONjqC8dLfV/deJ
 1nvmX9Bd/XOWmXtSKB/AqK5d8xAF/07MiFyCDVBEX0frcH3gxORtd05b3Zx4BH/tvqvHCR/yvbw
 Tr8Vr1vqRIPoDb4XFi+cL2JaX+3fsO8pPOc6uUTt/yGbwTAF9Jfoq7s0du8HGG0aoGCHyD4Oq8d
 QC8bQaRM+0mOTFRtzVSfnxcs5TePxvQLu8HMNnbZ7846u2xl7EFa0vv6yohakakklDGis8TpDs1
 FqQ/jMhqZVcGwfkMrxg==

On Wed, 11 Feb 2026 15:01:05 +0900, Won Jung wrote:

> This patch ensures that UFS Runtime PM can achieve power saving
> after System PM suspend by resetting hba->urgent_bkops_lvl.
> It also modifies ufshcd_bkops_exception_event_handler to avoid
> setting urgent_bkops_lvl when status is 0, which helps maintain
> optimal power management.
> 
> On UFS devices supporting UFSHCD_CAP_AUTO_BKOPS_SUSPEND,
> a BKOPS exception event can lead to a situation
> where UFS Runtime PM can't enter low-power mode states even
> after the BKOPS exception has been resolved.
> 
> [...]

Applied to 7.0/scsi-fixes, thanks!

[1/1] scsi: ufs: core: Reset urgent_bkops_lvl to allow runtime PM power mode
      https://git.kernel.org/mkp/scsi/c/5b313760059c

-- 
Martin K. Petersen
