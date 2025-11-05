Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D39161F5437
	for <linux-scsi@vger.kernel.org>; Wed,  5 Nov 2025 04:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762315366; cv=none; b=nFV3C1wo2dTxsa2DlW30tLp0AS9BpAViNHdDGCBf1j9dZQ68fUstH05eLCFkFEgeJ6URfwhdy7wKOzfPspPWdzIllqZxYdki1tr/aSdPCKoW6nHUNXvctentqg9Iu31OW/CQCSBc/TnVdAUgLCAHb1/miVLlWVZaQAlpzMiSDp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762315366; c=relaxed/simple;
	bh=hggDnZhs7bXavOY2h6Ubnu2c8Qr4tEP89RaJE/y5oo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PP5jiyplGoEP25p8pj0Z/yDd+i72G32CzEAmwDtfVxxu5IFiQc1bGJBFIOdfLd1CcwdLg2w9oCAkrfxLc+5gG1CM7LNxsWYYWNO6w10tdbp7k2bnUC4PxVZQjmWTFIwI8lCNM0tkiEtwkPoAGqj2vrw8seeIDd7AzPMgB+tIAy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=mew+zmai; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mew+zmai"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A5301mc005477;
	Wed, 5 Nov 2025 04:02:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=VTOksKKE8j67djUM3ZOqPgGgQ6ca+1ZmSFBkM4QwGz8=; b=
	mew+zmaiblm+o3Anc2xI7zvgDssqbVWobz2Ws62XSpu7eVEFBI4iFl4X8rI/7zOw
	rUOZSkx/oAFFJhCDMsJlgVVZ6MLZGJltvH27YTW/9o6PJ/eImS68AaCRGxqOykzO
	PN6/BaEvaNl1q3PlSQtAEuY5W1vDFXUkxlNWYOn4rGqt1AzvO93pIwedGMNwtAoU
	m8XXKqo3E9nmoUehMD3LJzI2bpQGuoRbt27BsJ2kamT3ONMHHuRHhmvXJzuwxtWp
	YD/5KDFoThd/yXARDo8U2vyy1pbRhuux929ydX9KzuEVlw0O7yvCxtQBNCN+8fPG
	6YlVfer4OptooYD5KQZj/Q==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a7x9fg2dp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Nov 2025 04:02:29 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A51wQqU024861;
	Wed, 5 Nov 2025 04:02:28 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a58ne15j8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Nov 2025 04:02:28 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5A542Prq005395;
	Wed, 5 Nov 2025 04:02:27 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4a58ne15gy-7;
	Wed, 05 Nov 2025 04:02:27 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, jejb@linux.ibm.com, alim.akhtar@samsung.com,
        avri.altman@wdc.com, bvanassche@acm.org, chaotian.jing@mediatek.com,
        peter.wang@mediatek.com
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, matthias.bgg@gmail.com,
        angelogioacchino.delregno@collabora.com, chu.stanley@gmail.com,
        chun-hung.wu@mediatek.com, alice.chao@mediatek.com,
        naomi.chu@mediatek.com, ed.tsai@mediatek.com
Subject: Re: [PATCH v1] ufs: mediatek: Add the maintainer for MediaTek UFS hooks
Date: Tue,  4 Nov 2025 23:02:21 -0500
Message-ID: <176231440756.2306382.811755973516125170.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251031115356.1501765-1-peter.wang@mediatek.com>
References: <20251031115356.1501765-1-peter.wang@mediatek.com>
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
 definitions=2025-11-05_02,2025-11-03_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=763 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511050024
X-Proofpoint-ORIG-GUID: Khy3D3TMINcB1MJcl4CFlpnh9NNmYcaN
X-Authority-Analysis: v=2.4 cv=LYkxKzfi c=1 sm=1 tr=0 ts=690acc55 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=mpaa-ttXAAAA:8 a=TyFnxLCT_s77ql2NTT4A:9 a=QEXdDO2ut3YA:10
 cc=ntf awl=host:13657
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA1MDAxOCBTYWx0ZWRfX7GlbIpMU7mgK
 tCXFtoKgfmgL9WTClf3W40EQYuPuh/JFWoV0Ow4Y6DKOd5Na9pSN7ipeyOYesLWxghqZq3Zy2p6
 O9viij6r6KlHkU/Rizm2BqU/86AITcqiCLulcsCcv88oIgLZXDaelEvhrd5HCPSS9erodC4Jfhw
 mlqKtVcTx6nn+2ClTsf6gdETItVL0I/BlFq+RX5MhRhAnst3qWveyj3Rd58L+KseGws7BFAbZ6u
 aRNCrVDn5c4TmhZ34qI0adFB+B6s71CF4m4KyAcePoTwY/lq+gEB8PN8tu1AAr6FRHTNXGMZ+bo
 UrGzPpyyQmH2wvp5PW4jnvLt27+l0McC+GXE10XeoQguBLR+p3ZT/0MieC6jV/CCYkyxLrqfvg9
 GojSrZx+EsfJ4QCNNBWAFeE7kmllDBp+0WHBIegX8nXnIuwMERA=
X-Proofpoint-GUID: Khy3D3TMINcB1MJcl4CFlpnh9NNmYcaN

On Fri, 31 Oct 2025 19:53:16 +0800, peter.wang@mediatek.com wrote:

> Add Chaotian Jing as the maintainer of the MediaTek UFS hooks.
> 
> 

Applied to 6.19/scsi-queue, thanks!

[1/1] ufs: mediatek: Add the maintainer for MediaTek UFS hooks
      https://git.kernel.org/mkp/scsi/c/b0b9c7ccc1ef

-- 
Martin K. Petersen
