From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] zfcp: Report FCP LUN to SCSI midlayer
Date: Tue, 26 Jun 2007 13:01:29 -0400
Message-ID: <1182877289.3562.27.camel@localhost.localdomain>
References: <319583.29876.qm@web31809.mail.mud.yahoo.com>
	 <4680EDFE.4050808@s5r6.in-berlin.de>
	 <1182867615.3562.3.camel@localhost.localdomain>
	 <4681351F.8000403@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:35304 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756382AbXFZRBp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jun 2007 13:01:45 -0400
In-Reply-To: <4681351F.8000403@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: ltuikov@yahoo.com, Hannes Reinecke <hare@suse.de>, Swen Schillig <swen@vnet.ibm.com>, Mike Anderson <andmike@us.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>, linux-scsi@vger.kernel.org

On Tue, 2007-06-26 at 17:47 +0200, Stefan Richter wrote:
> James Bottomley wrote:
> > On Tue, 2007-06-26 at 12:44 +0200, Stefan Richter wrote:
> >> If there are going to be sysfs representations of targets,
> [...]
> > OK, you've lost me ... this is our current sysfs representation of a
> > disk:
> > 
> > /sys/devices/pci0000:00/0000:00:1f.1/host0/target0:0:0/0:0:0:0
> > 
> > target0:0:0 is what I think of as the target ...
> 
> Strange.  How did I miss this?  #-|
> 
> Actually I missed this because I only looked into linux/include/scsi/*.h
> and found
> 
> struct scsi_device {
> 	...
> 	struct scsi_target *sdev_target; /* used only for single_lun */
> 	...
> }

It was procedural ... the only use the mid layer made of this field was
for the single lun processing ... although the code could be rewritten
not actually to do this (we could just use the dev->parent to get the
target).  I suspect a lot of the transport classes now hook into this as
well.

> Is the comment wrong or is sdev_target something different?
> 
> > is that different from what you're asking for?
> 
> That's part of what I asked for.  I also thought of SCSI core populating
> it with certain attributes; let's call them port_name and port_id.  To
> fill values into these attributes, transport layer
> drivers/classes/whatever supply to SCSI core either strings or functions
> which print strings into buffers.  ->  SCSI core controls that these
> properties go into host*/target*:*:*/port_{name,id}.  Transports control
> how the values of these attributes look.

Really, look at the fc code which already does it ... to try to provide
methods from the mid-layer would make this quite complex.

> If that's not wanted, then what is the way?  Simply the following code
> in a transport driver/class/whatever?
> 
> 	target_gendev = get_device(sdev->sdev_gendev.parent);
> 	/* error check omitted */
> 	err = device_create_file(target_gendev, &my_port_name_attr);
> 	/* error check omitted */
> 	err = device_create_file(target_gendev, &my_port_id_attr);
> 	/* error check omitted */
> 	put_device(target_gendev);
> 
> And I do this once, typically for the first sdev of each target?
> (Repeating it won't hurt, just gives -EEXIST

Not really ... look at scsi_transport_fc.c line 911 ... the entire
transport class is designed to set attributes like this and manage the
lifetimes of the underlying objects.

James


