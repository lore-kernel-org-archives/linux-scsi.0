Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5F6672634
	for <linux-scsi@vger.kernel.org>; Wed, 17 Dec 2025 03:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765942826; cv=none; b=ohnUTl9Z8QGDeGYpTWuPFtvPfNthdP1nwn7GuUkBCGYcWFXu3H0HQOwKewMSqQGT1UfizmBZxi7iUFtxpxqWjFrDdQBGU+LbYUniHDtDHNcbyKZryOXhwKDzN3cPsNUWefnr/4m9bpj1KpqldHQXgPtEVVrVV6LtTlGQYf/PMvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765942826; c=relaxed/simple;
	bh=wtDITyWSBBMrzolBNPMifOeTlhNSHhTVFwt2W5oE1Zg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TOKAv/tthz705xUCuU/fQAA4JGbWZdVGD8uVaQ4TyDMOv8lzUUiSCkY+ofXdDCaM+PCyoissg1a6Xy/wtexiJVlssGTxox7UrK3M0+FR7RUqzEHLfyC0GSjJaTu/T9NzOGmDSoIS/OlrPCoI6DjGaCbO4liglRR76d4cDQq8BRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=TreY+Xw7; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TreY+Xw7"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BH0uTF91485465;
	Wed, 17 Dec 2025 03:40:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=5d4eUeItrVxb5iiEz2IRpLpSIDmc0b6CAukgBzqqAxY=; b=
	TreY+Xw7H+fCDOmQBApMv3PBbzZS1khmuFRuQgZJ4ly1WChX1SfZH2SA7p40Qa4x
	LLlGcNhCYaGyVqmKJAkNG5YPayk00F9hJL1WqM6KDme9emxL9FQMwrCx7gwe8ei/
	AkTG5Cl/3+gD85K0L9IUqpIhQQH/E27a5sGbAXUWqEi5CqBX6m+FU/p7TaaT2wpQ
	jE11XSAdyW2kGla2aIX3G8PpAeFUrjfx7uoTinnrQDUWCO6XrqsGXiiOFHTrczWL
	XWRsp2i5ToPtcKmtgFdSb55AvKUyeMsGkdM+UDycNyI6HysOnvs2Wruqrgj3olxe
	evdue71CFT/mQ27LQg4JVw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b0xqxw8ey-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Dec 2025 03:40:23 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BH1JD59025254;
	Wed, 17 Dec 2025 03:40:22 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4b0xkb9aee-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Dec 2025 03:40:22 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5BH3eLwZ023311;
	Wed, 17 Dec 2025 03:40:22 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4b0xkb9adw-2;
	Wed, 17 Dec 2025 03:40:21 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: james.bottomley@hansenpartnership.com,
        John Garry <john.g.garry@oracle.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: scsi_debug: Fix atomic write enable module param description
Date: Tue, 16 Dec 2025 22:40:15 -0500
Message-ID: <176594264278.1094313.16574890934864877697.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251211100651.9056-1-john.g.garry@oracle.com>
References: <20251211100651.9056-1-john.g.garry@oracle.com>
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=891 spamscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 mlxscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512170027
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE3MDAyNyBTYWx0ZWRfX7HO1yBKe29RE
 jgjttTncHbIi/TSzO9KYGRHtopsVjjbTqA2FblEoSupE4FeYUuTtb2Wykkj7jKNqfhSMOYls4AK
 P1dvoQ//HLrUrZCXyyIbw7GaoTqukSQ7p2XKbuCMKwrfqrOMI0cWFfhsXjP45OmApWZ78mPay45
 0lziNTHoeOhFqK6FvKWFfLuMqJ1VqVM2/sxXuRV4inHC5JGCqDRFQuyInTYy+qbudRkENcUy3rj
 +whsTwc7EKD9uXv8J3g7wynFohz3JMNbE8+YRZ+MRUDZGFwWU+8DvpMcwKza7QD/kTvOpicsUwH
 hMZfwSMSUOX/oxuaDCkE7+xxShITEyO2YqArozkIQU/eZNFPJXtYu4Z59pQeBSNGd7qD2pi/17t
 UEv4daTqCFjQPvhQ7/k0cJt/nnQllg==
X-Proofpoint-GUID: evztqtwsgKHIDKhAQ24CKh3R3IXUbJKF
X-Proofpoint-ORIG-GUID: evztqtwsgKHIDKhAQ24CKh3R3IXUbJKF
X-Authority-Analysis: v=2.4 cv=BYDVE7t2 c=1 sm=1 tr=0 ts=69422627 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=RhJH6FJfGRe2PmfqtQcA:9 a=QEXdDO2ut3YA:10

On Thu, 11 Dec 2025 10:06:51 +0000, John Garry wrote:

> The atomic write enable module param is "atomic_wr", and not
> "atomic_write", so fix the module param description.
> 
> 

Applied to 6.19/scsi-fixes, thanks!

[1/1] scsi: scsi_debug: Fix atomic write enable module param description
      https://git.kernel.org/mkp/scsi/c/1f7d6e2efeed

-- 
Martin K. Petersen
