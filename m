Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AEA533D6E1
	for <linux-scsi@vger.kernel.org>; Tue,  2 Jun 2026 02:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780366268; cv=none; b=RVBCIRl1T0J+CRD9GR/hmgBh2E6UxqHTnA1+HZSAPPC3TvJzzvu+ATaNvWvnHoAv5udSizl4ghMmfGzpx5vdbDEQ0vlmH7xekG+29cWLBGaOqxDY2XSUnB70YcxCOkhdxlZ76Xmg/Ijz3QYHm0+jU3UARTtExuLVyWXBp2QWM/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780366268; c=relaxed/simple;
	bh=37qn02jwmdAG+qLl27YLEEH6ojYso1jQg2gZcwUmCZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jb466yaow9KBzivHYBmqSHjnBMhUB1CDW+YKTTvolLsLiKWvH89NMawB4DGlFsfI5z7N2sLS4mrI+zokUb0MS3bmAON2S/NnhCsc8L/QR/SHHU+R29ZCPa+iMElJQr8yHvRdoIkT1JvTra7dfOjzWBuIQyPaQAwMn1UPK9fa5TA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=d6d/9n0N; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="d6d/9n0N"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 651Gu03w665483;
	Tue, 2 Jun 2026 02:10:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=j6XCptdoPSWdgOw4nt3VSUJlidQw8DCM8FkQxHMyJrA=; b=
	d6d/9n0NK8VrBeisr2pHpKoK4jnyvC6iNCT+GFvK78wmhNx6jwCgZ9Pr2+ELFBVr
	uOZgffvw+gZ2LfaJdDgRcoT6z0d8rp4FTEWV3gHwNqjQIFAlDkXyUJ/iz064jISt
	8anIjc6lr7NwkMlNYNJcFxRMY9bduUddMskvP3nMcg9tK4b7G8G4aKvK66mgcFI2
	KMgyLHac8Njf2YiwFr0OXU+iubTwvelt7RdquXvZgSse1xUEJLhWUgStgyuNklUv
	ms5JiK3FXseUkfCUw9nQs/xV8yAM+whLamgCWAQmZ3kzpoGhMCymBq9NzylDrLUb
	hgWBuclXN9bEcsex+0UNdg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4efpaau8d2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Jun 2026 02:10:56 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 6522A3fO020079;
	Tue, 2 Jun 2026 02:10:55 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4efpbc2wxc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Jun 2026 02:10:55 +0000 (GMT)
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 6522ArC6023303;
	Tue, 2 Jun 2026 02:10:54 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4efpbc2ww0-2;
	Tue, 02 Jun 2026 02:10:54 +0000 (GMT)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Brian Bunker <brian@purestorage.com>,
        Damien Le Moal <dlemoal@kernel.org>, Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 0/3] Rework the struct scsi_device inquiry information
Date: Mon,  1 Jun 2026 22:10:43 -0400
Message-ID: <178036282204.1628204.12107591851419360970.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260515205222.1754621-1-bvanassche@acm.org>
References: <20260515205222.1754621-1-bvanassche@acm.org>
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
 definitions=2026-06-01_07,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 malwarescore=0 spamscore=0 bulkscore=0 mlxscore=0 suspectscore=0
 lowpriorityscore=0 adultscore=0 mlxlogscore=883 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2605130000 definitions=main-2606020018
X-Authority-Analysis: v=2.4 cv=T/S8ifKQ c=1 sm=1 tr=0 ts=6a1e3bb0 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=VwQbUJbxAAAA:8
 a=mnHA3GFP-1D7FZRJf4IA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: Eu7ApR1ILNzhlXi8nuzJ94kUMbZB4W1N
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAyMDAxOCBTYWx0ZWRfXxxqMHgNGARrJ
 YOGIOyXzkCUvUCM9qcxVumAs+maJ9h3gVFP62C9VU+2XE6ABOT3pCUYHFLWynIgJz6HkAQHx1G5
 M3oIcPHO3xe1t2NjGyUNuBPhxl57xu5OzJbw+gR9gmRAmxRKs/tjoj4lZxhYK/BsBQuTKWV6ZQ4
 9bUrApj7c9xkbkEM0OF8Xeg2D/gV96AFAgCuOiOA51yVa007OfMccLcZRGvmSK19F0E8+gDUG5R
 3/ffPwayqY7HQzIjGGgPKcEMXmhQdvSNWlcrQzqgiFveKPVkQmvZZ2Mm3T82+Fcc4q1wgJt0zLs
 NcS7Kx/kuoGw6O+Y271rHHlL8UiBqYWAZmbEY/Z2jehzY0tZ4ydG5Y80qPlXOgkS+IHvNvD4Job
 xbiK5IykasB9LxxjUQqWB4zri2FjNYUtUf+oikzY7CHs0/X25TYa2UxMPLOZkcsyatvcz6bQyhY
 1/bGhpU5v0XZKmECMmQ==
X-Proofpoint-GUID: Eu7ApR1ILNzhlXi8nuzJ94kUMbZB4W1N

On Fri, 15 May 2026 13:52:18 -0700, Bart Van Assche wrote:

> The vendor, model and rev members in struct scsi_device are fixed-length
> strings that are not NUL-terminated. This patch converts these members into
> NUL-terminated character arrays. This makes it less error-prone to deal with
> these structure members. The patches in this series have been implemented such
> that the number of lines changed and the risk for regressions is minimized.
> 
> Please consider this patch series for the next merge window.
> 
> [...]

Applied to 7.2/scsi-queue, thanks!

[1/3] scsi: core, target: Add INQUIRY-related constants into <scsi/scsi_common.h>
      https://git.kernel.org/mkp/scsi/c/b1968f46509e
[2/3] scsi: core: Use the INQUIRY-related constants
      https://git.kernel.org/mkp/scsi/c/28ff38b9d8e1
[3/3] scsi: core: Convert INQUIRY information
      https://git.kernel.org/mkp/scsi/c/20fd1648f353

-- 
Martin K. Petersen
