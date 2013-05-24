From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: PING^7 (was Re: [PATCH v2 00/14] Corrections and customization
 of the SG_IO command whitelist (CVE-2012-4542))
Date: Fri, 24 May 2013 10:31:34 +0200
Message-ID: <519F2566.2000008@redhat.com>
References: <20130522134134.GA15189@mtj.dyndns.org> <519CD234.40608@redhat.com> <20130522143019.GA18541@mtj.dyndns.org> <519CDDA4.2050100@redhat.com> <20130522193009.GA23845@mtj.dyndns.org> <519D360D.4050309@redhat.com> <20130522221737.GA12339@mtj.dyndns.org> <519DC926.4000106@redhat.com> <20130523090222.GA26592@mtj.dyndns.org> <519DE5AD.7080303@redhat.com> <20130524014405.GB16882@mtj.dyndns.org> <519F12FF.6090809@redhat.com> <CAOS58YODjkSF=V7wADqbn_z8c6bmj=r03hWxEs5B1O+1cd0n6g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAOS58YODjkSF=V7wADqbn_z8c6bmj=r03hWxEs5B1O+1cd0n6g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Jens Axboe <axboe@kernel.dk>, lkml <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Il 24/05/2013 10:02, Tejun Heo ha scritto:
> On Fri, May 24, 2013 at 4:13 PM, Paolo Bonzini <pbonzini@redhat.com> wrote:
>>> The same filtering table being applied to different classes of
>>> hardware is a software bug, but my point is that the practive
>>> essentially entrusts non-insignificant part of security enforcement to
>>> the hardware itself.  The variety of hardware in question is very wide
>>> and significant portion has historically been known to be flaky.
>>
>> Unproven theory, and contradicted by actual practice.  Bugs are more
>> common in the handling of borderline conditions, not in the handling of
>> unimplemented commands.
>>
>> If you want to be secure aginst buggy firmware, the commands you have to
>> block are READ and WRITE.  Check out the list of existing USB quirks.
> 
> Well, I'd actually much prefer disabling CDB whitelisting for all !MMC
> devices if at all possible. You're basically arguing that because what
> we have is already broken, it should be okay to break it further.
> Also, RW commands having more quirks doesn't necessarily indicate that
> they tend to be more broken. They just get hammered on a lot in
> various ways so problems on those commands tend to be more noticeable.

I agree intuition may not count, and it's perfectly possible that
firmware writers forgot a "break;" or put the wrong location in a jump
table, so that unimplemented commands give interesting results.

However, the _fact_ is that this might happen anyway with the buttload
of commands that are already enabled by the whitelist and that most
disks will never implement.

>> You need to allow more commands.
>> The count-me-out knob allows all commands.
>> You cannot always allow all commands.
>> Ergo, you cannot always use the count-me-out knob.
> 
> The thing is that both approaches aren't perfect here so you can make
> similar type of argument from the other side. If the system wants to
> give out raw hardware access to VMs, requiring it to delegate the
> device fully could be reasonable.

No, it is not unfortunately.  Allowing to do discards is one thing,
allowing to disrupt the settings of a SAN is another.  You can only
delegate the device fully in these cases:

(a) of course, if the guest is trusted;

(b) if QEMU is running as a confined user, then you can get by with a
userspace whitelist.  (Otherwise you're just a ptrace away from
arbitrary access, as you pointed out).

Unfortunately, there are _real_ problems that this patches fix, such as
log spews due to blocked commands, and these happen even if neither of
the above conditions is true.

Is there anything else I can do?  Sure, I can check for the presence of
the whitelist and hack the VPD pages to hide features that I know the
whitelist will block.  Is it the right thing to do?  In my opinion no.
It makes no sense to have raw device access _disable_ features compared
to emulation.

> Not ideal but widening direct
> command access by default is pretty nasty too.

I actually agree, and that's why I'm trying to balance the widening and
restricting.

Paolo
