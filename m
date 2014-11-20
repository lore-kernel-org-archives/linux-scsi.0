From: Tim Small <tim@buttersideup.com>
Subject: Re: Very slow throughput when using cdparanoia on two SATA CDROM
 drives with /dev/sr but not /dev/sg
Date: Thu, 20 Nov 2014 08:16:06 +0000
Message-ID: <546DA346.7050507@buttersideup.com>
References: <545B76B2.1020906@buttersideup.com> <20141107213723.GA5088@animx.eu.org> <20141120063420.GA18238@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay1.allsecuredomains.com ([78.47.234.210]:33985 "EHLO
	relay1.allsecuredomains.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754574AbaKTIQk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Nov 2014 03:16:40 -0500
In-Reply-To: <20141120063420.GA18238@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Wakko Warner <wakko@animx.eu.org>
Cc: linux-scsi@vger.kernel.org

On 20/11/14 06:34, Christoph Hellwig wrote:
> Wakko, any chance you could resend a patch to remove the mutex from the
> ioctl path?

I'm trying out some local changes which removes the ex-BKL mutex from
sr_block_ioctl() in sr.c, and instead uses a per-drive mutex which I've
added to cdrom_device_info (as per Arnd Bergmann/ James Bottomley's
discussion here https://lkml.org/lkml/2012/2/28/305 ).

This seems to work in a quick test testing (simultaneous cdparanoia on
8-or-so drives took ~10 minutes, whereas last time I tried that it took
more than 18 hours), but I've been short on time to do much more.

At first inspection, it looks like it's just the cdrom-specific ioctls
in drivers/cdrom/cdrom.c which aren't safely preemptible (my conclusion
based on the fact that scsi_ioctl etc. is called elsewhere without
locking (e.g. from /dev/sg and /dev/sd devices - I haven't looked at ).

As a result, I was wondering about moving the mutex_lock / unlock, so
that they wrap just the cdrom-specific ioctl calls instead, although I
suspect there won't be a huge performance benefit from doing so, it
would have the advantage that all the code related to the new mutex to
be moved into cdrom.c

Hopefully I'll grab a bit of time to work on this later this week, and
post a patch.

Cheers,

Tim.

