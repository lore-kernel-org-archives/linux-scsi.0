Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E2A679CF
	for <linux-scsi@vger.kernel.org>; Wed, 21 May 2025 02:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747794008; cv=none; b=PdwhuCRCZxFWcE9iu3FTxKJ9WXVhHIIVvonXTNuLT76TqXcEE1ZbxirpJU2o9MKDWz5RsnvBVFQyRbgyV33YvI/76mJpW+GnngvN8ao2Cxl51T7toGHogrwxtata9A4Og/Vswt725LtCmqBemQFBEGFnMGearCHIZVAvU9IFSyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747794008; c=relaxed/simple;
	bh=cdmgI49gvR5FOFHcAosaBWy2as8yaoBa/mO7tQ2A4nE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fZcdOC/8Cw7Pdx5Al9OXHNXphE5emNbNOl7MOVO0HAsog4HX0agtMNpJUjkiZ+WCgHoQ3Dq2k5+4iBKyZDA4WEfFpgo5bSWm2nvosNScWyAfmRsYDAhDeZodEooFPKpM5d+XcGohEGVtx6dQQOn+9+nk5jiQ35+HJiQ4NX7YCVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=FXFK10ir; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FXFK10ir"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54L2DDiQ017475;
	Wed, 21 May 2025 02:19:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=09+aQshAZb8YOwFf8ld/wcgToIDS1sqLjvK/RsQQDUI=; b=
	FXFK10irWOcB9Tpm2ktDy/WjGm9lcfm/2QIRyqy+QVYozfSGhKlf7B2w6Ymy4TGj
	bYLNkFruFSFdHb/0gR8R3zjH2kpUQ+UYIa8CV1lXUZ5RzYtm5GjEwXNBvUhuPyk1
	nd5ORRJqsGOxnsOKqta3eRi0Ls6j1IxVkQvTn5x5Wj7lPmmlnH9gMRGpcMr13acv
	rG4t1tGnRfIrxNQFZqfP3mVwvZGlWPn8oyGpy66G5/DtitQtJgFGzFC0jVnZMNA+
	TNv79lckE481Jn57qZtuiB82g+OJ01jijSfXWGwDB70kMZ7Q8cBVwZKk55i6DTv9
	zzrCmqqS5gnhwtuXhVrwOg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46s5mag0t8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 May 2025 02:19:49 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54L2DldN032157;
	Wed, 21 May 2025 02:19:48 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46rweks9hd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 May 2025 02:19:48 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 54L2JmZt004389;
	Wed, 21 May 2025 02:19:48 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 46rweks9h2-1;
	Wed, 21 May 2025 02:19:47 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, bvanassche@acm.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        John Garry <john.g.garry@oracle.com>
Subject: Re: [PATCH] scsi: remove the stream_status member from scsi_stream_status_header
Date: Tue, 20 May 2025 22:19:16 -0400
Message-ID: <174777706859.55368.13651158376894297113.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250505060640.3398500-1-hch@lst.de>
References: <20250505060640.3398500-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-21_01,2025-05-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=777
 suspectscore=0 phishscore=0 mlxscore=0 malwarescore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2505210021
X-Authority-Analysis: v=2.4 cv=aZVhnQot c=1 sm=1 tr=0 ts=682d3845 cx=c_pps a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=VwQbUJbxAAAA:8 a=3eMLAKG2ellr2LCeQBMA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: bTN1XvEC94HB3SmUGi9w-oRiebDtca7-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIxMDAyMSBTYWx0ZWRfX6itbyajAH5IJ 1zNSojc/l9fS5AWadH5a558HmxM7490Qa276LiB80mbD/NLjHnj6MfjtTZwJk7Ucg7zUlCyH0vN pJbIJIZCGHuqHF7w8nBK3f3s2NN0xoH0zgEdK4nbGMctdUTRXp3jy4MRcowYLWZrSTl2Hm+B8xK
 XgrdG9o2xnb0iu7/dALtB6xPTJOy9lOjfOPhBpM/w7vhoNcCgnGmw4O5IoG2tdZ8GHkgwWp6d88 CJs7UevBY15iWziFzVvRWd12yill4TJB1aWi7M9oxnZz+jz5ErkKvsg+u7gTQCKFkgPRVP3JdcZ zKhV6CM+5jcdjuuKUDAW/hQlJy0oCXqG0qm/7J75Y2ZpKimbpyyNkaQvI6dmvaFUeNV28Kifa9A
 7hzX7JSKsHlmUSser+82Zr9dffMA3h4w1sxsNdSW7uszp7nDnXMfP5Zm0KI+m0t4ygNlOcjc
X-Proofpoint-GUID: bTN1XvEC94HB3SmUGi9w-oRiebDtca7-

On Mon, 05 May 2025 08:06:37 +0200, Christoph Hellwig wrote:

> Having a variable length array at the end of scsi_stream_status_header
> only cause problems.  Remove it and switch sd_is_perm_stream which is
> the only place that currently uses it to use the scsi_stream_status
> directly following it in the local buf structure.
> 
> Besides being a much better data structure design, this also avoids
> a -Wflex-array-member-not-at-end warning.
> 
> [...]

Applied to 6.16/scsi-queue, thanks!

[1/1] scsi: remove the stream_status member from scsi_stream_status_header
      https://git.kernel.org/mkp/scsi/c/cd6856d38881

-- 
Martin K. Petersen	Oracle Linux Engineering
