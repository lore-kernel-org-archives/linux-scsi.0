Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90F0A3C0621;
	Mon, 31 Aug 2026 06:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788158791; cv=none; b=pn8dBdF+b4dUFP4yDi5xT/I7+mURdnDq+lM53LPz9XejiONH6bEq7gAn5PB/Np0qnqPf7HW9YtJ1TXHCp6RT/p448xUitp1qIoIroX+SertT9B2DaRRfQKcQrlXU1mIzrr+zVu1EPza3tcnfkBVhaf1GNquzJ7UXaSeSljkFAk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788158791; c=relaxed/simple;
	bh=p5hdJLuvFuOvCWkUvzXR5an1Q4NTABxebzaBqSiKbHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dw6R4qb36/2CH2pEMcA6wSQ05+lVLHq5hH/5cxDYfN1/ekhEtjPIVdgjkF4rpgqVAPGmnsGwEQIBQD7Lh1dy45wsPnUCgrQtcl4wFTKUH3L9hAGyX61ewg5nkRg2yOxkIPAIJvlzjNrqiLOluu0vbq7zEJreb+Limr7x37uuid8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=0e9IDhS4; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="0e9IDhS4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=0urLBAtV6DlwQRY8ocpQROCHD5GmkWza8ATErD//6oE=; b=0e9IDhS4oVxAyFmLRlqDKMJUS1
	+uR/3q9pT0g+d/1k7uENFDThQf4No+Iex0S0ht3WiEBNp0Mvi19GYn3gbrQMRl423lWfodNKxYcYb
	qPDRcBhZxeyS2Dzi/r69Cy6kF3d8J3a6KJRI7V/8Z4at8yvEdTYaHGmMupiY5Ryzu6sfh0P2fU3u4
	1Qr0EN72rlZRasjWTAhHkAhsfN9drfeudiSD0FwXlNQnidkHNE0vjuElWddmDG3PDFjcGt6P+U7Mp
	VWUdR3bIOGi/eMeArTuWETe7sf+jgor80hEXfXNPVk8n95zNp9D9Qinxc45caGvrPpzf3bbNeg0Wv
	sT3qaJPg==;
Received: from [2001:4bb8:2f9:3a59:1608:d03f:db12:ee92] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x0vmm-00000008dIg-3PAE;
	Mon, 31 Aug 2026 06:46:29 +0000
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
Date: Mon, 31 Aug 2026 09:45:49 +0300
Message-ID: <20260831064557.2577241-6-hch@lst.de>
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

Add a test that runs fsx in buffered and direct I/O mode on T10 PI
type 1, 2, 3 with and without strip/insert using scsi_debug.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/generic/2301     | 94 ++++++++++++++++++++++++++++++++++++++++++
 tests/generic/2301.out | 73 ++++++++++++++++++++++++++++++++
 2 files changed, 167 insertions(+)
 create mode 100755 tests/generic/2301
 create mode 100644 tests/generic/2301.out

diff --git a/tests/generic/2301 b/tests/generic/2301
new file mode 100755
index 000000000000..6bf026bfeb60
--- /dev/null
+++ b/tests/generic/2301
@@ -0,0 +1,94 @@
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

