From: Willem Riede <osst@riede.org>
Subject: Re: [-mm PATCH 29/32] drivers/scsi: fix-up schedule_timeout() usage
Date: Mon, 15 Aug 2005 20:34:27 +0000
Message-ID: <1124138067l.3920l.7l@serve.riede.org>
References: <20050815180514.GC2854@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rwcrmhc14.comcast.net ([216.148.227.89]:51400 "EHLO
	rwcrmhc12.comcast.net") by vger.kernel.org with ESMTP
	id S964917AbVHOUew convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Aug 2005 16:34:52 -0400
In-Reply-To: <20050815182751.GF2854@us.ibm.com> (from nacc@us.ibm.com on Mon
	Aug 15 14:27:51 2005)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: James.Bottomley@SteelEye.com, matthew@wil.cx, markus.lidel@shadowconnect.com, andrew.vasquez@qlogic.com, akpm@osdl.org, linux-scsi@vger.kernel.org

On 08/15/2005 02:27:51 PM, Nishanth Aravamudan wrote:
> Description: Use schedule_timeout_uninterruptible() instead of
> set_current_state()/schedule_timeout() to reduce kernel size.
> 
> Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
> 
> ---
> 
>  drivers/scsi/osst.c           |    9 +++------
>
> diff -urpN 2.6.13-rc5-mm1/drivers/scsi/osst.c
> 2.6.13-rc5-mm1-dev/drivers/scsi/osst.c
> --- 2.6.13-rc5-mm1/drivers/scsi/osst.c	2005-08-07 10:05:21.000000000
> -0700
> +++ 2.6.13-rc5-mm1-dev/drivers/scsi/osst.c	2005-08-12
> 13:42:13.000000000 -0700
> @@ -862,8 +862,7 @@ static int osst_recover_wait_frame(struc
>  				retval = osst_write_error_recovery(STp,
> aSRpnt, 0);
>  				break;
>  			}
> -			set_current_state(TASK_INTERRUPTIBLE);
> -			schedule_timeout (HZ / OSST_POLL_PER_SEC);
> +			schedule_timeout_interruptible(HZ /
OSST_POLL_PER_SEC);

Others have suggested using msleep in osst instead of schedule, which I think
is 
more appropriate.

Regards, Willem Riede.



