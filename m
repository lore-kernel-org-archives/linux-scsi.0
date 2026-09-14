Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47D6F27AC31;
	Mon, 14 Sep 2026 09:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789376884; cv=none; b=csDl9p5ZQ++dj6gHAD/bldlu+fWnIraWXN9F4hKeb0GbbVpQLDklC2nqoOICwloRuHzLH1aU9Uyk6lNVnS2amDHT7Thp0VqxfByCDiwjw6I6iZfH+g9Kkt6Kf/UdnsIpPHbfP25aypqVgjakr2SdFx7vWiD1XX1OoKsnwkTvrXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789376884; c=relaxed/simple;
	bh=9ESsoQKp0q13c/OmvG+uDPEJKk1CQgKUFXsV9CHCjTU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RSN4GdSpa4i3b3EKKtvAMkRUexpyStL2eQKNISTMIDiHK2O5J6DxeVhVW5AiClU8uV88Ad9DcWmxicYtYannJMBj3VhHauR54eCcdVt0nv+HHlqSQml3SzWtx8FCkZqwXvUXUtyijNH6/hbrQ2tQzAX+H3oIR22ARU8SfWDw658=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y+U9obnw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y+U9obnw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00D371F000FF;
	Mon, 14 Sep 2026 09:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789376882;
	bh=x+uFjbeVw45u+g7xjagc3YWrkEsajDX5pecyn3VEm74=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Y+U9obnwo78hsDpbfIFvDuqufCr22AYMACPWoXa8ni8Nd7QPm4b5jIy9vuiRFb1hW
	 wBvxaNZATm9xmPUf17r524Vt0QRg2leD20n6fdq22aY2JDwo+kURqzN2VmhKvLCJFM
	 HnWnU63Mi6Eavm9Xx2PWMvbszVZ6CSAlwNm8YbZQ6fVJF7TqShw0N4YZFbV+LRS/SU
	 7DTczLS9VXxm0cBuUJjp0Dc+Lm+vOECpxS0njKi/WD0O4Oz1evSjwVlmZbjR4gYQ/J
	 1T/jxS9uKL/34uoa0CGPS56srNQ6ZkFWD92/tj5sUquWxWuxhCMbBETB79HsF2Rvz+
	 SJ2j95J3U0fUA==
Date: Mon, 14 Sep 2026 17:07:55 +0800
From: Zorro Lang <zlang@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: fstests@vger.kernel.org, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Kanchan Joshi <joshi.k@samsung.com>, 
	Anuj Gupta <anuj20.g@samsung.com>, John Garry <john.g.garry@oracle.com>, 
	"Darrick J. Wong" <djwong@kernel.org>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 6/6] generic: test corruption detection using T10
 protection information
Message-ID: <aqe5VTzX2qLDf4KG@zlang-mailbox>
Mail-Followup-To: Christoph Hellwig <hch@lst.de>, fstests@vger.kernel.org, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Kanchan Joshi <joshi.k@samsung.com>, 
	Anuj Gupta <anuj20.g@samsung.com>, John Garry <john.g.garry@oracle.com>, 
	"Darrick J. Wong" <djwong@kernel.org>, linux-scsi@vger.kernel.org
References: <20260911070831.1760646-1-hch@lst.de>
 <20260911070831.1760646-7-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260911070831.1760646-7-hch@lst.de>

On Fri, Sep 11, 2026 at 09:08:24AM +0200, Christoph Hellwig wrote:
> Add a test that simulates bit flips in data and misdirected writes and
> checks that file systems detect it when run on devices using protection
> information.
> 
> This requires the new scsi_debug corruption injection.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> ---

Looks good to me,

Reviewed-by: Zorro Lang <zlang@kernel.org>

>  tests/generic/2302     | 133 +++++++++++++++++++++++++++++++++++++++++
>  tests/generic/2302.out |  21 +++++++
>  2 files changed, 154 insertions(+)
>  create mode 100755 tests/generic/2302
>  create mode 100644 tests/generic/2302.out
> 
> diff --git a/tests/generic/2302 b/tests/generic/2302
> new file mode 100755
> index 000000000000..fd83c64dfff1
> --- /dev/null
> +++ b/tests/generic/2302
> @@ -0,0 +1,133 @@
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
> +	local blksz=$(_get_block_size $SCSI_DEBUG_MNT)
> +	local testfile="$SCSI_DEBUG_MNT/test"
> +
> +	$XFS_IO_PROG -d -f \
> +		-c "pwrite -S 0x66 0 $((128 * blksz))" \
> +		-c fsync \
> +		$testfile >> $seqres.full 2>&1
> +
> +	local phys_sector=$(_get_file_extent_sector $testfile 0)
> +	if [ -z "$phys_sector" ]; then
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
> +		echo "adding to $phys_sector" >> $seqres.full
> +		phys_sector=$((phys_sector + (128 * blksz / 512) - 1))
> +	fi
> +
> +	echo "lba=$phys_sector,num=1,bit_errors=$bit_errors,reftag_adjust=$reftag_adjust" \
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
> +# Note: Type 3 doesn't have a reftag, so don't test it
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
