From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: [PATCH] bugfix for an underflow condition in usb storage &
 isd200.c
Date: Thu, 31 Jan 2008 12:49:59 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0801311244430.4373-100000@iolanthe.rowland.org>
References: <47A2033D.2050502@panasas.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <47A2033D.2050502-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Cc: Mark Glines <mark-6pk7R1svBr8dnm+yROfE0A@public.gmane.org>, Matthew Dharm <mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>, James Bottomley <James.Bottomley-lYEaACU144FWk0Htik3J/w@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 31 Jan 2008, Boaz Harrosh wrote:

> @@ -228,9 +228,14 @@ void usb_stor_set_xfer_buf(unsigned char *buffer,
>  {
>  	unsigned int offset = 0;
>  	struct scatterlist *sg = NULL;
> +	unsigned int count;
>  
> -	usb_stor_access_xfer_buf(buffer, buflen, srb, &sg, &offset,
> +	count = usb_stor_access_xfer_buf(buffer, buflen, srb, &sg, &offset,
>  			TO_XFER_BUF);
> -	if (buflen < scsi_bufflen(srb))
> -		scsi_set_resid(srb, scsi_bufflen(srb) - buflen);
> +
> +	/* Check for underflow */
> +	if (buflen > scsi_bufflen(srb))
> +		count = buflen;
> +
> +	scsi_set_resid(srb, scsi_bufflen(srb) - count);
>  }

This last "if" statement doesn't look right.  And since you know that
count will never be larger than scsi_bufflen(srb), you don't have to
check for underflow at all.  Just leave out the "if" and call
scsi_set_resid() directly.

Alan Stern
