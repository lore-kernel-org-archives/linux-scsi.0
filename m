From: Brian King <brking@us.ibm.com>
Subject: Re: [RFC] IBM Power RAID driver (ipr)
Date: Fri, 16 Jan 2004 17:46:37 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <400877DD.1020408@us.ibm.com>
References: <40085EDA.4010802@us.ibm.com> <20040116230118.GP734@actcom.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.103]:61910 "EHLO e3.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S265794AbUAPXql (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Jan 2004 18:46:41 -0500
List-Id: linux-scsi@vger.kernel.org
To: Muli Ben-Yehuda <mulix@mulix.org>
Cc: linux-scsi@vger.kernel.org

Muli Ben-Yehuda wrote:
> Hi, I took a look and I have some comments / questions. I will try to
> go over all of it in the next few days, but here's what I went over so
> far: 

Thanks!

>>+static int ipr_unsafe = 1;		/* xxx set to 0 for ship */
> 
> 
> Should it be set to 0 or to 1 for inclusion in the kernel? any driver
> that is first included is considered experimental, so just how unsafe
> is ipr_unsafe?

Perhaps this is poorly named. If you take a look at ipr_invalid_adapter,
you will see how ipr_unsafe is used. If set to 1, then it will allow 
certain adapters to run in systems which have known problems.

>>+static void ipr_sleep_no_lock(signed long delay)
>>+{
>>+	DECLARE_WAIT_QUEUE_HEAD(internal_wait);
>>+
>>+	sleep_on_timeout(&internal_wait, (delay * HZ) / 1000);
>>+	return;
> 
> 
> just a nitpick, but the Linux coding style says no 'return' from void
> functions. 

Done.

>>+static void ipr_sleep(struct ipr_ioa_cfg *ioa_cfg, signed long delay)
>>+{
>>+	spin_unlock_irq(ioa_cfg->host->host_lock);
>>+	ipr_sleep_no_lock(delay);
>>+	spin_lock_irq(ioa_cfg->host->host_lock);
> 
> 
> Hmpf... it's called from ipr_diagnostic_ioctl(), which does
> spin_lock_irqsave()
> ipr_sleep()
> spin_unlock_irqrestore()
> 
> So I guess you really do intend to enable interrupts before going to
> sleep? it's somewhat fragile... also, is the dropping and
> reacquisition of the lock safe here (in the sense that none of the
> data the lock is protecting that we care about can change while the
> lock is not held?)

I certainly don't want to go to sleep with interrupts masked. I need to 
wait a second and then check to see if some shared data has changed, so 
I am actually counting on the data protected by the spinlock being able 
to change. I can certainly remove ipr_sleep since it is only used in the 
one spot now and

> Same questions wrt ipr_interruptible_sleep_on(), which does the same
> thing. By the way, ipr_dump_ioctl does not check the return value from
> ipr_interruptible_sleep_on(). If this is intentional, perhaps call it
> using (void)ipr_interruptible_sleep_on()?

Yes. It checks the sdt_state, which is sufficient. I will add the (void).


>>+static void ipr_block_requests(struct ipr_ioa_cfg *ioa_cfg)
>>+{
>>+	ENTER;
>>+
>>+	if (0 == ioa_cfg->block_host_ops++) {
>>+	   ioa_cfg->allow_cmds = 0;
> 
> 
> This is racy unless a lock is held. I think a lock is held here in all
> callers of this function, but a comment to that effect would be nice
> before the function. This also applies to every other function which
> either must be called with a lock taken, or modifies the "locking
> status" - takes a lock which is released elsewhere, enables interrupts
> unconditionally, etc. 

Yes, the host lock must be held by the caller. I can certainly add the 
comments you suggest as well.


> +static void ipr_unblock_requests(struct ipr_ioa_cfg *ioa_cfg)
> +{
> +	ENTER;
> +
> +	if (0 == --ioa_cfg->block_host_ops) {
> +	   ioa_cfg->allow_cmds = 1;
> +	   spin_unlock_irq(ioa_cfg->host->host_lock);
> +	   scsi_unblock_requests(ioa_cfg->host);
> +	   spin_lock_irq(ioa_cfg->host->host_lock);
> 
> Eeek! What happens if on another CPU a call comes in that does
> ipr_block_requests() after the lock is released and before it is taken
> again?

Looks like I have other issues with the block/unblock interfaces as 
well. I'll clean this up.


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

