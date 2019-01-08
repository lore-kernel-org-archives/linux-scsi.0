From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] scsi: isci: initialize shost fully before calling
 scsi_add_host()
Date: Tue, 8 Jan 2019 14:30:36 -0700
Message-ID: <0d986fa7-b510-07d0-02bd-cf4da11fd84e@kernel.dk>
References: <20190108205043.3122-1-logang@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190108205043.3122-1-logang@deltatee.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Logan Gunthorpe <logang@deltatee.com>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Intel SCU Linux support <intel-linux-scu@intel.com>, Artur Paszkiewicz <artur.paszkiewicz@intel.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Jeff Moyer <jmoyer@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On 1/8/19 1:50 PM, Logan Gunthorpe wrote:
> scsi_mq_setup_tags(), which is called by scsi_add_host(), calculates
> the command size to allocate based on the prot_capabilities. In the
> isci driver, scsi_host_set_prot() is called after scsi_add_host()
> so the command size gets calculated to be smaller than it needs to be.
> Eventually, scsi_mq_init_request() locates the 'prot_sdb' after the command
> assuming it was sized correctly and a buffer overrun may occur.
> 
> However, seeing blk_mq_alloc_rqs() rounds up to the nearest cache line
> size, the mistake can go unnoticed.
> 
> The bug was noticed after the struct request size was reduced by
> commit 9d037ad707ed ("block: remove req->timeout_list")
> 
> Which likely reduced the allocated space for the request by an entire
> cache line, enough that the overflow could be hit and it caused a panic,
> on boot, at:
> 
>   RIP: 0010:t10_pi_complete+0x77/0x1c0
>   Call Trace:
>     <IRQ>
>     sd_done+0xf5/0x340
>     scsi_finish_command+0xc3/0x120
>     blk_done_softirq+0x83/0xb0
>     __do_softirq+0xa1/0x2e6
>     irq_exit+0xbc/0xd0
>     call_function_single_interrupt+0xf/0x20
>     </IRQ>
> 
> sd_done() would call scsi_prot_sg_count() which reads the number of
> entities in 'prot_sdb', but seeing 'prot_sdb' is located after the end of
> the allocated space it reads a garbage number and erroneously calls
> t10_pi_complete().
> 
> To prevent this, the calls to scsi_host_set_prot() are moved into
> isci_host_alloc() before the call to scsi_add_host(). Out of caution,
> also move the similar call to scsi_host_set_guard().

Nice work!

Reviewed-by: Jens Axboe <axboe@kernel.dk>

-- 
Jens Axboe
