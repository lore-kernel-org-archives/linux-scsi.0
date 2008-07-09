From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] Mark i2o config broken on 64-bit platforms.
Date: Wed, 09 Jul 2008 15:15:14 +0100
Message-ID: <4561.1215612914@redhat.com>
References: <E1KGa1W-0004nG-Cw@n2o.xs4all.nl> <20080709113547.19235.15424.stgit@warthog.procyon.org.uk>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:33803 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751879AbYGIOPd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Jul 2008 10:15:33 -0400
In-Reply-To: <E1KGa1W-0004nG-Cw@n2o.xs4all.nl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Miquel van Smoorenburg <miquels@cistron.nl>
Cc: dhowells@redhat.com, akpm@linux-foundation.org, alan@redhat.com, Markus.Lidel@shadowconnect.com, vvs@sw.ru, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Miquel van Smoorenburg <miquels@cistron.nl> wrote:

> The adaptec management application ("raidutils") is also not 64-bit clean
> (read the code .. it puts pointers into ints etc etc), and fixing
> that is not trivial, _but_ the 32 bit version works on a 64 bit kernel.

That may be so, but there is nothing to protect the 64-bit ioctl() call,
should someone choose to make one.

> First, if you want to mark something broken, it would be
> CONFIG_I2O_EXT_ADAPTEC ..

That's probably right.

> second, compiling it gives warnings, but it works, and I bet people are
> using it.

Maybe, but have you looked at i2o_cfg_passthru()?  Take this, for example:

			/* Allocate memory for the transfer */
			p = kmalloc(sg_size, GFP_KERNEL);
			...
			//TODO 64bit fix
			sg[i].addr_bus = virt_to_bus(p);

That looks distinctly dodgy.  virt_to_bus() returns a 64-bit address, and as
far as I know you may not assume that it will return a 32-bit address.  You're
taking the bus-address of a piece of RAM, but there may be more than 4GB of
RAM in the system.

David
