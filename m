From: Nishanth Aravamudan <nacc@us.ibm.com>
Subject: [UPDATE PATCH] scsi/osst: replace schedule_timeout() with msleep()
Date: Mon, 7 Mar 2005 15:05:22 -0800
Message-ID: <20050307230522.GD2778@us.ibm.com>
References: <20050306222742.294F71EC90@trashy.coderock.org> <1110148975l.5880l.4l@serve.riede.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from e5.ny.us.ibm.com ([32.97.182.145]:17116 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S261274AbVCGXF2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Mar 2005 18:05:28 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e5.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id j27N5ObL023213
	for <linux-scsi@vger.kernel.org>; Mon, 7 Mar 2005 18:05:24 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j27N5OWY070696
	for <linux-scsi@vger.kernel.org>; Mon, 7 Mar 2005 18:05:24 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11/8.12.11) with ESMTP id j27N5NtX023727
	for <linux-scsi@vger.kernel.org>; Mon, 7 Mar 2005 18:05:24 -0500
Content-Disposition: inline
In-Reply-To: <1110148975l.5880l.4l@serve.riede.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Willem Riede <osst@riede.org>
Cc: domen@coderock.org, linux-scsi@vger.kernel.org

On Sun, Mar 06, 2005 at 10:42:55PM +0000, Willem Riede wrote:
> On 03/06/2005 05:27:41 PM, domen@coderock.org wrote:
> > 
> > 
> > Use msleep() instead of schedule_timeout() to guarantee the task
> > delays as expected. Although TASK_INTERRUPTIBLE is used in the current code,
> > there is no code dealing with an early return / signals_pending().
> 
> This change is a total don't-care as far as I'm concerned. But if we are going to 
> make it, can we please be consistent? Does the "set_current_state(TASK_INTERRUPTIBLE)"
> stay or go? The two changes below don't agree in that respect.

You are completely correct. Please excuse the sloppy patch, fixed below.

Description: Use msleep() instead of schedule_timeout() to guarantee the
task delays as expected. Although TASK_INTERRUPTIBLE is used in the
current code, there is no code dealing with an early return / signals_pending().

Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>

--- 2.6.11-v/drivers/scsi/osst.c	2005-03-01 23:38:08.000000000 -0800
+++ 2.6.11/drivers/scsi/osst.c	2005-03-07 15:01:38.000000000 -0800
@@ -862,8 +862,7 @@ static int osst_recover_wait_frame(struc
 				retval = osst_write_error_recovery(STp, aSRpnt, 0);
 				break;
 			}
-			set_current_state(TASK_INTERRUPTIBLE);
-			schedule_timeout (HZ / OSST_POLL_PER_SEC);
+			msleep(1000 / OSST_POLL_PER_SEC);
 
 			STp->buffer->b_data = mybuf; STp->buffer->buffer_size = 24;
 			memset(cmd, 0, MAX_COMMAND_SIZE);
@@ -1558,8 +1557,7 @@ static int osst_reposition_and_retry(str
 			osst_set_frame_position(STp, aSRpnt, frame + skip, 1);
 			flag = 0;
 			attempts--;
-			set_current_state(TASK_INTERRUPTIBLE);
-			schedule_timeout(HZ / 10);
+			msleep(100);
 		}
 		if (osst_get_frame_position(STp, aSRpnt) < 0) {		/* additional write error */
 #if DEBUG
@@ -1620,8 +1618,7 @@ static int osst_reposition_and_retry(str
 			debugging = 0;
 		}
 #endif
-		set_current_state(TASK_INTERRUPTIBLE);
-		schedule_timeout(HZ / 10);
+		msleep(100);
 	}
 	printk(KERN_ERR "%s:E: Failed to find valid tape media\n", name);
 #if DEBUG
