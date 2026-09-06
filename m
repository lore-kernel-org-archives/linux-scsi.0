Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44ED638C426;
	Sun,  6 Sep 2026 10:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788689786; cv=none; b=AQzdEbQDDYTgA3SZoz6osxdTMmijeWnRVdAlwCmjJqJNbriM2nZY04Stkd33fcd17MSmLeIhurrA4cotjQZ6nD67KS/LAPWUXWIIVNJ78PO+wzjTRdu0Hx58Rxr4qA4CUIR2LjMjVRuj/ADhqe5HiBM9oFEgUK9AkrobNCjjcN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788689786; c=relaxed/simple;
	bh=w52dlVvTuSE3q233cNH4XCMP45qKmpRtdG4rlZuHKeQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hQbiXN0CzTyQ7YcKHEgybeeM+tF1tQbPECbCC2Wc1jGkjWHWiZWRnPPpwp2XBJysJVd1T72wuwP0fzUBYJzoi0KCL2b6pOsZXHvcJ410AsBppApHAIo1nb2Lg675GJMHG1U3mDproQCcsG9Vrlp/aYQ0CF7+rJO4Tn2anpxpJec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hy93BAmp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hy93BAmp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADAF21F00A3A;
	Sun,  6 Sep 2026 10:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788689784;
	bh=nvNK7T3zH0fzn4zq1Q+HDzlH0q+EO8s3/+84Yfx3rJQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hy93BAmpcuVm8PuBkqCf8XO2NQmzpXcagxY7Wlvx2XEbymcBwQbD+XfJUxG0or7wn
	 YuE5sr+moKQlHP0RRYBktFuZDjK5Q7AIFlnLS1F73EFcEAKbmtpDdGNkzuZJzE2bL5
	 yn68wrbYWZ6eEXzIeEkYGh7GOCcn6lGNK17jJkILAkltQ+48/LTWwBqCfpjdNuJ/Iz
	 l871wGzA66XqS01sn83Nqc5EJt0m1hStpseYyI7rTBiqT7xdNchU2STc7JsZAzmJzk
	 CU9M8027h3MAGBNlAsB8LIA1hES+w1bHS+F96AySiHbVyQRD4dA9+7cBoOLySpA4Qf
	 EqNojmLSsCOQQ==
Date: Sun, 6 Sep 2026 11:16:19 +0100
From: Simon Horman <horms@kernel.org>
To: Ethan Nelson-Moore <enelsonmoore@gmail.com>
Cc: Kees Cook <kees@kernel.org>, linux-ide@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
	linux-scsi@vger.kernel.org, linux-serial@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Russell King <linux@armlinux.org.uk>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jiri Slaby <jirislaby@kernel.org>
Subject: Re: [PATCH] ecard: use module_driver() to avoid repeated boilerplate
 code
Message-ID: <20260906101619.GG40544@horms.kernel.org>
References: <20260906040153.105692-1-enelsonmoore@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260906040153.105692-1-enelsonmoore@gmail.com>

On Sat, Sep 05, 2026 at 09:01:46PM -0700, Ethan Nelson-Moore wrote:
> Many Acorn expansion card drivers have module_init and module_exit
> functions that only call ecard_register_driver() and
> ecard_remove_driver(). The module_driver() macro automatically
> generates these functions given the register and unregister functions.
> Switch to it to simplify the code.
> 
> Signed-off-by: Ethan Nelson-Moore <enelsonmoore@gmail.com>
> ---
>  drivers/ata/pata_icside.c            | 13 +------------
>  drivers/net/ethernet/i825xx/ether1.c | 13 +------------
>  drivers/net/ethernet/seeq/ether3.c   | 13 +------------
>  drivers/scsi/arm/acornscsi.c         | 13 +------------
>  drivers/scsi/arm/arxescsi.c          | 14 +-------------
>  drivers/scsi/arm/cumana_1.c          | 13 +------------
>  drivers/scsi/arm/cumana_2.c          | 13 +------------
>  drivers/scsi/arm/eesox.c             | 13 +------------
>  drivers/scsi/arm/oak.c               | 14 +-------------
>  drivers/scsi/arm/powertec.c          | 13 +------------
>  drivers/tty/serial/8250/8250_acorn.c | 13 +------------

I think it would be best to split this patch up on a per-subsystem
of per driver basis. And send patches to appropriate subsystems.

In particular, please break out the net/ changes into a patchset
with one or two patches for net-next.

-- 
pw-bot: changes-requested
