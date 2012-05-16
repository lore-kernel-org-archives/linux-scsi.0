From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 05/10] sg: remove closed flag
Date: Wed, 16 May 2012 17:57:35 -0400
Message-ID: <4FB422CF.8060109@interlog.com>
References: <20120412213217.GA17388@logfs.org> <20120412213339.GE17388@logfs.org>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:54397 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759249Ab2EPV5w (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 May 2012 17:57:52 -0400
In-Reply-To: <20120412213339.GE17388@logfs.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org

On 12-04-12 05:33 PM, J=C3=B6rn Engel wrote:
> After sg_release() has been called, noone should be able to actually =
use
> that filedescriptor anymore.  So if closed ever made a difference in =
the
> past five years or so, it would have meant a bug.  Remove it.
>
> Signed-off-by: Joern Engel<joern@logfs.org>

Acked-by: Douglas Gilbert <dgilbert@interlog.com>

> ---
>   drivers/scsi/sg.c |   10 +++-------
>   1 files changed, 3 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index 1a0be4f..ba657a9 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -157,7 +157,6 @@ typedef struct sg_fd {		/* holds the state of a f=
ile descriptor */
>   	Sg_request req_arr[SG_MAX_QUEUE];	/* used as singly-linked list */
>   	char low_dma;		/* as in parent but possibly overridden to 1 */
>   	char force_packid;	/* 1 ->  pack_id input to read(), 0 ->  ignored=
 */
> -	volatile char closed;	/* 1 ->  fd closed but request(s) outstanding=
 */
>   	char cmd_q;		/* 1 ->  allow command queuing, 0 ->  don't */
>   	char next_cmd_len;	/* 0 ->  automatic (def),>0 ->  use on next wri=
te() */
>   	char keep_orphan;	/* 0 ->  drop orphan (def), 1 ->  keep for read(=
) */
> @@ -329,8 +328,6 @@ sg_release(struct inode *inode, struct file *filp=
)
>   		return -ENXIO;
>   	SCSI_LOG_TIMEOUT(3, printk("sg_release: %s\n", sdp->disk->disk_nam=
e));
>
> -	sfp->closed =3D 1;
> -
>   	sdp->exclude =3D 0;
>   	wake_up_interruptible(&sdp->o_excl_wait);
>
> @@ -1118,8 +1115,7 @@ sg_poll(struct file *filp, poll_table * wait)
>   	int count =3D 0;
>   	unsigned long iflags;
>
> -	if ((!(sfp =3D (Sg_fd *) filp->private_data)) || (!(sdp =3D sfp->pa=
rentdp))
> -	    || sfp->closed)
> +	if ((!(sfp =3D (Sg_fd *) filp->private_data)) || (!(sdp =3D sfp->pa=
rentdp)))
>   		return POLLERR;
>   	poll_wait(filp,&sfp->read_wait, wait);
>   	read_lock_irqsave(&sfp->rq_list_lock, iflags);
> @@ -2515,9 +2511,9 @@ static void sg_proc_debug_helper(struct seq_fil=
e *s, Sg_device * sdp)
>   			   fp->reserve.bufflen,
>   			   (int) fp->reserve.k_use_sg,
>   			   (int) fp->low_dma);
> -		seq_printf(s, "   cmd_q=3D%d f_packid=3D%d k_orphan=3D%d closed=3D=
%d\n",
> +		seq_printf(s, "   cmd_q=3D%d f_packid=3D%d k_orphan=3D%d closed=3D=
0\n",
>   			   (int) fp->cmd_q, (int) fp->force_packid,
> -			   (int) fp->keep_orphan, (int) fp->closed);
> +			   (int) fp->keep_orphan);
>   		for (m =3D 0, srp =3D fp->headrp;
>   				srp !=3D NULL;
>   				++m, srp =3D srp->nextrp) {

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
