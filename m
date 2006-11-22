From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [RFC] Asynchronous scanning for FC/SAS version 3
Date: Wed, 22 Nov 2006 08:19:26 -0800
Message-ID: <20061122161926.GC1538@andrew-vasquezs-computer.local>
References: <20061113152605.GZ16952@parisc-linux.org> <20061120192140.GE11420@andrew-vasquezs-computer.local> <20061120201143.GN18567@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:48810 "EHLO
	avexch1.qlogic.com") by vger.kernel.org with ESMTP id S1755327AbWKVQT2
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Nov 2006 11:19:28 -0500
Content-Disposition: inline
In-Reply-To: <20061120201143.GN18567@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org, linux-driver@qlogic.com, james.smart@emulex.com, Andrew Vasquez <andrew.vasquez@qlogic.com>

On Mon, 20 Nov 2006, Matthew Wilcox wrote:
> On Mon, Nov 20, 2006 at 11:21:41AM -0800, Andrew Vasquez wrote:
> > Perhaps as an alternative, I'd propose the following change to qla2xxx
> > intialization semantics:
> > 
> > - perform basic hardware configuration only (as usual)
> >   - allocate resources
> >   - load and execute firmware
> > 
> > - defer link (transport) negotiations to the DPC thread
> >   - again the code in qla2x00_initialize_adapter() to stall probe()
> >     completion was needed for legacy-style scanning.
> >   - DPC thread stalls until probe() complete.
> > 
> > - before probe() completes, set DPC flags to perform loop-resync logic
> >   (similar to what's done during cable-insertion/removal).
> > 
> > Benefits: user does not have to wait 20+ seconds in case the FC cable
> > is unplugged during driver load, code consolidation (removal of
> > redundant link negotiation logic during initialize_adaoter()), and
> > finilly, the driver no longer needs to defer the fc_remote_port_add()
> > calls to hold off lun-scanning prior to returning from the probe()
> > function.
> 
> This seems like a nice cleanup of some moderately complicated code.
> We still need scan_start and scan_finished methods so that the midlayer
> knows when the qla2xxx driver thinks it's found all the devices there
> are to find.

BTW:  side-note, this is a bit tricky, as we are dealing with a fabric
environment where ports can fall on/off a topology at any given time
(ISL removed, port disconnected, etc. can all cause a loss in fcport
visibility).  What this condition in scan_finished() is going to
catch:

+static int
+qla2xxx_scan_finished(struct Scsi_Host *shost, unsigned long time)
+{
+       scsi_qla_host_t *ha = (scsi_qla_host_t *)shost->hostdata;
+
+       if (!ha->host)
+               return 1;
+       if (time > ha->loop_reset_delay * HZ)
+               return 1;
+
+       return atomic_read(&ha->loop_state) == LOOP_READY;
+}

is the *first* instance where the firmware/driver has attained a
steady link state within the topology.  The 'found all the devices
there are to find' case may or may not fall within this window...

> But the patch to add those looks like it could be
> significantly smaller and have less chance of being buggy.
> 
> I think it should probably look something like this:

Ok, I've tweaked the code a bit and have been testing with the
following two patches, the first is a cleaned-up revision of my
'alternate' proposal (from above).  The second, adds callbacks for
your scan_start/end() work.

...
> ... and then add the call to scsi_scan_host() right after the call
> to scsi_add_host().  Bear in mind that if async scanning is disabled,
> scsi_scan_host will wait for ->scan_finished() to return true, so
> everything (eg interrupts and the DPC thread) must be initialised
> before calling scsi_scan_host().

Yes, that will always be the case.

> But also remember that we must call
> scsi_scan_host() before the driver calls scsi_scan_target() for the
> first time, so anything that could trigger that happening has to be done
> in ->scan_start().

Yep.  I'll continue testing with these two patches as an alternative
to your original work:

[SCSI] Convert qla2xxx to use scsi_scan_host
http://git.parisc-linux.org/?p=linux-2.6.git;a=commitdiff;h=114cf7c818ee1ba9104dbf0574c3b39e4f3ea5ef
