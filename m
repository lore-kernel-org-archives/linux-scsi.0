Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFAE83DE436;
	Tue, 30 Jun 2026 19:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782848894; cv=none; b=lukTtDB2eCzqB5212lBbAh4Y105FSZVmZ1Ql1oqNDLecavxV7vB3WxLKU3GNkwdB9NWgrywJ4KlOlFVbVuVa5DEFaBifEe01oiEKiGiG7Q4KNvRw8DbSN2oLgjrsxk+YYNROsUhkcgRNiuouZphp6KANuDnDbd+stCa3etWq1iQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782848894; c=relaxed/simple;
	bh=Ghvoyx/ghMo5weDZ/lF347xW9I9fRNVaRjlvBCBRFBc=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:Cc:To:From:
	 References:In-Reply-To; b=P+UVXxoqAxVbVREBFZIT0eAgdjKgh5qk1wyN3NHHLc2KjppFWUzqosENd8ERxwajpTLNxj8NWVb7q/XvQM+OwFG+Ob+K6MAZoY6eu0OtRnUK/6cWjVMSUGQ0CXqPpiZg51Tx9k36P2RJtouAdvMspsGG0xxZd4uO63f8SSddL0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kRfBC8uR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kRfBC8uR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74E2C1F000E9;
	Tue, 30 Jun 2026 19:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782848893;
	bh=Ghvoyx/ghMo5weDZ/lF347xW9I9fRNVaRjlvBCBRFBc=;
	h=Date:Subject:Cc:To:From:References:In-Reply-To;
	b=kRfBC8uR13RmSnW5sNegsjc/8sib7WHGv7ufpQ882VZV79pkY3M8z2BrEb3tbP9LP
	 nzDMaQaPPCU88ZQtFFMWdlRXIFvFmys/zniHghssinyj41e9teBaCdWa6qGDzjZl27
	 3MqQsAgupz3N0BlxMh4QuzGo0Br2VOl+lMNYmNTPCKRN5nv1vYVblldLmOcGouZOTb
	 AGT7WuI1wmxuDk0I3f5ooNCBwFByfjscRPFZ/c4/AJ5AJmRO3AHkYNjsJGDnwf2l98
	 Hvmxbt6ZNYTgXFbFbCR2Cn5dII7xaLeVtP1YmFDPQOMzqoPkqZJ1KPOWySyXNOeIp4
	 FZzVsLDtW7E3Q==
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 30 Jun 2026 21:48:07 +0200
Message-Id: <DJMN6NWGTJSM.30O8ZG8LPF19I@kernel.org>
Subject: Re: [PATCH v2 4/7] mlxsw: don't keep pci_device_id
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
 <20260630-pci_id_fix-v2-4-b834a98c0af2@garyguo.net>
In-Reply-To: <20260630-pci_id_fix-v2-4-b834a98c0af2@garyguo.net>

On Tue Jun 30, 2026 at 1:09 PM CEST, Gary Guo wrote:
> pci_device_id is not guaranteed to live longer than probe due to presence
> of dynamic ID. This stored ID is unused so remove it.
>
> Signed-off-by: Gary Guo <gary@garyguo.net>

Reviewed-by: Danilo Krummrich <dakr@kernel.org>
