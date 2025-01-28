Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3D9D19D8A8;
	Tue, 28 Jan 2025 23:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738107734; cv=none; b=Mst7hb2OovEvr7IoehEaGok75/FweVnwWFQkuHNWGHMIsJ/6W4VCn+7YAQrZhEwaWdbe06whYeDhNTXwfkpSX6bEW5FoMdN1AtEVvQBWJWf4qa6HUxTuPntUM8gPHJSk9dPcfh6uYsjHuAjfq2iFwFhEE/Y/adkmKOBxkyOw654=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738107734; c=relaxed/simple;
	bh=idZZdupKEkl3VMoR7NCFvbcaJYKvlDni5tel3XxrGuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cNc84K8fGyWWQhAlPpJsunqAwI+ggB848realnKyOFeuMbG8puKaUTTCP178ZM8QcKib4PjD0sAxY9egTDwIUIMYQCSKqzhZ7thehdVtIoCgDlMELa7otikbg+jl7mRHN8cJBWqaAcm/U6GKWh+LUoGgaPDZrUK/uelqQrI6yQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=OeKe+joM; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OeKe+joM"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50SMfuh4017882;
	Tue, 28 Jan 2025 23:42:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2023-11-20; bh=Q5Z2H
	hQ2PrRtwrzITOcYK8bPXqgMsi4iT5n5ZXTjQPQ=; b=OeKe+joMedbNl20VYHErO
	PEHPlTJhg812qwc3P759CPbjDRWMuD4ah+nxj+UybbFYSmtDUBf9C+FBX1x1uv/9
	73eI0jnt/MmMWiwoIrRpSITNp6uqAi+6ZYbYAgf/wmbOdR8trC9umAJ7u/x5nfUQ
	CvF92qeGr18KrX5vwS9TNo+BdWyCpTuFLBi5p0rks6uSn2AX5LBaMjl2DCoBItIE
	wbXYcOC17le1iY36jbJRgL9XpnDtboKKyj39Km4nftgFY/gij6isCPlhRGkUIf+i
	/8jwDGe/SVoXAGCe9fet1/bYjbrdrfV+Aj5UInceEkD67muXoxCwYmlYj9xsOzYj
	g==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44f841r2nt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Jan 2025 23:42:06 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50SND7MH035925;
	Tue, 28 Jan 2025 23:42:06 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 44cpdf2mxd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Jan 2025 23:42:06 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 50SNg3Ww019555;
	Tue, 28 Jan 2025 23:42:05 GMT
Received: from ca-dev94.us.oracle.com (ca-dev94.us.oracle.com [10.129.136.30])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 44cpdf2mvx-3;
	Tue, 28 Jan 2025 23:42:05 +0000
From: Alan Adamson <alan.adamson@oracle.com>
To: linux-block@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, alan.adamson@oracle.com,
        linux-nvme@lists.infradead.org, shinichiro.kawasaki@wdc.com
Subject: [PATCH v2 blktests 2/2] nvme/059: add atomic write tests
Date: Tue, 28 Jan 2025 15:50:34 -0800
Message-ID: <20250128235034.307987-3-alan.adamson@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250128235034.307987-1-alan.adamson@oracle.com>
References: <20250128235034.307987-1-alan.adamson@oracle.com>
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
X-Proofpoint-ORIG-GUID: 5KYxZKJlFfzQ8KQ2a0RsuUiQrk4QnwzC
X-Proofpoint-GUID: 5KYxZKJlFfzQ8KQ2a0RsuUiQrk4QnwzC

Tests basic atomic write functionality using NVMe devices
that support the AWUN and AWUPF Controller Atomic Parameters
and NAWUN and NAWUPF Namespace Atomic Parameters.

Testing areas include:

- Verify sysfs atomic write attributes are consistent with
  atomic write capablities advertised by the NVMe HW.

- Verify the atomic write paramters of statx are correct using
  xfs_io.

- Perform a pwritev2() (with and without RWF_ATOMIC flag) using
  xfs_io:
    - maximum byte size (atomic_write_unit_max_bytes)
    - a write larger than atomic_write_unit_max_bytes

Signed-off-by: Alan Adamson <alan.adamson@oracle.com>
---
 tests/nvme/059     | 151 +++++++++++++++++++++++++++++++++++++++++++++
 tests/nvme/059.out |  10 +++
 2 files changed, 161 insertions(+)
 create mode 100755 tests/nvme/059
 create mode 100644 tests/nvme/059.out

diff --git a/tests/nvme/059 b/tests/nvme/059
new file mode 100755
index 000000000000..032f793e222d
--- /dev/null
+++ b/tests/nvme/059
@@ -0,0 +1,151 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-3.0+
+# Copyright (C) 2025 Oracle and/or its affiliates
+#
+# Test NVMe Atomic Writes
+
+. tests/nvme/rc
+. common/xfs
+
+DESCRIPTION="test atomic writes"
+QUICK=1
+
+requires() {
+	_nvme_requires
+	_have_program nvme
+	_have_xfs_io_atomic_write
+}
+
+device_requires() {
+	_require_test_dev_sysfs queue/atomic_write_max_bytes
+	if (( $(< "${TEST_DEV_SYSFS}"/queue/atomic_write_max_bytes) == 0 )); then
+		SKIP_REASONS+=("${TEST_DEV} does not support atomic write")
+		return 1
+	fi
+}
+
+test_device() {
+	local ns_dev
+	local ctrl_dev
+	local queue_path
+	local nvme_awupf
+	local nvme_nsfeat
+	local nvme_nsabp
+	local atomic_max_bytes
+	local statx_atomic_max
+	local sysfs_atomic_max_bytes
+	local sysfs_atomic_unit_max_bytes
+	local sysfs_logical_block_size
+	local bytes_written
+	local bytes_to_write
+	local test_desc
+
+	echo "Running ${TEST_NAME}"
+	ns_dev=${TEST_DEV##*/}
+	ctrl_dev=${ns_dev%n*}
+	queue_path="${TEST_DEV_SYSFS}/queue/"
+
+	test_desc="TEST 1 - Verify sysfs attributes"
+
+	sysfs_logical_block_size=$(cat "$queue_path"/logical_block_size)
+	sysfs_max_hw_sectors_kb=$(cat "$queue_path"/max_hw_sectors_kb)
+	max_hw_bytes=$(( "$sysfs_max_hw_sectors_kb" * 1024 ))
+	sysfs_atomic_max_bytes=$(cat "$queue_path"/atomic_write_max_bytes)
+	sysfs_atomic_unit_max_bytes=$(cat "$queue_path"/atomic_write_unit_max_bytes)
+	sysfs_atomic_unit_min_bytes=$(cat "$queue_path"/atomic_write_unit_min_bytes)
+
+	if [ "$max_hw_bytes" -ge "$sysfs_atomic_max_bytes" ] &&
+		[ "$sysfs_atomic_max_bytes" -ge "$sysfs_atomic_unit_max_bytes" ] &&
+		[ "$sysfs_atomic_unit_max_bytes" -ge "$sysfs_atomic_unit_min_bytes" ]
+	then
+		echo "$test_desc - pass"
+	else
+		echo "$test_desc - fail $max_hw_bytes - $sysfs_max_hw_sectors_kb -" \
+			"$sysfs_atomic_max_bytes - $sysfs_atomic_unit_max_bytes -" \
+			"$sysfs_atomic_unit_min_bytes"
+	fi
+
+	test_desc="TEST 2 - Verify sysfs atomic_write_unit_max_bytes is consistent "
+	test_desc+="with NVMe AWUPF/NAWUPF"
+	nvme_nsfeat=$(nvme id-ns /dev/"${ns_dev}" | grep nsfeat | awk '{ print $3}')
+	nvme_nsabp=$((("$nvme_nsfeat" & 0x2) != 0))
+	if [ "$nvme_nsabp" = 1 ] # Check if NSABP is set
+	then
+		nvme_awupf=$(nvme id-ns /dev/"$ns_dev" | grep nawupf | awk '{ print $3}')
+		atomic_max_bytes=$(( ("$nvme_awupf" + 1) * "$sysfs_logical_block_size" ))
+	else
+		nvme_awupf=$(nvme id-ctrl /dev/"${ctrl_dev}" | grep awupf | awk '{ print $3}')
+		atomic_max_bytes=$(( ("$nvme_awupf" + 1) * "$sysfs_logical_block_size" ))
+	fi
+	if [ "$atomic_max_bytes" -le "$max_hw_bytes" ]
+	then
+		if [ "$atomic_max_bytes" = "$sysfs_atomic_max_bytes" ]
+		then
+			echo "$test_desc - pass"
+		else
+			echo "$test_desc - fail $nvme_nsabp - $atomic_max_bytes - $sysfs_atomic_max_bytes -" \
+				"$max_hw_bytes"
+		fi
+	else
+		if [ "$sysfs_atomic_max_bytes" = "$max_hw_bytes" ]
+		then
+			echo "$test_desc - pass"
+		else
+			echo "$test_desc - fail $nvme_nsabp - $atomic_max_bytes - $sysfs_atomic_max_bytes -" \
+				"$max_hw_bytes"
+		fi
+	fi
+
+	test_desc="TEST 3 - Verify statx is correctly reporting atomic_unit_max_bytes"
+	statx_atomic_max=$(run_xfs_io_xstat /dev/"$ns_dev" "stat.atomic_write_unit_max")
+	if [ "$sysfs_atomic_unit_max_bytes" = "$statx_atomic_max" ]
+	then
+		echo "$test_desc - pass"
+	else
+		echo "$test_desc - fail $statx_atomic_max - $sysfs_atomic_unit_max_bytes"
+	fi
+
+	test_desc="TEST 4 - perform a pwritev2 with size of sysfs_atomic_unit_max_bytes "\
+	test_desc+="with no RWF_ATOMIC"
+	# flag - pwritev2 should be succesful.
+        bytes_written=$(run_xfs_io_pwritev2 /dev/"$ns_dev" "$sysfs_atomic_unit_max_bytes")
+        if [ "$bytes_written" = "$sysfs_atomic_unit_max_bytes" ]
+        then
+                echo "$test_desc - pass"
+        else
+                echo "$test_desc - fail $bytes_written - $sysfs_atomic_unit_max_bytes"
+        fi
+
+	test_desc="TEST 5 - perform a pwritev2 with size of sysfs_atomic_unit_max_bytes with "
+	test_desc+="RWF_ATOMIC flag - pwritev2 should  be succesful"
+	bytes_written=$(run_xfs_io_pwritev2_atomic /dev/"$ns_dev" "$sysfs_atomic_unit_max_bytes")
+	if [ "$bytes_written" = "$sysfs_atomic_unit_max_bytes" ]
+	then
+		echo "$test_desc - pass"
+	else
+		echo "$test_desc - fail $bytes_written - $sysfs_atomic_unit_max_bytes"
+	fi
+
+	test_desc="TEST 6 - perform a pwritev2 with size of sysfs_atomic_unit_max_bytes + 1 logical "
+	test_desc+="block with no RWF_ATOMIC flag - pwritev2 should be succesful"
+	bytes_to_write=$(( "$sysfs_atomic_unit_max_bytes" + "$sysfs_logical_block_size" ))
+	bytes_written=$(run_xfs_io_pwritev2 /dev/"$ns_dev" "$bytes_to_write")
+	if [ "$bytes_written" = "$bytes_to_write" ]
+	then
+		echo "$test_desc - pass"
+	else
+		echo "$test_desc - fail $bytes_written - $bytes_to_write"
+	fi
+
+	test_desc="TEST 7 - perform a pwritev2 with size of sysfs_atomic_unit_max_bytes + logical "
+	test_desc+="block with RWF_ATOMIC flag - pwritev2 should not be succesful"
+	bytes_written=$(run_xfs_io_pwritev2_atomic /dev/"$ns_dev" "$bytes_to_write")
+	if [ "$bytes_written" = "" ]
+	then
+		echo "$test_desc - pass"
+	else
+		echo "$test_desc - fail $bytes_written - $bytes_to_write"
+	fi
+
+	echo "Test complete"
+}
diff --git a/tests/nvme/059.out b/tests/nvme/059.out
new file mode 100644
index 000000000000..e803de35776f
--- /dev/null
+++ b/tests/nvme/059.out
@@ -0,0 +1,10 @@
+Running nvme/059
+TEST 1 - Verify sysfs attributes - pass
+TEST 2 - Verify sysfs atomic_write_unit_max_bytes is consistent with NVMe AWUPF/NAWUPF - pass
+TEST 3 - Verify statx is correctly reporting atomic_unit_max_bytes - pass
+TEST 4 - perform a pwritev2 with size of sysfs_atomic_unit_max_bytes with no RWF_ATOMIC - pass
+TEST 5 - perform a pwritev2 with size of sysfs_atomic_unit_max_bytes with RWF_ATOMIC flag - pwritev2 should  be succesful - pass
+TEST 6 - perform a pwritev2 with size of sysfs_atomic_unit_max_bytes + 1 logical block with no RWF_ATOMIC flag - pwritev2 should be succesful - pass
+pwrite: Invalid argument
+TEST 7 - perform a pwritev2 with size of sysfs_atomic_unit_max_bytes + logical block with RWF_ATOMIC flag - pwritev2 should not be succesful - pass
+Test complete
-- 
2.43.5

