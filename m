From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH 6/7] aacraid: unlock around kfree
Date: Thu, 4 Aug 2005 08:04:48 -0400
Message-ID: <60807403EABEB443939A5A7AA8A7458B017931F1@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:56263 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S262496AbVHDMGw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Aug 2005 08:06:52 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mark Haverkamp <markh@osdl.org>, James Bottomley <James.Bottomley@SteelEye.com>

Cool! Thanks for the information! Sounds like the patch will be
necessary. However, I have never seen the issue bite us, but who knows,
it may be the contributor to a system lockup after 8000 hours of uptime
... I'd prefer the paranoid delusion and a stable system!

As for the GFP_ATOMIC, the intent is to move the kmalloc w/GFP_ATOMIC
from inside the loop to outside the loop and perform a guestimate+ on
the possible pool requirements of the loop. Since this is an independent
thread, there will be no need to use GFP_NOIO. The code has been tested
for almost a year now in the Adaptec branch, and the guestimate was
tweaked in that time to be 100% reliable.

Sincerely -- Mark Salyzyn

-----Original Message-----
From: Arjan van de Ven [mailto:arjan@infradead.org] 
Sent: Thursday, August 04, 2005 7:48 AM
To: Salyzyn, Mark
Cc: linux-scsi; Mark Haverkamp; James Bottomley
Subject: RE: [PATCH 6/7] aacraid: unlock around kfree

On Thu, 2005-08-04 at 07:33 -0400, Salyzyn, Mark wrote:
> Good to know. I went through one too many code reviews and had no
> defense against the request.
> 
> There is a follow-up to this one not yet submitted to MarkH where I
> endeavor to pre-allocate with kmalloc(,GFP_ATOMIC|GFP_KERNEL) a pool
> before entering a locked list traversal rather than risking making the
> calls with the locks held. The code is in an independent kernel thread
> handling deferred actions triggered by the interrupt. Am I barking up
> the wrong tree?

why do you need the GFP_ATOMIC if you allocate outside all locks?
Yes the idea is the right one; do a sleeping alloc outside all locks,
instead of a far more fragile atomic alloc inside locks.

Note: if you don't want the allocation to cause IO (which could recurse
into your driver) you need to use GFP_NOIO not GFP_KERNEL; the
difference is important for avoiding recursion-deadlocks


