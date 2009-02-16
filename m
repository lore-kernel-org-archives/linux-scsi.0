From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: BUG - MODE SENSE residue miscount in g_file_storage bulk-only
 transport ?
Date: Mon, 16 Feb 2009 11:30:35 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0902161122510.15521-100000@netrider.rowland.org>
References: <200902161233.27173.stf_xl@wp.pl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <200902161233.27173.stf_xl-5tc4TXWwyLM@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stanislaw Gruszka <stf_xl-5tc4TXWwyLM@public.gmane.org>
Cc: linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 16 Feb 2009, Stanislaw Gruszka wrote:

> Hello.
> 
> I'm trying to use g_file_storage gadget on my embedded Atmel board and have
> some troubles. It take _very_ long time to discovery device due to USB interface
> resets which happen because of residue miscouting for MODE_SENSE command.

No, that's not why the resets happen.  The residue is not miscounted.

> Below are debugging mesages in configuration where USB host is connected to USB
> device on the same machine (USB cable loop).
> 
> Whats happen? 
> - SCSI host driver set MODE SENSE command length to 192
> - device return 16 bytes of mode pages and set internal residue to 176, 
> - host does not check residue and try to get command status
> - device halt bulk in endpoint
> - host reset device 

You left out a few steps, but the details don't matter.

> This sequence is repeated few times (SD_MAX_RETRIES times probably).
> 
> I'm trying to fix the issue and currently wrote a workaround which looks
> works quite well, but I did not test it for other transports than BBB:
> 
> diff --git a/drivers/usb/gadget/file_storage.c b/drivers/usb/gadget/file_storage.c
> index b10fa31..0a77ba8 100644
> --- a/drivers/usb/gadget/file_storage.c
> +++ b/drivers/usb/gadget/file_storage.c
> @@ -2269,6 +2269,7 @@ static int do_mode_sense(struct fsg_dev *fsg, struct fsg_buffhd *bh)
>  		buf0[0] = len - 1;
>  	else
>  		put_be16(buf0, len - 2);
> +	fsg->residue = fsg->usb_amount_left = len;
>  	return len;
>  }

This patch is incorrect.  len is the amount of data sent, not the 
residue.  If you look at the end of do_scsi_command(), you'll see where 
the code calculates the correct residue.

> Maybe this is not only problem with MODE SENSE command but with all commands
> that have allocation length field and file_storage gadget driver BBB transport
> return less data.
> 
> Problem also happens in older kernels, I tried 2.6.27 and 2.6.24 - they have this issue. 
> Please let me know if have more info or any other help to fix.

The problem is in the Atmel hardware; it's not capable of halting a
bulk endpoint correctly.  You need to invoke g_file_storage with the
"stall=no" parameter.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
