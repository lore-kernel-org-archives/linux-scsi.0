Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA1C23F6C32;
	Fri, 21 Aug 2026 05:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787289118; cv=none; b=o3ncItaDc4HWnQE7S1eQ249d14SlwudonodL+YgB8KfIEXCriSa23IszfuBXuBRPUm/6+KsD3BqbMneDH08z1beMJI/TunG2T1vBYpnzqf5gFhVbeN/+rWaL40C3lk7rnLrzPFinxQpgI6eVtuzFT5Mq2KP9WVu6QMYXHcxz0x8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787289118; c=relaxed/simple;
	bh=Nv7WLQ1pWDaiLSuX0rjcKWoLTbaANdhLKgdoRaC4xiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nqqNn4F+KYmZOwKctvckMJ/o4W6MgaOn+DpIwR4ZTR1phXYyhviXMwMef96NiLmG71FwpIy0K2pRC7IxSvDECU8UN2uY59mJo8XkQDPeELwSVzAAOPwyBhhHhNjmVq+/bBB5oQYYKJ9QHx1okbJjHV+5gVqLQ94gjepKXB+otTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=j81mOb27; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="j81mOb27"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=uROKeIwCegtc0p/j5eP1QBSYpT5q0loELKbQxjySUgs=; b=j81mOb27pcK6ZyCLyvPB2JuOVg
	GJEWAEy05Lh8kSJU1c50bcCH5DguHxrA7oecPQLWBI2hsutwlycPVSeV9qkou+PKfyCsF48SaSvsR
	kLidsxHGhSz3XeEBNIvd4Md1GibeOYxk3mkf6woLFus/cdHl40/4l19CJdmRS+0sF3x/vWWaGaxES
	fZ/iDr1UVnKuJYA4/0zDPpWY1ZCFzwsCu0kHYEQCNr3k+9BSuXLdi8pf7n/8BJIQV493sBTnNyC83
	p0VB+X+MAi026L4NqQIqNOnolMpYhVspc0s2hdAkbHQM1i2/BKJFKxicoaTrqaYFuNX35D1xCMY1i
	hTie+nGg==;
Received: from [46.255.74.83] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wxHXn-0000000CYBl-3aiX;
	Fri, 21 Aug 2026 05:11:56 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: fstests@vger.kernel.org,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	linux-scsi@vger.kernel.org
Subject: [PATCH 4/5] generic: test I/O on devices with T10 protection information
Date: Fri, 21 Aug 2026 07:11:29 +0200
Message-ID: <20260821051133.1817670-5-hch@lst.de>
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

Add a test that runs fsx in buffered and direct I/O mode on T10 PI
type 1, 2, 3 with and without strip/insert using scsi_debug.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/generic/2301     | 91 ++++++++++++++++++++++++++++++++++++++++++
 tests/generic/2301.out | 73 +++++++++++++++++++++++++++++++++
 2 files changed, 164 insertions(+)
 create mode 100755 tests/generic/2301
 create mode 100644 tests/generic/2301.out

diff --git a/tests/generic/2301 b/tests/generic/2301
new file mode 100755
index 000000000000..ba6952855f55
--- /dev/null
+++ b/tests/generic/2301
@@ -0,0 +1,91 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Christoph Hellwig
+#
+# FS QA Test No. 2301
+#
+# Basix FSX sanity check when using T10 protection information
+#
+. ./common/preamble
+_begin_fstest auto rw pi dangerous
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
+
+_require_debugfs
+_require_scsi_debug
+# If TEST_DEV is block device, make sure current fs is a localfs which can be
+# written on scsi_debug device
+_require_test
+_require_block_device $TEST_DEV
+_require_odirect
+
+size=$(_small_fs_size_mb 256)
+
+# like run_fsx(), but using a custom path
+fsx_run()
+{
+	_run_fsx_on_file $SCSI_DEBUG_MNT/junk $@ || _exit 1
+}
+
+test_dif()
+{
+	local pi_type=$1
+	local pi_enable="$2"
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
+	bsize=$($here/src/min_dio_alignment $SCSI_DEBUG_MNT $SCSI_DEBUG_DEV)
+
+	local integrity_path="$(_sysfs_block_integrity_path $SCSI_DEBUG_DEV)"
+	echo $pi_enable > $integrity_path/read_verify
+	echo $pi_enable > $integrity_path/write_generate
+
+	# fsx load similar to generic/091
+	echo "Testing direct I/O for DIF type $pi_type (enabled: $pi_enable)"
+	local dio_opts="-r PSIZE -t BSIZE -w BSIZE"
+	fsx_run -N 10000            -l 500000 -r BSIZE -w BSIZE -Z -R -W
+	fsx_run -N 10000  -o 8192   -l 500000 -r BSIZE -w BSIZE -Z -R -W
+	fsx_run -N 10000  -o 32768  -l 500000 -r BSIZE -w BSIZE -Z -R -W
+	fsx_run -N 10000  -o 8192   -l 500000 -r BSIZE -w BSIZE -Z -R -W
+	fsx_run -N 10000  -o 32768  -l 500000 -r BSIZE -w BSIZE -Z -R -W
+	fsx_run -N 10000  -o 128000 -l 500000 -r BSIZE -w BSIZE -Z -W
+
+	# fsx load similar to generic/091 but using buffered I/O
+	echo "Testing buffered I/O for DIF type $pi_type (enabled: $pi_enable)"
+	fsx_run -N 10000            -l 500000
+	fsx_run -N 10000  -o 8192   -l 500000
+	fsx_run -N 10000  -o 32768  -l 500000
+	fsx_run -N 10000  -o 128000 -l 500000
+
+	[ -d "$SCSI_DEBUG_MNT" ] && _unmount $SCSI_DEBUG_MNT 2>/dev/null
+	_put_scsi_debug_dev
+}
+
+# Test with PI fully enabled
+test_dif 1 1
+test_dif 2 1
+test_dif 3 1
+
+# Test with strip / insert in the HBA
+test_dif 1 0
+test_dif 2 0
+test_dif 3 0
+
+# success, all done
+_exit 0
diff --git a/tests/generic/2301.out b/tests/generic/2301.out
new file mode 100644
index 000000000000..dda88676a219
--- /dev/null
+++ b/tests/generic/2301.out
@@ -0,0 +1,73 @@
+QA output created by 2301
+Testing direct I/O for DIF type 1 (enabled: 1)
+fsx -N 10000 -l 500000 -r BSIZE -w BSIZE -Z -R -W
+fsx -N 10000 -o 8192 -l 500000 -r BSIZE -w BSIZE -Z -R -W
+fsx -N 10000 -o 32768 -l 500000 -r BSIZE -w BSIZE -Z -R -W
+fsx -N 10000 -o 8192 -l 500000 -r BSIZE -w BSIZE -Z -R -W
+fsx -N 10000 -o 32768 -l 500000 -r BSIZE -w BSIZE -Z -R -W
+fsx -N 10000 -o 128000 -l 500000 -r BSIZE -w BSIZE -Z -W
+Testing buffered I/O for DIF type 1 (enabled: 1)
+fsx -N 10000 -l 500000
+fsx -N 10000 -o 8192 -l 500000
+fsx -N 10000 -o 32768 -l 500000
+fsx -N 10000 -o 128000 -l 500000
+Testing direct I/O for DIF type 2 (enabled: 1)
+fsx -N 10000 -l 500000 -r BSIZE -w BSIZE -Z -R -W
+fsx -N 10000 -o 8192 -l 500000 -r BSIZE -w BSIZE -Z -R -W
+fsx -N 10000 -o 32768 -l 500000 -r BSIZE -w BSIZE -Z -R -W
+fsx -N 10000 -o 8192 -l 500000 -r BSIZE -w BSIZE -Z -R -W
+fsx -N 10000 -o 32768 -l 500000 -r BSIZE -w BSIZE -Z -R -W
+fsx -N 10000 -o 128000 -l 500000 -r BSIZE -w BSIZE -Z -W
+Testing buffered I/O for DIF type 2 (enabled: 1)
+fsx -N 10000 -l 500000
+fsx -N 10000 -o 8192 -l 500000
+fsx -N 10000 -o 32768 -l 500000
+fsx -N 10000 -o 128000 -l 500000
+Testing direct I/O for DIF type 3 (enabled: 1)
+fsx -N 10000 -l 500000 -r BSIZE -w BSIZE -Z -R -W
+fsx -N 10000 -o 8192 -l 500000 -r BSIZE -w BSIZE -Z -R -W
+fsx -N 10000 -o 32768 -l 500000 -r BSIZE -w BSIZE -Z -R -W
+fsx -N 10000 -o 8192 -l 500000 -r BSIZE -w BSIZE -Z -R -W
+fsx -N 10000 -o 32768 -l 500000 -r BSIZE -w BSIZE -Z -R -W
+fsx -N 10000 -o 128000 -l 500000 -r BSIZE -w BSIZE -Z -W
+Testing buffered I/O for DIF type 3 (enabled: 1)
+fsx -N 10000 -l 500000
+fsx -N 10000 -o 8192 -l 500000
+fsx -N 10000 -o 32768 -l 500000
+fsx -N 10000 -o 128000 -l 500000
+Testing direct I/O for DIF type 1 (enabled: 0)
+fsx -N 10000 -l 500000 -r BSIZE -w BSIZE -Z -R -W
+fsx -N 10000 -o 8192 -l 500000 -r BSIZE -w BSIZE -Z -R -W
+fsx -N 10000 -o 32768 -l 500000 -r BSIZE -w BSIZE -Z -R -W
+fsx -N 10000 -o 8192 -l 500000 -r BSIZE -w BSIZE -Z -R -W
+fsx -N 10000 -o 32768 -l 500000 -r BSIZE -w BSIZE -Z -R -W
+fsx -N 10000 -o 128000 -l 500000 -r BSIZE -w BSIZE -Z -W
+Testing buffered I/O for DIF type 1 (enabled: 0)
+fsx -N 10000 -l 500000
+fsx -N 10000 -o 8192 -l 500000
+fsx -N 10000 -o 32768 -l 500000
+fsx -N 10000 -o 128000 -l 500000
+Testing direct I/O for DIF type 2 (enabled: 0)
+fsx -N 10000 -l 500000 -r BSIZE -w BSIZE -Z -R -W
+fsx -N 10000 -o 8192 -l 500000 -r BSIZE -w BSIZE -Z -R -W
+fsx -N 10000 -o 32768 -l 500000 -r BSIZE -w BSIZE -Z -R -W
+fsx -N 10000 -o 8192 -l 500000 -r BSIZE -w BSIZE -Z -R -W
+fsx -N 10000 -o 32768 -l 500000 -r BSIZE -w BSIZE -Z -R -W
+fsx -N 10000 -o 128000 -l 500000 -r BSIZE -w BSIZE -Z -W
+Testing buffered I/O for DIF type 2 (enabled: 0)
+fsx -N 10000 -l 500000
+fsx -N 10000 -o 8192 -l 500000
+fsx -N 10000 -o 32768 -l 500000
+fsx -N 10000 -o 128000 -l 500000
+Testing direct I/O for DIF type 3 (enabled: 0)
+fsx -N 10000 -l 500000 -r BSIZE -w BSIZE -Z -R -W
+fsx -N 10000 -o 8192 -l 500000 -r BSIZE -w BSIZE -Z -R -W
+fsx -N 10000 -o 32768 -l 500000 -r BSIZE -w BSIZE -Z -R -W
+fsx -N 10000 -o 8192 -l 500000 -r BSIZE -w BSIZE -Z -R -W
+fsx -N 10000 -o 32768 -l 500000 -r BSIZE -w BSIZE -Z -R -W
+fsx -N 10000 -o 128000 -l 500000 -r BSIZE -w BSIZE -Z -W
+Testing buffered I/O for DIF type 3 (enabled: 0)
+fsx -N 10000 -l 500000
+fsx -N 10000 -o 8192 -l 500000
+fsx -N 10000 -o 32768 -l 500000
+fsx -N 10000 -o 128000 -l 500000
-- 
2.53.0

