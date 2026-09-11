Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84519448BB2;
	Fri, 11 Sep 2026 07:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789110549; cv=none; b=YibRWh0Vv1j+ePG25GY7s6RWzWuHpZoCirUZ/JS1xbzNOXgp/wUBSA49hHEdpngjj7mSyJD/dJj1o1WknRmf9bqHBTj3aImmwngYE1iRNrUbR4p4CAAo6XQM8lYt1Os8w3Fv3PUAeMcezwKmuMQyQHqubsHDq08Lw9WqGqOJdvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789110549; c=relaxed/simple;
	bh=0Ibi5vcRDS7q2eBsXpM8Xai/0gVTS23udXIHqEMheJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TCthWQt716KxQSifxTLcHU0sWR5Eq8LUtOGH/tPvSvemreaLAs42kSZuhm/8/4PisKMjdmvYfvoUXVS2vMTVvLVWUwHfpluhIQe+FeuD2sm1cLuvRNSjsjnV+Tve53iU5KikfL5ae0qWo+SFVr3sAl/IdqZuCt+eo4LzqTWE5iI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=aNrukXv8; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="aNrukXv8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=kmIC2ZlF2OZA17eg/uQz44ldkSHk6k6OSGFddwwKYms=; b=aNrukXv8UBme9/Oau2FAAP2w+M
	ntWsgzYk8/rE89MBoNLTzMuOU2L5c7oSHwmKaktBqLI/Vcw+g/5qb9KTWJX4siHd6LCNL2YWrlJmb
	xHPTwWRp50AEm3SyhzJZK+gH2fEkKz9on9BUyYaHU49+86rDWqIIYe4ziTk1Vhe2aTAD858Gp9JEJ
	zmLPii5zHsWMO5/GlbFAvtjrapQgO5ObqK2kXPnOmII03r1x26PmqupArfjW+bZIY4zY1OM85tblE
	LNJBm/X8adqQv1W9SZDPrgcFxEGNavovtzuufk0EBYoQxawI1nKH6VHc83TThDeBu6r/sQ93yM0xf
	vgGu+kfQ==;
Received: from 2a02-8389-2301-9f00-b711-947d-6c5b-1af5.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b711:947d:6c5b:1af5] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x4vNY-0000000G09E-2CBP;
	Fri, 11 Sep 2026 07:08:56 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: fstests@vger.kernel.org,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	John Garry <john.g.garry@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-scsi@vger.kernel.org
Subject: [PATCH 6/6] generic: test corruption detection using T10 protection information
Date: Fri, 11 Sep 2026 09:08:24 +0200
Message-ID: <20260911070831.1760646-7-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260911070831.1760646-1-hch@lst.de>
References: <20260911070831.1760646-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Add a test that simulates bit flips in data and misdirected writes and
checks that file systems detect it when run on devices using protection
information.

This requires the new scsi_debug corruption injection.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/generic/2302     | 133 +++++++++++++++++++++++++++++++++++++++++
 tests/generic/2302.out |  21 +++++++
 2 files changed, 154 insertions(+)
 create mode 100755 tests/generic/2302
 create mode 100644 tests/generic/2302.out

diff --git a/tests/generic/2302 b/tests/generic/2302
new file mode 100755
index 000000000000..fd83c64dfff1
--- /dev/null
+++ b/tests/generic/2302
@@ -0,0 +1,133 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Christoph Hellwig
+#
+# FS QA Test No. 2302
+#
+# Test that T10 DIF detects bitflips and misplaced writes.
+#
+. ./common/preamble
+_begin_fstest auto rw pi
+
+_cleanup()
+{
+	cd /
+	rm -r -f $tmp.*
+	[ -d "$SCSI_DEBUG_MNT" ] && _unmount $SCSI_DEBUG_MNT 2>/dev/null
+	_put_scsi_debug_dev
+}
+
+. ./common/scsi_debug
+. ./common/filter
+
+_require_debugfs
+_require_scsi_debug
+# If TEST_DEV is block device, make sure current fs is a localfs which can be
+# written on scsi_debug device
+_require_test
+_require_block_device $TEST_DEV
+_require_xfs_io_command fiemap
+_require_odirect
+
+# FIEMAP on Btrfs returns logical addresses within the filesystem's address
+# space, not physical device offsets. Writing to these offsets on $SCRATCH_DEV
+# would corrupt the filesystem in multi-device setups.
+_exclude_fs btrfs
+
+size=$(_small_fs_size_mb 256)
+
+test_dif()
+{
+	local pi_type=$1
+	local last=$2
+	local bit_errors=$3
+	local reftag_adjust=$4
+
+	echo -n "Testing DIF type $pi_type "
+	if [ "$bit_errors" -gt "0" ]; then
+		echo -n "bit errors ($bit_errors) in "
+	fi
+	if [ "$reftag_adjust" -ne "0" ]; then
+		echo -n "reftag adjustment by $reftag_adjust in "
+	fi
+	if [ "$last" -eq 1 ]; then
+		echo "last sector"
+	else
+		echo "first sector"
+	fi
+
+	scsi_debug_pi_opts="write_same_length=0 dif=${pi_type} dix=1"
+	SCSI_DEBUG_DEV=`_get_scsi_debug_dev 512 512 0 $size $scsi_debug_pi_opts`
+
+	local integrity_path="$(_sysfs_block_integrity_path $SCSI_DEBUG_DEV)"
+	if [ ! -d "$integrity_path" ]; then
+		_notrun "DIF not supported by running kernel"
+	fi
+
+	SCSI_DEBUG_MNT="$TEST_DIR/scsi_debug_$seq"
+	rm -rf $SCSI_DEBUG_MNT
+	mkdir $SCSI_DEBUG_MNT
+
+	_mkfs_dev $SCSI_DEBUG_DEV || \
+		_fail "Can't make $FSTYP on DIF-enabled scsi_debug device"
+	run_check _mount $SCSI_DEBUG_DEV $SCSI_DEBUG_MNT
+
+	local blksz=$(_get_block_size $SCSI_DEBUG_MNT)
+	local testfile="$SCSI_DEBUG_MNT/test"
+
+	$XFS_IO_PROG -d -f \
+		-c "pwrite -S 0x66 0 $((128 * blksz))" \
+		-c fsync \
+		$testfile >> $seqres.full 2>&1
+
+	local phys_sector=$(_get_file_extent_sector $testfile 0)
+	if [ -z "$phys_sector" ]; then
+		_fail "$test_name: failed to get physical block offset via fiemap"
+	fi
+
+	local dev=$(_short_dev $SCSI_DEBUG_DEV)
+	local debugfs_dir=$(ls /sys/block/$dev/device/scsi_device/)
+	local debugfs_file="/sys/kernel/debug/scsi_debug/$debugfs_dir/corrupt"
+
+	if [ ! -f "$debugfs_file" ]; then
+		_notrun "scsi_debug corruption injection not supported"
+	fi
+
+	if [ "$last" -eq 1 ]; then
+		echo "adding to $phys_sector" >> $seqres.full
+		phys_sector=$((phys_sector + (128 * blksz / 512) - 1))
+	fi
+
+	echo "lba=$phys_sector,num=1,bit_errors=$bit_errors,reftag_adjust=$reftag_adjust" \
+		 > $debugfs_file
+
+	$XFS_IO_PROG -d -f \
+		-c "pread 0 $((128 * blksz))" \
+		$testfile
+
+	[ -d "$SCSI_DEBUG_MNT" ] && _unmount $SCSI_DEBUG_MNT 2>/dev/null
+	_put_scsi_debug_dev
+}
+
+# test data corruption in first block
+test_dif 1 0 2 0
+test_dif 2 0 2 0
+test_dif 3 0 2 0
+
+# test data corruption in last block
+test_dif 1 1 2 0
+test_dif 2 1 2 0
+test_dif 3 1 2 0
+
+
+# Note: Type 3 doesn't have a reftag, so don't test it
+
+# reftag mismatch in first block
+test_dif 1 0 0 8
+test_dif 2 0 0 8
+
+# reftag mismatch in last block
+test_dif 1 1 0 8
+test_dif 2 1 0 8
+
+_exit 0
diff --git a/tests/generic/2302.out b/tests/generic/2302.out
new file mode 100644
index 000000000000..03b68d904943
--- /dev/null
+++ b/tests/generic/2302.out
@@ -0,0 +1,21 @@
+QA output created by 2302
+Testing DIF type 1 bit errors (2) in first sector
+pread: Invalid or incomplete multibyte or wide character
+Testing DIF type 2 bit errors (2) in first sector
+pread: Invalid or incomplete multibyte or wide character
+Testing DIF type 3 bit errors (2) in first sector
+pread: Invalid or incomplete multibyte or wide character
+Testing DIF type 1 bit errors (2) in last sector
+pread: Invalid or incomplete multibyte or wide character
+Testing DIF type 2 bit errors (2) in last sector
+pread: Invalid or incomplete multibyte or wide character
+Testing DIF type 3 bit errors (2) in last sector
+pread: Invalid or incomplete multibyte or wide character
+Testing DIF type 1 reftag adjustment by 8 in first sector
+pread: Invalid or incomplete multibyte or wide character
+Testing DIF type 2 reftag adjustment by 8 in first sector
+pread: Invalid or incomplete multibyte or wide character
+Testing DIF type 1 reftag adjustment by 8 in last sector
+pread: Invalid or incomplete multibyte or wide character
+Testing DIF type 2 reftag adjustment by 8 in last sector
+pread: Invalid or incomplete multibyte or wide character
-- 
2.53.0

