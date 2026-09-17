Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D1F14ED18E
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 17:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666641; cv=none; b=G3W+lrVfLT4pICERXaslj19A+YGtAaXqSLjqm29EdCrW58e8p5YB5hNNqvtoOZFkNfK9wSZvDmvK6b4oUHXTczbzaFu+VPhbD4rbSBuAJ6PkpQrxziBn5ZgUHab2ttLrdaaYIQd7hrkF1yAPGnLxTK/mBPj8z4DIgYwHdmo2IV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666641; c=relaxed/simple;
	bh=PB8z1rzdEEhga9HeXuvLY17s1aFitGcUBw5RaBEespk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gQk/sLsXM6rfJpW17FvmCBMm6I3OmWE96VeqDMvZCIphL/IPDF37SKXD386ENqcgI4lC55snRM8oiErNJPBt/8Yl2RlnVaZmt8vfYgaeG+cKPmg2+mw8Lb/xIDn8LZJ9yfu/9tlEPcL5CKrkSydtMeyoniQD/Ezp4C05WeWCE7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fhE/UoAs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fhE/UoAs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B0C01F000FF;
	Thu, 17 Sep 2026 17:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789666639;
	bh=DIQqxb3cFnMhn0m7FSmIJNldl/CRLw3GixdV5PwkEk4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fhE/UoAsHsN5/z90mcchwgnHxPRTNgwJE4rLUvWeFgXVFLlKUBGYxE5RgBfaLDEqN
	 2I3baxnxCbZexl5zThTOV2wTcir8BPzgI2KL1HYP0G59ym+uz2uv6kqs79SfzckEC7
	 v4ChAfx7a+3oH2g/wJDYXTQIKme19oC7e48QOvRsrDzOsp8mTvIlqaeKfU8k2Ga4Gs
	 L84dKJO4Sn5KZ0vwvpUSusYYf7uFkwPytX35Z0TaFRFizNQVUIR0gVx8c9Zgfca4Pm
	 cdwb/bUhmlMik0uvTIw83gARIdXkAoawJDSQvIgPkScBd6sqJMJlNuZbvmHyFcEks9
	 W+ud08U3elvZA==
Date: Thu, 17 Sep 2026 19:37:15 +0200
From: Niklas Cassel <cassel@kernel.org>
To: John Garry <john.garry@linux.dev>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/2] scsi: scsi_debug: Validate zone access for WRITE
 ATOMIC (16)
Message-ID: <aqwlS-_pWMWL238o@ryzen>
References: <20260917084553.559765-4-cassel@kernel.org>
 <20260917084553.559765-6-cassel@kernel.org>
 <f1c5db8b-2c99-4c5f-bb1a-3da8f2c5413b@linux.dev>
 <aqu5Q_6EvfY7iRmk@ryzen>
 <0acc0a4d-b532-4f69-8fcc-1d4eef7549c0@linux.dev>
 <aqvCeq9IsbjSJIEx@ryzen>
 <35ad0b9c-06bb-4ccd-8e58-fde4d859b85e@linux.dev>
 <3709D24B-4D27-44CC-92C5-59DC66309931@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3709D24B-4D27-44CC-92C5-59DC66309931@kernel.org>

On Thu, Sep 17, 2026 at 06:10:11PM +0200, Niklas Cassel wrote:
> Hello John,
> 
> On 17 September 2026 17:42:28 CEST, John Garry <john.garry@linux.dev> wrote:
> >On 9/17/26 11:35, Niklas Cassel wrote:
> >> On Thu, Sep 17, 2026 at 11:26:45AM +0100, John Garry wrote:
> >>> On 9/17/26 10:56, Niklas Cassel wrote:
> >>>> On Thu, Sep 17, 2026 at 10:38:30AM +0100, John Garry wrote:
> >>>>> On 9/17/26 09:45, Niklas Cassel wrote:
> >>>>> 
> >>>>> So far we have not considered atomic writes for zoned devices
> >>>>> - do devices which support both technologies exist? Or is
> >>>>> this just hypothetical?
> >>>> If the specs allow it, someone might build it.
> >>> 
> >>> Sure, but do they (allow it)? atomic writes have specific
> >>> alignment and granularity rules - how does that play with
> >>> zoned devices?
> >>> 
> >>> I would need to check the specs more on this..
> >> 
> >> I haven't been able to find anything that disallows it.
> >> 
> >> Trying to parse the specs with the help of LLM:
> >> 
> >> ""
> >> WRITE ATOMIC (16) is a write command as far as ZBC is concerned, so on a
> >> zoned device it is subject to the access requirements of the zone that it
> >> addresses, and it advances the write pointer of a sequential write
> >> required zone.
> >> Neither standard says so directly, but the definitions leave no room for
> >> anything else. SBC-6 r02 defines an atomic write operation as a "process
> >> by which a device server performs a write operation that is either
> >> completed in its entirety or has no effects on stored logical block
> >> data" (3.1.9), and an atomic write command as a "command that performs
> >> one or more atomic write operations" (3.1.8). ZBC-3 r06 in turn defines
> >> a write operation as a "write operation as described in SBC-5 with the
> >> additional requirements described in this standard" (3.1.62), and a
> >> write command as a "command that requests write operations" (3.1.61).
> >> WRITE ATOMIC (16) therefore falls under 4.5.3.3.2 Write access pattern
> >> requirements for sequential write required zones, exactly as WRITE (16)
> >> does.
> >> ""
> >> 
> >> Right now, I don't see why WRITE ATOMIC should not be allowed on a ZBC
> >> drive.
> >> 
> >> 
> >So what happens when the write pointer is not aligned with Atomic alignment? Are atomic writes just not permitted in that scenario?
> 
> 
> You are the expert when it comes to atomic writes.
> 
> But I would imagine that a device that implements both WRITE ATOMIC and ZBC
> would set the atomic alignment to the physical block size.
> 
> That way the write pointer in sequential write required zones would always be aligned to both.

The above is true for sequential write required zones.
For SWR zones: The write pointer will always be aligned to the physical block
size. (Regardless if physical block size > logical block size, or PBS == LBS).

For conventional zones, when physical block size > logical block size:
The write pointer can be aligned to logical block size.
Since for conventional zones, the write is implemented using a read modify
write.


Thus for conventional zones, if the WP is aligned to LBS, but not PBS,
I think it would make sense that a WRITE ATOMIC would fail with:

""
If the starting LBA of an atomic write command does not meet the requirements
of the ATOMIC ALIGNMENT field (see 6.6.4), then the device server shall
terminate the command with CHECK CONDITION status with the sense key set to
ILLEGAL REQUEST and the additional sense code set to INVALID FIELD IN CDB.
""

Considering that a write < physical block size is implemented as a RMW on
conventional zones, so the write cannot be done atomically.

Yet, a normal (non-atomic) write, at the same WP, would succeed (because it
would do a RMW).

But this is just me stating what I think would be the logical implementation.


Kind regards,
Niklas
