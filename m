Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C40B5315D20
	for <linux-scsi@vger.kernel.org>; Sun,  4 Jan 2026 21:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767563013; cv=none; b=gwoNF/dKNPghh+Ufs6nL034dwDuyf8RdlSlLzhy6tR7+fxFPJKwFo9CxkxIvbwESKgIQdizzrW5CEhlUbSv4MXGa5gDVpBmUsTrvLSc3QcsjEsI0V4W1tngSEL00WH5zsB93lTAdsY3P/GBR7NYV5RHI0oBMPDxQxUz80RbAXbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767563013; c=relaxed/simple;
	bh=CJyFS8zKZva+KJKMHt744nVMivVGB3qKcOMVe8WccRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CafwBcs6KdcCjrxQLabBxqqWZeKO8EJ/sL+aAdqUQzhxI6Qgm9/uK4t9DozrWs8jvXcwptNTK40nmUMJ3nI04H9TLXVwcLhpWLum/Xz7VsRN6LuTB82pv2Onl9r5vggcXfgpOhM73NfqPd7yacbOqhKhJkVkjwLBCnwcjGE4d74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UazlyIhp; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UazlyIhp"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 604Lfs4E009110;
	Sun, 4 Jan 2026 21:43:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=G3p5arkLYNNCWXgL7uXWyuxwO1XsftbCORftvGsSzys=; b=
	UazlyIhplpPDJsZXZco5zRqGuUdSgKobkZxKKM6xIOkNnnouWAWfNjEozjRidHKE
	ePWa2O70M+iijVq+Z7zcZG63nhE8VWs1vXOxHFyha6TYcNDGxrLlUuP/hkLXapAj
	Cg0EYFxcdJxTMm5J1tD+BhWpEi7WpdpmulP4h9kxEQje4mGZ5IN10lZuMZZASEzY
	DO/duEWw+DpH1MHT8HV5NXy/9BdKpo1PJ/6Q7AGfevoCKNYaqJbTaH5WuRDTTJKE
	E07m3YTos4o+W9hG0EQIijDbuFs4u7yR5iyfya6pRqPvaDrQdcaA1Dw3r80JKeUQ
	mlNLT6nibwj/lmJamBQcQg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bev6ngxwt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 04 Jan 2026 21:43:29 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 604GlorA026603;
	Sun, 4 Jan 2026 21:43:28 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4besj6gbh0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 04 Jan 2026 21:43:28 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 604LhPoT007658;
	Sun, 4 Jan 2026 21:43:28 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4besj6gbf9-4;
	Sun, 04 Jan 2026 21:43:27 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, Justin Tee <justintee8345@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, jsmart2021@gmail.com,
        justin.tee@broadcom.com
Subject: Re: [PATCH 0/3] Update lpfc to revision 14.4.0.13
Date: Sun,  4 Jan 2026 16:43:10 -0500
Message-ID: <176755562242.1327406.14262393628406702589.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251211001659.138635-1-justintee8345@gmail.com>
References: <20251211001659.138635-1-justintee8345@gmail.com>
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 mlxscore=0 spamscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601040200
X-Proofpoint-ORIG-GUID: eAd5lETyaZvPPas9VgrB6V8OxEWlUVYx
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA0MDIwMCBTYWx0ZWRfX/2R+B+B6i+cc
 yyhV+oPFZ7OKoAevrUg5YvLE/+8AlmeAsyZnjziw3M5Nwavdxx42iRXH3osr2D+z1gDFEexBwXe
 jdv2HtiDgPnNrAPCdO3Vd/2W8BXVFgyrWSyjr0Q2NnHYzPGnESZNuQVoaoPYiVfhwHBVHJE3PnK
 P/mLql/+zuT6Q4QXKd+wRNjJrr7XkIhE/ikTsjMYdi0sOikgJiJlpA7vli1XI6iObobfnkQkmlJ
 YM5ogWSqInsdWUkSWgPfCmivX+lQbVGKs0I731vvqtVDZPD6vXeUX4nfGMaJ+uJ9HXzNiPMW95t
 j0b1MVB1LrPcw8vF+txkH4xmtwKzz8o6DOnmzC7G9a2MB9YPfQ5HJ4MN+Y9i0fiVs42atPurvyN
 Pp3zfNPtdzkSnkjXpNT5G7yzLwqJzIwTuEjUm4PdxyQ8W0NsBDoAUW94/PN2IcB6L6cLn6tQ3zv
 EeuTLrHm4c/Yy1doOfA==
X-Proofpoint-GUID: eAd5lETyaZvPPas9VgrB6V8OxEWlUVYx
X-Authority-Analysis: v=2.4 cv=QtFTHFyd c=1 sm=1 tr=0 ts=695adf01 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=ygGwB_NCQbuXTOrIIS4A:9 a=QEXdDO2ut3YA:10

On Wed, 10 Dec 2025 16:16:56 -0800, Justin Tee wrote:

> Update lpfc to revision 14.4.0.13
> 
> This patch set introduces reporting encryption information for fibre
> channel HBAs.
> 
> First, the scsi_transport_fc layer is updated to include a new
> fc_encryption_info attribute that is added to struct fc_rport.  Supporting
> sysfs and LLDD templates are provided.
> 
> [...]

Applied to 6.20/scsi-queue, thanks!

[1/3] scsi_transport_fc: Introduce encryption group in fc_rport attribute
      https://git.kernel.org/mkp/scsi/c/bd2bc528691e
[2/3] lpfc: Add support for reporting encryption events
      https://git.kernel.org/mkp/scsi/c/e2dacf8e5e33
[3/3] lpfc: Update lpfc version to 14.4.0.13
      https://git.kernel.org/mkp/scsi/c/621164425315

-- 
Martin K. Petersen
