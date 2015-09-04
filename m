From: Anish Bhatt <anish@chelsio.com>
Subject: RE: [PATCH] csiostor:Fix locking requirements for function call in
 the function csio_alloc_rnode
Date: Fri, 4 Sep 2015 22:46:32 +0000
Message-ID: <525DB349B3FB5444AE057A887CB2A8D893E4376C@nice.asicdesigners.com>
References: <1441302252-30973-1-git-send-email-xerofoify@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1441302252-30973-1-git-send-email-xerofoify@gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Nicholas Krause <xerofoify@gmail.com>, "JBottomley@odin.com" <JBottomley@odin.com>
Cc: "hare@suse.de" <hare@suse.de>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, "davem@davemloft.net" <davem@davemloft.net>, Hariprasad S <hariprasad@chelsio.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

> -----Original Message-----
> From: Nicholas Krause [mailto:xerofoify@gmail.com]
> Sent: Thursday, September 3, 2015 10:44 AM
> To: JBottomley@odin.com
> Cc: hare@suse.de; michaelc@cs.wisc.edu; davem@davemloft.net; Anish
> Bhatt; Hariprasad S; linux-scsi@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Subject: [PATCH] csiostor:Fix locking requirements for function call in the
> function csio_alloc_rnode
> 
> This fixes locking requirements for the function call to the function
> csio_rnode_init to properly lock and disable irqs before calling this function
> with spin_lock_irq on the structure pointer hw of type csio_hw and unlocking
> after the function call with spin_unlock_irq in order to prevent concurrent
> access on the shared structure pointer hw of type csio_hw with other
> threads of execution accessing this structure
> 
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> ---
>  drivers/scsi/csiostor/csio_rnode.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/csiostor/csio_rnode.c
> b/drivers/scsi/csiostor/csio_rnode.c
> index e9c3b04..85635f4 100644
> --- a/drivers/scsi/csiostor/csio_rnode.c
> +++ b/drivers/scsi/csiostor/csio_rnode.c
> @@ -222,9 +222,13 @@ csio_alloc_rnode(struct csio_lnode *ln)
>  		goto err;
> 
>  	memset(rn, 0, sizeof(struct csio_rnode));
> -	if (csio_rnode_init(rn, ln))
> +	spin_lock_irq(&hw->lock);
> +	if (csio_rnode_init(rn, ln)) {
> +		spin_unlock_irq(&hw->lock);
>  		goto err_free;
> -
> +	}
> +
> +	spin_unlock_irq(&hw->lock);
>  	CSIO_INC_STATS(ln, n_rnode_alloc);
> 
>  	return rn;
> --
> 2.1.4

NACK. Function called from csio_fcoe_fwevt_handler() with lock held.
