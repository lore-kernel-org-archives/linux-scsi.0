From: christophe.varoqui@free.fr
Subject: Re: [lvm] [christophe.varoqui@free.fr: dm multipath target]
Date: Tue, 19 Aug 2003 12:48:07 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1061290087.3f4200678f811@impt2-2.free.fr>
References: <20030819073926.GA423@fib011235813.fsnet.co.uk> <20030819094838.F8428@sistina.com> <1061283871.3f41e81f8226b@impt3-2.free.fr> <20030819115110.I8420@sistina.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from postfix3-2.free.fr ([213.228.0.169]:50620 "EHLO
	postfix3-2.free.fr") by vger.kernel.org with ESMTP id S270206AbTHSKsJ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Aug 2003 06:48:09 -0400
In-Reply-To: <20030819115110.I8420@sistina.com>
List-Id: linux-scsi@vger.kernel.org
To: mauelshagen@sistina.com
Cc: mge@sistina.com, linux-scsi@vger.kernel.org

Selon "Heinz J . Mauelshagen" <Heinz.Mauelshagen@t-online.de>:

> Ghosts should report EIO in case of an unstarted LUN anyway ?
> In case they are started they are supposed to report EPERM on IO because
> they don't support any.
> 
All I can say is that it blocks pvscan for a looong time. I havn't had the
patience to see if it finaly abords.

> Even reporting EPERM in both cases would be sufficient, because IO
> will never make it through a ghost. Blocking makes no sense to me at all.
> 
That's the vendor-specific issue I talk about : other controlers certainly
return errors, other activate the path on IO submission (with or without
penalty). HSV simply blocks.

> There's various "flavours" where to put multipath into the io chain.
> Kernel hacker conclusion is in device-mapper.
> 
No problem with that

> Multipathing is a device-mapper target and therefore offers a general kernel
> service to be used by arbitrary applications.
> LVM2 is the one from us supporting that in the future.
> 
Does it mean the multipath tools from you will be packaged in the lvm compound
binary, or as an independant set ?

> Other LVM applications are free to implement a different model.
> 
> Device-mapper has no clue of volume management metadata. LVM2 has.
>
> We need better device recovery in Linux (which will happen in the Linux 2.7
> series later). PV UUIDs enable LVM2 to discover PVs.
> 
Yes, but does it mean _your_ multipath tools will need PV UUIDs ?
Will these tools be relevant outside of LVM2 volume management scope, as for
them to become "standard" ?

> I much rather prefer a cleaner ghosts implementation not blocking
> critical applications.
> 
The ghost behaviour being vendor-specific, policy belongs to userspace. If the
vendor says the ghost does not respond to IO, then it's up to userland to
instruct the kernel to not submit IO to it (ie set device mappings).
As you plan to package a set of userspace tools for multipath management, you
should allow plugins implementing those policies.

regards,
cvaroqui
