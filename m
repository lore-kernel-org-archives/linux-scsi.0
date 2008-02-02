From: Mark Glines <mark-6pk7R1svBr8dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2.6.24] bugfix for an overflow condition in usb storage
 & isd200.c
Date: Fri, 1 Feb 2008 16:55:07 -0800
Message-ID: <20080201165507.233345b9@chirp.tahoe>
References: <Pine.LNX.4.44L0.0801301807420.17156-100000@iolanthe.rowland.org>
	<47A1948B.2010402@panasas.com>
	<20080131070846.4464eb3c@chirp.tahoe>
	<47A1E6A0.8050500@panasas.com>
	<47A2033D.2050502@panasas.com>
	<20080131180051.GA22341@kroah.com>
	<47A22369.80906@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <47A22369.80906-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Cc: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, Matthew Dharm <mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>, James Bottomley <James.Bottomley-lYEaACU144FWk0Htik3J/w@public.gmane.org>, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 31 Jan 2008 21:37:13 +0200
Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org> wrote:
> 
> Mark - This is for you on top of vanila v2.6.24 kernel from Linus.

Sorry I didn't get back to you sooner.  This fixes the issue I was
having.


> ---
> 
>   scsi_scan is issuing a 36-byte INQUIRY request to llds. isd200 would
>   volunteer 96 bytes of INQUIRY. This caused an overflow condition in
>   protocol.c usb_stor_access_xfer_buf(). So first fix is to
>   usb_stor_access_xfer_buf() to properly handle overflow/underflow
> conditions. Then usb_stor_set_xfer_buf() should report this condition
> as a negative resid. Should we also set cmnd->status in the overflow
> condition?
> 
>   Then also isd200.c is fixed to only return the type of INQUIRY &&
> SENSE the upper layer asked for.
> 
> Signed-off-by: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>

Tested-by: Mark Glines <mark-6pk7R1svBr8dnm+yROfE0A@public.gmane.org>

> ---
>  drivers/usb/storage/isd200.c   |    7 +++++--
>  drivers/usb/storage/protocol.c |   13 +++++++++----
>  2 files changed, 14 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/usb/storage/isd200.c
> b/drivers/usb/storage/isd200.c index 49ba6c0..8186e93 100644
> --- a/drivers/usb/storage/isd200.c
> +++ b/drivers/usb/storage/isd200.c
> @@ -1238,6 +1238,7 @@ static int isd200_scsi_to_ata(struct scsi_cmnd
> *srb, struct us_data *us, unsigned long lba;
>  	unsigned long blockCount;
>  	unsigned char senseData[8] = { 0, 0, 0, 0, 0, 0, 0, 0 };
> +	unsigned xfer_len;
>  
>  	memset(ataCdb, 0, sizeof(union ata_cdb));
>  
> @@ -1247,8 +1248,9 @@ static int isd200_scsi_to_ata(struct scsi_cmnd
> *srb, struct us_data *us, US_DEBUGP("   ATA OUT - INQUIRY\n");
>  
>  		/* copy InquiryData */
> +		xfer_len = min(sizeof(info->InquiryData),
> scsi_bufflen(srb)); usb_stor_set_xfer_buf((unsigned char *)
> &info->InquiryData,
> -				sizeof(info->InquiryData), srb);
> +					xfer_len, srb);
>  		srb->result = SAM_STAT_GOOD;
>  		sendToTransport = 0;
>  		break;
> @@ -1257,7 +1259,8 @@ static int isd200_scsi_to_ata(struct scsi_cmnd
> *srb, struct us_data *us, US_DEBUGP("   ATA OUT -
> SCSIOP_MODE_SENSE\n"); 
>  		/* Initialize the return buffer */
> -		usb_stor_set_xfer_buf(senseData, sizeof(senseData),
> srb);
> +		xfer_len = min(sizeof(senseData), scsi_bufflen(srb));
> +		usb_stor_set_xfer_buf(senseData, xfer_len, srb);
>  
>  		if (info->DeviceFlags & DF_MEDIA_STATUS_ENABLED)
>  		{
> diff --git a/drivers/usb/storage/protocol.c
> b/drivers/usb/storage/protocol.c index 889622b..038a284 100644
> --- a/drivers/usb/storage/protocol.c
> +++ b/drivers/usb/storage/protocol.c
> @@ -194,7 +194,7 @@ unsigned int usb_stor_access_xfer_buf(unsigned
> char *buffer,
>  		 * and the starting offset within the page, and
> update
>  		 * the *offset and *index values for the next loop.
> */ cnt = 0;
> -		while (cnt < buflen) {
> +		while (cnt < buflen && sg) {
>  			struct page *page = sg_page(sg) +
>  					((sg->offset + *offset) >>
> PAGE_SHIFT); unsigned int poff =
> @@ -248,9 +248,14 @@ void usb_stor_set_xfer_buf(unsigned char *buffer,
>  {
>  	unsigned int offset = 0;
>  	struct scatterlist *sg = NULL;
> +	unsigned count;
>  
> -	usb_stor_access_xfer_buf(buffer, buflen, srb, &sg, &offset,
> +	count = usb_stor_access_xfer_buf(buffer, buflen, srb, &sg,
> &offset, TO_XFER_BUF);
> -	if (buflen < srb->request_bufflen)
> -		srb->resid = srb->request_bufflen - buflen;
> +
> +	/* Check for overflow */
> +	if (buflen > scsi_bufflen(srb))
> +		count = buflen;
> +
> +	scsi_set_resid(srb, scsi_bufflen(srb) - count);
>  }
