Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 542CF2D7DD5
	for <linux-scsi@vger.kernel.org>; Sat, 17 Jan 2026 04:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768624624; cv=none; b=J3lMvxY+C3NRAsvxFa743C/apGvzcXpsFyjob1aCSdxHlg/4vrbZKTdyYadrjrmFGrEKwg0D2bqU8dSFjweVEWiXAruVtCryRbvNuGL3zVLyJS9nPLLCx10dBPhV0Gzv6WsUacAQo946es6OixjrFpQcKxGNNE9xiLKV9qZl6v8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768624624; c=relaxed/simple;
	bh=nBtCO0wHMON1fB2Nu4e6Y0dRpQ1Sz8BDshbZ4icE32I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IxhSgzECvGArhe9blQC0ao+glulwJx57UgdF3W9ZVf2q8rBLzaDAdIRdofwPC3aukM8Lb04vbmiXpUHguQegVWKj6+5qQ3qbH1cvRy/7tEwP7tQj/0oOGQd1LDp4waZK+A69fcyuTYgxvcST95+HGthEzjpb0ztXlhZnCcEAjGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=sX66iqE4; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sX66iqE4"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60H3vSBd054504;
	Sat, 17 Jan 2026 04:36:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=RBY9+ibRpaGmQD9A8N06oJrP7+cYkun9NtOFnxRdnIc=; b=
	sX66iqE4phhog5JEG9GwJDww+/g5p09lXFEeJIQqSy4VoFeZGurwvbJSVArKMaGb
	D7ybh2DiggMIXkqUR+VNOek8WjJda78nBX13Cd/qkodt7PJKUS+OjUovwOppzIyV
	dAzj2+ouDwlqCGF62xZBni3GHRkuaIkCSUNUnwnIafLX0sUEF1oYD8YVWku3Am7S
	JPs/3BsETe9gwvV2dyTzvcFw4A/2yrE+jRMs4RsngqcjaWxPmYQxh4JkgbCu4MwG
	dkxMUiTMAguFjQnk5DhU7gmb11QYfWQSpcATzqcZzuURjEfpxrhYufLZQts8K5cW
	72mBdCfsSDtSKajmyYY5sw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br2ypr0jv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 17 Jan 2026 04:36:58 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60H1Xjfd008388;
	Sat, 17 Jan 2026 04:36:58 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4br0v6bk5p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 17 Jan 2026 04:36:58 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 60H4at7N005851;
	Sat, 17 Jan 2026 04:36:57 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4br0v6bk4d-4;
	Sat, 17 Jan 2026 04:36:57 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: Re: [PATCH v2 0/2] Call scsi_host_busy() after the SCSI host has been added
Date: Fri, 16 Jan 2026 23:36:48 -0500
Message-ID: <176862009003.2331811.10608158577144065221.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260109205104.496478-1-bvanassche@acm.org>
References: <20260109205104.496478-1-bvanassche@acm.org>
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
 definitions=2026-01-16_09,2026-01-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 malwarescore=0 bulkscore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601170034
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE3MDAzNSBTYWx0ZWRfX/DVDHfzgfinS
 m5WFag8Co7MacrlFimtNdqA+EGElELr/XrubkB4rFKayOslnCG0O2LvHncewKYXHu83Be/g6cQm
 W4IqsapsSe6wF3OeILv23TPq/H4nl19J4yH/7TPqHj41Wz/W+I10MMudqG/GZzEyzE9bPB4g8f4
 g3yYtEoveJhHjtcYWZw0PtMEylz2+iWmin0S9cM9UnHnYZPcasrsZ9CPMDAGs8UdR+HWX6LHVB+
 K88O82gluW/qFWanKb2DnWg2MDLRxUYxshTK9wXzlyu2iwgqQeEUQztJGUPU/Q2IjP9dHDPVxmp
 Txh+vhk3m1zY+UedvmpMjLDU8PZIf6c34jPd9c45J/RGrY6Qu6yhExG3Y/d4GDgOYxR3C+j5E7y
 KzEtJU4phfrSFGUGonTG0JrJxqZ+w5yK4cfCiSioE50bR+EhetmBMQHxhjpxCfrAmPX4xrSannw
 weUYoYGxPPdGMBfE+zw==
X-Authority-Analysis: v=2.4 cv=de6NHHXe c=1 sm=1 tr=0 ts=696b11ea cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=r9O8fT0MRkxUWqyD1qoA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: Vcli6JDilUxUxLSRp8KE2XT-5SRBsAVM
X-Proofpoint-GUID: Vcli6JDilUxUxLSRp8KE2XT-5SRBsAVM

On Fri, 09 Jan 2026 12:51:00 -0800, Bart Van Assche wrote:

> The UFS driver is the only SCSI driver I know of that may call
> scsi_host_busy() before the SCSI host has been added. This patch series
> modifies the UFS driver such that scsi_host_busy() is only called after the
> SCSI host has been added. Additionally, commit a0b7780602b1 ("scsi: core:
> Fix a regression triggered by scsi_host_busy()") is reverted because all
> scsi_host_busy() calls now happen after the corresponding SCSI host has
> been added.
> 
> [...]

Applied to 6.20/scsi-queue, thanks!

[1/2] ufs: core: Only call scsi_host_busy() after the SCSI host has been added
      https://git.kernel.org/mkp/scsi/c/202d5dadd3a0
[2/2] scsi: core: Revert "Fix a regression triggered by scsi_host_busy()"
      https://git.kernel.org/mkp/scsi/c/e60b57972099

-- 
Martin K. Petersen
