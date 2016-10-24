From: "Ewan D. Milne" <emilne@redhat.com>
Subject: Re: [PATCH v3 1/6] scsi: fnic: use kernel's '%pM' format option to
 print MAC
Date: Mon, 24 Oct 2016 08:29:17 -0400
Message-ID: <1477312157.17595.0.camel@localhost.localdomain>
References: <20161022173231.170417-1-andriy.shevchenko@linux.intel.com>
         <20161022173231.170417-2-andriy.shevchenko@linux.intel.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52274 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934831AbcJXM3T (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 24 Oct 2016 08:29:19 -0400
In-Reply-To: <20161022173231.170417-2-andriy.shevchenko@linux.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Hiral Patel <hiralpat@cisco.com>, Suma Ramars <sramars@cisco.com>

On Sat, 2016-10-22 at 20:32 +0300, Andy Shevchenko wrote:
> Instead of supplying each byte through stack let's use %pM specifier.
> 
> Cc: Hiral Patel <hiralpat@cisco.com>
> Cc: Suma Ramars <sramars@cisco.com>
> Acked-by: Tom Tucker <tom@opengridcomputing.com>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/scsi/fnic/vnic_dev.c | 10 ++--------
>  1 file changed, 2 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/scsi/fnic/vnic_dev.c b/drivers/scsi/fnic/vnic_dev.c
> index 9795d6f..ba69d61 100644
> --- a/drivers/scsi/fnic/vnic_dev.c
> +++ b/drivers/scsi/fnic/vnic_dev.c
> @@ -499,10 +499,7 @@ void vnic_dev_add_addr(struct vnic_dev *vdev, u8 *addr)
>  
>  	err = vnic_dev_cmd(vdev, CMD_ADDR_ADD, &a0, &a1, wait);
>  	if (err)
> -		printk(KERN_ERR
> -			"Can't add addr [%02x:%02x:%02x:%02x:%02x:%02x], %d\n",
> -			addr[0], addr[1], addr[2], addr[3], addr[4], addr[5],
> -			err);
> +		pr_err("Can't add addr [%pM], %d\n", addr, err);
>  }
>  
>  void vnic_dev_del_addr(struct vnic_dev *vdev, u8 *addr)
> @@ -517,10 +514,7 @@ void vnic_dev_del_addr(struct vnic_dev *vdev, u8 *addr)
>  
>  	err = vnic_dev_cmd(vdev, CMD_ADDR_DEL, &a0, &a1, wait);
>  	if (err)
> -		printk(KERN_ERR
> -			"Can't del addr [%02x:%02x:%02x:%02x:%02x:%02x], %d\n",
> -			addr[0], addr[1], addr[2], addr[3], addr[4], addr[5],
> -			err);
> +		pr_err("Can't del addr [%pM], %d\n", addr, err);
>  }
>  
>  int vnic_dev_notify_set(struct vnic_dev *vdev, u16 intr)

Reviewed-by: Ewan D. Milne <emilne@redhat.com>


