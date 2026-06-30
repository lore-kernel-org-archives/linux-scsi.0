Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C7BD3C4154;
	Tue, 30 Jun 2026 19:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782848815; cv=none; b=kpeOLDaYecyO3HTTJ29dYJ+w4RDOSVXa5Imzn4Zdhpwm2QFFMPPCMo9cmT+gNt2R7igcfkcFuw43N1pYJ/o57D7lORQPjSDpw/XusugeQqRyRCVCPceyIkFOk7KVAadyGU8Vfh1AkAuhBaQS7LbwMn9MDMDpHrzj4x2PXqIikDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782848815; c=relaxed/simple;
	bh=dPWWumFbEV5yA3udEfWNt+0vEpK1URSqyUAkaq+3HAQ=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:Cc:To:From:
	 References:In-Reply-To; b=Hw5uDpFXnZ2mW+q89P/IFrc0vuuEClL4RIH/lGxzXB1HNghKlvaZafKLj4kNxM21n9iag5P7PZ7fcqQTIZSMEEOl3ZK3ONDgxQrc70DfdF+j/eGo9ovXBigHTkdhdMR1NPvdPHayeq8wNWej6bbB1d3vWYIJsOdw2auWNt/mChk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IzAp5xBE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IzAp5xBE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A68A1F000E9;
	Tue, 30 Jun 2026 19:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782848814;
	bh=dPWWumFbEV5yA3udEfWNt+0vEpK1URSqyUAkaq+3HAQ=;
	h=Date:Subject:Cc:To:From:References:In-Reply-To;
	b=IzAp5xBEJGJQptQ5UMwMw4MhsshLrt31YLvU57xcLhOn39OcNMheAlXXFayLySHIj
	 cnclQ6JZ15+RRDC+StrWDioDaPn+4fp6ArrE8G0Z423E3XEXTREAiq2UvRB5vRk0Ov
	 /hv5yW/hjmcAou+oC2YsaraneRj8TL/lEr//ghoLNMNOlzSJZi9uRfv+CWiozavXJ4
	 SOcclaeWHBLmH5PK508WcV2Sx9mJhYch0ODD6QyGli/BLSNLQP+a81ZGsRqdAxlob4
	 ryfWFa6hFoSn1TJ+xwTuDeCLkqQ3ZFhNM2IOQNZmQNH4VLapU14vnXFmUjBdiBYnf/
	 JPAuYf7XkPQkg==
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 30 Jun 2026 21:46:47 +0200
Message-Id: <DJMN5NFA766Y.1LSK7LF1Q7SL0@kernel.org>
Subject: Re: [PATCH v2 2/7] nsp32: don't keep pci_device_id
Cc: "Bjorn Helgaas" <bhelgaas@google.com>, "Zhenzhong Duan"
 <zhenzhong.duan@gmail.com>, "Greg Kroah-Hartman"
 <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>,
 "Damien Le Moal" <dlemoal@kernel.org>, "Niklas Cassel" <cassel@kernel.org>,
 "GOTO Masanori" <gotom@debian.or.jp>, "YOKOTA Hiroshi"
 <yokota@netlab.is.tsukuba.ac.jp>, "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"
 <martin.petersen@oracle.com>, "Vaibhav Gupta" <vaibhavgupta40@gmail.com>,
 "Jens Taprogge" <jens.taprogge@taprogge.org>, "Ido Schimmel"
 <idosch@nvidia.com>, "Petr Machata" <petrm@nvidia.com>, "Andrew Lunn"
 <andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>, "Eric
 Dumazet" <edumazet@google.com>, "Jakub Kicinski" <kuba@kernel.org>, "Paolo
 Abeni" <pabeni@redhat.com>, <linux-pci@vger.kernel.org>,
 <driver-core@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
 <linux-ide@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
 <industrypack-devel@lists.sourceforge.net>, <netdev@vger.kernel.org>
To: "Gary Guo" <gary@garyguo.net>
From: "Danilo Krummrich" <dakr@kernel.org>
References: <20260630-pci_id_fix-v2-0-b834a98c0af2@garyguo.net>
 <20260630-pci_id_fix-v2-2-b834a98c0af2@garyguo.net>
In-Reply-To: <20260630-pci_id_fix-v2-2-b834a98c0af2@garyguo.net>

On Tue Jun 30, 2026 at 1:09 PM CEST, Gary Guo wrote:
> pci_device_id is not guaranteed to live longer than probe due to presence
> of dynamic ID. All information apart from driver_data can be easily
> retrieved from pci_dev, so just store driver_data.
>
> Signed-off-by: Gary Guo <gary@garyguo.net>

Reviewed-by: Danilo Krummrich <dakr@kernel.org>
