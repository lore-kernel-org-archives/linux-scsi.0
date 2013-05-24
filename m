From: Tejun Heo <tj@kernel.org>
Subject: Re: PING^7 (was Re: [PATCH v2 00/14] Corrections and customization
 of the SG_IO command whitelist (CVE-2012-4542))
Date: Sat, 25 May 2013 07:20:58 +0900
Message-ID: <20130524222058.GA32409@mtj.dyndns.org>
References: <20130522221737.GA12339@mtj.dyndns.org>
 <519DC926.4000106@redhat.com>
 <20130523090222.GA26592@mtj.dyndns.org>
 <519DE5AD.7080303@redhat.com>
 <20130524014405.GB16882@mtj.dyndns.org>
 <519F12FF.6090809@redhat.com>
 <CAOS58YODjkSF=V7wADqbn_z8c6bmj=r03hWxEs5B1O+1cd0n6g@mail.gmail.com>
 <519F2566.2000008@redhat.com>
 <CAOS58YMSw6wJU07WfVG8wd_BnU4TXr7VDBHeDPa4XjSpn2p3Ag@mail.gmail.com>
 <519F36BD.1030806@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <519F36BD.1030806@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Jens Axboe <axboe@kernel.dk>, lkml <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, May 24, 2013 at 11:45:33AM +0200, Paolo Bonzini wrote:
> > It's not just unimplemented commands. Exposing any new command exposes
> > its borderline problems together with it.
> 
> For commands that are used by Linux already, the right way to fix the
> problems is not obscuring the commands from userspace's view.  You can
> hit the same problems with ioctls or even with normal operation of the
> device.

The kernel is providing an isolation layer between the userland and
the devices.  It isn't obscuring.  We can go through many adjectives
but it's still increasing the amount exposed surface and accelerating
expansion of cdb filter.

> And prohibiting the extension of whitelists is gonna increase the
> usage of unpriv_sgio and less-secure userspace whitelists.
> 
> Anvil, meet hammer.

Delegating full device access is still a fringe use case compared to
generic block RW access.  Given thta we're expecting to have an extra
separation layer albeit in userland, the overall picture doesn't seem
to favor extension of whitelists.

> > If the bulk of filtering can be solved with userland whitelisting as a
> > confined user, it should be possible to resolve peripheral problems
> > like log messages in simpler way, no? Can you please elaborate on the
> > log message problem? Who's spewing those messages?
> 
> For example:
> 
>         if (bdev_write_same(bdev)) {
>                 unsigned char bdn[BDEVNAME_SIZE];
> 
>                 if (!blkdev_issue_write_same(bdev, sector, nr_sects, gfp_mask,
>                                              ZERO_PAGE(0)))
>                         return 0;
> 
>                 bdevname(bdev, bdn);
>                 pr_err("%s: WRITE SAME failed. Manually zeroing.\n", bdn);
>         }
> 
>         return __blkdev_issue_zeroout(bdev, sector, nr_sects, gfp_mask);
> 
> The device exposes the ability to zero out LUN blocks, but the command is
> not whitelisted and it fails.

Which can be solved by userland filtering, right?

-- 
tejun
