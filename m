From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [RFC] Asynchronous scanning for FC/SAS version 3
Date: Wed, 22 Nov 2006 11:19:08 -0800
Message-ID: <20061122191908.GK1538@andrew-vasquezs-computer.local>
References: <20061113152605.GZ16952@parisc-linux.org> <20061120192140.GE11420@andrew-vasquezs-computer.local> <20061120201143.GN18567@parisc-linux.org> <20061122161926.GC1538@andrew-vasquezs-computer.local> <20061122175125.GW18567@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:41816 "EHLO
	avexch1.qlogic.com") by vger.kernel.org with ESMTP id S1756701AbWKVTTK
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Nov 2006 14:19:10 -0500
Content-Disposition: inline
In-Reply-To: <20061122175125.GW18567@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org, linux-driver@qlogic.com, james.smart@emulex.com

On Wed, 22 Nov 2006, Matthew Wilcox wrote:
> On Wed, Nov 22, 2006 at 08:19:26AM -0800, Andrew Vasquez wrote:
> > +static int
> > +qla2xxx_scan_finished(struct Scsi_Host *shost, unsigned long time)
> > +{
> > +       scsi_qla_host_t *ha = (scsi_qla_host_t *)shost->hostdata;
> > +
> > +       if (!ha->host)
> > +               return 1;
> > +       if (time > ha->loop_reset_delay * HZ)
> > +               return 1;
> > +
> > +       return atomic_read(&ha->loop_state) == LOOP_READY;
> > +}
> > 
> > is the *first* instance where the firmware/driver has attained a
> > steady link state within the topology.  The 'found all the devices
> > there are to find' case may or may not fall within this window...
> 
> Ah, fair point, I didn't *quite* understand the distinction between the
> various flags; can you suggest a better condition to test?

I don't really think there's a 'better' condition to test for given
there's isn't a state at which a driver:

- knows how to define 'all devices'
- is in control of ports beyond its single interconnect (as is
  the case of a fabric) from the HBA to the switch port.

My only point is that when the LOOP_READY state is attained for the
first time, we'll have only discovered devices (ports) present at
precisely that point in time -- i.e. two seconds (one second, 10
miliseconds) later (perhaps due to some hiccup on the fabric) an RSCN
could occur, an SNS rescan performed, and some new target-capable
device is discovered...

Anyway, just something we need to keep in mind going forward... It's
also another reason why lun-discovery is triggered indirectly during
an fc_remote_port_add()...
