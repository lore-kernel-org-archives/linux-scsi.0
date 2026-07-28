Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BE32377555;
	Tue, 28 Jul 2026 16:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785255941; cv=none; b=Nomjm8pQ4MYu+ayQhw5LS15RqsnDLZ85zM/kdAFm0ioQ277bLfhVqtDw2cKlMh6zLLGlck+CnCFXk5DQCZezoOxHiOI7QI1KMW3hZT2Y/hrReoCYGAR2r5aOxmeNhDlrF6/WyvFcq7Hu5V8zEvxTg2YXIjW9NDoEHCV3t9a6lQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785255941; c=relaxed/simple;
	bh=BT1DIgdzT42YfZKQdhZmZpBZamrrpNno/BeBkl3FQbs=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=C3AhVvb2IowU443pzZWCT1M9zFF6U+hnE/MVybtpACV9cLn6DRONbL+Q138lgr8fZzBK7rWRqQjoTYUmT7zITUwzTCqsr7/OczM677RPo5IyG4uxxfi6WOy3ORTPAHluy+4DcL4KX0YlKuRZdMgEVI8j0vxcZSxiyxFYho+WqH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T8YExfa9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T8YExfa9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0A251F000E9;
	Tue, 28 Jul 2026 16:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785255940;
	bh=Xuug4pB3DkO4ZZbUvsCWkdl6bCUlkn/0WO+uIgwQQVU=;
	h=Date:From:To:Cc:Subject:In-Reply-To;
	b=T8YExfa9XlTKa1ZO468fuXFLapFvDY1t1nFVEp5r+4hoLPiTSfICMok0zRC5aHbUi
	 xdz6qdxkXdSQKx0RLqhKJf9cvAR9xL1gyJGxvwcrb88Vc3y4iHbtMLPUKeDqyR32Ot
	 AEKVrWQyjX+7f8+yfxcvopTf6LGEZB5rpuPZ/SU9DNbeWcxQXTqE3tVtAPnw563WSc
	 1xzPSm/aLxknHHQQwaTw9f0fxPcwmcFGVdXGpWXpdV8uctvc7HVNzXN9DyxyhDC9bW
	 Byn5zCLBcksarx81xLTjrL4TTsieo9ua+iqsAKTFGX9dZ0HPnnhGvCFIBJ6CQoTUL8
	 tyC0oYDRjuJBw==
Date: Tue, 28 Jul 2026 11:25:38 -0500
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
Subject: Re: [PATCH v4 0/9] PCI: Fix UAF and TOCTOU related to dynamic ID
Message-ID: <20260728162538.GA1325438@bhelgaas>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723-pci_id_fix-v4-0-3580726844e1@garyguo.net>

On Thu, Jul 23, 2026 at 11:00:39PM +0100, Gary Guo wrote:
> While working on improving the Rust abstractions [1], Sashiko reported that
> an existing UAF issue related to dynamic ID, which I find to be genuine.
> When taking a look at the code I also find a TOCTOU issue where the
> existence check of dynamic ID happens in a separate critical section as the
> actual insertion. This series fix both issues.
> 
> There are two exported functions pci_match_id() and pci_add_dynid() which I
> have to tweak to implement this cleanly; I created separate "do_xxx"
> functions to keep the existing APIs because they all have multiple users.
> 
> There're a few existing users which stores their pci_device_id argument in
> probe callback. This is a bad pattern because nothing except driver_data
> inside pci_device_id is what they want; actual ID information can be
> retrieved from pci_dev instead.
> 
> There are two users that performs pointer arithmetic on the pci_device_id;
> these are also problematic with dynamic ID and driver_override, so fix them
> as well.
> 
> I've used the following coccinelle script to flag all cases where the
> pci_device_id is used other than reading its fields.
> 
> @usage@
> identifier fn, id;
> position p;
> @@
>   fn(..., struct pci_device_id *id, ...)
>   {
>     ...
>     id@p
>     ...
>   }
> 
> // Due to cocci isomorphism this needs to be explicit
> @bad@
> identifier fn, id;
> type T;
> position usage.p;
> @@
>   fn(..., struct pci_device_id *id, ...)
>   {
>     ...
>     (T*)id@p
>     ...
>   }
> 
> // Good use cases
> @good@
> identifier fn, id, fld;
> expression E;
> position usage.p;
> @@
>   fn(..., struct pci_device_id *id, ...)
>   {
>     ...
> (
>     id@p->fld
> |
>     E(..., id@p, ...)
> |
> // Redundant checks, but ignore
>     !id@p
> |
> // Redundant checks, but ignore
>     id ? ... : ...
> )
>     ...
>   }
> 
> @script:python depends on usage && (bad || !good)@
> p << usage.p;
> @@
> coccilib.report.print_report(p[0], "suspicious use of pci_device_id")
> 
> Link: https://lore.kernel.org/all/20260618-id_info-v1-0-96af1e559ef9@garyguo.net/ [1]
> Link: https://lore.kernel.org/all/20260619170503.518F61F00A3A@smtp.kernel.org/ [2]
> 
> ---
> Changes in v4:
> - Code and commit message style fixes (Bjorn)
> - Link to v3: https://patch.msgid.link/20260706-pci_id_fix-v3-0-2d48fc025acc@garyguo.net
> 
> Changes in v3:
> - Fix users which uses pci_device_id for pointer arithmetic. (Sashiko)
> - Convert to scoped_guard. (Danilo)
> - For static IDs, still give out static pointers and avoid making a copy.
> - Link to v2: https://patch.msgid.link/20260630-pci_id_fix-v2-0-b834a98c0af2@garyguo.net
> 
> Changes in v2:
> - Fix users which store pci_device_id.
> - Clarify in probe documentation about the lifetime of pci_device_id
>   parameter.
> - Dynamic ID conflict check now ignores override_only. (Sashiko)
> - Link to v1: https://patch.msgid.link/20260626-pci_id_fix-v1-0-a35c803f1b95@garyguo.net
> 
> ---
> Gary Guo (9):
>       ata: ata_generic: don't store pci_device_id
>       scsi: nsp32: don't store pci_device_id
>       ipack: tpci200: don't store pci_device_id
>       mlxsw: pci: don't store pci_device_id
>       agp/via: Don't rely on address of pci_device_id
>       agp/amd-k7: Don't rely on address of pci_device_id
>       PCI: Make pci_match_one_device() match on ID instead of device
>       PCI: Fix dyn_id add TOCTOU
>       PCI: Fix UAF when probe runs concurrent to dyn ID removal
> 
>  drivers/ata/ata_generic.c                 |   6 +-
>  drivers/char/agp/amd-k7-agp.c             |  26 +--
>  drivers/char/agp/via-agp.c                | 308 +++++++-----------------------
>  drivers/ipack/carriers/tpci200.c          |   1 -
>  drivers/ipack/carriers/tpci200.h          |   1 -
>  drivers/net/ethernet/mellanox/mlxsw/pci.c |  11 +-
>  drivers/pci/pci-driver.c                  | 194 ++++++++++---------
>  drivers/pci/pci.h                         |  43 +++--
>  drivers/pci/search.c                      |   8 +-
>  drivers/scsi/nsp32.c                      |   8 +-
>  drivers/scsi/nsp32.h                      |   8 +-
>  include/linux/pci.h                       |   1 +
>  12 files changed, 237 insertions(+), 378 deletions(-)

I put this on pci/enumeration and plan it for v7.3, hopefully with
acks from the AGP, tpci200, and nsp32 folks.
