From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: ses: fix VPD inquiry overrun
Date: Wed, 30 Jul 2008 12:44:32 +0300
Message-ID: <48903800.7000008@panasas.com>
References: <1217349505.6103.15.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:6774 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761471AbYG3Jo5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Jul 2008 05:44:57 -0400
In-Reply-To: <1217349505.6103.15.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Harvey Harrison <harvey.harrison@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> There are a few kerneloops.org reports like this one:
> 
> http://www.kerneloops.org/search.php?search=ses_match_to_enclosure
> 
> That seem to imply we're running off the end of the VPD inquiry data
> (although at 512 bytes, it should be long enough for just about
> anything).  we should be using correctly sized buffers anyway, so put
> those in and hope this oops goes away.
> 
> James
> 
> ---
> 
> diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
> index 0fe031f..f2d89be 100644
> --- a/drivers/scsi/ses.c
> +++ b/drivers/scsi/ses.c
> @@ -345,14 +345,14 @@ static int ses_enclosure_find_by_addr(struct enclosure_device *edev,
>  	return 0;
>  }
>  
> -#define VPD_INQUIRY_SIZE 512
> +#define VPD_INQUIRY_SIZE 36
>  
>  static void ses_match_to_enclosure(struct enclosure_device *edev,
>  				   struct scsi_device *sdev)
>  {
>  	unsigned char *buf = kmalloc(VPD_INQUIRY_SIZE, GFP_KERNEL);
>  	unsigned char *desc;
> -	int len;
> +	u16 vpd_len;
>  	struct efd efd = {
>  		.addr = 0,
>  	};
> @@ -372,9 +372,19 @@ static void ses_match_to_enclosure(struct enclosure_device *edev,
>  			     VPD_INQUIRY_SIZE, NULL, SES_TIMEOUT, SES_RETRIES))
>  		goto free;
>  
> -	len = (buf[2] << 8) + buf[3];
> +	vpd_len = (buf[2] << 8) + buf[3];

+	vpd_len = get_unaligned_be16(&buf[2]);

> +	kfree(buf);
> +	buf = kmalloc(vpd_len, GFP_KERNEL);
> +	if (!buf)
> +		return;
> +	cmd[3] = vpd_len >> 8;
> +	cmd[4] = vpd_len & 0xff;

+	put_unaligned_be16(vpd_len, &cmd[3]);

> +	if (scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buf,
> +			     vpd_len, NULL, SES_TIMEOUT, SES_RETRIES))
> +		goto free;
> +	
>  	desc = buf + 4;
> -	while (desc < buf + len) {
> +	while (desc < buf + vpd_len) {
>  		enum scsi_protocol proto = desc[0] >> 4;
>  		u8 code_set = desc[0] & 0x0f;
>  		u8 piv = desc[1] & 0x80;
> 
> 
> 

Harvey where are these bitwise accessors that do an *aligned* access on a 
void pointer. the equivalent of:
	u16 = be16_to_cpup((const __be16 *p)&buff[x]);
Where I know that x above is some even offset.

I've seen you sent them but I can't find them in my tree

Boaz

