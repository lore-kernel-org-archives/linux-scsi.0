From: Brian King <brking@us.ibm.com>
Subject: Re: [PATCH] ibmvscsi driver - next version
Date: Mon, 23 Feb 2004 14:52:50 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <403A6822.2040700@us.ibm.com>
References: <opr3s2iefyl6e53g@us.ibm.com> <20040223144542.A9624@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.104]:8169 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S261958AbUBWUxS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Feb 2004 15:53:18 -0500
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Boutcher <sleddog@us.ibm.com>, linux-scsi@vger.kernel.org

Christoph Hellwig wrote:

> +	found_evt = NULL;
> +	spin_lock_irqsave(&hostdata->lock, flags);
> +	if(!list_empty(&hostdata->sent)) {
> +		list_for_each_safe(pos, next, &hostdata->sent) {
> +			tmp_evt = list_entry(pos, struct srp_event_struct, list);
> +			
> +			if (tmp_evt->cmnd == cmd) {
> +				found_evt = tmp_evt;
> +				break;
> +			}
> +		}
> +	}
> +	spin_unlock_irqrestore(&hostdata->lock, flags);
> +	
> +	/* If we can't find this event, just return false */
> +	if (found_evt == NULL) {
> +		printk(KERN_ERR "ibmvscsi: failed to abort command\n");
> +		return FAILED;
> +	}
> 
> 	This can't ever happen.  You will only get called for commands
> 	that you have accepted in queuecommand and not called the completion
> 	routine for.

I'm not sure I agree with this statement. Looking at scsi_error.c, it looks
to me like there is a race condition in that the midlayer decides whether or
not to abort an op, then grabs the host lock, then calls eh_abort. From the
time that the midlayer decides to abort an op and then grabs the host lock, the
op may have finished. The LLD should return SUCCESS in this scenario, however,
rather than FAILED.



-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

