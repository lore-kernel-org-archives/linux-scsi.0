Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B28D547255C;
	Mon, 12 Oct 2026 09:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791795750; cv=none; b=SRev32PkxfTmhS9/ty5JQZM0eeDSQMd9BMVgngRDp4+uzVSpoVi7a2AtWlhpxqqAhdrvr1PkppEXAx3wnSQNM7khxzXAh3OJ7biATjE9ivYFy81efwvbLTe9iuFGtv7TweT0Ztiae5TZyjt7itzR6VFXj0KF8+GeUA4w7HU2Ynk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791795750; c=relaxed/simple;
	bh=mWZIb10zAutJgEh0KniHXgXTt9YBDI5B6c6T9qD0zNE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Yi+3Tz2Ae31CG22geq2F7P/lJj7NgFCBrbuTTv+95T+epY7R9js8770yWvyy6qZskVMc2+7ClfgLSMUZD9Xh545YS4PYucdeoK1kozGmjL0V6fivX9cEV/eyO+z/8D6K9N4vr4ptFEYp54GbfxwRcR4NfmT0Ga1ULv5FqYc9U00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U5miw4Ea; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U5miw4Ea"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD78A1F0089B;
	Mon, 12 Oct 2026 09:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791795749;
	bh=8izoBkxfL8AzbJ0HgJiFbCWv1KbAHjrnKTMsVeRQnQc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=U5miw4EaGR+P9/Sehis5+dhDXP8v3urixmJkStU7kL8VqF8z1+CK+ifbhOeODo0o2
	 2xa26h0xp9+wEWd9xEqY9SOjNnHLjkQVyv4kdS+e9KUB/2gCU8ePq5+UpN+QV3+ZGO
	 +2AZQXhJ7QqBC8HwBEyDjA6SkKvlXkX3YUzmLkY6t9EG+mRNcvEOgWGQMsHM3sJNZr
	 7uXUykeIu0CVvQrub291xLDTbjnTDWmoeG0LmxHJntCw8k84druvVzjkwGIOGNLvoa
	 aE+lXeplG6wdfDvf3qj78zeH/l4fl4WSv8nRwl5c2k0OhTdL/CJH1vwzzeJ7tbP+rp
	 0oNzko0Py39Zw==
Date: Mon, 12 Oct 2026 11:02:25 +0200
From: Niklas Cassel <cassel@kernel.org>
To: Phil Pemberton <philpem@philpem.me.uk>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org, Damien Le Moal <dlemoal@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v8 0/6] libata-scsi: multi-LUN ATAPI device support
Message-ID: <asyiIaJxUAtMkrqZ@ryzen>
References: <20260731213503.2379771-1-philpem@philpem.me.uk>
 <apVF22SjDzqkzEkm@ryzen>
 <0a7bba64-c0fb-43c7-bcaa-d806f2377afd@philpem.me.uk>
 <askAE1FcZJ3jFiWl@ryzen>
 <2fdc4bfd-0ab4-49fb-a046-4b9351654a5e@philpem.me.uk>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2fdc4bfd-0ab4-49fb-a046-4b9351654a5e@philpem.me.uk>

On Fri, Oct 09, 2026 at 05:26:48PM +0100, Phil Pemberton wrote:
> On 09/10/2026 15:54, Niklas Cassel wrote:
> > Simply sending a new series is fine, like you already did.
> > 
> > It will unfortunately most likely miss 7.4, since we will need acks
> > from the SCSI maintainers on the SCSI parts, and I saw that you got
> > some additional (non-preexisting issue) from Sashiko.
> > 
> > But my recommendation is still to respin sooner rather than later,
> > such that we can get it merged any not miss (another) release cycle.
> > 
> > 
> > Kind regards,
> > Niklas
> 
> I'm not in a rush to get it in, given how much it touches I'd rather it be
> right than rushed. I have a netboot Debian with a custom kernel if I need to
> recover any more PD disks.

That is 100% the right mentality :)


> 
> I'm about to send V10, which fixes the issues Sashiko raised.

7.3 will most likely be released on Sunday, and then Damien takes over.
Damien and I take turns to maintain libata, so after that you will need
to ping him for reviews :)

Which is good, since if I remember correctly, he already reviewed some
of your ealier revisions of this series.


Kind regards,
Niklas
