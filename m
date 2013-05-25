From: Christoph Hellwig <hch@infradead.org>
Subject: Re: PING^7 (was Re: [PATCH v2 00/14] Corrections and customization
 of the SG_IO command whitelist (CVE-2012-4542))
Date: Sat, 25 May 2013 03:11:18 -0400
Message-ID: <20130525071118.GA11912@infradead.org>
References: <20130522221737.GA12339@mtj.dyndns.org>
 <519DC926.4000106@redhat.com>
 <20130523090222.GA26592@mtj.dyndns.org>
 <519DE5AD.7080303@redhat.com>
 <20130524014405.GB16882@mtj.dyndns.org>
 <519F12FF.6090809@redhat.com>
 <CAOS58YODjkSF=V7wADqbn_z8c6bmj=r03hWxEs5B1O+1cd0n6g@mail.gmail.com>
 <1369456502.5008.5.camel@dabdike>
 <20130525052744.GA25186@infradead.org>
 <51A062B5.8040601@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <51A062B5.8040601@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>, lkml <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, May 25, 2013 at 09:05:25AM +0200, Paolo Bonzini wrote:
> > you could send destructive commands to a partition.  The right fix
> > for that would be to not allow SG_IO on partitions at all, just
> > wondering if anything would be broken by this.
> 
> Linus wanted to keep that for CAP_SYS_RAWIO.  We found two uses of SG_IO
> on partitions: zfs-fuse used SYNCHRONIZE CACHE; some proprietary driver
> used TEST UNIT READY.
> 
> Really, the solution is to make the bitmaps configurable in userspace.
> It is no less secure than unpriv_sgio.  Then the kernel can be
> configured at build-time to have either an MMC bitmap and a basic
> whitelist of a dozen commands.  We can even avoid working around those
> few conflicting opcodes; if you're paranoid you can just configure your
> kernel right.

Keep it simple.  Allowing SG_IO for CAP_SYS_RAWIO probably is fine,
allowing it for permissions only clearly isn't. All the per-command
filetering is just complete bullshit and the kind of bloat that
eventually will make Linux unmaintainable.
