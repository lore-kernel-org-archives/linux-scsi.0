Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794656269;
	b=oGdlW1hmVU94OrdRY3sj6lh27XQvH/xNWTLmDCUud3ghfu45jbKM5jhN9H6meoc9Fz8i
	 VA8qN1u/S5UgXAzMF7T6FEMBH8kG1QBabtuXoAWITRCWlKx/n4u8gp2eBEvFQNVSkexLO
	 VgEpWvuvVqhmJL0gibx0d4/ovlzh9rn/fWHQlruhiQjJyaZVg/uYADJ5m55d8xP+Klzxn
	 IIbdrihCBUNlzJA1Gu7ptLWUsTjuWlkqcoiVychg2q0WFIgI72vW8IikEknFxh1nQ5gmR
	 QiUlMj3NfAl+52SZMqaUfgBTmRd3Hdny0q/bSGIxzWOLQ/wrNJ4jCq0NKju5dTxSvVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794656269;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=ujAYX702mc5Sy0ms/mnvtMDStt7ZaMRxVBxVaGnEd2E=;
	b=KxJKXf6AALE6B+BJN92IU/fHz1HvjHv5IthnP7E5XRaIiD4iiHlWCvIQyqS3I3t2sRyJ
	 Fy8/1pi51OWtU3jTtj6txNvXTjmniY1UqWCIBR9hvZA4pE58NQYWssEI1zBJr/NPE97UQ
	 z5chsYpO+20JvGmgwR0GsXANuAvbdhCQFm+lAOq74gwBmfpnr6UcFI00v887AvfVqtpYM
	 NrtpBrhKj5GMGxw96WvdNlOB4ygKBS+Unel0tYikL1h8AOAlTMOm+3D6kWf9yjeU1UDZP
	 di+70r7NuZMyhMvBQ4aCoAD18RRGozpbeeYr9+3M0wTI7eibJkc1zVSzzBbcc+E4G0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aGIR5RMy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B6C9606A329;
	Sat, 14 Nov 2026 11:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aGIR5RMy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B39E1F000C5;
	Sat, 14 Nov 2026 11:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794656269;
	bh=ujAYX702mc5Sy0ms/mnvtMDStt7ZaMRxVBxVaGnEd2E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aGIR5RMyAniR1rioEnJ7wtm6ltifCa1wJvlOysTnWPrqtPcoxI1w6HRvLT+JMvwXm
	 BITtkj1JGs0lpbwvw+km0zmFlMKCEXh+G6OHSm/En0yztUACFPrWB4b8iU4UeWRdBW
	 OVAA2UutC5e92DlloctcNIHsJYwokm0tFmf4i944ahqWDBCBv60QgiI5qnUaMKEAvQ
	 6cJPtGkNbfvToNbdhPoL2hvf3QPRtA9C/ldo0XoFINex1RyfDwvdXkYz+192DXCZIg
	 GxIGgQ2J4AZ2QjIqRjeQu3QBnPOr4jOKzElg6D3cGlLJDA0nFkS8+ucQAdypG8WEdy
	 52gKC4uBSK8Vw==
Date: Sat, 14 Nov 2026 12:37:44 +0100
From: Christian Brauner <brauner@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, 
	target-devel@vger.kernel.org, bpf@vger.kernel.org, Chuck Lever <cel@kernel.org>, 
	Jeff Layton <jlayton@kernel.org>, Anna Schumaker <anna@kernel.org>
Subject: Re: [PATCH 11/12] bpf: fs/xattr: take freeze protection in the xattr
 kfuncs
Message-ID: <20261114-raumfahrt-bioprodukte-ersatzlos-e6b9f19a6e1b@brauner>
References: <20261114-work-fs-frozen_writes-v1-0-f5ae61c898b1@kernel.org>
 <20261114-work-fs-frozen_writes-v1-11-f5ae61c898b1@kernel.org>
 <sashiko-outbox-214394@kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <sashiko-outbox-214394@kernel.org>

On Sat, Nov 14, 2026 at 11:11:36AM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found no new issues
> in this patch, but noticed 1 related pre-existing issue it does not
> introduce:
> - [High] bpf: deadlock in bpf_set_dentry_xattr() via
>   bpf_lsm_inode_need_killpriv() [1]
> --
> 
> commit 486e046b7935f74b8ef238345d31e9322cf39132
> Author: Christian Brauner <brauner@kernel.org>
> 
> bpf: fs/xattr: take freeze protection in the xattr kfuncs
> 
> This commit takes superblock freeze protection via
> sb_start_write_trylock() in bpf_set_dentry_xattr() and
> bpf_remove_dentry_xattr() so that BPF LSM programs cannot modify a frozen
> filesystem.
> 
> > diff --git a/fs/bpf_fs_kfuncs.c b/fs/bpf_fs_kfuncs.c
> > index 35ccd98a4de64..7f61e2efa08ba 100644
> > --- a/fs/bpf_fs_kfuncs.c
> > +++ b/fs/bpf_fs_kfuncs.c
> > @@ -295,9 +295,13 @@ __bpf_kfunc int bpf_set_dentry_xattr(struct dentry *dentry, const char *name__st
> >  	if (!inode)
> >  		return -EINVAL;
> >  
> > +	/* The hook may hold locks or freeze protection already. */
> > +	if (!sb_start_write_trylock(inode->i_sb))
> > +		return -EBUSY;
> >  	inode_lock(inode);
> >  	ret = bpf_set_dentry_xattr_locked(dentry, name__str, value_p, flags);
> >  	inode_unlock(inode);
> > +	sb_end_write(inode->i_sb);
> >  	return ret;
> >  }
> 
> [Severity: High]
> This problem wasn't introduced by this patch, but can calling
> bpf_set_dentry_xattr() or bpf_remove_dentry_xattr() from
> bpf_lsm_inode_need_killpriv() deadlock on inode_lock(inode) [1]?

Yes, I've been pointing that out quite a few times already.
This needs bpf infrastructure changes to be able to automatically track
the locking context a function can be called from (or something
similar).
