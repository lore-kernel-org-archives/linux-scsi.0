From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH 20/24] sd: Cleanup logging
Date: Fri, 3 Oct 2014 02:23:08 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958CCBEC7@G4W3202.americas.hpqcorp.net>
References: <1412144580-72880-1-git-send-email-hare@suse.de>
 <1412144580-72880-21-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3425.houston.hp.com ([15.201.208.53]:23275 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479AbaJCCZK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Oct 2014 22:25:10 -0400
In-Reply-To: <1412144580-72880-21-git-send-email-hare@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.de]
...
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
...
> @@ -3328,9 +3319,19 @@ static void sd_print_sense_hdr(struct scsi_disk *sdkp,
>  			     sshdr->asc, sshdr->ascq);
>  }
> 
> -static void sd_print_result(struct scsi_disk *sdkp, int result)
> +static void sd_print_result(struct scsi_disk *sdkp, const char *msg,
> +			    int result)
>  {
> -	sd_printk(KERN_INFO, sdkp, " ");
> -	scsi_show_result(result);
> +	const char *hb_string = scsi_hostbyte_string(result);
> +	const char *db_string = scsi_driverbyte_string(result);
> +
> +	if (hb_string && db_string)
> +		sd_printk(KERN_INFO, sdkp,
> +			  "%s: Result: hostbyte=%s driverbyte=%s\n",
> +			  msg, hb_string, db_string);
> +	else
> +		sd_printk(KERN_INFO, sdkp,
> +			  "%s: Result: hostbyte=0x%02x driverbyte=0x%02x\n",
> +			  msg, host_byte(result), driver_byte(result));

In a similar construct, patch 19 used || in scsi_print_result
to choose the string path, and printed "invalid" if one
of the strings was NULL.  They should probably match.


---
Rob Elliott    HP Server Storage



