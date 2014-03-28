From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: uas: Use GFP_NOIO rather then GFP_ATOMIC where possible
Date: Fri, 28 Mar 2014 11:08:11 +0300
Message-ID: <20140328080811.GE25192@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26333 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088AbaC1IId (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Mar 2014 04:08:33 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hdegoede@redhat.com
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net

Hello Hans de Goede,

The patch e36e64930cff: "uas: Use GFP_NOIO rather then GFP_ATOMIC
where possible" from Nov 7, 2013, leads to the following static
checker warning:

	drivers/usb/storage/uas.c:806 uas_eh_task_mgmt()
	error: scheduling with locks held: 'spin_lock:lock'

drivers/usb/storage/uas.c
   789          spin_lock_irqsave(&devinfo->lock, flags);
   790  
   791          if (devinfo->resetting) {
   792                  spin_unlock_irqrestore(&devinfo->lock, flags);
   793                  return FAILED;
   794          }
   795  
   796          if (devinfo->running_task) {
   797                  shost_printk(KERN_INFO, shost,
   798                               "%s: %s: error already running a task\n",
   799                               __func__, fname);
   800                  spin_unlock_irqrestore(&devinfo->lock, flags);
   801                  return FAILED;
   802          }
   803  
   804          devinfo->running_task = 1;
   805          memset(&devinfo->response, 0, sizeof(devinfo->response));
   806          sense_urb = uas_submit_sense_urb(cmnd, GFP_NOIO,
                                                       ^^^^^^^^
The original code had this as GFP_ATOMIC because we can't sleep while
we have spin_lock_irqsave() held.

   807                                           devinfo->use_streams ? tag : 0);
   808          if (!sense_urb) {
   809                  shost_printk(KERN_INFO, shost,
   810                               "%s: %s: submit sense urb failed\n",
   811                               __func__, fname);
   812                  devinfo->running_task = 0;
   813                  spin_unlock_irqrestore(&devinfo->lock, flags);
   814                  return FAILED;
   815          }
   816          if (uas_submit_task_urb(cmnd, GFP_NOIO, function, tag)) {
                                              ^^^^^^^^
Same.

   817                  shost_printk(KERN_INFO, shost,
   818                               "%s: %s: submit task mgmt urb failed\n",
   819                               __func__, fname);
   820                  devinfo->running_task = 0;
   821                  spin_unlock_irqrestore(&devinfo->lock, flags);
   822                  usb_kill_urb(sense_urb);
   823                  return FAILED;
   824          }
   825          spin_unlock_irqrestore(&devinfo->lock, flags);

regards,
dan carpenter
