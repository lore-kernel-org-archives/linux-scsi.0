Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC0FA3F6C22;
	Thu, 23 Jul 2026 21:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784841053; cv=none; b=iLcGvfKPA7H2ZzAZrhEeLzGB97BTxBqkp5UhSvVsTdWnRa3gYIXiJpSPs82k5rlK1t8mkoLTMhMkqQu0G+49LEzvN7TGeUxSsL2Bj4UjMhvboymE8IUTRANq7gD7Dpahu4r6or66+Z49XJ2nU9zWaqQC90C8a38ym5Hy18CBVCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784841053; c=relaxed/simple;
	bh=0onsvWqd3YLA8Ugz/XPAOOqHIJEj4tHBryHNYr362UI=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=RIx63FPDHrQiZNVUHTISjKifq1Zo4WhpmphZPEBfj7xNYgcPqtYg5BWa5RBDnwJBbwMAKVAw1UYphmLeMCQ/TUNEidWmgV9fdPKWlK/3mW7Nm0j9L5+lZSAKh/2qxW8R1Oq+rhhO+yDLIUeGLuE4aJnNwbvI0Yuy9Uv6BckOq1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FkODYz35; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FkODYz35"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A0881F000E9;
	Thu, 23 Jul 2026 21:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784841049;
	bh=5f9ZtsjVxvvVMvTLjI49xDxBHtnl7xTVDp8nqfIG+AU=;
	h=Date:From:To:Cc:Subject:In-Reply-To;
	b=FkODYz35kP7ItLHXLj7+ej0aCz7/XB1I0nj2NlHbujPL2ltI3Mnx1VSjzH8o8y4rS
	 E2ehk2LOEeW2IFH4HycAobCulyM6g9HO7sKrz77K80RYWQD39b/mZGOfsrpH1gw5hF
	 by5G8VfCJllg0j3fdBRlmTF1q0AuFpnCqbPV7sILcHfy9sF0P/N25znpChnLHJkriy
	 kZsOnBfAx15dpcU3r53MCTMobDleW9Yp//gn9AQdVMJqKrdMti1wprCiOnHuiPpcT4
	 CbhpQe4ZfWYkjoRkAK/vlKML8N+cElkZ8nmm0sO8gqe3p2dVI/mV/mc7+WmvBXkM9U
	 LEYm8WUGknPdQ==
Date: Thu, 23 Jul 2026 16:10:48 -0500
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
Message-ID: <20260723211048.GA857046@bhelgaas>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DK67INM1MX6H.1FA6WNE8RZ9R7@garyguo.net>

On Thu, Jul 23, 2026 at 08:44:48PM +0100, Gary Guo wrote:
> On Thu Jul 23, 2026 at 8:29 PM BST, Bjorn Helgaas wrote:
> > On Thu, Jul 23, 2026 at 07:57:58PM +0100, Gary Guo wrote:
> >> On Tue Jul 21, 2026 at 11:35 PM BST, Bjorn Helgaas wrote:
> >> > On Mon, Jul 06, 2026 at 03:11:21PM +0100, Gary Guo wrote:
> >> >> Dynamic IDs are only guaranteed to be valid when dynids.lock is held,
> >> >> as remove_id_store can free the node. Thus, make a copy in
> >> >> pci_match_device. Also, clarify that the id parameter is only valid during
> >> >> probe.
> >> >> 
> >> >> Reported-by: Sashiko <sashiko-bot@kernel.org>
> >> >> Link: https://lore.kernel.org/all/20260619170503.518F61F00A3A@smtp.kernel.org/
> >> >> Fixes: 0994375e9614 ("PCI: add remove_id sysfs entry")
> >> >> Signed-off-by: Gary Guo <gary@garyguo.net>
> >> >> ---
> >> >>  drivers/pci/pci-driver.c | 28 +++++++++++++++-------------
> >> >>  include/linux/pci.h      |  1 +
> >> >>  2 files changed, 16 insertions(+), 13 deletions(-)
> >> >> 
> >> >> diff --git a/include/linux/pci.h b/include/linux/pci.h
> >> >> index 64b308b6e61c..92c17c116de6 100644
> >> >> --- a/include/linux/pci.h
> >> >> +++ b/include/linux/pci.h
> >> >> @@ -979,6 +979,7 @@ struct module;
> >> >>   *		function returns zero when the driver chooses to
> >> >>   *		take "ownership" of the device or an error code
> >> >>   *		(negative number) otherwise.
> >> >> + *		The pci_device_id parameter is only valid during probe.
> >> >
> >> > The probe function takes a pointer to a struct pci_device_id,
> >> > so I think the requirement is that the struct pci_device_id
> >> > only *needs* to be valid during .probe(), right, i.e., the PCI
> >> > core probe path makes its own copy of the ID and doesn't retain
> >> > the pointer after .probe() returns, right?
> >> >
> >> > I assume the caller determines the struct pci_device_id
> >> > lifetime, and it could be forever.
> >> >
> >> > Could say something like:
> >> >
> >> >   The pci_device_id parameter only needs to be valid during
> >> >   probe.
> >> 
> >> As a contract on function parameter, the caller needs to
> >> guarantee that it lives at least as long as documented (i.e.
> >> during the whole probe) and the callee cannot assume that it will
> >> be valid beyond what's guaranteed.
> >> 
> >> How about:
> >> 
> >>     The pci_device_id parameter is only guaranteed to be valid
> >>     during probe.
> >
> > That's ok with me.  My only niggle is that this documentation is
> > that the *consumer* end, and of course the consumer, i.e., the PCI
> > core probe path, can't guarantee anything about the parameters it
> > receives.  But I guess your point is that the *caller* must
> > guarantee that the parameter remains valid during probe.
> 
> I'm not quite getting it, the PCI core probe path is pci-driver.c
> which is the caller? Do you mean that the PCI *driver* probe path
> cannot guarantee anything about the parameter it receives?
> 
> > The only thing the consumer can guarantee is that it doesn't
> > depend on the pci_device_id parameter after the probe returns.
> 
> How about:
> 
>     The pci_device_id parameter may not be valid after the probe
>     returns and must not be used afterwards.

You're right, sorry, I had this all completely backwards.  I was
thinking the pci_device_id came from a PCI endpoint driver, but of
course that's not right.  The PCI core *supplies* it to the driver's
.probe() function, and that .probe() shouldn't save the pointer.

I think either your original text or your last proposal is fine.

Sorry for confusing all this!
