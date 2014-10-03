From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH 05/24] scsi: Use sdev as argument for sense code printing
Date: Fri, 3 Oct 2014 00:32:00 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958CCBD3E@G4W3202.americas.hpqcorp.net>
References: <1412144580-72880-1-git-send-email-hare@suse.de>
 <1412144580-72880-6-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3427.houston.hp.com ([15.201.208.55]:57228 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbaJCAd5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Oct 2014 20:33:57 -0400
In-Reply-To: <1412144580-72880-6-git-send-email-hare@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.de]
...
> @@ -1369,49 +1372,53 @@ scsi_extd_sense_format(unsigned char asc, unsigned
> char ascq) {
>  EXPORT_SYMBOL(scsi_extd_sense_format);
> 
>  void
> -scsi_show_extd_sense(unsigned char asc, unsigned char ascq)
> +scsi_show_extd_sense(struct scsi_device *sdev, const char *name,
> +		     unsigned char asc, unsigned char ascq)

Since what sdev points to is not modified, that could be
const struct scsi_device *sdev.

(also adjust the function prototype in scsi_dbg.h to match)


>  {
> -        const char *extd_sense_fmt = scsi_extd_sense_format(asc, ascq);
> +	const char *extd_sense_fmt = NULL;
> +	const char *extd_sense_str = scsi_extd_sense_format(asc, ascq,
> +							    &extd_sense_fmt);
> +
> +	if (extd_sense_str) {
> +		if (extd_sense_fmt)
> +			sdev_prefix_printk(KERN_INFO, sdev, name,
> +					   "Add. Sense: %s (%s%x)",
> +					   extd_sense_str, extd_sense_fmt,
> +					   ascq);
> +		else
> +			sdev_prefix_printk(KERN_INFO, sdev, name,
> +					   "Add. Sense: %s", extd_sense_str);
> 
> -	if (extd_sense_fmt) {
> -		if (strstr(extd_sense_fmt, "%x")) {
> -			printk("Add. Sense: ");
> -			printk(extd_sense_fmt, ascq);
> -		} else
> -			printk("Add. Sense: %s", extd_sense_fmt);
>  	} else {
> -		if (asc >= 0x80)
> -			printk("<<vendor>> ASC=0x%x ASCQ=0x%x", asc,
> -			       ascq);
> -		if (ascq >= 0x80)
> -			printk("ASC=0x%x <<vendor>> ASCQ=0x%x", asc,
> -			       ascq);
> -		else
> -			printk("ASC=0x%x ASCQ=0x%x", asc, ascq);
> +		sdev_prefix_printk(KERN_INFO, sdev, name,
> +				   "%sASC=0x%x %sASCQ=0x%x\n",
> +				   asc >= 0x80 ? "<<vendor>> " : "", asc,
> +				   ascq >= 0x80 ? "<<vendor>> " : "", ascq);
>  	}
> -
> -	printk("\n");
>  }
>  EXPORT_SYMBOL(scsi_show_extd_sense);
> 
>  void
> -scsi_show_sense_hdr(struct scsi_sense_hdr *sshdr)
> +scsi_show_sense_hdr(struct scsi_device *sdev, const char *name,
> +		    struct scsi_sense_hdr *sshdr)

Add const for *sdev and *sshdr.

The latter requires also adding const to the argument in
scsi_sense_is_deferred() in scsi_eh.h.


...
> @@ -1419,12 +1426,11 @@ EXPORT_SYMBOL(scsi_show_sense_hdr);
>   * Print normalized SCSI sense header with a prefix.
>   */
>  void
> -scsi_print_sense_hdr(const char *name, struct scsi_sense_hdr *sshdr)
> +scsi_print_sense_hdr(struct scsi_device *sdev, const char *name,
> +		     struct scsi_sense_hdr *sshdr)

Add const for *sdev and *sshdr.

...
> @@ -1513,33 +1519,26 @@ scsi_decode_sense_extras(const unsigned char
> *sense_buffer, int sense_len,
>  }
> 
>  /* Normalize and print sense buffer with name prefix */
> -void __scsi_print_sense(const char *name, const unsigned char *sense_buffer,
> -			int sense_len)
> +void __scsi_print_sense(struct scsi_device *sdev, const char *name,
> +			const unsigned char *sense_buffer, int sense_len)

Add const for *sdev.

>  {
>  	struct scsi_sense_hdr sshdr;
> 
> -	printk(KERN_INFO "%s: ", name);
>  	scsi_decode_sense_buffer(sense_buffer, sense_len, &sshdr);
> -	scsi_show_sense_hdr(&sshdr);
> +	scsi_show_sense_hdr(sdev, name, &sshdr);
>  	scsi_decode_sense_extras(sense_buffer, sense_len, &sshdr);
> -	printk(KERN_INFO "%s: ", name);
> -	scsi_show_extd_sense(sshdr.asc, sshdr.ascq);
> +	scsi_show_extd_sense(sdev, name, sshdr.asc, sshdr.ascq);
>  }
>  EXPORT_SYMBOL(__scsi_print_sense);
> 
>  /* Normalize and print sense buffer in SCSI command */
> -void scsi_print_sense(char *name, struct scsi_cmnd *cmd)
> +void scsi_print_sense(struct scsi_cmnd *cmd)
...

Add const for *cmd.


---
Rob Elliott    HP Server Storage





