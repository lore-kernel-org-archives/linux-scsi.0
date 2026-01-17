Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA92250094C
	for <linux-scsi@vger.kernel.org>; Sat, 17 Jan 2026 04:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768624709; cv=none; b=ir9ncBIFyv62SepRebrjW4Sq8Kgpfvx8s03QgvMxXVtGm/v09+y3bzZ5tt62N8QipNRdXHJYQRKKKTXlc+Eb3wIfNfISZV6S7iDNwFQunudZovmCZhlg1xTaYa9vDH4DQV+gmD+NG0a9edy+VK+Rddf/89na5nW1TtWxFyR+rAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768624709; c=relaxed/simple;
	bh=F8VYuQE+j4+ybL77+9qqgjxclvIR29X4me5Ol84+h6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JJUGJwGkVuR/E5/HpzVlqW8RKHCSCEdTRj1b40qynPFrfrHZLg5S+MZJLMXeMV15GcJmzxNrccuA1QB1mWnZ9VY41YHSWKsXJRynitp8rJ47exivkKwI0Ga1S/+hWfE5y9t0Nd6/Z3MXzASx8nPksP2JBqfnDBlcANkx8X5dooo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=mLSdR29H; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mLSdR29H"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60H4Z1S71146188;
	Sat, 17 Jan 2026 04:38:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=qgYEo9fXLT/VDLyz3+n2KEyFjxfj1SxdGS74HTaPx3M=; b=
	mLSdR29H6kqy+6cnJ3GcHnN36Oxnq2E09qmze7Q1DyPQv2KPNtQtz7fe6KqpsUbt
	NejBZijTkzw5jeY4jpjsfI1tRjI3N4y39r2z1pfrvG2bU3zK5SnvGIrE/agjAP/O
	vKL6cvgySDvmjUgSfj0AHebM3Wxsgkz+3sXYavH5BeDCnvZtYAxsBJItaqpqV6WF
	sc1HIyhFXm3E2zQfETDdmSV8J0PPJFpdfB1Wcgz5sAuuB3afhPoLLu9Nk7Roo4mQ
	aSNjh5QCN7gfs73qqbnRaGzlVWCVOlhMa+xCzK7f6HDCgSujMwMUJL8pUPFWqvtg
	d52bqcys4cEGilO5cOvnUA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br2fa01g8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 17 Jan 2026 04:38:25 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60H1XlXj008410;
	Sat, 17 Jan 2026 04:38:24 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4br0v6bkty-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 17 Jan 2026 04:38:24 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 60H4cNOn008297;
	Sat, 17 Jan 2026 04:38:23 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4br0v6bkpw-1;
	Sat, 17 Jan 2026 04:38:23 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        David Jeffery <djeffery@redhat.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: Wake up the error handler when final completions race against each other
Date: Fri, 16 Jan 2026 23:38:04 -0500
Message-ID: <176862465915.2486839.13481928667380140969.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260113161036.6730-1-djeffery@redhat.com>
References: <20260113161036.6730-1-djeffery@redhat.com>
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
 definitions=main-2601170035
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE3MDAzNSBTYWx0ZWRfX2SCbYs4Tf2+Y
 muN65HpC5Ased3Qr3ly3HD9rC7xTeF/eNbWMc2A1pf2el826bsbZaDREuSjGPaAOnObw1uc04gs
 /ygENM9HpoZjs+1Ps9Kl9YFaDXMo7CfOpPfwa2OFfuuFdMul58f5kYfY8rBqoRcnTjJFcgj8Npq
 IpqGvjHwo1u4j27eQOU8Nv8xHYBKDAUBHqN0bo66ZFWkqEphIr9AJxEPGi2RvjzsI4A6SJzfQ6V
 kqr0AVRaLbPgQ60RWKrG5eDASFvRLnxcb6Dazibt35s3HnVs0RHDIObAJjAM5eR3sy/yXfrOjDB
 3TIfIomXgqbDaU5GBrm8C7s/0sQUQGRx39eBUmXzk7dj7jDngUZXPnr8XezyAbiP3ltAbAeeBhk
 i2/ozM97DdBdrJCiLm1CQkG2o0cA5/qTp3S7UvWF047WAOu1rbeMy8k2fy0soTVYW3YIm83g9IP
 oBPmjJ6FrloN3eoxIVQ==
X-Authority-Analysis: v=2.4 cv=HvB72kTS c=1 sm=1 tr=0 ts=696b1241 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=v4lJL6gmYw9ZTtN8:21 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=8FqnkaVlfTP_qjxUoRwA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: 3GhRntsPuIinr_1M5uKrGfrGEwjVQLyk
X-Proofpoint-GUID: 3GhRntsPuIinr_1M5uKrGfrGEwjVQLyk

On Tue, 13 Jan 2026 11:08:13 -0500, David Jeffery wrote:

> The fragile ordering between marking commands completed or failed so that
> the error handler only wakes when the last running command completes or
> times out has race conditions. These race conditions can cause the scsi
> layer to fail to wake the error handler, leaving I/O through the scsi host
> stuck as the error state cannot advance.
> 
> First, there is an memory ordering issue within scsi_dec_host_busy. The
> write which clears SCMD_STATE_INFLIGHT may be reordered with reads counting
> in scsi_host_busy. While the local CPU will see its own write, reordering
> can allow other CPUs in scsi_dec_host_busy or scsi_eh_inc_host_failed to
> see a raised busy count, causing no CPU to see a host busy equal to the
> host_failed count.
> 
> [...]

Applied to 6.19/scsi-fixes, thanks!

[1/1] scsi: Wake up the error handler when final completions race against each other
      https://git.kernel.org/mkp/scsi/c/fe2f8ad6f099

-- 
Martin K. Petersen
