Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFB783F4830;
	Fri, 21 Aug 2026 05:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787289122; cv=none; b=JMZxM8SPSY6lOAFHgNYRJRiyAtbDs9t+QXVhSg73MLPmcGT21RieYIEBxRbqwJQYebIASDeyeF+b5Ein8MPsLhanarW8ALRwQ5grTXnT+i+7BlQclkm8uZMH5pq23NVWyZ09AUp4sdOX7pwPW0xF/TSQEc8WSnKzdIjvWW5Ppo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787289122; c=relaxed/simple;
	bh=f+KhJYmVh0KgFfkyL68HCuWa992t9LQ4N1JbD4YxNpI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a7z+1MWh4a3VYIF6gzIMEWHSvYpX8eiobbMehFqNkPJBE3Q2YznDEHVGy71yNNLGyMkVtyTcWz7iOjM5foMPwTOdDi3znNL67i4IIA/bH+I2hpvYV+PRW1ojx4VTI7zUrAcctE73NEEkcb01/ytV/eHJfpHkpHNIeaWLtskvySc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=iCPYQwdX; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="iCPYQwdX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=pPhzJnRuRN++ZtBUnrchRtGa1lyCyO9BH3pGQRDBlDw=; b=iCPYQwdXH/UOTYZd0welxFD7PM
	k+3VnnEkGZnSUybaHGy+E7LC0JQc2AxUgEuZvPQfQYlhlbjd60pFRla/M3Gdozvw6R+l0AXeV+yXB
	+gY3gnqYTJxQorcylmXEYVvvKev0Y/arf3AQB/pho7ww5hF6EzNwTyzAQYa0rrmrQZ2G98umB69+9
	Cod14sq1As5Fv1W7uRBZhvpLlUyDBn1Fce6Y+bIAs64zwb25C2JXut/O4opPrFDosRoxLeX3eCNj5
	KVZycZ0bJn2AOSfZuFdg1wMqVgYmaLwPkuS6EF4KP4CWQwmE4tIx7is/BoaJrJBXtvoBqWLWnOrXQ
	NnPX3OIw==;
Received: from [46.255.74.83] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wxHXr-0000000CYCI-2x5Z;
	Fri, 21 Aug 2026 05:12:00 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: fstests@vger.kernel.org,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	linux-scsi@vger.kernel.org
Subject: [PATCH 5/5] generic: test corruption detection using T10 protection information
Date: Fri, 21 Aug 2026 07:11:30 +0200
Message-ID: <20260821051133.1817670-6-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260821051133.1817670-1-hch@lst.de>
References: <20260821051133.1817670-1-hch@lst.de>
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
---
 tests/generic/2302     | 128 +++++++++++++++++++++++++++++++++++++++++
 tests/generic/2302.out |  21 +++++++
 2 files changed, 149 insertions(+)
 create mode 100755 tests/generic/2302
 create mode 100644 tests/generic/2302.out

diff --git a/tests/generic/2302 b/tests/generic/2302
new file mode 100755
index 000000000000..4a9d9165174b
--- /dev/null
+++ b/tests/generic/2302
@@ -0,0 +1,128 @@
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
+	local phys_blk=$(_get_file_extent_sector $testfile 0)
+	if [ -z "$phys_blk" ]; then
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
+		echo "adding to $phys_blk" >> $seqres.full
+		phys_blk=$((phys_blk + 127))
+	fi
+
+	echo "lba=$phys_blk,num=1,bit_errors=$bit_errors,reftag_adjust=$reftag_adjust" \
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
+# Note: Type 3 doesn't have a refrag, so don't test it
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

