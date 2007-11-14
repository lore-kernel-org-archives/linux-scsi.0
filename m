From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: how to handle QUEUE_FULL/SAM_STAT_TASK_SET_FULL in userspace?
Date: Wed, 14 Nov 2007 15:45:06 -0700
Message-ID: <664A4EBB07F29743873A87CF62C26D70B3443F@NAMAIL4.ad.lsil.com>
References: <473B2F07.8060908@nortel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:64541 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751615AbXKNWpa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Nov 2007 17:45:30 -0500
Content-class: urn:content-classes:message
In-Reply-To: <473B2F07.8060908@nortel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chris Friesen <cfriesen@nortel.com>
Cc: "Stephens, Larry" <Larry.Stephens@lsi.com>, linux-scsi@vger.kernel.org, dgilbert@interlog.com, James.Bottomley@SteelEye.com, DL-MPT Fusion Linux <DL-MPTFusionLinux@lsi.com>

On Wednesday, November 14, 2007 10:23 AM, Chris Friesen wrote: 
> > QUEUE_FULL and SAM_STAT_TASK_SET_FULL are not errors.
> 
> I consider them errors in the same way that ENOMEM or ENOBUFS 
> (or even 
> EAGAIN) are errors.  "There is a shortage of resources and 
> the command 
> could not be completed, please try again later."
> 
> Also, the behaviour has changed from 2.6.10 with the 3.01.18 fusion 
> driver, to 2.6.14 with the 3.02.57 fusion driver.
> 
> With 2.6.10 our user app never saw SAM_STAT_TASK_SET_FULL.  I 
> suspect it 
> is due to the fact that it's using a queue size of 7, while in 2.6.14 
> it's using a queue size of 32 or 64.
> 
> Which kernel version is behaving properly?

You already figured out the problem, I don't understand why your asking
if the kernel verison is behaving properly.   You said between those
driver versions the device queue depth increased from 32 to 64, and that
is exactly what happened.   The reason for the increase is some customer
ask for the increase queue_depth which helps with performance. We are
not going to decrease it back.

> 
> I've asked seagate what the queue size should be for that 
> hardware, but 
> haven't heard back yet.
> 
> > SAM_STAT_TASK_SET_FULL returned for the target that handle 
> the number of
> > commands, and QUEUE_FULL returned from hba firmware meaning 
> its can't
> > handle the number of commands.  Translated, the commands 
> are retried by
> > scsiml.    I probably should be calling scsi_track_queue_full which
> > would be throttling the command back, however I'm not sure 
> whether it
> > matters.
> 
> We have a userspace app calling ioctl(...SG_IO...) on /dev/sdX and 
> occasionally getting a status of SAM_STAT_TASK_SET_FULL.  I may be 
> misreading the code, but it doesn't appear that the midlayer 
> is retrying 
> these commands.
> 
> If the queue length in 2.6.14 is correct then how do I handle that 
> status code?  Maybe delay a bit then retry a few times?  How 
> much delay? 
>    How many retries?
> 

SAM_STAT_TASK_SET_FULL in /usr/src/linux/scsi/scsi.h, is the same as
QUEUE_FULL.  If you look in scsi_error.c searching for QUEUE_FULL, you
will see that it will translate to ADD_TO_MLQUEUE, which means it will
reposted to the request queue.      Ultimately, calling
scsi_track_queue_full would help by reducing the queue_depth on the fly,
however I'm not sure if that is there in the older kernels your running.
What I suggest you do is write a script to update the queue_depth to the
values youre wanting.

Example
#  echo 32 > /sys/class/scsi_device/0:0:0:0/device/queue_depth




