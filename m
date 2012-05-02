From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] scsi: Silence unnecessary warnings about ioctl to
 partition
Date: Wed, 2 May 2012 12:12:08 +0100
Message-ID: <20120502121208.3c19a9bc@pyramind.ukuu.org.uk>
References: <1335953452-10460-1-git-send-email-jack@suse.cz>
	<4FA1092E.9090603@redhat.com>
	<20120502115447.7dcc3a54@pyramind.ukuu.org.uk>
	<4FA11454.2010103@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4FA11454.2010103@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>, LKML <linux-kernel@vger.kernel.org>, James Bottomley <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> Sure, but then disallowing the ioctls for processes with CAP_SYS_RAWIO
> will not cause regressions and _can_ happen.  The transition period only

The user has CAP_SYS_RAWIO, they can already do it by poking the
registers on the chip directly. It is a nonsense to attempt to block or
warn about this.

> up and implement a very restrictive filter for SCSI commands sent to
> partition.

The process has CAP_SYS_RAWIO it can already bypass any check you try and
put in place.

> The right patch is one that prepares for these step,

Doesn't look very right to me.

> http://permalink.gmane.org/gmane.linux.kernel/1254625 for example.  It
> leaves the warning only for SG_IO, and silently blocks the rest (more
> rationale in the commit message there).

Even the printk in that patch is wrong. We have capabilities. Being a
"root" user is a meaningless distinction here so your ratelimited printk
isn't just bogus - its wrong. It may have got into RHEL somehow but the
kernel QA process is a bit higher standard than this proposed patch.

A process with CAP_SYS_RAWIO has total power. It's assumed to know what
it is doing. Trying to block it doing stuff like that simply makes
authors do them via different more crass methods.

Alan
