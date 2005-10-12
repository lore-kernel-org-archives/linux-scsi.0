From: Jeff Garzik <jgarzik@pobox.com>
Subject: Adaptec SAS integration notes
Date: Wed, 12 Oct 2005 14:40:29 -0400
Message-ID: <20051012184029.GA10786@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:62852 "EHLO havoc.gtf.org")
	by vger.kernel.org with ESMTP id S1751499AbVJLSkd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Oct 2005 14:40:33 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Anderson <andmike@us.ibm.com>, Luben Tuikov <luben_tuikov@adaptec.com>, James Bottomley <James.Bottomley@steeleye.com>, Christoph Hellwig <hch@infradead.org>



So, I've been looking through Adaptec's SAS stuff, trying to figure
out how to best match it up with where the SCSI core currently is.
Here's the issues as best I can describe them, and proposed solutions.
Pending discussion of course, I hope to have a first cut of the
solutions sometime early next week.

Problems (with both Adaptec SAS and existing kernel)
--------
* Adaptec SAS abuses Scsi_Host_Template.  The host template is a set of
ops for various layers, and it is fine as an interface.  No need to
avoid it.

* Way too much glue between scsi_host and the rest of SAS.
sas_scsi_host.c is just the beginning.

* struct domain_device ultimately means "an RPC message destination",
and I'm not convinced it is a useful abstraction.  Further, if people
choose to introduce this abstraction, the implementation of such should
be far more widespread.

* Adaptec SAS could certainly integrate a bit with scsi_transport_sas...
not sure if full integration will work:

* scsi_transport_sas's sas_rphy_add() digs a bit too deep into
discovery.  I would prefer that libsas call scsi_scan_target() as it
makes connections.

* Given how low-level SAS wide ports are, it really feels like we should
be dealing with things at the SAS port level, not SAS phy level.

* Thought should be given to HBAs as RPC targets, since they have WWNs etc.

* very poor SATA interface

* not sure if SMP really needs a full blown block driver abstraction.
Christoph did some experiments and wasn't terribly pleased with what he
saw.  I can see his point.

* duplicates HCIL mapping code

* existing LUN scan should be fine, with maybe a few tiny tweaks

* Consider the problem of SAS vs. SATA, and both Adaptec SAS and libata
fighting over who's host struct to use.


Nice stuff (with both Adaptec SAS and existing kernel)
----------
* Overall, the Adaptec SAS code is pretty clean and easy to read

* Having ->lldd_execute_task() and similar hooks match closely with
the hardware behavior, so those are nice.

* Adaptec SAS transport is cleanly separated from the rest of things

* SCSI core already pretty much equates to SAM, even if there is plenty
of HCIL dependency in various places (HCIL should get marginalized,
as all agree)


Solutions
---------
* Similar to libata drivers, scsi-host-template should be in the LLDD,
even if it is filled with mostly generic helper calls.

* I would tend to prefer calling scsi_scan_target() from SAS discovery
code, rather than sas_rhy_add()

* Using scsi_scan_target() would allow us to use the normal LUN scan

* Avoid writing a separate SMP driver for now, and see how things
shake out with future SAS+SATA hardware.

* Put HCIL mapping into top-level helper code, for sharing between FC
and SAS (hopefully!)

* use existing struct scsi_lun where feasible

* LONG TERM: I wouldn't mind a small "scsi_rpc" helper lib
which provided execute_task() hook and other task mgmt functions.
Authors could choose to use that interface -- sitting just underneath
Scsi_Host_Template -- if their hardware closely matches the pure SAM
TMF model.  If hardware doesn't closely match, using this interface
will simply lead to a lot of glue/simulation code.  This gets the
hardware a bit closer to scsi_execute_req() etc.



Overall
-------
Not a _ton_ of work to integrate as I have described, but I may be
missing some pertinent details.



Comments welcome -- this is basically where I plan to start coding.



