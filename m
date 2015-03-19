From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH] scsi: fnic: use kernel's '%pM' format option to print
 MAC
Date: Thu, 19 Mar 2015 19:54:02 +0200
Message-ID: <1426787642.14897.375.camel@linux.intel.com>
References: <1398782723-13433-1-git-send-email-andriy.shevchenko@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:44617 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750905AbbCSRyG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Mar 2015 13:54:06 -0400
In-Reply-To: <1398782723-13433-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Hiral Patel <hiralpat@cisco.com>, Tom Tucker <tom@opengridcomputing.com>, Steve Wise <swise@opengridcomputing.com>, linux-rdma@vger.kernel.org

On Tue, 2014-04-29 at 17:45 +0300, Andy Shevchenko wrote:
> Instead of supplying each byte through stack let's use %pM specifier.

Anyone to comment or apply this patch?

> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: Tom Tucker <tom@opengridcomputing.com>
> Cc: Steve Wise <swise@opengridcomputing.com>
> Cc: linux-rdma@vger.kernel.org
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


-- 
Andy Shevchenko <andriy.shevchenko@intel.com>
Intel Finland Oy

