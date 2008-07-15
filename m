From: James.Smart@Emulex.Com
Subject: RE: bidi support: FC transport layer...
Date: Tue, 15 Jul 2008 15:35:43 -0400
Message-ID: <D1D4C3FF75F9354393DB8314DF43DEF2E7EF7B@xbl3.ma.emulex.com>
References: <E11DE615-512A-45C0-9308-036BDA225E9D@qlogic.com> <D1D4C3FF75F9354393DB8314DF43DEF2E7EE27@xbl3.ma.emulex.com> <77DD6D0A-346F-4797-B05D-C3C24EAD290E@qlogic.com> <C9F1A1B1-136B-4EE0-8F64-8EE5DF04E5B6@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:42009 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753329AbYGOTft convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Jul 2008 15:35:49 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: seokmann.ju@qlogic.com
Cc: linux-scsi@vger.kernel.org, andrew.vasquez@qlogic.com

 
> -----Original Message-----
> From: Seokmann Ju [mailto:seokmann.ju@qlogic.com] 
> Sent: Tuesday, July 15, 2008 2:55 PM
> To: Smart, James
> Cc: linux-scsi@vger.kernel.org; Andrew Vasquez
> Subject: Re: bidi support: FC transport layer...
>
>  From the code walk-through, for the SAS SMP case, the 
> transport layer  
> create
> a file under sysfs per each device detection, which is former case.
> Could you elaborate why we have to "temporarily create object X and  
> destroy"?

Well - as long as you are only going to talk to what the driver exports,
ok...

But, what if I want to talk to a Fabric Service or Switch entity the
driver
doesn't typically log into or stay logged into ?  Or what if I want to
talk
to another FCP initiator (not FCP traffic, but rather just ELS's/CT
traffic)
or want to talk to a non-FCP port, but the driver only enumerated the
rports
associated with FCP Targets ?  Or what if I just want to FC-Ping some
random
FC address ?

Somehow we have to make the driver/transport enumerate the device that
we
want to talk to.  Along with this, I'm assuming the driver has to
initiate/do
the basic PLOGI to the other address, and be told when to tear it down.

Another part I don't like about the "create a file for each enumeration"
is,
we rarely use these files. If the SAN is big, the system has lots of
adapters,
and so on, why make the system allocate/maintain/etc all of these things
that
are rarely used ? When you start enumerating per phy, and with logical
entities
layering on top of the physical thingies, it can really grow. At what
point does
SGIO run out of dev_t space ?  Consider that we are enumerating many
adapters in 
an enterprise system; and on the physical level down to phys, and
everything
on the transport such as expanders and phys on expanders and targets and
luns;
and add in virtualization such as NPIV or VSANs, each with potentially
large
san connectivity and their own large trees of these things... 
Does SGIO actually scale ?

> In general, I've been walking through the code to figure out overall  
> design
> and implementation details about SAS SMP handling.
> 1. when each of target device detected, a request_queue for the device
>   allocated/associated to it.
> 2. each of device gets device file under sysfs and the device file is
>   used to send SMP via bsg and the packets get serviced in 
> the nature of
>   bidi.
> 
> I also think it should be safe to implement FC-CT/ELS support in the
> manner similar to the SAS SMP.
> Please let me know for any other missing pieces.

Agreed - for the basic part.  However, you're still under the assumption
that SAS
enumerated everything.  Given that some SAS parts could perform
discovery on it's
own, with the LLDD interacting with the transport just enough to
enumerate what it
found useful, this may not always be the case. Additionally, there
aren't a lot
of other "protocols" or "port roles" that exist in SAS - but there are
in FC.

The more interesting part is to those things (switch services, non-FCP
targets)
that the driver did not enumerate.  We should allow the directed
enumeration of them
to perform some basic diagnostics or san queries.  And once you have
this, 
we can really open some interesting doors - why not an app that talks
FICON ? or
something that just message passes between 2 ports ? and so on...

-- james



