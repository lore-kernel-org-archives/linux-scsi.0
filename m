From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH] aacraid: Initialize rx/rkt function pointers before calling them
Date: Fri, 27 Apr 2007 08:46:58 -0400
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF018FD83A@otce2k301.adaptec.com>
References: <46312E81.7030600@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:42047 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755776AbXD0MrA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Apr 2007 08:47:00 -0400
Content-class: urn:content-classes:message
In-Reply-To: <46312E81.7030600@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>, linux-scsi@vger.kernel.org
Cc: Alexis Bruemmer <alexisb@us.ibm.com>

Reject, this is already covered in aacraid_kexec_5.patch and again
separately in aacraid_kexec_fix.patch.

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: Darrick J. Wong [mailto:djwong@us.ibm.com] 
> Sent: Thursday, April 26, 2007 6:58 PM
> To: linux-scsi@vger.kernel.org
> Cc: Salyzyn, Mark; Alexis Bruemmer
> Subject: [PATCH] aacraid: Initialize rx/rkt function pointers 
> before calling them
> 
> 
> Commit 8418852d11f0bbaeebeedd4243560d8fdc85410d to scsi-misc 
> resulted in
> the substitution of calls to rx_sync_cmd with a function pointer
> abstraction.  aac_rx_restart_adapter requires a pointer to a sync_cmd
> function, which is not set up before its first invocation.  
> That causes
> the driver to crash at startup.  Move the initializers (we need both
> rx_sync_cmd and enable_int pointers) further up to proceed the
> restart_adapter call.
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> ---
> 
>  drivers/scsi/aacraid/rx.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/aacraid/rx.c b/drivers/scsi/aacraid/rx.c
> index 0c71315..b7810d6 100644
> --- a/drivers/scsi/aacraid/rx.c
> +++ b/drivers/scsi/aacraid/rx.c
> @@ -537,6 +537,8 @@ int _aac_rx_init(struct aac_dev *dev)
>  		printk(KERN_WARNING "%s: unable to map 
> adapter.\n", name);
>  		goto error_iounmap;
>  	}
> +	dev->a_ops.adapter_sync_cmd = rx_sync_cmd;
> +	aac_adapter_comm(dev, AAC_COMM_PRODUCER);
>  
>  	/* Failure to reset here is an option ... */
>  	dev->OIMR = status = rx_readb (dev, MUnit.OIMR);
> @@ -598,7 +600,6 @@ int _aac_rx_init(struct aac_dev *dev)
>  	dev->a_ops.adapter_interrupt = aac_rx_interrupt_adapter;
>  	dev->a_ops.adapter_disable_int = aac_rx_disable_interrupt;
>  	dev->a_ops.adapter_notify = aac_rx_notify_adapter;
> -	dev->a_ops.adapter_sync_cmd = rx_sync_cmd;
>  	dev->a_ops.adapter_check_health = aac_rx_check_health;
>  	dev->a_ops.adapter_restart = aac_rx_restart_adapter;
>  
> @@ -606,7 +607,6 @@ int _aac_rx_init(struct aac_dev *dev)
>  	 *	First clear out all interrupts.  Then enable 
> the one's that we
>  	 *	can handle.
>  	 */
> -	aac_adapter_comm(dev, AAC_COMM_PRODUCER);
>  	aac_adapter_disable_int(dev);
>  	rx_writel(dev, MUnit.ODR, 0xffffffff);
>  	aac_adapter_enable_int(dev);
> 
