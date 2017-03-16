From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [patch] check length passed to SG_NEXT_CMD_LEN
Date: Thu, 16 Mar 2017 14:24:37 -0400
Message-ID: <9bea89fc-9c52-338b-08cb-6ff35ee02d02@interlog.com>
References: <CAF2xp_GW8KwyD9AuZjHFoPtiNdRyPQ27+1jDLEJjuKxci3mU6w@mail.gmail.com>
 <yq1zigmf6vq.fsf@oracle.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:53405 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753929AbdCPScx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Mar 2017 14:32:53 -0400
In-Reply-To: <yq1zigmf6vq.fsf@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Peter Chang <dpf@google.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Dmitry Vyukov <dvyukov@google.com>

On 2017-03-15 07:38 PM, Martin K. Petersen wrote:
> Peter Chang <dpf@google.com> writes:
>
>> now that i think i've got gmail not marking everything as spam...
>
> Doug?

The extra sanity check can't hurt.

Acked-by: Douglas Gilbert <dgilbert@interlog.com>

>
>>From 93409c62db49d15105390315a685e54083029bee Mon Sep 17 00:00:00 2001
> From: peter chang <dpf@google.com>
> Date: Wed, 15 Feb 2017 14:11:54 -0800
> Subject: [PATCH] [sg] check length passed to SG_NEXT_CMD_LEN
>
> the user can control the size of the next command passed along, but
> the value passed to the ioctl isn't checked against the usable
> max command size.
>
> Change-Id: I9ac2ae07c35cf5fda62d7afad32c8d9ab6a9ea1d
> Tested: sanity checked w/ calling the ioctl w/ a bogus size
> ---
>  drivers/scsi/sg.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index 9c5c5f2b3962..b47a369cb71c 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -976,6 +976,8 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
>  		result = get_user(val, ip);
>  		if (result)
>  			return result;
> +		if (val > SG_MAX_CDB_SIZE)
> +			return -ENOMEM;
>  		sfp->next_cmd_len = (val > 0) ? val : 0;
>  		return 0;
>  	case SG_GET_VERSION_NUM:
>
