Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3883D3EFFDB;
	Tue, 30 Jun 2026 11:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782820752; cv=none; b=rXRhF/JcoLEWB9qj8IdQ+KnC3kDnh/fA2HcRZLp5IFfjWM88XTkaQtaAeS0uLUlcmbZuAe90SywX6mmVF59xLvB0+nwuSEQ8r79wF1etnZwL+gkuHxzCNhRp9+mcPNcKqek9JVa9Cm1VdG6r7Ec7WrTgUwHzrcQZN9+/wbDtGms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782820752; c=relaxed/simple;
	bh=15MeBpiR9COtkfQMfxHQfAshQ1Ip+uCvSynuoQEKCuo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nHvKJVxuRNTe5Rs/yXagsncWe5u4vRLjf646zrhkxq34fNQwiiF/ClqK1gPu2C6y6GQRchxhTFcWV/5yPWrrua16gueRiXmkPKRTevHYhG0w/P1Dj7dFPuOmIl114AtiOLDXa/34g2geAN+ARu3LrE7XODaLLhjAL/TA4Ks8xPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MP8grQaY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MP8grQaY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34E0C1F000E9;
	Tue, 30 Jun 2026 11:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782820750;
	bh=3uyRIdTmaGFcp2SYXLoMhSySxZ7Y9nec4cbKx7L5lv4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MP8grQaYRynuELr3FfvFLwc8BtxWzDOL64Zo43/DGHHstDZBFORFfm7l07qAXss3O
	 l0M4XqvVst1IQGjJy2sARExBd1mQNWfest91vqJY0MEprsSU8mEgE+e3UohN7ygDuX
	 vRG4Y0Tb1kxk4ec3lE0NCtYXDQbbzRKk1TpW45ZjdVfS3v2Sgk9o547XhKD6ZPwGV6
	 vAEXBFp0x3uDENjRGeNryUG76aSFeGJoOeLoDhu/RJbsYnGXYAWyv/gEjbExeBTAvB
	 4mLVURNiGinPbNHHEjD/awFLwehlaYz6oqfsHXnAmj1rYnc6XfEzJjsHwliMWkTvYz
	 u4ZEnwoviV2VA==
Date: Tue, 30 Jun 2026 13:59:02 +0200
From: Niklas Cassel <cassel@kernel.org>
To: Gary Guo <gary@garyguo.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
	Zhenzhong Duan <zhenzhong.duan@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	GOTO Masanori <gotom@debian.or.jp>,
	YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Vaibhav Gupta <vaibhavgupta40@gmail.com>,
	Jens Taprogge <jens.taprogge@taprogge.org>,
	Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	linux-pci@vger.kernel.org, driver-core@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	industrypack-devel@lists.sourceforge.net, netdev@vger.kernel.org
Subject: Re: [PATCH v2 1/7] ata: don't keep pci_device_id
Message-ID: <akOvhr-X1Wp9iNd8@ryzen>
References: <20260630-pci_id_fix-v2-0-b834a98c0af2@garyguo.net>
 <20260630-pci_id_fix-v2-1-b834a98c0af2@garyguo.net>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260630-pci_id_fix-v2-1-b834a98c0af2@garyguo.net>

Hello Gary,

On Tue, Jun 30, 2026 at 12:09:01PM +0100, Gary Guo wrote:
> pci_device_id is not guaranteed to live longer than probe due to presence
> of dynamic ID. All information apart from driver_data can be easily
> retrieved from pci_dev, so just store driver_data.
> 
> Signed-off-by: Gary Guo <gary@garyguo.net>

Please write a proper commit message.

The commit message should be detailed enough for someone to realize what
is going on without reading your cover-letter (as information in the cover
letter in not part of the accepted commit).

1) Explain how to reproduce.

2) Explain the problem.

3) Explain the consequences of the problem. UAF? Crash?

4) Explain how you fix it.


AFAICT, this is somehow related to pci_add_dynid(), which is called when
user-space is doing something like:

$ echo "vendor device" > /sys/bus/pci/drivers/your_driver/new_id


Kind regards,
Niklas
