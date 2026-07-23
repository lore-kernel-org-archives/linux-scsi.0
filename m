Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 258DD3CCFDB;
	Thu, 23 Jul 2026 21:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784841719; cv=none; b=ldqKvme366uEnTFtvQ4VQGUknSVz1/2tEL35gBXs44/vqYcRwKm68hZ1G/YuzBk13303sQ203c9RjlJjEwmM+6wg8jKHLwaXiQw7ijm4D5x1eG4eIbjczelRLBuqZFET7qkzJEhShFwEdED4u5uJMCSwffrEWpWYsY7vUMt+KNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784841719; c=relaxed/simple;
	bh=iPUxfS0aQGDvHR9Z4FhFJ7N14NM+Gm78/UoWkSRYERo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DRbJiulWDwHNVWjX7eJYSx1sByVmPPcyNisdSZ64PVn8RDGHDYkSY4UTbyl94AGjMupr9hx7HIpD3Jwbosvszn5CxKfLYCLfOXZCTt0s2/SKv87VEdtTNMp9rks8HkHPnQiZK8zT2wisfQgTYjyqSGYkbqY5HJnI544Pzv25tGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Mi7eEBmg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Mi7eEBmg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13E731F000E9;
	Thu, 23 Jul 2026 21:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784841717;
	bh=8KC2DSNpAt9AdYOuMQy3pAgGL6W1aDXGthYyqLSpM5k=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Mi7eEBmgMeVYqqiVjdVsuP88GzcC3Y4dDWRr3EG1EW+Xm8uxB88jlDnBFLgWiloYA
	 EzZWLtaF7Oqp+/Dr6sWvc0zk0cNUyC74SbBUeUGcM/tofgQ3zhQRaV7M9Qnz/6nA2Z
	 nQont9J0yBdXBJ5PTLJqqIcnfWnUwhPSQAlQXSt43KpOhpDPAuUZBSETCyfmu4OwwI
	 0uUtoFYVLbX6rRwsPcnRagkVhTUNR6HZuRHIgFGSZ7iUBi1uQ1Cn5GkHLr3nNyGSRJ
	 vJhBvE03GRfto1K9b8QX9sdSRlQt9a93vj7sm8kwGcLt4oCU3spYGRXpjZtZ1eDdPz
	 jWpE/BGAm3QqQ==
Message-ID: <2220ce37-2fbf-4be8-9af0-b3673be90f04@kernel.org>
Date: Thu, 23 Jul 2026 23:21:50 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/9] pci: fix UAF and TOCTOU related to dynamic ID
To: Gary Guo <gary@garyguo.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
 Zhenzhong Duan <zhenzhong.duan@gmail.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Damien Le Moal
 <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>,
 GOTO Masanori <gotom@debian.or.jp>,
 YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Vaibhav Gupta <vaibhavgupta40@gmail.com>,
 Jens Taprogge <jens.taprogge@taprogge.org>, Ido Schimmel
 <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>,
 Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 David Airlie <airlied@redhat.com>, linux-pci@vger.kernel.org,
 driver-core@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
 industrypack-devel@lists.sourceforge.net, netdev@vger.kernel.org,
 dri-devel@lists.freedesktop.org, Sashiko <sashiko-bot@kernel.org>
References: <20260706-pci_id_fix-v3-0-2d48fc025acc@garyguo.net>
From: Danilo Krummrich <dakr@kernel.org>
Content-Language: en-US
In-Reply-To: <20260706-pci_id_fix-v3-0-2d48fc025acc@garyguo.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/6/26 4:11 PM, Gary Guo wrote:
> Gary Guo (9):
>       ata: don't store pci_device_id
>       nsp32: don't store pci_device_id
>       ipack: tpci200: don't store pci_device_id
>       mlxsw: don't store pci_device_id
>       agp/via: don't rely on address of pci_device_id
>       agp/amd-k7: don't rely on address of pci_device_id
>       pci: make pci_match_one_device match on ID instead of device
>       pci: fix dyn_id add TOCTOU
>       pci: fix UAF when probe runs concurrent to dyn ID removal
Reviewed-by: Danilo Krummrich <dakr@kernel.org>
