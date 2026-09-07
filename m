Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DD6143553A;
	Mon,  7 Sep 2026 07:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788767947; cv=none; b=A/12f1KUyvJRrM3O088VMHkULkV3abSjK0k7MyD5pWYvefRIkA1xGOrDs8bW3Z4YDZtMGcZdzepe+sAGs/VIvMrtHIn6ZH5JogHr1M+UEVm2u+0ChqiWnO2jjIo+HCtWZK2nFe+X9Jv/NgwuBVkYk4VtO0NQvFSXOW/MMnebKIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788767947; c=relaxed/simple;
	bh=BrgoIi2tM9ZLDgFlvyE65ZKhVAjvgcJhKGh7cC12ToE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qcgwQILEwXqNSLHQmXiXH0jWBaOxt5yzXf8igRrgg6dazyVnutBWWi9KGthc9VaFGgLV6Hac0vJ9KDAc6zUXh1zH+jtZSrjD3J0GJkW+h0Lv6VllTB51o7gxY+FdYEWRfRio9U1R4iD+YUERZqa/0D1D9O85ZbXoMAaRTtHUyQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=PrzC81xh; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PrzC81xh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=DZiPHhB+rmjZw90vIVwh/r13sx3kbeUp1ru1lqEbJJk=; b=PrzC81xhoB8/DB5SoQUsahMmv6
	WjRtlTaGRtYoB3oZhgtdyqD1uyc9wftMy7TjlI9UEooNRo2qd2+pHbmZCvevK7BQhEulBeqHAC71T
	xEmeqglTdwSJeBIu80iWhDaVVrSwxXxeTshZMl2MVimPJ1M8Vu/cR3j5x1JoWX4z/6PIuFX0QH+L8
	EAU/27P6GOIrooqajdj6B7bbESFDLjjzz0cSY/MnhHcMRTvyyBNC0I9Go+WmUyI8MZf1jt+Nq87mz
	rsLff9DpEcywO7wR7+jRTO1QAJN0ioLIHVEMJU6ox4vJ2VR4z/B5Xdu/qD9arIN/pw0C8YTG7KqQH
	TjY+ofxw==;
Received: from [93.123.20.121] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x3UFq-00000006DEZ-0riX;
	Mon, 07 Sep 2026 07:59:03 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: fstests@vger.kernel.org,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	John Garry <john.g.garry@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-scsi@vger.kernel.org
Subject: [PATCH 5/6] generic: test I/O on devices with T10 protection information
Date: Mon,  7 Sep 2026 10:58:15 +0300
Message-ID: <20260907075822.749818-6-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260907075822.749818-1-hch@lst.de>
References: <20260907075822.749818-1-hch@lst.de>
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
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/generic/2301     | 97 ++++++++++++++++++++++++++++++++++++++++++
 tests/generic/2301.out | 73 +++++++++++++++++++++++++++++++
 2 files changed, 170 insertions(+)
 create mode 100755 tests/generic/2301
 create mode 100644 tests/generic/2301.out

diff --git a/tests/generic/2301 b/tests/generic/2301
new file mode 100755
index 000000000000..35d1fb4574e8
--- /dev/null
+++ b/tests/generic/2301
@@ -0,0 +1,97 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Christoph Hellwig
+#
+# FS QA Test No. 2301
+#
+# Basic FSX sanity check when using T10 protection information
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
+_fixed_by_kernel_commit 8a8685b32c07 \
+	"iomap: don't free integrity payload that doesn't exist"
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
+	echo $pi_enable > $integrity_path/read_verify
+	echo $pi_enable > $integrity_path/write_generate
+
+	# fsx load similar to generic/091
+	echo "Testing direct I/O for DIF type $pi_type (enabled: $pi_enable)"
+	bsize=$($here/src/min_dio_alignment $SCSI_DEBUG_MNT $SCSI_DEBUG_DEV)
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

