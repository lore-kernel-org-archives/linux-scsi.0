From: "Miller, Mike (OS Dev)" <mike.miller@hp.com>
Subject: FW: [patch 1/1] block/cciss: replace schedule_timeout() with msleep()
Date: Mon, 7 Mar 2005 08:59:04 -0600
Message-ID: <D4CFB69C345C394284E4B78B876C1CF107DC036F@cceexc23.americas.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Received: from ccerelbas01.cce.hp.com ([161.114.21.104]:28591 "EHLO
	ccerelbas01.cce.hp.com") by vger.kernel.org with ESMTP
	id S261534AbVCGO7Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Mar 2005 09:59:16 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@osdl.org, axboe@suse.de
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, nacc@us.ibm.com, domen@coderock.org

> -----Original Message-----
> From: domen@coderock.org [mailto:domen@coderock.org] 
> Sent: Saturday, March 05, 2005 4:45 PM
> To: Miller, Mike (OS Dev)
> Cc: ISS StorageDev; domen@coderock.org; nacc@us.ibm.com
> Subject: [patch 1/1] block/cciss: replace schedule_timeout() 
> with msleep()
> 
> 
> 
> 
> I used msleep(10) here under the presumption that the 
> schedule_timeout(1) was written assuming that HZ=100 (as it 
> used to be), which is equivalent to 10 milliseconds. If the 
> desire is actually for 1 ms or the minimal sleep interval, 
> then the patch can be changed appropriately. A similar 
> assumption as to the constant delay value was made in the 
> other replacement, which can also be appropriately adjusted.
> 
> Change the delay logic in pollcomplete() to use msleep() and 
> time_before(). Instead of assuming schedule_timeout() will 
> sleep exactly as requested, use msleep(10) to guarantee 
> minimally 10 millisecond increments and
> time_before() to guarantee stopping the loop as close to 20 
> seconds as possible.
> Also changes another occurrence of schedule_timeout() to msleep().
> TASK_INTERRUPTIBLE is used in this case, but signals are not handled. 
> 
> Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
> Acked-by: Mike Miller <mike.miller@hp.com>
> Signed-off-by: Domen Puncer <domen@coderock.org>

Please consider the following patch for inclusion.

Thanks,
mikem 


 ---
 
 
  kj-domen/drivers/block/cciss.c |   17 +++++++----------
  1 files changed, 7 insertions(+), 10 deletions(-)
 
 diff -puN drivers/block/cciss.c~msleep-drivers_block_cciss 
 drivers/block/cciss.c
 --- kj/drivers/block/cciss.c~msleep-drivers_block_cciss	
 2005-03-05 16:10:44.000000000 +0100
 +++ kj-domen/drivers/block/cciss.c	2005-03-05 
 16:10:44.000000000 +0100
 @@ -1702,17 +1702,15 @@ static int cciss_revalidate(struct 
 gendi  static unsigned long pollcomplete(int ctlr)  {
  	unsigned long done;
 -	int i;
 +	unsigned long end_jiffies = jiffies + 20 * HZ;
  
  	/* Wait (up to 20 seconds) for a command to complete */
 -
 -	for (i = 20 * HZ; i > 0; i--) {
 +	while (time_before(jiffies,end_jiffies)) {
  		done = hba[ctlr]->access.command_completed(hba[ctlr]);
 -		if (done == FIFO_EMPTY) {
 -			set_current_state(TASK_UNINTERRUPTIBLE);
 -			schedule_timeout(1);
 -		} else
 -			return (done);
 +		if (done == FIFO_EMPTY)
 +			msleep(10);
 +		else
 +			return done;
  	}
  	/* Invalid address to tell caller we ran out of time */
  	return 1;
 @@ -2486,8 +2484,7 @@ static int cciss_pci_init(ctlr_info_t *c
  		if (!(readl(c->vaddr + SA5_DOORBELL) & 
 CFGTBL_ChangeReq))
  			break;
  		/* delay and try again */
 -		set_current_state(TASK_INTERRUPTIBLE);
 -		schedule_timeout(10);
 +		msleep(100);
  	}	
  
  #ifdef CCISS_DEBUG
 _
 
