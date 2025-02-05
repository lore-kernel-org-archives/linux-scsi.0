Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDC2E21506A;
	Wed,  5 Feb 2025 23:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738796555; cv=none; b=EO/2HYsMWCtxQ3nCJQgY2iU/SCLyc5RcX95FU0TjjVSQ+N9odyI7nNTr7n02PdzuDjx80ZrrLakdDnQAV3yI+eQ2nBLSieuCQxpigSsN7JUbVBaaEE86VlBZm5wj8HeO0HLdxCv5zSrwk8pkqydsENqXPyrhwONZZ6US02TAMj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738796555; c=relaxed/simple;
	bh=ZSRUoATcoXuShGzkiPK2QTea3nWZ+pEH1Z+2h7nBQQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pGexI4wdEuTB51zl3Q7xb2d5lVyEFSohVZU41OVIS/1J0UMwGPv/9QR3AyMHatfohstbz6jw7RYMEK5zZR4vreJD1/MIaxJdsCe+Rl6QzhpUY4CpnXv6y54X+fLEswlEFH+axgHsPylhevSa90vEmaTfdx4HJslmrlbxdQt2CTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=acEd+qp/; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="acEd+qp/"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 515N10xF022294;
	Wed, 5 Feb 2025 23:02:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2023-11-20; bh=PoT5i
	XwqkGHI6Zj22GZ49yPCVDOUpRMeA1OsHfTmtg0=; b=acEd+qp/Uq3sYApUjNbS6
	WjuRe9tvN7Ox/56rhSyoesbIjNFW/nZSTXoxnbxwtH3nsMt8k9in10MqTqFmu+Xk
	s52Ju/gmntkTLDxb/gX1lIhFA25ZEadzlXFcLILRICrkxaa+ajL62Blzk0tbNrHW
	UUFHeQAyAS25LkW+Au3Kv6orU8+IpCSYExEBePLIdUx3ozgIXQhNa3o6xfEUQFA9
	skrtMaYUpPAkhU1D6raoFqrYMbKw/BG20OnnJcahf6vh/m0Zm8kcgS4j7oeC2LK5
	RwDrlec+bDPqzdxZDCu6EDX58iRaZ3a9LlLmiLCx7V5pi+x8JPWAcrl72hoBCFz3
	w==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44kckxm5t0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Feb 2025 23:02:30 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 515Lu44D022663;
	Wed, 5 Feb 2025 23:02:29 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44j8e9r5ng-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Feb 2025 23:02:29 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 515N2Rfm040085;
	Wed, 5 Feb 2025 23:02:28 GMT
Received: from ca-dev94.us.oracle.com (ca-dev94.us.oracle.com [10.129.136.30])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 44j8e9r5m8-3;
	Wed, 05 Feb 2025 23:02:28 +0000
From: Alan Adamson <alan.adamson@oracle.com>
To: linux-block@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, alan.adamson@oracle.com,
        linux-nvme@lists.infradead.org, shinichiro.kawasaki@wdc.com
Subject: [PATCH v3 blktests 2/2] nvme/059: add atomic write tests
Date: Wed,  5 Feb 2025 15:11:00 -0800
Message-ID: <20250205231100.391005-3-alan.adamson@oracle.com>
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
X-Proofpoint-GUID: -ki184izDy3JthxZMTqwLoytknoySExw
X-Proofpoint-ORIG-GUID: -ki184izDy3JthxZMTqwLoytknoySExw

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
 tests/nvme/059     | 147 +++++++++++++++++++++++++++++++++++++++++++++
 tests/nvme/059.out |  10 +++
 2 files changed, 157 insertions(+)
 create mode 100755 tests/nvme/059
 create mode 100644 tests/nvme/059.out

diff --git a/tests/nvme/059 b/tests/nvme/059
new file mode 100755
index 000000000000..24b2bec645a8
--- /dev/null
+++ b/tests/nvme/059
@@ -0,0 +1,147 @@
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
+	_require_device_support_atomic_writes
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

