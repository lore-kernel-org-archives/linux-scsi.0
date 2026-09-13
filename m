Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 493A9282F1B;
	Sun, 13 Sep 2026 14:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789308257; cv=none; b=mmWS7qUicngqH91pofjmBHRh1ncJboQmvFPP2fXFzTle+ztStaRTJmZYk3ANzCP99ngzsLv7u4qbTAiaKTVkZHNKwW5dyN9OEskz7cpW/2Ss48qJcZ++U/5N9XGDp5G/2gmev3v3alr1sjjKh5Oqi8VppwE/1x/DS7opX1/FGV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789308257; c=relaxed/simple;
	bh=A6w8QzumAPMoYIGu1t9VrqhBXXCYQmfiwAWRwDjeOeQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A1YDZHqwY/M+IkRhIRKxl6xFxEuJo+SypzlI3t1DQTSfa9IESle1ls/Pc7F+x1IF1XFz/aeYzUsHZyC9ZZ3jA5tqtjkaY8WDO41vo+cIQ4/ezwTQNbz7EhisoXMXGnsRcxaVAfDD2UmYeWzsumG/4OEl8IS1F75GkrH2OcvE8wQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qh2FA3Rd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qh2FA3Rd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDDD21F000FF;
	Sun, 13 Sep 2026 14:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789308255;
	bh=TF9Aa6g5mlo96334XJCqoFFRQR0MDrvfw+NVOccDuAM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Qh2FA3Rdb89PJgeIZKK28n4V6M1siqd/fxrszedGkR+nwrA6N+Qus10YiLmjElIAQ
	 oLduwriO7He3I05ALFops9APF+zuftr2Mg4a0FrHvP1vv5zAH/ckcubH9BkY04LXMd
	 vPO7QDElOsur/FfFXsHEbVqTLCShfTy41rT8M5c9JPlhQ63oH3PFIyxF+095dp9QEr
	 2Kqor9xj5g6MJZzMtLyFLFNHsyfv2Tb8QQCXxr+RY5A0H46RcPs9PUvu5soBUfyg2S
	 79Kc3qR8v0bsHk+JWQNv8BYFW9g96QlINyAcYQsfw22Ie5aCsFEC4espavE8oDHPWf
	 pNnrZ34rI/15A==
Date: Sun, 13 Sep 2026 22:04:08 +0800
From: Zorro Lang <zlang@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: fstests@vger.kernel.org, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Kanchan Joshi <joshi.k@samsung.com>, 
	Anuj Gupta <anuj20.g@samsung.com>, John Garry <john.g.garry@oracle.com>, 
	"Darrick J. Wong" <djwong@kernel.org>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 5/6] generic: test I/O on devices with T10 protection
 information
Message-ID: <aqaswXbERsC1hDG2@zlang-mailbox>
Mail-Followup-To: Christoph Hellwig <hch@lst.de>, fstests@vger.kernel.org, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Kanchan Joshi <joshi.k@samsung.com>, 
	Anuj Gupta <anuj20.g@samsung.com>, John Garry <john.g.garry@oracle.com>, 
	"Darrick J. Wong" <djwong@kernel.org>, linux-scsi@vger.kernel.org
References: <20260911070831.1760646-1-hch@lst.de>
 <20260911070831.1760646-6-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260911070831.1760646-6-hch@lst.de>

On Fri, Sep 11, 2026 at 09:08:23AM +0200, Christoph Hellwig wrote:
> Add a test that runs fsx in buffered and direct I/O mode on T10 PI
> type 1, 2, 3 with and without strip/insert using scsi_debug.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  tests/generic/2301     | 97 ++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/2301.out | 73 +++++++++++++++++++++++++++++++
>  2 files changed, 170 insertions(+)
>  create mode 100755 tests/generic/2301
>  create mode 100644 tests/generic/2301.out
> 
> diff --git a/tests/generic/2301 b/tests/generic/2301
> new file mode 100755
> index 000000000000..35d1fb4574e8
> --- /dev/null
> +++ b/tests/generic/2301
> @@ -0,0 +1,97 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2026 Christoph Hellwig
> +#
> +# FS QA Test No. 2301
> +#
> +# Basic FSX sanity check when using T10 protection information
> +#
> +. ./common/preamble
> +_begin_fstest auto rw pi dangerous
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -r -f $tmp.*
> +	[ -d "$SCSI_DEBUG_MNT" ] && _unmount $SCSI_DEBUG_MNT 2>/dev/null
> +	_put_scsi_debug_dev
> +}
> +
> +. ./common/scsi_debug
> +
> +_require_debugfs

Why debugfs is needed for this test case?

Others look good to me,

Reviewed-by: Zorro Lang <zlang@kernel.org>

> +_require_scsi_debug
> +# If TEST_DEV is block device, make sure current fs is a localfs which can be
> +# written on scsi_debug device
> +_require_test
> +_require_block_device $TEST_DEV
> +_require_odirect
> +
> +_fixed_by_kernel_commit 8a8685b32c07 \
> +	"iomap: don't free integrity payload that doesn't exist"
> +
> +size=$(_small_fs_size_mb 256)
> +
> +# like run_fsx(), but using a custom path
> +fsx_run()
> +{
> +	_run_fsx_on_file $SCSI_DEBUG_MNT/junk $@ || _exit 1
> +}
> +
> +test_dif()
> +{
> +	local pi_type=$1
> +	local pi_enable="$2"
> +
> +	scsi_debug_pi_opts="write_same_length=0 dif=${pi_type} dix=1"
> +	SCSI_DEBUG_DEV=`_get_scsi_debug_dev 512 512 0 $size $scsi_debug_pi_opts`
> +
> +	local integrity_path="$(_sysfs_block_integrity_path $SCSI_DEBUG_DEV)"
> +	if [ ! -d "$integrity_path" ]; then
> +		_notrun "DIF not supported by running kernel"
> +	fi
> +
> +	SCSI_DEBUG_MNT="$TEST_DIR/scsi_debug_$seq"
> +	rm -rf $SCSI_DEBUG_MNT
> +	mkdir $SCSI_DEBUG_MNT
> +
> +	_mkfs_dev $SCSI_DEBUG_DEV || \
> +		_fail "Can't make $FSTYP on DIF-enabled scsi_debug device"
> +	run_check _mount $SCSI_DEBUG_DEV $SCSI_DEBUG_MNT
> +
> +	echo $pi_enable > $integrity_path/read_verify
> +	echo $pi_enable > $integrity_path/write_generate
> +
> +	# fsx load similar to generic/091
> +	echo "Testing direct I/O for DIF type $pi_type (enabled: $pi_enable)"
> +	bsize=$($here/src/min_dio_alignment $SCSI_DEBUG_MNT $SCSI_DEBUG_DEV)
> +	fsx_run -N 10000            -l 500000 -r BSIZE -w BSIZE -Z -R -W
> +	fsx_run -N 10000  -o 8192   -l 500000 -r BSIZE -w BSIZE -Z -R -W
> +	fsx_run -N 10000  -o 32768  -l 500000 -r BSIZE -w BSIZE -Z -R -W
> +	fsx_run -N 10000  -o 8192   -l 500000 -r BSIZE -w BSIZE -Z -R -W
> +	fsx_run -N 10000  -o 32768  -l 500000 -r BSIZE -w BSIZE -Z -R -W
> +	fsx_run -N 10000  -o 128000 -l 500000 -r BSIZE -w BSIZE -Z -W
> +
> +	# fsx load similar to generic/091 but using buffered I/O
> +	echo "Testing buffered I/O for DIF type $pi_type (enabled: $pi_enable)"
> +	fsx_run -N 10000            -l 500000
> +	fsx_run -N 10000  -o 8192   -l 500000
> +	fsx_run -N 10000  -o 32768  -l 500000
> +	fsx_run -N 10000  -o 128000 -l 500000
> +
> +	[ -d "$SCSI_DEBUG_MNT" ] && _unmount $SCSI_DEBUG_MNT 2>/dev/null
> +	_put_scsi_debug_dev
> +}
> +
> +# Test with PI fully enabled
> +test_dif 1 1
> +test_dif 2 1
> +test_dif 3 1
> +
> +# Test with strip / insert in the HBA
> +test_dif 1 0
> +test_dif 2 0
> +test_dif 3 0
> +
> +# success, all done
> +_exit 0
> diff --git a/tests/generic/2301.out b/tests/generic/2301.out
> new file mode 100644
> index 000000000000..dda88676a219
> --- /dev/null
> +++ b/tests/generic/2301.out
> @@ -0,0 +1,73 @@
> +QA output created by 2301
> +Testing direct I/O for DIF type 1 (enabled: 1)
> +fsx -N 10000 -l 500000 -r BSIZE -w BSIZE -Z -R -W
> +fsx -N 10000 -o 8192 -l 500000 -r BSIZE -w BSIZE -Z -R -W
> +fsx -N 10000 -o 32768 -l 500000 -r BSIZE -w BSIZE -Z -R -W
> +fsx -N 10000 -o 8192 -l 500000 -r BSIZE -w BSIZE -Z -R -W
> +fsx -N 10000 -o 32768 -l 500000 -r BSIZE -w BSIZE -Z -R -W
> +fsx -N 10000 -o 128000 -l 500000 -r BSIZE -w BSIZE -Z -W
> +Testing buffered I/O for DIF type 1 (enabled: 1)
> +fsx -N 10000 -l 500000
> +fsx -N 10000 -o 8192 -l 500000
> +fsx -N 10000 -o 32768 -l 500000
> +fsx -N 10000 -o 128000 -l 500000
> +Testing direct I/O for DIF type 2 (enabled: 1)
> +fsx -N 10000 -l 500000 -r BSIZE -w BSIZE -Z -R -W
> +fsx -N 10000 -o 8192 -l 500000 -r BSIZE -w BSIZE -Z -R -W
> +fsx -N 10000 -o 32768 -l 500000 -r BSIZE -w BSIZE -Z -R -W
> +fsx -N 10000 -o 8192 -l 500000 -r BSIZE -w BSIZE -Z -R -W
> +fsx -N 10000 -o 32768 -l 500000 -r BSIZE -w BSIZE -Z -R -W
> +fsx -N 10000 -o 128000 -l 500000 -r BSIZE -w BSIZE -Z -W
> +Testing buffered I/O for DIF type 2 (enabled: 1)
> +fsx -N 10000 -l 500000
> +fsx -N 10000 -o 8192 -l 500000
> +fsx -N 10000 -o 32768 -l 500000
> +fsx -N 10000 -o 128000 -l 500000
> +Testing direct I/O for DIF type 3 (enabled: 1)
> +fsx -N 10000 -l 500000 -r BSIZE -w BSIZE -Z -R -W
> +fsx -N 10000 -o 8192 -l 500000 -r BSIZE -w BSIZE -Z -R -W
> +fsx -N 10000 -o 32768 -l 500000 -r BSIZE -w BSIZE -Z -R -W
> +fsx -N 10000 -o 8192 -l 500000 -r BSIZE -w BSIZE -Z -R -W
> +fsx -N 10000 -o 32768 -l 500000 -r BSIZE -w BSIZE -Z -R -W
> +fsx -N 10000 -o 128000 -l 500000 -r BSIZE -w BSIZE -Z -W
> +Testing buffered I/O for DIF type 3 (enabled: 1)
> +fsx -N 10000 -l 500000
> +fsx -N 10000 -o 8192 -l 500000
> +fsx -N 10000 -o 32768 -l 500000
> +fsx -N 10000 -o 128000 -l 500000
> +Testing direct I/O for DIF type 1 (enabled: 0)
> +fsx -N 10000 -l 500000 -r BSIZE -w BSIZE -Z -R -W
> +fsx -N 10000 -o 8192 -l 500000 -r BSIZE -w BSIZE -Z -R -W
> +fsx -N 10000 -o 32768 -l 500000 -r BSIZE -w BSIZE -Z -R -W
> +fsx -N 10000 -o 8192 -l 500000 -r BSIZE -w BSIZE -Z -R -W
> +fsx -N 10000 -o 32768 -l 500000 -r BSIZE -w BSIZE -Z -R -W
> +fsx -N 10000 -o 128000 -l 500000 -r BSIZE -w BSIZE -Z -W
> +Testing buffered I/O for DIF type 1 (enabled: 0)
> +fsx -N 10000 -l 500000
> +fsx -N 10000 -o 8192 -l 500000
> +fsx -N 10000 -o 32768 -l 500000
> +fsx -N 10000 -o 128000 -l 500000
> +Testing direct I/O for DIF type 2 (enabled: 0)
> +fsx -N 10000 -l 500000 -r BSIZE -w BSIZE -Z -R -W
> +fsx -N 10000 -o 8192 -l 500000 -r BSIZE -w BSIZE -Z -R -W
> +fsx -N 10000 -o 32768 -l 500000 -r BSIZE -w BSIZE -Z -R -W
> +fsx -N 10000 -o 8192 -l 500000 -r BSIZE -w BSIZE -Z -R -W
> +fsx -N 10000 -o 32768 -l 500000 -r BSIZE -w BSIZE -Z -R -W
> +fsx -N 10000 -o 128000 -l 500000 -r BSIZE -w BSIZE -Z -W
> +Testing buffered I/O for DIF type 2 (enabled: 0)
> +fsx -N 10000 -l 500000
> +fsx -N 10000 -o 8192 -l 500000
> +fsx -N 10000 -o 32768 -l 500000
> +fsx -N 10000 -o 128000 -l 500000
> +Testing direct I/O for DIF type 3 (enabled: 0)
> +fsx -N 10000 -l 500000 -r BSIZE -w BSIZE -Z -R -W
> +fsx -N 10000 -o 8192 -l 500000 -r BSIZE -w BSIZE -Z -R -W
> +fsx -N 10000 -o 32768 -l 500000 -r BSIZE -w BSIZE -Z -R -W
> +fsx -N 10000 -o 8192 -l 500000 -r BSIZE -w BSIZE -Z -R -W
> +fsx -N 10000 -o 32768 -l 500000 -r BSIZE -w BSIZE -Z -R -W
> +fsx -N 10000 -o 128000 -l 500000 -r BSIZE -w BSIZE -Z -W
> +Testing buffered I/O for DIF type 3 (enabled: 0)
> +fsx -N 10000 -l 500000
> +fsx -N 10000 -o 8192 -l 500000
> +fsx -N 10000 -o 32768 -l 500000
> +fsx -N 10000 -o 128000 -l 500000
> -- 
> 2.53.0
> 
