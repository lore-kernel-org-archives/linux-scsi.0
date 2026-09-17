Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D552B4B403D
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 09:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789638995; cv=none; b=S7G72y4lha6/2/5Qbilk6wzBkicO/NyuOKgDP2fmvrwmCM5PZSENgnbC1cjCJMjtyGlyaFD68g/bsyUqWabt7uKD5z+oTbzB4/FyxykMKTYXB0kTI5APx5PeWZDtiCgcw/PJdH99vPPOcIUAZcjMvB7hQunoujldEPIbYQdSYYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789638995; c=relaxed/simple;
	bh=S4oOffRVdb225/ATU2Db7gNZwMsJa69W6jp/CqteWl4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BVA/K0UMSfHJ+F0jtkvt4eLtGYDdK38cHUkAbmNTnbfNibSmOa4drWMffm5NpK2/99UG9Az4n/BB8ezgDs+cqzzvQfj1fq+uhLe/VSZCjV9pA6jiAJcfLBiS28QbtHTTDRvLv/hcmdWKu+yH5hdbxfMhNLJlqdZfS/aIkTw99Sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C5GqWB7k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C5GqWB7k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AF101F0089D;
	Thu, 17 Sep 2026 09:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789638983;
	bh=CH31tdgl84onSz3k5bDeutcTLX5fBol5lDkajzQJcW0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=C5GqWB7k99rnxhB8THsKhXC6CJaQ8MgQNQICHtxJ8zsgKJAKvVdY5H/xWFz7gfxOe
	 pYoO93TjgX6bcvdhr9YAAaqlgVHxjwto0BIjUPS+N3tQt8drLnFXkBcTEjjZFBm72l
	 8Hms1stOS4pJxGYpyXQABpVFpgEd/0ROTB1kC9BJ51I8/O6zBinzgVIotYu+jRxpJv
	 OPOjZrBhReeaY6vcQh3NXc+qvb9WZRBE8uWtOFDdcoXWXHJ/ZIoXQozcZtledm0QB7
	 9A5WICOhiJ0jGvRAhWFBJVlzRw1hP7h0hsp8Iw0RXwpqvddWKlGq9Ds3we7QsJ3/j7
	 cA/vm+ccYmjLQ==
Date: Thu, 17 Sep 2026 11:56:19 +0200
From: Niklas Cassel <cassel@kernel.org>
To: John Garry <john.garry@linux.dev>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/2] scsi: scsi_debug: Validate zone access for WRITE
 ATOMIC (16)
Message-ID: <aqu5Q_6EvfY7iRmk@ryzen>
References: <20260917084553.559765-4-cassel@kernel.org>
 <20260917084553.559765-6-cassel@kernel.org>
 <f1c5db8b-2c99-4c5f-bb1a-3da8f2c5413b@linux.dev>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f1c5db8b-2c99-4c5f-bb1a-3da8f2c5413b@linux.dev>

On Thu, Sep 17, 2026 at 10:38:30AM +0100, John Garry wrote:
> On 9/17/26 09:45, Niklas Cassel wrote:
> 
> So far we have not considered atomic writes for zoned devices
> - do devices which support both technologies exist? Or is
> this just hypothetical?

If the specs allow it, someone might build it.

I don't see why someone would not want to build a device that supports both,
as they are both really nice features :)


Kind regards,
Niklas
