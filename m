From: "Adam Radford" <aradford@amcc.com>
Subject: RE: [PATCH] 3ware 9000 driver update for 2.6.7-rc2-mm2
Date: Wed, 2 Jun 2004 16:21:03 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <HYPFK001.25G@hadar.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hadar.amcc.com ([192.195.69.168]:2540 "EHLO hadar.amcc.com")
	by vger.kernel.org with ESMTP id S265376AbUFBXVi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Jun 2004 19:21:38 -0400
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: akpm@osdl.org, james.bottomley@steeleye.com, linux-scsi@vger.kernel.org

Jeff,

Thanks for the feedback.

I will send a patch for the msleep() fix shortly.

As for your 'major' fix, I'm not sure what you mean.  The only thing
the driver does is set sht->can_queue to 254, then if the sht->queuecommand()
function sees the hardware is busy, it returns SCSI_MLQUEUE_HOST_BUSY.
The slave_configure() setting was removed.  Controller-wide queue count
is set from sht->can_queue to 254.

The 'pending' queue is only used for internal driver AEN posts and ioctls
in the case of 'queue busy', and I would like to leave it that way since 
I don't want to return -EBUSY for the ioctl routine or have the internal
AEN post 'not complete' due to the hardware being busy.  For these 2 cases,
I use the hardware's 'command interrupt' method for posting pending commands.


--
Adam Radford
Staff Software Engineer
AMCC

-----Original Message-----
From: Jeff Garzik [mailto:jgarzik@pobox.com]
Sent: Wednesday, June 02, 2004 3:54 PM
To: Adam Radford
Cc: akpm@osdl.org; james.bottomley@steeleye.com;
linux-scsi@vger.kernel.org
Subject: Re: [PATCH] 3ware 9000 driver update for 2.6.7-rc2-mm2


Adam Radford wrote:
> Andrew, James, 
> 
> This patch updates the 3w-9xxx driver in 2.6.7-rc2-mm1 to v2.26.02.000 to cleanup several things pointed out by Chris Hellwig / Jeff Garzik.


Looks good, one major and one minor grumble remain:

Minor:  Your schedule_timeout() usage is incorrect without also 
set_current_state() and a loop in certain situations.  However, the fix 
is quite easy:  just use the new msleep() function.  In your code, it 
should be a straight replacement from the mdelay() calls.


Major:  code still wastes time caring about queue depth when it need 
not.  Don't emulate this feature, export the feature as the hardware 
does -- using a controller-wide queue count, not per-device.  This would 
involve deleting the queue depth code and setting ->use_sg to 253, IIRC.

	Jeff



