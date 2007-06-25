From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] zfcp: Report FCP LUN to SCSI midlayer
Date: Mon, 25 Jun 2007 20:57:20 +0200
Message-ID: <46801010.3050604@s5r6.in-berlin.de>
References: <200706191025.30986.swen@vnet.ibm.com> <20070622044035.GB5560@us.ibm.com> <1182521500.3923.49.camel@mulgrave.il.steeleye.com> <200706251239.09755.swen@vnet.ibm.com> <467FCB4C.6060907@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:48092 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520AbXFYS56 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Jun 2007 14:57:58 -0400
In-Reply-To: <467FCB4C.6060907@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Swen Schillig <swen@vnet.ibm.com>, James Bottomley <James.Bottomley@steeleye.com>, Mike Anderson <andmike@us.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>, linux-scsi@vger.kernel.org

Hannes Reinecke wrote:
> why don't we stick with the original implementation like zfcp had it?
> We can simpley expand the midlayer to add an attribute 'lun'
> to each scsi_device. This would be the LUN as returned by eg
> REPORT LUNS.
> No translation, nothing. Would be easy to implement and would allow
> any administrator to map the h:c:i:l value to the 'real' lun.

I would also like to have the Target Port identifier in there.  This, in
combination with the LUN alias Logical Unit identifier is useful for all
kinds of persistent device mapping.

The LUN could be the same data format (and display format) for all
transports == 8 bytes.  SBP-3's native format is 2 bytes but we can
transform and print it in the 8 bytes format; shouldn't hurt.

Actually, the SCSI midlayer integer 'l' can be used as internal
intermediary data format as long as only those LUN variants are in
real-world use which can be losslessly transformed to and from SCSI
midlayer's integer 'l'.

The transport identifiers have transport-dependent data sizes, and the
display formats are not standardized.  So that's requiring a little bit
more care than the LUNs but it isn't overly complicated either.

So,
  - SCSI mid layer should maintain sysfs attributes for each sdev which
    show Logical Unit identifier and Target Port identifier.

  - Do we pass the LUN through to SCSI midlayer's sysfs code via the
    theoretically lossy scsilun_to_int/ int_to_scsilun transformation?

  - Do we pass the target port identifier through as a data member in
    struct scsi_device, or as a hook "int (* print_target_port_id)(..);"
    in struct scsi_transport_template?

  - Do we also want initiator port identifier, initiator port name,
    target port name, LU name?  If so, create a subdirectory for that
    whole bunch of additional attributes?  (Most of these are just
    optional.  In case of SBP-2/3, the initiator port identifier is
    totally uninteresting to userspace; the initiator port name is of
    mild interest but can be retrieved elsewhere from sysfs by some
    black magic.)

I am slowly working on loosely related stuff in the fw-sbp2
transport-layer driver and could produce a respective patch for the
midlayer infrastructure along the way, if nobody else does before me.
(Next weekend at the earliest.)
-- 
Stefan Richter
-=====-=-=== -==- ==--=
http://arcgraph.de/sr/
