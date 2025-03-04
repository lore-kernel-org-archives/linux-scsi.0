Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FE351EEA51
	for <linux-scsi@vger.kernel.org>; Tue,  4 Mar 2025 03:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741058401; cv=none; b=ib4aCC+V9aaovy0R5Mz/PAEdxUoUtBdrH2v2eW6kOuQvwc6d5xz8ghrLMrytGDqksbhz8usvtfUEaNXYWmVrHV/ebsar6q1AtWzacOmvphlWtwQhnU3l4fTEvRyyFhDojtqfFc3iQcl0e9k8HpFQjDj0ykbJHj5OHo1pQXVXpDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741058401; c=relaxed/simple;
	bh=eezJ0dUjlmd6iM3ecqjv48USRGKS4nfPbSK7jdyPeMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Mx+cC4d728NBdV9aYFtirEvWDiPoCR3VwhLlh5dnBpKlAtcRGuOxkARjsCRR2P5ca/TZ+zG45T7y2mdvdXlQaMb/9ip685S+qL9ut/OmIDIQllQFU5uwhEDItoV9PQjsc0xfXip7UFV4y1Sd3XE0DENeqPqzuZMuxVFCBSKtB6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Qop5lX2M; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Qop5lX2M"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5241Mou1019223;
	Tue, 4 Mar 2025 03:19:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=iR3JqEZrwpc1/R5l/vl9NF/whxqdJ8FQz4JIlWkBDHc=; b=
	Qop5lX2MwtqskysmV0ZsR68mLvDdQ2OHQ7HyFazlmMnaacevgr84Co4toyXt5hSh
	76uZNdkLIPiNVq18jz53/B6DiWfWFnQC5/4yEfJUcWt+lnKavSQMp2OT+ZmLSP7l
	iRRnWJvarR+kFDP/WQ+Mx+lOOJr5wtyRw+AX6Jf9kbyOCZh8RPmmkmg6fNcs3rKN
	7qRY/cnR5HdRclLkPMQ5hvsIeDpa0w/ixqDgIFNCAh+U9psooRBZEPqWzfuq75nn
	rd6V6vUhpgSjMT9FVXGmj+SwnldcjKGQmVL7og+/HE2STbpGMfjM1ySGARAyCtSG
	7yF6SsM89kmbhjt+qDaKuw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 453uavv2tm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Mar 2025 03:19:50 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5242u2kP039768;
	Tue, 4 Mar 2025 03:19:49 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 453rp92sfw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Mar 2025 03:19:49 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5243Jl4e029873;
	Tue, 4 Mar 2025 03:19:48 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 453rp92set-2;
	Tue, 04 Mar 2025 03:19:48 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, dgilbert@interlog.com,
        =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        James.Bottomley@HansenPartnership.com, jmeneghi@redhat.com
Subject: Re: [PATCH v2 0/7] scsi: scsi_debug: Add more tape support
Date: Mon,  3 Mar 2025 22:19:16 -0500
Message-ID: <174105384018.3860046.14722073801589472586.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213092636.2510-1-Kai.Makisara@kolumbus.fi>
References: <20250213092636.2510-1-Kai.Makisara@kolumbus.fi>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-04_02,2025-03-03_04,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 spamscore=0
 mlxscore=0 mlxlogscore=999 adultscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2503040026
X-Proofpoint-GUID: AX6bxGPXSkUQII8mf7hMaoPIyzDRpTa1
X-Proofpoint-ORIG-GUID: AX6bxGPXSkUQII8mf7hMaoPIyzDRpTa1

On Thu, 13 Feb 2025 11:26:29 +0200, Kai Mäkisara wrote:

> Currently, the scsi_debug driver can create tape devices and the st
> driver attaches to those. Nothing much can be done with the tape devices
> because scsi_debug does not have support for the tape-specific commands
> and features. These patches add some more tape support to the scsi_debug
> driver. The end result is simulated drives with a tape having one or two
> partitions (one partition is created initially).
> 
> [...]

Applied to 6.15/scsi-queue, thanks!

[1/7] scsi: scsi_debug: First fixes for tapes
      https://git.kernel.org/mkp/scsi/c/f69da85d5d5c
[2/7] scsi: scsi_debug: Add READ BLOCK LIMITS and modify LOAD for tapes
      https://git.kernel.org/mkp/scsi/c/e7795366c41d
[3/7] scsi: scsi_debug: Add write support with block lengths and 4 bytes of data
      https://git.kernel.org/mkp/scsi/c/e1ac21310aaa
[4/7] scsi: scsi_debug: Add read support and update locate for tapes
      https://git.kernel.org/mkp/scsi/c/0744d3114c60
[5/7] scsi: scsi_debug: Add compression mode page for tapes
      https://git.kernel.org/mkp/scsi/c/568354b24c7d
[6/7] scsi: scsi_debug: Reset tape setting at device reset
      https://git.kernel.org/mkp/scsi/c/862a5556b1a4
[7/7] scsi: scsi_debug: Add support for partitioning the tape
      https://git.kernel.org/mkp/scsi/c/23f4e82bb9eb

-- 
Martin K. Petersen	Oracle Linux Engineering
