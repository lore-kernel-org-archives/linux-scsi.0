From: Anish Bhatt <anish@chelsio.com>
Subject: RE: [PATCH] csiostor:Fix backwards locking in the function
 __csio_unreg_rnode
Date: Fri, 4 Sep 2015 22:44:17 +0000
Message-ID: <525DB349B3FB5444AE057A887CB2A8D893E43743@nice.asicdesigners.com>
References: <1441300143-1143-1-git-send-email-xerofoify@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1441300143-1143-1-git-send-email-xerofoify@gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Nicholas Krause <xerofoify@gmail.com>, "JBottomley@odin.com" <JBottomley@odin.com>, Praveen Madhavan <praveenm@chelsio.com>
Cc: "hare@suse.de" <hare@suse.de>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, "davem@davemloft.net" <davem@davemloft.net>, Hariprasad S <hariprasad@chelsio.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


> -----Original Message-----
> From: Nicholas Krause [mailto:xerofoify@gmail.com]
> Sent: Thursday, September 3, 2015 10:09 AM
> To: JBottomley@odin.com
> Cc: hare@suse.de; michaelc@cs.wisc.edu; davem@davemloft.net; Anish
> Bhatt; Hariprasad S; linux-scsi@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Subject: [PATCH] csiostor:Fix backwards locking in the function
> __csio_unreg_rnode
> 
> This fixes backwards locking in the function __csio_unreg_rnode to properly
> lock before the call to the function csio_unreg_rnode and not unlock with
> spin_unlock_irq as this would not allow the proper protection for concurrent
> access on the shared csio_hw structure pointer hw. In addition switch the
> locking after the critical region function call to properly unlock instead with
> spin_unlock_irq on the shared structure pointer.
> 
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> ---
>  drivers/scsi/csiostor/csio_rnode.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/csiostor/csio_rnode.c
> b/drivers/scsi/csiostor/csio_rnode.c
> index e9c3b04..029a09e 100644
> --- a/drivers/scsi/csiostor/csio_rnode.c
> +++ b/drivers/scsi/csiostor/csio_rnode.c
> @@ -580,9 +580,9 @@ __csio_unreg_rnode(struct csio_rnode *rn)
>  		ln->last_scan_ntgts--;
>  	}
> 
> -	spin_unlock_irq(&hw->lock);
> -	csio_unreg_rnode(rn);
>  	spin_lock_irq(&hw->lock);
> +	csio_unreg_rnode(rn);
> +	spin_unlock_irq(&hw->lock);
> 
>  	/* Cleanup I/Os that were waiting for rnode to unregister */
>  	if (cmpl)
> --
> 2.1.4

NACK, function is called with lock held.
