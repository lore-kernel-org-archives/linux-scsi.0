From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] zfcp: Report FCP LUN to SCSI midlayer
Date: Mon, 25 Jun 2007 16:48:44 -0500
Message-ID: <1182808124.3461.17.camel@localhost.localdomain>
References: <200706191025.30986.swen@vnet.ibm.com>
	 <20070622044035.GB5560@us.ibm.com>
	 <1182521500.3923.49.camel@mulgrave.il.steeleye.com>
	 <200706251239.09755.swen@vnet.ibm.com> <467FCB4C.6060907@suse.de>
	 <46801010.3050604@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:48201 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753092AbXFYVsr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Jun 2007 17:48:47 -0400
In-Reply-To: <46801010.3050604@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Hannes Reinecke <hare@suse.de>, Swen Schillig <swen@vnet.ibm.com>, Mike Anderson <andmike@us.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>, linux-scsi@vger.kernel.org

On Mon, 2007-06-25 at 20:57 +0200, Stefan Richter wrote:
> Hannes Reinecke wrote:
> > why don't we stick with the original implementation like zfcp had it?
> > We can simpley expand the midlayer to add an attribute 'lun'
> > to each scsi_device. This would be the LUN as returned by eg
> > REPORT LUNS.
> > No translation, nothing. Would be easy to implement and would allow
> > any administrator to map the h:c:i:l value to the 'real' lun.
> 
> I would also like to have the Target Port identifier in there.  This, in
> combination with the LUN alias Logical Unit identifier is useful for all
> kinds of persistent device mapping.

Really, no.  Target port is a target, not a LUN property; worse, it's
potentially transport defined.  The way target ports are currently shown
is by the relevant transport class as per target things (see the FC
transport for an example).  There's no real reason the mid-layer has to
know about these.

> The LUN could be the same data format (and display format) for all
> transports == 8 bytes.  SBP-3's native format is 2 bytes but we can
> transform and print it in the 8 bytes format; shouldn't hurt.
> 
> Actually, the SCSI midlayer integer 'l' can be used as internal
> intermediary data format as long as only those LUN variants are in
> real-world use which can be losslessly transformed to and from SCSI
> midlayer's integer 'l'.

You're sort of confusing what we display as the LUN and what we
represent it as internally (admittedly they're the same at the moment).
The object would be to separate these and the debate is really about
what to display.  I think the number for single level simple peripheral
addressing bus==0 or flat addressing and the full 64 bit entity
otherwise seems to be what people are converging on.

> The transport identifiers have transport-dependent data sizes, and the
> display formats are not standardized.  So that's requiring a little bit
> more care than the LUNs but it isn't overly complicated either.
> 
> So,
>   - SCSI mid layer should maintain sysfs attributes for each sdev which
>     show Logical Unit identifier and Target Port identifier.

LUN possibly, TPID no; the transport class does that one.

>   - Do we pass the LUN through to SCSI midlayer's sysfs code via the
>     theoretically lossy scsilun_to_int/ int_to_scsilun transformation?

Absolutely ... otherwise you won't get the correct representation when
that gets decided.

>   - Do we pass the target port identifier through as a data member in
>     struct scsi_device, or as a hook "int (* print_target_port_id)(..);"
>     in struct scsi_transport_template?
> 
>   - Do we also want initiator port identifier, initiator port name,
>     target port name, LU name?  If so, create a subdirectory for that
>     whole bunch of additional attributes?  (Most of these are just
>     optional.  In case of SBP-2/3, the initiator port identifier is
>     totally uninteresting to userspace; the initiator port name is of
>     mild interest but can be retrieved elsewhere from sysfs by some
>     black magic.)

Again, no ... these are transport dependent quantities and belong in the
transport class (if they're relevant to the transport).

> I am slowly working on loosely related stuff in the fw-sbp2
> transport-layer driver and could produce a respective patch for the
> midlayer infrastructure along the way, if nobody else does before me.
> (Next weekend at the earliest.)

James


