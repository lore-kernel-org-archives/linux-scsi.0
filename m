From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] scsi: Silence unnecessary warnings about ioctl to
 partition
Date: Wed, 2 May 2012 13:05:31 +0100
Message-ID: <20120502130531.4b7d98fa@pyramind.ukuu.org.uk>
References: <1335953452-10460-1-git-send-email-jack@suse.cz>
	<4FA1092E.9090603@redhat.com>
	<20120502115447.7dcc3a54@pyramind.ukuu.org.uk>
	<4FA11454.2010103@redhat.com>
	<20120502121208.3c19a9bc@pyramind.ukuu.org.uk>
	<4FA11963.3040007@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4FA11963.3040007@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>, LKML <linux-kernel@vger.kernel.org>, James Bottomley <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> not inventing anything, the old ATA subsystem is already blocking most
> "dangerous" ioctls for partitions, even if you have CAP_SYS_RAWIO.

It blocked a few by default to protect hardware. It's a tricky tradeoff,
which is quite different to this.

> Now of course CAP_SYS_RAWIO lets you use ioperm or iopl, but that's a
> separate issue and only limited to x86.

Ie only 99.99% of the systems running desktop/server Linux OS designs.

> Almost any capability can be abused to bypass checks.  True,
> CAP_SYS_RAWIO is especially good at that, but still you can try.

Why try - you are seeking to arbitarily impose your own worldview on the
interface (and in doing so break back compatibility). The whole basis of
the Unix philosophy is that the OS shouldn't try and micromanage the
priviledged apps because that just leads to crap code.

Think "small government" on this aspect of design. And with the patch you
propose the analogy for your patch is the TSA.

> > A process with CAP_SYS_RAWIO has total power. It's assumed to know what
> > it is doing. Trying to block it doing stuff like that simply makes
> > authors do them via different more crass methods.
> 
> Getting appropriate permission on device nodes is less crass than
> abusing partition device nodes.

Given a passed file handle how do you do that securely. Remember that
open /dev/foo while you have a handle on /dev/foo1 could open a
different disk if a hotplug has occurred.

So there are good reasons to keep the partition behaviour.

Alan
