Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AA1426980F
	for <linux-scsi@vger.kernel.org>; Thu, 13 Nov 2025 02:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763002054; cv=none; b=VLk5TVQjCZPyvCb+YNA1aXi2gUIpnr2WZvPOFNuYkrelkSLEh6HAe57w/qoZvnBieTPN2rDYI+1w3XcpwsxAbPv2CnYNxITOp3PeufdfFQSEPWKPhZ7RGuG1vyRyBm9MOxVIQ4O5rRYfy/+ZDoePjyEKm8TasdXXJ1R7+i7Sfck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763002054; c=relaxed/simple;
	bh=LiDiiPucLkd0HFck388iRYry1XmpObaX3xDKffqfob8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=POOxFCrAGrpDfQjpwouA+uIZieNSwqHgETRYZpz+Iv6IxiNx7yvJlCAF78bY2tm9wjVEh3rZpN4AVSO9AhH+FpnU9sBf0DzZLqhIC8KgiCy1KCqmiA9pxvq25I1t84Rv+ZTFyEpWT215TKYK+cm6K85OiB0SsuqkoPz8v4LLRyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=na33/uGt; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="na33/uGt"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AD1gH8S030748;
	Thu, 13 Nov 2025 02:47:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Mf4/7OhgiiwfDo6a+xou9wB6dzyUB3kBxXIZQGwW0Hw=; b=
	na33/uGt/NMQpbgvDx4FEpp5iywMfDAHpjKiz5i9l/ADGoB0O0X3ZocFB3Fqwyrf
	X9NHzS9pi9wMRbnmI0YS4JL997cRDxEUYh6JqGelE0o7k+bsC7lmCQ7bh+qM7hHk
	Y209BTirA9KD6K1avJkX+lDwoRoQnVPUnYP6yURKmmGp+yOAgwCuAx3YN1vDRbCV
	tCE1fh8OJRT9iw8T2JXKAHxHX1eEmXZHTgXaIH4tsB3q+ANLHruvLjlOO2JBJaTX
	jBX6H+tdxBxMGi4+PggupX6PtcBFmK0ksJGHHkjNOtbdy74+0KSbULqNnH9rVW/N
	/DFU5zRGs/PuRdT1oF9/Eg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4acyra8qd0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Nov 2025 02:47:13 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AD0xvUd032539;
	Thu, 13 Nov 2025 02:47:12 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a9van9qb6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Nov 2025 02:47:12 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5AD2lB8F038323;
	Thu, 13 Nov 2025 02:47:11 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4a9van9qab-2;
	Thu, 13 Nov 2025 02:47:11 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: scott.teel@microchip.com, scott.benesh@microchip.com,
        gerry.morong@microchip.com, mahesh.rajashekhara@microchip.com,
        mike.mcgowen@microchip.com, murthy.bhat@microchip.com,
        kumar.meiyappan@microchip.com, jeremy.reeves@microchip.com,
        david.strahan@microchip.com, hch@infradead.org,
        James.Bottomley@HansenPartnership.com, joseph.szczypek@hpe.com,
        POSWALD@suse.com, cameron.cumberland@suse.com,
        Yi Zhang <yi.zhang@redhat.com>, Don Brace <don.brace@microchip.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/4] smartpqi updates
Date: Wed, 12 Nov 2025 21:46:51 -0500
Message-ID: <176298170740.2933492.9462390548558021526.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251106163823.786828-1-don.brace@microchip.com>
References: <20251106163823.786828-1-don.brace@microchip.com>
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
 definitions=2025-11-12_06,2025-11-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 mlxscore=0
 phishscore=0 mlxlogscore=669 spamscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511130017
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEyMDE1MSBTYWx0ZWRfX6tOVckV7X5RI
 BCx7LCOhxLPN3PaUC4zfqUOqbHB/MQ4OZXKQhztOETYvvJW7G090pDquFqL3XfPXCODx8s2to2L
 /rALX+Kq8GQP3hPAhkt/Kaj/VrZ26zUzoNA+8uvmoovgOzQg+fP3K7UBYPlmqRfx8peNG4N8qbG
 vvp/Cx5lBFUymJoQYJFSaKnAtLEpbGiDgrncwJZUuYldVUAdOX2H5ApI3uKat8AaQQbg8/J9kJl
 HMjKUvgIFnlVVAud4wN7s+dYaRl4Nfqs7NfFMmkR26klx9D8EWNJGWl9EJgHrRRwZ7ustAPwI0b
 mej69M+ha7x4+66a7Mau1+G6fAnwp5mgZK9yF1Tpx9xP3V43UXDKBd7Pupm1Isd1LM/kI/cmz+C
 +hpPI2WgaimhIGdB13fhZ7bZx+sYsNh3Kqe7jSCLWT5lPmJ6lpQ=
X-Proofpoint-GUID: ImBfTmD2VS9wej9CQ0WRgH9W-PDk3Onr
X-Authority-Analysis: v=2.4 cv=ILgPywvG c=1 sm=1 tr=0 ts=691546b1 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=3QXT9x4IoNQorpoaaoYA:9 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:12100
X-Proofpoint-ORIG-GUID: ImBfTmD2VS9wej9CQ0WRgH9W-PDk3Onr

On Thu, 06 Nov 2025 10:38:18 -0600, Don Brace wrote:

> These patches are based on Martin Petersen's 6.19/scsi-queue tree
>   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git
>   6.19/scsi-queue
> 
> This patch series includes four patches, with two main functional changes:
> 
> 1. smartpqi-Add-timeout-value-to-RAID-path-requests-to-physical-devices
> 
> [...]

Applied to 6.19/scsi-queue, thanks!

[1/4] smartpqi: Add timeout value to RAID path requests to physical devices
      https://git.kernel.org/mkp/scsi/c/f3ecbba1aa71
[2/4] smartpqi: Fix device resources accessed after device removal
      https://git.kernel.org/mkp/scsi/c/b518e86d1a70
[3/4] smartpqi: add support for Hurray Data new controller PCI device
      https://git.kernel.org/mkp/scsi/c/48e6b7e70802
[4/4] smartpqi: update version to 2.1.36-026
      https://git.kernel.org/mkp/scsi/c/4cec99e83d92

-- 
Martin K. Petersen
