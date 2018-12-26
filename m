From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] scsi: fix a double-fetch bug in sg_write
Date: Tue, 25 Dec 2018 22:42:52 -0500
Message-ID: <7e727b1a-88e5-7062-159e-bf4be110d168@interlog.com>
References: <20181225202427.69476-1-kjlu@umn.edu>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181225202427.69476-1-kjlu@umn.edu>
Content-Language: en-CA
Sender: linux-kernel-owner@vger.kernel.org
To: Kangjie Lu <kjlu@umn.edu>
Cc: pakki001@umn.edu, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 2018-12-25 3:24 p.m., Kangjie Lu wrote:
> "opcode" has been copied in from user space and checked. We should not
> copy it in again, which may have been modified by malicous
> multi-threading user programs through race conditions. The fix uses the
> opcode fetched in the first copy.
> 
> Signed-off-by: Kangjie Lu <kjlu@umn.edu>
  Acked-by: Douglas Gilbert <dgilbert@interlog.com>

Also applied to my sg v4 driver code. The v1 and v2 interfaces (based on
struct sg_header) did not provide a command length field. The sg driver
needed to read the first byte of the command (the "opcode") to determine
the full command's length prior to actually reading it in full.

Hard to think of an example of an exploit based on this double read.

> ---
>   drivers/scsi/sg.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index 4dacbfffd113..41774e4f9508 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -686,7 +686,8 @@ sg_write(struct file *filp, const char __user *buf, size_t count, loff_t * ppos)
>   	hp->flags = input_size;	/* structure abuse ... */
>   	hp->pack_id = old_hdr.pack_id;
>   	hp->usr_ptr = NULL;
> -	if (__copy_from_user(cmnd, buf, cmd_size))
> +	cmnd[0] = opcode;
> +	if (__copy_from_user(cmnd + 1, buf + 1, cmd_size - 1))
>   		return -EFAULT;
>   	/*
>   	 * SG_DXFER_TO_FROM_DEV is functionally equivalent to SG_DXFER_FROM_DEV,
> 
