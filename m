From: "Seokmann Ju" <seokmann.ju@qlogic.com>
Subject: RE: [PATCH RFC] qla2xxx: fix timeout in qla2x00_down_timeout
Date: Wed, 30 May 2007 04:25:32 -0700
Message-ID: <A6970E9A290F3F4682E1EAD0EA14F32B0108CA30@AVEXCH2.qlogic.org>
References: <20070530081643.GA29004@nostromo.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch2.qlogic.com ([198.70.193.116]:6507 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576AbXE3Lkl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 May 2007 07:40:41 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20070530081643.GA29004@nostromo.devel.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bill Nottingham <notting@redhat.com>, linux-scsi@vger.kernel.org
Cc: Linux Driver <Linux-Driver@qlogic.com>, linux-kernel@vger.kernel.org

Thanks for finding. 
Acked-by: Seokmann Ju <seokmann.ju@qlogic.com>

> -----Original Message-----
> From: Bill Nottingham [mailto:notting@redhat.com] 
> Sent: Wednesday, May 30, 2007 1:17 AM
> To: linux-scsi@vger.kernel.org
> Cc: Linux Driver; linux-kernel@vger.kernel.org
> Subject: [PATCH RFC] qla2xxx: fix timeout in qla2x00_down_timeout
> 
> iterations is unsigned, so it is impossible to get out of the 
> loop and return -ETIMEDOUT.
> 
> Signed-off-by: Bill Nottingham <notting@redhat.com>
> 
> ---
> 
> If the intention *is* to never fall out of the end of the 
> loop, ignore this, and just replace it with do {} while (1);.
> 
> --- drivers/scsi/qla2xxx/qla_os.c.foo	2007-05-30 
> 04:07:52.000000000 -0400
> +++ drivers/scsi/qla2xxx/qla_os.c	2007-05-30 
> 04:08:31.000000000 -0400
> @@ -2587,15 +2587,15 @@ qla2x00_down_timeout(struct semaphore *s
>  	unsigned int iterations = jiffies_to_msecs(timeout)/100;
>  
>  	do {
>  		if (!down_trylock(sema))
>  			return 0;
>  		if (msleep_interruptible(step))
>  			break;
> -	} while (--iterations >= 0);
> +	} while (--iterations > 0);
>  
>  	return -ETIMEDOUT;
>  }
>  
>  /* Firmware interface routines. */
>  
>  #define FW_BLOBS	5
> 
