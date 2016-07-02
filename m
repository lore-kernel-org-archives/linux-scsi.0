From: Luis de Bethencourt <luisbg@osg.samsung.com>
Subject: Re: [PATCHv3] mvsas:Fix possible NULL pointer deference in mvs_dev_found_notify
Date: Sat, 02 Jul 2016 19:16:40 +0100
Message-ID: <57780508.3030200@osg.samsung.com>
References: <1467478843-16315-1-git-send-email-xerofoify@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1467478843-16315-1-git-send-email-xerofoify@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nicholas Krause <xerofoify@gmail.com>, jejb@linux.vnet.ibm.com
Cc: martin.petersen@oracle.co, tj@kernel.org, James.Bottomley@HansenPartnership.com, hare@suse.de, jthumshirn@suse.de, Wilfried.Weissmann@gmx.a, davispuh@gmail.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 02/07/16 18:00, Nicholas Krause wrote:
> This adds properly checking after the call to mvs_find_dev_mvi
>  due to this function being able to return a NULL pointer and
> if this does arise we will deference it in mvs_alloc_dev due
> to this function never checking if a NULL pointer is given as
> it's input argument. Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> ---
> v3 - Make logic simpler on error path by returning -1 directly
> if mvs_find_dev_mvi returns NULL.
> v2 - Fix NULL pointer deferenece in error path by calling 
> spin_unlock_irqrestore on the now NULL pointer, as returned
> 
> 
>  drivers/scsi/mvsas/mv_sas.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
> index 5b9fcff..dffab01 100644
> --- a/drivers/scsi/mvsas/mv_sas.c
> +++ b/drivers/scsi/mvsas/mv_sas.c
> @@ -1194,6 +1194,8 @@ int mvs_dev_found_notify(struct domain_device *dev, int lock)
>  	struct mvs_device *mvi_device;
>  
>  	mvi = mvs_find_dev_mvi(dev);
> +	if (!mvi)
> +		return -1;
>  
>  	if (lock)
>  		spin_lock_irqsave(&mvi->lock, flags);
> 

This looks better :)

Checking the value of mvi makes sense if mvs_find_dev_mvi() can return NULL.

Reviewed-by: Luis de Bethencourt <luisbg@osg.samsung.com>

Thanks,
Luis
