From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [patch 08/10]  scsi/dpt_i2o: replace 	schedule_timeout()
	withmsleep_interruptible()
Date: 21 Oct 2004 09:47:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1098366441.1716.12.camel@mulgrave>
References: <60807403EABEB443939A5A7AA8A7458B40B5E9@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:45727 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S267362AbUJUNrd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Oct 2004 09:47:33 -0400
In-Reply-To: <60807403EABEB443939A5A7AA8A7458B40B5E9@otce2k01.adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: janitor@sternwelten.at, SCSI Mailing List <linux-scsi@vger.kernel.org>, nacc@us.ibm.com

On Thu, 2004-10-21 at 09:17, Salyzyn, Mark wrote:
> The driver does set the state to TASK_INTERRUPTIBLE a handful of lines
> above, is there some other state that the driver should have set?

No, it should be set to TASK_[UN]INTERRUPTIBLE.  However, you can't just
do it once.  When the schedule_timeout() returns, the state is once more
TASK_RUNNING.  If you want to do another schedule_timeout() like you're
doing in this case, you have to set it to TASK_[UN]INTERRUPTIBLE again.

> We should remove the set_current_state(TASK_INTERRUPTIBLE) line when
> replacing with the msleep_interruptible(timeout * 1000) line.

Actually, the whole thing:

	if((status = adpt_i2o_post_this(pHba, msg, len)) == 0){
		set_current_state(TASK_INTERRUPTIBLE);
		if(pHba->host)
			spin_unlock_irq(pHba->host->host_lock);
		if (!timeout)
			schedule();
		else{
			timeout = schedule_timeout(timeout);
			if (timeout == 0) {
				// I/O issued, but cannot get result in
				// specified time. Freeing resorces is
				// dangerous.
				status = -ETIME;
			}
			schedule_timeout(timeout*HZ);
		}
		if(pHba->host)
			spin_lock_irq(pHba->host->host_lock);
	}

Looks a bit bogus.  Are the conditional spinlocks really necesary? Why
is timeout multiplied by HZ in the second case, but not in the first
case?  The only reason why timeout would be non-zero in the first
schedule timeout would be if the sleep were interrupted.

James


