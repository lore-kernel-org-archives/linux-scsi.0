Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D98B11E5B9F
	for <linux-scsi@vger.kernel.org>; Tue, 11 Mar 2025 01:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741655995; cv=none; b=eB4Wvrw8CYB2fq/ecSnw7Nwl/Fzrd70w0PPm6ts80WKycwsgHf6ib7HxYR6g1KuDzhakhccYOrkCp7QErDUTt0cAyrEstdDN4H80B4g1rDgPJXvFbzNTgsAy8rN4QRWgJXuXEH5y4F8OXKTkymqIZ2x6FXjjqcyidmF7clx89rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741655995; c=relaxed/simple;
	bh=biO+oPedyYMdjYKkPoJTvT1r3lVxEnHJVf/ORPzsPiI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rBk2Ddztz88naRhFTQ8m3RAPrmuRsCXlALiFDH87Z1QFlGeKlVFI7ca0au2ydNZcu6/WkxeoIpw05Iz5AM3wFu1bdaRS/D+TPftdlLh4P0NJWSgbqJFcPtnQINP1BhXU/xcEzq4Rahm2AbfnzpahPSA69ahGb3lfTFe9a8BtQQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=QjMvGj/J; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QjMvGj/J"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52ALfkiK025703;
	Tue, 11 Mar 2025 01:19:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=oZ/iDPI+a/xGmVspkD5+H/zD5tFx+1Ijx+VpXYsdFnI=; b=
	QjMvGj/JaLPNEZ4OJWWmAILv2QP6k09I48vN42XjjO0wy7nm1MszlJ1+5HkzAV2s
	yijEoF6k8Jo26iz+Bng3KC/MlfQKzDfJjQCUg1hdcYyb4Qwlc4VvGXSAhksXIEV/
	xQyuSB5bRgHQga/9+OerRbei0786oEHop4OTCJhnaDWoparMAO39NW6Wb4/5SgS6
	MwE4BLlEJ3ZW8MZobpbIhcxYe4vIUP/JJkXFTd9t1HmS6EOP7QS7AbRBMhPaKLOi
	8faasGk/Th5uhJlhPlpthrGkl3oEV0Sm8cKYW7p3chJrNGt5n206QI5O6dXakSAa
	R9xiR1S1f7hc00rDniT9PA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 458dxckw23-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Mar 2025 01:19:47 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52ANHein017110;
	Tue, 11 Mar 2025 01:19:46 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 458cbencnn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Mar 2025 01:19:46 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 52B1JfrL014960;
	Tue, 11 Mar 2025 01:19:46 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 458cbencm8-8;
	Tue, 11 Mar 2025 01:19:46 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        Shawn Lin <shawn.lin@rock-chips.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH -next] scsi: ufs: rockchip: Fix devm_clk_bulk_get_all_enabled return value
Date: Mon, 10 Mar 2025 21:19:07 -0400
Message-ID: <174165504987.528513.16353015722329183490.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <1740552733-182527-1-git-send-email-shawn.lin@rock-chips.com>
References: <1740552733-182527-1-git-send-email-shawn.lin@rock-chips.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-11_01,2025-03-07_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 spamscore=0
 mlxlogscore=699 malwarescore=0 suspectscore=0 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2503110007
X-Proofpoint-ORIG-GUID: hGDn_c7BQKNBkZa4RQBFejKwFFqju6Kw
X-Proofpoint-GUID: hGDn_c7BQKNBkZa4RQBFejKwFFqju6Kw

On Wed, 26 Feb 2025 14:52:13 +0800, Shawn Lin wrote:

> A positive value is for the number of clocks obtained if assigned.
> 
> 

Applied to 6.15/scsi-queue, thanks!

[1/1] scsi: ufs: rockchip: Fix devm_clk_bulk_get_all_enabled return value
      https://git.kernel.org/mkp/scsi/c/4fffffd3b134

-- 
Martin K. Petersen	Oracle Linux Engineering
