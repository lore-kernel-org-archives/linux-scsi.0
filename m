From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: command queueing cmd_per_lun, queue_depth and tags
Date: Mon, 10 Apr 2006 11:59:19 -0700
Message-ID: <20060410185919.GA15124@us.ibm.com>
References: <20060407214954.GA4990@us.ibm.com> <4436E7C8.5030204@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:13267 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S932095AbWDJTAZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Apr 2006 15:00:25 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e1.ny.us.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k3AJ0OWW015075
	for <linux-scsi@vger.kernel.org>; Mon, 10 Apr 2006 15:00:24 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VER6.8) with ESMTP id k3AIxcIm253176
	for <linux-scsi@vger.kernel.org>; Mon, 10 Apr 2006 14:59:38 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11/8.13.3) with ESMTP id k3AIxcO0014500
	for <linux-scsi@vger.kernel.org>; Mon, 10 Apr 2006 14:59:38 -0400
Content-Disposition: inline
In-Reply-To: <4436E7C8.5030204@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

On Fri, Apr 07, 2006 at 05:29:28PM -0500, Brian King wrote:
> Patrick Mansfield wrote:
> > Currently cmd_per_lun is the default queue depth for both tagged and
> > untagged queueing. That is, if the LLDD does not modify queue_depth in its
> > slave_configure, queue_depth will be set to cmd_per_lun, no matter what
> > the command queueing/tag support. 
> > 
> > If we don't allow queueing in the LLDD, and cmd_per_lun is supposed to be
> > the default depth for untagged support, shouldn't it always be 1, and
> > hence go away? 
> 
> This seems to assume there are no SCSI devices which do command queuing, but do
> not support queue tags. This is not the case.

I should not have used "untagged", that is misleading and a problem with
current scsi core, where we reference tcq, tags, and don't seem to mention
task attributes.

But LLDD can override anything in slave_configure.

Also, it looks like we could safely use cmd_per_lun as the default
queue_depth, rather than setting it to 1 as done in my previous
post/patch.

> > Similarily, why do some LLDD's use a cmd_per_lun of 3, or (like
> > ncr53c8xx_slave_configure) set queue_depth for !tagged_supported to
> > anything other than 1?
> 
> In the case of ipr, there are two scenarios. The first is for JBOD disks.
> I use a default queue depth of 6 in ipr. When running untagged, with a queue depth
> of > 1, the ipr adapter firmware then maintains a queue, guaranteeing only
> one command will be outstanding to the device at once. This lower level
> queue allows for a faster turnaround of commands and improved performance.
> The second case is that of RAID arrays. These show up as logical scsi disks.
> They support command queueing, but not tagged command queueing.

So you just want the task attibutes, and don't care about tag management
(i.e. you don't ever use cmd->request->tags)? That is similar to FCP.

> > I know (at least) FCP can always do simple queueing, but I don't think
> > scsi core should allow multiple commands to be sent if the device does not
> > have CMDQUE (or BQUE).
> 
> This will break both of the working scenarios I described above for ipr
> and performance will suffer significantly. The inquiry data for ipr RAID
> arrays does not set either CMDQUE or BQUE.

Sounds like they are sort of SCSI-2 compliant, that is allowed there but
mentioned as obsolete in current SCSI-3 (spc3r23.pdf).

The LLDD can override the queue_depth for these cases.

> > Also we don't even check the BQUE in the INQUIRY result (byte 6, bit 7).
> > Should this be changed? That is set tagged_supported if BQUE is set, like
> > we do for CMDQUE (byte 7 bit 1). And also set simple_tags if
> > tagged_supported is set.
> 
> I don't like the idea of always enabling TCQ in scsi core simply if
> the device supports it. What if the HBA does not support it? To make
> matters more interesting, what if the HBA does not support TCQ, but does
> support untagged command queueing, similar to ipr as described above?

They can override it in slave_configure.

It really does look like we should set tagged_supported if BQUE *or*
CMDQUE is set, independent of any queue_depth setting.

Things are messy in this area, we use scsi-2/SPI based variable names
(simple_tags, tagged_supported, tcq), that don't apply to newer transports.
We should use task attributes, not tag/untagged.

And not combine task attributes with tag management. That is FCP and ipr
don't need cmd->request->tag, they don't need the data setup by
blk_queue_start_tag().

Also for emulex/lpfc, cmd->tag is set before we have even set
request->tag, and neither of those include task attributes. cmd->tag
should be deleted.

> Additionally, ipr is currently relying on the fact that TCQ does not
> get enabled by default. It lets userspace code enable it after verifying
> the mode page settings of the drive for things like qerr, which the adapter
> firmware has dependencies on.
> 
> Brian

-- Patrick Mansfield
