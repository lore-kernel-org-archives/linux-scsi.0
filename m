From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: Re: [PATCH 1/2] mpt2sas: Refcount sas_device objects and fix unsafe
 list usage
Date: Mon, 13 Jul 2015 11:05:09 -0400
Message-ID: <55A3D3A5.6090005@stratus.com>
References: <1433821856-2815280-1-git-send-email-calvinowens@fb.com> <1436675096-324527-1-git-send-email-calvinowens@fb.com> <1436675096-324527-2-git-send-email-calvinowens@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1436675096-324527-2-git-send-email-calvinowens@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Calvin Owens <calvinowens@fb.com>, Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>
Cc: MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Christoph Hellwig <hch@infradead.org>, Bart Van Assche <bart.vanassche@sandisk.com>
List-Id: linux-scsi@vger.kernel.org

On 07/12/2015 12:24 AM, Calvin Owens wrote:
> These objects can be referenced concurrently throughout the driver, we
> need a way to make sure threads can't delete them out from under each
> other. This patch adds the refcount, and refactors the code to use it.
> 
> Additionally, we cannot iterate over the sas_device_list without
> holding the lock, or we risk corrupting random memory if items are
> added or deleted as we iterate. This patch refactors _scsih_probe_sas()
> to use the sas_device_list in a safe way.
> 
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: Bart Van Assche <bart.vanassche@sandisk.com>
> Signed-off-by: Calvin Owens <calvinowens@fb.com>
> ---
>  drivers/scsi/mpt2sas/mpt2sas_base.h      |  22 +-
>  drivers/scsi/mpt2sas/mpt2sas_scsih.c     | 434 ++++++++++++++++++++-----------
>  drivers/scsi/mpt2sas/mpt2sas_transport.c |  12 +-
>  3 files changed, 315 insertions(+), 153 deletions(-)

[ ... snip ... ]

> @@ -2078,7 +2150,7 @@ _scsih_slave_configure(struct scsi_device *sdev)
>  	}
>  
>  	spin_lock_irqsave(&ioc->sas_device_lock, flags);
> -	sas_device = mpt2sas_scsih_sas_device_find_by_sas_address(ioc,
> +	sas_device = __mpt2sas_get_sdev_by_addr(ioc,
>  	   sas_device_priv_data->sas_target->sas_address);
>  	if (!sas_device) {
>  		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
> @@ -2116,13 +2188,14 @@ _scsih_slave_configure(struct scsi_device *sdev)
>  	if (!ssp_target)
>  		_scsih_display_sata_capabilities(ioc, handle, sdev);
>  
> -
>  	_scsih_change_queue_depth(sdev, qdepth);
>  
>  	if (ssp_target) {
>  		sas_read_port_mode_page(sdev);
>  		_scsih_enable_tlr(ioc, sdev);
>  	}
> +
> +	sas_device_put(sas_device);
>  	return 0;
>  }

Hi Calvin,

Any reason why this sas_device_put is placed outside the sas_device
lock?  Most other instances in this patch were called just before unlocking.

BTW I attempted testing, but needed to port to mpt3 and ended up with a
driver that didn't boot :(   Hopefully I can retry later this week, or
find an older mpt2 box lying around.

-- Joe
