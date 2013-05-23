From: Tejun Heo <tj@kernel.org>
Subject: Re: PING^7 (was Re: [PATCH v2 00/14] Corrections and customization
 of the SG_IO command whitelist (CVE-2012-4542))
Date: Thu, 23 May 2013 09:54:31 +0900
Message-ID: <20130523005431.GA17291@mtj.dyndns.org>
References: <519C959A.3090100@redhat.com>
 <20130522100212.GE3466@mtj.dyndns.org>
 <519C9CBC.3050003@redhat.com>
 <20130522134134.GA15189@mtj.dyndns.org>
 <519CD234.40608@redhat.com>
 <20130522143019.GA18541@mtj.dyndns.org>
 <519CDDA4.2050100@redhat.com>
 <20130522193009.GA23845@mtj.dyndns.org>
 <519D360D.4050309@redhat.com>
 <20130522221737.GA12339@mtj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130522221737.GA12339@mtj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, May 23, 2013 at 07:17:37AM +0900, Tejun Heo wrote:
> > No, it doesn't.  You can use SCM_RIGHTS, and pass a file descriptor for
> > the device node to an unprivileged program.  You can choose the
> > users/groups that are allowed to access the device.  In either case, the
> > privileged action is limited in time or in scope.
> > 
> > The count-me-out knob affects all processes that use the device node,
> > and won't be cleaned up properly if you SIGKILL the (privileged)
> > process that sets it.  So if you can avoid it, you should.
> 
> Then let's make it fit the use case better.  I really can't see much
> point in crafting the cdb filter when you basically have to entrust
> the device to the user anyway.  Let's either trust the user with the

One more thing, is it really necessary to have finer granularity than
provided by file permissions?  What would be the use case?  Do you
expect to have multiple - two - differing levels of access with and
without SG_IO?  Note that, for the same user, it's pointless to give
out SG_IO access to processes while denying for other processes.  As
long as ptrace can be attached, hijacking such fd is easy.  Making it
per-device should be suitable enough, no?

-- 
tejun
