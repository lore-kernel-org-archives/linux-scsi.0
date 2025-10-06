Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AD6A11713;
	Mon,  6 Oct 2025 15:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759763251; cv=none; b=fHd4LZ6BRgktljPizqBoXX5grEaE9qbvo6RLpQGsMWtaZTxZzt8t1ZExUhGa9WGBAtWoVw7AGgkzARr1KrcgQsoQHccqxIL3SXh8g6Eyt9CYPeDDnj4Y3j3ZXNVgY2I5IiydSkyBo8ngAz4dQLtIxij4DHNwMNoqJkHSDN/rPxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759763251; c=relaxed/simple;
	bh=JRvEheTB2TE+SWSBWDqF6/XEPi6lt1LK1nf4IJ+PL7Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uPkiXpgzgmpFMQaqUBAOxwlMqRj1yATmb+POL/V6DZjWOFWwv7g48xRlmKUyawR8v6eKg64+s0cox1/wDUnrn0mUU7T1ePQkeqIU0bUb+aSUlmhFymdpLdK7ibMJFBWokfhjhuOmcbfCeP9WTvV576vyOI28LSul6qREoIrKnXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RnIomwKK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RnIomwKK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0488DC4CEF5;
	Mon,  6 Oct 2025 15:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759763250;
	bh=JRvEheTB2TE+SWSBWDqF6/XEPi6lt1LK1nf4IJ+PL7Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RnIomwKKHD1eg4OR/A1VRiEvseOVy/bLYU7S9StzkRlYouF2BPWkcT8FSK5KUMmq2
	 4+pDWQmadYosK5L9lBfDqGIvNFo253YGT0jkRaMHScOH0r1BTsKWzgbL2mFcG526qX
	 KWIzkuhc4kOlj8xbM6+x8Sd6ZJ+kE1GGc9Wn0/rD9pvGY1u0SN06B45Gn9CWEF2UhZ
	 vx5pAlH8VCq6hmKDqqYgaQRX1dPO0vWaGvwL+UnxQvu689nlCQntuAjUBtJVelyvvq
	 eznbk/53+9sBtJck9zKjCOPHsuYobNnMqT0quWnFv0/06Frm5OXdqdDAbzM/MusrjD
	 j5TvM+EKGCOLg==
Date: Mon, 6 Oct 2025 17:07:26 +0200
From: Niklas Cassel <cassel@kernel.org>
To: Markus Probst <markus.probst@posteo.de>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Power on ata ports defined in ACPI before probing
 ports
Message-ID: <aOPbLlvbfFadVQsV@ryzen>
References: <8c3cb28c57462f9665b08fdaa022e6abc57fcd9e.camel@posteo.de>
 <20251005190559.1472308-1-markus.probst@posteo.de>
 <20251005190559.1472308-2-markus.probst@posteo.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251005190559.1472308-2-markus.probst@posteo.de>

On Sun, Oct 05, 2025 at 07:06:07PM +0000, Markus Probst wrote:
> some devices (for example every synology nas with "deep sleep" support)

Some devices?
I assume you mean the HBA and not the devices connected to the HBA.


> have the ability to power on and off each ata port individually. This
> turns the specific port on, if power manageable in acpi, before probing
> it.
> 
> This can later be extended to power down the ata ports (removing power
> from a disk) while the disk is spin down.

Spun down?


Overall this commit message needs some serious improvement.

I have no idea what Synology NAS with "deep sleep" support is.

We don't add support for vendor specific features.

Please reference the proper ATA ACS / AHCI / SATA / ACPI specification,
including the version of said specification and which section in that
specification.


Kind regards,
Niklas
