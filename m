Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC5CF35C6AB
	for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2026 07:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789718040; cv=none; b=E3Z9nL1SQCjSsWqZpW565EUF+KHbVgLB8y/tEK2jkJT59NGDwTTmjjLT8gN7UyWq5HIip8s7rcGlpyyUEfJMDUGr/5V9IdcuQmwMMb2x43BNoAxf1h+a1dadBHNiIGpFcffuJBlFl4uImAbKg8Y20/aeVk+SJfwg/swW62zlqRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789718040; c=relaxed/simple;
	bh=CukGI7Z142bE9oSMI1AXO2LT29LFamwqImzlRMr6B+Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TsO/m38JGzcMUjOJH3MU5nyLU2jl53ZiuSs+/AW7ekuvpPZIVWXZ6fLqC6WZckij+eaJihpqk7Ex8oDMfLD8VcSXBcYodET3Eb84G5NA9jIbc83l3OtvPcQzORm3LGOV0wWExi3AWmsfIcQfr/vJgtTOc2Xtha6f0PvxXsi6LS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hfC8FA1J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hfC8FA1J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33DCA1F000FF;
	Fri, 18 Sep 2026 07:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789718039;
	bh=+PAKrBtzNIqDV5o1cvYmZ6sLpMggfxhxL6jzAjUyr4o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hfC8FA1Jm/1e4lF42ZzLco2P95jGBULCxvJ6Z9Pqf7HgBxTQr1Vgn0/ZOxArgPo7V
	 ZbtSsTgCMkbSJjkt/Q+6eB5STYYoQwbk9rLKTNo27UTy+bF3sTWaFC2RQbaSLAdas2
	 tPsuSDEBDfYgybpa1XbLxbngbiEWcWP5C8vzFG4i8R3xqeIuwexgR29NW9dBLQyuDn
	 va8SwswtjOCMEA0EBr+WCBcYwjdESG3/9quWS1hIx6ImUmOgyvyGNIAL+tl02zV69b
	 fBd6LoCEuM0cKwoHrxapekeK5IHjSCEnC6yQzQTqT/9VwpA7KJwM+SjVsOWMz+n13o
	 /IcrF0EFavn1A==
Date: Fri, 18 Sep 2026 09:53:55 +0200
From: Niklas Cassel <cassel@kernel.org>
To: John Garry <john.garry@linux.dev>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>
Subject: Re: [PATCH v4 10/10] scsi: scsi_debug: Validate the access
 parameters of WRITE ATOMIC (16)
Message-ID: <aqzuE6cV8TpVxJ5L@ryzen>
References: <20260918062910.1709791-12-cassel@kernel.org>
 <20260918062910.1709791-22-cassel@kernel.org>
 <d9971f1c-6e8c-4e6b-889e-bb8d6449b451@linux.dev>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d9971f1c-6e8c-4e6b-889e-bb8d6449b451@linux.dev>

On Fri, Sep 18, 2026 at 08:33:07AM +0100, John Garry wrote:
> On 9/18/26 07:29, Niklas Cassel wrote:
> > resp_atomic_write() validates the fields that are specific to an atomic
> > write, the alignment and granularity of the transfer, the atomic
> > boundary and the maximum transfer length, but it never validates the
> > range that the command addresses. Every other command that writes user
> > data calls check_device_access_params() first, which rejects a transfer
> > that ends beyond the capacity of the device, one whose length exceeds
> > the size of the store, and any write to a write protected device.
> > 
> > As a consequence a WRITE ATOMIC (16) past the end of the device is not
> > terminated with LOGICAL BLOCK ADDRESS OUT OF RANGE. do_device_access()
> > reduces the LBA modulo the size of the store, so the command writes
> > somewhere else on the medium instead. A WRITE ATOMIC (16) also writes to
> > a device whose wp module parameter is set, which every other write
> > refuses with DATA PROTECT.
> > 
> > Call check_device_access_params(). The zone checks that it ends with are
> > unreachable, as atomic writes and ZBC emulation are mutually exclusive.
> 
> These are quite verbose commit messages ... LLM-generated, by chance?

Yes, hence the Assisted-by tag just a few lines further down:

> 
> > 
> > Assisted-by: LLM
> > Fixes: 84f3a3c01d70 ("scsi: scsi_debug: Atomic write support")
> > Signed-off-by: Niklas Cassel <cassel@kernel.org>

The commit message does point out two actual problems resulting from the
missing check_device_access_params() call in resp_atomic_write() (which
exists in all other resp_write_*() functions):

- Fails to repect the write protect module parameter, so resp_atomic_write()
  fails to generate the proper sense data in this case.

- Fails to check if the command will write past that device capacity, so
  resp_atomic_write() fails to generate the proper sense data in this case.

The generated sense data differs in the two cases.

I suppose we could drop:

  As a consequence a WRITE ATOMIC (16) past the end of the device is not
  terminated with LOGICAL BLOCK ADDRESS OUT OF RANGE. do_device_access()
  reduces the LBA modulo the size of the store, so the command writes
  somewhere else on the medium instead. A WRITE ATOMIC (16) also writes to
  a device whose wp module parameter is set, which every other write
  refuses with DATA PROTECT.


From the commit message, as I suppose it might be a bit overly verbose to
mention the exact sense data that each missing check would generate.
If someone cares about that, they can just look at the mk_sense_buffer()
calls in check_device_access_params().


Kind regards,
Niklas
