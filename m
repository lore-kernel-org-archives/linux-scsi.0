Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74653279DA2
	for <linux-scsi@vger.kernel.org>; Thu, 30 Oct 2025 03:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761795224; cv=none; b=WWMzs4EhMezXjomJwdu6qAoADVjtFLnhkNnw41wWIViFX+H/KsAdg34bm2TBdFURQnecxDPNALrqMCQO2gHVAccFgYzD+pzpP2CcI8Tu/sTHxlPTZTgbfWoebn8vr3+9ZsqKcT7UUeMJTI/BbJ5csYfr7w9ePfSVPBQ6FAVfUzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761795224; c=relaxed/simple;
	bh=xYJe/05FhRKN0RcbQwseCDbym3t6dCExMwh6s2IkyLE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X9QfvO0qpLbyCydpofKmr4SkenxHIdb/h5sjrvPYifvO4yzy5WCvZYHE2404WymMlDjHLDwIzin3xIO5hUyAw4WqWTykxCzN2W5blX4qG5dffan0O91lXWAl/F7ndMWfI7kjuoMBV1rOZ8T/wGvhG65ST6dEALQQ8UiuI7NZfPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IX764N+8; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IX764N+8"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59U29ZP7018486;
	Thu, 30 Oct 2025 03:33:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=UKoCMBPOIJGxT6Zns2kCBMCKp7YxlxmJuUIZ5DlisBA=; b=
	IX764N+8N37HkpIignZPpiG05K+zDjwn5QpphRLQLNMQpAxjM48Dt6730p+f3vlZ
	6U5uq/cYWqYvBUCVcW57mDpBsk51ME3GwDXWdh4o7t/jqbPKBL+rFU63jk91pzBB
	VIl/NMcH6GturQxMS1Xw45/OWhmvLJDvN+2flG+UepC0yZ0SM5Jisb7Z38zsXNVu
	va0BZTVHEX7ZbH68mNqdPbdDMB4PvRnKxASAhmE5TmEudqpDe6m6/B3VY27MiFGS
	VDNyN/M9V0uRKlbtxUDxV6vFfkHGKbm0Y3duZtoJrLcTv8/BdbDepl7Svc4J55ZY
	GRiQkjhPD/maAh8S+qy0lw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a3y02g2vs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Oct 2025 03:33:38 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59TNsWT7022831;
	Thu, 30 Oct 2025 03:33:38 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a33y01uq4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Oct 2025 03:33:38 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 59U3XYQk034192;
	Thu, 30 Oct 2025 03:33:37 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4a33y01uh6-4;
	Thu, 30 Oct 2025 03:33:37 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: james.bottomley@hansenpartnership.com,
        John Garry <john.g.garry@oracle.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, bvanassche@acm.org
Subject: Re: [PATCH v2] scsi: core: Minor comment fixes for scsi_host_busy()
Date: Wed, 29 Oct 2025 23:33:20 -0400
Message-ID: <176178801892.1949089.2398117425483239106.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251023082759.3927000-1-john.g.garry@oracle.com>
References: <20251023082759.3927000-1-john.g.garry@oracle.com>
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
 definitions=2025-10-30_01,2025-10-29_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 mlxscore=0
 adultscore=0 mlxlogscore=999 suspectscore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2510300026
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDMwMDAxNSBTYWx0ZWRfXwPChi9XJTDtu
 504hfzg3QjYtAcbK6zVIM1l7cEsUPd07LL2EjOMGDFXsWp137LH5dI0q2NoIX/OKllzeyaXZ+tK
 Btocb9rK1IWLqDw5Q3oHgwD6CWOBBqyqX/XGXhl8wDH7urj6xLAvODSyxqFNJloXE0R2mjru1qM
 1Y5DyFKL1SZYy9lGvnz4ZJXW9UosiBeg01EPs25Po8dkWbTWXFDFO9JAm61ygjqNWqUbOIluHum
 NwgtBNPQgAq0xoonos8CR8i0Fh1nEAFnmHpUbr8oo4hZ5Yn0OrePi3nkX6azA0hFodSsl3/TYop
 wHLsHX9IFYf47uIc5Wvo9J4q3BbQfRLqvJoLnWR1JxZlbHABoKMckTXOh4FuzOkcac7+fTc39rW
 ye9ZuzIJj2psdUPcd3qQ0VplsfsywQ==
X-Proofpoint-ORIG-GUID: C0AROviTtljPRxhNocBHVLpspheBuA3a
X-Authority-Analysis: v=2.4 cv=Vs4uwu2n c=1 sm=1 tr=0 ts=6902dc93 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=z_Cww6XpaXVVc8tTTocA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: C0AROviTtljPRxhNocBHVLpspheBuA3a

On Thu, 23 Oct 2025 08:27:59 +0000, John Garry wrote:

> I guess that the @shost comment on scsi_host_busy() was copied from
> scsi_host_get() (as it is the same), however they do not do the same thing.
> 
> Also drop reference to busy counter, which has been removed.
> 
> 

Applied to 6.19/scsi-queue, thanks!

[1/1] scsi: core: Minor comment fixes for scsi_host_busy()
      https://git.kernel.org/mkp/scsi/c/dcc98c11364e

-- 
Martin K. Petersen
