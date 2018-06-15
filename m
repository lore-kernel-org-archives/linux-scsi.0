From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH] sg, bsg: mitigate read/write abuse, block uaccess in
 release
Date: Fri, 15 Jun 2018 17:49:30 +0100
Message-ID: <20180615164930.GE30522@ZenIV.linux.org.uk>
References: <20180615152335.208202-1-jannh@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180615152335.208202-1-jannh@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jann Horn <jannh@google.com>
Cc: Jens Axboe <axboe@kernel.dk>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Doug Gilbert <dgilbert@interlog.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, security@kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Jun 15, 2018 at 05:23:35PM +0200, Jann Horn wrote:
> As Al Viro noted in commit 128394eff343 ("sg_write()/bsg_write() is not fit
> to be called under KERNEL_DS"), sg and bsg improperly access userspace
> memory outside the provided buffer, permitting kernel memory corruption via
> splice().
> But they don't just do it on ->write(), also on ->read() and (in the case
> of bsg) even on ->release().
> 
> As a band-aid, make sure that the ->read() and ->write() handlers can not
> be called in weird contexts (kernel context or credentials different from
> file opener), like for ib_safe_file_access().
> Also, completely prevent user memory accesses from ->release().

Band-aid it is, and a bloody awful one, at that.  What the hell is going on
in bsg_put_device() and can it _ever_ hit that call chain?  I.e.
	bsg_release()
		bsg_put_device()
			blk_complete_sgv4_hdr_rq()
				->complete_rq()
					copy_to_user()
If it can, the whole thing is FUBAR by design - ->release() may bloody well
be called in a context that has no userspace at all.

This is completely insane; what's going on there?
