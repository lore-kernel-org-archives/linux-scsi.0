From: Lee Duncan <lduncan@suse.com>
Subject: Re: [PATCH] Fix a memory leak in scsi_host_dev_release()
Date: Tue, 24 Nov 2015 15:10:41 -0800
Message-ID: <5654EE71.70504@suse.com>
References: <564D0224.9040001@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48661 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754143AbbKXXLN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Nov 2015 18:11:13 -0500
In-Reply-To: <564D0224.9040001@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 11/18/2015 02:56 PM, Bart Van Assche wrote:
> Avoid that kmemleak reports the following memory leak if a
> SCSI LLD calls scsi_host_alloc() and scsi_host_put() but neither
> scsi_host_add() nor scsi_host_remove(). The following shell
> command triggers that scenario:
> 
> for ((i=0; i<2; i++)); do
>   srp_daemon -oac |
>   while read line; do
>     echo $line >/sys/class/infiniband_srp/srp-mlx4_0-1/add_target
>   done
> done
> 
> unreferenced object 0xffff88021b24a220 (size 8):
>   comm "srp_daemon", pid 56421, jiffies 4295006762 (age 4240.750s)
>   hex dump (first 8 bytes):
>     68 6f 73 74 35 38 00 a5                          host58..
>   backtrace:
>     [<ffffffff8151014a>] kmemleak_alloc+0x7a/0xc0
>     [<ffffffff81165c1e>] __kmalloc_track_caller+0xfe/0x160
>     [<ffffffff81260d2b>] kvasprintf+0x5b/0x90
>     [<ffffffff81260e2d>] kvasprintf_const+0x8d/0xb0
>     [<ffffffff81254b0c>] kobject_set_name_vargs+0x3c/0xa0
>     [<ffffffff81337e3c>] dev_set_name+0x3c/0x40
>     [<ffffffff81355757>] scsi_host_alloc+0x327/0x4b0
>     [<ffffffffa03edc8e>] srp_create_target+0x4e/0x8a0 [ib_srp]
>     [<ffffffff8133778b>] dev_attr_store+0x1b/0x20
>     [<ffffffff811f27fa>] sysfs_kf_write+0x4a/0x60
>     [<ffffffff811f1e8e>] kernfs_fop_write+0x14e/0x180
>     [<ffffffff81176eef>] __vfs_write+0x2f/0xf0
>     [<ffffffff811771e4>] vfs_write+0xa4/0x100
>     [<ffffffff81177c64>] SyS_write+0x54/0xc0
>     [<ffffffff8151b257>] entry_SYSCALL_64_fastpath+0x12/0x6f
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: stable <stable@vger.kernel.org>
> ---
>  drivers/scsi/hosts.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index 323982f..82ac1cd 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -333,6 +333,17 @@ static void scsi_host_dev_release(struct device *dev)
>  		kfree(queuedata);
>  	}
>  
> +	if (shost->shost_state == SHOST_CREATED) {
> +		/*
> +		 * Free the shost_dev device name here if scsi_host_alloc()
> +		 * and scsi_host_put() have been called but neither
> +		 * scsi_host_add() nor scsi_host_remove() has been called.
> +		 * This avoids that the memory allocated for the shost_dev
> +		 * name is leaked.
> +		 */
> +		kfree(dev_name(&shost->shost_dev));
> +	}
> +
>  	scsi_destroy_command_freelist(shost);
>  	if (shost_use_blk_mq(shost)) {
>  		if (shost->tag_set.tags)
> 

Reviewed-by: Lee Duncan <lduncan@suse.com>
