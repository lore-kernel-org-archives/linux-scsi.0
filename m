From: Willem Riede <osst@riede.org>
Subject: [PATCH] Re: no set_current_state() before schedule_timeout() (OSST)
Date: Tue, 13 Jul 2004 23:07:32 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1089760052l.26949l.0l@serve.riede.org>
References: <40F41EA6.9000900@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	Format=Flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rwcrmhc12.comcast.net ([216.148.227.85]:28593 "EHLO
	rwcrmhc12.comcast.net") by vger.kernel.org with ESMTP
	id S266924AbUGMWR0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Jul 2004 18:17:26 -0400
In-Reply-To: <40F41EA6.9000900@us.ibm.com> (from nacc@us.ibm.com on Tue, Jul
	13, 2004 at 13:40:54 -0400)
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: osst-users@lists.sourceforge.net, linux-scsi@vger.kernel.org, kernel-janitors@lists.osdl.org

On 07/13/2004 01:40:54 PM, Nishanth Aravamudan wrote:
> Hi,
> 
> In continuing to replace, where appropriate, code with msleep() calls, I
> ran across the following file(s) / function(s), which do not invoke
> set_current_state() before schedule_timeout(), which causes the latter
> to return immediately:
> 
> drivers/scsi/osst.c::osst_reposition_and_retry()
> 
> If someone could tell me which state (TASK_INTERRUPTIBLE or
> TASK_UNINTERRUPTIBLE) is desired, I can fix this and perhaps replace the
> calls with msleep().

You're right, there is a set_current_state(TASK_INTERRUPTIBLE) missing.
I don't know why we would want to change to use msleep() though.
Below is the patch to add the missing statement.

James Bottomley, can you apply this patch?

Regards, Willem Riede.

Signed-off-by: Willem Riede <osst@riede.org>

--- linux-2.6.8-rc1/drivers/scsi/osst.c.orig	2004-07-13
18:59:16.026349000 -0400
+++ linux-2.6.8-rc1/drivers/scsi/osst.c	2004-07-13 19:01:58.040719208
-0400
@@ -1555,6 +1555,7 @@
 			debugging = 0;
 		}
 #endif
+		set_current_state(TASK_INTERRUPTIBLE);
 		schedule_timeout(HZ / 10);
 	}
 	printk(KERN_ERR "%s:E: Failed to find valid tape media\n", name);


