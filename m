Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EBB84A499C;
	Mon, 21 Sep 2026 15:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790003597; cv=none; b=LN3Fe7Ir8WhnK53txV9JtJ/aySd5a+/inN89edRswSdTTsP62viqWSOGg47HcQQcz82KEYES+ZbRW9c5mq32tmXWtPsdvzi3JsJv+BKtBy4PGAnvAZ8i+ZnwRLbnfyHj3bZX5RHeNN6QDpVdFjbMWbk5aJKlvfT9ifm2soGt1Og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790003597; c=relaxed/simple;
	bh=EWjQVAQIylvSG9W3zLdlfdbytmEt7s0TUvEcL8Wt6lU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EelJvwZMMTux0CAdkggV43XcM1bm+hOTN42xqC5uKEiUKN448vYN6uGWw8X2ngmto69dLPb6qHgpJLxddw1mTdLNj8GdgQ7A0/gIpBLBhXzmB2jDSOvvX/8EU9u265Vtns/hLp4eJ5chI2bM7QftRruprwBr5c4PXLc4U9eWzFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hfvZUyqc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hfvZUyqc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DF311F00898;
	Mon, 21 Sep 2026 15:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790003596;
	bh=IYANU/J0xdZa4loaPIsfvyi041uqY/e4r1IDgIdSdOU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hfvZUyqct5TkwpktLSJ8dfMTRCw2WKFhvEWPozX2ygHr2VwTaTVfCSPUs+BcfSmbw
	 N2kR1PCC7vlyIp+woiOyszf6b1MC6dCiGId/NF5n9e5dR9TfNgiAzKG+59Pu0dtPt7
	 +WsmNtrdBQlPAny09uMuoDvTOyFRN1XtD+awRRB2Y8hAvcIHF+SAyg94lfOYdhnkDj
	 kgywdHpIUPDOhrnHq7LxOdZjOhNXXpkn2M6CsLPjJj1RX1lJQyP2xnEd43yM8f07NW
	 IektM0ujog3ccc/lbq469bFpBBqAFwh/gic9B5zMsjfgV6VAXs7TiH/w9KPH5VmDXl
	 lI3eTVnuTtyDg==
Date: Mon, 21 Sep 2026 17:13:13 +0200
From: krzk@kernel.org
To: Guangshuo Li <lgs201920130244@gmail.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, 
	Ram Vegesna <ram.vegesna@broadcom.com>, Kees Cook <kees@kernel.org>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Daniel Wagner <dwagner@suse.de>, 
	James Smart <jsmart2021@gmail.com>, linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
	Thomas Gleixner <tglx@kernel.org>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	Hannes Reinecke <hare@suse.de>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH] scsi: efct: clear MWI on remove
Message-ID: <arFJiC1JGB0KpoLn@quoll>
References: <20260918181326.3633765-1-lgs201920130244@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260918181326.3633765-1-lgs201920130244@gmail.com>


On Sat, 19 Sep 2026 02:13:26 +0800, Guangshuo Li wrote:
> efct_pci_probe() enables PCI Memory-Write-Invalidate with pci_set_mwi().
> The probe failure path clears this state with pci_clear_mwi(), but the
> normal remove path does not perform the corresponding cleanup.
> 
> pci_disable_device() only disables PCI bus mastering and does not clear
> the PCI_COMMAND_INVALIDATE bit. As a result, the MWI configuration can
> remain enabled after the driver is removed.
> 
> Call pci_clear_mwi() in efct_pci_remove(), matching the probe error
> path.
> 
> This issue was found by manual code inspection.
> 
> Fixes: 4df84e8466242 ("scsi: elx: efct: Driver initialization routines")
> Cc: stable@vger.kernel.org
> Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
> ---
>  drivers/scsi/elx/efct/efct_driver.c | 1 +
>  1 file changed, 1 insertion(+)
> 


You sent multiple independent patches, to multiple independent
subsystems. The amount of these patches clearly suggest this was
AI generated and most likely not tested.

More importantly, you sent all this work without properly organizing
relevant patches into patchsets. This makes reviewing difficult
and might cause multiple reviewers to address the same issue.
Replying to the entire set is impossible and requires handling each
patch independently, instead of applying or discarding the set.
Maintainers also won't see the bigger picture of your work. Quite
worrying.

This is on the verge of hostile patch: bomb us with so many
contributions, we won't be able to handle them in efficient manner,
like responding ONCE to ask you to slow down.  Considering all this
is untested and LLM generated, I have even more doubts whether this
should be considered for review.

Please read kernel documentation BEFORE posting more work. It will
explain you how to identify subsystems, how to organize your work per
subsystem, how to document usage of LLM and how what you should not
do if this was posted in a good faith.

Best regards,
Krzysztof



