Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E67DF1DFF0
	for <linux-scsi@vger.kernel.org>; Sat, 29 Nov 2025 03:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764387037; cv=none; b=nY31p+kts/7DstEUENM3NX+E7wGPA4UZbvAat0Kp70VtW7BV2CFP/y/7LSrDIh26SJf6rGtHbkE+lGm3mvTC26qhOWdFypgNx7mzX/GQEYPTl0s7Jvtcou+G0qd9/H27qq7GT/5uBeby8LbQL04mWpxA9vRiOOt7ejSS8tp2uW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764387037; c=relaxed/simple;
	bh=nAd/hG7Lo/nXAMd7A5LJef+nb5P752LUqJG1AYJenhc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DgswZQz3bzXIcFQNDLkxrAo0AxaZoQzf99yhA7Yo981UBnMF5/jD48CpoT2stK3pfEVTyJ3fbxs/X5PClaaaab43IEHq7neC2F8QoKjzH439cvL0QZ8KIeqv4EP+ismDt4w6yJPlhr4zCDoLSBrLfqgMoVoLBX4sigmMvyCGSDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Kx/iLN7i; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Kx/iLN7i"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AT1uvZ9508146;
	Sat, 29 Nov 2025 03:30:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=xSr16eE09q1f3tC5tD4Ys0UgeW40YhZFR8mFvYsnXDU=; b=
	Kx/iLN7ib9+nxB/4bQnuSOxlr70GLzqc/59k/RWpeFCpfBvMHSu37exqCAmDzEmo
	Sji2QGKJLxDQqlfaBj/voZ9fr5+ptW5AdJA9Kvs4/j7F/DWhhkUg4K600eONAksW
	z5vvqgh6W8s1hEAJqxVoos9hU/K47sWpZdXRXSrgS7y5MkuNKvPBrm6KVBqNf9rq
	geCYHWCpCdxM0jrlFe1LH0V/mmAdOWrGn2bQ6qltbAbyjVXkVEoZt67LCugDqmF4
	CNPYbxFZL/4x2i6vcj4iyRYdur/p+6ZLsHNBGWQE3+nn/W+ceGRZMeOXRzzxvi0l
	Gegj0f0RLuFIl2mje6rMSA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aqq8c01ue-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 29 Nov 2025 03:30:20 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AT1XbGu031975;
	Sat, 29 Nov 2025 03:30:20 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4aqq961nap-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 29 Nov 2025 03:30:19 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5AT3UEpN015090;
	Sat, 29 Nov 2025 03:30:19 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4aqq961n85-6;
	Sat, 29 Nov 2025 03:30:19 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        Shawn Lin <shawn.lin@rock-chips.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-rockchip@lists.infradead.org
Subject: Re: [PATCH] scsi: ufs: rockchip: Reset controller on PRE_CHANGE of hce enable notify
Date: Fri, 28 Nov 2025 22:30:05 -0500
Message-ID: <176438479585.3682470.6069803802402545335.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <1763009575-237552-1-git-send-email-shawn.lin@rock-chips.com>
References: <1763009575-237552-1-git-send-email-shawn.lin@rock-chips.com>
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
 definitions=2025-11-28_08,2025-11-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 spamscore=0
 bulkscore=0 suspectscore=0 mlxscore=0 phishscore=0 mlxlogscore=959
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511290024
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI5MDAyNCBTYWx0ZWRfXwRDLIKbti7+B
 5JmI5ER17JJeRct/G59uXztlaOIeyRsYqv4lIedM7uXBVMAgy/pYMBv/sIBnIN35adyi0W4lX9o
 AUMh42n6hxnWkhwSKR+pIaj8nFq4oL0YzScnbKtvKSEh0+Dc0/dZBefdLy36gE7EJuW3x3y4IBy
 qZKFJ1iSs5ju3eYapzKsQ90w2EHWt1VLUodV4WUJfwrG19rDhgc7Nz75hXTB9neZOSz48xCJCJe
 HZEBZ4+sGYtFdKHp8TJD2t4pJ2r/QKyKlhDpzoZdgAdlc233qwqF4F9uXIsaC28PKDfwfiMSKNQ
 EI+7os/OWXMFYJl23U7AyWPWicvd9qWbPv+2P6OyRrzscqi1A9TahjZRLvUvKKgBxmS+pEU0G5s
 cY1BT+1kYONEo+sU2oZ36qTa/ep4Kg==
X-Proofpoint-GUID: UFye0RbPge5lnvgrakIbKKk8YzS2GDnO
X-Proofpoint-ORIG-GUID: UFye0RbPge5lnvgrakIbKKk8YzS2GDnO
X-Authority-Analysis: v=2.4 cv=EpHfbCcA c=1 sm=1 tr=0 ts=692a68cd cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=KifAWfop1pt8cB6EqPoA:9 a=QEXdDO2ut3YA:10

On Thu, 13 Nov 2025 12:52:55 +0800, Shawn Lin wrote:

> This fixes the dme-reset failed when doing recoverying, because device
> reset is not enough, we could occasionally see the error below:
> 
> ufshcd-rockchip 2a2d0000.ufs: uic cmd 0x14 with arg3 0x0 completion timeout
> ufshcd-rockchip 2a2d0000.ufs: dme-reset: error code -110
> ufshcd-rockchip 2a2d0000.ufs: DME_RESET failed
> ufshcd-rockchip 2a2d0000.ufs: ufshcd_host_reset_and_restore: Host init failed -110
> 
> [...]

Applied to 6.19/scsi-queue, thanks!

[1/1] scsi: ufs: rockchip: Reset controller on PRE_CHANGE of hce enable notify
      https://git.kernel.org/mkp/scsi/c/b0ee72db9132

-- 
Martin K. Petersen
