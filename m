Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3B4139F191
	for <linux-scsi@vger.kernel.org>; Sat, 17 Oct 2026 23:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792281523; cv=none; b=dqesvtK7fN7HvG+uLGQsSmvR8S8Emz+InpKVvHE5jvSyWtpyMBE9O+qObcImIViiB2dwWfNdu8Y/xdZkdrrmQaMsosAtPo10U7OaDno+nB1ug+f4Dxu6iuJaYkx/tfpLremorrBOZstKWlrsZLfzK0cxxxFcSDXP/IgWd6Soje4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792281523; c=relaxed/simple;
	bh=E3tSXS0C7KVe3XQAcpTi2p7j/bSmA6jT2Z+8anVh+Ls=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HnUXVk/oUOfA294OnljkqcUPE565Ffl9ROVVTLWTv/GjNXsJ3sgKcaeBFQcnyR8uFCz/t4Uzz+/uZyGy9dIQvDOuhC97OFofj3bDhKb0HOGI1KU16ig3j6mKOjCYYxNx+AnWKfwMcGHqrAXy+OHP7EbgkxiqmJYRqZUTnBco9Bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l2awgXYk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l2awgXYk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB13D1F000C4;
	Sat, 17 Oct 2026 23:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792281522;
	bh=GtfjyhO1SKAJp2NNad4EjEIbvV7rjeN1n5B07fdw5HY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=l2awgXYknIo9EtE3b2XXxa9uM6kD8jM4lp/TNytA/0PkaoBV6HiagHZksuVxScm3t
	 AVibEI1HJsOT9buGNl165Ita7vsqiTfXNmA+K2ybun7gLtgEMz+9n56V6zmB6/WwWh
	 6z5WVUCogRvVLCXFZDZEBG4mBJjihTPQV/ZRoL+FG2T47Xn+0uQS7koC3SZsYEX8a2
	 umHZBTzqIrvdgBORPjprxoGkzKmuoNCXy1c/vE7cqpJHpFf+OASsjCx1VpBX1NTyYA
	 w7/LNQRUe/yZbz8u15hzffraJc0QjO9gyowPRIbOfPO1x1uFFBLvMF62uRqVvQ6OrU
	 JAOxz+33wSAaw==
Date: Sat, 17 Oct 2026 16:58:38 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, Karan Tilak Kumar <kartilak@cisco.com>,
	Satish Kharat <satishkh@cisco.com>,
	Sesidhar Baddela <sebaddel@cisco.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Subject: Re: [PATCH v4 26/54] scsi: fnic: Enable lock context analysis
Message-ID: <20261017235838.GA413570@ax162>
References: <cover.1790360262.git.bvanassche@acm.org>
 <e8ac2000b7ed23cec78f5be360a21d741f50a73e.1790360262.git.bvanassche@acm.org>
 <20261016023120.GA2863622@ax162>
 <9c375265-e198-42e1-97f5-fdfb08563d41@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9c375265-e198-42e1-97f5-fdfb08563d41@acm.org>

On Thu, Oct 15, 2026 at 08:38:53PM -0700, Bart Van Assche wrote:
> On 10/15/26 7:31 PM, Nathan Chancellor wrote:
> > Hi Bart,
> > 
> > On Fri, Sep 25, 2026 at 11:26:04AM -0700, Bart Van Assche wrote:
> > > Document locking requirements with __must_hold(). Suppress complaints
> > > about conditional locking in fnic_device_reset() with __acquire() and
> > > __release().
> > > 
> > > Cc: Karan Tilak Kumar <kartilak@cisco.com>
> > > Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> > 
> > I am seeing the following warnings/errors with LLVM 23.1.3 after this
> > change in -next as commit 70d2304ae575 ("scsi: fnic: Enable lock context
> > analysis"):
> > 
> >    $ make -skj"$(nproc)" ARCH=x86_64 LLVM=1 mrproper allmodconfig drivers/scsi/fnic/
> >    drivers/scsi/fnic/fnic_nvme.c:1332:2: error: releasing spinlock 'iport->fnic->fnic_lock' that was not held [-Werror,-Wthread-safety-analysis]
> >     1332 |         spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
> >          |         ^
> 
> I can't reproduce this with LLVM built from git HEAD (commit
> d7ae8658cb98b2ef2c7e6ebf21912f31d2c1feeb). Could the above indicate a
> bug in LLVM 23.1.3?

I can reproduce it with clang @ 1ae71725e3edb2bb5c5bed7f2cff9d2f22e10636
so it doesn't seem like something specific to LLVM 23. Is it
configuration related?

-- 
Cheers,
Nathan
