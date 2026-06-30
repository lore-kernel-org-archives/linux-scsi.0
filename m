Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4F0F3E023E;
	Tue, 30 Jun 2026 20:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782849873; cv=none; b=ouJm0k0gPnq9DMPXsB8rlDLuVciBSbPWGvc2XYViFE6dfrJf4pl3g7SWQj+GnNO+caWiZoaWo9i3LBFA5Cbnmd8PeIEuIgo9dHunCZJKlFzBG1LmcUSYJzQyaWRDpPzhv8ulPpbzMbyvYwVxRp0OsWVH4Qc9KLlQcLzjFhZFsB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782849873; c=relaxed/simple;
	bh=uuR9+/Mqv6VzcB/o9cpudXm09xHl6MhhQ5yODAPtFgg=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:Cc:To:From:
	 References:In-Reply-To; b=Eu1VXr6T1fN9Cqv9jHi8nZ2eXT2/BAvfb9OWi6gvy8de7ZNKWxpRC42LYsZSd+pPjMKzhZupn8G2koVeTwhU61plcuW5+8wEkK8PJSDjdU0rgfRpeuakYQslMzE2MdF3wI/w0bVqKVYLDVH9clATXLVp75kqqi/AxeOv8SxkrWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LvFMsP+9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LvFMsP+9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C694F1F000E9;
	Tue, 30 Jun 2026 20:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782849872;
	bh=uuR9+/Mqv6VzcB/o9cpudXm09xHl6MhhQ5yODAPtFgg=;
	h=Date:Subject:Cc:To:From:References:In-Reply-To;
	b=LvFMsP+9EeXKmXvFaZis9G2VLobXuWWGjGttLFjwM5011HTqQy38WMRVErXAfdps7
	 eGPsh7PUxStS3iKwj49mbjtCP+1R3NBTpwApg/bHfRo0U44e+/oeH1/Zf16AA8OKDz
	 f8cttZVjSDfUDywj2m19emj+BWBDVmhwO5zc88MFqBaL2VfjWunrfQjS/Hx+omw02L
	 1oMgJ4vCZ545huYVOLULqvx4FE7xBxKLlwW4KDlC5USJ42ORQA4rqamDCuH1aws4mw
	 kv+UjH5Qee0Ke6XdCUYR069j24FUc7BT3FZkPRcYgJkfa3j4oQBqwcgTf6izfltotW
	 sv1vk5zFmYCKQ==
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 30 Jun 2026 22:04:26 +0200
Message-Id: <DJMNJ5OPEMT0.1H4NP8NJ7JETR@kernel.org>
Subject: Re: [PATCH v2 5/7] pci: make pci_match_one_device match on ID
 instead of device
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
 <20260630-pci_id_fix-v2-5-b834a98c0af2@garyguo.net>
In-Reply-To: <20260630-pci_id_fix-v2-5-b834a98c0af2@garyguo.net>

On Tue Jun 30, 2026 at 1:09 PM CEST, Gary Guo wrote:
> There is a need to match just IDs instead of against devices. Thus rename
> this function to pci_match_one_id, and add a pci_id_from_device helper to
> make it easy to convert users.
>
> Similar convert pci_match_id to do_pci_match_id, however the existing API
> is kept due to quite a few users.
>
> Signed-off-by: Gary Guo <gary@garyguo.net>

Reviewed-by: Danilo Krummrich <dakr@kernel.org>
