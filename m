From: "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [patch 1/2] cciss: cleans up warnings in the 32/64 bit conversions
Date: Fri, 22 Oct 2004 01:00:45 +0100 (BST)
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58L.0410220054010.15504@blysk.ds.pg.gda.pl>
References: <20041021211718.GA10462@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S271149AbUJVAEr@vger.kernel.org>
In-Reply-To: <20041021211718.GA10462@beardog.cca.cpqcorp.net>
To: mikem@beardog.cca.cpqcorp.net
Cc: marcelo.tosatti@cyclades.com, axboe@suse.de, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 21 Oct 2004 mike.miller@hp.com wrote:

> @@ -611,7 +610,7 @@ int cciss_ioctl32_passthru(unsigned int 
>  	err |= copy_from_user(&arg64.Request, &arg32->Request, sizeof(arg64.Request));
>  	err |= copy_from_user(&arg64.error_info, &arg32->error_info, sizeof(arg64.error_info));
>  	err |= get_user(arg64.buf_size, &arg32->buf_size);
> -	err |= get_user(arg64.buf, &arg32->buf);
> +	err |= get_user((__u64) arg64.buf, &arg32->buf);
>  	if (err) 
>  		return -EFAULT; 
>  
> @@ -641,7 +640,7 @@ int cciss_ioctl32_big_passthru(unsigned 
>  	err |= copy_from_user(&arg64.error_info, &arg32->error_info, sizeof(arg64.error_info));
>  	err |= get_user(arg64.buf_size, &arg32->buf_size);
>  	err |= get_user(arg64.malloc_size, &arg32->malloc_size);
> -	err |= get_user(arg64.buf, &arg32->buf);
> +	err |= get_user((__u64) arg64.buf, &arg32->buf);
>  	if (err) return -EFAULT; 
>  	old_fs = get_fs();
>  	set_fs(KERNEL_DS);

 These constructs (casts as lvalues) are deprecated with GCC 3.4 (a
warning is triggered) and no longer supported with 4.0.  Please consider
rewriting -- you'll probably need an auxiliary variable.

  Maciej
