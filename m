Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26A18305E3B;
	Tue, 30 Jun 2026 19:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782848775; cv=none; b=D6+dw3gU6ovoNgv/zBI53M4ZxaenvpX8ztf5t1EuaBpaFBRGnDsEfN6YxsMq/M6+PVhJm+ga2FegmwjjboqXcYEeScqSnjW5hpicMnPivlUTS90fqYWBEScPtJwyn1cI/ztPBkLvje5fdyeorJYne3Nnj9TjGEXInamjF298I2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782848775; c=relaxed/simple;
	bh=dPWWumFbEV5yA3udEfWNt+0vEpK1URSqyUAkaq+3HAQ=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:To:From:Subject:
	 References:In-Reply-To; b=gigUuV/0sPALrH+MEDQNuYYa0uOzIViwB+j4Y/OZ1W/H3lsgYS8FxCF8XC65CMMFo2puwSCiIcz+aaxWoG+jEO8x4BILQYoOnxKRQcTHGfQH+Jkbd9aHiAQ+TWWXY6OyOVMb3MOEudL7uXJgGHuiflEMDTQ/OJJC2785K4bvX98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FJ20vSwT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FJ20vSwT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2FB21F000E9;
	Tue, 30 Jun 2026 19:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782848773;
	bh=dPWWumFbEV5yA3udEfWNt+0vEpK1URSqyUAkaq+3HAQ=;
	h=Date:Cc:To:From:Subject:References:In-Reply-To;
	b=FJ20vSwTIuj+zL1oaENG1GDgHXhqE4i8U05sqKGaRqJnlSJN0cMjsLy58DXa+FN3z
	 HJ+Pk2EjfZIC8iaTF5EvE7RmD7yEyHuqqj+KMfFPzKwUbhVkA88OCueHpw2qbNq5dN
	 i7ww33FqK2t0wpv6jqmkhJRmHyW+nxUm+CDDLDh38TWjzVS+NJTSGhqU/TbADYqURG
	 nbW1MNRrilIrtR4RuSH72udhVzJiE0mLa+bBMmuf/CQJ/A/uqGAM9efRs6MJACp8pG
	 +S4ludzToioI7DR4eAJ4j1RdiaTu0xMW7etuiZRleIoBy3pF2jOIrpK9KyUF/xdpZI
	 /VpofDNkmsDPQ==
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 30 Jun 2026 21:46:07 +0200
Message-Id: <DJMN54ZANNUT.DYHPIRG0GGVU@kernel.org>
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
Subject: Re: [PATCH v2 1/7] ata: don't keep pci_device_id
References: <20260630-pci_id_fix-v2-0-b834a98c0af2@garyguo.net>
 <20260630-pci_id_fix-v2-1-b834a98c0af2@garyguo.net>
In-Reply-To: <20260630-pci_id_fix-v2-1-b834a98c0af2@garyguo.net>

On Tue Jun 30, 2026 at 1:09 PM CEST, Gary Guo wrote:
> pci_device_id is not guaranteed to live longer than probe due to presence
> of dynamic ID. All information apart from driver_data can be easily
> retrieved from pci_dev, so just store driver_data.
>
> Signed-off-by: Gary Guo <gary@garyguo.net>

Reviewed-by: Danilo Krummrich <dakr@kernel.org>
