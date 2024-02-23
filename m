Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [80.241.56.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B3AF3FF1;
	Fri, 23 Feb 2024 16:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708706515; cv=none; b=BBH7EkhBsfw+kDhlIkPm4ZGQTMdOrEnueo+Xfts7DAOWyX6ZKL0A77ZXE/OR36IrJpuwqKXwcm9cl/w3aUj5rSvykjRbRMnXbU1b/ugvTs9JcCLrem11h3iqLdnr0ngYGugNVW+fItro22W4ClR4Syl6sNYhtorgnseStj1gxws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708706515; c=relaxed/simple;
	bh=iPePdpshC6aNZbH2wWpmV8JeUEGAIvwSRLY0Bq2AEX0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jk9R48zJP5kZb+euMJABfwLRPSpIjn+TGl+D7AY3BQ8wYm48CPAV1IMbw60jhrWfuxJPmKcpArMwiA1UwEVeRtv2RuEvPPlm2s0LRmOTA+XM4Q+gjvB3TpP5D2swc0TtQrZM3uMFH4KO1q6ZjSWGxulbwj2Kk4vcxNhhEjnQrM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pankajraghav.com; spf=pass smtp.mailfrom=pankajraghav.com; dkim=pass (2048-bit key) header.d=pankajraghav.com header.i=@pankajraghav.com header.b=e8+lqrCe; arc=none smtp.client-ip=80.241.56.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pankajraghav.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pankajraghav.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pankajraghav.com header.i=@pankajraghav.com header.b="e8+lqrCe"
Received: from smtp202.mailbox.org (smtp202.mailbox.org [IPv6:2001:67c:2050:b231:465::202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4ThG4Y4khgz9srX;
	Fri, 23 Feb 2024 17:41:49 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1708706509;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UZzVY1rE4nuBeeTGJE+eDzU+/KFUPmhj+EbPbIqSZ4c=;
	b=e8+lqrCeUGLoeWHdMU2NT7TaFTqF+HMvYcUIDjJsltURgi0xQ/bx7qGFNQsEJYhQHMZsNe
	nMoOe/X4Lct1Kp4ZiNdvtgX///gTTodyn0euqKyxAR7nCtXXLqUkxJ4S6LcCfYb5MPWsbE
	Rhgy7btRp3nuFVbDEv4hzdAXPkCO/cP1DErzN/0zPuDj1jQMe2i570+hF9/d34b6dBh1tH
	yNSN17DLBKPXBt9MtVGwcWkbRDh8qYbWXR5/lkabo3HBYOUrAbkaXGgi6calsgTdR9vUW1
	y4NXoSKSDxK0oZOw1bVwbG+TOCepPI0Xw5TwgT8KYbcGt0kuAYfnQojkef5EPg==
Date: Fri, 23 Feb 2024 17:41:46 +0100
From: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
To: Hannes Reinecke <hare@suse.de>
Cc: lsf-pc@lists.linuxfoundation.org, linux-mm@kvack.org, 
	linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, 
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, mcgrof@kernel.org, p.raghav@samsung.com
Subject: Re: [LSF/MM/BPF TOPIC] Large block for I/O
Message-ID: <43yvte5buxg4jv7nlguiz5eu5l26lkzz6cpa4snnvjqokbyg7i@42s52upzhrdi>
References: <7970ad75-ca6a-34b9-43ea-c6f67fe6eae6@iogearbox.net>
 <4343d07b-b1b2-d43b-c201-a48e89145e5c@iogearbox.net>
 <03ebbc5f-2ff5-4f3c-8c5b-544413c55257@suse.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <03ebbc5f-2ff5-4f3c-8c5b-544413c55257@suse.de>
X-Rspamd-Queue-Id: 4ThG4Y4khgz9srX

On Wed, Dec 20, 2023 at 04:03:43PM +0100, Hannes Reinecke wrote:
> Hi all,
> 
> I would like to discuss
> 
> Large blocks for I/O
> 
> Since the presentation last year there has been quite some developments
> and improvements in some areas, but at the same time a lack of progress
> in other areas.
> In this presentation/discussion I would like to highlight the current
> state of affairs, existing pain points, and future directions of
> development.
> It might be an idea to co-locate it with the MM folks as we do have
> quite some overlap with page-cache improvements and hugepage handling.

I am interested in attending this session. As we are getting closer to
having LBS in XFS[1], we could then have the LBS support for block
devices for free if we use the iomap to interact with the block cache 
(!CONFIG_BUFFER_HEAD).

So one of the focus points for this discussion could be on adding the LBS
support to the buffer_head path for block devices and blockers (if any).

Another important discussion point is testing. xfstests helped iron out
bugs in page cache and iomap while adding the LBS support for XFS. If we
add support to buffer_heads, then how are we going to stress test the changes?
I doubt just blktests would be enough to test the changes in page cache
and buffer_heads.

[1] https://lore.kernel.org/linux-xfs/20240213093713.1753368-1-kernel@pankajraghav.com/

--
Pankaj
