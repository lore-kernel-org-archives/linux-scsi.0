Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52ABE2E2665;
	Sat, 23 May 2026 03:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779506128; cv=none; b=NRUAQ2p2tuqu60EH+a3Urpy+Z4zuyN5dW6hkXe+NEWHtO3SDBtRcJIbYyGoMcuzWzXoRZQkqgzyPMJ4QZlKbsTyZtvVFJpLhA495ZaDefNFA6oQO+89DcasV4sVv/OYzj/J4/Qc5WdmPX3RbOTcultO1xBxTlICQQpLg3Up6bSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779506128; c=relaxed/simple;
	bh=e47Korvi+VbRkfxGGIqBWxvLb23UV8sxmAh9Ny30oMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m0mQhVX4e/4TK0m8kBsYegl+FqLCvwz2olaHSdcXXeZlEbm24RJGwElcedwOzlT9XfEHCWNmob0UUWsQSb+xLd3ZkpOKmyGP2cI7ZtNccBoOSJnos1SmlPI79av+vXtj/6EnYzXHN9GdBIeEI56qFPZNXLEANchfJ/nUA+ou3uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=K83GpPwZ; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="K83GpPwZ"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64N2tTpS2818812;
	Sat, 23 May 2026 03:15:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=W2saHMTltBNVftROKzQgkXbdoWtU97jgw8jW88M5T6E=; b=
	K83GpPwZaBsq/voTjGx3msPCP4Cxny91jQ3Mk+j5d1oBsoJjmSj5LAqVbaDzw3nq
	NpnSsIo+X8UD/UpNqGFK4wL6Btk5GpDLVP1Xzjbk+UkZReeCw/xvkWOoMmF/9+sp
	40h8UWNkuYbUn3m5iI1YWw0N9emp/SwkJlHC/Wg91w59GNJzLYmd6JuoWUQoLheK
	6oiCkzy2HR08pu2tAf6WPgEM4OhvD3gowso+CXKa6xiSewFauuovcYSwbmxemPS4
	59XltGi9mHsHVN+24s54UyuLIvsMVZ2KlMFvqrgfiYOYEzvOu3Cbhqfz9/L9U77p
	EMv261PUnzPppFLloztu+A==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4eb3us80d5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 23 May 2026 03:15:24 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 64N3F7ao032598;
	Sat, 23 May 2026 03:15:23 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4eb2p6hsj3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 23 May 2026 03:15:23 +0000 (GMT)
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 64N3F9eI032824;
	Sat, 23 May 2026 03:15:23 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4eb2p6hs6k-13;
	Sat, 23 May 2026 03:15:22 +0000 (GMT)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Sasha Levin <sashal@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: ncr53c8xx: Drop CONFIG_ prefix from Zalon-specific compiler defines
Date: Fri, 22 May 2026 23:14:27 -0400
Message-ID: <177913641745.1181900.707705029889941541.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260426000330.56137-1-sashal@kernel.org>
References: <20260426000330.56137-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-23_01,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0 lowpriorityscore=0
 mlxlogscore=837 bulkscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2605130000 definitions=main-2605230029
X-Authority-Analysis: v=2.4 cv=Zewt8MVA c=1 sm=1 tr=0 ts=6a111bcc cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=VwQbUJbxAAAA:8
 a=3bGs5ERHum-b-X5uikgA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: 4YRRjomAEFbD0oE2y-FZNOpNt6P7Pkj7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIzMDAyOSBTYWx0ZWRfX3FUQib0Zf2+P
 iriXVtv+Q+0Suhm6JeDNZAkpVIUa225fuo7UYCyLzzjXFyhCATh7SfISjfptv5mXH7CHfvi/9cO
 5GdyJqyFwHgms/cQQ1AtuU35LrRcI+oEzg9ImjevRL8EpxwibbaFuaReKfHixmBLDdR/uRwd8gB
 tdDPczLvv1ujcAZCJwk2de5ba9JWod5StT6es/07+CWcUnBX7ehKq6a4ypK0v+UNaQ7D2st2QIA
 q+Pcg5ZpSUhECl9u/HAJdgyKEcaPGRwX9cgDfEJrb3MkLSfnvbsH/BZpxrQK14WkWkTFHnEp4BV
 DLKwhdmTGJz6cffJAu5BZJJMCW19gyvaeootS3L/5W+czZmB+kqtIZ0jRKZOe7X8aVlTFhlOwgB
 Zjscn8pmd9DiS94nJCP7DDb+IC1ifc3inKhLjXtwcDN/ifUe+13IL9NkKNZohwDi/hb2NaTbQdN
 ae7RJgJVuyiJILAnwDA==
X-Proofpoint-ORIG-GUID: 4YRRjomAEFbD0oE2y-FZNOpNt6P7Pkj7

On Sat, 25 Apr 2026 20:03:30 -0400, Sasha Levin wrote:

> kconfiglint reports:
> 
>   X001: CONFIG_NCR53C8XX_PREFETCH referenced in Makefile but not
>         defined in any Kconfig
>   X001: CONFIG_SCSI_NCR53C8XX_NO_WORD_TRANSFERS referenced in Makefile
>         but not defined in any Kconfig
> 
> [...]

Applied to 7.2/scsi-queue, thanks!

[1/1] scsi: ncr53c8xx: Drop CONFIG_ prefix from Zalon-specific compiler defines
      https://git.kernel.org/mkp/scsi/c/7787588db949

-- 
Martin K. Petersen
