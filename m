From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH 20/24] sd: Cleanup logging
Date: Thu, 2 Oct 2014 23:20:57 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958CCBCC5@G4W3202.americas.hpqcorp.net>
References: <1412144580-72880-1-git-send-email-hare@suse.de>
 <1412144580-72880-21-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3427.houston.hp.com ([15.201.208.55]:22506 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120AbaJBXWj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Oct 2014 19:22:39 -0400
In-Reply-To: <1412144580-72880-21-git-send-email-hare@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Elliott, Robert (Server Storage)" <Elliott@hp.com>, Hannes Reinecke <hare@suse.de>

> From: Hannes Reinecke [mailto:hare@suse.de]
...
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 848b17d..2cc8703 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -116,7 +116,7 @@ static int sd_eh_action(struct scsi_cmnd *, int);
>  static void sd_read_capacity(struct scsi_disk *sdkp, unsigned char *buffer);
>  static void scsi_disk_release(struct device *cdev);
>  static void sd_print_sense_hdr(struct scsi_disk *, struct scsi_sense_hdr *);
> -static void sd_print_result(struct scsi_disk *, int);
> +static void sd_print_result(struct scsi_disk *, const char *, int);
> 
>  static DEFINE_SPINLOCK(sd_index_lock);
>  static DEFINE_IDA(sd_index_ida);
> @@ -1479,7 +1479,7 @@ static int sd_sync_cache(struct scsi_disk *sdkp)
>  	}
> 
>  	if (res) {
> -		sd_print_result(sdkp, res);
> +		sd_print_result(sdkp, "SYNCHRONIZE_CACHE failed", res);

The cdb_byte0_names[] array in constants.c capitalizes
the candidates as:
	Synchronize Cache(10)
	Synchronize cache(16)

Here, it's specifically the 10 byte version (so far), so
	Synchronize Cache(10) failed
might be a better string.  Or, if following SCSI standards,
	SYNCHRONIZE CACHE(10)
without the _ would be better.

Consider changing cdb_byte0_names to Synchronize Cache(16) too.
(it has a lot of inconsistent capitalization)

> 
>  		if (driver_byte(res) & DRIVER_SENSE)
>  			sd_print_sense_hdr(sdkp, &sshdr);
> @@ -1700,17 +1700,9 @@ static int sd_done(struct scsi_cmnd *SCpnt)
>  		if (sense_valid)
>  			sense_deferred = scsi_sense_is_deferred(&sshdr);
>  	}
> -#ifdef CONFIG_SCSI_LOGGING
> -	SCSI_LOG_HLCOMPLETE(1, scsi_print_result(SCpnt));
> -	if (sense_valid) {
> -		SCSI_LOG_HLCOMPLETE(1, scmd_printk(KERN_INFO, SCpnt,
> -						   "sd_done: sb[respc,sk,asc,"
> -						   "ascq]=%x,%x,%x,%x\n",
> -						   sshdr.response_code,
> -						   sshdr.sense_key, sshdr.asc,
> -						   sshdr.ascq));
> -	}
> -#endif
> +	SCSI_LOG_HLCOMPLETE(1, scmd_printk(KERN_INFO, SCpnt,
> +					   "sd_done: completed %d bytes\n",
> +					   good_bytes));

Printing good_bytes here is misleading, because it is 
subsequently changed from 0 to nonzero in these cases:
* HARDWARE ERROR sense key
* MEDIUM ERROR sense key
* RECOVERED ERROR sense key
* ABORTED COMMAND sense key for ASC 0x10
* ILLEGAL REQUEST sense key for ASC 0x10
* ILLEGAL REQUEST sense key for ASC/ASCQ 0x20/0x24 
	for WRITE SAME without the UNMAP bit

Suggestions:
1. Move the print down after the out: label, when good_bytes
has reached its final value.

2. Indicate if the command was able to transfer all the bytes
by adding:
	"%d of %d bytes" good_bytes, scsi_bufflen(SCpnt) 

>  	sdkp->medium_access_timed_out = 0;
> 
>  	if (driver_byte(result) != DRIVER_SENSE &&
> @@ -1820,12 +1812,12 @@ sd_spinup_disk(struct scsi_disk *sdkp)
>  			/* no sense, TUR either succeeded or failed
>  			 * with a status error */
>  			if(!spintime && !scsi_status_is_good(the_result)) {
> -				sd_printk(KERN_NOTICE, sdkp, "Unit Not Ready\n");
> -				sd_print_result(sdkp, the_result);
> +				sd_print_result(sdkp, "Unit Not Ready",
> +						the_result);

"unit" by itself is not a real SCSI term.  "Logical Unit Not 
Ready" would be better, but this is printed for all non-GOOD 
status values, not just CHECK CONDITION status with a sense 
key of NOT READY and one of many additional sense codes with 
"LOGICAL UNIT NOT READY" in their names.

Following the other prints in this patch, how about this?
	"TEST UNIT READY failed"

>  			}
>  			break;
>  		}
> -
> +
>  		/*
>  		 * The device does not want the automatic start to be issued.
>  		 */
> @@ -1941,7 +1933,7 @@ static void read_capacity_error(struct scsi_disk *sdkp,
> struct scsi_device *sdp,
>  			struct scsi_sense_hdr *sshdr, int sense_valid,
>  			int the_result)
>  {
> -	sd_print_result(sdkp, the_result);
> +	sd_print_result(sdkp, "READ CAPACITY failed", the_result);

The cdb_byte0_names[] array in constants.c capitalizes
the candidates as:
	Read Capacity(10)
	Read capacity(16)

The two callers to this function already print the opcode
name, using all caps and not printing "(10)", at the
KERN_NOTICE level:
                sd_printk(KERN_NOTICE, sdkp, "READ CAPACITY(16) failed\n");
                read_capacity_error(sdkp, sdp, &sshdr, sense_valid, the_result);

                sd_printk(KERN_NOTICE, sdkp, "READ CAPACITY failed\n");
                read_capacity_error(sdkp, sdp, &sshdr, sense_valid, the_result);

sd_print_result uses the KERN_INFO level.

To follow cdb_byte0_names, use "Read Capacity(10)" and
"Read capacity(16)" in the callers.

To follow SCSI standards, add "(10)" in the second caller.

Consider changing cdb_byte0_names to "Read Capacity(16)" too.

>  	if (driver_byte(the_result) & DRIVER_SENSE)
>  		sd_print_sense_hdr(sdkp, sshdr);
>  	else
> @@ -3126,8 +3118,7 @@ static int sd_start_stop_device(struct scsi_disk *sdkp,
> int start)
>  	res = scsi_execute_req_flags(sdp, cmd, DMA_NONE, NULL, 0, &sshdr,
>  			       SD_TIMEOUT, SD_MAX_RETRIES, NULL, REQ_PM);
>  	if (res) {
> -		sd_printk(KERN_WARNING, sdkp, "START_STOP FAILED\n");
> -		sd_print_result(sdkp, res);
> +		sd_print_result(sdkp, "START_STOP failed", res);

To follow cdb_byte0_names, use "Start/Stop Unit".
To follow SCSI standards, use "START STOP UNIT".

Since this command can request start, stop, or
various power conditions, it might be helpful to include:
	start=%d pwr_cond=0x%x",
		cmd[4] & 0x1,
		cmd[4] >> 4 & 0xf


>  		if (driver_byte(res) & DRIVER_SENSE)
>  			sd_print_sense_hdr(sdkp, &sshdr);
>  		if (scsi_sense_valid(&sshdr) &&
> @@ -3328,9 +3319,19 @@ static void sd_print_sense_hdr(struct scsi_disk *sdkp,
>  			     sshdr->asc, sshdr->ascq);
>  }
> 
> -static void sd_print_result(struct scsi_disk *sdkp, int result)
> +static void sd_print_result(struct scsi_disk *sdkp, const char *msg,
> +			    int result)
...

Since what sdkp points to is not modified, the first argument 
could be:
	const struct scsi_disk *sdkp


---
Rob Elliott    HP Server Storage



