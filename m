From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH 6/6] scsi: use dev_printk variants where possible
Date: Wed, 22 Oct 2014 22:29:35 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B40295932131A@G4W3296.americas.hpqcorp.net>
References: <1401794577-102277-1-git-send-email-hare@suse.de>
 <1401794577-102277-7-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3426.houston.hp.com ([15.201.208.54]:56593 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932887AbaJVWaz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Oct 2014 18:30:55 -0400
In-Reply-To: <1401794577-102277-7-git-send-email-hare@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Hannes Reinecke
> Sent: Tuesday, 03 June, 2014 6:23 AM
> To: James Bottomley
> Cc: Christoph Hellwig; linux-scsi@vger.kernel.org; Hannes Reinecke
> Subject: [PATCH 6/6] scsi: use dev_printk variants where possible
> 
> Using dev_printk variants prefixes the logging message with
> the originating device, which makes debugging easier.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
...

This patch (91921e016a2199e7afe5933c94bd9f723d946598
in the kernel) has left the devname[64] variable in this 
function unused.  There is an sprintf setting it, but it is 
never read.

	char devname[64];
	...
	sprintf(devname, "host %d channel %d id %d",
                shost->host_no, sdev->channel, sdev->id);

Here are the former uses:

> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index e02b3aa..46563b1 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
...
> @@ -1430,17 +1433,19 @@ static int scsi_report_lun_scan(struct
> scsi_target *starget, int bflags,
>  	 * a retry.
>  	 */
>  	for (retries = 0; retries < 3; retries++) {
> -		SCSI_LOG_SCAN_BUS(3, printk (KERN_INFO "scsi scan:
> Sending"
> -				" REPORT LUNS to %s (try %d)\n", devname,
> +		SCSI_LOG_SCAN_BUS(3, sdev_printk (KERN_INFO, sdev,
> +				"scsi scan: Sending REPORT LUNS to (try
> %d)\n",
>  				retries));

The word "to" remains from:
	"to %s", devname 

but the switch to sdev_printk probably meant to delete "to" too.

...
> @@ -1466,10 +1471,11 @@ static int scsi_report_lun_scan(struct
> scsi_target *starget, int bflags,
> 
>  	num_luns = (length / sizeof(struct scsi_lun));
>  	if (num_luns > max_scsi_report_luns) {
> -		printk(KERN_WARNING "scsi: On %s only %d
> (max_scsi_report_luns)"
> -		       " of %d luns reported, try increasing"
> -		       " max_scsi_report_luns.\n", devname,
> -		       max_scsi_report_luns, num_luns);
> +		sdev_printk(KERN_WARNING, sdev,
> +			    "Only %d (max_scsi_report_luns)"
> +			    " of %d luns reported, try increasing"
> +			    " max_scsi_report_luns.\n",
> +			    max_scsi_report_luns, num_luns);
>  		num_luns = max_scsi_report_luns;
>  	}
> 
> @@ -1495,15 +1501,15 @@ static int scsi_report_lun_scan(struct
> scsi_target *starget, int bflags,
>  			 * this differs from what linux would print for the
>  			 * integer LUN value.
>  			 */
> -			printk(KERN_WARNING "scsi: %s lun 0x", devname);
> -			data = (char *)lunp->scsi_lun;
> -			for (i = 0; i < sizeof(struct scsi_lun); i++)
> -				printk("%02x", data[i]);
> -			printk(" has a LUN larger than currently
> supported.\n");
> +			sdev_printk(KERN_WARNING, sdev,
> +				    "lun 0x%8phN has a LUN larger"
> +				    " than currently supported.\n",
> +				    lunp->scsi_lun);
>  		} else if (lun > sdev->host->max_lun) {
> -			printk(KERN_WARNING "scsi: %s lun%d has a LUN
> larger"
> -			       " than allowed by the host adapter\n",
> -			       devname, lun);
> +			sdev_printk(KERN_WARNING, sdev,
> +				    "lun 0x%8phN has a LUN larger"
> +				    " than allowed by the host adapter\n",
> +				    lunp->scsi_lun);
>  		} else {
>  			int res;
> 
...
