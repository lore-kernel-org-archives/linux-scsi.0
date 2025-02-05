Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9F28215176;
	Wed,  5 Feb 2025 23:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738796556; cv=none; b=H7zG8B+dBjL753V+wZrg871scceLxjvdH2EfuhwW2RdN/wCrVFiH0zXUh0nwbPEOR/recXF2VoB8L0Qr57VkdnhCZnM7fY7O2bwQYYEIEuAgCVSSVoeD8xZ5IrijwewSSuqIXDVp4ADX4qQtUozcV6RRkrviyHOuEkaV40F3Vck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738796556; c=relaxed/simple;
	bh=cp+p/NRgcu9XI+ixbYJpQ7sLc3HwfVcNwRe8iB2fd5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k/uPQ+NGP+jRlZyVM3D+9/68s0bKuTK/a2b0r9Mrg/0UVBdtfqM+N6lsWAbCP57xl6/ukuS0t+XIl0GpcQZz6oYxflHvlO7plIkKWSsf3k6jNqV/UEZKm8XKUI8TDEodwUD22q3wWuRQ3Ehc+a7um72AdkPO/im56nlber7URX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=cKD0W1NP; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cKD0W1NP"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 515N15Dc009518;
	Wed, 5 Feb 2025 23:02:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2023-11-20; bh=vw+9q
	MusOrDDnEO0NKnpytKkXfp/W4mbSKIt8xbYN7Y=; b=cKD0W1NP5S2Lt0Jjj45pL
	/1tuVPryNQKvNbp837lA/qVpT5OrdKjnt0IjFfRzV4hPmeo/3alYC9XQO6L4fZU3
	7NNaWpRvC/CqIkWAcv9ivYQsrrkXt8IS98XSI4ZDpW92ZBVYLJZ9orDYkq7rKN9b
	y4fw0wTfJ6PYTkFb6Nv9IOc6oB+79hdlSQwF3uFl35E50PYJZSOVqve01dnJCopl
	Y+R3q8DkPGffiNrYAeJ2J7Rt/xmmf+mM+OF9He3+TRc1GXZbU6h6AwVslBGr5U7f
	0C2HccEdU4tRynzGxfHfoyC3TqHqiqNoeZyPxEFNFcWea02EXxCaPmiEsqnzF9/F
	w==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44m50u9jnw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Feb 2025 23:02:30 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 515Ll3kw022622;
	Wed, 5 Feb 2025 23:02:29 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44j8e9r5n1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Feb 2025 23:02:28 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 515N2Rfk040085;
	Wed, 5 Feb 2025 23:02:28 GMT
Received: from ca-dev94.us.oracle.com (ca-dev94.us.oracle.com [10.129.136.30])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 44j8e9r5m8-2;
	Wed, 05 Feb 2025 23:02:28 +0000
From: Alan Adamson <alan.adamson@oracle.com>
To: linux-block@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, alan.adamson@oracle.com,
        linux-nvme@lists.infradead.org, shinichiro.kawasaki@wdc.com
Subject: [PATCH v3 blktests 1/2] scsi/009: add atomic write tests
Date: Wed,  5 Feb 2025 15:10:59 -0800
Message-ID: <20250205231100.391005-2-alan.adamson@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250205231100.391005-1-alan.adamson@oracle.com>
References: <20250205231100.391005-1-alan.adamson@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-05_08,2025-02-05_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2501170000 definitions=main-2502050176
X-Proofpoint-GUID: rXzr4b7jsRgsFaoyv5OTYGokqAn4qNE8
X-Proofpoint-ORIG-GUID: rXzr4b7jsRgsFaoyv5OTYGokqAn4qNE8

Tests basic atomic write functionality. If no scsi test device is provided,
a scsi_debug device will be used. Testing areas include:

- Verify sysfs atomic write attributes are consistent with
  atomic write attributes advertised by scsi_debug.
- Verify the atomic write paramters of statx are correct using
  xfs_io.
- Perform a pwritev2() (with and without RWF_ATOMIC flag) using
  xfs_io:
    - maximum byte size (atomic_write_unit_max_bytes)
    - minimum byte size (atomic_write_unit_min_bytes)
    - a write larger than atomic_write_unit_max_bytes
    - a write smaller than atomic_write_unit_min_bytes

Signed-off-by: Alan Adamson <alan.adamson@oracle.com>
---
 common/rc          |   8 ++
 common/xfs         |  58 ++++++++++++
 tests/scsi/009     | 229 +++++++++++++++++++++++++++++++++++++++++++++
 tests/scsi/009.out |  18 ++++
 4 files changed, 313 insertions(+)
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
index 000000000000..b114d92dd3db
--- /dev/null
+++ b/tests/scsi/009
@@ -0,0 +1,229 @@
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
+	test_desc="TEST 7 - perform a pwritev2 with size of sysfs_atomic_unit_max_bytes "
+	test_desc+="with no RWF_ATOMIC flag - pwritev2 should be succesful"
+	bytes_written=$(run_xfs_io_pwritev2 "$TEST_DEV" "$sysfs_atomic_unit_max_bytes")
+	if [ "$bytes_written" = "$sysfs_atomic_unit_max_bytes" ]
+	then
+		echo "$test_desc - pass"
+	else
+		echo "$test_desc - fail $bytes_written - $sysfs_atomic_unit_max_bytes"
+	fi
+
+	test_desc="TEST 8 - perform a pwritev2 with size of sysfs_atomic_unit_max_bytes with "
+	test_desc+="RWF_ATOMIC flag - pwritev2 should be succesful"
+	bytes_written=$(run_xfs_io_pwritev2_atomic "$TEST_DEV" "$sysfs_atomic_unit_max_bytes")
+	if [ "$bytes_written" = "$sysfs_atomic_unit_max_bytes" ]
+	then
+		echo "$test_desc - pass"
+	else
+		echo "$test_desc - fail $bytes_written - $sysfs_atomic_unit_max_bytes"
+	fi
+
+	test_desc="TEST 9 - perform a pwritev2 with size of sysfs_atomic_unit_max_bytes + 512 "
+	test_desc+="bytes with no RWF_ATOMIC flag - pwritev2 should be succesful"
+	bytes_to_write=$(( "${sysfs_atomic_unit_max_bytes}" + "$sysfs_logical_block_size" ))
+	bytes_written=$(run_xfs_io_pwritev2 "$TEST_DEV" "$bytes_to_write")
+	if [ "$bytes_written" = "$bytes_to_write" ]
+	then
+		echo "$test_desc - pass"
+	else
+		echo "$test_desc - fail $bytes_written - $bytes_to_write"
+	fi
+
+	test_desc="TEST 10 - perform a pwritev2 with size of sysfs_atomic_unit_max_bytes + 512 "
+	test_desc+="bytes with RWF_ATOMIC flag - pwritev2 should not be succesful"
+	bytes_written=$(run_xfs_io_pwritev2_atomic "$TEST_DEV" "$bytes_to_write")
+	if [ "$bytes_written" = "" ]
+	then
+		echo "$test_desc - pass"
+	else
+		echo "$test_desc - fail $bytes_written - $bytes_to_write"
+	fi
+
+	test_desc="TEST 11 - perform a pwritev2 with size of sysfs_atomic_unit_min_bytes "
+	test_desc+="with no RWF_ATOMIC flag - pwritev2 should be succesful"
+	bytes_written=$(run_xfs_io_pwritev2 "$TEST_DEV" "$sysfs_atomic_unit_min_bytes")
+	if [ "$bytes_written" = "$sysfs_atomic_unit_min_bytes" ]
+	then
+		echo "$test_desc - pass"
+	else
+		echo "$test_desc - fail $bytes_written - $scsi_atomic_min_bytes"
+	fi
+
+	test_desc="TEST 12 - perform a pwritev2 with size of sysfs_atomic_unit_min_bytes "
+	test_desc+="with RWF_ATOMIC flag - pwritev2 should be succesful"
+	bytes_written=$(run_xfs_io_pwritev2_atomic "$TEST_DEV" "$sysfs_atomic_unit_min_bytes")
+	if [ "$bytes_written" = "$sysfs_atomic_unit_min_bytes" ]
+	then
+		echo "$test_desc - pass"
+	else
+		echo "$test_desc - fail $bytes_written - $scsi_atomic_min_bytes"
+	fi
+
+	test_desc="TEST 13 - perform a pwritev2 with a size of sysfs_atomic_unit_min_bytes - 512 "
+	test_desc+="bytes with no RWF_ATOMIC flag - pwritev2 should be succesful"
+	bytes_to_write=$(( "${sysfs_atomic_unit_min_bytes}" - "${sysfs_logical_block_size}" ))
+	if [ "$bytes_to_write" = 0 ]
+	then
+		echo "$test_desc - pass"
+		echo "pwrite: Invalid argument"
+	else
+		bytes_written=$(run_xfs_io_pwritev2 "$TEST_DEV" "$bytes_to_write")
+		if [ "$bytes_written" = "$bytes_to_write" ]
+		then
+			echo "$test_desc - pass"
+		else
+			echo "$test_desc - fail $bytes_written - $bytes_to_write"
+		fi
+	fi
+	test_desc="TEST 14 - perform a pwritev2 with a size of sysfs_atomic_unit_min_bytes - 512 "
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
index 000000000000..e31416b93515
--- /dev/null
+++ b/tests/scsi/009.out
@@ -0,0 +1,18 @@
+Running scsi/009
+TEST 1 - Verify sysfs atomic attributes - pass
+TEST 2 - check scsi_debug atomic_wr_max_length is the same as sysfs atomic_write_max_bytes - pass
+TEST 3 - check sysfs atomic_write_unit_max_bytes <= scsi_debug atomic_wr_max_length - pass
+TEST 4 - check sysfs atomic_write_unit_min_bytes = scsi_debug atomic_wr_gran - pass
+TEST 5 - check statx stx_atomic_write_unit_min - pass
+TEST 6 - check statx stx_atomic_write_unit_max - pass
+TEST 7 - perform a pwritev2 with size of sysfs_atomic_unit_max_bytes with no RWF_ATOMIC flag - pwritev2 should be succesful - pass
+TEST 8 - perform a pwritev2 with size of sysfs_atomic_unit_max_bytes with RWF_ATOMIC flag - pwritev2 should be succesful - pass
+TEST 9 - perform a pwritev2 with size of sysfs_atomic_unit_max_bytes + 512 bytes with no RWF_ATOMIC flag - pwritev2 should be succesful - pass
+pwrite: Invalid argument
+TEST 10 - perform a pwritev2 with size of sysfs_atomic_unit_max_bytes + 512 bytes with RWF_ATOMIC flag - pwritev2 should not be succesful - pass
+TEST 11 - perform a pwritev2 with size of sysfs_atomic_unit_min_bytes with no RWF_ATOMIC flag - pwritev2 should be succesful - pass
+TEST 12 - perform a pwritev2 with size of sysfs_atomic_unit_min_bytes with RWF_ATOMIC flag - pwritev2 should be succesful - pass
+TEST 13 - perform a pwritev2 with a size of sysfs_atomic_unit_min_bytes - 512 bytes with no RWF_ATOMIC flag - pwritev2 should be succesful - pass
+pwrite: Invalid argument
+TEST 14 - perform a pwritev2 with a size of sysfs_atomic_unit_min_bytes - 512 bytes with RWF_ATOMIC flag - pwritev2 should fail - pass
+Test complete
-- 
2.43.5

