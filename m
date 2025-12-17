Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A117A2D0635
	for <linux-scsi@vger.kernel.org>; Wed, 17 Dec 2025 03:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765942831; cv=none; b=nvgxgM6hczeZI07dwNP/3cl7CufLStP2nYwLqxEd6RyJjewDFglfPZ0Or3SSyj24X0l6JFsiliJfOCdWs1KIXql36V2KH4b/wxTDG0db9XTcHh89JMSTH3SL/BEgrvQDoFNm7Iq70G4QSrYjtc6oAblRdoepM8kL/0PVqt5Do7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765942831; c=relaxed/simple;
	bh=IpgSrO7Yyu6uMNiBVrtGoq5r/NA0vc6Zd2sD1MfzgU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Rti2RwH3/FvWtssDSPnt0iVeWsfoR6xkMWbNyevn+7Iy8zBpz67WcB+vOBJzfRwsIVEc+IcjZFBltTQ2cSWn2R8BQ7OkqrxBgBewD90pw50OOCS3Tp2LCTkmtNx6wimV++PyqorCvSLeVmeLVbsLWXSbfQIihyiKW8e8YjephgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=fjQx9A4H; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fjQx9A4H"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BH0ufWk1620731;
	Wed, 17 Dec 2025 03:40:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Fi/V+x6r+p+7SoW1JSoyJRIhstN98GPP9QOVtT2aTOs=; b=
	fjQx9A4HElzHm6+VQBzEGoakLnLaVM8sAQ6HuhF0oD9LUeNZgjKDRafvvzh9MpI/
	XvaLjKvl6zXlgtXgodBgqyDFHRneN9rKSgu0kC+F/sqKR2ksq0MfC7wZUvRXfGJQ
	dFrZdTk6Bi85fwVNxUVtaYg0mdsMvioLA/yE7PjD2gDOcSYDnLxf3TSom3H4hSHe
	q0DUhs5nFL7K0cgmUeXjYzRQ3b2YUZfzYadnI05i0bDMtVH4X9wC5gpXzGYmdZMe
	+D32scWE6paDmj6DV/9wk0fPH7tRtvCRyzn7/nYf6K3LpuVvfAddjQIALaxPgmtw
	jdi0F3lEtLBQ6CdpcurXTA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b0y28d7av-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Dec 2025 03:40:25 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BH1lMCY025805;
	Wed, 17 Dec 2025 03:40:23 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4b0xkb9aeu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Dec 2025 03:40:23 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5BH3eLwb023311;
	Wed, 17 Dec 2025 03:40:23 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4b0xkb9adw-3;
	Wed, 17 Dec 2025 03:40:22 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, dgilbert@interlog.com,
        =?UTF-8?q?Michal=20R=C3=A1bek?= <mrabek@redhat.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Tomas Henzl <thenzl@redhat.com>, Changhui Zhong <czhong@redhat.com>,
        "Ewan D. Milne" <emilne@redhat.com>,
        John Meneghini <jmeneghi@redhat.com>
Subject: Re: [PATCH] scsi: sg: fix occasional bogus elapsed time that exceeds timeout
Date: Tue, 16 Dec 2025 22:40:16 -0500
Message-ID: <176594264287.1094313.7462236468036605377.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251212160900.64924-1-mrabek@redhat.com>
References: <20251212160900.64924-1-mrabek@redhat.com>
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=760 spamscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 mlxscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512170027
X-Proofpoint-GUID: JaispR-pdn3WPWislTVCdrhVW9FhtvrS
X-Proofpoint-ORIG-GUID: JaispR-pdn3WPWislTVCdrhVW9FhtvrS
X-Authority-Analysis: v=2.4 cv=fOQ0HJae c=1 sm=1 tr=0 ts=69422629 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=Dh7WSLOB7z5fWyzqBrQA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE3MDAyNyBTYWx0ZWRfX5KAyH6ysQjZ4
 Za0o3qxBpbH1/H3K5BhD14Smz/twwkKTiP8D6yNHpd+zJIfI4p0rBJdoIDLfpMVnQVg4SX95Vmy
 S0+Ti/QxzxrIcQZtK/1rHXHs8uMoxrVnlsPiQNwQIf6Ihf2ub07dCfzwgXKLmqrAKfEMkKPJaTb
 20I6w13gOko7lHagDSIiYhZ27OA8hvedHAgfkfoLe+cDRAyUQyyhjoLnbic6PwJ+g7ZRHNNaB+q
 wHzHlyoxivGMVoMhR7hdOiJscgEpiZ663tCum0qzkjglkceZysQx/1yDMtelQvGi6gRMUSnJRTs
 BF+GpeRDUENepvaBeDL2hEmBepNZIAicWZCDCVf0B/bDFUBW49712OkB6ow7uTK7mNaDC/P+ygl
 NRWwXVuMfTMQFQgAp4zmDY+1S7uDgg==

On Fri, 12 Dec 2025 17:08:23 +0100, Michal Rábek wrote:

> A race condition was found in sg_proc_debug_helper(). It was observed on
> a system using an IBM LTO-9 SAS Tape Drive (ULTRIUM-TD9) and monitoring
> /proc/scsi/sg/debug every second. A very large elapsed time would
> sometimes appear. This is caused by two race conditions.
> 
> We reproduced the issue with an IBM ULTRIUM-HH9 tape drive on an x86_64
> architecture. A patched kernel was built, and the race condition could
> not be observed anymore after the application of this patch. A reproducer
> C program utilising the scsi_debug module was also built by
> Changhui Zhong and can be viewed here:
> 
> [...]

Applied to 6.19/scsi-fixes, thanks!

[1/1] scsi: sg: fix occasional bogus elapsed time that exceeds timeout
      https://git.kernel.org/mkp/scsi/c/0e1677654259

-- 
Martin K. Petersen
