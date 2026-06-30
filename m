Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 190883C4154;
	Tue, 30 Jun 2026 19:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782848858; cv=none; b=Rb6fTfUd0Q4j3T6pFus3+8arwLceMBwsWfnyKgKRQtrJJmb7TaPKivPKVwZWMkE3ZEACNihtjCmmSNW+2sF05Z4RsdfRtJaV9lxqopIoBaMCOLQfW2PFbWovkO2AlcbKn8/nrXrtTHhHOFvb2oXSmAU+3MGcuRdQMmbSHil3bGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782848858; c=relaxed/simple;
	bh=Ghvoyx/ghMo5weDZ/lF347xW9I9fRNVaRjlvBCBRFBc=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:Cc:To:From:
	 References:In-Reply-To; b=F5Pp9dQU4z/FsuhoPBuLb3aT5lTK6Hst3Fh+d7imRxsns3DBPMR9ns8vfGExZ0nxax4M2H8bbmA+BLetwbHAmilOcTqHHzVdCy43oGSgXii7JuVrXFiztULSWFGtptFP5ShMmK/LCDOz5gSvHiFZCZtQCabZnSi/Cy5L3bAnNI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oYNu/9C6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oYNu/9C6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA62E1F000E9;
	Tue, 30 Jun 2026 19:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782848856;
	bh=Ghvoyx/ghMo5weDZ/lF347xW9I9fRNVaRjlvBCBRFBc=;
	h=Date:Subject:Cc:To:From:References:In-Reply-To;
	b=oYNu/9C6YgT1wSjvtnQ/B08uyOwKYo3CE/N1BKh4qwvcudhJOssK482qYNY0oSU68
	 fn2hIU3Mm6BvlFqKbWskQVB06WfOMlaQbpxCYsUzJy8hvn6i4k/ttNXhBMq7yQr08B
	 Fjltzl7xcAFhN7+0cK7H/zl+JD2sSxjATLoBgUO06BomieUrcnhs6p5Gk9wekrOBCG
	 PdTdrFOrM9lY7PpdK8awWxXfa+gYEp7IfutcTSWN1w8oVSsxVbYHGgGcN8Purl/9CS
	 SvqMi0bWZWfIvfB2uQeTea5Ico45/7agV2pjTQuhzpje4aV5/gtGl+IRHT2sN1rNvC
	 s6AsTbGxQisOA==
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 30 Jun 2026 21:47:30 +0200
Message-Id: <DJMN66ZPO2D8.22NZEBHTQH9QW@kernel.org>
Subject: Re: [PATCH v2 3/7] ipack: tpci200: don't keep pci_device_id
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
 <20260630-pci_id_fix-v2-3-b834a98c0af2@garyguo.net>
In-Reply-To: <20260630-pci_id_fix-v2-3-b834a98c0af2@garyguo.net>

On Tue Jun 30, 2026 at 1:09 PM CEST, Gary Guo wrote:
> pci_device_id is not guaranteed to live longer than probe due to presence
> of dynamic ID. This stored ID is unused so remove it.
>
> Signed-off-by: Gary Guo <gary@garyguo.net>

Reviewed-by: Danilo Krummrich <dakr@kernel.org>
