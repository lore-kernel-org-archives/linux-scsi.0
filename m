From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [RFC] Asynchronous scanning for FC/SAS version 3
Date: Wed, 22 Nov 2006 10:51:25 -0700
Message-ID: <20061122175125.GW18567@parisc-linux.org>
References: <20061113152605.GZ16952@parisc-linux.org> <20061120192140.GE11420@andrew-vasquezs-computer.local> <20061120201143.GN18567@parisc-linux.org> <20061122161926.GC1538@andrew-vasquezs-computer.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:962 "EHLO
	mail.parisc-linux.org") by vger.kernel.org with ESMTP
	id S1756086AbWKVRv0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Nov 2006 12:51:26 -0500
Content-Disposition: inline
In-Reply-To: <20061122161926.GC1538@andrew-vasquezs-computer.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: linux-scsi@vger.kernel.org, linux-driver@qlogic.com, james.smart@emulex.com

On Wed, Nov 22, 2006 at 08:19:26AM -0800, Andrew Vasquez wrote:
> > This seems like a nice cleanup of some moderately complicated code.
> > We still need scan_start and scan_finished methods so that the midlayer
> > knows when the qla2xxx driver thinks it's found all the devices there
> > are to find.
> 
> BTW:  side-note, this is a bit tricky, as we are dealing with a fabric
> environment where ports can fall on/off a topology at any given time
> (ISL removed, port disconnected, etc. can all cause a loss in fcport
> visibility).

Oh yes, I understand that.  I'm only trying to solve the situation where
the fabric is stable.

> What this condition in scan_finished() is going to
> catch:
> 
> +static int
> +qla2xxx_scan_finished(struct Scsi_Host *shost, unsigned long time)
> +{
> +       scsi_qla_host_t *ha = (scsi_qla_host_t *)shost->hostdata;
> +
> +       if (!ha->host)
> +               return 1;
> +       if (time > ha->loop_reset_delay * HZ)
> +               return 1;
> +
> +       return atomic_read(&ha->loop_state) == LOOP_READY;
> +}
> 
> is the *first* instance where the firmware/driver has attained a
> steady link state within the topology.  The 'found all the devices
> there are to find' case may or may not fall within this window...

Ah, fair point, I didn't *quite* understand the distinction between the
various flags; can you suggest a better condition to test?

> Ok, I've tweaked the code a bit and have been testing with the
> following two patches, the first is a cleaned-up revision of my
> 'alternate' proposal (from above).  The second, adds callbacks for
> your scan_start/end() work.

Thanks a lot!
