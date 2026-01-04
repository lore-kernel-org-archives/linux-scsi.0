Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91B70314D0E
	for <linux-scsi@vger.kernel.org>; Sun,  4 Jan 2026 21:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767562992; cv=none; b=ULDEpzNh6nVlmnW44m22H3U9VdZlZUPlASc9njvYPWwjTNxSRWRelHl3f0uBp0PjpuwYjUyF0hFoFKp0ljlgiwN2aUVVEeCJuDQKut9FS2TizDDVHso8t1hZXJRYDub2Clg0adixJtx17PwFVb0f2Vu+zuNyZkNsi71h3GTFCc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767562992; c=relaxed/simple;
	bh=tjlL6KhEEutzqhWxwltNHfH2dFqPM5xDTZeB37oTVD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nEhlUc+n7M5ulD1iY8fkGpFlQkaa1i4RgfIjN6WTm7bCu8R5Vxwllo8/v78BH6mQMcGdYzN0cGDHg0gSElo/QqPlYvfJx2yk3HMv8r4ZpGQuT1iJV6dzlYxF40SnNx/7D2YhWDEdCEv9VR3GGk/RJ7zs3nRdYcuuiDVrSJM9Oug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=T/wAqqAI; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="T/wAqqAI"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 604LgrWr4171784;
	Sun, 4 Jan 2026 21:42:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=6poNO1DpvKMGAUWqq1UHwrnfAThUEgEI+K53wKUUzd4=; b=
	T/wAqqAI0BbX+6VtCOeZ6MRi1V8hHtx34Shp7dptF6aZuW3ScxuB36Dh7lF2CMir
	H8OP5H3zF+pxOpos8oKLvDE3sQMOlO3nZHg9Vza+/XL9i+D/S4gcoeYkwE+v6VfQ
	iT56NxgXtAZLge0Bmd4yMi4mm7Xq1HIo2JlJ+UMAu/8T9bjfsoha14c1/W6/YPpx
	wUAL4ZTu9J5XULNiKF9Jg4jzxmTz10wLXCNtrlQs/gRGs2jl0YWlSvDVwsMJ7Nst
	qeWxUzrmTkrOAo4yq7NDMExN1dxJgIfApKjgQoWTH7Q33OtMvbSQQ+lnMgVcW+FF
	QSOl05b7rycJ3DFqQ0TSJA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bev37ry2k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 04 Jan 2026 21:42:52 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 604GfTBq030813;
	Sun, 4 Jan 2026 21:42:52 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4besjarf2v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 04 Jan 2026 21:42:52 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 604LgpIm034017;
	Sun, 4 Jan 2026 21:42:51 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4besjarf2n-1;
	Sun, 04 Jan 2026 21:42:51 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Nitin Rawat <nitin.rawat@oss.qualcomm.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Peter Wang <peter.wang@mediatek.com>,
        Avri Altman <avri.altman@sandisk.com>, Bean Huo <beanhuo@micron.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
Subject: Re: [PATCH for rc] ufs: core: Configure MCQ after link startup
Date: Sun,  4 Jan 2026 16:42:41 -0500
Message-ID: <176756271698.1812936.2371830497137890922.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251218230741.2661049-1-bvanassche@acm.org>
References: <20251218230741.2661049-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-04_06,2025-12-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 adultscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 spamscore=0 mlxlogscore=936
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601040199
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA0MDIwMCBTYWx0ZWRfX0SJxZcouJjLd
 zAwyLbPbGPnEP7hroszlUHSPSKEPRL3NTYvulpLWP3kgKj08KAfSZ9f4Ls73UtJqyaWolagCi0f
 p34hc3lbrByU0uFGOJelrhujcxxUtVuDAfknfv4u+BIezFhqxITIdTRWFvaod5v5Hd3xIEQCgcn
 Zd5NE0wF6GSmr1nBo6jEMQCj3L3ioZ/p2g+hGtgtogSNFtRZ0O+KIVgSh0ov/gGoRitMcjS6pr5
 GlBCxCvPDzjmjTEZwEcyIBLV3UYORT98jNf/wpUI7fU26yoE8e+D+B+HQXwCbyiBZIaXh6IgwXT
 q1HUDpI87wIcy+tiCHygvaW4sp5CjedXF9Pw1ealZZaZzrJonXY5joitsq0JqnRC2DL9tyTePVY
 eB3e32cSQL2CsL0b/nIJWJHoNw4/60E5MjM3yI4jHaPlHe013ohlHTaRhcwdLBiJ2DQMpf7NWf0
 AcSLboAlsbifMHjjzvhw6K6p/HXqpE/PWC+eRTvA=
X-Proofpoint-GUID: 2apcrfLQHK48lpxcX4v62U5OBI5t1Uch
X-Proofpoint-ORIG-GUID: 2apcrfLQHK48lpxcX4v62U5OBI5t1Uch
X-Authority-Analysis: v=2.4 cv=F89at6hN c=1 sm=1 tr=0 ts=695adedc b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=j8opm_o-RrqdPbyV6ZgA:9 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:13654

On Thu, 18 Dec 2025 15:07:37 -0800, Bart Van Assche wrote:

> Commit f46b9a595fa9 ("scsi: ufs: core: Allocate the SCSI host earlier")
> did not only cause scsi_add_host() to be called earlier. It also swapped
> the order of link startup and enabling and configuring MCQ mode. Before
> that commit, the call chains for link startup and enabling MCQ were as
> follows:
> 
> ufshcd_init()
>   ufshcd_link_startup()
>   ufshcd_add_scsi_host()
>     ufshcd_mcq_enable()
> 
> [...]

Applied to 6.19/scsi-fixes, thanks!

[1/1] ufs: core: Configure MCQ after link startup
      https://git.kernel.org/mkp/scsi/c/ee229e7c256a

-- 
Martin K. Petersen
