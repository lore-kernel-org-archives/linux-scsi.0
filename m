From: Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH] sg: fix a double-fetch bug in sg_write()
Date: Wed, 5 Jun 2019 08:41:11 +0200
Message-ID: <38bbd54f-d85b-e529-36ad-5c1809bb435f@suse.cz>
References: <20190531012704.GA4541@zhanggen-UX430UQ>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190531012704.GA4541@zhanggen-UX430UQ>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Gen Zhang <blackgod016574@gmail.com>, dgilbert@interlog.com, jejb@linux.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 31. 05. 19, 3:27, Gen Zhang wrote:
> In sg_write(), the opcode of the command is fetched the first time from 
> the userspace by __get_user(). Then the whole command, the opcode 
> included, is fetched again from userspace by __copy_from_user(). 
> However, a malicious user can change the opcode between the two fetches.
> This can cause inconsistent data and potential errors as cmnd is used in
> the following codes.
> 
> Thus we should check opcode between the two fetches to prevent this.
> 
> Signed-off-by: Gen Zhang <blackgod016574@gmail.com>
> ---
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index d3f1531..a2971b8 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -694,6 +694,8 @@ sg_write(struct file *filp, const char __user *buf, size_t count, loff_t * ppos)
>  	hp->flags = input_size;	/* structure abuse ... */
>  	hp->pack_id = old_hdr.pack_id;
>  	hp->usr_ptr = NULL;
> +	if (opcode != cmnd[0])
> +		return -EINVAL;
>  	if (__copy_from_user(cmnd, buf, cmd_size))
>  		return -EFAULT;

You are sending the same patches like a broken machine. Please STOP this
and give people some time to actually review your patches! (Don't expect
replies in days.)

I already commented on this apparently broken one earlier...

thanks,
-- 
js
suse labs
