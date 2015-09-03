From: Anish Bhatt <anish@chelsio.com>
Subject: RE: [PATCH] csiostor:Fix locking issues in the function
 csio_scsim_cleanup_io_lnode
Date: Thu, 3 Sep 2015 01:37:13 +0000
Message-ID: <525DB349B3FB5444AE057A887CB2A8D893E417F9@nice.asicdesigners.com>
References: <1441215365-27112-1-git-send-email-xerofoify@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1441215365-27112-1-git-send-email-xerofoify@gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Nicholas Krause <xerofoify@gmail.com>, "JBottomley@odin.com" <JBottomley@odin.com>
Cc: "hare@suse.de" <hare@suse.de>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, "davem@davemloft.net" <davem@davemloft.net>, Hariprasad S <hariprasad@chelsio.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

> -----Original Message-----
> From: Nicholas Krause [mailto:xerofoify@gmail.com]
> Sent: Wednesday, September 2, 2015 10:36 AM
> To: JBottomley@odin.com
> Cc: hare@suse.de; michaelc@cs.wisc.edu; davem@davemloft.net; Anish
> Bhatt; Hariprasad S; linux-scsi@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Subject: [PATCH] csiostor:Fix locking issues in the function
> csio_scsim_cleanup_io_lnode
> 
> This fixes locking issues in the function csio_scsim_cleanup_io_lnode by
> locking around the call to the function csio_csci_gather_active_ios with the
> function pair spin_lock_irq/spin_unlock_irq as any function calling this
> particular function must do in order to avoid concurrent threads of execution
> on the passed structure pointer of type csio_hw as this structure pointer can
> be shared across mutliple threads in the kernel.
> 
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> ---
>  drivers/scsi/csiostor/csio_scsi.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/scsi/csiostor/csio_scsi.c b/drivers/scsi/csiostor/csio_scsi.c
> index 2c4562d..c318855 100644
> --- a/drivers/scsi/csiostor/csio_scsi.c
> +++ b/drivers/scsi/csiostor/csio_scsi.c
> @@ -1327,7 +1327,9 @@ csio_scsim_cleanup_io_lnode(struct csio_scsim
> *scm, struct csio_lnode *ln)
>  	sld.level = CSIO_LEV_LNODE;
>  	sld.lnode = ln;
>  	INIT_LIST_HEAD(&ln->cmpl_q);
> +	spin_lock_irq(&hw->lock);
>  	csio_scsi_gather_active_ios(scm, &sld, &ln->cmpl_q);
> +	spin_unlock_irq(&hw->lock);
> 
>  	/* No I/Os pending on this lnode  */
>  	if (list_empty(&ln->cmpl_q))
> --
> 2.1.4

Acked-By:  Anish Bhatt <anish@chelsio.com>
