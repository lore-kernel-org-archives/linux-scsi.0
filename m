Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3693D1D07BA;
	Fri,  7 Feb 2025 23:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738972052; cv=none; b=IcWiPFb8wwaaxV9NBMKv6S2fnLnK5eIpirvnR598GSgJccd2nulziDQSxsuRTMPSgSxXF18Qb/Y07CY4R2ekCQ2xtTjroSI5j4O3AxN+Jjy6fO9681sOMX3pUTbUF6HbTen46bCzVoX9IIXhI4xwcQxwLRK4FBwSP/Gfxal66p4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738972052; c=relaxed/simple;
	bh=BsfMoCm8MlH9AGBmYNmCYjQDHjlTEQKUiZ1QFLAvexw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z+CKu0srCJFie9D+LLqI7fj4ZrjW80OST0kr6b/uP3tutTh3FGhCTSK8BKXDBnY/rV+S+MmyyuderpJFt0QKzyVs6zVJw5LVWnMr0zJLEHo6K156wax3T11KzgCRNPyPqxgtA1duB+prxVqrZaSOIkgNqY8ODn/g08/L1hl2IhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=gnGNesvQ; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gnGNesvQ"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 517Lfpli021110;
	Fri, 7 Feb 2025 23:47:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2023-11-20; bh=h3F4n
	/vhHMvSO3obC0vk2jEC+nX67L/UDUxic2UBdIM=; b=gnGNesvQzs21a5mB0/RLK
	j6HBXnSml/dtr5aHgea/c1aM3OB3tgg+wcQxpQsOrzfvSf9V21XOeJBM5siscoWJ
	4xfjKVK6fw3LK+k5cvn8xzyLqYXCbEtMhT2q3aYvhNY88zpy2MPKAczWJ9ckC6wV
	WvmsCRgt5CRb8FFCGuMSFdMtFYDrGESCtfIfFFAf+DURCgsXEryhgtzQyhgz9lyv
	WvnwdpHNfaQXrJbvzrR8C/AfmB2xOx5pZY4jgknldBBfmUuPV+BH6B6YxDgjY9PL
	wXhJMX2tlRrk0ncrOW2PZCFQgk0H7LS3LmTASKRCXlbZjTaNGWbnwWFgUF/e3MiJ
	w==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44n0fsjs3e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 07 Feb 2025 23:47:24 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 517LUNdR027912;
	Fri, 7 Feb 2025 23:47:23 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 44j8ds5wsn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 07 Feb 2025 23:47:23 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 517NlMLh001803;
	Fri, 7 Feb 2025 23:47:22 GMT
Received: from ca-dev94.us.oracle.com (ca-dev94.us.oracle.com [10.129.136.30])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 44j8ds5ws8-2;
	Fri, 07 Feb 2025 23:47:22 +0000
From: Alan Adamson <alan.adamson@oracle.com>
To: linux-block@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, alan.adamson@oracle.com,
        linux-nvme@lists.infradead.org, shinichiro.kawasaki@wdc.com
Subject: [PATCH v4 blktests 1/2] scsi/009: add atomic write tests
Date: Fri,  7 Feb 2025 15:55:52 -0800
Message-ID: <20250207235553.322741-2-alan.adamson@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250207235553.322741-1-alan.adamson@oracle.com>
References: <20250207235553.322741-1-alan.adamson@oracle.com>
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
X-Proofpoint-ORIG-GUID: BB6kOXk3n0dtv1s7Txzy0It0GS8Gtfs4
X-Proofpoint-GUID: BB6kOXk3n0dtv1s7Txzy0It0GS8Gtfs4

Tests basic atomic write functionality. If no scsi test device is provided,
a scsi_debug device will be used. Testing areas include:

- Verify sysfs atomic write attributes are consistent with
  atomic write attributes advertised by scsi_debug.
- Verify the atomic write paramters of statx are correct using
  xfs_io.
- Perform a pwritev2() (with RWF_ATOMIC flag) using xfs_io:
    - maximum byte size (atomic_write_unit_max_bytes)
    - minimum byte size (atomic_write_unit_min_bytes)
    - a write larger than atomic_write_unit_max_bytes
    - a write smaller than atomic_write_unit_min_bytes

Signed-off-by: Alan Adamson <alan.adamson@oracle.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
---
 common/rc          |   8 ++
 common/xfs         |  58 ++++++++++++++
 tests/scsi/009     | 183 +++++++++++++++++++++++++++++++++++++++++++++
 tests/scsi/009.out |  13 ++++
 4 files changed, 262 insertions(+)
 create mode 100755 tests/scsi/009
 create mode 100644 tests/scsi/009.out

diff --git a/common/rc b/common/rc
index bcb215d35114..06c0a416e3e1 100644
--- a/common/rc
+++ b/common/rc
@@ -292,6 +292,14 @@ _require_test_dev_can_discard() {
 	return 0
 }
 
+_require_device_support_atomic_writes() {
+	_require_test_dev_sysfs queue/atomic_write_max_bytes
+	if (( $(< "${TEST_DEV_SYSFS}"/queue/atomic_write_max_bytes) == 0 )); then
+		SKIP_REASONS+=("${TEST_DEV} does not support atomic write")
+		return 1
+	fi
+}
+
 _test_dev_queue_get() {
 	if [[ $1 = scheduler ]]; then
 		sed -e 's/.*\[//' -e 's/\].*//' "${TEST_DEV_SYSFS}/queue/scheduler"
diff --git a/common/xfs b/common/xfs
index 569770fecd53..0b1ca7c29049 100644
--- a/common/xfs
+++ b/common/xfs
@@ -6,6 +6,22 @@
 
 . common/shellcheck
 
+_have_xfs_io_atomic_write() {
+	local s
+
+	_have_program xfs_io || return $?
+
+	# If the pwrite command supports the -A option then this version
+	# of xfs_io supports atomic writes.
+	s=$(xfs_io -c help | grep pwrite | awk '{ print $4}')
+	if [[ $s == *"A"* ]];
+	then
+		return 0
+	fi
+	SKIP_REASONS+=("xfs_io does not support the -A option")
+	return 1
+}
+
 _have_xfs() {
 	_have_fs xfs && _have_program mkfs.xfs
 }
@@ -52,3 +68,45 @@ _xfs_run_fio_verify_io() {
 
 	return "${rc}"
 }
+
+# Use xfs_io to perform a non-atomic write using pwritev2().
+# Args:    $1 - device to write to
+#          $2 - number of bytes to write
+# Returns: Number of bytes written
+run_xfs_io_pwritev2() {
+	local dev=$1
+	local bytes_to_write=$2
+	local bytes_written
+
+	# Perform write and extract out bytes written from xfs_io output
+	bytes_written=$(xfs_io -d -C \
+		"pwrite -b ${bytes_to_write} -V 1 -D 0 ${bytes_to_write}" \
+		"$dev" | grep "wrote" | sed 's/\// /g' | awk '{ print $2 }')
+	echo "$bytes_written"
+}
+
+# Use xfs_io to perform an atomic write using pwritev2().
+# Args:    $1 - device to write to
+#          $2 - number of bytes to write
+# Returns: Number of bytes written
+run_xfs_io_pwritev2_atomic() {
+	local dev=$1
+	local bytes_to_write=$2
+	local bytes_written
+
+	# Perform atomic write and extract out bytes written from xfs_io output
+	bytes_written=$(xfs_io -d -C \
+		"pwrite -b ${bytes_to_write} -V 1 -A -D 0 ${bytes_to_write}" \
+		"$dev" | grep "wrote" | sed 's/\// /g' | awk '{ print $2 }')
+	echo "$bytes_written"
+}
+
+run_xfs_io_xstat() {
+	local dev=$1
+	local field=$2
+	local statx_output
+
+	statx_output=$(xfs_io -c "statx -r -m 0x00010000" "$dev" | \
+		grep "$field" | awk '{ print $3 }')
+	echo "$statx_output"
+}
diff --git a/tests/scsi/009 b/tests/scsi/009
new file mode 100755
index 000000000000..8860e1c0d072
--- /dev/null
+++ b/tests/scsi/009
@@ -0,0 +1,183 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-3.0+
+# Copyright (C) 2025 Oracle and/or its affiliates
+#
+# Test SCSI Atomic Writes with scsi_debug
+
+. tests/scsi/rc
+. common/scsi_debug
+. common/xfs
+
+DESCRIPTION="test scsi atomic writes"
+QUICK=1
+
+requires() {
+	_have_driver scsi_debug
+	_have_xfs_io_atomic_write
+}
+
+device_requires() {
+	_require_device_support_atomic_writes
+}
+
+fallback_device() {
+	local scsi_debug_params=(
+		delay=0
+		atomic_wr=1
+	)
+	if ! _configure_scsi_debug "${scsi_debug_params[@]}"; then
+		return 1
+		fi
+	echo "/dev/${SCSI_DEBUG_DEVICES[0]}"
+}
+
+cleanup_fallback_device() {
+	_exit_scsi_debug
+}
+
+test_device() {
+	local scsi_debug_atomic_wr_max_length
+	local scsi_debug_atomic_wr_gran
+	local scsi_atomic_max_bytes
+	local scsi_atomic_min_bytes
+	local sysfs_max_hw_sectors_kb
+	local max_hw_bytes
+	local sysfs_logical_block_size
+	local sysfs_atomic_max_bytes
+	local sysfs_atomic_unit_max_bytes
+	local sysfs_atomic_unit_min_bytes
+	local statx_atomic_min
+	local statx_atomic_max
+	local bytes_to_write
+	local bytes_written
+	local test_desc
+
+	echo "Running ${TEST_NAME}"
+
+	sysfs_logical_block_size=$(< "${TEST_DEV_SYSFS}"/queue/logical_block_size)
+	sysfs_max_hw_sectors_kb=$(< "${TEST_DEV_SYSFS}"/queue/max_hw_sectors_kb)
+	max_hw_bytes=$(( "$sysfs_max_hw_sectors_kb" * 1024 ))
+	sysfs_atomic_max_bytes=$(< "${TEST_DEV_SYSFS}"/queue/atomic_write_max_bytes)
+	sysfs_atomic_unit_max_bytes=$(< "${TEST_DEV_SYSFS}"/queue/atomic_write_unit_max_bytes)
+	sysfs_atomic_unit_min_bytes=$(< "${TEST_DEV_SYSFS}"/queue/atomic_write_unit_min_bytes)
+	scsi_debug_atomic_wr_max_length=$(< /sys/module/scsi_debug/parameters/atomic_wr_max_length)
+	scsi_debug_atomic_wr_gran=$(< /sys/module/scsi_debug/parameters/atomic_wr_gran)
+	scsi_atomic_max_bytes=$(( "$scsi_debug_atomic_wr_max_length" * "$sysfs_logical_block_size" ))
+	scsi_atomic_min_bytes=$(( "$scsi_debug_atomic_wr_gran" * "$sysfs_logical_block_size" ))
+
+	test_desc="TEST 1 - Verify sysfs atomic attributes"
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
+	test_desc="TEST 2 - check scsi_debug atomic_wr_max_length is the same as sysfs atomic_write_max_bytes"
+	if [ "$scsi_atomic_max_bytes" -le "$max_hw_bytes" ]
+	then
+		if [ "$scsi_atomic_max_bytes" = "$sysfs_atomic_max_bytes" ]
+		then
+			echo "$test_desc - pass"
+		else
+			echo "$test_desc - fail $scsi_atomic_max_bytes - $max_hw_bytes -" \
+				"$sysfs_atomic_max_bytes"
+		fi
+	else
+		if [ "$sysfs_atomic_max_bytes" = "$max_hw_bytes" ]
+		then
+			echo "$test_desc - pass"
+		else
+			echo "$test_desc - fail $scsi_atomic_max_bytes - $max_hw_bytes -" \
+				"$sysfs_atomic_max_bytes"
+		fi
+	fi
+
+	test_desc="TEST 3 - check sysfs atomic_write_unit_max_bytes <= scsi_debug atomic_wr_max_length"
+	if (("$sysfs_atomic_unit_max_bytes" <= "$scsi_atomic_max_bytes"))
+	then
+		echo "$test_desc - pass"
+	else
+		echo "$test_desc - fail $sysfs_atomic_unit_max_bytes - $scsi_atomic_max_bytes"
+	fi
+
+	test_desc="TEST 4 - check sysfs atomic_write_unit_min_bytes = scsi_debug atomic_wr_gran"
+	if [ "$sysfs_atomic_unit_min_bytes" = "$scsi_atomic_min_bytes" ]
+	then
+		echo "$test_desc - pass"
+	else
+		echo "$test_desc - fail $sysfs_atomic_unit_min_bytes - $scsi_atomic_min_bytes"
+	fi
+
+	test_desc="TEST 5 - check statx stx_atomic_write_unit_min"
+	statx_atomic_min=$(run_xfs_io_xstat "$TEST_DEV" "stat.atomic_write_unit_min")
+	if [ "$statx_atomic_min" = "$scsi_atomic_min_bytes" ]
+	then
+		echo "$test_desc - pass"
+	else
+		echo "$test_desc - fail $statx_atomic_min - $scsi_atomic_min_bytes"
+	fi
+
+	test_desc="TEST 6 - check statx stx_atomic_write_unit_max"
+	statx_atomic_max=$(run_xfs_io_xstat "$TEST_DEV" "stat.atomic_write_unit_max")
+	if [ "$statx_atomic_max" = "$sysfs_atomic_unit_max_bytes" ]
+	then
+		echo "$test_desc - pass"
+	else
+		echo "$test_desc - fail $statx_atomic_max - $sysfs_atomic_unit_max_bytes"
+	fi
+
+	test_desc="TEST 7 - perform a pwritev2 with size of sysfs_atomic_unit_max_bytes with "
+	test_desc+="RWF_ATOMIC flag - pwritev2 should be succesful"
+	bytes_written=$(run_xfs_io_pwritev2_atomic "$TEST_DEV" "$sysfs_atomic_unit_max_bytes")
+	if [ "$bytes_written" = "$sysfs_atomic_unit_max_bytes" ]
+	then
+		echo "$test_desc - pass"
+	else
+		echo "$test_desc - fail $bytes_written - $sysfs_atomic_unit_max_bytes"
+	fi
+
+	test_desc="TEST 8 - perform a pwritev2 with size of sysfs_atomic_unit_max_bytes + 512 "
+	test_desc+="bytes with RWF_ATOMIC flag - pwritev2 should not be succesful"
+	bytes_written=$(run_xfs_io_pwritev2_atomic "$TEST_DEV" "$bytes_to_write")
+	if [ "$bytes_written" = "" ]
+	then
+		echo "$test_desc - pass"
+	else
+		echo "$test_desc - fail $bytes_written - $bytes_to_write"
+	fi
+
+	test_desc="TEST 9 - perform a pwritev2 with size of sysfs_atomic_unit_min_bytes "
+	test_desc+="with RWF_ATOMIC flag - pwritev2 should be succesful"
+	bytes_written=$(run_xfs_io_pwritev2_atomic "$TEST_DEV" "$sysfs_atomic_unit_min_bytes")
+	if [ "$bytes_written" = "$sysfs_atomic_unit_min_bytes" ]
+	then
+		echo "$test_desc - pass"
+	else
+		echo "$test_desc - fail $bytes_written - $scsi_atomic_min_bytes"
+	fi
+
+	bytes_to_write=$(( "${sysfs_atomic_unit_min_bytes}" - "${sysfs_logical_block_size}" ))
+	test_desc="TEST 10 - perform a pwritev2 with a size of sysfs_atomic_unit_min_bytes - 512 "
+	test_desc+="bytes with RWF_ATOMIC flag - pwritev2 should fail"
+	if [ "$bytes_to_write" = 0 ]
+	then
+		echo "$test_desc - pass"
+	else
+		bytes_written=$(run_xfs_io_pwritev2_atomic "$TEST_DEV" "$bytes_to_write")
+		if [ "$bytes_written" = "" ]
+		then
+			echo "$test_desc - pass"
+		else
+			echo "$test_desc - fail $bytes_written - $bytes_to_write"
+		fi
+	fi
+
+	_exit_scsi_debug
+
+	echo "Test complete"
+}
diff --git a/tests/scsi/009.out b/tests/scsi/009.out
new file mode 100644
index 000000000000..e94882d44f60
--- /dev/null
+++ b/tests/scsi/009.out
@@ -0,0 +1,13 @@
+Running scsi/009
+TEST 1 - Verify sysfs atomic attributes - pass
+TEST 2 - check scsi_debug atomic_wr_max_length is the same as sysfs atomic_write_max_bytes - pass
+TEST 3 - check sysfs atomic_write_unit_max_bytes <= scsi_debug atomic_wr_max_length - pass
+TEST 4 - check sysfs atomic_write_unit_min_bytes = scsi_debug atomic_wr_gran - pass
+TEST 5 - check statx stx_atomic_write_unit_min - pass
+TEST 6 - check statx stx_atomic_write_unit_max - pass
+TEST 7 - perform a pwritev2 with size of sysfs_atomic_unit_max_bytes with RWF_ATOMIC flag - pwritev2 should be succesful - pass
+TEST 8 - perform a pwritev2 with size of sysfs_atomic_unit_max_bytes + 512 bytes with RWF_ATOMIC flag - pwritev2 should not be succesful - pass
+TEST 9 - perform a pwritev2 with size of sysfs_atomic_unit_min_bytes with RWF_ATOMIC flag - pwritev2 should be succesful - pass
+pwrite: Invalid argument
+TEST 10 - perform a pwritev2 with a size of sysfs_atomic_unit_min_bytes - 512 bytes with RWF_ATOMIC flag - pwritev2 should fail - pass
+Test complete
-- 
2.43.5

