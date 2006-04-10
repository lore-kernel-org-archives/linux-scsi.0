From: Brian King <brking@us.ibm.com>
Subject: Re: command queueing cmd_per_lun, queue_depth and tags
Date: Mon, 10 Apr 2006 15:04:47 -0500
Message-ID: <443ABA5F.9010306@us.ibm.com>
References: <20060407214954.GA4990@us.ibm.com> <4436E7C8.5030204@us.ibm.com> <20060410185919.GA15124@us.ibm.com>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:46309 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S932100AbWDJUEv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Apr 2006 16:04:51 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e1.ny.us.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k3AK4pQC011433
	for <linux-scsi@vger.kernel.org>; Mon, 10 Apr 2006 16:04:51 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VER6.8) with ESMTP id k3AK4pIm219370
	for <linux-scsi@vger.kernel.org>; Mon, 10 Apr 2006 16:04:51 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11/8.13.3) with ESMTP id k3AK4oRB028205
	for <linux-scsi@vger.kernel.org>; Mon, 10 Apr 2006 16:04:50 -0400
In-Reply-To: <20060410185919.GA15124@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

Patrick Mansfield wrote:
> On Fri, Apr 07, 2006 at 05:29:28PM -0500, Brian King wrote:
>> Patrick Mansfield wrote:
>>> Currently cmd_per_lun is the default queue depth for both tagged and
>>> untagged queueing. That is, if the LLDD does not modify queue_depth in its
>>> slave_configure, queue_depth will be set to cmd_per_lun, no matter what
>>> the command queueing/tag support. 
>>>
>>> If we don't allow queueing in the LLDD, and cmd_per_lun is supposed to be
>>> the default depth for untagged support, shouldn't it always be 1, and
>>> hence go away? 
>> This seems to assume there are no SCSI devices which do command queuing, but do
>> not support queue tags. This is not the case.
> 
> I should not have used "untagged", that is misleading and a problem with
> current scsi core, where we reference tcq, tags, and don't seem to mention
> task attributes.
> 
> But LLDD can override anything in slave_configure.

I guess my biggest problem with this part of the patch is that it prevents an
LLDD that wants this behavior from being able to use scsi_adjust_queue_depth
to set the queue depth, whether it be in slave_configure, change_queue_depth, etc.

> Also, it looks like we could safely use cmd_per_lun as the default
> queue_depth, rather than setting it to 1 as done in my previous
> post/patch.

Ok. If we do that and also allow scsi_adjust_queue_depth
to adjust the queue depth when tagged == 0, as is allowed today,
then I think most of my objections to the patch should disappear,
although it may require me to make a couple ipr changes.

>>> Similarily, why do some LLDD's use a cmd_per_lun of 3, or (like
>>> ncr53c8xx_slave_configure) set queue_depth for !tagged_supported to
>>> anything other than 1?
>> In the case of ipr, there are two scenarios. The first is for JBOD disks.
>> I use a default queue depth of 6 in ipr. When running untagged, with a queue depth
>> of > 1, the ipr adapter firmware then maintains a queue, guaranteeing only
>> one command will be outstanding to the device at once. This lower level
>> queue allows for a faster turnaround of commands and improved performance.
>> The second case is that of RAID arrays. These show up as logical scsi disks.
>> They support command queueing, but not tagged command queueing.
> 
> So you just want the task attibutes, and don't care about tag management
> (i.e. you don't ever use cmd->request->tags)? That is similar to FCP.

Correct. The ipr adapter firmware generates its own queue tags before sending
tagged commands to the device. 

>>> I know (at least) FCP can always do simple queueing, but I don't think
>>> scsi core should allow multiple commands to be sent if the device does not
>>> have CMDQUE (or BQUE).
>> This will break both of the working scenarios I described above for ipr
>> and performance will suffer significantly. The inquiry data for ipr RAID
>> arrays does not set either CMDQUE or BQUE.
> 
> Sounds like they are sort of SCSI-2 compliant, that is allowed there but
> mentioned as obsolete in current SCSI-3 (spc3r23.pdf).
> 
> The LLDD can override the queue_depth for these cases.

Agreed, but my first comment applies here as well.

>>> Also we don't even check the BQUE in the INQUIRY result (byte 6, bit 7).
>>> Should this be changed? That is set tagged_supported if BQUE is set, like
>>> we do for CMDQUE (byte 7 bit 1). And also set simple_tags if
>>> tagged_supported is set.
>> I don't like the idea of always enabling TCQ in scsi core simply if
>> the device supports it. What if the HBA does not support it? To make
>> matters more interesting, what if the HBA does not support TCQ, but does
>> support untagged command queueing, similar to ipr as described above?
> 
> They can override it in slave_configure.

Sure. I could add a scsi_deactivate_tcq in slave_configure.


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
