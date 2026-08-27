Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48D1D381B0D;
	Thu, 27 Aug 2026 18:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787856143; cv=none; b=uzYEORYyE0n61oBSSpsDOK9T2Z7SAWfpHVf0JZFf9g00OuBtSbXbSOpRUrbKDP160WPouewMuAj1Db3IZNilWVRcL+WteLr/YCSNq/u1KMqN6YdWy6srBLVfpiOOBsV0dHgnYHbfQzImmjgXYPCLzOCtD+Gnj/tJma/SCLunjc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787856143; c=relaxed/simple;
	bh=BQxeBCzlpdIBx1IQubyGP4cIIBLKUfAEpmsojcE+y0o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WwsbLJhSSRzo88WJWhuniaWbY4xu29Ut8jBgjORiPVs2rGKhGTArm3SMAcR3ZKJ/tK+Iy3HeRrKn71WcDNZ+Ec7PiLq9vbpwniYoJ2hImfrFFvdtMRglRJ4Vaj/RItdkbmRFbpDttQ+74yVutyzvYQ9fmBY3MBKw/yQn1eRfc2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JGyGZ1iF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JGyGZ1iF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5E891F000E9;
	Thu, 27 Aug 2026 18:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787856141;
	bh=KHhkLS/1kvPLnma3IR3pFI9fv8AtiL1iUd3rkfzN1lg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JGyGZ1iFBz3zCcmK5s+YpaPPkJwF8HLlFKvCFOqnrCOgPcUbrmKgH4FEBYa/xbr7a
	 h/1ZV4SVVbM08ujfZXsGjzeLQi4WVe7WUlIBnKyfNROLYwwBE28tqTXgbthsIqCcr9
	 ZTWE0eGpePQDRxQ4T0lnMZV/0ukCtizTYpLByJER98aCyL6tH9cbxgroRedeTOZdvL
	 L4OLoDn9U3H0qcxLGzwu9kX45We7ZNJbUcASVdMW9I5BuakpxhZ1Nj+jjlWmKwxDYc
	 IT4Z/cvAibf/UWNXsYhG8Xs0ZCsGG25RgCt0UAQWvVjYpyNU/7Ig3ny/dkKNLseFfP
	 aDTjGRsQ/HeTg==
Date: Thu, 27 Aug 2026 18:42:19 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
Cc: axboe@kernel.dk, mst@redhat.com, jasowangio@gmail.com,
	James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
	robh@kernel.org, krzk+dt@kernel.org, conor+dt@kernel.org,
	linux-block@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-scsi@vger.kernel.org, virtualization@lists.linux.dev,
	devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
	neeraj.soni@oss.qualcomm.com, gaurav.kashyap@oss.qualcomm.com,
	mani@kernel.org, andersson@kernel.org, konradybcio@kernel.org,
	bvanassche@acm.org, alim.akhtar@samsung.com,
	avri.altman@sandisk.com, stefanha@redhat.com, pbonzini@redhat.com,
	eperezma@redhat.com, xuanzhuo@linux.alibaba.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 00/11] FBE virtualization: inline encryption for
 virtio-blk guests
Message-ID: <20260827184219.GB2137493@google.com>
References: <20260827160806.1295313-1-linlin.zhang@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260827160806.1295313-1-linlin.zhang@oss.qualcomm.com>

On Thu, Aug 27, 2026 at 09:07:09AM -0700, Linlin Zhang wrote:
> From: linlzhan <linlin.zhang@oss.qualcomm.com>
> 
> Current virtio-blk does not provide a mechanism for a guest to
> program hardware keys or submit encrypted I/O using pre-programmed
> keyslots.  It drops the crypto context when issuing a bio request
> to the virtio-blk queue, preventing inline-encryption-based FBE
> on virtio block devices.
> 
> This series enables File-Based Encryption in guest VMs on Qualcomm
> GVM platforms where the ICE inline encryption hardware is shared
> between the host and guests.  In this environment the guest kernel
> has no access to the ICE hardware directly; it supplies a virtual
> keyslot index and data unit number with each encrypted I/O request
> via VIRTIO_BLK_F_INLINE_ENCRYPTION, and the host must translate the
> virtual slot to a physical ICE keyslot and submit the bio — without
> transferring raw key material across the VM boundary.

This seems to be designed incorrectly by not making virtio-blk itself
support key programming and eviction.  That complicates things
significantly by then having to handle the key programming and eviction
out-of-band using Qualcomm-specific SCM calls.  It also means that
adding other implementations of this would be very difficult.

There are some claims that not transmitting keys across the VM boundary
is desirable.  But that doesn't seem meaningful, given that all the I/O
is transmitted across that boundary in plaintext anyway, and also it
seems that hardware-wrapped keys will be supported too.

Please make virtio-blk support the key programming, eviction, and
HW-wrapped key management operations that are needed for this to work.

- Eric
