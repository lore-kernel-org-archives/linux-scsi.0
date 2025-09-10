Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E494425C802;
	Wed, 10 Sep 2025 03:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757473494; cv=none; b=eT1gcSwI+15kJxGjyZk6bYNLwVhKCxDYDRx5gDJGK6iipw443ldXn2W9ZQEE4OvY0n4aZKCgTie1E023c3eKMY7Rbn5bDEihSnLv27KtPjpIo4ZoSvluHoVRh0oy/rqo1/h7W6CzaakAD0yyrkeRushkpKO48ZpRzDcvyxiUf+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757473494; c=relaxed/simple;
	bh=avckK7QbrBg259+qP8RuI0GzFlEGGI8GalYtqJU7mGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oQ+QceTY342VkM4OAzzIEG/EIoZOIN1BtESRJu7AzP8kXzH70FoKWv2ijyhpzGM+8NsfReffe6vkk0UZJPeurZwWJRPMSGJhXPpAoflRuvlr9F9hJzdZqgQToYh5jyz+V/lyfij71folJYb4VRFq0+/+aqncKklTI+ZfZ0aKQx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=hBvSzYww; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hBvSzYww"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 589L0fMn002219;
	Wed, 10 Sep 2025 03:04:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=BCJLMNYqaYsPwnOoqY835FZ5FeeUolOfcSlAqBBckLA=; b=
	hBvSzYwwwmRlN9zyUmoyqMaWogOcteLhJA6pBPlSIZWnq3rd4cZEJdjlK9L22rXn
	PNv06Jzvk+b9BlfV43jqWjTsIL/cbYQENMi7YUBfHYQm02vk91H6mnsP6bBQeqcR
	8nPI0AN31HHAFSp+/CxqyW0v2c5mIGzsn2GoJJK5RccaB1qmqicsgh2b9trfZ1L2
	1UxeC3dAMfVXmWUSwfnNASVavBMXeuna/SRUreZyubigudbVw54OdZdQmqneVcxj
	h/Jxuwc9Hw3XepaURflOpvST0vSTiu2patBE8TeHvjqxiqMFwmBc7QdgbM/68fIo
	Y5OmZxg45K0MMzi+lj4Jkw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49226su6jk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Sep 2025 03:04:47 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58A12Uol030711;
	Wed, 10 Sep 2025 03:04:46 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 490bdadcw6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Sep 2025 03:04:46 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 58A34g5c011326;
	Wed, 10 Sep 2025 03:04:46 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 490bdadcur-5;
	Wed, 10 Sep 2025 03:04:46 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Thorsten Blum <thorsten.blum@linux.dev>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] scsi: qla2xxx: Use secs_to_jiffies() instead of msecs_to_jiffies()
Date: Tue,  9 Sep 2025 23:04:37 -0400
Message-ID: <175746865978.2804493.17708026741244716029.b4-ty@oracle.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250828161153.3676-2-thorsten.blum@linux.dev>
References: <20250828161153.3676-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-09_03,2025-09-08_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=708 adultscore=0
 suspectscore=0 spamscore=0 phishscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509100024
X-Authority-Analysis: v=2.4 cv=QeRmvtbv c=1 sm=1 tr=0 ts=68c0eacf cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=VwQbUJbxAAAA:8 a=jrhKfrNR-P2al2X6LikA:9
 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10
X-Proofpoint-ORIG-GUID: z0swmYp5BIqBiRc9Xe9QEbR8xwUlOzrO
X-Proofpoint-GUID: z0swmYp5BIqBiRc9Xe9QEbR8xwUlOzrO
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE1OCBTYWx0ZWRfX56u9YbG/c4Me
 R8SdKf6oiQ85ESWbjCvP98BEk6/Y0rW01uxe6u00lksiKDGox3Mvt6/NY+4sUnfR/hEffTsGOxg
 1w1hYMT4r/QZYckfAYfIpkstDoES28YSPsx6EPtRmo9aRQHKLWSnAw3Aic4VET2ENXku61omZKc
 prGQw+8b6DrRt6SQjrucM++SWAQtk2RsJTu5oDsyqrcoKs2jXbuTkyAOOuRXBC1eUTQSPbju8Bc
 FeWKMWOAUBTWGBD1DvaaILBKJJVo5kVboI8bClZUPIZL1UQcgLQ+CPbnSxVZ3SbhiVe4BwESbPm
 YSBoWgetksnv4OiNZWodGjhEcpSzCoPKZbb3Are87ieqryfTGhMibgjYpvIT87M3nfy/hzDlA3U
 Y94bWdZH

On Thu, 28 Aug 2025 18:11:53 +0200, Thorsten Blum wrote:

> Use secs_to_jiffies() instead of msecs_to_jiffies() and avoid scaling
> 'ratov_j' to milliseconds.
> 
> No functional changes intended.
> 
> 

Applied to 6.18/scsi-queue, thanks!

[1/1] scsi: qla2xxx: Use secs_to_jiffies() instead of msecs_to_jiffies()
      https://git.kernel.org/mkp/scsi/c/e02436d37a47

-- 
Martin K. Petersen
