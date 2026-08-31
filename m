Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A44C3C10B0;
	Mon, 31 Aug 2026 06:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788158797; cv=none; b=KSHmpq/IkVvJmRou2frBwPIr7j4u/J2OvQxtIQzYjFFCfV28B7o682uF6jp6N9ABb2DfsheW6mZi7AgJx6kLXC1jm7F77fw2oF7EfO7lKWyvdIlVJyIll4TDogL8CZ2s/qTugS/6PLCB8CjMCzjoK3+MFAIgNu8USBn5+Fh6roM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788158797; c=relaxed/simple;
	bh=gAoyhxitjUYi2A0ucUMKZmiLnPmYamHP/3XKl9sX5rA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JzESy3PE4V1r99alDhxLtk/ZRD7dOmhyGEKQH7iQ0Vj4VOZgE47NpicJBf0W2oIA1nj/0sJraCQJFbKEoGRWIzWOh3HwcuPZD2+mXF58YuGqXHUWFLlmqJajYBjaI//WzwBojI20f+VegHBybcsQ0u//LU6OJMwDxyiu+irF8F4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Gf4vZsKA; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Gf4vZsKA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=TmCHTskuWMcaOyciOpvFYhmOPo6rsoiVj4kzJaefWLc=; b=Gf4vZsKAa/4AbJlQepGaqYNeG0
	bafuECA20yN8QA9zaInG5Sns+SWw6Z3QxgQkZFsojs8fiZ26dBgTEFlCfZIFBgPUymk2zuX5YDg/Q
	vpaWvfktEGJUcQQwFZTeY7o69EeyQ6VUluSumyrCEWZX4HxUJ8SPfkPE4USp5hB43k49AiUxezVM5
	BD5f2LIIeXhwF9L0FmPwybC+/6AsTWbGZY/qi1ET8DuyLchCPKEtxTsaGLhLQACcWMhMjXVe/BZfX
	BTS3PhrUATRqEJC8X/F6o+mHrMbaCCU/SgOFRQl+3zx2uuHEYe7Dc+Iujy1Ff0wyOUvaKc68uY53L
	1sJDAN8w==;
Received: from [2001:4bb8:2f9:3a59:1608:d03f:db12:ee92] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x0vmt-00000008dJ6-17bM;
	Mon, 31 Aug 2026 06:46:35 +0000
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
Date: Mon, 31 Aug 2026 09:45:50 +0300
Message-ID: <20260831064557.2577241-7-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831064557.2577241-1-hch@lst.de>
References: <20260831064557.2577241-1-hch@lst.de>
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

