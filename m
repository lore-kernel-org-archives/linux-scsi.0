Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B97A4A4848
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 13:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789650214; cv=none; b=WXJh7a2zwwLYbKTFgm1Khe6UWf606SYlj3hpNM7tmOVO1j5CjX9OO0ptaqx3dSJwz/RTc+olf31uEJEftyV9p8bsrCqQdVDHIueJVn3vpwtL95nosK0AZZUu86AZ0FqANMhCldVefd3PIX9MICibuBrF6CarxW+c+9fZDlYkRNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789650214; c=relaxed/simple;
	bh=0yjOWK3afiHrSu0i7PLZeNPp+9ahJVhyhvSeT/fpSNc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p0lbuW8JFP5f1GRwNnMe/YkmCgm3yxzuDvtG2mN1vAsbP2SrR85TfTl6VOOF3cuHTMyoUtrMfldB0xhhId8fIGmvzKnls5SE3npz3hh/Fz/DSDzdg4J42bk3zALkY3oHlrXBm+8mSDEggfKnr/X5Msz2FTX1eSuU8i6hb/PFkSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f67XNc/I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f67XNc/I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 728FE1F000FF;
	Thu, 17 Sep 2026 13:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789650203;
	bh=0m3bhuy6+3CGnuSN5P2iA5sGLspLRD4oiE7bMiBS1Lw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=f67XNc/I4gOH7A8xxzxUmymrdcWDv3c2uoye3oP3DODslqRXLDZb4PAwpCnl6I+18
	 oJMDwHPYBbk9IAxrpHZJV70EpLAvsOuExaGStrWw7T0gtdoMc9n0AF0HF8ByVRiFCD
	 /gtkO4ZegtXYwn/HRPdB47iVhU/qh9JGdMyRi/flpTwUqBobJYyHAqMbNx3WNmX94P
	 E/ehTkju/VAlQN2fTm45D2lQMCTP6qvBtLPrkufCYR4etFBcBZ9EguTcVNSeqDMgYx
	 vLFZh4PDgBbHAVKWX4uMoGGFNWpby1uI3C1AUnkrAcBqx0JwtgPO4Je5Jv9jPhjBr2
	 F8YLPLKPp/48w==
Message-ID: <2f577b79-8c5b-4d61-9adc-22b607231b97@kernel.org>
Date: Thu, 17 Sep 2026 20:03:20 +0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/4] scsi: scsi_debug: Validate zone access for WRITE
 ATOMIC (16)
To: Niklas Cassel <cassel@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org, John Garry <john.garry@linux.dev>
References: <20260917110316.1104863-6-cassel@kernel.org>
 <20260917110316.1104863-10-cassel@kernel.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20260917110316.1104863-10-cassel@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/09/17 18:03, Niklas Cassel wrote:
> WRITE ATOMIC (16) is a write command, so on a zoned device it is subject
> to the access requirements of the zone that it addresses, and it advances
> the write pointer of a sequential write required zone. See ZBC-3 r06
> (T10/BSR INCITS 579), 4.5.3.3.2 Write access pattern requirements for
> sequential write required zones.
> 
> resp_atomic_write() calls do_device_access() directly, without calling
> check_device_access_params() first and without advancing the write
> pointer afterwards. It is the only command that writes user data which
> does not; WRITE, WRITE SCATTERED and WRITE SAME all go through
> check_device_access_params(), which validates zone access for a zoned
> device.
> 
> As a consequence, with zbc=managed atomic_wr=1, a WRITE ATOMIC (16) can
> write anywhere within a sequential write required zone regardless of its
> write pointer and zone condition, into a gap zone, or across a zone
> boundary, and none of it is reflected in the zone state. The write
> pointer is left where it was, so a subsequent REPORT ZONES does not
> describe the data on the medium, and the next write at that write
> pointer overwrites data that was written without error.
> 
> Validate the access and advance the write pointer the way
> resp_write_dt0() does, holding the zone metadata write lock across both,
> since the write pointer has to be read and updated atomically with
> respect to other commands, and advancing it only when all of the data
> was written.
> 
> Assisted-by: LLM
> Fixes: 84f3a3c01d70 ("scsi: scsi_debug: Atomic write support")
> Signed-off-by: Niklas Cassel <cassel@kernel.org>
> ---
> Tested with:
> 
>   modprobe scsi_debug zbc=managed sector_size=512 physblk_exp=3 \
>       zone_size_mb=8 dev_size_mb=128 zone_nr_conv=2 atomic_wr=1
> 
> issuing WRITE ATOMIC (16) with sg_raw. Before this patch, an eight block
> atomic write at the write pointer of an empty sequential write required
> zone completes with GOOD status and leaves the write pointer unchanged,
> and one issued past the write pointer is accepted as well. After it, the
> former advances the write pointer by eight blocks and the latter is
> terminated with ILLEGAL REQUEST / UNALIGNED WRITE COMMAND.
> 
> A two block atomic write at the write pointer, which satisfies
> atomic_wr_gran and atomic_wr_align but is smaller than the 4096 byte
> physical block, is now rejected by the physical block alignment check
> added earlier in this series. An atomic write to a conventional zone is
> unaffected.
> 
> A WRITE ATOMIC (16) of eight blocks with a data-out buffer of one leaves
> the write pointer where it was, as an atomic write that does not
> complete has no effect.

Given that there are no SMR drives that support atomic writes that I know of, I
think we should not allow this at all, to mimic what user can actually encouter
instead of emulating the "perfect SMR drives that supports everything".
So rather the write pointer fix, I think we should have atomic write support and
ZBC emulation be mutually exclusive.

We can change that later if SMR drives supporting atomic writes ever become a thing.

-- 
Damien Le Moal
Western Digital Research
