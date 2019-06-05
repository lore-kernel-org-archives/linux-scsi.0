From: Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH] sg: Fix a double-fetch bug in drivers/scsi/sg.c
Date: Wed, 5 Jun 2019 08:00:49 +0200
Message-ID: <d7cb94f3-f136-62ff-3067-b3e5f6ac63ce@suse.cz>
References: <20190523023855.GA17852@zhanggen-UX430UQ>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190523023855.GA17852@zhanggen-UX430UQ>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Gen Zhang <blackgod016574@gmail.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 23. 05. 19, 4:38, Gen Zhang wrote:
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

Isn't it too early to check cmnd which is copied only here:

>  	if (__copy_from_user(cmnd, buf, cmd_size))
>  		return -EFAULT;
>  	/*
> ---
> 

thanks,
-- 
js
suse labs
