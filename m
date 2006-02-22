From: "Hammer, Jack" <Jack_Hammer@adaptec.com>
Subject: RE: [PATCH] don't call ips_eh_reset in ips_queue to avoid deadlock
Date: Wed, 22 Feb 2006 09:41:08 -0500
Message-ID: <A121ABA5B472B74EB59076B8E3C8F01901E521B8@rtpe2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:6819 "EHLO
	mail-gw3.adaptec.com") by vger.kernel.org with ESMTP
	id S1751295AbWBVOlJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Feb 2006 09:41:09 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org


The only place this can occur ( an ioctl reset ) is from the ServeRAID
bootable CD, which is a 2.4 kernel, which explains why this has not been
a problem and would be impossible for you to test, even if you had
hardware.

It appears to be a technically correct patch. I concur - please apply
this patch.

Thanks Mike.

Jack Hammer
Adaptec



-----Original Message-----
From: Mike Christie [mailto:michaelc@cs.wisc.edu] 
Sent: Wednesday, February 22, 2006 3:12 AM
To: linux-scsi@vger.kernel.org; Hammer, Jack
Subject: [PATCH] don't call ips_eh_reset in ips_queue to avoid deadlock

When the locking was changed in the eh code ips_eh_reset was changed so
that it was a wraper around __ips_eh_reset and all ips_eh_reset does is
grab the host lock and then calls __ips_eh_reset.

In the queuecommand, ips_queue is called with the host_lock held so if
it calls ips_eh_reset we will have a problem. This patch just has
ips_queue call __ips_eh_reset.

Patch is only compile tested. I do not have the HW.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

--- linux-2.6.16-rc4/drivers/scsi/ips.c	2006-02-17 16:23:45.000000000
-0600
+++ linux-2.6.16-rc4.work/drivers/scsi/ips.c	2006-02-22
01:51:39.000000000 -0600
@@ -1146,7 +1146,7 @@ ips_queue(Scsi_Cmnd * SC, void (*done) (
 				return (0);
 			}
 			ha->ioctl_reset = 1;	/* This reset request is
from an IOCTL */
-			ips_eh_reset(SC);
+			__ips_eh_reset(SC);
 			SC->result = DID_OK << 16;
 			SC->scsi_done(SC);
 			return (0);



