From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 1/2] scsi: sg: Avoid overflow when USER_HZ > HZ
Date: Fri, 26 Aug 2016 23:21:20 +0200
Message-ID: <780ef07d-e85a-fdd3-31f4-68c38a747097@interlog.com>
References: <20160819164357.26121-1-paul.burton@imgtec.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:38436 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754185AbcHZVai (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 26 Aug 2016 17:30:38 -0400
In-Reply-To: <20160819164357.26121-1-paul.burton@imgtec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paul Burton <paul.burton@imgtec.com>, linux-scsi@vger.kernel.org, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>

On 2016-08-19 06:43 PM, Paul Burton wrote:
> Calculating the maximum timeout that a user can set via the
> SG_SET_TIMEOUT ioctl involves multiplying INT_MAX by USER_HZ/HZ. If
> USER_HZ is larger than HZ then this results in an overflow when
> performed as a 32 bit integer calculation, resulting in compiler
> warnings such as the following:
>
>   drivers/scsi/sg.c: In function 'sg_ioctl':
>   drivers/scsi/sg.c:91:67: warning: integer overflow in expression [-Woverflow]
>    #define MULDIV(X,MUL,DIV) ((((X % DIV) * MUL) / DIV) + ((X / DIV) * MUL))
>                                                                      ^
>   drivers/scsi/sg.c:887:14: note: in expansion of macro 'MULDIV'
>      if (val >= MULDIV (INT_MAX, USER_HZ, HZ))
>                 ^
>   drivers/scsi/sg.c:91:67: warning: integer overflow in expression [-Woverflow]
>    #define MULDIV(X,MUL,DIV) ((((X % DIV) * MUL) / DIV) + ((X / DIV) * MUL))
>                                                                      ^
>   drivers/scsi/sg.c:888:13: note: in expansion of macro 'MULDIV'
>          val = MULDIV (INT_MAX, USER_HZ, HZ);
>                ^
>
> Avoid this overflow by performing the (constant) arithmetic on 64 bit
> integers, which ensures that overflow from multiplying the 32 bit values
> cannot occur. When converting the result back to a 32 bit integer use
> min_t to ensure that we don't simply truncate a value beyond INT_MAX to
> a 32 bit integer, but instead use INT_MAX where the result was larger
> than it. As the values are all compile time constant the 64 bit
> arithmetic should have no runtime cost.
>
> Signed-off-by: Paul Burton <paul.burton@imgtec.com>

That macro has been changed several times, hopefully this is the final
time.

Acked by: Douglas Gilbert <dgilbert@interlog.com>

> ---
>  drivers/scsi/sg.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index ae7d9bd..bb5ec2d 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -884,8 +884,9 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
>  			return result;
>  		if (val < 0)
>  			return -EIO;
> -		if (val >= MULDIV (INT_MAX, USER_HZ, HZ))
> -		    val = MULDIV (INT_MAX, USER_HZ, HZ);
> +		if (val >= MULDIV((s64)INT_MAX, USER_HZ, HZ))
> +			val = min_t(s64, MULDIV((s64)INT_MAX, USER_HZ, HZ),
> +				    INT_MAX);
>  		sfp->timeout_user = val;
>  		sfp->timeout = MULDIV (val, HZ, USER_HZ);
>
>

