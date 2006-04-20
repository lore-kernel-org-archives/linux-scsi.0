From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: qla2xxx lock ordering question
Date: Thu, 20 Apr 2006 16:46:06 -0700
Message-ID: <20060420234606.GO8514@andrew-vasquezs-powerbook-g4-15.local>
References: <1145438524.3085.19.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:2874 "EHLO avexch02.qlogic.com")
	by vger.kernel.org with ESMTP id S1751288AbWDTXqM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Apr 2006 19:46:12 -0400
Content-Disposition: inline
In-Reply-To: <1145438524.3085.19.camel@laptopd505.fenrus.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: mingo@elte.hu, linux-scsi@vger.kernel.org

On Wed, 19 Apr 2006, Arjan van de Ven wrote:

> a question about qla2xxx lock ordering since it trips up with Ingo's
> lock depenceny tool:
> 
> in qla2x00_mailbox_command() the code first grabs the mbx_reg_lock lock,
> then the hardware_lock. So far so good. But then...
> it drops the mbx_reg_lock, does stuff, and regrabs the mbx_reg_lock
> lock, while keeping the hardware_lock held!
> 
> This appears to be an AB-BA deadlock risk since for the second part you
> are taking the locks in the wrong order... or am I missing something
> here?

Actually the code is a bit convoluted, but I believe we are OK.  There
are two scenarios we need to consider:

   abort_active == 0 && io_lock_on == 1:

	- mbx_reg_lock is acquired:

		...
		/* Try to get mailbox register access */
		if (!abort_active)
			spin_lock_irqsave(&ha->mbx_reg_lock, mbx_flags);

	- hardware_lock is acquired

		...
		DEBUG11(printk("scsi(%ld): prepare to issue mbox cmd=0x%x.\n",
		   ha->host_no, mcp->mb[0]);)

		spin_lock_irqsave(&ha->hardware_lock, flags);

	- hardware_lock is relinquished:

		...
		/* Wait for mbx cmd completion until timeout */

		if (!abort_active && io_lock_on) {
			...
			if (IS_QLA24XX(ha) || IS_QLA54XX(ha))
				WRT_REG_DWORD(&reg->isp24.hccr, HCCRX_SET_HOST_INT);
			else
				WRT_REG_WORD(&reg->isp.hccr, HCCR_SET_HOST_INT);
			spin_unlock_irqrestore(&ha->hardware_lock, flags);

	- mbx_reg_lock is relinquished:

			if (!abort_active)
				spin_unlock_irqrestore(&ha->mbx_reg_lock, mbx_flags);
			...

	- mbx_reg_lock is acquired:

			...
		}

		if (!abort_active)
			spin_lock_irqsave(&ha->mbx_reg_lock, mbx_flags);

	- mbx_reg_lock is relinquished:

		...
		if (!abort_active)
			spin_unlock_irqrestore(&ha->mbx_reg_lock, mbx_flags);

and the second:

   abort_active == 1 && io_lock_on == DONT_CARE:

	- hardware_lock is acquired

		...
		DEBUG11(printk("scsi(%ld): prepare to issue mbox cmd=0x%x.\n",
		   ha->host_no, mcp->mb[0]);)

		spin_lock_irqsave(&ha->hardware_lock, flags);

	- hardware_lock is relinquished:

		...
		/* Wait for mbx cmd completion until timeout */

		if (!abort_active && io_lock_on) {
			...
		} else {
			DEBUG3_11(printk("%s(%ld): cmd=%x POLLING MODE.\n", __func__,
			    ha->host_no, command);)

			if (IS_QLA24XX(ha) || IS_QLA54XX(ha))
				WRT_REG_DWORD(&reg->isp24.hccr, HCCRX_SET_HOST_INT);
			else
				WRT_REG_WORD(&reg->isp.hccr, HCCR_SET_HOST_INT);
			spin_unlock_irqrestore(&ha->hardware_lock, flags);

> Greetings,
>    Arjan van de Ven

Not pretty, I had to looks at this several times as well...

-- 
AV
