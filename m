Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFF6337E5C5
	for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2026 05:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789709834; cv=none; b=a1rGkQYvtNmAzT6AZe3QIw653CE7CIdlV0VPVRVu2/GTgT4wRSDhs03iFnw1uSGC/3t02A/yetGug3y7+O6hyiPEHOC5tkdE3ieoudW9kp+nowl5fjQVGmw5Mv0JpxllKrO8mGyt2CZOg7SYc6ic/U30Ug+y7bVyePu5344ZgvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789709834; c=relaxed/simple;
	bh=Cb1bAmiayZ7JXuByC8jdNnkLt6cjOFw4mPB0mbaXbMI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fAbhboZaNBoexdbOZ3nZLHfLRJrODJ9JvaieZWn9zbaXWN5AhPTdbS8Mq04dhLyUnivS2Jcuq8vvmw13qWFxzJZ/eFMC0MIYCxQDLYwXj6/W/dEuAVefL4mIEkCZ2AQUYiBbyWLi3WSC3GxLaSmX6bj9sNPnudU3bhAEdZBqBrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hQP2QYdv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hQP2QYdv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4E181F000FF;
	Fri, 18 Sep 2026 05:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789709833;
	bh=nXyIiO4+pgTF4q1Pjy//cij9U7oApQnM0qfkJBWW69g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hQP2QYdv44u41zDEWP+MJr8k3412H6ccLD+cIhYT7ZqqPElsoNm9D7G+gBuWx4oyA
	 V/pteCN2nFjI3CAPAqsbTSsdULrtg9vnOdganDFsGbZ89zoeKT96LE//GurIhFzVTK
	 pHvpalRKmBo1DNi96zrKs/zWGieMC0BwqxWIoiFXBnMHls0YsHARv8JCaTzjWk7rAp
	 c5IE4KRJWuG6VQKSWHGqemIc1fhrst1dTnIrN4YJRllqpHYndkBSHx9laKFxSXjxEW
	 lJJzmjP4TJUflVqlmAAb0VnD/bs7bLNnGvK8NnTuDuyiNtwXUbhtPJlX3vAZzSquUW
	 kJVwVJ1SKr+cg==
Date: Fri, 18 Sep 2026 07:37:09 +0200
From: Niklas Cassel <cassel@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: John Garry <john.garry@linux.dev>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/2] scsi: scsi_debug: Validate zone access for WRITE
 ATOMIC (16)
Message-ID: <aqzOBedKG6JPbn3C@ryzen>
References: <20260917084553.559765-4-cassel@kernel.org>
 <20260917084553.559765-6-cassel@kernel.org>
 <f1c5db8b-2c99-4c5f-bb1a-3da8f2c5413b@linux.dev>
 <aqu5Q_6EvfY7iRmk@ryzen>
 <0acc0a4d-b532-4f69-8fcc-1d4eef7549c0@linux.dev>
 <aqvCeq9IsbjSJIEx@ryzen>
 <35ad0b9c-06bb-4ccd-8e58-fde4d859b85e@linux.dev>
 <3709D24B-4D27-44CC-92C5-59DC66309931@kernel.org>
 <aqwlS-_pWMWL238o@ryzen>
 <d4640976-7cfe-4d29-8a3f-cfb91b474110@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d4640976-7cfe-4d29-8a3f-cfb91b474110@kernel.org>

On Fri, Sep 18, 2026 at 09:27:10AM +0700, Damien Le Moal wrote:
> > The above is true for sequential write required zones.
> > For SWR zones: The write pointer will always be aligned to the physical block
> > size. (Regardless if physical block size > logical block size, or PBS == LBS).
> > 
> > For conventional zones, when physical block size > logical block size:
> > The write pointer can be aligned to logical block size.
> > Since for conventional zones, the write is implemented using a read modify
> > write.
> > 
> > 
> > Thus for conventional zones, if the WP is aligned to LBS, but not PBS,
> > I think it would make sense that a WRITE ATOMIC would fail with:
> > 
> > ""
> > If the starting LBA of an atomic write command does not meet the requirements
> > of the ATOMIC ALIGNMENT field (see 6.6.4), then the device server shall
> > terminate the command with CHECK CONDITION status with the sense key set to
> > ILLEGAL REQUEST and the additional sense code set to INVALID FIELD IN CDB.
> > ""
> > 
> > Considering that a write < physical block size is implemented as a RMW on
> > conventional zones, so the write cannot be done atomically.
> > 
> > Yet, a normal (non-atomic) write, at the same WP, would succeed (because it
> > would do a RMW).
> > 
> > But this is just me stating what I think would be the logical implementation.
> 
> As I commented already, I think we should *not* allow for atomic write on ZBC in
> scsi_debug. The reason is that as discussed here, implementation of the combined
> features is not as simple as it seems, and since there are no SMR drives out
> there supporting atomic writes, I do not want to give users false hopes with
> scsi debug :)
> 
> Let's make atomic writes and ZBC emulation mutually exclusive.

Sure, I will do that, with your Suggested-by tag.


I do want to note that, for the absolutely most common case, HM-SMR where
logical block size == physical block size, I don't see a problem of these
features being combined.

The drive vendor just needs to set the atomic alignment to something that
makes sense (e.g. equal to the physical block size) with regards to ZBC.


Kind regards,
Niklas
