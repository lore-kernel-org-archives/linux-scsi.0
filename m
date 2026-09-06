Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CFA318DB2A;
	Sun,  6 Sep 2026 10:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788689873; cv=none; b=ViadNrR9lKIPZQTfXzU5BbcMnGBpvam75B42w6RlQS/pT9L9wf5HsvXI3FJCVQxTvpFW6o2WVE39Ik2/TO9ElS5/VrBDeGlnPooDRiJRLvKnd0mWY0CHzovBWIT/bC4hvoZTDDH1aDyarwPli/Dhy0lqUKIu8Ti088/jRqNKEFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788689873; c=relaxed/simple;
	bh=KNbMmecFW8pnxQbyIPh4G7INs6HNiN4eOiQGWdcw8VM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KSlBSHEb2KYaGniHMdp1IC0cJUMgh5pi6m3yA6vwX6KhYHXhX1b3umM2zdgsU0RBcSInNVlfRumK7ls2V4BPzphKUZ9S4SlunsDM9Lkjryj2ZeytrKzca8Dz77gQaU1EVbpIxidV/FNsUZL/b14L61PZMVP499Jl+t5CZ4Jg0Qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LYOqj9wn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LYOqj9wn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AE781F00A3A;
	Sun,  6 Sep 2026 10:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788689871;
	bh=6cz/R+51JS7kiWhTPDSyzvviNSGMJboGNNDJolsr+k4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LYOqj9wnc9s9dXA/dN4ufaiGBKW9N1kixaqCKk1pLWKkLVBQD8kc/+rqvh/ucSZlw
	 UeSdKi/LHX5KMK/pEcoCLey23Mzeb+AdI6aK0UtA5Yn7nIUz1FevAVpzgzOw/NEsro
	 vnQHxqNl8ATequbgqoYwqG0IgV81U/nVaH0CnVn/TV7Ifr9pL0oUCCbNfYMxAn/lVY
	 XePso2voDHnavJY1uP+I1VEvQnOVyjC1ZhB9F5yl/dy5bvNMi1LjpMDuNwisInAVJ3
	 Nr+l80MyEyPiKakDaNPi8P37wYbU56iWMM30QQtF6yGKx5zA+YJi8QKKNyS7QiGA8F
	 77InxZkCqtmkg==
Date: Sun, 6 Sep 2026 11:17:47 +0100
From: Simon Horman <horms@kernel.org>
To: Ethan Nelson-Moore <enelsonmoore@gmail.com>
Cc: Uwe =?utf-8?Q?Kleine-K=C3=B6nig_=28The_Capable_Hub=29?= <u.kleine-koenig@baylibre.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>, netdev@vger.kernel.org,
	linux-scsi@vger.kernel.org, Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Subject: Re: [PATCH] zorro: use module_driver() to avoid repeated boilerplate
 code
Message-ID: <20260906101747.GH40544@horms.kernel.org>
References: <20260906034037.81379-1-enelsonmoore@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260906034037.81379-1-enelsonmoore@gmail.com>

On Sat, Sep 05, 2026 at 08:40:19PM -0700, Ethan Nelson-Moore wrote:
> Many Zorro drivers have module_init and module_exit functions that only
> call zorro_register_driver() and zorro_unregister_driver(). The
> module_driver() macro automatically generates these functions given the
> register and unregister functions. Switch to it to simplify the code.
> 
> Signed-off-by: Ethan Nelson-Moore <enelsonmoore@gmail.com>
> ---
>  drivers/net/ethernet/8390/hydra.c     | 13 +------------
>  drivers/net/ethernet/8390/zorro8390.c | 13 +------------
>  drivers/net/ethernet/amd/a2065.c      | 13 +------------
>  drivers/net/ethernet/amd/ariadne.c    | 13 +------------
>  drivers/scsi/a2091.c                  | 12 +-----------
>  drivers/scsi/gvp11.c                  | 12 +-----------
>  drivers/scsi/zorro7xx.c               | 13 +------------
>  drivers/scsi/zorro_esp.c              | 13 +------------
>  8 files changed, 8 insertions(+), 94 deletions(-)

I think it would be best to split this patch up on a per-subsystem
of per driver basis. And send patches to appropriate subsystems.

In particular, please break out the net/ changes into a patchset
for net-next.

--
pw-bot: changes-requested
