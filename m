Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 009C142E400
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 10:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789641350; cv=none; b=pr/QH3MRtEjTwVEnrfN95nGw5DSxe8sIp7YYwrRDkMPM1YRoW0NzLsN6tqR/YVKRVVg3X74s2baT7N3gZAMysW6E/yfM9lfeYEEbofOyYtj+hvr3EtJ93c5CPRVbVCqoux7IkaygOjNosEgVFbccjnWoZ0VHtbvJx68uxGGLYac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789641350; c=relaxed/simple;
	bh=+Vl46CTOMoT3CH9DfXpCA+9O3ahxXdMjkueNwJa3NT4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ItGQB2LHCg0r30Th+4v8RX6Zdcj19w3bj75AV9/0/JoZeuFosR6B+Bl/qZ/WVjnBFCY4P3thAsFxs6+aEt2ZObsHg+reZwEzq4SxMzWwK6LJ6zTkLrK9odh8RQcYwQVRYzIgwvtQLzwGKxMo1rbKM8LXVmifXMS51pLgVAdOcFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eBAtx9YN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eBAtx9YN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36C351F000FF;
	Thu, 17 Sep 2026 10:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789641342;
	bh=7Xe+rjhW8M2kaQLStKB9Wee31/J/Xyz8kAy6OCwc5jE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eBAtx9YNH/cuJs1xDb8t5vGQbYmJtMVMn9qa9qZJ6xpJ3a894P+jRcktZckFEGTDg
	 boMnbd3/QkTyMtvH2r2EEfFumcMhOSL7h+cU9yhLXbxZDG7gW0r3tbOZPeiVi3PWob
	 HRHTUbfECyH6qT3lVLIoVI4IS5OIYvl/d/xgooPSKGqnZsiwyZ9k4azJbxNt8omIC5
	 +vxdbAqMgXghX7kUs8CyhuxKIEE1s6XM2Q9tTjJaYGmZ6UN1fdaDwS+3QzVCROcBDl
	 pckO4D05/kuWukFOmJcKPQ7yF1aa/cmGk1Q69y1j45952Y5dTYKJcn93fD1Hb5Y9iV
	 KR27YPj/n8Oog==
Date: Thu, 17 Sep 2026 12:35:38 +0200
From: Niklas Cassel <cassel@kernel.org>
To: John Garry <john.garry@linux.dev>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/2] scsi: scsi_debug: Validate zone access for WRITE
 ATOMIC (16)
Message-ID: <aqvCeq9IsbjSJIEx@ryzen>
References: <20260917084553.559765-4-cassel@kernel.org>
 <20260917084553.559765-6-cassel@kernel.org>
 <f1c5db8b-2c99-4c5f-bb1a-3da8f2c5413b@linux.dev>
 <aqu5Q_6EvfY7iRmk@ryzen>
 <0acc0a4d-b532-4f69-8fcc-1d4eef7549c0@linux.dev>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0acc0a4d-b532-4f69-8fcc-1d4eef7549c0@linux.dev>

On Thu, Sep 17, 2026 at 11:26:45AM +0100, John Garry wrote:
> On 9/17/26 10:56, Niklas Cassel wrote:
> > On Thu, Sep 17, 2026 at 10:38:30AM +0100, John Garry wrote:
> > > On 9/17/26 09:45, Niklas Cassel wrote:
> > > 
> > > So far we have not considered atomic writes for zoned devices
> > > - do devices which support both technologies exist? Or is
> > > this just hypothetical?
> > If the specs allow it, someone might build it.
> 
> Sure, but do they (allow it)? atomic writes have specific
> alignment and granularity rules - how does that play with
> zoned devices?
> 
> I would need to check the specs more on this..

I haven't been able to find anything that disallows it.

Trying to parse the specs with the help of LLM:

""
WRITE ATOMIC (16) is a write command as far as ZBC is concerned, so on a
zoned device it is subject to the access requirements of the zone that it
addresses, and it advances the write pointer of a sequential write
required zone.
Neither standard says so directly, but the definitions leave no room for
anything else. SBC-6 r02 defines an atomic write operation as a "process
by which a device server performs a write operation that is either
completed in its entirety or has no effects on stored logical block
data" (3.1.9), and an atomic write command as a "command that performs
one or more atomic write operations" (3.1.8). ZBC-3 r06 in turn defines
a write operation as a "write operation as described in SBC-5 with the
additional requirements described in this standard" (3.1.62), and a
write command as a "command that requests write operations" (3.1.61).
WRITE ATOMIC (16) therefore falls under 4.5.3.3.2 Write access pattern
requirements for sequential write required zones, exactly as WRITE (16)
does.
""

Right now, I don't see why WRITE ATOMIC should not be allowed on a ZBC
drive.


Kind regards,
Niklas
