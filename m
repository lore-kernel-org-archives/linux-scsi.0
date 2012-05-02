From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] scsi: Silence unnecessary warnings about ioctl to partition
Date: Wed, 02 May 2012 13:02:44 +0200
Message-ID: <4FA11454.2010103@redhat.com>
References: <1335953452-10460-1-git-send-email-jack@suse.cz> <4FA1092E.9090603@redhat.com> <20120502115447.7dcc3a54@pyramind.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62631 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753224Ab2EBLDU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 May 2012 07:03:20 -0400
In-Reply-To: <20120502115447.7dcc3a54@pyramind.ukuu.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>, LKML <linux-kernel@vger.kernel.org>, James Bottomley <JBottomley@parallels.com>, linux-scsi@vger.kernel.org

Il 02/05/2012 12:54, Alan Cox ha scritto:
>>> > > Since I have seen warnings from lots of commands, including some proprietary
>>> > > userspace applications, I don't think disallowing the ioctls for processes
>>> > > with CAP_SYS_RAWIO will happen in the near future if ever. So lets just
>>> > > stop warning for processes with CAP_SYS_RAWIO for which ioctl is allowed.
>> > 
>> > NACK.  I would bet that all the warnings you've seen are for ioctl that
>> > would have failed anyway with ENOTTY.
> Then we don't need the bogus warning do we.

Sure, but then disallowing the ioctls for processes with CAP_SYS_RAWIO
will not cause regressions and _can_ happen.  The transition period only
needs to be prolonged for SG_IO, the only one that was reported in the
wild, until people have time to fix their bugs or (I hope not) we give
up and implement a very restrictive filter for SCSI commands sent to
partition.

The right patch is one that prepares for these step,
http://permalink.gmane.org/gmane.linux.kernel/1254625 for example.  It
leaves the warning only for SG_IO, and silently blocks the rest (more
rationale in the commit message there).

However, that patch should be applied only at the beginning of the merge
window, not at the end of the release cycle.

Paolo
