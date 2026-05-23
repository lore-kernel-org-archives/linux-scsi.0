Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CE13339705
	for <linux-scsi@vger.kernel.org>; Sat, 23 May 2026 03:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779506166; cv=none; b=POcyvzQyOhhlW1amI5RQjDScJDArcX4QDbk/WJ75MUL2OzDHPayoXgyW2M98ZdA42MhYNyxkCIKSGjtZH+uFmhZeuzM/iedrvc/+n0zFAH/n1acADzjcm9ce0vr2F3lsiKM9UG0vpE2eV8/9Vnv0n7vv7S9Ncrd0U9l7BWYHx5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779506166; c=relaxed/simple;
	bh=M+cpXNVNmBECPfTHafUNTaa0ZMZsG1pGrlAIB+m3yRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CmMCA3S9zMXuF+PvBsBwb2d3RrWP2GOoHcjMTtWOqIkVgz+XRjARD/D97ZQvR0lbnsDdF1edc+WmrDCMX6F4lnTT2/ukWWjRXlimzr2Au43BKJVvzC4I0ukloyL3oRH+4LQ84Qp/oz++f59HwsXsOb5rl3q6L03ec7irC4t5GLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UXWBXk22; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UXWBXk22"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64N39dDE925950;
	Sat, 23 May 2026 03:15:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=POcr278EiKP+KWx1bSbLFER/AODfoBN67DtJaDax6W4=; b=
	UXWBXk22PbKBNAha/hUid5IlTt/hn3sS5oT4bqmnBBipdzLFHj74aWx4OSYa4XEh
	aw3bB6KPPRfC2fRcEt5Y7Vqb+A24f83Uv+TB+f8SFj+q3ThrXICA2h++zkgjxpdV
	/Epf/CNT/6gX3rYkdzNc8D3czPJ3mypbxNYKrkQCTiXGga1lhXI4jznz97m1MKsb
	3Jmujj09xYEvPjpYNl8/fgzWoBFV01UDxoysvufZ9O/G9HMMzGtsqmAwQDJvd9iE
	VaRMxCmdXno/EeMYnYGTfmCP9GhXAW4gLBiNtAeogIcasxixsJ54zTP61D8xHZin
	WakuCqR6E7z19LVIl+XYXw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4eb2tyg72g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 23 May 2026 03:15:58 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 64N3F68n032371;
	Sat, 23 May 2026 03:15:58 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4eb2p6hstu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 23 May 2026 03:15:58 +0000 (GMT)
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 64N3FvRI035132;
	Sat, 23 May 2026 03:15:57 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4eb2p6hstd-2;
	Sat, 23 May 2026 03:15:57 +0000 (GMT)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Bart Van Assche <bvanassche@acm.org>,
        David Jeffery <djeffery@redhat.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] scsi: core: run queues for all non-SDEV_DEL devices from scsi_run_host_queues
Date: Fri, 22 May 2026 23:15:48 -0400
Message-ID: <177950426842.1557613.17754359525659781441.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260515180941.9698-1-djeffery@redhat.com>
References: <20260515180941.9698-1-djeffery@redhat.com>
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
 mlxlogscore=984 bulkscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2605130000 definitions=main-2605230029
X-Authority-Analysis: v=2.4 cv=SoCgLvO0 c=1 sm=1 tr=0 ts=6a111bee cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=VwQbUJbxAAAA:8
 a=NUbkhC5GeSYxshbFoikA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: gfmT7zwZWJn1rVjYySPhuzMPl8E-fmvj
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIzMDAyOSBTYWx0ZWRfX4RiklgwW+rI8
 2ua0AIKbjiKXDLpjYy9H/Y/AENK/aXISyqSh4wAyaZ2vBcgQcrf82gfRzmfsJ94TcjGmmK92Wdl
 po5WiwmrNMG7eWfh5t02ArGlhCPM19WTWgRzJ4GBv55uLj2hbmTZSpNJyeJP2YuFBXwebHCYvrd
 OLwqYAKAO0YoJwZQ1pDivdL6Jdjc78N5ZvpjyQJ9IoIy72pE9VNcnGrlXkw9T7q25Vuj6Z8IuiQ
 OjQFySyjvN6oCzM0IuikZZBCdcXVnuvFxeGpxpnuS8Y/lo2EQ41nXQTU06OE/qh911oKACYkptr
 kRemIteqySvOAGgqDUhPGy58fttlqrPgN9vpI7qBZCxwtsJPOSYBV+GWgUOin/XVsGiX2fJZPdi
 tSBMpZxBB+qtrk0fwgLxHExnqvVphP5egC6xkkV5MZNVKdHWueZuRORFonqX6DLwb0GnfT8zlf/
 Et706FetGe6Us3k626Q==
X-Proofpoint-GUID: gfmT7zwZWJn1rVjYySPhuzMPl8E-fmvj

On Fri, 15 May 2026 14:09:41 -0400, David Jeffery wrote:

> While a scsi host is in a recovery state, scsi_mq_requeue_cmd will not set
> the requeue list for a requeued command to be kicked in the future. The
> expectation is a call to scsi_run_host_queues will kick all scsi devices
> once the recovery state is cleared.
> 
> However, scsi_run_host_queues uses shost_for_each_device which uses
> scsi_device_get and so will ignore devices in a partially removed state like
> SDEV_CANCEL. But these devices may also have requeued requests, leaving
> their requests stuck from not being kicked and causing the removal process
> of the device to hang.
> 
> [...]

Applied to 7.1/scsi-fixes, thanks!

[1/1] scsi: core: run queues for all non-SDEV_DEL devices from scsi_run_host_queues
      https://git.kernel.org/mkp/scsi/c/7205b5870227

-- 
Martin K. Petersen
