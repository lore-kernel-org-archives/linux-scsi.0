From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: [BUG] 2.6.24-git usb reset problems
Date: Tue, 29 Jan 2008 10:36:19 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0801291032210.4229-100000@iolanthe.rowland.org>
References: <479F18D3.9030709@panasas.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <479F18D3.9030709-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Cc: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, Jens Axboe <jens.axboe-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Matthew Dharm <mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 29 Jan 2008, Boaz Harrosh wrote:

> --- a/drivers/usb/storage/transport.c
> +++ b/drivers/usb/storage/transport.c
> @@ -462,18 +462,24 @@ static int usb_stor_bulk_transfer_sglist(struct us_data *us, unsigned int pipe,
>   * Common used function. Transfer a complete command
>   * via usb_stor_bulk_transfer_sglist() above. Set cmnd resid
>   */
> -int usb_stor_bulk_srb(struct us_data* us, unsigned int pipe,
> -		      struct scsi_cmnd* srb)
> +int usb_stor_bulk_srb_length(struct us_data* us, unsigned int pipe,
> +		      struct scsi_cmnd* srb, unsigned length)
>  {
>  	unsigned int partial;
>  	int result = usb_stor_bulk_transfer_sglist(us, pipe, scsi_sglist(srb),
> -				      scsi_sg_count(srb), scsi_bufflen(srb),
> +				      scsi_sg_count(srb), length,
>  				      &partial);
>  
>  	scsi_set_resid(srb, scsi_bufflen(srb) - partial);
>  	return result;
>  }
>  
> +int usb_stor_bulk_srb(struct us_data* us, unsigned int pipe,
> +		struct scsi_cmnd* srb)
> +{
> +	return usb_stor_bulk_srb_length(us, pipe, srb, scsi_bufflen(srb));
> +}
> +

I don't like this patch very much.  Why add another layer of 
indirection when the two subroutines do hardly any work?  Leave 
usb_stor_bulk_srb() the way it was, and add usb_stor_bulk_srb_length() 
as a separate routine that simply calls usb_stor_bulk_transfer_sglist() 
and scsi_set_resid().

BTW, the standard coding style calls for a blank line after the list of 
local variables at the start of a function or block.

Alan Stern
