From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Bugs in scsi_vpd_inquiry()
Date: Tue, 11 Aug 2009 10:59:09 -0500
Message-ID: <1250006349.4301.46.camel@mulgrave.site>
References: <Pine.LNX.4.44L0.0908111136350.2562-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:48836 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752864AbZHKP7L (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Aug 2009 11:59:11 -0400
In-Reply-To: <Pine.LNX.4.44L0.0908111136350.2562-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Boaz Harrosh <bharrosh@panasas.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Matthew Wilcox <willy@linux.intel.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Tue, 2009-08-11 at 11:38 -0400, Alan Stern wrote:
> On Tue, 11 Aug 2009, James Bottomley wrote:
> 
> > > > This is pointless and dangerous:  Some architectures will invalidate
> > > > caches for DMA not flush them, so it might not do what you think it
> > > > does.
> > > > 
> > > 
> > > Then you can't do that "after check" either. It's a simple minefield.
> > > What do you suggest?
> > 
> > Well, nothing really, like the original code.  Byzantine checking is
> > never a good idea.  You always assume that if a device told you it did
> > what you told it, it actually did.  If we find devices that fail this
> > simple premise, then we get into blacklists and other forms of
> > nastiness.
> 
> Okay, then how about this?
> 
> Alan Stern
> 
> 
> 
> Index: usb-2.6/drivers/scsi/scsi.c
> ===================================================================
> --- usb-2.6.orig/drivers/scsi/scsi.c
> +++ usb-2.6/drivers/scsi/scsi.c
> @@ -980,7 +980,8 @@ static int scsi_vpd_inquiry(struct scsi_
>  							u8 page, unsigned len)
>  {
>  	int result;
> -	unsigned char cmd[16];
> +	int resid;
> +	unsigned char cmd[6];
>  
>  	cmd[0] = INQUIRY;
>  	cmd[1] = 1;		/* EVPD */
> @@ -994,12 +995,12 @@ static int scsi_vpd_inquiry(struct scsi_
>  	 * all the existing users tried this hard.
>  	 */
>  	result = scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buffer,
> -				  len + 4, NULL, 30 * HZ, 3, NULL);
> +				  len, NULL, 30 * HZ, 3, &resid);
>  	if (result)
>  		return result;
>  
> -	/* Sanity check that we got the page back that we asked for */
> -	if (buffer[1] != page)
> +	/* Sanity check that we at least got the header */
> +	if (resid > len - 4)
>  		return -EIO;
>  
>  	return 0;
> @@ -1027,7 +1028,7 @@ unsigned char *scsi_get_vpd_page(struct 
>  		return NULL;
>  
>  	/* Ask for all the pages supported by this device */
> -	result = scsi_vpd_inquiry(sdev, buf, 0, 255);
> +	result = scsi_vpd_inquiry(sdev, buf, 0, 255 + 4);
>  	if (result)
>  		goto fail;
>  
> @@ -1042,7 +1043,7 @@ unsigned char *scsi_get_vpd_page(struct 
>  	goto fail;
>  
>   found:
> -	result = scsi_vpd_inquiry(sdev, buf, page, 255);
> +	result = scsi_vpd_inquiry(sdev, buf, page, 255 + 4);
>  	if (result)
>  		goto fail;
>  
> @@ -1056,7 +1057,7 @@ unsigned char *scsi_get_vpd_page(struct 
>  
>  	kfree(buf);
>  	buf = kmalloc(len + 4, GFP_KERNEL);
> -	result = scsi_vpd_inquiry(sdev, buf, page, len);
> +	result = scsi_vpd_inquiry(sdev, buf, page, len + 4);
>  	if (result)
>  		goto fail;

Sort of, but it's not really doing it properly.  Lets do it like this.
This should also fix the > 255 length problem older devices might have.

James

---

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 2de5f3a..b6e0307 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -994,7 +994,7 @@ static int scsi_vpd_inquiry(struct scsi_device *sdev, unsigned char *buffer,
 	 * all the existing users tried this hard.
 	 */
 	result = scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buffer,
-				  len + 4, NULL, 30 * HZ, 3, NULL);
+				  len, NULL, 30 * HZ, 3, NULL);
 	if (result)
 		return result;
 
@@ -1021,13 +1021,14 @@ unsigned char *scsi_get_vpd_page(struct scsi_device *sdev, u8 page)
 {
 	int i, result;
 	unsigned int len;
-	unsigned char *buf = kmalloc(259, GFP_KERNEL);
+	const unsigned int init_vpd_len = 255;
+	unsigned char *buf = kmalloc(init_vpd_len, GFP_KERNEL);
 
 	if (!buf)
 		return NULL;
 
 	/* Ask for all the pages supported by this device */
-	result = scsi_vpd_inquiry(sdev, buf, 0, 255);
+	result = scsi_vpd_inquiry(sdev, buf, 0, init_vpd_len);
 	if (result)
 		goto fail;
 
@@ -1050,12 +1051,12 @@ unsigned char *scsi_get_vpd_page(struct scsi_device *sdev, u8 page)
 	 * Some pages are longer than 255 bytes.  The actual length of
 	 * the page is returned in the header.
 	 */
-	len = (buf[2] << 8) | buf[3];
-	if (len <= 255)
+	len = ((buf[2] << 8) | buf[3]) + 4;
+	if (len <= init_vpd_len)
 		return buf;
 
 	kfree(buf);
-	buf = kmalloc(len + 4, GFP_KERNEL);
+	buf = kmalloc(len, GFP_KERNEL);
 	result = scsi_vpd_inquiry(sdev, buf, page, len);
 	if (result)
 		goto fail;


