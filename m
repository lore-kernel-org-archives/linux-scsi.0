From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: PING^7 (was Re: [PATCH v2 00/14] Corrections and customization
 of the SG_IO command whitelist (CVE-2012-4542))
Date: Sat, 25 May 2013 13:14:37 +0200
Message-ID: <51A09D1D.3040706@redhat.com>
References: <20130522193009.GA23845@mtj.dyndns.org> <519D360D.4050309@redhat.com> <20130522221737.GA12339@mtj.dyndns.org> <519DC926.4000106@redhat.com> <20130523090222.GA26592@mtj.dyndns.org> <519DE5AD.7080303@redhat.com> <20130524014405.GB16882@mtj.dyndns.org> <519F12FF.6090809@redhat.com> <CAOS58YODjkSF=V7wADqbn_z8c6bmj=r03hWxEs5B1O+1cd0n6g@mail.gmail.com> <1369456502.5008.5.camel@dabdike> <20130525083713.GA6179@mtj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130525083713.GA6179@mtj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <axboe@kernel.dk>, lkml <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Il 25/05/2013 10:37, Tejun Heo ha scritto:
> Hey, James.
> 
> On Fri, May 24, 2013 at 09:35:02PM -0700, James Bottomley wrote:
>>> Well, I'd actually much prefer disabling CDB whitelisting for all !MMC
>>> devices if at all possible.
>>
>> I'll go along with this.  I'm also wondering what the problem would be
> 
> Don't think we can.  It'd be a behavior change clearly visible to
> userland at this point.

We can (and even for MMC) if it is a build-time configuration knob.  It
would satisfy those people who want the CVE fixed, as long as userspace
gets some configurability.

> * Fix the security bug.  I don't really care how it's fixed as long as
>   the amount of whitelisted commands goes down not up.
> 
> * It's not like we can remove the filter for !MMC devices at this
>   point, so I think it makes sense to make it per-class so that we can
>   *remove* commands which aren't relevant for the device type.  Also,
>   we probably wanna add read blinking comment yelling that no further
>   commands should be added.
> 
> * Merge the patch to give out SG_IO access along with write access, so
>   the use cases which want to give out SG_IO access can do so
>   explicitly and be fully responsible for the device.  This makes
>   sense to me.  If one wants to be allowed to issue raw commands to
>   the hardware, one takes the full responsibility.

That's not possible; it would make it impossible to do things like using
a privileged helper to open the file and passing it back via SCM_RIGHTS
to an unprivileged program (running as the user).  This is the ptrace
attack that you mentioned.

Paolo
