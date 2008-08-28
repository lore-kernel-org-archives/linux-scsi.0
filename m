From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Problems adding/removing scsi devices.
Date: Thu, 28 Aug 2008 13:11:44 -0500
Message-ID: <1219947104.3378.9.camel@localhost.localdomain>
References: <20080828174623.GA3611@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:43872 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753377AbYH1SLp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Aug 2008 14:11:45 -0400
In-Reply-To: <20080828174623.GA3611@beardog.cca.cpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: brace@beardog.cca.cpqcorp.net
Cc: linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

On Thu, 2008-08-28 at 12:46 -0500, brace@beardog.cca.cpqcorp.net wrote:
> I am having problems with my scsi driver. There is an application that issues
> configuration changes to my driver to add/remove scsi devices. 
> 
> I am having a problem with the following sequence:
> 	1) Add a drive. 
> 	2) Remove the drive.
> 	3) Add the drive back.
> 
> The first two work correctly, the third works, but the drive's sdev_state is 
> set to SDEV_DEL and can no longer be managed.
> 
> To delete the scsi_device, The driver does the following:
> 
> struct scsi_device *sdev = scsi_device_lookup(sh, removed[i].bus, 
> 					removed[i].target,removed[i].lun);
> if (sdev != NULL) {
> 	scsi_remove_device(sdev);
> 	scsi_device_put(sdev);
> }
> 
> Later on that application adds a scsi_device. (Using the same bus, target, 
> and lun as before).
> 
> rc = scsi_add_device(sh, added[i].bus, added[i].target, added[i].lun);
> if (rc == 0) {
> 	printk(DRIVERNAME "%d: shost[%p] added b%dt%dl%d\n", h->ctlr_num, sh,
> 				added[i].bus, added[i].target, added[i].lun);
> 	struct scsi_device *sdev = scsi_device_lookup(sh, added[i].bus, 
> 						added[i].target, added[i].lun);
> 	printk(DRIVERNAME "%d: shost[%p] looked up sdev[%p]\n", h->ctlr_num,sh,sdev);
> 	continue;
> }
> 
> The scsi_device_lookup() call after the scsi_device_add() fails because the 
> scsi_device.sdev_state is set to SDEV_DEL. 

This means something else still has a reference to the old scsi device.
Until that reference is released, the old structure can't be garbage
collected and removed from the lists.

> I added code to scsi_add_device() and printed out the state just before the 
> return statement, it is SDEV_RUNNING. After returning back to my driver, the 
> scsi_device.sdev_state is set to SDEV_DEL. 
> 
> int scsi_add_device(struct Scsi_Host *host,                     rc = scsi_add_device(sh, added[i].bus,
>                     uint channel, uint target, uint lun)                           added[i].target, added[i].lun);
> {                                                               ==>// Here the state is SDEV_DEL.
> 
> 	struct scsi_device *sdev = __scsi_add_device(host, 
>                                                      channel, 
>                                                      target, 
>                                                      lun, NULL); 
> 	if (IS_ERR(sdev)) 
> 		return PTR_ERR(sdev); 
> 		scsi_device_put(sdev); 
> 		printk("sdev[%p] state = %04x\n", sdev.sdev_state); <===== Here is is running.
> 	return 0;
> }
> 
> Can you not add, remove, and add the same bus, target, lun?

Not and expect it to come back as the same device no.  This is the
essence of the reference counting problems in Linux:  we can't force
other things to give up object references, we can merely put the object
into a dead state and wait for all outstanding references to be
released.

There was a proposal to resurrect devices in SDEV_DEL, but it has quite
a few nasty corner cases.  I thought the replacement proposal was to
make scsi_device_lookup() skip over devices in SDEV_DEL (so it would
find the live one if one were in the list).

However, if, as I suspect, your outstanding reference is say a mounted
filesystem or other user space application, then you're out of luck if
you're expecting scsi_add_device() to magically reconnect the new device
to the filesystem.

James


