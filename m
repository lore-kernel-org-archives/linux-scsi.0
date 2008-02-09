From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: ses fix for len and mem leaking when fail to add
	intf
Date: Sat, 09 Feb 2008 09:00:42 -0600
Message-ID: <1202569242.4254.9.camel@localhost.localdomain>
References: <200802090413.53275.yinghai.lu@sun.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <200802090413.53275.yinghai.lu@sun.com>
Sender: linux-ide-owner@vger.kernel.org
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, kristen.c.accardi@intel.com
List-Id: linux-scsi@vger.kernel.org


On Sat, 2008-02-09 at 04:13 -0800, Yinghai Lu wrote:
> [PATCH] scsi: ses fix for len and mem leaking when fail to add intf
> 
> change to u32 before left shifting char

This one is a bit unnecessary; C promotion rules guarantee that
everything is promoted to int (or above) before doing arithmetic.  Since
it's only ever done on 16 bits, signed or unsigned int is adequate for
the conversion.

> also fix leaking with scomp leaking when failing.

Yes, I see that, thanks!  There's also the kmalloc of scomp which should
be kzalloc if you care to fix that up in the resend.

> -		edev = 	enclosure_find(&sdev->host->shost_gendev);
> +		edev = enclosure_find(&sdev->host->shost_gendev);

Space cleanups also need mention in the changelog.

> -	ses_dev->page1 = buf;
> -	ses_dev->page1_len = len;
> -
>  	result = ses_recv_diag(sdev, 1, buf, len);
>  	if (result)
>  		goto recv_failed;
>  
> +	ses_dev->page1 = buf;
> +	ses_dev->page1_len = len;
> +

Neither of us gets this right.  By removing the kfree(buf) from the
err_free path, you cause a leak here.  I cause a double free.  I think
putting back the kfree(buf) and keeping this hunk is the fix.

>  	types = buf[10];
>  	len = buf[11];
>  
> @@ -474,11 +474,12 @@ static int ses_intf_add(struct class_dev
>  			components += type_ptr[1];
>  	}
>  
> +	buf = NULL;

Yes, prevents double free (but only if buf is freed).

>  	result = ses_recv_diag(sdev, 2, hdr_buf, INIT_ALLOC_SIZE);
>  	if (result)
>  		goto recv_failed;
>  
> @@ -492,11 +493,12 @@ static int ses_intf_add(struct class_dev
>  
>  	/* The additional information page --- allows us
>  	 * to match up the devices */
> +	buf = NULL;

It's probably better to move these closer to the statements that make
them necessary (in this case above the comment).

>  	if (IS_ERR(edev)) {
>  		err = PTR_ERR(edev);
> +		kfree(scomp);
>  		goto err_free;
>  	}

kfree(scomp) should be in the err_free path just in case someone else
adds something to this.
 
>  	/* add 1 for trailing '\0' we'll use */
>  	buf = kzalloc(len + 1, GFP_KERNEL);
> -	result = ses_recv_diag(sdev, 7, buf, len);
> -	if (result) {
> +	if (buf)
> +		result = ses_recv_diag(sdev, 7, buf, len);
> +	else
> +		result = 7;
> +

What exactly is this supposed to be doing, and why 7?  If you're
thinking of conditioning the page 7 receive on the success of the
allocation, we really need the allocation failure report more than we
need the driver to attach.

> -					addl_desc_ptr += addl_desc_ptr[1] + 2;
> +					addl_desc_ptr += 2 + addl_desc_ptr[1];

This is rather pointless, isn't it?

>   err_free:
> -	kfree(buf);

You can't remove this.  Also add kfree(scomp) here.

>  	kfree(ses_dev->page10);
>  	kfree(ses_dev->page2);
>  	kfree(ses_dev->page1);
> @@ -630,6 +636,7 @@ static void ses_intf_remove(struct class
>  	ses_dev = edev->scratch;
>  	edev->scratch = NULL;
>  
> +	kfree(ses_dev->page10);

Yes, a bug, thanks.

>  	kfree(ses_dev->page1);
>  	kfree(ses_dev->page2);
>  	kfree(ses_dev);

James


