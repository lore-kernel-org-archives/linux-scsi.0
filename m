Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47B38435529;
	Fri, 21 Aug 2026 23:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787355518; cv=none; b=dudovyoKlvVpdSNLOKxy2SpYItXDll4+/DDk8v+mCs2R8HsfTAzw1QZ3fzwpJE78vmM/kZEw/Uqbjfv2eNC1qs/v4wIzb5bqvg7LHJcsOXZtMusYHE9i9nTfvwYX3MahiFPOY4Bp/4bs4nXtr3vnYfG5Ki0JoFTVyCdmteaV5KI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787355518; c=relaxed/simple;
	bh=XkeHBmvdwjxZ0XeSpa+fE3u9fgoOmnd/lIL6xTL8ZYU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OoLO3+3U346a9ynxFI5NdnTtDMwesuZSncRc7SpXT3BbqyNzHWgiPgUTi758hyok7ohZfLYjkSLo1jXOP/wGP3zG5uprjV3o3wkUNdJpChQ1XBdKGm988fd21SzeA2A1fbI5DeW26FhvWNxbaIOj/jvr4hchuY3Ds4REpHb+Alo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fzF/pXQm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fzF/pXQm"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id DB9821F000E9;
	Fri, 21 Aug 2026 23:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787355517;
	bh=cxOwtOUeWyOPBkAwue8gFcTdml0rB1SmbwAnFlyPr/s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fzF/pXQmJRt16EM5mykZgyWWTZTyIq+yTDq8lKnlyeW9+OOIhaR/dX1B4gOW2T+lb
	 aIclwu5FO/DC7Kft4Brr5bOuDbPsOaBuIS3SVQnXCGE/dQwaUYgMjyzof2LURJ/b93
	 K9HckMLrVjFnVnc/WNsKYHF4hd9RVNYahhh9UgvPVtKyp1uBbCaoCnF1+cU3iof1U8
	 RO+qaIfA8zq6ALHntm1nB6tzlU3ON8ZtDNNtyACs1R2QPrSKpT7DIjZSz3sNAU1x1g
	 Ixn41e/KSYcLo+bYpR8GSeDY0JSgnWoEin2MQI09zINCoF8+qWQXUuxi/mkkF+AEDs
	 a6e7v5E4A7Cug==
Date: Fri, 21 Aug 2026 16:38:36 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Anuj Gupta <anuj20.g@samsung.com>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 5/5] generic: test corruption detection using T10
 protection information
Message-ID: <20260821233836.GH839663@frogsfrogsfrogs>
References: <20260821051133.1817670-1-hch@lst.de>
 <20260821051133.1817670-6-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260821051133.1817670-6-hch@lst.de>

On Fri, Aug 21, 2026 at 07:11:30AM +0200, Christoph Hellwig wrote:
> Add a test that simulates bit flips in data and misdirected writes and
> checks that file systems detect it when run on devices using protection
> information.
> 
> This requires the new scsi_debug corruption injection.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me (this patch and the previous one), so
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  tests/generic/2302     | 128 +++++++++++++++++++++++++++++++++++++++++
>  tests/generic/2302.out |  21 +++++++
>  2 files changed, 149 insertions(+)
>  create mode 100755 tests/generic/2302
>  create mode 100644 tests/generic/2302.out
> 
> diff --git a/tests/generic/2302 b/tests/generic/2302
> new file mode 100755
> index 000000000000..4a9d9165174b
> --- /dev/null
> +++ b/tests/generic/2302
> @@ -0,0 +1,128 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2026 Christoph Hellwig
> +#
> +# FS QA Test No. 2302
> +#
> +# Test that T10 DIF detects bitflips and misplaced writes.
> +#
> +. ./common/preamble
> +_begin_fstest auto rw pi
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
> +_require_debugfs
> +_require_scsi_debug
> +# If TEST_DEV is block device, make sure current fs is a localfs which can be
> +# written on scsi_debug device
> +_require_test
> +_require_block_device $TEST_DEV
> +_require_xfs_io_command fiemap
> +_require_odirect
> +
> +# FIEMAP on Btrfs returns logical addresses within the filesystem's address
> +# space, not physical device offsets. Writing to these offsets on $SCRATCH_DEV
> +# would corrupt the filesystem in multi-device setups.
> +_exclude_fs btrfs
> +
> +size=$(_small_fs_size_mb 256)
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
> +		-c "pwrite -S 0x66 0 $((128 * blksz))" \
> +		-c fsync \
> +		$testfile >> $seqres.full 2>&1
> +
> +	local phys_blk=$(_get_file_extent_sector $testfile 0)
> +	if [ -z "$phys_blk" ]; then
> +		_fail "$test_name: failed to get physical block offset via fiemap"
> +	fi
> +
> +	local dev=$(_short_dev $SCSI_DEBUG_DEV)
> +	local debugfs_dir=$(ls /sys/block/$dev/device/scsi_device/)
> +	local debugfs_file="/sys/kernel/debug/scsi_debug/$debugfs_dir/corrupt"
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
> +_exit 0
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
> 
