Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B5CE203D52;
	Tue, 17 Dec 2024 16:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734451234; cv=none; b=g6KRq0CXsE5ITAk6ii1cXts6SPrr8nCY3N9GMcFyr8V1LK8AClC0Uub6NaOlPal6J4BvBlSuCsBUrK0RdaKVLS0oa04gF+rO8fITI1Ze7Pdp/O8/IpGudGppF5VEgqskvo8LshjgH5562v4P2bRCwFzUo42Sd+4WXmoNKsBrZaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734451234; c=relaxed/simple;
	bh=EHGn27UeUnw//XSv6nd3Qhmq3MootZ87QKYdo80ZL/U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jcm2uZNMoYTX9zAVSjPn+61MwHWa+poe+dyaTIr0Xc5WZV/tV3KZzmDPz7Xw0ifRk2ScMtY1rsBfjA582+IqzgcXvpAKVRdoKdmQqU+kyicarIJFw8kk7NbxXUmfq9OEsPp5e3Y+S3DXuTBh6K2MAo8WyJ/KNPrD6UUdzeQbX70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QZVLa1H8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QZVLa1H8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51F67C4CED3;
	Tue, 17 Dec 2024 16:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734451233;
	bh=EHGn27UeUnw//XSv6nd3Qhmq3MootZ87QKYdo80ZL/U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QZVLa1H8hgXpNwONSs5txre9UH01OTtl9vxkb32Gtf9+pTFOe/Thhkdue2I9TPEub
	 jilLZsJi5raF72IUopGowSdSbVrvz2Dbp3v8NL4+JCCS4noxr6JPgyLrFyx/BlZJfZ
	 Ltd1wKtudLh7QQB89hHu3bnuSkOaDw6e/9TGTeFlHq4zu/K+uIKrq2JKxiFSQ+OcVw
	 3z577EwN3+VktbZE/wGkYulTQ6oEhICsf8WUgrd4aNXF1BKY5aiRtPSxMrbx4Wm3DP
	 tJ+ev2O7YGc5iOF0RHZOSfn2qqqa/Sh7F96ZIcEe4QVFBAN/yK0SEydYlsyYnFiA2s
	 iun5yXRIQWb/w==
Date: Tue, 17 Dec 2024 16:00:26 +0000
From: Simon Horman <horms@kernel.org>
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
	"Dr. David Alan Gilbert" <linux@treblig.org>,
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org, netdev@vger.kernel.org,
	Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH] net: core: Convert inet_addr_is_any() to sockaddr_storage
Message-ID: <20241217160026.GS780307@kernel.org>
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

On Mon, Dec 16, 2024 at 05:26:19PM -0800, Kees Cook wrote:
> All the callers of inet_addr_is_any() have a sockaddr_storage-backed
> sockaddr. Avoid casts and switch prototype to the actual object being
> used, as part of the work to move away from internal use of struct
> sockaddr.
> 
> Signed-off-by: Kees Cook <kees@kernel.org>

Reviewed-by: Simon Horman <horms@kernel.org>
