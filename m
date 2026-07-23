Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E70CB41A4F1;
	Thu, 23 Jul 2026 19:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784835756; cv=none; b=FeaA3uIaL7tWzi7+jVYJB0PxB2GMNvXrVLHwqtais0GqVZt4Kc5rqOEAlWtB0u54KQNhZ5E6/HXF9Z1alLot5qgiZVdficVEuiWguH+rh877PsQH326B4PmWIKDx4qJ+bJHUqQt6rqkHu2xKyP2etGoIS0Zqemo7JV5RvV80yYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784835756; c=relaxed/simple;
	bh=UxJHSpehpzEkAgFS7kKae4bAXdWqxKbmO5miFjLGpdc=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=Pfh0NSCCZmZZ1oVNL/dreSoEOSgEXz4YHWp24qJsqdC35H8++9YSn/qp1jvEN3c5YeLNys5sSUjUWiTsAOtT8e21Il0rKULI45jh5YMKcOHZcDFYgLAJ9GFO9K5vKkYue2+bcizlCQKgoMDScb8Ff1YH011gQLBJdzzF7ZnPhcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DUMcMrP+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DUMcMrP+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CC1E1F00ACF;
	Thu, 23 Jul 2026 19:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784835742;
	bh=eXneC4AEWZmvrSgFgM8FzSTm/obwIrjQiJj+mDbh5BA=;
	h=Date:From:To:Cc:Subject:In-Reply-To;
	b=DUMcMrP+BDegMe7pNmbuJpMshn+8iJlqLLLZWQ0ouM/Y3uwvPCrnp3rRoLKpWzp4p
	 5PbTeiAg1w/jDTOdYbNsEukR6yZ1rQvzXpDc90/Ti8ccL0O/0DEcOe1RDqlKMXIxqG
	 bUc1Ik01mBHXDGLbyOOKofh0PLYqk8mJnEoGIOmsNGl3FMqWbhZ0lwCfPkbEVsN4n6
	 CM4q+tYXH903I6roN6wYvVm9aq+XmoZ4jmyGeMjlJK0pXhYVfX7eT6wtbTEqQWec7+
	 tstU2ilKsw0rvh3POrcX+5kyYlgSwKr+7cxp23K+KqzBCrBodFtYb+jkuziHocy7DR
	 aB0CKPtVs235A==
Date: Thu, 23 Jul 2026 14:42:21 -0500
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
Message-ID: <20260723194221.GA850141@bhelgaas>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723192957.GA839273@bhelgaas>

On Thu, Jul 23, 2026 at 02:29:57PM -0500, Bjorn Helgaas wrote:
> On Thu, Jul 23, 2026 at 07:57:58PM +0100, Gary Guo wrote:
> > On Tue Jul 21, 2026 at 11:35 PM BST, Bjorn Helgaas wrote:
> > > On Mon, Jul 06, 2026 at 03:11:21PM +0100, Gary Guo wrote:
> > >> Dynamic IDs are only guaranteed to be valid when dynids.lock is held,
> > >> as remove_id_store can free the node. Thus, make a copy in
> > >> pci_match_device. Also, clarify that the id parameter is only valid during
> > >> probe.
> > >> 
> > >> Reported-by: Sashiko <sashiko-bot@kernel.org>
> > >> Link: https://lore.kernel.org/all/20260619170503.518F61F00A3A@smtp.kernel.org/
> > >> Fixes: 0994375e9614 ("PCI: add remove_id sysfs entry")
> > >> Signed-off-by: Gary Guo <gary@garyguo.net>
> > >> ---
> > >>  drivers/pci/pci-driver.c | 28 +++++++++++++++-------------
> > >>  include/linux/pci.h      |  1 +
> > >>  2 files changed, 16 insertions(+), 13 deletions(-)
> > >> 
> > >> diff --git a/include/linux/pci.h b/include/linux/pci.h
> > >> index 64b308b6e61c..92c17c116de6 100644
> > >> --- a/include/linux/pci.h
> > >> +++ b/include/linux/pci.h
> > >> @@ -979,6 +979,7 @@ struct module;
> > >>   *		function returns zero when the driver chooses to
> > >>   *		take "ownership" of the device or an error code
> > >>   *		(negative number) otherwise.
> > >> + *		The pci_device_id parameter is only valid during probe.
> > >
> > > The probe function takes a pointer to a struct pci_device_id, so I
> > > think the requirement is that the struct pci_device_id only *needs* to
> > > be valid during .probe(), right, i.e., the PCI core probe path makes
> > > its own copy of the ID and doesn't retain the pointer after .probe()
> > > returns, right?
> > >
> > > I assume the caller determines the struct pci_device_id lifetime, and
> > > it could be forever.
> > >
> > > Could say something like:
> > >
> > >   The pci_device_id parameter only needs to be valid during probe.
> > 
> > As a contract on function parameter, the caller needs to guarantee that it lives
> > at least as long as documented (i.e. during the whole probe) and the callee
> > cannot assume that it will be valid beyond what's guaranteed.
> > 
> > How about:
> > 
> >     The pci_device_id parameter is only guaranteed to be valid during probe.
> 
> That's ok with me.  My only niggle is that this documentation is that the
> *consumer* end, 

I meant to say this documentation is AT the consumer end.

> and of course the consumer, i.e., the PCI core probe path,
> can't guarantee anything about the parameters it receives.  But I guess
> your point is that the *caller* must guarantee that the parameter remains
> valid during probe.
> 
> The only thing the consumer can guarantee is that it doesn't depend on the
> pci_device_id parameter after the probe returns.
