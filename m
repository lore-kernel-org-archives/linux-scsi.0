Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7610A1F5413;
	Tue, 21 Jan 2025 22:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737497830; cv=none; b=PtlPAT1XoK5Tb2SWBhGMQXRymS13iWUIE/JwVcjG5hLGiA/QYYR5nWU6iYD5ifnWLIuYjlzOkG9cJLvEgqDv2KCTqUgHjiJz+hl8jz5aVOnNsLxP9bXxh2z0hoHYS4kg7CELXXnefnS0iFZGDboG+VobQf9RVunkUW26iEHIRJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737497830; c=relaxed/simple;
	bh=hNctKtRXlkyHasWzYO6Y7l0HvrysXiUqdOg51ZZ3Es8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ImKbswtJEc8P8a7HJ7yDvBGvetBlmrfq/nGA2DE02Npn+bvEVObhE8OVlZYHbQUMN5RZ8JMdPl7AeCREyhEfPmGklKz8TVTBXhORBWFp/ZypOieb/HthUSyRYmuDQ+5uHumQ8Pb4ewB3QXgVlzALyVERneQYmEaupLJMux8uOmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=R54pOdoM; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="R54pOdoM"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50LJKkhd022897;
	Tue, 21 Jan 2025 22:17:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2023-11-20; bh=2C0AL
	QKZ6eOxh3YBLPmz1HZppzENZFwajcXf8pFakmM=; b=R54pOdoMSxj0rKCtbcUBV
	JJz80frmuqXuSRUkKCtwtvg4BpmqqIB3IkVrJKG0gJRLW3YB37hbwLVyqpgT0HjZ
	ZVb+dLBhhmDSSHrNfbbIGtGZiygoB7cHm6Ogdbmp5zjQ7ZoofnA7EQn3LzKxmEez
	wV1KESRhjMCtalciOhzCEwj3b4aVGsLhuHr0U1NyEh+JBYRV4qKFQkYeOaDvG9FZ
	HYXsV/Z7ZwuHvMGCVkWdpuB8QNLTWDQRDGaa1TAS/HYKOLckJu7tNr3lGccUqwic
	gJ/k71pa0b2Gjo1A5LP+w2MhVmidAVAFFolh4B3IFBNtJTf7G7mVUZv4Xg011YO4
	g==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4485tm6mvu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Jan 2025 22:17:03 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50LKjfUE036578;
	Tue, 21 Jan 2025 22:17:03 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44917q44wr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Jan 2025 22:17:02 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 50LMH1S3022589;
	Tue, 21 Jan 2025 22:17:02 GMT
Received: from ca-dev94.us.oracle.com (ca-dev94.us.oracle.com [10.129.136.30])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 44917q44vy-3;
	Tue, 21 Jan 2025 22:17:02 +0000
From: Alan Adamson <alan.adamson@oracle.com>
To: linux-block@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, alan.adamson@oracle.com,
        linux-nvme@lists.infradead.org, shinichiro.kawasaki@wdc.com
Subject: [PATCH blktests 2/2] nvme/059: add atomic write tests
Date: Tue, 21 Jan 2025 14:25:30 -0800
Message-ID: <20250121222530.2824516-3-alan.adamson@oracle.com>
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
X-Proofpoint-ORIG-GUID: C95hys0fC_aTArAL8QpCv6AGKT5fOuMZ
X-Proofpoint-GUID: C95hys0fC_aTArAL8QpCv6AGKT5fOuMZ

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
 tests/nvme/059     | 138 +++++++++++++++++++++++++++++++++++++++++++++
 tests/nvme/059.out |  10 ++++
 2 files changed, 148 insertions(+)
 create mode 100755 tests/nvme/059
 create mode 100644 tests/nvme/059.out

diff --git a/tests/nvme/059 b/tests/nvme/059
new file mode 100755
index 000000000000..af4a4263329d
--- /dev/null
+++ b/tests/nvme/059
@@ -0,0 +1,138 @@
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
+	_have_kver 6 11
+	_have_xfs_io_ver 6 12 0
+}
+
+test_device() {
+	local ns_dev
+	local ctrl_dev
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
+
+	echo "Running ${TEST_NAME}"
+	ns_dev=${TEST_DEV##*/}
+	ctrl_dev=${ns_dev%n*}
+
+	# TEST 1 - Verify sysfs attributes
+	sysfs_logical_block_size=$(cat "${TEST_DEV_SYSFS}"/queue/logical_block_size)
+	sysfs_max_hw_sectors_kb=$(cat "${TEST_DEV_SYSFS}"/queue/max_hw_sectors_kb)
+	max_hw_bytes=$(( "$sysfs_max_hw_sectors_kb" * 1024 ))
+	sysfs_atomic_max_bytes=$(cat "${TEST_DEV_SYSFS}"/queue/atomic_write_max_bytes)
+	sysfs_atomic_unit_max_bytes=$(cat "${TEST_DEV_SYSFS}"/queue/atomic_write_unit_max_bytes)
+	sysfs_atomic_unit_min_bytes=$(cat "${TEST_DEV_SYSFS}"/queue/atomic_write_unit_min_bytes)
+
+	if [ "$max_hw_bytes" -ge "$sysfs_atomic_max_bytes" ] &&
+		[ "$sysfs_atomic_max_bytes" -ge "$sysfs_atomic_unit_max_bytes" ] &&
+		[ "$sysfs_atomic_unit_max_bytes" -ge "$sysfs_atomic_unit_min_bytes" ]
+	then
+		echo "TEST 1 - pass"
+	else
+		echo "TEST 1 - fail $max_hw_bytes - $sysfs_max_hw_sectors_kb -" \
+			"$sysfs_atomic_max_bytes - $sysfs_atomic_unit_max_bytes -" \
+			"$sysfs_atomic_unit_min_bytes"
+	fi
+
+	# TEST 2 - Verify sysfs atomic_write_unit_max_bytes is consistent with NVMe AWUPF/NAWUPF
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
+			echo "TEST 2 - pass"
+		else
+			echo "TEST 2 - fail $nvme_nsabp - $atomic_max_bytes - $sysfs_atomic_max_bytes -" \
+				"$max_hw_bytes"
+		fi
+	else
+		if [ "$sysfs_atomic_max_bytes" = "$max_hw_bytes" ]
+		then
+			echo "TEST 2 - pass"
+		else
+			echo "TEST 2 - fail $nvme_nsabp - $atomic_max_bytes - $sysfs_atomic_max_bytes -" \
+				"$max_hw_bytes"
+		fi
+	fi
+
+	# TEST 3 - Verify statx is correctly reporting atomic_unit_max_bytes
+	statx_atomic_max=$(run_xfs_io_xstat /dev/"$ns_dev" "stat.atomic_write_unit_max")
+	if [ "$sysfs_atomic_unit_max_bytes" = "$statx_atomic_max" ]
+	then
+		echo "TEST 3 - pass"
+	else
+		echo "TEST 3 - fail $statx_atomic_max - $sysfs_atomic_unit_max_bytes"
+	fi
+
+	# TEST 4 - perform a pwritev2 with size of sysfs_atomic_unit_max_bytes with no RWF_ATOMIC
+	# flag - pwritev2 should be succesful.
+        bytes_written=$(run_xfs_io_pwritev2 /dev/"$ns_dev" "$sysfs_atomic_unit_max_bytes")
+        if [ "$bytes_written" = "$sysfs_atomic_unit_max_bytes" ]
+        then
+                echo "TEST 4 - pass"
+        else
+                echo "TEST 4 - fail $bytes_written - $sysfs_atomic_unit_max_bytes"
+        fi
+
+	# TEST 5 - perform a pwritev2 with size of sysfs_atomic_unit_max_bytes with RWF_ATOMIC
+	# flag - pwritev2 should  be succesful.
+	bytes_written=$(run_xfs_io_pwritev2_atomic /dev/"$ns_dev" "$sysfs_atomic_unit_max_bytes")
+	if [ "$bytes_written" = "$sysfs_atomic_unit_max_bytes" ]
+	then
+		echo "TEST 5 - pass"
+	else
+		echo "TEST 5 - fail $bytes_written - $sysfs_atomic_unit_max_bytes"
+	fi
+
+	# TEST 6 - perform a pwritev2 with size of sysfs_atomic_unit_max_bytes + 1 logical block with no
+	# RWF_ATOMIC flag - pwritev2 should be succesful.
+	bytes_to_write=$(( "$sysfs_atomic_unit_max_bytes" + "$sysfs_logical_block_size" ))
+	bytes_written=$(run_xfs_io_pwritev2 /dev/"$ns_dev" "$bytes_to_write")
+	if [ "$bytes_written" = "$bytes_to_write" ]
+	then
+		echo "TEST 6 - pass"
+	else
+		echo "TEST 6 - fail $bytes_written - $bytes_to_write"
+	fi
+
+	# TEST 7 - perform a pwritev2 with size of sysfs_atomic_unit_max_bytes + logical block with
+	# RWF_ATOMIC flag - pwritev2 should not be succesful.
+	bytes_written=$(run_xfs_io_pwritev2_atomic /dev/"$ns_dev" "$bytes_to_write")
+	if [ "$bytes_written" = "" ]
+	then
+		echo "TEST 7 - pass"
+	else
+		echo "TEST 7 - fail $bytes_written - $bytes_to_write"
+	fi
+
+	echo "Test complete"
+}
diff --git a/tests/nvme/059.out b/tests/nvme/059.out
new file mode 100644
index 000000000000..45bc5d3566b4
--- /dev/null
+++ b/tests/nvme/059.out
@@ -0,0 +1,10 @@
+Running nvme/059
+TEST 1 - pass
+TEST 2 - pass
+TEST 3 - pass
+TEST 4 - pass
+TEST 5 - pass
+TEST 6 - pass
+pwrite: Invalid argument
+TEST 7 - pass
+Test complete
-- 
2.43.5

