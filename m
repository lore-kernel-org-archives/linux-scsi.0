Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93B862DB7A9;
	Tue, 27 Jan 2026 09:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769506364; cv=none; b=uHQkpaEiwprRyBgXmLDeOp/5CBDKyHkGpBtukCrXkxWE31pg8eiONImFFMjId1Wc7/PhR3iUAxxUj1rHMwLEDuGDUYwLwZHZojUC1XpYYqsn5DEWAjPP97dRyBHD8KDcGuY8pRGwfMHkidJbOKhHavsm5+XiVxpaG9lVOn2qs4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769506364; c=relaxed/simple;
	bh=eG+yqP+7Rbf/01a+0aRQfQsP84mxP22w8iRV1atNAx8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VIMOjHjWe2p+hyvbda594bg4HC7ZDImG45tksDefYdEdU8AZY7KRhV+fJdZBSpeMT0RDrWeyTB5NiU+TT2A6mu97TtoQchQ1Hzd2hZ7ttL/Ie5Qw+QTjbZgm4x/YgvWIIZ1QZjVdSjDd5oOUMiOB1J+Q+pdU0QkJL99ejbRASNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aSS+VaaW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aSS+VaaW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5E38C116C6;
	Tue, 27 Jan 2026 09:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769506364;
	bh=eG+yqP+7Rbf/01a+0aRQfQsP84mxP22w8iRV1atNAx8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aSS+VaaW0gQiMQJpnFaoFoSeI4RJ3dpo6xD6n59QUWRVypkDc2fw+WTsBAM3Mm8eh
	 I2sqE71fRUXvxcWs5p7CB+hbwWu46UXDj9j/e2M4BQ+E2Abpfl+dvPE29cQFuKEObv
	 rMJbUmeG0MpIQDnmGZq2UrWamIMONUVPyefIENAdToSmh8saSO2lwSpoV1TkP7xVu/
	 duTUdqX/ahduaSksRHPdmmMxwiFJXuq9km0JOBOmFadymoJiw4mq8YJPQwQ2GoQmFZ
	 BmOXmdpoUV36ElNmRdNT8QzsTzmIsO4BWBvdzBRK96WZ0bi/s0MLc7uB2pUr+9nKth
	 t8gbV4zdLvMxQ==
Date: Tue, 27 Jan 2026 10:32:37 +0100
From: Niklas Cassel <cassel@kernel.org>
To: Markus Probst <markus.probst@posteo.de>
Cc: Lee Jones <lee@kernel.org>, Pavel Machek <pavel@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Jacek Anaszewski <jacek.anaszewski@gmail.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Pavel Machek <pavel@ucw.cz>, linux-leds@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
	Ian Pilcher <arequipeno@gmail.com>
Subject: Re: [PATCH RFC 0/4] leds: extend disk trigger
Message-ID: <aXiGNZm12vLhQJ4Q@fedora>
References: <20260123-ledtrig_disk_-v1-0-07004756467b@posteo.de>
 <aXctPaaXFYemV20T@ryzen>
 <ce454969b83dbb0e3bb4ea78f682603cc328ceb9.camel@posteo.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ce454969b83dbb0e3bb4ea78f682603cc328ceb9.camel@posteo.de>

On Mon, Jan 26, 2026 at 10:06:02PM +0000, Markus Probst wrote:
> On Mon, 2026-01-26 at 10:00 +0100, Niklas Cassel wrote:
> > 
> > Why do we want to have this in kernel space?
> Because there are more than enough devices that could make use of it.
> 
> Just search the term "NAS device" and you see rarely any devices for
> which this wouldn't be useful.
> 
> The only reason the leds work on those devices currently, is because
> they get shipped with a custom modified kernel by the manufacturer.
> This shouldn't be a requirement for running Linux properly on a NAS
> device with disk leds.

I understand why you want the feature. I just don't understand why we
should add this feature to the kernel, rather than implement it in
user space.

Having a user space implementation for your feature would also allow
an upstream kernel, without the need for any custom kernel patches.


> > If we want something more complex than what is already there, then it
> > is probably much better handled in user space, considering the amount
> > of possible configuration options.
> A userspace daemon by itself is possible, but I don't think it is the
> best solution. Having an indicator for disk activity on a per-disk
> basis seems like basic led functionality that should be present in the
> kernel.

There seems to be existing user space applications that handles this,
I think both the daemon I linked to before, which uses /sys/block/<dev>/stat
which is thus per device and not per port, and e.g. this:
https://linux.die.net/man/8/ledmon
https://github.com/md-raid-utilities/ledmon
https://github.com/md-raid-utilities/ledmon/blob/main/src/lib/ahci.c


> > Basically the same argument as used in:
> > https://lore.kernel.org/linux-nvme/20220227234258.24619-1-ematsumiya@suse.de/T/#u
> If I understood it corretly, the argument there is that led code
> shouldn't be present in a fast path.
> 
> This does not apply to this scenario.

I think my main concern is that I don't think we should bloat the kernel
for a complex feature that can just as well be implemented in user space.


Kind regards,
Niklas
