From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH] don't call ips_eh_reset in ips_queue to avoid deadlock
Date: Wed, 22 Feb 2006 02:11:59 -0600
Message-ID: <1140595919.3945.2.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:63168 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S932300AbWBVIMJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Feb 2006 03:12:09 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, jack_hammer@adaptec.com

When the locking was changed in the eh code ips_eh_reset was changed
so that it was a wraper around __ips_eh_reset and all ips_eh_reset
does is grab the host lock and then calls __ips_eh_reset.

In the queuecommand, ips_queue is called with the host_lock held so if
it calls ips_eh_reset we will have a problem. This patch just has
ips_queue call __ips_eh_reset.

Patch is only compile tested. I do not have the HW.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

--- linux-2.6.16-rc4/drivers/scsi/ips.c	2006-02-17 16:23:45.000000000 -0600
+++ linux-2.6.16-rc4.work/drivers/scsi/ips.c	2006-02-22 01:51:39.000000000 -0600
@@ -1146,7 +1146,7 @@ ips_queue(Scsi_Cmnd * SC, void (*done) (
 				return (0);
 			}
 			ha->ioctl_reset = 1;	/* This reset request is from an IOCTL */
-			ips_eh_reset(SC);
+			__ips_eh_reset(SC);
 			SC->result = DID_OK << 16;
 			SC->scsi_done(SC);
 			return (0);


