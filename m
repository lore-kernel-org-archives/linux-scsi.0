From: Josef Bacik <jwhiter@redhat.com>
Subject: Re: [RFC][PATCH] fix for async scsi scan sysfs problem (resend)
Date: Thu, 19 Apr 2007 11:06:56 -0400
Message-ID: <20070419150655.GC1481@korben.rdu.redhat.com>
References: <20070419132459.GB1481@korben.rdu.redhat.com> <1176991356.31764.3.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:35690 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1766749AbXDSPFv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Apr 2007 11:05:51 -0400
Content-Disposition: inline
In-Reply-To: <1176991356.31764.3.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Josef Bacik <jwhiter@redhat.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Apr 19, 2007 at 10:02:36AM -0400, James Bottomley wrote:
> On Thu, 2007-04-19 at 09:25 -0400, Josef Bacik wrote:
> > Looking through everything I came to the conclusion that we don't really need
> > the scsi_sysfs_add_devices in scsi_finish_async_scan, which gets run everytime
> > we do a do_scan_async.  In doing the scanning, if we come upon anything we will
> > already be registering the device with sysfs so the scsi_sysfs_add_devices step
> > is kind of useless.
> 
> Unfortunately, it isn't.  The registration step while scanning is at the
> end of scsi_add_lun():
> 
> 
> 	if (!async && scsi_sysfs_add_sdev(sdev) != 0)
> 		return SCSI_SCAN_NO_RESPONSE;
> 
> 	return SCSI_SCAN_LUN_PRESENT;
> 
> The !async should mean that the addition *only* occurs for the non async
> scan case ... if you remove the post async scan add, we'll lose devices.
> 
> >   I tested this and it worked fine on my UP box (where the
> > problem was happening) and my SMP box (where the problem wasn't happening).  Now
> > I'm not entirely sure if this is correct, but I'm attaching the patch that I
> > used to fix it for me, please point out if I've done something wrong or if there
> > is a different way this needs to be fixed.  Thank you,
> 
> Could you add some debugging first to see if we're actually adding the
> device twice (and also, if we are, what the value of the async is).
>

Sorry I should have put that in the original post, I added debugging to
kobject_add to check to see if we were adding something twice, thats how I
figured out who was doing it

kobject rport-3:0-0: registering. parent: host3, set: devices
kobject rport-3:0-0: registering. parent: fc_remote_ports, set: class_obj
kobject target3:0:0: registering. parent: rport-3:0-0, set: devices
kobject rport-3:0-1: registering. parent: host3, set: devices
kobject rport-3:0-1: registering. parent: fc_remote_ports, set: class_obj
kobject target3:0:0: registering. parent: fc_transport, set: class_obj
kobject rport-3:0-2: registering. parent: host3, set: devices
kobject rport-3:0-2: registering. parent: fc_remote_ports, set: class_obj
kobject rport-3:0-3: registering. parent: host3, set: devices
kobject rport-3:0-3: registering. parent: fc_remote_ports, set: class_obj
kobject rport-3:0-4: registering. parent: host3, set: devices
kobject rport-3:0-4: registering. parent: fc_remote_ports, set: class_obj
kobject rport-3:0-5: registering. parent: host3, set: devices
kobject rport-3:0-5: registering. parent: fc_remote_ports, set: class_obj
kobject rport-3:0-6: registering. parent: host3, set: devices
kobject rport-3:0-6: registering. parent: fc_remote_ports, set: class_obj
kobject rport-3:0-7: registering. parent: host3, set: devices
kobject rport-3:0-7: registering. parent: fc_remote_ports, set: class_obj
>> kobject 3:0:0:0: registering. parent: target3:0:0, set: devices
kobject 3:0:0:0: registering. parent: scsi_device, set: class_obj
scsi 3:0:0:0: Direct-Access     IBM 1742-900         0520 PQ: 0 ANSI: 3
>> kobject 3:0:0:0: registering. parent: target3:0:0, set: devices
kobject_add failed for 3:0:0:0 with -EEXIST, don't try to register things with 
the same name in the same directory.

Async in the first case is set and in the second case it isn't set.  Thank you,

Josef 
