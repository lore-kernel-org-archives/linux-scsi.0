From: Tejun Heo <tj@kernel.org>
Subject: Re: PING^7 (was Re: [PATCH v2 00/14] Corrections and customization
 of the SG_IO command whitelist (CVE-2012-4542))
Date: Sat, 25 May 2013 17:37:13 +0900
Message-ID: <20130525083713.GA6179@mtj.dyndns.org>
References: <20130522193009.GA23845@mtj.dyndns.org>
 <519D360D.4050309@redhat.com>
 <20130522221737.GA12339@mtj.dyndns.org>
 <519DC926.4000106@redhat.com>
 <20130523090222.GA26592@mtj.dyndns.org>
 <519DE5AD.7080303@redhat.com>
 <20130524014405.GB16882@mtj.dyndns.org>
 <519F12FF.6090809@redhat.com>
 <CAOS58YODjkSF=V7wADqbn_z8c6bmj=r03hWxEs5B1O+1cd0n6g@mail.gmail.com>
 <1369456502.5008.5.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1369456502.5008.5.camel@dabdike>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jens Axboe <axboe@kernel.dk>, lkml <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hey, James.

On Fri, May 24, 2013 at 09:35:02PM -0700, James Bottomley wrote:
> > Well, I'd actually much prefer disabling CDB whitelisting for all !MMC
> > devices if at all possible.
> 
> I'll go along with this.  I'm also wondering what the problem would be

Don't think we can.  It'd be a behavior change clearly visible to
userland at this point.

> if we just allowed all commands on either CAP_SYS_RAWIO or opening the
> device for write, so we just defer to the filesystem permissions and
> restricted read only opens to the basic all device opcodes.

Given that there are quite a few cases where we give out block device
permission accesses, changing the behavior by default is likely too
dangerous.

> Do we have a real world example of this?  Getting the kernel out of the
> command filtering business does seem to be a good idea to me.

Something like the following seems workable.

* Fix the security bug.  I don't really care how it's fixed as long as
  the amount of whitelisted commands goes down not up.

* It's not like we can remove the filter for !MMC devices at this
  point, so I think it makes sense to make it per-class so that we can
  *remove* commands which aren't relevant for the device type.  Also,
  we probably wanna add read blinking comment yelling that no further
  commands should be added.

* Merge the patch to give out SG_IO access along with write access, so
  the use cases which want to give out SG_IO access can do so
  explicitly and be fully responsible for the device.  This makes
  sense to me.  If one wants to be allowed to issue raw commands to
  the hardware, one takes the full responsibility.

Thanks.

-- 
tejun
