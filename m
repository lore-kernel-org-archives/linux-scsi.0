From: Andreas Herrmann <AHERRMAN@de.ibm.com>
Subject: Re: [PATCH] fc transport: new attributes for NPIV
Date: Tue, 10 Jan 2006 00:09:52 +0100
Message-ID: <OF5D4CA422.17C86FB6-ON412570F1.007E97FD-412570F1.007F3BE8@de.ibm.com>
References: <43C2B3C7.4010506@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.29.153]:53678 "EHLO
	mtagate4.de.ibm.com") by vger.kernel.org with ESMTP
	id S1750768AbWAIXJz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Jan 2006 18:09:55 -0500
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate4.de.ibm.com (8.12.10/8.12.10) with ESMTP id k09N9rln168120
	for <linux-scsi@vger.kernel.org>; Mon, 9 Jan 2006 23:09:53 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.12.10/NCO/VERS6.8) with ESMTP id k09N9rtG229614
	for <linux-scsi@vger.kernel.org>; Tue, 10 Jan 2006 00:09:53 +0100
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11/8.13.3) with ESMTP id k09N9rDa011150
	for <linux-scsi@vger.kernel.org>; Tue, 10 Jan 2006 00:09:53 +0100
In-Reply-To: <43C2B3C7.4010506@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <jejb@steeleye.com>, Linux SCSI <linux-scsi@vger.kernel.org>

On 09.01.2006 20:04 James Smart <James.Smart@Emulex.Com> wrote:
> Christoph Hellwig wrote:
> > Actually I think even for Xen-like virtualization it makes most sense 
that
> > most domains wouldn't see the Scsi_Host for the phyisical port so this 
solution
> > looks most sane to me.  The long name for the physical names sounds 
fine to me
> > as well, much better than un-understandable three-latter acronyms :)
[... snip ...]
> Having made this argument - I then said - why not use the name from the
> standards, "permanent_port_xxx". But, when I look at this, it's not much 

> different. Permanent vs Physical ? at least the abbreviation gave it 
some
> separation. Bah Humbug. My preference is still "permanent" over 
"physical"
> as it tracks the standards name.

I think physical_port_name was not the right choice. Sticking to
standards the name should be permanent_port_name. So people familiar
with FC standards have an idea what it is and all others are able to
find an explanation in FC-GS-4.

But introducing a permanent_port_id will lead to confusion:
Interpretation as "permanent port_id" is wrong because a port_id is
anything but "permanent".

In conclusion James' suggestion of attributes ppn and ppn_id has some
advantage.

And now comes the funny part:
Question is, do I need the port_id of the physical port at all?  In
order to determine problems with a virtual port I might have to check
whether the physical port is properly connected and logged in to the
fabric. Furthermore configuration of the corresponding switch port
should be checked. (E.g. switch might allow to set limits for the
number of NPIV connections for the switch port.)
I may be wrong but I think the port_id of the physical port is not
needed for this purpose.

Thus, how about introducing just what is really needed:
Introduce permanent_port_name attribute (and leave out port_id of the
physical port).

BTW, the permanent_port_name attribute of the virtual port suffices to
identify the fc_host of the physical port if there is a
representation.
And I think an LLDD should configure this attribute only for virtual
ports.


Regards,

Andreas

