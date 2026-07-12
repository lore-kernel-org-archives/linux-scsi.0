Received: from mailout2.hostsharing.net (mailout2.hostsharing.net [83.223.78.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7136B2765E2;
	Sun, 12 Jul 2026 14:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.223.78.233
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783868135; cv=none; b=icacOHf2BiISObACpuC2gNf+XOyeAXM5BEnUqGPjL5XX/c7dzRowpDdk5VbtYXy+5SfL5pqpLtvdAcoMjUQV+kW/wPntCVXLx4htwK+4zDtSmNW+l4dBHWdWrXWxId9ZNJiCHc7DBFEs7Stp1kERwtH60wTw9A3Y7JzceFoNg+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783868135; c=relaxed/simple;
	bh=L4a64Aplo3e+24CSASMZO4O607mX9iJGrnuUkdNt5Xg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WLYK2zPWiPWGleC0ZICYUVy5Kn3Sxehg18uI3g5PWPsrjr1pw5cuuk4xK+WcaRKFqTBnVW9ygqoB+0tNQ1y8jYoeMxRxEqnit+MdiCDP7T5qv2kenq6QlxCyiqIc1H97eC1NvsW9IQfVhQDrIt3mPIm5ZA7ZNZBrD8jMj+98oH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de; spf=pass smtp.mailfrom=wunner.de; arc=none smtp.client-ip=83.223.78.233
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wunner.de
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature ECDSA (secp384r1) server-digest SHA384
	 client-signature ECDSA (secp384r1) client-digest SHA384)
	(Client CN "*.hostsharing.net", Issuer "GlobalSign GCC R6 AlphaSSL CA 2025" (verified OK))
	by mailout2.hostsharing.net (Postfix) with ESMTPS id 26AD310632;
	Sun, 12 Jul 2026 16:55:31 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
	id 032786022F08; Sun, 12 Jul 2026 16:55:30 +0200 (CEST)
Date: Sun, 12 Jul 2026 16:55:30 +0200
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
Subject: Re: [PATCH 2/2] PCI: Replace pci_dev->broken_parity_status with
 accessors
Message-ID: <alOq4rsjATipBjY9@wunner.de>
References: <20260711-pci-dev-flags-v1-0-2fcf2811138c@mailbox.org>
 <20260711-pci-dev-flags-v1-2-2fcf2811138c@mailbox.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260711-pci-dev-flags-v1-2-2fcf2811138c@mailbox.org>

On Sat, Jul 11, 2026 at 05:21:07PM +0200, Maurice Hieronymus wrote:
> `broken_parity_status` shares a C bitfield word in `struct pci_dev`
> with many other bits. `broken_parity_status_store()` writes it from
> sysfs at any time without taking any lock, so userspace can make it
> race with every other writer of the same word, e.g. `pci_set_master()`
> from a runtime PM resume path, and updates of neighboring bits can be
> lost.

For static bits in struct pci_dev, i.e. ones that are mostly read
and almost never written, and in particular ones that are only
written on device enumeration, it's perfectly fine and more convenient
to keep them as bitfields.  broken_parity_status seems to fit that bill.

For other bits which are modified more frequently, move them to the existing
priv_flags member if you believe they can be updated concurrently.
I'm not sure is_busmaster fits that bill, it isn't updated that often.

Quite honestly I'm wondering if there is anything to fix here.
Yes I get it, userspace may interfere with adjacent bits.
But broken_parity_status is only used for certain broken devices
on EDAC-capable platforms.  That's a fringe use case.
Is it really worth refactoring this?

Perhaps a better approach is to enclose dev_attr_broken_parity_status.attr
in "#ifdef CONFIG_EDAC" so that the attribute isn't shown unless it's used.

We shouldn't have used a sysfs attribute for this in the first place
but rather a quirk.  Unfortunately 6b09ff9d7879 does not betray for which
device this was needed, so it's difficult to convert it to a quirk now.

Bjorn introduced a pci_disable_parity() API in 2021 which is used in a
quirk for certain Mellanox products:

https://lore.kernel.org/all/20210330174318.1289680-1-helgaas@kernel.org/

Perhaps we can deprecate the sysfs attribute in favor of using quirks
for broken devices?

Thanks,

Lukas
