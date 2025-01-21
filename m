Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7DC21F55F0;
	Tue, 21 Jan 2025 22:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737497830; cv=none; b=ReIwt6IFVNDysZYyr6d8LXsZPzcKVs7obBmf1mf3De6H0YqKb/Q54iqG2+RmXTPCpkTxP9Dc1DRRvcQRcNmFna/sAgVymZApfVpX4RvmASTEhY8HVm4O2mt6BBlrS6eHqTYUe0zeCd1G/S2AkSqOXf0aQ5I8Ul/kZDSftKuvet4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737497830; c=relaxed/simple;
	bh=L9EoVIzqI66m0qLUUtVanwo5iLs2jOM9eqiGnfZoWDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g8vYWx7yIFvADtIPt6vNiJv3lWUcFUlEW7USJS8/VSYzYp+xcNT05B0ov0asYrWVsP+1h5JthvmVxFov46B35+prRM5mXnsUxHQIXsgoipaBZB3R/e67qOHi2q7VTZDRrOhDZr7+inF+pyUl1FPpgFjNaBj39aRFiZVvRzgcA+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=a5TAMcLp; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="a5TAMcLp"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50LJJpts025786;
	Tue, 21 Jan 2025 22:17:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2023-11-20; bh=eeoKo
	5pIDZXXfD/iekN9uaMyPDVcVGUfQqTraAFmm/8=; b=a5TAMcLp8uGmJkXrNFlv9
	UlmH71Y4Rl9AZd6PMji5aMue3sQgAEkZQqxwapr13599bnpK6zvCmTnY0aDsMKCh
	ZqeJWkoALJgcXQkJdINWgNgvcyHd639w4V8IoevmflOizXeYSfCRV20yxf98OYmJ
	2LtCqm3gaQwZszMlkyOspyEmZt2FAR7MGwaFzrv6eYJjkvB3G3udZj5V4Ys7obEL
	ybDYkGcTHXOd3/jNCgaE9iaq1FO5kr44TO+vqbfn3JYWP0yDuq82lFyCE6k7xxzC
	7ewNnYuMLSZatGckjj4bldq+5NahLK11yGaHVHyjXlB7iTK5BLicPqiQym/GU6kC
	g==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4485qkxgsk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Jan 2025 22:17:03 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50LM39cX036432;
	Tue, 21 Jan 2025 22:17:02 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44917q44wd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Jan 2025 22:17:02 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 50LMH1S1022589;
	Tue, 21 Jan 2025 22:17:02 GMT
Received: from ca-dev94.us.oracle.com (ca-dev94.us.oracle.com [10.129.136.30])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 44917q44vy-2;
	Tue, 21 Jan 2025 22:17:01 +0000
From: Alan Adamson <alan.adamson@oracle.com>
To: linux-block@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, alan.adamson@oracle.com,
        linux-nvme@lists.infradead.org, shinichiro.kawasaki@wdc.com
Subject: [PATCH blktests 1/2] scsi/009: add atomic write tests
Date: Tue, 21 Jan 2025 14:25:29 -0800
Message-ID: <20250121222530.2824516-2-alan.adamson@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250121222530.2824516-1-alan.adamson@oracle.com>
References: <20250121222530.2824516-1-alan.adamson@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-21_09,2025-01-21_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501210177
X-Proofpoint-GUID: CKWtBIgCWNmaayAV6xVfHSSRlw7CJHXn
X-Proofpoint-ORIG-GUID: CKWtBIgCWNmaayAV6xVfHSSRlw7CJHXn

Uses scsi_debug to test basic atomic write functionality. Testing
areas include:

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
 common/xfs         |  49 +++++++++++
 tests/scsi/009     | 213 +++++++++++++++++++++++++++++++++++++++++++++
 tests/scsi/009.out |  18 ++++
 3 files changed, 280 insertions(+)
 create mode 100755 tests/scsi/009
 create mode 100644 tests/scsi/009.out

diff --git a/common/xfs b/common/xfs
index 569770fecd53..284c6d7cdc40 100644
--- a/common/xfs
+++ b/common/xfs
@@ -6,6 +6,28 @@
 
 . common/shellcheck
 
+_have_xfs_io() {
+	if ! _have_program xfs_io; then
+		return 1
+	fi
+	return 0
+}
+
+# Check whether the version of xfs_io is greater than or equal to $1.$2.$3
+_have_xfs_io_ver() {
+	local d=$1 e=$2 f=$3
+
+	_have_xfs_io || return $?
+
+	IFS='.' read -r a b c < <(xfs_io -V | sed 's/xfs_io version *//')
+	if [ $((a * 65536 + b * 256 + c)) -lt $((d * 65536 + e * 256 + f)) ];
+	then
+		SKIP_REASONS+=("xfs_io version too old")
+		return 1
+	fi
+	return 0
+}
+
 _have_xfs() {
 	_have_fs xfs && _have_program mkfs.xfs
 }
@@ -52,3 +74,30 @@ _xfs_run_fio_verify_io() {
 
 	return "${rc}"
 }
+
+run_xfs_io_pwritev2() {
+	local dev=$1
+	local bytes_to_write=$2
+	local bytes_written
+
+	bytes_written=$(xfs_io -d -C "pwrite -b ${bytes_to_write} -V 1 -D 0 ${bytes_to_write}" "$dev" | grep "wrote" | sed 's/\// /g' | awk '{ print $2 }')
+	echo "$bytes_written"
+}
+
+run_xfs_io_pwritev2_atomic() {
+	local dev=$1
+	local bytes_to_write=$2
+	local bytes_written
+
+	bytes_written=$(xfs_io -d -C "pwrite -b ${bytes_to_write} -V 1 -A -D 0 ${bytes_to_write}" "$dev" | grep "wrote" | sed 's/\// /g' | awk '{ print $2 }')
+	echo "$bytes_written"
+}
+
+run_xfs_io_xstat() {
+	local dev=$1
+	local field=$2
+	local statx_output
+
+	statx_output=$(xfs_io -c "statx -r -m 0x00010000" "$dev" | grep "$field" | awk '{ print $3 }')
+	echo "$statx_output"
+}
diff --git a/tests/scsi/009 b/tests/scsi/009
new file mode 100755
index 000000000000..f3ab00f61369
--- /dev/null
+++ b/tests/scsi/009
@@ -0,0 +1,213 @@
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
+	_have_kver 6 11
+	_have_xfs_io_ver 6 12 0
+}
+
+test() {
+	local dev
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
+
+	echo "Running ${TEST_NAME}"
+
+	local scsi_debug_params=(
+		delay=0
+		atomic_wr=1
+	)
+	_configure_scsi_debug "${scsi_debug_params[@]}"
+	dev="/dev/${SCSI_DEBUG_DEVICES[0]}"
+	sysfs_logical_block_size=$(cat /sys/block/"${SCSI_DEBUG_DEVICES[0]}"/queue/logical_block_size)
+	sysfs_max_hw_sectors_kb=$(cat /sys/block/"${SCSI_DEBUG_DEVICES[0]}"/queue/max_hw_sectors_kb)
+	max_hw_bytes=$(( "$sysfs_max_hw_sectors_kb" * 1024 ))
+	sysfs_atomic_max_bytes=$(cat /sys/block/"${SCSI_DEBUG_DEVICES[0]}"/queue/atomic_write_max_bytes)
+	sysfs_atomic_unit_max_bytes=$(cat /sys/block/"${SCSI_DEBUG_DEVICES[0]}"/queue/atomic_write_unit_max_bytes)
+	sysfs_atomic_unit_min_bytes=$(cat /sys/block/"${SCSI_DEBUG_DEVICES[0]}"/queue/atomic_write_unit_min_bytes)
+	scsi_debug_atomic_wr_max_length=$(cat /sys/module/scsi_debug/parameters/atomic_wr_max_length)
+	scsi_debug_atomic_wr_gran=$(cat /sys/module/scsi_debug/parameters/atomic_wr_gran)
+	scsi_atomic_max_bytes=$(( "$scsi_debug_atomic_wr_max_length" * "$sysfs_logical_block_size" ))
+	scsi_atomic_min_bytes=$(( "$scsi_debug_atomic_wr_gran" * "$sysfs_logical_block_size" ))
+
+	# TEST 1 - Verify sysfs atomic attributes
+	if [ "$max_hw_bytes" -ge "$sysfs_atomic_max_bytes" ] &&
+		[ "$sysfs_atomic_max_bytes" -ge "$sysfs_atomic_unit_max_bytes" ] &&
+		[ "$sysfs_atomic_unit_max_bytes" -ge "$sysfs_atomic_unit_min_bytes" ]
+	then
+		echo "TEST 1 - pass"
+	else
+		"TEST 1 - fail $max_hw_bytes - $sysfs_max_hw_sectors_kb -" \
+			"$sysfs_atomic_max_bytes - $sysfs_atomic_unit_max_bytes -" \
+			"$sysfs_atomic_unit_min_bytes"
+	fi
+
+	# TEST 2 - check scsi_debug atomic_wr_max_length is the same as sysfs atomic_write_max_bytes
+	if [ "$scsi_atomic_max_bytes" -le "$max_hw_bytes" ]
+	then
+		if [ "$scsi_atomic_max_bytes" = "$sysfs_atomic_max_bytes" ]
+		then
+			echo "TEST 2 - pass"
+		else
+			echo "TEST 2 - fail $scsi_atomic_max_bytes - $max_hw_bytes -" \
+				"$sysfs_atomic_max_bytes"
+		fi
+	else
+		if [ "$sysfs_atomic_max_bytes" = "$max_hw_bytes" ]
+		then
+			echo "TEST 2 - pass"
+		else
+			echo "TEST 2 - fail $scsi_atomic_max_bytes - $max_hw_bytes -" \
+				"$sysfs_atomic_max_bytes"
+		fi
+	fi
+
+	# TEST 3 - check sysfs atomic_write_unit_max_bytes <= scsi_debug atomic_wr_max_length
+	if (("$sysfs_atomic_unit_max_bytes" <= "$scsi_atomic_max_bytes"))
+	then
+		echo "TEST 3 - pass"
+	else
+		echo "TEST 3 - fail $sysfs_atomic_unit_max_bytes - $scsi_atomic_max_bytes"
+	fi
+
+	# TEST 4 - check sysfs atomic_write_unit_min_bytes = scsi_debug atomic_wr_gran
+	if [ "$sysfs_atomic_unit_min_bytes" = "$scsi_atomic_min_bytes" ]
+	then
+		echo "TEST 4 - pass"
+	else
+		echo "TEST 4 - fail $sysfs_atomic_unit_min_bytes - $scsi_atomic_min_bytes"
+	fi
+
+	# TEST 5 - check statx stx_atomic_write_unit_min
+	statx_atomic_min=$(run_xfs_io_xstat "$dev" "stat.atomic_write_unit_min")
+	if [ "$statx_atomic_min" = "$scsi_atomic_min_bytes" ]
+	then
+		echo "TEST 5 - pass"
+	else
+		echo "TEST 5 - fail $statx_atomic_min - $scsi_atomic_min_bytes"
+	fi
+
+	# TEST  6 - check statx stx_atomic_write_unit_max
+	statx_atomic_max=$(run_xfs_io_xstat "$dev" "stat.atomic_write_unit_max")
+	if [ "$statx_atomic_max" = "$sysfs_atomic_unit_max_bytes" ]
+	then
+		echo "TEST 6 - pass"
+	else
+		echo "TEST 6 - fail $statx_atomic_max - $sysfs_atomic_unit_max_bytes"
+	fi
+
+	# TEST 7 - perform a pwritev2 with size of sysfs_atomic_unit_max_bytes with no RWF_ATOMIC flag - pwritev2 should
+	# be succesful.
+	bytes_written=$(run_xfs_io_pwritev2 "$dev" "$sysfs_atomic_unit_max_bytes")
+	if [ "$bytes_written" = "$sysfs_atomic_unit_max_bytes" ]
+	then
+		echo "TEST 7 - pass"
+	else
+		echo "TEST 7 - fail $bytes_written - $sysfs_atomic_unit_max_bytes"
+	fi
+
+	# TEST 8 - perform a pwritev2 with size of sysfs_atomic_unit_max_bytes with RWF_ATOMIC flag - pwritev2 should
+	# be succesful.
+	bytes_written=$(run_xfs_io_pwritev2_atomic "$dev" "$sysfs_atomic_unit_max_bytes")
+	if [ "$bytes_written" = "$sysfs_atomic_unit_max_bytes" ]
+	then
+		echo "TEST 8 - pass"
+	else
+		echo "TEST 8 - fail $bytes_written - $sysfs_atomic_unit_max_bytes"
+	fi
+
+	# TEST 9 - perform a pwritev2 with size of sysfs_atomic_unit_max_bytes + 512 bytes with no RWF_ATOMIC flag - pwritev2
+	# should be succesful.
+	bytes_to_write=$(( "${sysfs_atomic_unit_max_bytes}" + "$sysfs_logical_block_size" ))
+	bytes_written=$(run_xfs_io_pwritev2 "$dev" "$bytes_to_write")
+	if [ "$bytes_written" = "$bytes_to_write" ]
+	then
+		echo "TEST 9 - pass"
+	else
+		echo "TEST 9 - fail $bytes_written - $bytes_to_write"
+	fi
+
+	# TEST 10 - perform a pwritev2 with size of sysfs_atomic_unit_max_bytes + 512 bytes with RWF_ATOMIC flag - pwritev2
+	# should not be succesful.
+	bytes_written=$(run_xfs_io_pwritev2_atomic "$dev" "$bytes_to_write")
+	if [ "$bytes_written" = "" ]
+	then
+		echo "TEST 10 - pass"
+	else
+		echo "TEST 10 - fail $bytes_written - $bytes_to_write"
+	fi
+
+	# TEST 11 - perform a pwritev2 with size of sysfs_atomic_unit_min_bytes with no RWF_ATOMIC flag - pwritev2 should
+	# be succesful.
+	bytes_written=$(run_xfs_io_pwritev2 "$dev" "$sysfs_atomic_unit_min_bytes")
+	if [ "$bytes_written" = "$sysfs_atomic_unit_min_bytes" ]
+	then
+		echo "TEST 11 - pass"
+	else
+		echo "TEST 11 - fail $bytes_written - $scsi_atomic_min_bytes"
+	fi
+
+	# TEST 12 - perform a pwritev2 with size of sysfs_atomic_unit_min_bytes with RWF_ATOMIC flag - pwritev2 should
+	# be succesful.
+	bytes_written=$(run_xfs_io_pwritev2_atomic "$dev" "$sysfs_atomic_unit_min_bytes")
+	if [ "$bytes_written" = "$sysfs_atomic_unit_min_bytes" ]
+	then
+		echo "TEST 12 - pass"
+	else
+		echo "TEST 12 - fail $bytes_written - $scsi_atomic_min_bytes"
+	fi
+
+	# TEST 13 - perform a pwritev2 with a size of sysfs_atomic_unit_min_bytes - 512 bytes with no
+	# RWF_ATOMIC flag - pwritev2 should be succesful.
+	# TEST 14 - perform a pwritev2 with a size of sysfs_atomic_unit_min_bytes - 512 bytes with
+        # RWF_ATOMIC flag - pwritev2 should fail.
+	bytes_to_write=$(( "${sysfs_atomic_unit_min_bytes}" - "${sysfs_logical_block_size}" ))
+	if [ "$bytes_to_write" = 0 ]
+	then
+		# sysfs_atomic_unit_min_bytes is set to 1 logical block so these tests aren't needed.
+		echo "TEST 13 - pass"
+		echo "TEST 14 - pass"
+	else
+		bytes_written=$(run_xfs_io_pwritev2 "$dev" "$bytes_to_write")
+		if [ "$bytes_written" = "$bytes_to_write" ]
+		then
+			echo "TEST 13 - pass"
+		else
+			echo "TEST 13 - fail $bytes_written - $bytes_to_write"
+		fi
+		bytes_written=$(run_xfs_io_pwritev2_atomic "$dev" "$bytes_to_write")
+		if [ "$bytes_written" = "" ]
+		then
+			echo "TEST 14 - pass"
+		else
+			echo "TEST 14 - fail $bytes_written - $bytes_to_write"
+		fi
+	fi
+
+	_exit_scsi_debug
+
+	echo "Test complete"
+}
diff --git a/tests/scsi/009.out b/tests/scsi/009.out
new file mode 100644
index 000000000000..3a3382b1190c
--- /dev/null
+++ b/tests/scsi/009.out
@@ -0,0 +1,18 @@
+Running scsi/009
+TEST 1 - pass
+TEST 2 - pass
+TEST 3 - pass
+TEST 4 - pass
+TEST 5 - pass
+TEST 6 - pass
+TEST 7 - pass
+TEST 8 - pass
+TEST 9 - pass
+pwrite: Invalid argument
+TEST 10 - pass
+TEST 11 - pass
+TEST 12 - pass
+TEST 13 - pass
+pwrite: Invalid argument
+TEST 14 - pass
+Test complete
-- 
2.43.5

