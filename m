Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59DC928DA1;
	Tue, 28 Jan 2025 23:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738107732; cv=none; b=uWbPODb9yeYxQi5vwqJ8nESHvcqOd4/kbP9YNeWNS4o9ahJ4yx69sw8RHyKnsfnp+w4/yKKXqMSIEaFTr8q8FtRg/RCaFzk68pkzmQOSDaBBn2yXEJ3I2N0X0sayxvnfSSHLDnvffFYyVjLKsim3w8Sbt5j8T0z7sM5VIL0uoFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738107732; c=relaxed/simple;
	bh=PKFcSVU/UKXyMQab6ttJQElv1AogIcbFqfTc1mDXcso=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NlV75DloYLN/albg8yvNzHdLC8hN3cbFyk2SUPiJL8/v7mdxcbFlUhc6eu5hfeNAiHjJNT+iEBvtuGYBpvZ+mf9rqDsHu3O/jK0lvJTOWCwo4+J/ea8GL8K9r0ZcDRNjBlPq8SU1+h3A8PHW4H9esiJPrukbofdIEryZ0xfhzzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=oa5pgAXM; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oa5pgAXM"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50SNT09H007512;
	Tue, 28 Jan 2025 23:42:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2023-11-20; bh=6OKRVSi5+QVtZWVv7MJ9cHj72Ttwc
	3NUJiGqq4HrypE=; b=oa5pgAXMX069JLqDO//afhLVz1LuUMtjbfM00IKlc9wLk
	CS/rd64zhZIfXIPxYrKGfPRw0O98d0alvQrySC+sVU+zTq8v0EmRw7NFnETn7pud
	qR9gptMmIP4l83Idz8+bUN+Hd0Mw2eUWB+35Afv8Wb3XDsBYQ9rjHkDRImL7zsfr
	Lqt4HjvqCAiGzJZEon9kAsH8qX6jOIWPAjJ5UhRpI+RmsO6qxi6jsVPA7MTi03oP
	IM3PSVyWqS1HZlIh9p9Cb8UKZsy3qw9EM6jlA1DytchujXnt5gAjJxLkHLHv6kaJ
	YyNHXmYBZYlnLXvEhHyXkHpLxKh8iYXNxcO1CGnug==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44f8xu80c0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Jan 2025 23:42:05 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50SLwMYc035935;
	Tue, 28 Jan 2025 23:42:04 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 44cpdf2mws-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Jan 2025 23:42:04 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 50SNg3Ws019555;
	Tue, 28 Jan 2025 23:42:03 GMT
Received: from ca-dev94.us.oracle.com (ca-dev94.us.oracle.com [10.129.136.30])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 44cpdf2mvx-1;
	Tue, 28 Jan 2025 23:42:03 +0000
From: Alan Adamson <alan.adamson@oracle.com>
To: linux-block@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, alan.adamson@oracle.com,
        linux-nvme@lists.infradead.org, shinichiro.kawasaki@wdc.com
Subject: [PATCH v2 blktests 0/2] Add atomic write tests for scsi and nvme
Date: Tue, 28 Jan 2025 15:50:32 -0800
Message-ID: <20250128235034.307987-1-alan.adamson@oracle.com>
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
 definitions=2025-01-28_04,2025-01-27_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 phishscore=0 suspectscore=0 adultscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501280172
X-Proofpoint-ORIG-GUID: NdP3q6EmR7iSka9k6gMXWK42TurPBVVn
X-Proofpoint-GUID: NdP3q6EmR7iSka9k6gMXWK42TurPBVVn

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
