Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15A4F19259D;
	Fri,  7 Feb 2025 23:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738972049; cv=none; b=KA/QTkd9iQzlYdlWl6RtgAuz3ToA51cucKUop8s0mwd1+GqV1bHKaMzkUwK3AOPrOzuS4iXhSANoahwjoXlWURRHN5/G+OseqngbZydiMflFLJVzlk0pw4sxMsyUO8uOz7w5vtbNW5V2dOtGiqH+3XjwTWboUWrwgukfSGI6Xwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738972049; c=relaxed/simple;
	bh=wKDmae79VNgiANKxlLgspJDihSPWVbopgsgLD4UPplw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KszliiunueNcF3H1lPal57ZVW61mDnd3sTZh/sqByP7Pt2dHr6XrJGY1GG00f2aiU5yBMIUm1qKrRIV6FT0L/eh3Dp6nE2LNC45l50NosXpQUReKDo12uCF84IWEHuy/bTtPDuR9Qc9PeEQDbXpswe1oI709YHnUqy0YGRJKEbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=nvSulILx; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nvSulILx"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 517Lfpr5026273;
	Fri, 7 Feb 2025 23:47:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2023-11-20; bh=HU5ANisxh20MlKMA70imVgX1Zsd5T
	X2ZMIFbtyqokPo=; b=nvSulILxDkVwoqPv7LHTYm/zbiwq0JU1THjIxqoteRDrT
	w0me0+Xe8nxn26xYwqpst0SaiA1Sq7JdISI+x6V68FypuIXSiyj+itnW6+zE6amN
	dIn1yj9jeDmg8oplWetOVvKBAd2Sga1eGvqd+3VMKztxSc4wYd7l75ExbqRM6IWc
	G5H8xTskjvIOl1uKnKz2zO82fGRnTInxIT+agvfbeYX7UR8BrH725rmAUeQsQfbh
	dPP5e2dmnHex30bWWhSO1as9DwRdqq8u5szJGXCW3OVa1boNR2E9m3ND1PzpwdE3
	o9OnX146RsWvinZkjg8tKXT8gJKCoWbpEV3iH8xkg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44m58cntes-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 07 Feb 2025 23:47:23 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 517NUIP6028036;
	Fri, 7 Feb 2025 23:47:22 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 44j8ds5wse-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 07 Feb 2025 23:47:22 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 517NlMLf001803;
	Fri, 7 Feb 2025 23:47:22 GMT
Received: from ca-dev94.us.oracle.com (ca-dev94.us.oracle.com [10.129.136.30])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 44j8ds5ws8-1;
	Fri, 07 Feb 2025 23:47:21 +0000
From: Alan Adamson <alan.adamson@oracle.com>
To: linux-block@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, alan.adamson@oracle.com,
        linux-nvme@lists.infradead.org, shinichiro.kawasaki@wdc.com
Subject: [PATCH v4 blktests 0/2] Add atomic write tests for scsi and nvme
Date: Fri,  7 Feb 2025 15:55:51 -0800
Message-ID: <20250207235553.322741-1-alan.adamson@oracle.com>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-07_11,2025-02-07_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2501170000
 definitions=main-2502070180
X-Proofpoint-ORIG-GUID: 5WDXrknFEkMOsiKZUSPyDHxiEtVdBbAk
X-Proofpoint-GUID: 5WDXrknFEkMOsiKZUSPyDHxiEtVdBbAk

Changes in v4 (per John's comments):
- Verify sysfs_atomic_unit_min_byte attribute (nvme)
- Perform atomic write test using sysfs_atomic_unit_min_byte (nvme)
- fix spelling mis (nvme)
- Remove tests that don't use the RWF_ATOMIC flag (scsi+nvme)

Changes in v3:
- Remove _have_xfs_io routine and use _have_program.
- Comment cleanup in 0001
- Add SKIP_REASONS when xfs_io -A option is absent.
- Keep lines <=80 characters.
- Move device_requires logic in 0001 and 0002 to common/rc.

Changes in v2:
- Add additional comments in common/xfs
- Remove xfs_io and kernel version checking
- Simplify paths for sysfs attributes
- Fix failed case output (missing echo) in scsi/009
- Add local variable that sets Test # and description (test_desc) for scsi/009 and nvme/059
- Only use scsi_debug device if no scsi test device is provided.
- nvme testing done with qemu-nvme.
- scsi testing done with scsi_debug and qemu-scsi (no atomic write support).  No testing on
  atomic write capable scsi devices was done.
-------------------------------------------------------------------------------------------
Add tests for atomic write support.

Tests will be delivered for scsi (using scsi_debug) and nvme.  NVMe can use the qemu-nvme
emulated device that supports Controller-based Atomic Parameters (QEMU 9.2).

The xfs_io utility delivered with the xfsprogs-devel package (version 6.12) is required by
these tests.

The Linux Kernel 6.11 (and greater) supports Atomic Writes and is required by these tests.

Alan Adamson (2):
  scsi/009: add atomic write tests
  nvme/059: add atomic write tests

 common/rc          |   8 ++
 common/xfs         |  58 ++++++++++++++
 tests/nvme/059     | 146 ++++++++++++++++++++++++++++++++++++
 tests/nvme/059.out |   9 +++
 tests/scsi/009     | 183 +++++++++++++++++++++++++++++++++++++++++++++
 tests/scsi/009.out |  13 ++++
 6 files changed, 417 insertions(+)
 create mode 100755 tests/nvme/059
 create mode 100644 tests/nvme/059.out
 create mode 100755 tests/scsi/009
 create mode 100644 tests/scsi/009.out

-- 
2.43.5

