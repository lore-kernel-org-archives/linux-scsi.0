Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC12C2853FD
	for <linux-scsi@vger.kernel.org>; Fri, 16 Oct 2026 02:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792117886; cv=none; b=TB6C+zdGc3U4cJ2fUh5S5qZRZn0+0z4DVj9Kq9mm5rQFEQf9CYKJgbgH1PLMikoT+k6ZfFM8+ov91mdN7kt++H7TYqUgD+hRIJwJYp1HqIqE0owRCCHanM6vNSt46t0/NJFIMT0Ly8Yms1QMMWe2Gv1Jb/mto+x2kjGlbiEH71A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792117886; c=relaxed/simple;
	bh=B5j6NQ9hn4zGkmtKcG4c27H1uppEslEaPjk3oGV7Ucs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SX9Lg4Utn32J/7Um8/k+giRJ5Xv3P5i68J7DAi7N9CUBn5ndTqzUd2/QzPd3Tdrgo9D+lfYeMfNRKHf6ZDwBZHk/Q21kbXdC6ogUZSHSYjzjAxmDRVVpi3Wj+DlPoVx8x0dPs3tg10ortCzgxSYq/Vt29x1Ub+ABA+DR8ga1wBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jT5NHw66; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jT5NHw66"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D6071F000C4;
	Fri, 16 Oct 2026 02:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792117885;
	bh=DTttSt+WzJYHxLuIlqejLbCdBJTrSh1d6Je+FopE4Q4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jT5NHw66DwIKq5rGyJCZ/3GK6d25e9RFLT12t2f8qjRbTPVLAYBHhAnCxhl2g20QK
	 ZTvvTC3zMaYHqakZYK3R+IjFOTElddxhNat7kDcRVZ0xDgjIYg7tMgSf1AGrTPZmdl
	 9lVWmxYzkWFB6xrUOE6S3OWdYgcPR+DbdxsY8pmWS1cuQk6WJGbxxpKr627KyWoyp6
	 e9VZFcCYuX0ohUKZKH0LLoYeULMb7LRFnzj1sOJH87it5qKhDWwcGdnVOgkbn+J1O4
	 cKfJA3RuZA5mOlq+TaBMP50atDRVzQTHjpRwdbVGXSaIVAzgNwTtu+HtOAiUJm3Fsk
	 +HsplPEyi8E4g==
Date: Thu, 15 Oct 2026 19:31:20 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, Karan Tilak Kumar <kartilak@cisco.com>,
	Satish Kharat <satishkh@cisco.com>,
	Sesidhar Baddela <sebaddel@cisco.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Subject: Re: [PATCH v4 26/54] scsi: fnic: Enable lock context analysis
Message-ID: <20261016023120.GA2863622@ax162>
References: <cover.1790360262.git.bvanassche@acm.org>
 <e8ac2000b7ed23cec78f5be360a21d741f50a73e.1790360262.git.bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e8ac2000b7ed23cec78f5be360a21d741f50a73e.1790360262.git.bvanassche@acm.org>

Hi Bart,

On Fri, Sep 25, 2026 at 11:26:04AM -0700, Bart Van Assche wrote:
> Document locking requirements with __must_hold(). Suppress complaints
> about conditional locking in fnic_device_reset() with __acquire() and
> __release().
> 
> Cc: Karan Tilak Kumar <kartilak@cisco.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

I am seeing the following warnings/errors with LLVM 23.1.3 after this
change in -next as commit 70d2304ae575 ("scsi: fnic: Enable lock context
analysis"):

  $ make -skj"$(nproc)" ARCH=x86_64 LLVM=1 mrproper allmodconfig drivers/scsi/fnic/
  drivers/scsi/fnic/fnic_nvme.c:1332:2: error: releasing spinlock 'iport->fnic->fnic_lock' that was not held [-Werror,-Wthread-safety-analysis]
   1332 |         spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
        |         ^
  drivers/scsi/fnic/fnic_nvme.c:1336:1: error: spinlock 'iport->fnic->fnic_lock' is not held on every path through here [-Werror,-Wthread-safety-analysis]
   1336 | }
        | ^
  drivers/scsi/fnic/fnic_nvme.c:1335:2: note: spinlock acquired here
   1335 |         spin_lock_irqsave(&fnic->fnic_lock, fnic->lock_flags);
        |         ^
  include/linux/spinlock.h:389:35: note: expanded from macro 'spin_lock_irqsave'
    389 |         __release(spinlock_check(lock)); __acquire(lock);       \
        |                                          ^
  include/linux/compiler-context-analysis.h:375:23: note: expanded from macro '__acquire'
    375 | #define __acquire(x)            __acquire_ctx_lock(x)
        |                                 ^
  drivers/scsi/fnic/fnic_nvme.c:1445:2: error: releasing spinlock 'iport->fnic->fnic_lock' that was not held [-Werror,-Wthread-safety-analysis]
   1445 |         spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
        |         ^
  drivers/scsi/fnic/fnic_nvme.c:1449:1: error: spinlock 'iport->fnic->fnic_lock' is not held on every path through here [-Werror,-Wthread-safety-analysis]
   1449 | }
        | ^
  drivers/scsi/fnic/fnic_nvme.c:1448:2: note: spinlock acquired here
   1448 |         spin_lock_irqsave(&fnic->fnic_lock, fnic->lock_flags);
        |         ^
  include/linux/spinlock.h:389:35: note: expanded from macro 'spin_lock_irqsave'
    389 |         __release(spinlock_check(lock)); __acquire(lock);       \
        |                                          ^
  include/linux/compiler-context-analysis.h:375:23: note: expanded from macro '__acquire'
    375 | #define __acquire(x)            __acquire_ctx_lock(x)
        |                                 ^
  drivers/scsi/fnic/fnic_nvme.c:2120:2: error: releasing spinlock 'iport->fnic->fnic_lock' that was not held [-Werror,-Wthread-safety-analysis]
   2120 |         spin_unlock_irqrestore(&fnic->fnic_lock, flags);
        |         ^
  drivers/scsi/fnic/fnic_nvme.c:2178:1: error: spinlock 'iport->fnic->fnic_lock' is not held on every path through here [-Werror,-Wthread-safety-analysis]
   2178 | }
        | ^
  drivers/scsi/fnic/fnic_nvme.c:2144:2: note: spinlock acquired here
   2144 |         spin_lock_irqsave(&fnic->fnic_lock, flags);
        |         ^
  include/linux/spinlock.h:389:35: note: expanded from macro 'spin_lock_irqsave'
    389 |         __release(spinlock_check(lock)); __acquire(lock);       \
        |                                          ^
  include/linux/compiler-context-analysis.h:375:23: note: expanded from macro '__acquire'
    375 | #define __acquire(x)            __acquire_ctx_lock(x)
        |                                 ^
  drivers/scsi/fnic/fnic_nvme.c:2199:2: error: releasing spinlock 'fnic->fnic_lock' that was not held [-Werror,-Wthread-safety-analysis]
   2199 |         spin_unlock_irqrestore(&fnic->fnic_lock, flags);
        |         ^
  drivers/scsi/fnic/fnic_nvme.c:2215:1: error: spinlock 'fnic->fnic_lock' is still held at the end of function [-Werror,-Wthread-safety-analysis]
   2215 | }
        | ^
  drivers/scsi/fnic/fnic_nvme.c:2202:2: note: spinlock acquired here
   2202 |         spin_lock_irqsave(&fnic->fnic_lock, flags);
        |         ^
  include/linux/spinlock.h:389:35: note: expanded from macro 'spin_lock_irqsave'
    389 |         __release(spinlock_check(lock)); __acquire(lock);       \
        |                                          ^
  include/linux/compiler-context-analysis.h:375:23: note: expanded from macro '__acquire'
    375 | #define __acquire(x)            __acquire_ctx_lock(x)
        |                                 ^
  8 errors generated.

-- 
Cheers,
Nathan
