From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 6/7] aic94xx: use bitops
Date: Thu, 8 Jun 2006 13:28:16 +0100
Message-ID: <20060608122816.GB9865@infradead.org>
References: <1149637920.25278.81.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:18589 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751318AbWFHM2R (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Jun 2006 08:28:17 -0400
Content-Disposition: inline
In-Reply-To: <1149637920.25278.81.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alexis Bruemmer <alexisb@us.ibm.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

>  	spin_lock_irqsave(lock, flags);
> -	if (*pending & (1 << event)) {
> +	if (test_bit(event, pending)) {
>  		spin_unlock_irqrestore(lock, flags);
>  		return;
>  	}
> -	*pending |= (1 << event);
> +	__set_bit(event, pending);
>  	spin_unlock_irqrestore(lock, flags);
>  	scsi_queue_work(shost, work);
>  }
>  
> -static inline void sas_begin_event(int event, spinlock_t *lock, u32 *pending)
> +static inline void sas_begin_event(int event, spinlock_t *lock, 
> +				   unsigned long *pending)
>  {
>  	unsigned long flags;
>  
>  	spin_lock_irqsave(lock, flags);
> -	*pending &= ~(1 << event);
> +	__clear_bit(event, pending);
>  	spin_unlock_irqrestore(lock, flags);
>  }

What else does the spinlock protect?  By using test_and_set_bit/clear_bit
you could get rid of them unless it's needed elsewhere.
