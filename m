From: Andi Kleen <ak@muc.de>
Subject: Re: aic7xxx strange code
Date: Thu, 01 Jan 2004 23:31:17 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <m3vfnvi9my.fsf@averell.firstfloor.org>
References: <1072885576.10877.6.camel@laptop.fenrus.com>
	<960352704.1072895786@aslan.btc.adaptec.com>
	<20040101100809.GA1053@devserv.devel.redhat.com>
	<478922704.1072973783@aslan.scsiguy.com>
	<20040101161731.GB18742@devserv.devel.redhat.com>
	<482322704.1072974098@aslan.scsiguy.com>
	<20040101162823.GC18742@devserv.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pD9526784.dip.t-dialin.net ([217.82.103.132]:34688 "EHLO
	fred.muc.de") by vger.kernel.org with ESMTP id S264601AbUAAWbS
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Jan 2004 17:31:18 -0500
In-Reply-To: <20040101162823.GC18742@devserv.devel.redhat.com> (Arjan van de
 Ven's message of "Thu, 1 Jan 2004 17:28:23 +0100")
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjanv@redhat.com>
Cc: linux-scsi@vger.kernel.org, gibbs@scsiguy.com

Arjan van de Ven <arjanv@redhat.com> writes:
>
> This is the first time I've seen this bug (thanks again for reporting it)
> and it's clearly an API violation of the ONE API in linux which is very well
> documented so no other platform will have copied this bad bug... Adaptect

It may be well documented, but ports do not follow the documentation
very well in that area. In particular i386 handles the consistent dma mask
completely different than all the 64bit ports. Small overview:

Architecture                  pci_alloc_consistent uses
i386                          normal dma mask
most 64bit archs/old x86-64   hardcoded 0xffffffff
newer IA64/some x86-64        consistent dma mask (2) 
newest x86-64                 normal dma mask & consistent dma mask (1) (2)
old redhat IA64               hardcoded 0xffffffffffffffff (?)

(1) to be bug-to-bug compatible with i386, some drivers rely on that.
(2) consistent dma mask is normally equivalent to hardcoded 0xffffffff
because that is the default value
                                    
It's quite a mess unfortunately. Due to (2) the 64bit architectures
are consistent, except for that old IA64. But i386 doing something
different is quite a problem.

-Andi
