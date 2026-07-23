Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34B6C44C4EF;
	Thu, 23 Jul 2026 19:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784835001; cv=none; b=TFP8qnAXV78gwF1BD4jlEw5Kdx1czmHtQFQqgkGcyqaU3zrO9wI7KBmMJooq5zqTrRbBH6TOiJN7tKa+GbkgKgALEd1obC5pJdidU51Y29Au5U7mdJvz7PHHhsLmu5VhGWA4lePtysdQmOzPZ0UrrRphXbMJQAA8WDlc1sGImMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784835001; c=relaxed/simple;
	bh=TwWA1xCcEzuUuBFTE0AMItQB+YBiuWATuf/SC44C6OA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=am88LIu0U9+7tz1JPKfAky6CoQGTwl5dN+hm51DsCr+xBIuGiUci0M4CF74Jr4nY8/qMQyO+PoRAuPeBwglAmtF//QfVOX75fLjAIsUgcfBBglV9FUfTiRMPr2KkeDCjqGj3LyKcB/a1ZbNQBH0J1Q+3zbeSY0Wgj+UoSe5sfCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HpztF2W+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HpztF2W+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0B281F000E9;
	Thu, 23 Jul 2026 19:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784834998;
	bh=y5iomjCyRfRp3uujqn1eS42YOTWw+ABmMrptepvIZ7Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HpztF2W+jj+oPJBXBd5DBcqoA2Sm/XtLNAo7A3jLOwKkr8x9d2LlNJc5kOK87NXwV
	 dPfvFf436Ag4QAWvE4hqB+0CIaIog+ggZsQ3mr/KoGuZeT7PauU3CUF+DKT/KQGiyw
	 FLRRMPX6Juqw8TE9zKGvvEkK/N74UmZpHbG6YXAMajMDzSW4qR095hChwpIimswuz5
	 FmKTpz2ndXcBDeMV9c1wUZAFhLPoXzpKXNHeFyf3bAsS8jduYzwuQq95Gtem2ReCoX
	 4ZUVJbFHzbprLyxqinE64Imvapcq2pUpbKd09SDGjMeT0bBsnsCnQuBqAreyPWS7mS
	 DJoSCkrUJGJnA==
Date: Thu, 23 Jul 2026 14:29:57 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: Gary Guo <gary@garyguo.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
	Zhenzhong Duan <zhenzhong.duan@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	GOTO Masanori <gotom@debian.or.jp>,
	YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Vaibhav Gupta <vaibhavgupta40@gmail.com>,
	Jens Taprogge <jens.taprogge@taprogge.org>,
	Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	David Airlie <airlied@redhat.com>, linux-pci@vger.kernel.org,
	driver-core@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
	industrypack-devel@lists.sourceforge.net, netdev@vger.kernel.org,
	dri-devel@lists.freedesktop.org, Sashiko <sashiko-bot@kernel.org>
Subject: Re: [PATCH v3 9/9] pci: fix UAF when probe runs concurrent to dyn ID
 removal
Message-ID: <20260723192957.GA839273@bhelgaas>
References: <20260706-pci_id_fix-v3-9-2d48fc025acc@garyguo.net>
 <20260721223500.GA690676@bhelgaas>
 <DK66ISTEVM5H.3K5O68CW1F8ZB@garyguo.net>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DK66ISTEVM5H.3K5O68CW1F8ZB@garyguo.net>

On Thu, Jul 23, 2026 at 07:57:58PM +0100, Gary Guo wrote:
> On Tue Jul 21, 2026 at 11:35 PM BST, Bjorn Helgaas wrote:
> > On Mon, Jul 06, 2026 at 03:11:21PM +0100, Gary Guo wrote:
> >> Dynamic IDs are only guaranteed to be valid when dynids.lock is held,
> >> as remove_id_store can free the node. Thus, make a copy in
> >> pci_match_device. Also, clarify that the id parameter is only valid during
> >> probe.
> >> 
> >> Reported-by: Sashiko <sashiko-bot@kernel.org>
> >> Link: https://lore.kernel.org/all/20260619170503.518F61F00A3A@smtp.kernel.org/
> >> Fixes: 0994375e9614 ("PCI: add remove_id sysfs entry")
> >> Signed-off-by: Gary Guo <gary@garyguo.net>
> >> ---
> >>  drivers/pci/pci-driver.c | 28 +++++++++++++++-------------
> >>  include/linux/pci.h      |  1 +
> >>  2 files changed, 16 insertions(+), 13 deletions(-)
> >> 
> >> diff --git a/include/linux/pci.h b/include/linux/pci.h
> >> index 64b308b6e61c..92c17c116de6 100644
> >> --- a/include/linux/pci.h
> >> +++ b/include/linux/pci.h
> >> @@ -979,6 +979,7 @@ struct module;
> >>   *		function returns zero when the driver chooses to
> >>   *		take "ownership" of the device or an error code
> >>   *		(negative number) otherwise.
> >> + *		The pci_device_id parameter is only valid during probe.
> >
> > The probe function takes a pointer to a struct pci_device_id, so I
> > think the requirement is that the struct pci_device_id only *needs* to
> > be valid during .probe(), right, i.e., the PCI core probe path makes
> > its own copy of the ID and doesn't retain the pointer after .probe()
> > returns, right?
> >
> > I assume the caller determines the struct pci_device_id lifetime, and
> > it could be forever.
> >
> > Could say something like:
> >
> >   The pci_device_id parameter only needs to be valid during probe.
> 
> As a contract on function parameter, the caller needs to guarantee that it lives
> at least as long as documented (i.e. during the whole probe) and the callee
> cannot assume that it will be valid beyond what's guaranteed.
> 
> How about:
> 
>     The pci_device_id parameter is only guaranteed to be valid during probe.

That's ok with me.  My only niggle is that this documentation is that the
*consumer* end, and of course the consumer, i.e., the PCI core probe path,
can't guarantee anything about the parameters it receives.  But I guess
your point is that the *caller* must guarantee that the parameter remains
valid during probe.

The only thing the consumer can guarantee is that it doesn't depend on the
pci_device_id parameter after the probe returns.
