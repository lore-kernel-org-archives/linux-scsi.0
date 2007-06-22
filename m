From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] zfcp: Report FCP LUN to SCSI midlayer
Date: Fri, 22 Jun 2007 21:01:38 +0200
Message-ID: <467C1C92.2080405@s5r6.in-berlin.de>
References: <200706191025.30986.swen@vnet.ibm.com>	 <20070619171217.GA30099@infradead.org>	 <1182307586.10507.7.camel@mulgrave.il.steeleye.com>	 <20070621150308.GA29643@schmichrtp.de.ibm.com>	 <467AAB55.9040306@s5r6.in-berlin.de> <1182476482.3923.44.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:47759 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759937AbXFVTBx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jun 2007 15:01:53 -0400
In-Reply-To: <1182476482.3923.44.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Christof Schmitt <christof.schmitt@de.ibm.com>, linux-scsi@vger.kernel.org

James Bottomley wrote:
> H:C is really mid-layer defined (although I'd like to get rid of C
> eventually).  They really correspond to physical enumeration of the HBA
> devices.  T (or I) is the one we think could be abstracted and placed
> within the gift of the transport, but so far there's been a lot of
> debate with few actual concrete proposals.  L is basically defined by
> SAM for every transport, but I'm really unsure how it should be
> represented in all its SAM specified glory.

If we reduce this discussion to the sysfs representation, then there is
one important point to understand:  The sysfs device path is
implementation-defined.  It always has been, always will be.  That's
inherent to sysfs.

So, having the current implementation-defined H:C:T:L in the sysfs
device path is alright.

Trying to squeeze the SAM LU identifiers and target port identifiers
into the sysfs path might not be such a good idea, exactly because there
is a number of different formats of these identifiers.  We certainly
want to find devices in sysfs in a transport-independent way.

So these identifiers should go somewhere else.  How about exporting
sysfs attributes for each sdev with common names like
	logical_unit_identifier
	target_port_identifier
	initiator_port_identifier
but with transport-dependent contents?  The various transport-layer
implementations can do this without hand-holding of the SCSI core; the
only thing that's important is that all transports use the same names
for these attributes.  The attributes shall be human-readable and can be
used by system management software like udev, hal, lsscsi, whatever.

If SCSI mid-layer wants to control what attribute names are used but
wants to leave the formatting of the contents to the transports, add for
example something like:

struct scsi_transport_template {
	...
	int (* print_logical_unit_identifier)(char *buf,
					struct scsi_device *sdev);
	int (* print_target_port_identifier)(char *buf,
					struct scsi_device *sdev);
	int (* print_initiator_port_identifier)(char *buf,
					struct scsi_device *sdev);
	...
};

Then SCSI mid-layer creates and destroys the attributes and
transport-layer implementations deliver contents for them.  The print_
hooks can also be used for debug printk's or the like if need be.

What's then left of the issues with H:C:T:L are the varying difficulties
that some transports have to fill in some more or less sensible values
in the mid-layer's variables corresponding to H:C:T:L.  Well, actually
the values don't have to make a lot of sense because they are
implementation defined and not for users to draw conclusions from them.

Or is there more to it?
-- 
Stefan Richter
-=====-=-=== -==- =-==-
http://arcgraph.de/sr/
