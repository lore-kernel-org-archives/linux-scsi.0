Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 173A343F4C0;
	Tue, 21 Jul 2026 22:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673050; cv=none; b=qY0eRNDFTdn9nt/tyup6cK0cSzZIk9pg02KKOo1BRAG5Ms+BMzp448Gm1OwxFuBMAinToR1tKFgGn76hcyKvMU1bwJ7YXFz7+kPmMXnIVo1yPQkaxwGtpNM7hDon4hVMTWxUMHGwTIHhAkbG6OkUUouSmd8etbq4RqAwZQQ+ewk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673050; c=relaxed/simple;
	bh=ATKi2XAXyV80dXc2EWq6ISvVM3/3F/VDwQXheYbZ9AQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=u1yyYxzy792bKXCTlExsQXK7nIIhllx9Q421f5qyscSMjmyHRIuv7Hj8FLLGpbKp+muRY0k/WZ50b3ElON9bPCW+OH1qpMvlPX/vOwGl+YdstNWbTKK80sZPcQPd4jo6Krj8w2Otf1NgOsvGFa/PjLnT/d93vpZNJ05V7VOaLH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DtGpsbMI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DtGpsbMI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B67EC1F000E9;
	Tue, 21 Jul 2026 22:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784673048;
	bh=n0ky1DYEFYEQIfECSmhtvkQAZsT3axmRZ/FY1Oisxv8=;
	h=Date:From:To:Cc:Subject:In-Reply-To;
	b=DtGpsbMInwZaKFrcKnmjY3BR/jkGLaa8T4/I+Y3YLwngGGgLwovmu7FQmfRoZGLWe
	 e8W2dMpmJzKf8v9Sc70V6XSymIY0MwmaNFEBGrREc5/nRZgDrM5EnYPEo5mf1qm+4u
	 Jp/7MQAXMsznIY0loTrqvPzKCzw5y5gemX2eC8bggJj63uOB9swEu3zdTER2J3DJf2
	 nJ6XK1iEFCi29f1gqQXhUONyPer9hWNZWIr2XN6+UgoLA6d/8v3kk5BMefYIwFAuKx
	 4kEqhud2ywy9qxIY2rKn2GAyjrR7vD3TvvEm2INVadz63wd9dbvAUhjh515B3kWBqb
	 yu1KbJPltS1Mg==
Date: Tue, 21 Jul 2026 17:30:47 -0500
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
Message-ID: <20260721223047.GA674520@bhelgaas>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260630-pci_id_fix-v2-0-b834a98c0af2@garyguo.net>

On Tue, Jun 30, 2026 at 12:09:00PM +0100, Gary Guo wrote:
> While working on improving the Rust abstractions [1], Sashiko reported that
> an existing UAF issue related to dynamic ID, which I find to be genuine.
> When taking a look at the code I also find a TOCTOU issue where the
> existence check of dynamic ID happens in a separate critical section as the
> actual insertion. This series fix both issues.
> 
> There are two exported functions "pci_match_id" and "pci_add_dynid" which I
> have to tweak to implement this cleanly; I created separate "do_xxx"
> functions to keep the existing APIs because they all have multiple users.
> 
> There're a few existing users which stores their pci_device_id argument in
> probe callback. This is a bad pattern because nothing except driver_data
> inside pci_device_id is what they want. Actual ID information can be
> retrieved from pci_dev instead. I've used the following coccinelle script
> to find the cases where the argument is stored and converted them to stop
> storing pci_device_id.
> 
> @store@
> identifier fn;
> identifier id;
> expression E;
> parameter list[n] ps;
> @@
>   fn(ps, struct pci_device_id *id, ...)
>   {
>     ...
> *   E = id
>     ...
>   }
> 
> @cast@
> identifier fn;
> identifier id;
> parameter list[n] ps;
> @@
>   fn(ps, struct pci_device_id *id, ...)
>   {
>     ...
> *   (void *)id
>     ...
>   }
> 
> @in_struct@
> identifier s, fld;
> @@
>   struct s {
>     ...
> *   struct pci_device_id *fld;
>     ...
>   };
> 
> Link: https://lore.kernel.org/all/20260618-id_info-v1-0-96af1e559ef9@garyguo.net/ [1]
> Link: https://lore.kernel.org/all/20260619170503.518F61F00A3A@smtp.kernel.org/ [2]
> 
> ---
> Changes in v2:
> - Fix users which store pci_device_id.
> - Clarify in probe documentation about the lifetime of pci_device_id
>   parameter.
> - Dynamic ID conflict check now ignores override_only. (Sashiko)
> - Link to v1: https://patch.msgid.link/20260626-pci_id_fix-v1-0-a35c803f1b95@garyguo.net
> 
> ---
> Gary Guo (7):
>       ata: don't keep pci_device_id
>       nsp32: don't keep pci_device_id
>       ipack: tpci200: don't keep pci_device_id
>       mlxsw: don't keep pci_device_id
>       pci: make pci_match_one_device match on ID instead of device
>       pci: fix dyn_id add TOCTOU
>       pci: fix UAF when probe runs concurrent to dyn ID removal

Run "git log --oneline drivers/pci" and match style (capitalize "PCI:"
and first word of subject).

At least in the PCI patch commit logs and comments, add "()" after
function names.

s/id/ID/ throughout (it's currently inconsistent).
s/pci/PCI/ throughout (ditto)
