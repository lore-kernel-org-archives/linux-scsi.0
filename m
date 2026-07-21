Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93A2434DCE4;
	Tue, 21 Jul 2026 22:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673408; cv=none; b=MG12pDBiKqBSMmXy7EsI5RlJgV8ry7qI8kEsgxBQyHQ7Q4aFIvPd9Z1BTMFNqKQ/veLdrwBDDs6jgVMwyyjF+CUK1UazFN7xD6t7WWHw4tvhIXbMPGRcBtQOvnE4H74F3AId3V5WZPqv3vYArZie3Q7cmbAwPD3Mebxk3HdcSdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673408; c=relaxed/simple;
	bh=zCpZ6cMZxpu+FnZfREcPlSh0Oc2yxVtn47lAlVAne7U=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=SsyFi8OB/AWQxURxhheSNUKRZ3w3gkakjxsgkwVwnhh6POrxclLBfB1b+XogB1GJMoni4X1OYQ/MqJ3imMs/HDtdoC1eh6ocOrzLQjB6x1936w6NUfuVMS9EW1pRe537bqgkQ2+aqor7iDhavC40Vk6lQLRM9rEtVMrVoeAvKNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WMWrG9Vr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WMWrG9Vr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F4211F00A3A;
	Tue, 21 Jul 2026 22:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784673407;
	bh=GbaGTFg92X9VSXyCz+gDj4BHQHyXiWNw9Wm7PrN03cY=;
	h=Date:From:To:Cc:Subject:In-Reply-To;
	b=WMWrG9Vro+kasnzoHGuz4lclOg565LgERMNsBQq35Z6WvwgaJUCPq39hJFy5cSPuI
	 OsycCif9aTXGESlcC5tm0zY8ETRMyl0p1nk5Z5jpv7dJ1RkErNNZd/+n/w1MFXe/2A
	 mWrMDKJBCWbJPUq9ymXyEAX132TtrKUjtRlw9Cmreahfo7sMXv2q5fdh0o9I9899Mu
	 O4iANqS0iCIq71gQp30B3yfcz+SRKiC49WCWSCGqrfsVMax1L6R5NUPD6No0sYYIQY
	 gDpmVT2joZeqInBmjt3AA0KXjn5ca3rROEZSuACfLpBkLCP+bIdpFWLPBsWTrV/4gV
	 j3qak2SYezhQg==
Date: Tue, 21 Jul 2026 17:36:46 -0500
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
	linux-pci@vger.kernel.org, driver-core@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	industrypack-devel@lists.sourceforge.net, netdev@vger.kernel.org,
	Sashiko <sashiko-bot@kernel.org>
Subject: Re: [PATCH v2 0/7] pci: fix UAF and TOCTOU related to dynamic ID
Message-ID: <20260721223646.GA695827@bhelgaas>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260721223047.GA674520@bhelgaas>

On Tue, Jul 21, 2026 at 05:30:47PM -0500, Bjorn Helgaas wrote:
> On Tue, Jun 30, 2026 at 12:09:00PM +0100, Gary Guo wrote:
> > While working on improving the Rust abstractions [1], Sashiko reported that
> > an existing UAF issue related to dynamic ID, which I find to be genuine.
> > When taking a look at the code I also find a TOCTOU issue where the
> > existence check of dynamic ID happens in a separate critical section as the
> > actual insertion. This series fix both issues.
> ...

> Run "git log --oneline drivers/pci" and match style (capitalize "PCI:"
> and first word of subject).
> 
> At least in the PCI patch commit logs and comments, add "()" after
> function names.
> 
> s/id/ID/ throughout (it's currently inconsistent).
> s/pci/PCI/ throughout (ditto)

Oops, sorry, I meant to reply to v3, not v2.
