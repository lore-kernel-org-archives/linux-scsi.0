From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: PATCH: scsi device queue depth adjustability patch
Date: Wed, 02 Oct 2002 19:19:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200210022319.g92NJqe02653@localhost.localdomain>
References: <dledford@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id QAA26194
	for <linux-scsi@vger.kernel.org>; Wed, 2 Oct 2002 16:19:55 -0700
Received: from localhost.localdomain (midgard.sc.steeleye.com [172.17.6.40])
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) with ESMTP id QAA26105
	for <linux-scsi@vger.kernel.org>; Wed, 2 Oct 2002 16:19:53 -0700
Received: from mulgrave (jejb@localhost)
	by localhost.localdomain (8.11.6/linuxconf) with ESMTP id g92NJqe02653
	for <linux-scsi@vger.kernel.org>; Wed, 2 Oct 2002 19:19:52 -0400
In-Reply-To: Message from Doug Ledford <dledford@redhat.com>
   of "Wed, 02 Oct 2002 18:18:37 EDT." <20021002221837.GB30503@redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

dledford@redhat.com said:
> > How do HBA's that don't support this now work?

> The mid layer calls into the HBA driver's select_queue_depths()
> function  and the driver sets the queue depth on each device from
> there. 

> >  You've taken any dependency on 
> > scsi_host.cmd_per_lun out of the code (thus rendering it useless) so every HBA 
> > driver now is forced to use an initial queue depth adjustment just to start 
> > tagged command queueing.

> This is true both before and after my patch.  If the HBA doesn't implement 
> the select_queue_depths function then it will never get tagged queueing.  

But that's not quite how it works today.

If a HBA driver doesn't implement select_queue_depths, it can still set the 
template cmd_per_lun and have the mid layer build it this many commands per 
device (that's the line in scsi_build_commands which sets queue_depth to 
cmd_per_lun if its still unset), and hence you have an effective default 
tagged queue depth of cmd_per_lun.

The patch will break this, and thus disable TCQ for all drivers that rely on 
it.

> Besides, cmd_per_lun is *not* for tagged queueing, it's the queue depth 
> the scsi mid layer is suppossed to keep for *non* tagged devices.

The comment in the code above this parameter says: "...Set this to the maximum 
number of command blocks to be provided for each device.  Set this to 1 for 
one command block per lun, 2 for two, etc."  It's not unreasonable to assume 
this means the maximum number of outstanding tags.

Even if we assume it means what you say, how does the non TCQ HBA that sets 
this to 2 so every device always has one outstanding command and one ready to 
roll work? Now it only gets one command block because we never consult 
cmd_per_lun.

James


