Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 759564A23;
	Tue, 17 Dec 2024 03:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734407827; cv=none; b=k3eqNZSjjc1Wp/dX6pb+imvZ1jYxCJXJoxPgO/cTu0jqNnbGkkjNT9z4xuBsqrYMHBuvV5i5BPBLFpMXXtuKPFVSDej9LoTkYwJWlZUP4JF/w/7nSXe5m2OSYQWqG+eeOhXVs3ww8FP+kr9sMtvl4upcDN661tW/j8bVo/9VNoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734407827; c=relaxed/simple;
	bh=F5w+/O3HjzzsxJsPly6kvqYp/dkWSaoDv8uwoLFudjo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DdBrC3wZ2coiH/SlsENI/od3MoYGkSWTQPkAcJ7l8xottI2QM9VFC5s0azFYI6MvyBiVye15UGgIyJLyveuWMnEDqSy9+vrnMOtl6BWIYxgVd7+w67xplxkZJ0XzxkAkeelzHwtDpbpnDX7gdBZSKOoSuJPTROE457BzRXSo02g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2F5C468BEB; Tue, 17 Dec 2024 04:56:58 +0100 (CET)
Date: Tue, 17 Dec 2024 04:56:58 +0100
From: Christoph Hellwig <hch@lst.de>
To: Kees Cook <kees@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Mike Christie <michael.christie@oracle.com>,
	Max Gurtovoy <mgurtovoy@nvidia.com>,
	Maurizio Lombardi <mlombard@redhat.com>,
	Dmitry Bogdanov <d.bogdanov@yadro.com>,
	Mingzhe Zou <mingzhe.zou@easystack.cn>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Simon Horman <horms@kernel.org>,
	"Dr. David Alan Gilbert" <linux@treblig.org>,
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org, netdev@vger.kernel.org,
	Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH] net: core: Convert inet_addr_is_any() to
 sockaddr_storage
Message-ID: <20241217035657.GA14719@lst.de>
References: <20241217012618.work.323-kees@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241217012618.work.323-kees@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Dec 16, 2024 at 05:26:19PM -0800, Kees Cook wrote:
> -extern bool inet_addr_is_any(struct sockaddr *addr);
> +extern bool inet_addr_is_any(struct sockaddr_storage *addr);

You might want to drop the pointless extern here.

Otherwise this looks great:

Reviewed-by: Christoph Hellwig <hch@lst.de>

