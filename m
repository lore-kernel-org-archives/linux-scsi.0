From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [patch] mptfusion: prevent some memory corruption
Date: Fri, 03 Jul 2015 11:06:32 +0200
Message-ID: <mqdbnft7gpz.fsf@c203.arch.suse.de>
References: <20150703085303.GA11901@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150703085303.GA11901@mwanda> (Dan Carpenter's message of "Fri,
	3 Jul 2015 11:53:03 +0300")
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Dan Carpenter <dan.carpenter@oracle.com> writes:

> These are signed values the come from the user, we put a cap on the
> upper bounds but not on the lower bounds.
>
> We use "karg.dataSgeOffset" to calculate "sz".  We verify "sz" and
> proceed as if that means that "karg.dataSgeOffset" is correct but thi=
s
> fails to consider that the "sz" calculations can have integer overflo=
ws.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> During my QC process, I realized that I sent a similar patch last yea=
r,
> but never received a response.
>
> http://permalink.gmane.org/gmane.linux.kernel.janitors/32590
>
> Looking at both of them, I guess I prefer today's patch because it is
> simpler.
>
> diff --git a/drivers/message/fusion/mptctl.c b/drivers/message/fusion=
/mptctl.c
> index 70bb753..fc73937 100644
> --- a/drivers/message/fusion/mptctl.c
> +++ b/drivers/message/fusion/mptctl.c
> @@ -1859,6 +1859,15 @@ mptctl_do_mpt_command (struct mpt_ioctl_comman=
d karg, void __user *mfPtr)
>  	}
>  	spin_unlock_irqrestore(&ioc->taskmgmt_lock, flags);
> =20
> +	/* Basic sanity checks to prevent underflows or integer overflows *=
/
> +	if (karg.maxReplyBytes < 0 ||
> +	    karg.dataInSize < 0 ||
> +	    karg.dataOutSize < 0 ||
> +	    karg.dataSgeOffset < 0 ||
> +	    karg.maxSenseBytes < 0 ||
> +	    karg.dataSgeOffset > ioc->req_sz / 4)
> +		return -EINVAL;
> +
>  	/* Verify that the final request frame will not be too large.
>  	 */
>  	sz =3D karg.dataSgeOffset * 4;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Acked-by: Johannes Thumshirn <jthumshirn@suse.de>

--=20
Johannes Thumshirn                                       Storage
jthumshirn@suse.de                             +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
