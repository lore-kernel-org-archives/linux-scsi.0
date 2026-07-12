Received: from mailout2.hostsharing.net (mailout2.hostsharing.net [83.223.78.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C878E1FF5E3;
	Sun, 12 Jul 2026 14:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.223.78.233
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783866510; cv=none; b=n1aJwmjBRr8pFyn517/nzvpa6R7VFKssgzT0bL+iu1dGcpmFVxV4kuEekcqoYpsgUO2rohCl/y0KzfGAJ3b5hITe2PuOB58JY+hYzQFI82gYOma4ZTME/tnqu3umjnwS10fFWGUVV7906AJGq2+1AeCDF0fv43wjQFJ5O9F461k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783866510; c=relaxed/simple;
	bh=I+KFbiFzvw83rXUdeHnCjoqry53vD1aM4l4d4CLSeSw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EPrz05+eupWN0PJSnAkhZzrnov4MWd6yBHZA8PtbCN3k58ZVym5HTJJWW8+Xp8om0hjp+rnNaVpIXzUFeQpEsln76mGso+Is63xK/EJFMYgURomRX6osV7IEqbi8LNnEJLqi2T+26zYNNwB8Yf22B5RdV89HLnnloq7m2uiPht4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de; spf=pass smtp.mailfrom=wunner.de; arc=none smtp.client-ip=83.223.78.233
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wunner.de
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature ECDSA (secp384r1) server-digest SHA384
	 client-signature ECDSA (secp384r1) client-digest SHA384)
	(Client CN "*.hostsharing.net", Issuer "GlobalSign GCC R6 AlphaSSL CA 2025" (verified OK))
	by mailout2.hostsharing.net (Postfix) with ESMTPS id DD65710632;
	Sun, 12 Jul 2026 16:28:18 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
	id CA35D60211BE; Sun, 12 Jul 2026 16:28:18 +0200 (CEST)
Date: Sun, 12 Jul 2026 16:28:18 +0200
From: Lukas Wunner <lukas@wunner.de>
To: Maurice Hieronymus <mhi@mailbox.org>
Cc: Edward Cree <ecree.xilinx@gmail.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Justin Tee <justin.tee@broadcom.com>,
	Paul Ely <paul.ely@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
	Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>,
	Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Tamir Duberstein <tamird@kernel.org>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Onur =?iso-8859-1?Q?=D6zkan?= <work@onurozkan.dev>,
	Borislav Petkov <bp@alien8.de>, Tony Luck <tony.luck@intel.com>,
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org,
	netdev@vger.kernel.org, linux-net-drivers@amd.com,
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
	linux-scsi@vger.kernel.org, xen-devel@lists.xenproject.org,
	linux-edac@vger.kernel.org
Subject: Re: [PATCH 1/2] PCI: Replace pci_dev->is_busmaster with accessors
Message-ID: <alOkgrK7Fm6opB4r@wunner.de>
References: <20260711-pci-dev-flags-v1-0-2fcf2811138c@mailbox.org>
 <20260711-pci-dev-flags-v1-1-2fcf2811138c@mailbox.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260711-pci-dev-flags-v1-1-2fcf2811138c@mailbox.org>

On Sat, Jul 11, 2026 at 05:21:06PM +0200, Maurice Hieronymus wrote:
> `is_busmaster` is one bit of a ~60-bit C bitfield in `struct pci_dev`.
> Bits sharing a bitfield word must not be modified concurrently, but its
> writers take no common lock: `pci_set_master()` can run without the
> device lock (e.g. from runtime PM resume paths), `pci_disable_device()`
> clears the bit, and other bits in the same word are written from
> entirely different contexts, e.g. `broken_parity_status` from sysfs.
> Concurrent read-modify-write cycles of the shared word can then lose
> updates.
> 
> Move `is_busmaster` into a new `flags` bitmap modified with atomic
> bitops and accessed through generated accessor functions, following the
> example of commit a7cc262a1135 ("driver core: Replace dev->offline +
> ->offline_disabled with accessors"). More bitfield flags can follow the
> same pattern later.

We already have the priv_flags member in struct pci_dev,
please use that instead of adding another one for the same purpose.

Thanks,

Lukas
