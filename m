From: Nishanth Aravamudan <nacc@us.ibm.com>
Subject: Re: [patch 08/10]  scsi/dpt_i2o: replace 	schedule_timeout()withmsleep_interruptible()
Date: Fri, 22 Oct 2004 16:22:25 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041022232225.GA18906@us.ibm.com>
References: <60807403EABEB443939A5A7AA8A7458B40B611@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.105]:14331 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S269210AbUJVXWN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Oct 2004 19:22:13 -0400
Content-Disposition: inline
In-Reply-To: <60807403EABEB443939A5A7AA8A7458B40B611@otce2k01.adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, janitor@sternwelten.at, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, Oct 21, 2004 at 10:11:31AM -0400, Salyzyn, Mark wrote:
> I have to speak in absence of the original author, but I believe the
> decision to conditionalize the unlock was because this routine is called
> at init time and at run time.
> 
> I did not notice the `stutter' of the two schedule_timeout's. Eeeeek!!!
> (My scientific replacement for bogus). Thanks for shaking the cobwebs.
> 
> The second schedule_timeout needs to be *removed*, it does not belong
> there at all!

Please find below a patch which does exactly this.

Description: Removes a schedule_timeout() from adpt_i2o_post_wait() whch
Mark Salyzyn requested be removed.

Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>


--- 2.6.9-bk7-vanilla/drivers/scsi/dpt_i2o.c	2004-10-22 10:41:29.000000000 -0700
+++ 2.6.9-bk7/drivers/scsi/dpt_i2o.c	2004-10-22 15:22:53.000000000 -0700
@@ -1179,7 +1179,6 @@ static int adpt_i2o_post_wait(adpt_hba* 
 				// dangerous.
 				status = -ETIME;
 			}
-			schedule_timeout(timeout*HZ);
 		}
 		if(pHba->host)
 			spin_lock_irq(pHba->host->host_lock);
