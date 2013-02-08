From: Joe Lawrence <Joe.Lawrence@stratus.com>
Subject: Re: [PATCH v8 0/10] More device removal fixes
Date: Fri, 8 Feb 2013 18:29:07 -0500 (EST)
Message-ID: <alpine.DEB.2.02.1302081813170.13267@jlaw-desktop.mno.stratus.com>
References: <5110FE98.8030209@acm.org> <alpine.DEB.2.02.1302061727030.11804@jlaw-desktop.mno.stratus.com> <5113910D.2060100@acm.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub.stratus.com ([134.111.1.18]:56815 "EHLO
	mailhub5.stratus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1947302Ab3BHXdW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Feb 2013 18:33:22 -0500
In-Reply-To: <5113910D.2060100@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Joe Lawrence <Joe.Lawrence@stratus.com>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>, David Milburn <dmilburn@redhat.com>

On Thu, 7 Feb 2013, Bart Van Assche wrote:

> On 02/06/13 23:31, Joe Lawrence wrote:
> > crash> list scsi_device.siblings -H 0xffff8808513a4290 -s scsi_device
> > 
> > ffff880851232520
> > struct scsi_device {
> >    is_visible = 0x1,
> >    sdev_state = SDEV_DEL,
> > }
> > ffff880851235388
> > struct scsi_device {
> >    is_visible = 0x1,
> >    sdev_state = SDEV_DEL,
> > }
> 
> This is interesting. This probably means that one or more threads got stuck in
> __scsi_remove_device(). If you still have the crash dump available it would be
> appreciated if you could verify whether this is correct. If so, there might be
> an issue in the mpt2sas driver where scsi_done() does not get invoked for all
> outstanding commands after a surprise removal.

Hi Bart,

I haven't had time to rerun the test without the two patches that wait in 
scsi_remove_host(), however I did rerun the test and verify the same 
behavior as in my earlier mail.  I didn't see any __scsi_remove_device() 
instances running.

Some more investigation revealed that MD RAID was holding a reference to 
the removed device.  (In short, mdadm --remove had failed and left the 
device as a faulty member of the array.)  When I did finally manage to 
kick that disk from the MD device, scsi host/device removal continued to 
completion as expected.  

There's a bit more context to the MD situation that I'll post to the raid 
list once I get the details together for Neil.  I will CC you if you are 
interested in following.

Regards,

-- Joe
