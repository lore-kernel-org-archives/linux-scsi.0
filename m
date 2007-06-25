From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH] zfcp: Report FCP LUN to SCSI midlayer
Date: Mon, 25 Jun 2007 14:27:01 -0700 (PDT)
Message-ID: <877013.89456.qm@web31802.mail.mud.yahoo.com>
References: <46801010.3050604@s5r6.in-berlin.de>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31802.mail.mud.yahoo.com ([68.142.207.65]:43378 "HELO
	web31802.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752217AbXFYV1D (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Jun 2007 17:27:03 -0400
In-Reply-To: <46801010.3050604@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>, Hannes Reinecke <hare@suse.de>
Cc: Swen Schillig <swen@vnet.ibm.com>, James Bottomley <James.Bottomley@steeleye.com>, Mike Anderson <andmike@us.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>, linux-scsi@vger.kernel.org

--- Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> Hannes Reinecke wrote:
> > why don't we stick with the original implementation like zfcp had it?
> > We can simpley expand the midlayer to add an attribute 'lun'
> > to each scsi_device. This would be the LUN as returned by eg
> > REPORT LUNS.
> > No translation, nothing. Would be easy to implement and would allow
> > any administrator to map the h:c:i:l value to the 'real' lun.

This would be the best way to go (what Hannes said).
 
> I would also like to have the Target Port identifier in there.  This, in

Well this is not correct because the TPI's format and representation
is transport dependent and because it is a property of the SCSI Target,
not the SCSI device (struct scsi device).  And currently SCSI Core
has no representation of SCSI Targets.

SCSI Core can have a burden if it needs to know about TPIs.

Ideally SCSI Core is presented with an opaque token (void *, unsigned long (long),
etc) which represents a target port, which it uses to send SPC commands
to the target to find out how many if any LUs the target has, INQUIRY them,
and then create struct scsi_dev for each LU.

When presented with this opaque token*, SCSI Core allocates and
initializes a struct scsi_target, whose children are LUs, later
to be discovered by SCSI Core.  SCSI Core then uses that opaque token
to ask the transport protocol layer to send commands to the I_T_L
nexus (WLUN or LUN if it knows it from previous discovery attempt).

* Note this means that there is no "active" scanning on part
of the SCSI Core.  This belongs to the transport layer.
(And thus the "concept" of "async-scanning" recently introduced
to SCSI Core, becomes moot.)

> combination with the LUN alias Logical Unit identifier is useful for all
> kinds of persistent device mapping.

The OS distros have wanted this for a long time, but they've
correctly wanted properties/attribues of the _device_, which can
be found by the various INQUIRY facilities.

That is, how you get to the device isn't important, what is
important is the device itself.

Ideally that would be the SCSI Device Name, which is also transport
dependent, but using memcmp() or strcmp() shouldn't be that bad.

> The LUN could be the same data format (and display format) for all
> transports == 8 bytes.  SBP-3's native format is 2 bytes but we can
> transform and print it in the 8 bytes format; shouldn't hurt.

Yes, a LUN is u8[8] and SCSI Core should absolutely never care
about what it actually is.  It should just pass it around
unaltered.

> Actually, the SCSI midlayer integer 'l' can be used as internal
> intermediary data format as long as only those LUN variants are in
> real-world use which can be losslessly transformed to and from SCSI
> midlayer's integer 'l'.
> 
> The transport identifiers have transport-dependent data sizes, and the
> display formats are not standardized.  So that's requiring a little bit
> more care than the LUNs but it isn't overly complicated either.
> 
> So,
>   - SCSI mid layer should maintain sysfs attributes for each sdev which
>     show Logical Unit identifier and Target Port identifier.
> 
>   - Do we pass the LUN through to SCSI midlayer's sysfs code via the
>     theoretically lossy scsilun_to_int/ int_to_scsilun transformation?
> 
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

I'd try to _shrink_ SCSI Core and get it out of the game of knowing
anything about formats/representation/print methods/protocol dependent
stuff/etc.  The smaller you get SCSI Core, the better off it is.

   Luben

