From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [patch 08/10]  scsi/dpt_i2o: replace
		schedule_timeout()withmsleep_interruptible()
Date: 24 Oct 2004 10:39:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1098628798.10908.19.camel@mulgrave>
References: <60807403EABEB443939A5A7AA8A7458B40B611@otce2k01.adaptec.com>
	<20041022232225.GA18906@us.ibm.com>  <20041024140343.GA23059@stro.at>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:2689 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261502AbUJXOkJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 24 Oct 2004 10:40:09 -0400
In-Reply-To: <20041024140343.GA23059@stro.at>
List-Id: linux-scsi@vger.kernel.org
To: maximilian attems <janitor@sternwelten.at>
Cc: Nishanth Aravamudan <nacc@us.ibm.com>, "Salyzyn, Mark" <mark_salyzyn@adaptec.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

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

