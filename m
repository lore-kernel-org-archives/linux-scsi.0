From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [patch 08/10]  scsi/dpt_i2o: replace	schedule_timeout()withmsleep_interruptible()
Date: Mon, 25 Oct 2004 07:30:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <60807403EABEB443939A5A7AA8A7458B40B9B3@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:63191 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S261395AbUJYLao convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Oct 2004 07:30:44 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, maximilian attems <janitor@sternwelten.at>
Cc: Nishanth Aravamudan <nacc@us.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>


Not quite ... The value of 0 is meant to trigger never timing out on the
request (#define FOREVER (0) in dpti.h). The code change you have will
mean that the code will immediately timeout, not the intent.

There is a wakeup to the thread issued by the interrupt via a WAIT
QUEUE, if the sequence of TASK_INTERRUPTIBLE/schedule() did not work, it
would not explain the successful operation of the driver during
initialization time.

At this point, I like the simpler patch from Nishanth Aravamudan :-)

Sincerely -- Mark Salyzyn

-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@SteelEye.com] 
Sent: Sunday, October 24, 2004 10:40 AM
To: maximilian attems
Cc: Nishanth Aravamudan; Salyzyn, Mark; SCSI Mailing List
Subject: Re: [patch 08/10] scsi/dpt_i2o: replace
schedule_timeout()withmsleep_interruptible()

On Sun, 2004-10-24 at 10:03, maximilian attems wrote:
> this patch seems already applied in 2.6.10-rc1.
> please double check.

I don't think it is.  However we're not finished with shaking the
cobwebs out of this routine yet.

This:

               set_current_state(TASK_INTERRUPTIBLE);
		[...]
                if (!timeout)
                        schedule();
 
Would sleep forever if timeout were zero because nothing ever seems to
shift the task back into TASK_RUNNING (i.e. wake it up).

Anyway, I think the attached looks to be the best way to fix all the
issues.

James

===== include/linux/delay.h 1.6 vs edited =====
--- 1.6/include/linux/delay.h	2004-09-03 05:08:32 -04:00
+++ edited/include/linux/delay.h	2004-10-24 10:38:09 -04:00
@@ -46,4 +46,12 @@
 	msleep(seconds * 1000);
 }
 
+static inline unsigned long ssleep_interruptible(unsigned int seconds)
+{
+	unsigned long ret = msleep_interruptible(seconds * 1000);
+	/* Round up to seconds for return (i.e 0.001s remaining
+	 * becomes 1s) */
+	return ret/1000 + (ret ? 1 : 0);
+}
+
 #endif /* defined(_LINUX_DELAY_H) */
===== drivers/scsi/dpt_i2o.c 1.44 vs edited =====
--- 1.44/drivers/scsi/dpt_i2o.c	2004-07-26 18:03:34 -04:00
+++ edited/drivers/scsi/dpt_i2o.c	2004-10-24 10:34:17 -04:00
@@ -1164,22 +1164,14 @@
 	spin_unlock(&adpt_wq_i2o_post.lock);
 
 	msg[2] |= 0x80000000 | ((u32)wait_data->id);
-	timeout *= HZ;
 	if((status = adpt_i2o_post_this(pHba, msg, len)) == 0){
-		set_current_state(TASK_INTERRUPTIBLE);
 		if(pHba->host)
 			spin_unlock_irq(pHba->host->host_lock);
-		if (!timeout)
-			schedule();
-		else{
-			timeout = schedule_timeout(timeout);
-			if (timeout == 0) {
-				// I/O issued, but cannot get result in
-				// specified time. Freeing resorces is
-				// dangerous.
-				status = -ETIME;
-			}
-			schedule_timeout(timeout*HZ);
+		if (ssleep_interruptible(timeout)) {
+			// I/O issued, but cannot get result in
+			// specified time. Freeing resorces is
+			// dangerous.
+			status = -ETIME;
 		}
 		if(pHba->host)
 			spin_lock_irq(pHba->host->host_lock);

