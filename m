Received: from mailout2.hostsharing.net (mailout2.hostsharing.net [83.223.78.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C63383B42D7;
	Wed, 15 Jul 2026 04:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.223.78.233
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784091292; cv=none; b=AWMebL7aCqbRs5yCgYkj9PTsvBtveynZqZvTO9xMHPGcRZW/jsXmcOf1DdM1E8kdT16XfPwnVxqiX14t40aTlzNQbIPeLgn7CiZlpLfSVB9ZZ1jDrF5BeMcYDsUw608yADzp53gUg7R8AZUFmmGeo6qVvdYpYpALo8HqN+DWdug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784091292; c=relaxed/simple;
	bh=YG/BH0rGq979Z5uTrx4zYXUgFUmbKsGaN6XPzFKM8Ms=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JNKgf46hCIAH5wLQe7HkBPRIGlx6C8qlz4iSivawmxwg8xPfVXLseOD9b/iUrSqzwpcp0FTQphTYCi96NMZ/6RExHE5qSO7lRyIoK1M84ZxTUUlzkwOc5GEI+jCh6r6acxWLwdBT1dhQdxFofPp0Es6RUjIEwpv/pXYM+81i+HM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de; spf=pass smtp.mailfrom=wunner.de; arc=none smtp.client-ip=83.223.78.233
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wunner.de
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature ECDSA (secp384r1) server-digest SHA384
	 client-signature ECDSA (secp384r1) client-digest SHA384)
	(Client CN "*.hostsharing.net", Issuer "GlobalSign GCC R6 AlphaSSL CA 2025" (verified OK))
	by mailout2.hostsharing.net (Postfix) with ESMTPS id B5F3510630;
	Wed, 15 Jul 2026 06:54:38 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
	id 960BB603411E; Wed, 15 Jul 2026 06:54:38 +0200 (CEST)
Date: Wed, 15 Jul 2026 06:54:38 +0200
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
Subject: Re: [PATCH v2] PCI: Move pci_dev->is_busmaster into priv_flags
Message-ID: <alcSjoypegNolW48@wunner.de>
References: <20260714-pci-dev-flags-v2-1-a1d7dc441cf3@mailbox.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260714-pci-dev-flags-v2-1-a1d7dc441cf3@mailbox.org>

On Tue, Jul 14, 2026 at 09:37:07PM +0200, Maurice Hieronymus wrote:
> +++ b/include/linux/pci.h
> @@ -1446,6 +1445,8 @@ void pci_disable_device(struct pci_dev *dev);
>  extern unsigned int pcibios_max_latency;
>  void pci_set_master(struct pci_dev *dev);
>  void pci_clear_master(struct pci_dev *dev);
> +bool pci_dev_is_busmaster(const struct pci_dev *pdev);
> +void pci_dev_assign_busmaster(struct pci_dev *pdev, bool busmaster);

pci_dev_assign_busmaster() should not have public visibility.
Drivers should really use pci_set_master() / pci_clear_master()
and nothing else.

It seems Xen is the only one in the tree which needs this:

> +++ b/drivers/xen/xen-pciback/pciback_ops.c
> @@ -125,14 +125,14 @@ void xen_pcibk_reset_device(struct pci_dev *dev)
>  		if (pci_is_enabled(dev))
>  			pci_disable_device(dev);
>  
> -		dev->is_busmaster = 0;
> +		pci_dev_assign_busmaster(dev, false);
>  	} else {
>  		pci_read_config_word(dev, PCI_COMMAND, &cmd);
>  		if (cmd & (PCI_COMMAND_INVALIDATE)) {
>  			cmd &= ~(PCI_COMMAND_INVALIDATE);
>  			pci_write_config_word(dev, PCI_COMMAND, cmd);
>  
> -			dev->is_busmaster = 0;
> +			pci_dev_assign_busmaster(dev, false);
>  		}
>  	}
>  }

Please change these direct assignments to pci_clear_master(),
preferably in a separate patch to ease bisecting if anything
breaks.

Then you don't need pci_dev_assign_busmaster() and can just inline
setting/clearing the bit in __pci_set_master() and pci_disable_device().

Thanks,

Lukas
