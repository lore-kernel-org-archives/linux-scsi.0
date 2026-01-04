Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5808311C2D
	for <linux-scsi@vger.kernel.org>; Sun,  4 Jan 2026 21:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767563024; cv=none; b=nzvvdVabIlNLEBAtT5eQ2FMkV3uOgAtN9ZVv7zaiypNvPxbGkMmchMPOzGHW+Y9l99zdOa7XMvOW7vV3BhvUSbC1k7cweeok7DJEocjmnkYrCjXcoRnx78JbOSJ85x2D7qiXNEz8qR8ObCVxqudptVroEgHlpYht3yKdHkqS174=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767563024; c=relaxed/simple;
	bh=J1vHL3GMZ0H28fHjnV/6kNJLkO4G1nZ0n7uahk7h+eY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J9dtdinHz4rpWjq9Zi2w9Eqfrq/e34unT/GIHXusbkdT5iH30sH2/Y3rNtX9IfX8tyawYltY1WojpZNn6MrZfSk236kwyNc4FHz9LcbIov9pskg96Sn1DTrnYJo9mljOUQlGHc8xW7V4H2KTTAuX/LLvW13qfO6cfhGSUb6J5oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=OI0AijXB; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OI0AijXB"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 604LfFY24169403;
	Sun, 4 Jan 2026 21:43:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=XhjhgH9KCR3HBUEzSEpfVRfJjtzA7ytXaf2FqGtSJtM=; b=
	OI0AijXBLDI0xDcjAlkdM50cCgcLLF2r5vc8vNiAhCRUXdqPrCw540PlfcEj4I0S
	Ll5XowB0e3mc2D37KkMf/BCavA56nXMnnPEAExJNS1OsdR3WNReLVzpKswBtIF85
	03lzLsxHdMGuNa62X6ykGeREIySDiuZPiJXoo/E/RWRz8Lzy80qOjyjMkbX0i/PH
	WVGne0gWgbZHNDqU9Me+/z5uFtlNJd6Ezm81O0S3fZZawb3WNHsPB1oqa4H67dGL
	LGhYZVwfgiUctpdDP916zxtj5tGVzFIdDyw5ed/CQdomt1/u3ccHvwfCoBnpOrPz
	On66Kh8ZAINvtLXOxY61sQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bev37ry2s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 04 Jan 2026 21:43:28 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 604GpC95026584;
	Sun, 4 Jan 2026 21:43:27 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4besj6gbgu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 04 Jan 2026 21:43:27 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 604LhPoR007658;
	Sun, 4 Jan 2026 21:43:27 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4besj6gbf9-3;
	Sun, 04 Jan 2026 21:43:27 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: james.bottomley@hansenpartnership.com,
        John Garry <john.g.garry@oracle.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, bvanassche@acm.org,
        jiangjianjun3@huawei.com
Subject: Re: (subset) [PATCH RFT 0/6] scsi_debug: fake timeout handling improvements
Date: Sun,  4 Jan 2026 16:43:09 -0500
Message-ID: <176755562236.1327406.10190325570900510454.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251113133645.2898748-1-john.g.garry@oracle.com>
References: <20251113133645.2898748-1-john.g.garry@oracle.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA0MDIwMCBTYWx0ZWRfX/Cqof9d438p7
 0lAV1VnDMvB9ur4BvoomLmLACIRrt5P2/53/Lo6Ju0SoOurlYoXoAGNpY8BZ1HcBzq88S/mA5ob
 hF4un6cdy8Wi+X7ns3MMTsGrxv6bzig90YPlgpGhUnrSM/ogTYlUlIuHbS6KpWWINInuXvt6Wa3
 9WjL0p9K9vd7avmdXoPTGRtu0H7ObSbX9Ki1ggVruoQm8Ohji6lGvL6UyoLXJkpOHUZGjtsAXYr
 JmAvoKYN3XvJL/0ZFaud/QJmR2KIAp17EljO/trowN7If5WwAXtFKmbQEkvpYviZZ6f9Gdmr+al
 SxJnYTmz4fZa62zWpwt16I9Y8EB0YjJhicDMg5razinc6LmyU45G4HqkB+c14fxDlzsYfVzTJyz
 1uGuyhIPhM9jQKDpwXr4Z92Eipvb6QuP7TuxN4ORNhOYiOg7YuJgAkb/CA+sSP9aVkCg6VVHxo/
 qo/kHq2y6e2sDZdnlTg==
X-Proofpoint-GUID: hYjemg08YiCA51KeTY7MfND6gyag12BA
X-Proofpoint-ORIG-GUID: hYjemg08YiCA51KeTY7MfND6gyag12BA
X-Authority-Analysis: v=2.4 cv=F89at6hN c=1 sm=1 tr=0 ts=695adf00 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=pG3nVdeydXxWVyOxUwgA:9 a=QEXdDO2ut3YA:10

On Thu, 13 Nov 2025 13:36:39 +0000, John Garry wrote:

> This series includes improvements to fake timeout handling.
> 
> Specifically, when we try to abort a scsi_cmnd which has fake timeout,
> we check the deferral type, but this would not be set properly. In
> addition, we need special handling for fake timeout in the abort handler
> to ensure that we don't get confused with any other deferral type.
> 
> [...]

Applied to 6.20/scsi-queue, thanks!

[1/6] scsi: scsi_debug: Stop printing extra function name in debug logs
      https://git.kernel.org/mkp/scsi/c/a743b120227a
[2/6] scsi: scsi_debug: Stop using READ/WRITE_ONCE() when accessing sdebug_defer.defer_t
      https://git.kernel.org/mkp/scsi/c/559ae7a26b10
[3/6] scsi: scsi_debug: Drop NULL scsi_cmnd check in sdebug_q_cmd_complete()
      https://git.kernel.org/mkp/scsi/c/a8cf5c1bee0f

-- 
Martin K. Petersen
