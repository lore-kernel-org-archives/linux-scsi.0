Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C6AF219A8A;
	Mon, 26 Jan 2026 09:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769418052; cv=none; b=LOhlmbn5AsNGNoh9GvUum3wGsIG3OJsw14LD+k/WndX8xuMw16C/iM3901t2TJ4d+XT8TD2bX1TrRNHhmWhTI9yCuD2FMQVHBCiJJ4yx1q+PlQpnQ75tY/eoxDcMTzj+TwQKo4xVfDBKoGxtdwlhJIDmI6IkrBOB1jUE0IcYFfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769418052; c=relaxed/simple;
	bh=cJgrLjLQiB+SsK/eaFop4n4UxXAXE8CPdMBi7R+aO0Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Sc5Wws/ETsgCm5/U1glU16eM8laOflrGwYKsEg6mo8wNn44EOoYn6ZXdJfM2h80PLQ8F3TT2UCUiJ8FsLJyGX6OEOYUyWUCsEydpZs1We+xXEGYw1v0Py65ahTGIT+GYUDvMvcRnS+aFfrMTofakCljJjhTx+nFGlv+83PZDj5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VzzT5JX2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VzzT5JX2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EC70C116C6;
	Mon, 26 Jan 2026 09:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769418052;
	bh=cJgrLjLQiB+SsK/eaFop4n4UxXAXE8CPdMBi7R+aO0Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VzzT5JX2h/qS+jBtGXKzR+Ejuv9n/eOfGRdb80/IK3Rz1elHqKuXh/8iSeQo9/OPO
	 GxhHznKk6Tz9w5Ujwjb4dGeWxKRYzqeWjNXrQ/iUmL1fj1H6W82CDX3WGNGlMTyJeZ
	 l/CA/Nwa7KdhbkxmYt9DL93QBCCzAl1HT9YH0pmIZpZ5/+ZmYcb7c98r5a9Cttg61g
	 0m8d4wistqltzkeqWls3LW0TkKCidcEeynkaApXIHNk3iQM7/CTN2j0a+PEcjNCeJb
	 1J77zclR4IihWoY1BSuB+EKJycEVbLDbCWNJz4fw9TdcBPa03fEovDHGSEBx79hx5E
	 tf7qnLI8Y9exg==
Date: Mon, 26 Jan 2026 10:00:45 +0100
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
	linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH RFC 0/4] leds: extend disk trigger
Message-ID: <aXctPaaXFYemV20T@ryzen>
References: <20260123-ledtrig_disk_-v1-0-07004756467b@posteo.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260123-ledtrig_disk_-v1-0-07004756467b@posteo.de>

Hello Markus,

On Fri, Jan 23, 2026 at 07:05:03PM +0000, Markus Probst wrote:
> Extend the disk trigger
> - to allow configuration of the blinking delays
>   and whether the led should be kept on, on idle.
> - to allow an individual led to be mapped to an ata port
> 
> I would also like to add another patch to this series, only leaving the led
> on with invert 1 if also at least one disk is present on the ata port.
> The led would then not only indicate activity, but also if a disk is
> present.
> That is why it is an RFC.
> 
> @Damien,Niclas: What would be the most straightforward way of telling
> the led trigger if at least one disk is present on the ata port and
> notifing it when this changes?

Why do we want to have this in kernel space?

Sure, there is already the very simple ledtrig-disk driver.

But I'm not a fan of making the driver more complex.
If we want something more complex than what is already there, then it
is probably much better handled in user space, considering the amount
of possible configuration options.

Basically the same argument as used in:
https://lore.kernel.org/linux-nvme/20220227234258.24619-1-ematsumiya@suse.de/T/#u


Kind regards,
Niklas
