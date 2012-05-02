From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] scsi: Silence unnecessary warnings about ioctl to partition
Date: Wed, 02 May 2012 13:24:19 +0200
Message-ID: <4FA11963.3040007@redhat.com>
References: <1335953452-10460-1-git-send-email-jack@suse.cz> <4FA1092E.9090603@redhat.com> <20120502115447.7dcc3a54@pyramind.ukuu.org.uk> <4FA11454.2010103@redhat.com> <20120502121208.3c19a9bc@pyramind.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120502121208.3c19a9bc@pyramind.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>, LKML <linux-kernel@vger.kernel.org>, James Bottomley <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Il 02/05/2012 13:12, Alan Cox ha scritto:
>> Sure, but then disallowing the ioctls for processes with CAP_SYS_RAWIO
>> will not cause regressions and _can_ happen.  The transition period only
> 
> The user has CAP_SYS_RAWIO, they can already do it by poking the
> registers on the chip directly. It is a nonsense to attempt to block or
> warn about this.

Not true, for example CAP_SYS_RAWIO is still subject to access control.
 Even simple Unix DAC can prevent you from issuing register writes to
/dev/sdb, while letting you do so on /dev/sda and access /dev/sdb1.  I'm
not inventing anything, the old ATA subsystem is already blocking most
"dangerous" ioctls for partitions, even if you have CAP_SYS_RAWIO.

Now of course CAP_SYS_RAWIO lets you use ioperm or iopl, but that's a
separate issue and only limited to x86.

>> up and implement a very restrictive filter for SCSI commands sent to
>> partition.
> 
> The process has CAP_SYS_RAWIO it can already bypass any check you try and
> put in place.

Almost any capability can be abused to bypass checks.  True,
CAP_SYS_RAWIO is especially good at that, but still you can try.

>> The right patch is one that prepares for these step,
> 
> Doesn't look very right to me.
> 
>> http://permalink.gmane.org/gmane.linux.kernel/1254625 for example.  It
>> leaves the warning only for SG_IO, and silently blocks the rest (more
>> rationale in the commit message there).
> 
> Even the printk in that patch is wrong. We have capabilities. Being a
> "root" user is a meaningless distinction here so your ratelimited printk
> isn't just bogus - its wrong. It may have got into RHEL somehow but the
> kernel QA process is a bit higher standard than this proposed patch.

Indeed, RHEL doesn't have the warning at all and blocks all ioctls
including SG_IO (and in the past six months nobody has complained that
something stopped working for them).  Never said the patch is perfect...

> A process with CAP_SYS_RAWIO has total power. It's assumed to know what
> it is doing. Trying to block it doing stuff like that simply makes
> authors do them via different more crass methods.

Getting appropriate permission on device nodes is less crass than
abusing partition device nodes.

Paolo
