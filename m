Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D9032CCC1;
	Thu,  5 Jun 2025 22:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749163659; cv=none; b=b0chWy7emXnNygiJujsAnmtxavp5OcFnLIZkbPlj0SvjAoa76/6admqJhkvUx83P1yHj40vXPeF2OWr7YttUul7TaVTviaWpPmYy7CsS4fQ6iTpW6ZyuwcMtGO22a+g1WJRt/5Wtfwb0bOwRtw7BM4rZl8iMWnSWbeqHjP9VEXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749163659; c=relaxed/simple;
	bh=poc0/UThMxLbTSiUTMvanTGkDhhPzNCWUE8sHRpuMzI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ha8ezRrMC791L23gtrB5+4YJFBMq212X2wPR61GRn6ls0LzM0DyUGQR4XJDr1BibHFFqBe7l7SE1bsEh6lm3E5zRTwkkYOhl5w4HULcOloh78qDtP+n3H6uoAUGNtMxkwDu2CBtVy8FBkuignLITh2RbrC1Zk676EVyZAHiMLfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UC2SeIrb; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UC2SeIrb"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 555KvrKm031161;
	Thu, 5 Jun 2025 22:47:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2025-04-25; bh=B3iCkznfdJrPtmutRDHkkOVy3ToEG
	yOfwJM48wn17go=; b=UC2SeIrbs13g7qS6V6ZZIGnS3mAVeXf4KGnveI2ZLxCZm
	cvZeSAlbov/fZJ83+MhnmnVkgPG4ELaYssfmx3g00w2p3T4H2Xc6Oy/R4tNenSTp
	zgsnlPpIpXqBsE/WmE6dLRZD0JruBtkcTUa2nUdkH9Yi2nL/NPQfpn13eqb2kmuE
	ziCvECJ13eFVZM1xdcJ/PSrUaS6F4zgVp63LTy3TuSZDNdAA/X1edYdCAP2SchB7
	Ac7bXy3dEAdB7bvkcJbnixd5KFXefhYOFUcGqcwbELwGlFZ3gmXx3M+tNe/Qnw0L
	GKEN2JhuFkY1w0EJNpN6YQH7OYY3GHWfwh1qBj0Yw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 471g8bq1ee-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Jun 2025 22:47:27 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 555LLCo8030830;
	Thu, 5 Jun 2025 22:47:26 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46yr7cnddw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Jun 2025 22:47:26 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 555MlPld021940;
	Thu, 5 Jun 2025 22:47:25 GMT
Received: from ca-dev94.us.oracle.com (ca-dev94.us.oracle.com [10.129.136.30])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 46yr7cnddm-1;
	Thu, 05 Jun 2025 22:47:25 +0000
From: Alan Adamson <alan.adamson@oracle.com>
To: linux-block@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, alan.adamson@oracle.com,
        linux-nvme@lists.infradead.org, shinichiro.kawasaki@wdc.com,
        linux-raid@vger.kernel.org
Subject: [PATCH blktests] md/002: add atomic write tests for md/stacked devices
Date: Thu,  5 Jun 2025 15:57:25 -0700
Message-ID: <20250605225725.3352708-1-alan.adamson@oracle.com>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-05_07,2025-06-05_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 suspectscore=0 phishscore=0 adultscore=0 spamscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2506050206
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjA1MDIwNiBTYWx0ZWRfX6lgLsRc+ZDA+ qONOhevAhVjXQBDFD1tBgjuQx1f5nhIUDeyjnOwMVvtF3zmpQb0kw2PYxovFaGZGJ32Huz72V8D cHrj9gH+nILFN14c8RNCrCIKJ7rxi6jJEFMClFFkpmTLgmvIkIHwC43Vilf5VUwjFt3CyM4ZNwq
 UOWYWA+tnArI4hJ0c/5Rg6PjK/tioLyjsJyLQzaubjSdp7uwz1DpF7K3yYpWUoQL5Aj+qkDCGpw 6w6iH0lRQwibj/fOYblEMSjjogCo6Su/Z1RIlUC3cCernzLXoQFBLFY7q1bUBylCD/CrWOCVFka GrAA0+g45/QyEbTIikeZ+QM2EjBlW4mfYdkdrTJSdv+2zMt7W42nBLbRKuyo3lufE7mHvmnX/of
 2wNGD6rOiiC5xdcy1ta0jqfXNc69c0tCwdUb1ILQpOuk/86XAL/puLzSyQJGwFN0MuyzfiM4
X-Proofpoint-GUID: 2he_U9_GENU6zuttUcKcJL60mMjaj_3o
X-Proofpoint-ORIG-GUID: 2he_U9_GENU6zuttUcKcJL60mMjaj_3o
X-Authority-Analysis: v=2.4 cv=H+Dbw/Yi c=1 sm=1 tr=0 ts=68421e7f b=1 cx=c_pps a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17 a=6IFa9wvqVegA:10 a=yPCof4ZbAAAA:8 a=at6Jyrbyo9Rir9YWFhUA:9 cc=ntf awl=host:14714

Add a new test (md/002) to verify atomic write support for MD devices
(RAID 0, 1, and 10) stacked on top of SCSI devices using scsi_debug with
atomic write emulation enabled.

This test validates that atomic write sysfs attributes are correctly
propagated through MD layers, and that pwritev2() with RWF_ATOMIC
behaves as expected on these devices.

Specifically, the test checks:
    - That atomic write attributes in /sys/block/.../queue are consistent
      between MD and underlying SCSI devices
    - That atomic write limits are respected in user-space via xfs_io
    - That statx reports accurate atomic_write_unit_{min,max} values
    - That invalid writes (too small or too large) fail as expected
    - That chunk size affects max atomic write limits (for RAID 0/10)

Signed-off-by: Alan Adamson <alan.adamson@oracle.com>
---
 tests/md/002     | 245 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/md/002.out |  43 +++++++++
 2 files changed, 288 insertions(+)
 create mode 100755 tests/md/002
 create mode 100644 tests/md/002.out

diff --git a/tests/md/002 b/tests/md/002
new file mode 100755
index 000000000000..4b71ebf7d496
--- /dev/null
+++ b/tests/md/002
@@ -0,0 +1,245 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-3.0+
+# Copyright (C) 2025 Oracle and/or its affiliates
+#
+# Test SCSI Atomic Writes with MD devices
+
+. tests/scsi/rc
+. common/scsi_debug
+. common/xfs
+
+DESCRIPTION="test md atomic writes"
+QUICK=1
+
+requires() {
+	_have_kver 6 14 0
+	group_requires
+	_have_program mdadm
+	_have_driver scsi_debug
+	_have_xfs_io_atomic_write
+}
+
+test() {
+	local scsi_debug_atomic_wr_max_length
+	local scsi_debug_atomic_wr_gran
+	local scsi_sysfs_atomic_max_bytes
+	local scsi_sysfs_atomic_unit_max_bytes
+	local scsi_sysfs_atomic_unit_min_bytes
+	local md_atomic_max_bytes
+	local md_atomic_min_bytes
+	local md_sysfs_max_hw_sectors_kb
+	local md_max_hw_bytes
+	local md_chunk_size
+	local md_sysfs_logical_block_size
+	local md_sysfs_atomic_max_bytes
+	local md_sysfs_atomic_unit_max_bytes
+	local md_sysfs_atomic_unit_min_bytes
+	local bytes_to_write
+	local bytes_written
+	local test_desc
+	local scsi_0
+	local scsi_1
+	local scsi_2
+	local scsi_3
+	local scsi_dev_sysfs
+	local md_dev
+	local md_dev_sysfs
+	local scsi_debug_params=(
+		delay=0
+		atomic_wr=1
+		num_tgts=1
+		add_host=4
+		per_host_store=true
+	)
+
+	echo "Running ${TEST_NAME}"
+
+	if ! _configure_scsi_debug "${scsi_debug_params[@]}"; then
+                return 1
+                fi
+
+	scsi_0="${SCSI_DEBUG_DEVICES[0]}"
+	scsi_1="${SCSI_DEBUG_DEVICES[1]}"
+	scsi_2="${SCSI_DEBUG_DEVICES[2]}"
+	scsi_3="${SCSI_DEBUG_DEVICES[3]}"
+
+	scsi_dev_sysfs="/sys/block/${scsi_0}"
+	scsi_sysfs_atomic_max_bytes=$(< "${scsi_dev_sysfs}"/queue/atomic_write_max_bytes)
+	scsi_sysfs_atomic_unit_max_bytes=$(< "${scsi_dev_sysfs}"/queue/atomic_write_unit_max_bytes)
+	scsi_sysfs_atomic_unit_min_bytes=$(< "${scsi_dev_sysfs}"/queue/atomic_write_unit_min_bytes)
+	scsi_debug_atomic_wr_max_length=$(< /sys/module/scsi_debug/parameters/atomic_wr_max_length)
+	scsi_debug_atomic_wr_gran=$(< /sys/module/scsi_debug/parameters/atomic_wr_gran)
+
+	for raid_level in 0 1 10; do
+		if [ "$raid_level" = 10 ]
+		then
+			echo y | mdadm --create /dev/md/blktests_md --level=$raid_level \
+				--raid-devices=4 --force /dev/"${scsi_0}" /dev/"${scsi_1}" \
+				/dev/"${scsi_2}" /dev/"${scsi_3}" 2> /dev/null 1>&2
+		else
+			echo y | mdadm --create /dev/md/blktests_md --level=$raid_level \
+				--raid-devices=2 --force \
+				/dev/"${scsi_0}" /dev/"${scsi_1}" 2> /dev/null 1>&2
+		fi
+
+		md_dev=$(readlink /dev/md/blktests_md | sed 's|\.\./||')
+		md_dev_sysfs="/sys/devices/virtual/block/${md_dev}"
+
+		md_sysfs_logical_block_size=$(< "${md_dev_sysfs}"/queue/logical_block_size)
+		md_sysfs_max_hw_sectors_kb=$(< "${md_dev_sysfs}"/queue/max_hw_sectors_kb)
+		md_max_hw_bytes=$(( "$md_sysfs_max_hw_sectors_kb" * 1024 ))
+		md_sysfs_atomic_max_bytes=$(< "${md_dev_sysfs}"/queue/atomic_write_max_bytes)
+		md_sysfs_atomic_unit_max_bytes=$(< "${md_dev_sysfs}"/queue/atomic_write_unit_max_bytes)
+		md_sysfs_atomic_unit_min_bytes=$(< "${md_dev_sysfs}"/queue/atomic_write_unit_min_bytes)
+		md_atomic_max_bytes=$(( "$scsi_debug_atomic_wr_max_length" * "$md_sysfs_logical_block_size" ))
+		md_atomic_min_bytes=$(( "$scsi_debug_atomic_wr_gran" * "$md_sysfs_logical_block_size" ))
+
+		test_desc="TEST 1 RAID $raid_level - Verify md sysfs atomic attributes matches scsi"
+		if [ "$md_sysfs_atomic_unit_max_bytes" = "$scsi_sysfs_atomic_unit_max_bytes" ] &&
+			[ "$md_sysfs_atomic_unit_min_bytes" = "$scsi_sysfs_atomic_unit_min_bytes" ]
+		then
+			echo "$test_desc - pass"
+		else
+			echo "$test_desc - fail $md_sysfs_atomic_unit_max_bytes - $scsi_sysfs_atomic_unit_max_bytes -" \
+				"$md_sysfs_atomic_unit_min_bytes - $scsi_sysfs_atomic_unit_min_bytes "
+		fi
+
+		test_desc="TEST 2 RAID $raid_level - Verify sysfs atomic attributes"
+		if [ "$md_max_hw_bytes" -ge "$md_sysfs_atomic_max_bytes" ] &&
+			[ "$md_sysfs_atomic_max_bytes" -ge "$md_sysfs_atomic_unit_max_bytes" ] &&
+			[ "$md_sysfs_atomic_unit_max_bytes" -ge "$md_sysfs_atomic_unit_min_bytes" ]
+		then
+			echo "$test_desc - pass"
+		else
+			echo "$test_desc - fail $md_max_hw_bytes - $md_sysfs_max_hw_sectors_kb -" \
+				"$md_sysfs_atomic_max_bytes - $md_sysfs_atomic_unit_max_bytes -" \
+				"$md_sysfs_atomic_unit_min_bytes"
+		fi
+
+		test_desc="TEST 3 RAID $raid_level - Verify md sysfs_atomic_max_bytes is less than or equal "
+		test_desc+="scsi sysfs_atomic_max_bytes"
+		if [ "$md_sysfs_atomic_max_bytes" -le "$scsi_sysfs_atomic_max_bytes" ]
+		then
+			echo "$test_desc - pass"
+		else
+			echo "$test_desc - fail $md_sysfs_atomic_max_bytes - $scsi_sysfs_atomic_max_bytes"
+		fi
+
+		test_desc="TEST 4 RAID $raid_level - check sysfs atomic_write_unit_max_bytes <= scsi_debug atomic_wr_max_length"
+		if (("$md_sysfs_atomic_unit_max_bytes" <= "$md_atomic_max_bytes"))
+		then
+			echo "$test_desc - pass"
+		else
+			echo "$test_desc - fail $md_sysfs_atomic_unit_max_bytes - $md_atomic_max_bytes"
+		fi
+
+		test_desc="TEST 5 RAID $raid_level - check sysfs atomic_write_unit_min_bytes = scsi_debug atomic_wr_gran"
+		if [ "$md_sysfs_atomic_unit_min_bytes" = "$md_atomic_min_bytes" ]
+		then
+			echo "$test_desc - pass"
+		else
+			echo "$test_desc - fail $md_sysfs_atomic_unit_min_bytes - $md_atomic_min_bytes"
+		fi
+
+		test_desc="TEST 6 RAID $raid_level - check statx stx_atomic_write_unit_min"
+		statx_atomic_min=$(run_xfs_io_xstat /dev/"$md_dev" "stat.atomic_write_unit_min")
+		if [ "$statx_atomic_min" = "$md_atomic_min_bytes" ]
+		then
+			echo "$test_desc - pass"
+		else
+			echo "$test_desc - fail $statx_atomic_min - $md_atomic_min_bytes"
+		fi
+
+		test_desc="TEST 7 RAID $raid_level - check statx stx_atomic_write_unit_max"
+		statx_atomic_max=$(run_xfs_io_xstat /dev/"$md_dev" "stat.atomic_write_unit_max")
+		if [ "$statx_atomic_max" = "$md_sysfs_atomic_unit_max_bytes" ]
+		then
+			echo "$test_desc - pass"
+		else
+			echo "$test_desc - fail $statx_atomic_max - $md_sysfs_atomic_unit_max_bytes"
+		fi
+
+		test_desc="TEST 8 RAID $raid_level - perform a pwritev2 with size of sysfs_atomic_unit_max_bytes with "
+		test_desc+="RWF_ATOMIC flag - pwritev2 should be succesful"
+		bytes_written=$(run_xfs_io_pwritev2_atomic /dev/"$md_dev" "$md_sysfs_atomic_unit_max_bytes")
+		if [ "$bytes_written" = "$md_sysfs_atomic_unit_max_bytes" ]
+		then
+			echo "$test_desc - pass"
+		else
+			echo "$test_desc - fail $bytes_written - $md_sysfs_atomic_unit_max_bytes"
+		fi
+
+		test_desc="TEST 9 RAID $raid_level - perform a pwritev2 with size of sysfs_atomic_unit_max_bytes + 512 "
+		test_desc+="bytes with RWF_ATOMIC flag - pwritev2 should not be succesful"
+		bytes_to_write=$(( "${md_sysfs_atomic_unit_max_bytes}" + 512 ))
+		bytes_written=$(run_xfs_io_pwritev2_atomic /dev/"$md_dev" "$bytes_to_write")
+		if [ "$bytes_written" = "" ]
+		then
+			echo "$test_desc - pass"
+		else
+			echo "$test_desc - fail $bytes_written - $bytes_to_write"
+		fi
+
+		test_desc="TEST 10 RAID $raid_level - perform a pwritev2 with size of sysfs_atomic_unit_min_bytes "
+		test_desc+="with RWF_ATOMIC flag - pwritev2 should be succesful"
+		bytes_written=$(run_xfs_io_pwritev2_atomic /dev/"$md_dev" "$md_sysfs_atomic_unit_min_bytes")
+		if [ "$bytes_written" = "$md_sysfs_atomic_unit_min_bytes" ]
+		then
+			echo "$test_desc - pass"
+		else
+			echo "$test_desc - fail $bytes_written - $md_atomic_min_bytes"
+		fi
+
+		bytes_to_write=$(( "${md_sysfs_atomic_unit_min_bytes}" - "${md_sysfs_logical_block_size}" ))
+		test_desc="TEST 11 RAID $raid_level - perform a pwritev2 with a size of sysfs_atomic_unit_min_bytes - 512 "
+		test_desc+="bytes with RWF_ATOMIC flag - pwritev2 should fail"
+		if [ "$bytes_to_write" = 0 ]
+		then
+			echo "$test_desc - pass"
+		else
+			bytes_written=$(run_xfs_io_pwritev2_atomic /dev/"$md_dev" "$bytes_to_write")
+			if [ "$bytes_written" = "" ]
+			then
+				echo "$test_desc - pass"
+			else
+				echo "$test_desc - fail $bytes_written - $bytes_to_write"
+			fi
+		fi
+
+		mdadm --stop /dev/md/blktests_md  2> /dev/null 1>&2
+
+		if [ "$raid_level" = 0 ] || [ "$raid_level" = 10 ]
+		then
+			md_chunk_size=$(( "$scsi_sysfs_atomic_unit_max_bytes" / 2048))
+
+			if [ "$raid_level" = 0 ]
+			then
+				echo y | mdadm --create /dev/md/blktests_md --level=$raid_level \
+					--raid-devices=2 --chunk="${md_chunk_size}"K --force \
+					/dev/"${scsi_0}" /dev/"${scsi_1}" 2> /dev/null 1>&2
+			else
+				echo y | mdadm --create /dev/md/blktests_md --level=$raid_level \
+					--raid-devices=4 --chunk="${md_chunk_size}"K --force \
+					/dev/"${scsi_0}" /dev/"${scsi_1}" \
+					/dev/"${scsi_2}" /dev/"${scsi_3}" 2> /dev/null 1>&2
+			fi
+
+			md_dev=$(readlink /dev/md/blktests_md | sed 's|\.\./||')
+			md_dev_sysfs="/sys/devices/virtual/block/${md_dev}"
+			md_sysfs_atomic_unit_max_bytes=$(< "${md_dev_sysfs}"/queue/atomic_write_unit_max_bytes)
+			test_desc="TEST 12 RAID $raid_level - Verify sysfs_atomic_unit_max_bytes <= chunk size "
+			if [ "$md_chunk_size" -le "$md_sysfs_atomic_unit_max_bytes" ]
+			then
+				echo "$test_desc - pass"
+			else
+				echo "$test_desc - fail $md_chunk_size - $md_sysfs_atomic_unit_max_bytes"
+			fi
+
+			mdadm --quiet --stop /dev/md/blktests_md
+                fi
+	done
+
+	_exit_scsi_debug
+
+	echo "Test complete"
+}
diff --git a/tests/md/002.out b/tests/md/002.out
new file mode 100644
index 000000000000..61fb2650b60a
--- /dev/null
+++ b/tests/md/002.out
@@ -0,0 +1,43 @@
+Running md/002
+TEST 1 RAID 0 - Verify md sysfs atomic attributes matches scsi - pass
+TEST 2 RAID 0 - Verify sysfs atomic attributes - pass
+TEST 3 RAID 0 - Verify md sysfs_atomic_max_bytes is less than or equal scsi sysfs_atomic_max_bytes - pass
+TEST 4 RAID 0 - check sysfs atomic_write_unit_max_bytes <= scsi_debug atomic_wr_max_length - pass
+TEST 5 RAID 0 - check sysfs atomic_write_unit_min_bytes = scsi_debug atomic_wr_gran - pass
+TEST 6 RAID 0 - check statx stx_atomic_write_unit_min - pass
+TEST 7 RAID 0 - check statx stx_atomic_write_unit_max - pass
+TEST 8 RAID 0 - perform a pwritev2 with size of sysfs_atomic_unit_max_bytes with RWF_ATOMIC flag - pwritev2 should be succesful - pass
+pwrite: Invalid argument
+TEST 9 RAID 0 - perform a pwritev2 with size of sysfs_atomic_unit_max_bytes + 512 bytes with RWF_ATOMIC flag - pwritev2 should not be succesful - pass
+TEST 10 RAID 0 - perform a pwritev2 with size of sysfs_atomic_unit_min_bytes with RWF_ATOMIC flag - pwritev2 should be succesful - pass
+pwrite: Invalid argument
+TEST 11 RAID 0 - perform a pwritev2 with a size of sysfs_atomic_unit_min_bytes - 512 bytes with RWF_ATOMIC flag - pwritev2 should fail - pass
+TEST 12 RAID 0 - Verify sysfs_atomic_unit_max_bytes <= chunk size  - pass
+TEST 1 RAID 1 - Verify md sysfs atomic attributes matches scsi - pass
+TEST 2 RAID 1 - Verify sysfs atomic attributes - pass
+TEST 3 RAID 1 - Verify md sysfs_atomic_max_bytes is less than or equal scsi sysfs_atomic_max_bytes - pass
+TEST 4 RAID 1 - check sysfs atomic_write_unit_max_bytes <= scsi_debug atomic_wr_max_length - pass
+TEST 5 RAID 1 - check sysfs atomic_write_unit_min_bytes = scsi_debug atomic_wr_gran - pass
+TEST 6 RAID 1 - check statx stx_atomic_write_unit_min - pass
+TEST 7 RAID 1 - check statx stx_atomic_write_unit_max - pass
+TEST 8 RAID 1 - perform a pwritev2 with size of sysfs_atomic_unit_max_bytes with RWF_ATOMIC flag - pwritev2 should be succesful - pass
+pwrite: Invalid argument
+TEST 9 RAID 1 - perform a pwritev2 with size of sysfs_atomic_unit_max_bytes + 512 bytes with RWF_ATOMIC flag - pwritev2 should not be succesful - pass
+TEST 10 RAID 1 - perform a pwritev2 with size of sysfs_atomic_unit_min_bytes with RWF_ATOMIC flag - pwritev2 should be succesful - pass
+pwrite: Invalid argument
+TEST 11 RAID 1 - perform a pwritev2 with a size of sysfs_atomic_unit_min_bytes - 512 bytes with RWF_ATOMIC flag - pwritev2 should fail - pass
+TEST 1 RAID 10 - Verify md sysfs atomic attributes matches scsi - pass
+TEST 2 RAID 10 - Verify sysfs atomic attributes - pass
+TEST 3 RAID 10 - Verify md sysfs_atomic_max_bytes is less than or equal scsi sysfs_atomic_max_bytes - pass
+TEST 4 RAID 10 - check sysfs atomic_write_unit_max_bytes <= scsi_debug atomic_wr_max_length - pass
+TEST 5 RAID 10 - check sysfs atomic_write_unit_min_bytes = scsi_debug atomic_wr_gran - pass
+TEST 6 RAID 10 - check statx stx_atomic_write_unit_min - pass
+TEST 7 RAID 10 - check statx stx_atomic_write_unit_max - pass
+TEST 8 RAID 10 - perform a pwritev2 with size of sysfs_atomic_unit_max_bytes with RWF_ATOMIC flag - pwritev2 should be succesful - pass
+pwrite: Invalid argument
+TEST 9 RAID 10 - perform a pwritev2 with size of sysfs_atomic_unit_max_bytes + 512 bytes with RWF_ATOMIC flag - pwritev2 should not be succesful - pass
+TEST 10 RAID 10 - perform a pwritev2 with size of sysfs_atomic_unit_min_bytes with RWF_ATOMIC flag - pwritev2 should be succesful - pass
+pwrite: Invalid argument
+TEST 11 RAID 10 - perform a pwritev2 with a size of sysfs_atomic_unit_min_bytes - 512 bytes with RWF_ATOMIC flag - pwritev2 should fail - pass
+TEST 12 RAID 10 - Verify sysfs_atomic_unit_max_bytes <= chunk size  - pass
+Test complete
-- 
2.43.5

