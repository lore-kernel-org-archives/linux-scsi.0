From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: TYPE_RBC cache fixes (sbp2.c affected)
Date: Wed, 22 Feb 2006 08:08:14 +0100
Message-ID: <43FC0DDE.1050805@s5r6.in-berlin.de>
References: <20050516015955.GL1150@parcelfarce.linux.theplanet.co.uk> <43EA8128.9000205@s5r6.in-berlin.de> <20060208235415.GL27946@ftp.linux.org.uk> <43EDB35F.40709@s5r6.in-berlin.de> <20060220060845.GS27946@ftp.linux.org.uk> <43FB7058.4040008@s5r6.in-berlin.de> <20060221215144.GW27946@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-admin@lists.sourceforge.net>
In-Reply-To: <20060221215144.GW27946@ftp.linux.org.uk>
Sender: linux1394-devel-admin@lists.sourceforge.net
Errors-To: linux1394-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux1394-devel>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, linux1394-devel@lists.sourceforge.net
List-Id: linux-scsi@vger.kernel.org

Al Viro wrote:
...

Al, James,

what if we downsize this patch to...

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

...only these two lines and...

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

...these 6 lines here? We would miss what can be extracted from these 
buggy devices but (a) sd_read_cache_type::bad_sense's defaults work IMO 
well enough for the so far reported devices and (b) these are the 
particular checks which protect sd from out-of-bound memory access not 
only in case of the Initio-specific breakage.

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
-=====-=-==- --=- =-==-
http://arcgraph.de/sr/


-------------------------------------------------------
This SF.net email is sponsored by: Splunk Inc. Do you grep through log files
for problems?  Stop!  Download the new AJAX search engine that makes
searching your log files as easy as surfing the  web.  DOWNLOAD SPLUNK!
http://sel.as-us.falkag.net/sel?cmd=lnk&kid=103432&bid=230486&dat=121642
