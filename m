Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F8A4346FB5;
	Tue,  9 Jun 2026 01:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780969165; cv=none; b=oFXjG3HskF5aFs44yejr+tbX1XUeasNz7xjBRemVrtIkQkUsaUqcCKuAsz0QwEnsMfUjQqSIsTQk8ecyC4AhLudvDNcOPxiQ4nnMXKTyWzfsoeRdjYgmwDZ8UC5IwN0UQ5uMCcBN9lfhruvUdOaRF9iJ5ZwxRhP9dNnM1I+CkpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780969165; c=relaxed/simple;
	bh=3I+FbYCoEoRKsR1eOdrfP7IhEOKfnQJz1L3JvxSXE14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Wajh8b11bPqaudpJBQUsreELsgkX+yecw408xYKSSjHU0FbkROKs35x/UvCJZYYuRgJAwahMp5JQ32kWnoDC8rN+LZy5eWHe/+IdX9uVQ8EG1Odn/0JUFrZTsrRh1UbHzH/hXY4Cay+17iL8alHdV3K+jbZqaCpQwzno5o7SXu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=El2hv/F+; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="El2hv/F+"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 658HSf121690708;
	Tue, 9 Jun 2026 01:39:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=OX7A5KXyQS3wN1l9dUS78hTJOmX0YcnFyvIu953XMvo=; b=
	El2hv/F+6bdL0/WePv2OlC0SVebLCRgfGrbMDoD0IDmQsEJ6xGWG/xDcaGZY7IjV
	HJsILW5ssIKxfdHLKadPz98J6+jWVGWPs21b0qvWkF5G80uMIddS9k8xh+fSmRl0
	fH6pf8X+ghVTDo8h+gWPV4soQdQWIYoIlOlOkAMATjYSGqeA3+1AIw/44qmnCdiC
	NtGxuV3446VPM8sNUWYCd0hQ1oSLkpirrboH+bJyGYdtrOt7UDYirLkW69GT2SAg
	XB6Ch6EqNzdT5hpiwVAGiCQgQ7GaP3aczvniUzG5sGEVtyCTsaVR8//OCEXs/lt2
	92Mz/Cq2/MWgz88mwtYVzA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4emab4kh1e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Jun 2026 01:39:10 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 6591caRg028091;
	Tue, 9 Jun 2026 01:39:09 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ema0pgern-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Jun 2026 01:39:09 +0000 (GMT)
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 6591d6An030153;
	Tue, 9 Jun 2026 01:39:08 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4ema0pgepy-6;
	Tue, 09 Jun 2026 01:39:08 +0000 (GMT)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: James.Bottomley@HansenPartnership.com,
        Daejun Park <daejun7.park@samsung.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, bvanassche@acm.org,
        avri.altman@wdc.com, ALIM AKHTAR <alim.akhtar@samsung.com>,
        adrian.hunter@intel.com, palash.kambar@oss.qualcomm.com,
        mani@kernel.org, shawn.lin@rock-chips.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: core: Skip link param validation when lanes_per_direction is unset
Date: Mon,  8 Jun 2026 21:38:59 -0400
Message-ID: <178094912077.1810714.4446574368379119411.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260520070009epcms2p6542f3abb7660839e9d8140b3f2f145c3@epcms2p6>
References: <CGME20260520070009epcms2p6542f3abb7660839e9d8140b3f2f145c3@epcms2p6> <20260520070009epcms2p6542f3abb7660839e9d8140b3f2f145c3@epcms2p6>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-08_06,2026-06-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 lowpriorityscore=0 spamscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999
 adultscore=0 suspectscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2605130000 definitions=main-2606090013
X-Authority-Analysis: v=2.4 cv=cL/QdFeN c=1 sm=1 tr=0 ts=6a276ebe b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=VwQbUJbxAAAA:8
 a=rZbgq3Wq37U6-5rKoXAA:9 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13723
X-Proofpoint-GUID: XSN9VLbUDn9Jsu3uctRxADEsjeAS6FVe
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA5MDAxMyBTYWx0ZWRfX2c+hHQM6Q+zW
 Wl9nZt3TLcfHC5Pj5eY7Z0HT0jBuO69K1mv22j0PjrflMioBwaHO3BFuteAMG9Qhb5pjTY/jRAp
 jikrvuUGt6pdeJ/fHrA3aTxvbScIpJhs64SwQ1aFduGRRpbVWCiHrImXXQYuTtwnFKlhvL79W1s
 NdX+W94cqpUVERlzjZzPiWAh0pQh1AhK69j3UAUFvvFynvQFeUJoqMPlh+y4lSncyjl4rcN9A3G
 Rv+Sz4/s7DDFIGFUx8kRiB1b+2TXiXlKO79DxMs/EBCNqqcBLYPkTYf0G9ti3G7j0UdsPq+SGSp
 A0a48MdSl95Nn3Pt3cczPURGnqWUzXtF7HROu5A2wZ43p9xyz+7MwHtT0A/IuQSgymIruUzixGI
 zxbv9E+BCAVWbvUzFtgRbmsrh1i3O+wH0gDQWVaAT+BDFVq+yMTJ2F2F/0KmRMziUJN9Lo9Bxfs
 uRzIdH0acjeiDtZKtasHJdDd1xy92hRaH505tusU=
X-Proofpoint-ORIG-GUID: XSN9VLbUDn9Jsu3uctRxADEsjeAS6FVe

On Wed, 20 May 2026 16:00:09 +0900, Daejun Park wrote:

> ufshcd_validate_link_params(), added by commit e72323f3b09f ("scsi: ufs:
> core: Configure only active lanes during link"), is called
> unconditionally from ufshcd_link_startup() and fails link startup with
> -ENOLINK when the connected lane count read from the device differs from
> hba->lanes_per_direction.
> 
> lanes_per_direction is only set by ufshcd-pltfrm (default 2, or the
> "lanes-per-direction" devicetree property); ufshcd-pci controllers
> (e.g. Intel) leave it 0. As the device always reports >= 1 connected
> lanes, the check can never match and link startup always fails.
> Reproduced with QEMU's UFS device.
> 
> [...]

Applied to 7.2/scsi-queue, thanks!

[1/1] scsi: ufs: core: Skip link param validation when lanes_per_direction is unset
      https://git.kernel.org/mkp/scsi/c/06a34d9c1f47

-- 
Martin K. Petersen
