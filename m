Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB5A240A945;
	Fri, 11 Sep 2026 20:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789158534; cv=none; b=hh4zWtpDkEPweGJvYOy8k0aBMTZCd6dnwDwHMxA4y00aI8JhXaKVV9aEm+TANqfszzHR73VZ8fPlFQu1+1lZhCTV0M35hxy4LhPQbBLox6Q2Se8YZ6Ew0h2scVc/TsZdMMJkMnv2dRfjjjzD/Iys3Ly15RpNbAM2N5YWYSZcAAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789158534; c=relaxed/simple;
	bh=posZRNGtXy2frZiYX5qhxcx6BncEzD+P8N1aN2Ie5aM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f5bzi9nOMHsE7jPLuWLkKO8MGrMwRDTkx2kKyXL2a40LOrB3C2J+K4xY7MkEnrF4lRQ6ttLqd8pKPxdddV/qMFKYpTsJQbQWCRely/ym6IdssgrZ6mo9aBCHQ/e9aXHyI2+Rp0xxOhQTiBADLU5wPlKMuTNasjuRIdJlFAxG/eE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AVXbQPm7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AVXbQPm7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FB631F000FF;
	Fri, 11 Sep 2026 20:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789158532;
	bh=+5mzSpgILzHqr06GJbUTwa7c20pDz/QnXUmvQGKoMkU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AVXbQPm7L0+754CrGe0f211fQ6sydBek9ZkqMY9Ci1uoXaN6Rz7cKivlJ13lO6Ee2
	 qd/MZRW7s0ESXHDxjw1N4mJTbQm/jDNkTno7QB21Qt6GYOwBer80RKRWxPPESRswKL
	 JQ6KQkax6pA78HIpsw/wovO+XuGJrtg+iToQLhxQ=
Date: Fri, 11 Sep 2026 22:27:02 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: jaemyung.lee@samsung.com
Cc: Andreas Hindborg <a.hindborg@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>,
	Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Tamir Duberstein <tamird@kernel.org>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Onur =?iso-8859-1?Q?=D6zkan?= <work@onurozkan.dev>,
	linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org,
	linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH RFC] drivers/rufs: add Rust UFS host controller driver
Message-ID: <2026091124-treason-trickily-bc52@gregkh>
References: <20260912-rufs-private-v1-1-716db733e655@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260912-rufs-private-v1-1-716db733e655@samsung.com>

On Sat, Sep 12, 2026 at 12:52:55AM +0900, Jaemyung Lee via B4 Relay wrote:
> Comments on the decision to bypass the SCSI midlayer, the blk-mq model used
> in its place, and the proposed prerequisite API boundaries would be
> especially welcome.

Many many years ago, the USB subsystem tried to bypass the SCSI midlayer
for its storage driver, and while it was a "quick solution" at the time,
in the end, it didn't work out and we dropped the driver as it just made
no sense to keep duplicating all of the logic all the time.

So I wouldn't recommend it, as long as UFS builds on top of the SCSI
commands and the like, you should not attempt to duplicate it in a
separate driver, no matter how much "simpler" it initially seems to be.

But really:

>  30 files changed, 10005 insertions(+)

30 files and 10000 lines doesn't seem that simple :)

thanks,

greg k-h
