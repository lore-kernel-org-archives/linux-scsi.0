From: brace@beardog.cca.cpqcorp.net
Subject: Problems adding/removing scsi devices.
Date: Thu, 28 Aug 2008 12:46:23 -0500
Message-ID: <20080828174623.GA3611@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0015.houston.hp.com ([15.201.24.18]:20861 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755225AbYH1RqZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Aug 2008 13:46:25 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, fujita.tomonori@lab.ntt.co.jp

I am having problems with my scsi driver. There is an application that issues
configuration changes to my driver to add/remove scsi devices. 

I am having a problem with the following sequence:
	1) Add a drive. 
	2) Remove the drive.
	3) Add the drive back.

The first two work correctly, the third works, but the drive's sdev_state is 
set to SDEV_DEL and can no longer be managed.

To delete the scsi_device, The driver does the following:

struct scsi_device *sdev = scsi_device_lookup(sh, removed[i].bus, 
					removed[i].target,removed[i].lun);
if (sdev != NULL) {
	scsi_remove_device(sdev);
	scsi_device_put(sdev);
}

Later on that application adds a scsi_device. (Using the same bus, target, 
and lun as before).

rc = scsi_add_device(sh, added[i].bus, added[i].target, added[i].lun);
if (rc == 0) {
	printk(DRIVERNAME "%d: shost[%p] added b%dt%dl%d\n", h->ctlr_num, sh,
				added[i].bus, added[i].target, added[i].lun);
	struct scsi_device *sdev = scsi_device_lookup(sh, added[i].bus, 
						added[i].target, added[i].lun);
	printk(DRIVERNAME "%d: shost[%p] looked up sdev[%p]\n", h->ctlr_num,sh,sdev);
	continue;
}

The scsi_device_lookup() call after the scsi_device_add() fails because the 
scsi_device.sdev_state is set to SDEV_DEL. 

I added code to scsi_add_device() and printed out the state just before the 
return statement, it is SDEV_RUNNING. After returning back to my driver, the 
scsi_device.sdev_state is set to SDEV_DEL. 

int scsi_add_device(struct Scsi_Host *host,                     rc = scsi_add_device(sh, added[i].bus,
                    uint channel, uint target, uint lun)                           added[i].target, added[i].lun);
{                                                               ==>// Here the state is SDEV_DEL.

	struct scsi_device *sdev = __scsi_add_device(host, 
                                                     channel, 
                                                     target, 
                                                     lun, NULL); 
	if (IS_ERR(sdev)) 
		return PTR_ERR(sdev); 
		scsi_device_put(sdev); 
		printk("sdev[%p] state = %04x\n", sdev.sdev_state); <===== Here is is running.
	return 0;
}

Can you not add, remove, and add the same bus, target, lun?
