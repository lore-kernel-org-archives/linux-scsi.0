From: Andi Kleen <ak@muc.de>
Subject: Re: aic7xxx strange code
Date: Fri, 02 Jan 2004 00:14:15 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <m3smizi7nc.fsf@averell.firstfloor.org>
References: <1072885576.10877.6.camel@laptop.fenrus.com>
	<960352704.1072895786@aslan.btc.adaptec.com>
	<20040101100809.GA1053@devserv.devel.redhat.com>
	<478922704.1072973783@aslan.scsiguy.com>
	<20040101161731.GB18742@devserv.devel.redhat.com>
	<482322704.1072974098@aslan.scsiguy.com>
	<20040101162823.GC18742@devserv.devel.redhat.com>
	<m3vfnvi9my.fsf@averell.firstfloor.org>
	<20040101223452.GA16369@devserv.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pD9526784.dip.t-dialin.net ([217.82.103.132]:38016 "EHLO
	fred.muc.de") by vger.kernel.org with ESMTP id S261892AbUAAXOR
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Jan 2004 18:14:17 -0500
In-Reply-To: <20040101223452.GA16369@devserv.devel.redhat.com> (Arjan van de
 Ven's message of "Thu, 1 Jan 2004 23:34:52 +0100")
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjanv@redhat.com>
Cc: linux-scsi@vger.kernel.org, gibbs@scsiguy.com

Arjan van de Ven <arjanv@redhat.com> writes:

> On Thu, Jan 01, 2004 at 11:31:17PM +0100, Andi Kleen wrote:
>> Architecture                  pci_alloc_consistent uses
>> i386                          normal dma mask
> 				.... but clipped to 32 bit
>
>> most 64bit archs/old x86-64   hardcoded 0xffffffff
>> newer IA64/some x86-64        consistent dma mask (2) 
>> newest x86-64                 normal dma mask & consistent dma mask (1) (2)
>> old redhat IA64               hardcoded 0xffffffffffffffff (?)
>
> not just old RH; At least one old SuSE too :0 (in fact I found a previous
> report claiming this only affected SuSE but it seems we're in the same boat
> now)

Ok. Old IA64 in general @) Or rather IA64/HP, right?

>> 
>> (1) to be bug-to-bug compatible with i386, some drivers rely on that.
>> (2) consistent dma mask is normally equivalent to hardcoded 0xffffffff
>> because that is the default value
>>                                     
>> It's quite a mess unfortunately. Due to (2) the 64bit architectures
>> are consistent, except for that old IA64. But i386 doing something
>> different is quite a problem.
>
> but i386 will *never* return > 32 bit at least.

The problem occurs with smaller masks than 32bit (e.g. used by some
sound drivers). The driver sets the normal mask < 32bit and expects
the memory to be allocated GFP_DMA. But it isn't.

The right thing to do would be to set the consistent mask, but that won't
work on i386 without an ifdef :-/

-Andi
