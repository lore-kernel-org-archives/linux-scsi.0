From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 0/3] block: add queue-private command filter,
 editable via sysfs
Date: Fri, 19 Oct 2012 05:07:09 -0400 (EDT)
Message-ID: <1954562860.13360801.1350637629926.JavaMail.root@redhat.com>
References: <20121019002250.GB13370@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20121019002250.GB13370@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <axboe@kernel.dk>, Ric Wheeler <rwheeler@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> > In one use case, the administrator then needs the ability to configure
> > devices easily, for example to be much more restrictive on non-MMC
> > devices.  It must be done with the same tools it uses for other
> > aspects of the policy---which will be a combination of DAC (Unix
> > permissions and ACLs) and sysfs.  Different SCSI standards may give different
> > meanings for the same byte value, but a simple bitmap is enough for this.
> > 
> > In the virtualization case, the problem is really that you want to
> > pass through everything or almost everything, while still running
> > as confined as possible (i.e. CAP_SYS_RAWIO is not a choice).  But
> > in this case a more complex filtering can be done just as easily in
> > userspace, in the virtual machine monitor.
> > 
> > One alternative is a ioctl to disable the filter altogether, to be
> > used together with SCM_RIGHTS file descriptor passing.  This works in
> > the virtualization case but not for policy decisions.  So this patch
> > series provides the sysfs knob.  It is a tweaked revert of commit
> > 018e044 (block: get rid of queue-private command filter, 2009-06-26).
> 
> If your use case at hand is mostly virtualization, I personally would
> prefer the latter solution instead of extending in-kernel SG_IO
> filter.  It could be that I'm just not aware but I don't think there
> have been too many complaints regarding other use cases.  This type
> of deep inspection and filtering has fairly strong tendency to be
> unpopular.  Userland configurable one is even scarier and I don't
> think too many would know and make use of it in the end.

Actually I plan to set up the filtering in udev, so that we need not
pass through many MMC commands (some of which have completely different
meanings) to SBC devices.  So it would really be useful.

Paolo
