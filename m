From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [bug report] [SCSI] mvumi: GFP_KERNEL under spin lock
Date: Fri, 28 Sep 2012 14:30:22 +0300
Message-ID: <20120928113022.GW13767@mwanda>
References: <20120814145926.GA29090@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120814145926.GA29090@elgon.mountain>
Sender: linux-kernel-owner@vger.kernel.org
To: jyli@marvell.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Whatever happened with this?  You could just change the GFP_KERNEL
to GFP_ATOMIC.

regards,
dan carpenter

On Tue, Aug 14, 2012 at 05:59:27PM +0300, Dan Carpenter wrote:
> Hello Jianyun Li,
> 
> The patch f0c568a478f0: "[SCSI] mvumi: Add Marvell UMI driver" from 
> May 11, 2011, leads to the following warning:
> drivers/scsi/mvumi.c:121 mvumi_alloc_mem_resource()
> 	 error: scheduling with locks held: 'spin_lock:host_lock'
> 
> The problem is that we do a couple GPF_KERNEL allocations in
> mvumi_alloc_mem_resource() and this static analysis program sees a path
> where that function is called with spin_locks held.
> 
> mvumi_isr_handler() <- takes a spin lock
> -> mvumi_handshake()
>    -> mvumi_init_data()
>       -> mvumi_alloc_mem_resource() <- GFP_KERNEL
> 
> The IRQ handler does print a warning before calling mvumi_handshake()
> so it seems like this path doesn't get exercised very much.
> 
> regards,
> dan carpenter
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
