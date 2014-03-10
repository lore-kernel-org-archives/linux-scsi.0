From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH 5/5] ses: Use vpd information from scsi_device
Date: Mon, 10 Mar 2014 18:20:27 +0000
Message-ID: <1394475625.2565.42.camel@dabdike.int.hansenpartnership.com>
References: <1394461725-76203-1-git-send-email-hare@suse.de>
	 <1394461725-76203-6-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:48770 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381AbaCJSUt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Mar 2014 14:20:49 -0400
In-Reply-To: <1394461725-76203-6-git-send-email-hare@suse.de>
Content-Language: en-US
Content-ID: <CBAFF09758C31848821833F01DCC0497@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hare@suse.de" <hare@suse.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "bvanassche@acm.org" <bvanassche@acm.org>, "hch@infradead.org" <hch@infradead.org>

On Mon, 2014-03-10 at 15:28 +0100, Hannes Reinecke wrote:
> The scsi_device now has VPD page83 information attached, so
> there is no need to query it again.

This is a bit new for a v8 patch, have you actually tested it?  I'm
asking because it looks to me like the vpd attach is done just before
the configure whereas the bindings are usually done in add.  I suspect
this will work for ses because it's a device model binding rather than a
transport class binding and the former occurs later, but knowing it
actually all works would be useful.

James


> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/ses.c | 38 ++++++++++----------------------------
>  1 file changed, 10 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
> index eba183c..80bfece 100644
> --- a/drivers/scsi/ses.c
> +++ b/drivers/scsi/ses.c
> @@ -25,6 +25,7 @@
>  #include <linux/module.h>
>  #include <linux/kernel.h>
>  #include <linux/enclosure.h>
> +#include <asm/unaligned.h>
>  
>  #include <scsi/scsi.h>
>  #include <scsi/scsi_cmnd.h>
> @@ -448,27 +449,18 @@ static void ses_enclosure_data_process(struct enclosure_device *edev,
>  static void ses_match_to_enclosure(struct enclosure_device *edev,
>  				   struct scsi_device *sdev)
>  {
> -	unsigned char *buf;
>  	unsigned char *desc;
> -	unsigned int vpd_len;
>  	struct efd efd = {
>  		.addr = 0,
>  	};
>  
> -	buf = kmalloc(INIT_ALLOC_SIZE, GFP_KERNEL);
> -	if (!buf || scsi_get_vpd_page(sdev, 0x83, buf, INIT_ALLOC_SIZE))
> -		goto free;
> -
>  	ses_enclosure_data_process(edev, to_scsi_device(edev->edev.parent), 0);
>  
> -	vpd_len = ((buf[2] << 8) | buf[3]) + 4;
> -	kfree(buf);
> -	buf = kmalloc(vpd_len, GFP_KERNEL);
> -	if (!buf ||scsi_get_vpd_page(sdev, 0x83, buf, vpd_len))
> -		goto free;
> +	if (!sdev->vpd_pg83_len)
> +		return;
>  
> -	desc = buf + 4;
> -	while (desc < buf + vpd_len) {
> +	desc = sdev->vpd_pg83 + 4;
> +	while (desc < sdev->vpd_pg83 + sdev->vpd_pg83_len) {
>  		enum scsi_protocol proto = desc[0] >> 4;
>  		u8 code_set = desc[0] & 0x0f;
>  		u8 piv = desc[1] & 0x80;
> @@ -478,25 +470,15 @@ static void ses_match_to_enclosure(struct enclosure_device *edev,
>  
>  		if (piv && code_set == 1 && assoc == 1
>  		    && proto == SCSI_PROTOCOL_SAS && type == 3 && len == 8)
> -			efd.addr = (u64)desc[4] << 56 |
> -				(u64)desc[5] << 48 |
> -				(u64)desc[6] << 40 |
> -				(u64)desc[7] << 32 |
> -				(u64)desc[8] << 24 |
> -				(u64)desc[9] << 16 |
> -				(u64)desc[10] << 8 |
> -				(u64)desc[11];
> +			efd.addr = get_unaligned_be64(&desc[4]);
>  
>  		desc += len + 4;
>  	}
> -	if (!efd.addr)
> -		goto free;
> +	if (efd.addr) {
> +		efd.dev = &sdev->sdev_gendev;
>  
> -	efd.dev = &sdev->sdev_gendev;
> -
> -	enclosure_for_each_device(ses_enclosure_find_by_addr, &efd);
> - free:
> -	kfree(buf);
> +		enclosure_for_each_device(ses_enclosure_find_by_addr, &efd);
> +	}
>  }
>  
>  static int ses_intf_add(struct device *cdev,


