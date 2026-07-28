Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5BED377555;
	Tue, 28 Jul 2026 16:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785255878; cv=none; b=ILL+O56L8ai0ClpheL2po3YfYdSSeZb7kt8i2aX04UDjqRif1BzcOrA5x6CQ9c5BLcXR3KDuf4IDZdCnTKw4ijDnS1Lc1UjS3lCM8QesfKlfODSdw46uCIOtaS/vgityyreRVqfSydFfBCv0KK2oZm9rAr6GVyh7BXMwLnQHMxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785255878; c=relaxed/simple;
	bh=vWMKSzzpBTfatsYmHFgZj4EoC9MVBYwvfVkGM/cJjIo=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=Dq9YqDhWBHw3zpiHujSZQPw4DzXPOhbFsP0dVsmuvGi60syO761ruBYLs+/bCnRh7cJbjV3IoPFHBtFcXDn1cbSKPZl6fUFGnJCUg+k+tDnGH5njklb+sOCimU4PYWGfR05kdSWEgyrVoqtXUHHeisSq6U6FevJpYEnq+u8s7xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZDl/Eg/5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZDl/Eg/5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E87A1F000E9;
	Tue, 28 Jul 2026 16:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785255874;
	bh=3fXCTqKDFPeeZSKzhi12ENj/QYFjEH9zdFLqJrbhbl0=;
	h=Date:From:To:Cc:Subject:In-Reply-To;
	b=ZDl/Eg/5GYecAKoOepubuSjKK4tQcE2cGvzc6/PoNqMpaF64vYbLgx0hO6rO7EpAO
	 CR1aeoc0PB9OiKpERm5of50mGf1K7fQRIrPM9+T2vqShuHZR3UKwpz9T6+KFtMivrE
	 ZmPFWDDEKKF6AcVc+7DYIvAVXdKvJMqtCbW7W1dcBP5gvHAQ03jgr9GNVDKqUfjX4z
	 CJHbEk3YrTKyBtHGzK5MzBc6M9WzEGs4DNRcZZsXFlKK2MH26/KoDMbrwOLia7ka3a
	 R8zoj080ZIGAm5/xkJel9vNoQ4KasX5uHhXTPskf4j9HDYePFt6Qn8ATd20RJ9BJXs
	 Dnw/YrDPq4taw==
Date: Tue, 28 Jul 2026 11:24:32 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: Gary Guo <gary@garyguo.net>, David Airlie <airlied@redhat.com>,
	Vaibhav Gupta <vaibhavgupta40@gmail.com>,
	Jens Taprogge <jens.taprogge@taprogge.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	GOTO Masanori <gotom@debian.or.jp>,
	YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
	Zhenzhong Duan <zhenzhong.duan@gmail.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	linux-pci@vger.kernel.org, driver-core@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	industrypack-devel@lists.sourceforge.net, netdev@vger.kernel.org,
	dri-devel@lists.freedesktop.org
Subject: Re: [PATCH v4 7/9] PCI: Make pci_match_one_device() match on ID
 instead of device
Message-ID: <20260728162432.GA1322140@bhelgaas>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DK7N9IZPWPIT.2AKSZR5CU1H9L@garyguo.net>

[cc->to: Dave, Vaibhav, Jens, Greg, GOTO, YOKOTA: possible acks?
series: https://lore.kernel.org/all/20260723-pci_id_fix-v4-0-3580726844e1@garyguo.net]

On Sat, Jul 25, 2026 at 01:17:50PM +0100, Gary Guo wrote:
> On Fri Jul 24, 2026 at 11:29 PM BST, Bjorn Helgaas wrote:
> > On Thu, Jul 23, 2026 at 11:00:46PM +0100, Gary Guo wrote:
> >> PCI dynamic ID needs to match IDs against a new ID to see if it already
> >> exists. Existing APIs can only match IDs against devices, causing the
> >> dynamic ID insertion code to create a temporary device only for matching
> >> purpose. Rename pci_match_one_device() to pci_match_one_id() so it can be
> >> used for this purpose instead; add a pci_id_from_device() helper to make it
> >> easy to convert users.
> >
> > s/causing the ... code to create/so the ... code creates/
> > s/purpose/purposes/
> >
> >> Similarly, convert pci_match_id() to do_pci_match_id(). But keep the
> >> existing API because there are many users.
> >> 
> >> Reviewed-by: Danilo Krummrich <dakr@kernel.org>
> >> Signed-off-by: Gary Guo <gary@garyguo.net>
> >
> > Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>
> > Acked-by: Bjorn Helgaas <bhelgaas@google.com>
> >
> > What's the merge strategy?  If these all need to be merged
> > together, feel free to include the PCI patches whereever you merge
> > the series.
> 
> I think the series should be merged together, as I consider the
> driver changes included in this series being "fixing the users".
> 
> The series should probably be taken via the PCI tree. I suppose one
> can also argue that the lifetime issue with device IDs isn't unique
> to PCI bus so this can also be considered driver-core material, but
> given that Greg has already taken the USB fixes via the USB tree the
> only unfixed bus left is PCI.
> 
> So unless Danilo thinks otherwise I'd suggest the series be taken as
> a whole via PCI.

I'm happy to take via PCI.  It would be great to have acks/reviewed-by
from the non-PCI maintainers:

  David Airlie <airlied@redhat.com> (agp)

  Vaibhav Gupta <vaibhavgupta40@gmail.com> (tpci200)
  Jens Taprogge <jens.taprogge@taprogge.org> (tpci200)
  Greg Kroah-Hartman <gregkh@linuxfoundation.org> (tpci200)

  GOTO Masanori <gotom@debian.or.jp> (nsp32)
  YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp> (nsp32)
