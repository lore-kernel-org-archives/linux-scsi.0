From: Andreas Herrmann <AHERRMAN@de.ibm.com>
Subject: Re: [PATCH] fc transport: new attributes for NPIV
Date: Tue, 10 Jan 2006 00:59:53 +0100
Message-ID: <OFCC2A89CA.90DCC5D6-ON412570F1.008356CC-412570F1.0083D054@de.ibm.com>
References: <20060109180513.GA4286@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.29.151]:14029 "EHLO
	mtagate2.de.ibm.com") by vger.kernel.org with ESMTP
	id S1751663AbWAJABf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Jan 2006 19:01:35 -0500
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate2.de.ibm.com (8.12.10/8.12.10) with ESMTP id k0A01YI5054390
	for <linux-scsi@vger.kernel.org>; Tue, 10 Jan 2006 00:01:34 GMT
Received: from d12av04.megacenter.de.ibm.com (d12av04.megacenter.de.ibm.com [9.149.165.229])
	by d12nrmr1607.megacenter.de.ibm.com (8.12.10/NCO/VERS6.8) with ESMTP id k0A01Xbs156368
	for <linux-scsi@vger.kernel.org>; Tue, 10 Jan 2006 01:01:33 +0100
Received: from d12av04.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av04.megacenter.de.ibm.com (8.12.11/8.13.3) with ESMTP id k0A01XsD024772
	for <linux-scsi@vger.kernel.org>; Tue, 10 Jan 2006 01:01:33 +0100
In-Reply-To: <20060109180513.GA4286@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Smart <James.Smart@Emulex.Com>, James Bottomley <jejb@steeleye.com>, Linux SCSI <linux-scsi@vger.kernel.org>

On 09.01.2006 19:05 Christoph Hellwig <hch@infradead.org> wrote:
> On Thu, Jan 05, 2006 at 12:28:45PM -0500, James Smart wrote:
> > 
> > >Problem is that on the mainframe I don't have access to the primary
> > >port. Virtualization is done in adapter microcode. I just have
> > >access to the virtual port.
> > 
> > I was afraid you'd say this... that was the other caveat.
> > 
> > OK - given that the primary port doesn't exist what you have makes
> > a lot of sense. I guess we have the 2 options:
> > - add the 2 attributes per host
> > - create a host and set the attributes  (and this is major overkill)
> > 
[...snip...]
> Actually I think even for Xen-like virtualization it makes most sense 
that
> most domains wouldn't see the Scsi_Host for the phyisical port so this 
solution
> looks most sane to me.  The long name for the physical names sounds fine 
to me
> aswell, much better than un-understandable three-latter acronyms :)

Another general point of interest is fc_host_statistics for virtual
and physical ports.

There are some stats (most or all non fc4 stats) that only make sense
for the physical port. And there are the fc4 stats that might be
determined for the virtual port.

Having the (overkill) solution of a host for the physical port would
help to sort things out. You could provide
- complete fc_host_statistics for the physical port,
- separate fc4 statistics for each virtual port.

Without a host for the physical port you have the choice between:

(a) providing same fc_host_statistics (of the physical port) for all
virtual ports with the same permanent port name

(b) providing a combination of non fc4 stats of physical port and fc4
stats of virtual port in fc_host_statistics for a virtual port

zfcp currently does (a) with one of the patches sent last week.

Implementing (a) the per virtual port fc4 statistics are missing.
Implementing (b) the overall fc4 statistics are missing which might
help to determine the utilization of the physical link.

But I don't think this justifies the introduction of a dummy-host for
the physical port in case the physical port is not represented by a
normal host.


Regards,

Andreas

