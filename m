From: David Wysochanski <davidw@netapp.com>
Subject: Re: SNIA iSCSI Management API Public Review
Date: Tue, 26 Oct 2004 17:04:17 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <417EBBD1.7090508@netapp.com>
References: <20041026182914.GA6006@lists.us.dell.com> <20041026194926.GA17456@infradead.org> <417EAC8F.5010109@netapp.com> <20041026202311.GA17844@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.netapp.com ([216.240.18.37]:45482 "EHLO mx2.netapp.com")
	by vger.kernel.org with ESMTP id S261465AbUJZVEU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Oct 2004 17:04:20 -0400
In-Reply-To: <20041026202311.GA17844@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Matt Domsch <Matt_Domsch@dell.com>, linux-scsi@vger.kernel.org

Thanks for taking the time to review and be candid.  More comments
below.

Christoph Hellwig wrote:
> On Tue, Oct 26, 2004 at 03:59:11PM -0400, David Wysochanski wrote:
>  > Christoph Hellwig wrote:
>  > >On Tue, Oct 26, 2004 at 01:29:14PM -0500, Matt Domsch wrote:
>  > > > FYI.
>  > >
>  > >It has the usual SNIA spec quality - aka totally useless.
>  > >
>  >
>  > What specifically is so bad to describe it as totally useless?
> 
> it throws far too much things together, own type and object system,
> functions to deal with firmware.  there's ill suited abstractions like
> the phba, etc..
> 
Sounds like you don't like the modelling.  Keep in mind that a
lot of this came out of the T11 HBA API (for Fibre Channel HBAs
and FC storage management).  Thus, the "phba" idea really fits
the model well.  If you're thinking about it from a software
only perspective, with standard ethernet NICs, it does look
a little strange.

> as I said it's the usual SNIA design by commitee mess.
> 
>  > (Note that this API isn't kernel related.)
> 
> actual it is - as most of the calls end up in an device driver,
> or because the API is totally messed up with networking bits the
> networking layer.
> 
> to take a very concrete example:
> 
> IMA_SetSubnetMask (sets the subnet mask for a specified network port)
> doesn't make any sense at all in Linux with a software iscsi implementation
> as IP addresses and thus netmasks aren't bound to network interfaces at 
> all.
> 

Very good point.
I understand your concern, and I initially had similar ones.

For a software initiator, all of these networking type functions
will not be implemented -- the spec gives you an option to indicate
whether a particular implementation has the networking options.

I and a few others argued a while back these very things -- that
for a software  initiator and typical ethernet NICs, the model didn't
fit as well, and things like the IP stuff should be left to the standard
mechanisms.  As a result, the spec was adjusted a bit to accomodate
the software only case.

A while back I actually came up with a design for an IMA plugin
(the OS dependent part of IMA) to the linux-iscsi software initiator.
As I recall, very little of the plugin, if at all, needed an IOCTL
call to the iscsi driver, but most of it just interfaced with the
userspace stuff.



