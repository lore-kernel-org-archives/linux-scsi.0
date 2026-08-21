Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6199B30F533;
	Fri, 21 Aug 2026 23:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787354865; cv=none; b=H9Uno/E0IubaO6k2CO0wL/k4oTESRhUqH5GZHAViO/7hkhKPNaJvNAxi6UfO27DnZJvhI/kTtdUt/VSaiCyM6VF+syHXbCje7H2hx5Oq9EplQ4hLKlmverBMA2WvE+dMs2cXDqaWYI0cdEQbfpVEjESshMWBC9MSIIRtN53hmYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787354865; c=relaxed/simple;
	bh=JHgnv4kMmCTOIZ6jij0MVt8TYeJ3idTL+yZwMhFEnl4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PnoRE/cpiNlxscMfgCrAK0w4avZDYpht3sAQ+TMjPtp0vV/3twt/9Xc1cL4CEun6rcnfmIRpqJYrMDRoUWQjGIe3ZhZW4rNM4ZrZDudUA2vIHcIUWsuFTqpEcQ90fFhLB6qAWLL9qvUTSb+DIDIi0cF0tMz/jfn3+rskCLnhiFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d4RuQ2Ni; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d4RuQ2Ni"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 24D2A1F000E9;
	Fri, 21 Aug 2026 23:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787354864;
	bh=fEy5SZpIQpL1zxNj0z/t+6CU//F0Q/5IbpqqjxZru18=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=d4RuQ2Ni4P2R/Ev9xfEfeioOImJR2Sf2GeIceIdWDKGDvNJFDujww5RozD3JngwMV
	 sy7S542Rhzih9DwTx5MGfi5qzISWbXN5JFEyu2byaoEh0JLByRY9CQMJUBja136CGB
	 FT/RKHIh5mIJihlC4DWKWV0MBjQF2vcQxRclMT2yVmihvi1E3BXKOKlW09Oq9KM69w
	 muunD6R1/zgUtO4bBo8LBrZZiG8UZZ80VaGKIMHiBt6N/sKzq0FOSyhYrDczc0C4an
	 QI2Gpa4/aU4QUkQqztdxGXFiA6el3P2EyATl/dcNUJeT4aoQa3FWCI14BSGZIFTCcu
	 /Yeo70X9KGxSw==
Date: Fri, 21 Aug 2026 16:27:43 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: John Garry <john.g.garry@oracle.com>, Christoph Hellwig <hch@lst.de>,
	Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Anuj Gupta <anuj20.g@samsung.com>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/5] common/scsi_debug: don't slow down I/O
Message-ID: <20260821232743.GD839663@frogsfrogsfrogs>
References: <20260821051133.1817670-1-hch@lst.de>
 <20260821051133.1817670-2-hch@lst.de>
 <d3289f5b-7b4c-44ce-99ba-c7ff0f59404d@oracle.com>
 <23760489-a45c-4b00-8500-9e8f4c9189df@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23760489-a45c-4b00-8500-9e8f4c9189df@acm.org>

On Fri, Aug 21, 2026 at 09:14:29AM -0700, Bart Van Assche wrote:
> On 8/21/26 12:41 AM, John Garry wrote:
> > On 21/08/2026 06:11, Christoph Hellwig wrote:
> > > scsi_debug by defaults delays I/O
> > 
> > Maybe we can just make delay=0 default for that driver. Or use ndelay > 0.
> 
> I'm in favor of changing the default delay to zero. It's what most users
> need and it's easy to forget to specify delay=0 when loading scsi_debug.

I didn't even *know* that you had to do that!

I agree with these changes.
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> Thanks,
> 
> Bart.
> 
