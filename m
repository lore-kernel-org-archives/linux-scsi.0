Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C42F626F2B6;
	Wed, 17 Dec 2025 03:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765942839; cv=none; b=uykiIpuuz6yFs69krI2zUpF95LaEBwxSVHEnNcYecTsvk9JNxgNgtGFbZLUPFo1utb2Q1r2VfB09SDkeoH5LuyU6qje9GWSgKaxWpBlX4E9S/WWtcuZhzUcoSRCXon7poXydNqtoy6/Vi9Ro+tvCXqniMtGJzGgfmSAkU9OvjfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765942839; c=relaxed/simple;
	bh=4z3EtR+XCYuok1/09ymsEKoU7B/l5Y3JrhMmF0sL6qc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aG/BnMP4iGhqAYaJywHwNoqXHE7w1jRFjZcfhpn9sPzn9meaLxbxhC9dMdgAqB86OXpAi9hqsX5iPfzSkcVoVpitv/9biq3J8J2mGg6drP3xK9w23vNog1gP0xpD+q/YwWcnYrpBjugYJaAXZJXqyKd6MI1zMz/ZGsVvIR4g1o8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=CyN0LfGj; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CyN0LfGj"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BH0uM391485406;
	Wed, 17 Dec 2025 03:40:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=IDui87S4/LYLqSLYCDl7sszouWgT985n7pCnJtJHMLA=; b=
	CyN0LfGj3GluefYh1Np2ksYxlyX+3PZkWoSb1GxpYFnoArctYN6lGAPTLzUSudw3
	pFtF7UFKSMKmLxrHfwWvjAK0aFt7Kz9VJ0sZKckjnNCRWlAndLolczJgwGPqa16T
	UBRYBM5nuOhRZyYNaGYyeaLp5hTqdW7xP05LjdGaGcFKynnbOk8b/g1d8Dze+vBl
	tpNjqJWtovtR40Ou14lQ9IJDdHfu5V1pE9QwVTMxkpLQtUw2JnwCC7sQlR2xaTb7
	y7drHXzEKR3gXpWlf2AG34R/o4QGL1h1j7hjRtewd6AXeQwV8VfZJHmDmMjLZP9W
	69NLUPrgxEFMUZ2NcXYL3g==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b0xqxw8f0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Dec 2025 03:40:25 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BH2Iget025257;
	Wed, 17 Dec 2025 03:40:25 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4b0xkb9afb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Dec 2025 03:40:25 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5BH3eLwd023311;
	Wed, 17 Dec 2025 03:40:24 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4b0xkb9adw-4;
	Wed, 17 Dec 2025 03:40:24 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
        James.Bottomley@HansenPartnership.com, peter.wang@mediatek.com,
        beanhuo@micron.com, adrian.hunter@intel.com, quic_nguyenb@quicinc.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Seunghwan Baek <sh8267.baek@samsung.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, stable@vger.kernel.org
Subject: Re: [PATCH v1 1/1] scsi: ufs : core: Add ufshcd_update_evt_hist for ufs suspend error.
Date: Tue, 16 Dec 2025 22:40:17 -0500
Message-ID: <176594264295.1094313.149495458362154867.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251210063854.1483899-2-sh8267.baek@samsung.com>
References: <20251210063854.1483899-2-sh8267.baek@samsung.com>
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
 definitions=2025-12-16_03,2025-12-16_05,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=889 spamscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 mlxscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512170027
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE3MDAyNyBTYWx0ZWRfX27Nc2iU2vVVE
 Wr3/M+Tqv+OTK5xBat/37bpt/qNsHoMD7Q9uKxIXf7xeyCcDSA9LHbJawFPHWJ1mhdIqhs4SLsR
 CmJNmgyxt1SHj2gHeyJLsMfEsHugIbkSuOJEkf7MVDPMNkOtYei+R3UTPJmjx43WI4CHlMEEf8J
 YjJ2qsyGT4P17fAr5SY9LopDPTKt+TXDAakgB2L9eLPZPHugRSP6pemPNaTERXikOdU1/9zM3hM
 D5CRJTIa4QSA4NUveMLOU4KN3M0+9oJf5SVRNd94mx2K1Exc5uJ6BhguLRqVtazUqBfAV2Uuc9f
 6+HdhcCte+VjwMxqh513T9TNbeYmk9+4LExRNgKGV3PoCMFWa6LdbQiIIHCUjREsHBiuPIBDmXv
 o6yaJy/toAT/lHUP8827i16JN1fTLA==
X-Proofpoint-GUID: 0pSsZdACtKM6FlQGajlv9rN9UgRQD7sw
X-Proofpoint-ORIG-GUID: 0pSsZdACtKM6FlQGajlv9rN9UgRQD7sw
X-Authority-Analysis: v=2.4 cv=BYDVE7t2 c=1 sm=1 tr=0 ts=69422629 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=dDrjAAvImfPD8B1ja_AA:9 a=QEXdDO2ut3YA:10

On Wed, 10 Dec 2025 15:38:54 +0900, Seunghwan Baek wrote:

> If the ufs resume fails, the event history is updated in ufshcd_resume,
> but there is no code anywhere to record ufs suspend. Therefore, add code
> to record ufs suspend error event history.
> 
> Fixes: dd11376b9f1b ("scsi: ufs: Split the drivers/scsi/ufs directory")
> Cc: stable@vger.kernel.org
> 
> [...]

Applied to 6.19/scsi-fixes, thanks!

[1/1] scsi: ufs : core: Add ufshcd_update_evt_hist for ufs suspend error.
      https://git.kernel.org/mkp/scsi/c/c9f36f04a8a2

-- 
Martin K. Petersen
