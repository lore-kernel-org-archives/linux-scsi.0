From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Can we pass a file handle down to the block ioctls to implement per
 file filters on scsi SG_IO ?
Date: Tue, 12 Jun 2012 19:52:00 +0100
Message-ID: <20120612195200.2a1b6129@pyramind.ukuu.org.uk>
References: <1339517312-18134-1-git-send-email-pbonzini@redhat.com>
	<20120612175503.3462962f@pyramind.ukuu.org.uk>
	<4FD777A5.9050001@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4FD777A5.9050001@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, linux-scsi@vger.kernel.org, jbottomley@parallels.com, Al Viro <viro@ZenIV.linux.org.uk>
List-Id: linux-scsi@vger.kernel.org

> > Persistent reservations are exactly the kind of command that should have
> > a security model attached to them.
> 
> There is.  It's called "chmod"; you don't give write access to LUNs to
> random users.  and SCM_RIGHTS is what lets you override it securely.

Only you do - for virtual machines for example.

> > Red Hat seems to be an ever growing source of "mummy its hard, lets
> > disable all the security" type fixes. Please stop it.
> 
> Last time you were complaining that I was turning things *off* (SG_IO to
> partitions for root).  Now you complain that I'm turning things *on*.
> It's difficult to say they are the same thing.  Though perhaps you were
> talking about someone else.

Last time you were trying to break stuff that worked and stop the
privileged user doing it. This time you are tring to take away security
features that users might be relying on.

> > There is a sensible debate to be had about whether a lesser privilege
> > ought to be allowed. The real fix to this as with half of the other
> > crazy attempts to break all the security models that seem to keep spewing
> > forth is for someone who cares about it (that seems to me Red Hat) add
> > support for pushing a BPF filter onto a block device command queue. 
> 
> Sure; however, doing so requires access to some member of "struct file"
> from SG_IO.  Thus, ioctl would need to take a "struct file" rather than
> just an fmode_t.
> 
> The switch to fmode_t was done in 2007 by Al Viro.  I would like to
> understand the reasons for the switch; it seems to me that it was part
> of the big kernel lock removal.  If it's acceptable to undo it, I would
> very much would like to add generic BPF filtering to SG_IO

That would solve all sorts of problems in this area, so lets ping the man
himself -  Al ?

Alan
