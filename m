Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30D8256B60
	for <linux-scsi@vger.kernel.org>; Tue,  6 Feb 2024 02:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707185298; cv=none; b=AOY9BFx384Vxgz2XWRO6Pzo3w7yopjxb3QdM++anldX/DWo32VibISrXVB0RhaUoOfDvdeYgUU8Y9UoLSf7rrujKCcCRBdYxF6sYiOJJv1s2o0wWFwAdNEB8KgKzaWFYQ+Y8lOofDEmMu67WRB7WnPSgs+kwnqibOFaQ0LiECaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707185298; c=relaxed/simple;
	bh=DUw5Ch5+xE1YIctZcICcMPYftGa8U8r893zbztlmAPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tmkGzfh4s92zCVdkK4mRG4aG3CwY489/BI6R/SpC4OQFfucnpop2lUmtuMVdl8a0mlVjn2ia28/QbfnEr979CmQKy/aUdIQkiOm9ZEtDLFDd+UV/hDMSr9qhphr7Ba2X4vsD1eSJCivUkNffkem9SMfFCUFq5vK5GQj+SnVuZiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bT1Odjc8; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bT1Odjc8"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 4161ESGt004818;
	Tue, 6 Feb 2024 02:08:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-11-20;
 bh=9wvwFLRfLl0KMKLzLKG3G/Q6Cd1noQcQtfr8Ks08l1o=;
 b=bT1Odjc8xUNkGxmIL3/ThuZQb5T3VcobOGiX1rnQ5iRdCpeK2lJgEvGKzwNU1aX7DVBF
 t37KtELuCHekxLEnhVdrgkuD0FMcBLeKtqoS6nzfHJ3XVC6m5kxZ7NHmtxnyZTFa7fRz
 ZIhWS3jZhtKcyPr9th5kcDNp/YQd42J3HRXQH7BZOGE23t1aIwWZqTckT7s2BeuhKO0U
 SEpqXCWwfGgM17xlqSQYGAi3kZIgN2U1C9YXcsSmSna00JpmMqPdc40kas7tJCmP2xEm
 5lTI3cnexooq4gZC3IOIfUkCbaU3guz8MGSo8/gDiD5NWbESCZwgk1ymVITjffqgh47x MA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w1c93wmfj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Feb 2024 02:08:04 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 415NjcBR039526;
	Tue, 6 Feb 2024 02:08:03 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3w1bx6cdue-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Feb 2024 02:08:03 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 41627qHL034652;
	Tue, 6 Feb 2024 02:08:02 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3w1bx6cdrb-3;
	Tue, 06 Feb 2024 02:08:02 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
        Mike Christie <michael.christie@oracle.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v13 00/19] scsi: Allow scsi_execute users to request retries
Date: Mon,  5 Feb 2024 21:07:39 -0500
Message-ID: <170715263714.945763.13515511419958141084.b4-ty@oracle.com>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20240123002220.129141-1-michael.christie@oracle.com>
References: <20240123002220.129141-1-michael.christie@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-05_18,2024-01-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 phishscore=0
 spamscore=0 adultscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2402060013
X-Proofpoint-ORIG-GUID: hMafaZy5oRdAuXcbkGGIuQYT9Hxm35s7
X-Proofpoint-GUID: hMafaZy5oRdAuXcbkGGIuQYT9Hxm35s7

On Mon, 22 Jan 2024 18:22:01 -0600, Mike Christie wrote:

> The following patches were made over Linus's tree which contains
> a fix for sd which was not in Martin's branches.
> 
> The patches allow scsi_execute_cmd users to have scsi-ml retry the
> cmd for it instead of the caller having to parse the error and loop
> itself.
> 
> [...]

Applied to 6.9/scsi-queue, thanks!

[01/19] scsi: Allow passthrough to request scsi-ml retries
        https://git.kernel.org/mkp/scsi/c/994724e6b3f0
[02/19] scsi: Have scsi-ml retry scsi_probe_lun errors
        https://git.kernel.org/mkp/scsi/c/2a1f96f60a4b
[03/19] scsi: retry INQUIRY after timeout
        https://git.kernel.org/mkp/scsi/c/987d7d3db0b9
[04/19] scsi: Use separate buf for START_STOP in sd_spinup_disk
        https://git.kernel.org/mkp/scsi/c/1008f5776fe5
[05/19] scsi: Have scsi-ml retry sd_spinup_disk errors
        https://git.kernel.org/mkp/scsi/c/c1acf38cd11e
[06/19] scsi: hp_sw: Have scsi-ml retry scsi_execute_cmd errors
        https://git.kernel.org/mkp/scsi/c/fabe3ee92e18
[07/19] scsi: rdac: Have scsi-ml retry send_mode_select errors
        https://git.kernel.org/mkp/scsi/c/f316ff46a0ff
[08/19] scsi: spi: Have scsi-ml retry spi_execute UAs
        https://git.kernel.org/mkp/scsi/c/5dbf10473642
[09/19] scsi: sd: Have scsi-ml retry sd_sync_cache errors
        https://git.kernel.org/mkp/scsi/c/183053203d45
[10/19] scsi: ch: Remove unit_attention
        https://git.kernel.org/mkp/scsi/c/11a26723210e
[11/19] scsi: ch: Have scsi-ml retry ch_do_scsi UAs
        https://git.kernel.org/mkp/scsi/c/e11f35c46ebd
[12/19] scsi: Have scsi-ml retry scsi_mode_sense UAs
        https://git.kernel.org/mkp/scsi/c/21bdff48e12b
[13/19] scsi: Have scsi-ml retry scsi_report_lun_scan errors
        https://git.kernel.org/mkp/scsi/c/8d24677ebb9e
[14/19] scsi: sd: Have pr commands retry UAs
        https://git.kernel.org/mkp/scsi/c/eea6ef3792e3
[15/19] scsi: sd: Have scsi-ml retry read_capacity_10 errors
        https://git.kernel.org/mkp/scsi/c/0f11328f2f46
[16/19] scsi: ses: Have scsi-ml retry scsi_execute_cmd errors
        https://git.kernel.org/mkp/scsi/c/3a7b4579328e
[17/19] scsi: sr: Have scsi-ml retry get_sectorsize errors
        https://git.kernel.org/mkp/scsi/c/b72f2d149e24
[18/19] scsi: ufs: Have scsi-ml retry start stop errors
        https://git.kernel.org/mkp/scsi/c/b8c3a7bac9b6
[19/19] scsi: Add kunit tests for scsi_check_passthrough
        https://git.kernel.org/mkp/scsi/c/25a1f7a0a1fe

-- 
Martin K. Petersen	Oracle Linux Engineering
