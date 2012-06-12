From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] scsi: allow persistent reservations without CAP_SYS_RAWIO
Date: Tue, 12 Jun 2012 19:08:53 +0200
Message-ID: <4FD777A5.9050001@redhat.com>
References: <1339517312-18134-1-git-send-email-pbonzini@redhat.com> <20120612175503.3462962f@pyramind.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120612175503.3462962f@pyramind.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, linux-scsi@vger.kernel.org, jbottomley@parallels.com
List-Id: linux-scsi@vger.kernel.org

Il 12/06/2012 18:55, Alan Cox ha scritto:
> On Tue, 12 Jun 2012 18:08:32 +0200
> Paolo Bonzini <pbonzini@redhat.com> wrote:
> 
>> Persistent reservations commands cannot be issued right now without
>> giving CAP_SYS_RAWIO to the process who wishes to send them.  This
>> is a bit heavy-handed, allow these two commands.
>>
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>> ---
>>         Ok for 3.5 as well?
> 
> NAK.
> 
> Persistent reservations are exactly the kind of command that should have
> a security model attached to them.

There is.  It's called "chmod"; you don't give write access to LUNs to
random users.  and SCM_RIGHTS is what lets you override it securely.

> Red Hat seems to be an ever growing source of "mummy its hard, lets
> disable all the security" type fixes. Please stop it.

Last time you were complaining that I was turning things *off* (SG_IO to
partitions for root).  Now you complain that I'm turning things *on*.
It's difficult to say they are the same thing.  Though perhaps you were
talking about someone else.

> There is a sensible debate to be had about whether a lesser privilege
> ought to be allowed. The real fix to this as with half of the other
> crazy attempts to break all the security models that seem to keep spewing
> forth is for someone who cares about it (that seems to me Red Hat) add
> support for pushing a BPF filter onto a block device command queue. 

Sure; however, doing so requires access to some member of "struct file"
from SG_IO.  Thus, ioctl would need to take a "struct file" rather than
just an fmode_t.

The switch to fmode_t was done in 2007 by Al Viro.  I would like to
understand the reasons for the switch; it seems to me that it was part
of the big kernel lock removal.  If it's acceptable to undo it, I would
very much would like to add generic BPF filtering to SG_IO.

Paolo
