From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: TYPE_RBC cache fixes (sbp2.c affected)
Date: Tue, 21 Feb 2006 23:41:10 +0100
Message-ID: <43FB9706.9010001@s5r6.in-berlin.de>
References: <20050516015955.GL1150@parcelfarce.linux.theplanet.co.uk> <43EA8128.9000205@s5r6.in-berlin.de> <20060208235415.GL27946@ftp.linux.org.uk> <43EDB35F.40709@s5r6.in-berlin.de> <20060220060845.GS27946@ftp.linux.org.uk> <43FB7058.4040008@s5r6.in-berlin.de> <20060221215144.GW27946@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:59320 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S1750948AbWBUWlV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Feb 2006 17:41:21 -0500
In-Reply-To: <20060221215144.GW27946@ftp.linux.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Al Viro <viro@ftp.linux.org.uk>
Cc: linux-scsi@vger.kernel.org, linux1394-devel@lists.sourceforge.net

Al Viro wrote:
> On Tue, Feb 21, 2006 at 08:56:08PM +0100, Stefan Richter wrote:
>>I suppose I should let sbp2_slave_configure check for 
>>this string in sdev->vendor and for sdev->type == TYPE_DISK, then bend 
>>sdev->type to TYPE_RBC. (Or set skip_ms_page_8; I will check how my disk 
>>behaves when forced to TYPE_RBC...)
> 
> 
> Same - it still forgets to generate proper header.
> 
> See if that helps (might allow killing that skip_ms_page_8 in those, BTW):

Yes, this works for me so far.

However someone pointed out to me that he still got memory corruption 
when running the stock driver with the skip_ms_page_8 workaround in 
sbp2, i.e. when sd_read_cache_type skips mode_sense altogether. I will 
proceed to test with DEBUG_SLAB.

> --- a/drivers/scsi/scsi_lib.c	2006-02-20 10:02:58.000000000 -0600
> +++ b/drivers/scsi/scsi_lib.c	2006-02-21 01:47:18.000000000 -0600
> @@ -1892,8 +1892,16 @@
>  	}
>  
>  	if(scsi_status_is_good(result)) {
> -		data->header_length = header_length;
> -		if(use_10_for_ms) {
> +		if (unlikely(buffer[0] == 0x86 && buffer[1] == 0x0b &&
> +			     (modepage == 6 || modepage == 8))) {
> +			/* Initio breakage? */
> +			header_length = 0;
> +			data->length = 13;
> +			data->medium_type = 0;
> +			data->device_specific = 0;
> +			data->longlba = 0;
> +			data->block_descriptor_length = 0;
> +		} else if(use_10_for_ms) {
>  			data->length = buffer[0]*256 + buffer[1] + 2;
>  			data->medium_type = buffer[2];
>  			data->device_specific = buffer[3];
> @@ -1906,6 +1914,7 @@
>  			data->device_specific = buffer[2];
>  			data->block_descriptor_length = buffer[3];
>  		}
> +		data->header_length = header_length;
>  	}
>  
>  	return result;
> --- a/drivers/scsi/sd.c	2006-02-17 16:26:52.000000000 -0600
> +++ b/drivers/scsi/sd.c	2006-02-20 18:15:44.000000000 -0600
> @@ -1328,6 +1328,12 @@
>  	if (!scsi_status_is_good(res))
>  		goto bad_sense;
>  
> +	if (!data.header_length) {
> +		modepage = 6;
> +		printk(KERN_ERR "%s: missing header in MODE_SENSE response\n",
> +		       diskname);
> +	}
> +
>  	/* that went OK, now ask for the proper length */
>  	len = data.length;
>  
> @@ -1342,6 +1348,8 @@
>  
>  	/* Take headers and block descriptors into account */
>  	len += data.header_length + data.block_descriptor_length;
> +	if (len > 512)
> +		goto bad_sense;
>  
>  	/* Get the data */
>  	res = sd_do_mode_sense(sdp, dbd, modepage, buffer, len, &data, &sshdr);
> @@ -1354,8 +1362,15 @@
>  		int ct = 0;
>  		int offset = data.header_length + data.block_descriptor_length;
>  
> +		if (offset >= 512 - 2) {
> +			printk(KERN_ERR "%s: malformed MODE SENSE response",
> +				diskname);
> +			goto defaults;
> +		}
> +
>  		if ((buffer[offset] & 0x3f) != modepage) {
> -			printk(KERN_ERR "%s: got wrong page\n", diskname);
> +			printk(KERN_ERR "%s: got wrong page (%d -> %d)\n",
> +				 diskname, modepage, buffer[offset] & 0x3f);
>  			goto defaults;
>  		}
>  
> 


-- 
Stefan Richter
-=====-=-==- --=- =-=-=
http://arcgraph.de/sr/
