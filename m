Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9B7335CB76;
	Sun,  2 Aug 2026 11:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785671833; cv=none; b=Q3D/8Nd/ntraunaCb2irIGREjOrae5UiqRR00WL88ay/lk/heGN4pTHefEYIbskTy//O16o+D/n/cX/NW3TzeNoYQKyhk4ldzNZMCr38E6Yxoz+BUZh/HP86jKd3eQ9pwZiUcPwQf2Rp9HsJaMU1SsWU4BN5J7cIIxo6lkZl4Cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785671833; c=relaxed/simple;
	bh=ZvXXRf14m5AWY/HOtHl/8Gy2thue1Cb356UdymQJQpY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GeqUHNTkFXNPVIhLFtdFWcApqkCSjAk6KXMMTfZrYAREkIXBkljxWF5hdiKInmwmWeVeyvDbIQyaPoVYt4/xDFxvBvyLZBDPr3VAUMCLEtiu/LapfRfbcV6+wPGM0gUSyX90aep0AmFoBL6VTWC4Q3/7crz9g5naY4fCVC7GUek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oiv6Soz9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oiv6Soz9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 976311F000E9;
	Sun,  2 Aug 2026 11:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785671831;
	bh=dQdxaALiF695sxgGHQBEtazpr6H9yEjXBUJix3EUrS4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oiv6Soz9EnuidSAX1uUfd9C8opCCxq02ckqs2CNaesA5JavI9obLPcJIvuSMGxMTT
	 2WdLMdQL6PlVuAODr4WND7YGD593PpASVtqydSER3lgvHJumnM/pRRHEUFwIOfKIUR
	 /n+cctY0SGHa4IY2sCJ7NbZMw5cd1cWpT2agD7d7XnWd8SZVaC6NvgAuHY9JN0wbk9
	 pi0CUztt6DiD+UahGGnzHCj1Yi+Fkm5PIAAa1MXv9L9C+Noqo3ce8peJq+/AHQPky+
	 3PhZ4CFO6YCdtFiX4j1FL1iIXpp2Kj9HAJML37ynRaU/EMg381/5N6YUQ1u4FvpZWX
	 2SRRNK3cxtnaQ==
Date: Sun, 2 Aug 2026 19:57:04 +0800
From: Zorro Lang <zlang@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: fstests@vger.kernel.org, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Kanchan Joshi <joshi.k@samsung.com>, 
	Anuj Gupta <anuj20.g@samsung.com>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 4/4] generic: test corruption detection using T10
 protection information
Message-ID: <am8s1_vH6tqpjl1l@zlang-mailbox>
Mail-Followup-To: Christoph Hellwig <hch@lst.de>, fstests@vger.kernel.org, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Kanchan Joshi <joshi.k@samsung.com>, 
	Anuj Gupta <anuj20.g@samsung.com>, linux-scsi@vger.kernel.org
References: <20260723142856.108193-1-hch@lst.de>
 <20260723142856.108193-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723142856.108193-5-hch@lst.de>

On Thu, Jul 23, 2026 at 04:28:47PM +0200, Christoph Hellwig wrote:
> Add a test that simulates bit flips in data and misdirected writes and
> checks that file systems detect it when run on devices using protection
> information.
> 
> This requires the new scsi_debug corruption injection.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  tests/generic/2302     | 143 +++++++++++++++++++++++++++++++++++++++++
>  tests/generic/2302.out |  21 ++++++
>  2 files changed, 164 insertions(+)
>  create mode 100755 tests/generic/2302
>  create mode 100644 tests/generic/2302.out
> 
> diff --git a/tests/generic/2302 b/tests/generic/2302
> new file mode 100755
> index 000000000000..5fff1f5e5015
> --- /dev/null
> +++ b/tests/generic/2302
> @@ -0,0 +1,143 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2026 Christoph Hellwig
> +#
> +# FS QA Test No. 2302
> +#
> +# Test that T10 DIF detects bitflips and misplaced writes.
> +#
> +. ./common/preamble
> +_begin_fstest auto rw
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
> +. ./common/filter
> +
> +_require_scsi_debug
> +# If TEST_DEV is block device, make sure current fs is a localfs which can be
> +# written on scsi_debug device
> +_require_test
> +_require_block_device $TEST_DEV
> +
> +# FIEMAP on Btrfs returns logical addresses within the filesystem's address
> +# space, not physical device offsets. Writing to these offsets on $SCRATCH_DEV
> +# would corrupt the filesystem in multi-device setups.
> +_exclude_fs btrfs
> +
> +size=$(_small_fs_size_mb 256)
> +
> +# Get the physical block offset (in bytes) of the file's first block on device
> +get_phys_blk()
> +{
> +	local file="$1"
> +	local fiemap_output
> +	local phys_blk
> +
> +	fiemap_output=$($XFS_IO_PROG -r -c "fiemap -v" "$file" 2>/dev/null)

_require_xfs_io_command fiemap

> +	phys_blk=$(echo "$fiemap_output" | _filter_xfs_io_fiemap | head -1 | awk '{print $3}')

This logic looks like common/rc:_get_file_extent_sector(), can this
function help?

> +	if [ -z "$phys_blk" ]; then
> +		echo ""
> +		return
> +	fi
> +	echo $phys_blk
> +}
> +
> +test_dif()
> +{
> +	local pi_type=$1
> +	local last=$2
> +	local bit_errors=$3
> +	local reftag_adjust=$4
> +
> +	echo -n "Testing DIF type $pi_type "
> +	if [ "$bit_errors" -gt "0" ]; then
> +		echo -n "bit errors ($bit_errors) in "
> +	fi
> +	if [ "$reftag_adjust" -ne "0" ]; then
> +		echo -n "reftag adjustment by $reftag_adjust in "
> +	fi
> +	if [ "$last" -eq 1 ]; then
> +		echo "last sector"
> +	else
> +		echo "first sector"
> +	fi
> +
> +	scsi_debug_pi_opts="write_same_length=0 dif=${pi_type} dix=1"
> +	SCSI_DEBUG_DEV=`_get_scsi_debug_dev 512 512 0 $size $scsi_debug_pi_opts`
> +
> +	SCSI_DEBUG_MNT="$TEST_DIR/scsi_debug_$seq"
> +	rm -rf $SCSI_DEBUG_MNT
> +	mkdir $SCSI_DEBUG_MNT
> +
> +	_mkfs_dev $SCSI_DEBUG_DEV || \
> +		_fail "Can't make $FSTYP on DIF-enabled scsi_debug device"
> +	run_check _mount $SCSI_DEBUG_DEV $SCSI_DEBUG_MNT
> +
> +	local blksz=$(_get_block_size $SCSI_DEBUG_MNT)
> +	local testfile="$SCSI_DEBUG_MNT/test"
> +
> +	$XFS_IO_PROG -d -f \

_require_odirect ?

> +		-c "pwrite -S 0x66 0 $((128 * blksz))" \
> +		-c fsync \
> +		$testfile >> $seqres.full 2>&1
> +
> +	local phys_blk=$(get_phys_blk $testfile)
> +	if [ -z "$phys_blk" ]; then
> +		_fail "$test_name: failed to get physical block offset via fiemap"
> +	fi
> +
> +	local dev=$(_short_dev $SCSI_DEBUG_DEV)
> +	local debugfs_dir=$(ls /sys/block/$dev/device/scsi_device/)
> +	local debugfs_file="/sys/kernel/debug/scsi_debug/$debugfs_dir/corrupt"

_require_debugfs

> +
> +	if [ ! -f "$debugfs_file" ]; then
> +		_notrun "scsi_debug corruption injection not supported"
> +	fi
> +
> +	if [ "$last" -eq 1 ]; then
> +		echo "adding to $phys_blk" >> $seqres.full
> +		phys_blk=$((phys_blk + 127))
> +	fi
> +
> +	echo "lba=$phys_blk,num=1,bit_errors=$bit_errors,reftag_adjust=$reftag_adjust" \
> +		 > $debugfs_file
> +
> +	$XFS_IO_PROG -d -f \
> +		-c "pread 0 $((128 * blksz))" \
> +		$testfile
> +
> +	[ -d "$SCSI_DEBUG_MNT" ] && _unmount $SCSI_DEBUG_MNT 2>/dev/null
> +	_put_scsi_debug_dev
> +}
> +
> +# test data corruption in first block
> +test_dif 1 0 2 0
> +test_dif 2 0 2 0
> +test_dif 3 0 2 0
> +
> +# test data corruption in last block
> +test_dif 1 1 2 0
> +test_dif 2 1 2 0
> +test_dif 3 1 2 0
> +
> +
> +# Note: Type 3 doesn't have a refrag, so don't test it
> +
> +# reftag mismatch in first block
> +test_dif 1 0 0 8
> +test_dif 2 0 0 8
> +
> +# reftag mismatch in last block
> +test_dif 1 1 0 8
> +test_dif 2 1 0 8
> +
> +# success, all done
> +status=0
> +exit

_exit 0

> diff --git a/tests/generic/2302.out b/tests/generic/2302.out
> new file mode 100644
> index 000000000000..03b68d904943
> --- /dev/null
> +++ b/tests/generic/2302.out
> @@ -0,0 +1,21 @@
> +QA output created by 2302
> +Testing DIF type 1 bit errors (2) in first sector
> +pread: Invalid or incomplete multibyte or wide character
> +Testing DIF type 2 bit errors (2) in first sector
> +pread: Invalid or incomplete multibyte or wide character
> +Testing DIF type 3 bit errors (2) in first sector
> +pread: Invalid or incomplete multibyte or wide character
> +Testing DIF type 1 bit errors (2) in last sector
> +pread: Invalid or incomplete multibyte or wide character
> +Testing DIF type 2 bit errors (2) in last sector
> +pread: Invalid or incomplete multibyte or wide character
> +Testing DIF type 3 bit errors (2) in last sector
> +pread: Invalid or incomplete multibyte or wide character
> +Testing DIF type 1 reftag adjustment by 8 in first sector
> +pread: Invalid or incomplete multibyte or wide character
> +Testing DIF type 2 reftag adjustment by 8 in first sector
> +pread: Invalid or incomplete multibyte or wide character
> +Testing DIF type 1 reftag adjustment by 8 in last sector
> +pread: Invalid or incomplete multibyte or wide character
> +Testing DIF type 2 reftag adjustment by 8 in last sector
> +pread: Invalid or incomplete multibyte or wide character
> -- 
> 2.53.0
> 
