Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C33D438FF4;
	Fri, 21 Aug 2026 23:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787355471; cv=none; b=iRViLpuQIiU+wWJkCKpr2L0A1Zk+EShHt0tTVQS6B6nzyV0sYPYcDRdEoNigaWW6PHjjg4qc90zpcmpMLkPz2atxLuEDYhO3SjaBQnrIduIA2FUiSeAh38J5cLSeW8pzVjt17t3leT7AGZHEW7grazUSD5IFyy1VRYocvvwEBmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787355471; c=relaxed/simple;
	bh=HVhBs1eXaONv1yMruTi91Yy1tw7arDCDADZCVLueSzw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QtEKgGN6gWDaABk4qroK8QmryEdpBWc14fMv93RBgifGHi83mv+HHtEppuG+8Vxwa15V47qa7oSjYjJ0ZjDsleFJuxkL6T65LdtNTWoyfu0UlACTqEw76MNBo6AsOSY2Xd0x0yNn1jVLw0TCQSsTZcjYyowRAjfSWt9Gn7auT9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XgUzIke0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XgUzIke0"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E500C1F000E9;
	Fri, 21 Aug 2026 23:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787355470;
	bh=coECccNnRDICpRxpX778QfZUJbg/xmiQKTKlx/mG2+Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XgUzIke02IEwE17PC9lggEBSrfH6oQFwgPWqHipHcL61ISLONJR5jsqsSQiajEYpO
	 yQkaK8b343a1v0HX/TLiuy+O6WlB79PXVG77fRhhauZylBGDVgWMdPQwfLTR/P5LV/
	 WAID7HlD5Bu6vRzwpChNaRDoCbpJ4mjuj+SUK+sYXfUqtzmVei6Uo0Km1N+3qspM2F
	 vtwYm+7FRnF5n4bLgXxPdUvGswlD6kkB3AC47+zRFJebNhcTeTfrFshClop3TI9zUo
	 UOrY9giIj3oAFL/UkY3irTBcvU28goFqgnxKIrU6xCLduu37gIGdNztvSadOvk5VUL
	 Pce8BGRvDVuXg==
Date: Fri, 21 Aug 2026 16:37:49 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Anuj Gupta <anuj20.g@samsung.com>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 4/5] generic: test I/O on devices with T10 protection
 information
Message-ID: <20260821233749.GG839663@frogsfrogsfrogs>
References: <20260821051133.1817670-1-hch@lst.de>
 <20260821051133.1817670-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260821051133.1817670-5-hch@lst.de>

On Fri, Aug 21, 2026 at 07:11:29AM +0200, Christoph Hellwig wrote:
> Add a test that runs fsx in buffered and direct I/O mode on T10 PI
> type 1, 2, 3 with and without strip/insert using scsi_debug.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  tests/generic/2301     | 91 ++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/2301.out | 73 +++++++++++++++++++++++++++++++++
>  2 files changed, 164 insertions(+)
>  create mode 100755 tests/generic/2301
>  create mode 100644 tests/generic/2301.out
> 
> diff --git a/tests/generic/2301 b/tests/generic/2301
> new file mode 100755
> index 000000000000..ba6952855f55
> --- /dev/null
> +++ b/tests/generic/2301
> @@ -0,0 +1,91 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2026 Christoph Hellwig
> +#
> +# FS QA Test No. 2301
> +#
> +# Basix FSX sanity check when using T10 protection information
> +#
> +. ./common/preamble
> +_begin_fstest auto rw pi dangerous

Why dangerous?  Can this crash the system?

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
> +_require_scsi_debug
> +# If TEST_DEV is block device, make sure current fs is a localfs which can be
> +# written on scsi_debug device
> +_require_test
> +_require_block_device $TEST_DEV
> +_require_odirect
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
> +	SCSI_DEBUG_MNT="$TEST_DIR/scsi_debug_$seq"
> +	rm -rf $SCSI_DEBUG_MNT
> +	mkdir $SCSI_DEBUG_MNT
> +
> +	_mkfs_dev $SCSI_DEBUG_DEV || \
> +		_fail "Can't make $FSTYP on DIF-enabled scsi_debug device"

I wonder, wouldn't it help to broaden feature testing coverage if we
could inject the scratch device's mkfs/mount options here?  With just a
bare _mkfs_dev you only test the mkfs defaults.  For example, you won't
be testing xfs with metadir and t10 until mkfs.xfs turns that on by
default.

That said, the big problem with that is that there's only one scsi-debug
device and multi-device scratch fs options won't work with that.  I'm
not ride-or-die for this, but I thought it was worth mentioning.

--D

> +	run_check _mount $SCSI_DEBUG_DEV $SCSI_DEBUG_MNT
> +	bsize=$($here/src/min_dio_alignment $SCSI_DEBUG_MNT $SCSI_DEBUG_DEV)
> +
> +	local integrity_path="$(_sysfs_block_integrity_path $SCSI_DEBUG_DEV)"
> +	echo $pi_enable > $integrity_path/read_verify
> +	echo $pi_enable > $integrity_path/write_generate
> +
> +	# fsx load similar to generic/091
> +	echo "Testing direct I/O for DIF type $pi_type (enabled: $pi_enable)"
> +	local dio_opts="-r PSIZE -t BSIZE -w BSIZE"
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
> 
