From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH 05/10] scsi: use external buffer for command logging
Date: Thu, 13 Nov 2014 02:24:57 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B4029593A1332@G9W0745.americas.hpqcorp.net>
References: <1415262639-121586-1-git-send-email-hare@suse.de>
 <1415262639-121586-6-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3426.houston.hp.com ([15.201.208.54]:25560 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117AbaKMC1I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Nov 2014 21:27:08 -0500
In-Reply-To: <1415262639-121586-6-git-send-email-hare@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ewan Milne <emilne@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.de]
> Sent: Thursday, 06 November, 2014 2:31 AM
> To: James Bottomley
> Cc: Christoph Hellwig; Ewan Milne; Elliott, Robert (Server Storage);
> linux-scsi@vger.kernel.org; Hannes Reinecke
> Subject: [PATCH 05/10] scsi: use external buffer for command logging
> 
...
> diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
> index 4f502f9..ed0d10d 100644
> --- a/drivers/scsi/ch.c
> +++ b/drivers/scsi/ch.c
> @@ -195,8 +195,10 @@ ch_do_scsi(scsi_changer *ch, unsigned char *cmd,
> int cmd_len,
>   retry:
>  	errno = 0;
>  	if (debug) {
> -		DPRINTK("command: ");
> -		__scsi_print_command(cmd, cmd_len);
> +		char logbuf[SCSI_LOG_BUFSIZE];
> +
> +		__scsi_format_command(logbuf, SCSI_LOG_BUFSIZE, cmd,
> cmd_len);

Use sizeof(logbuf) rather than SCSI_LOG_BUFSIZE to avoid 
the macro name ever mismatching.

> +		DPRINTK("command: %s", logbuf);
>  	}
> 
>  	result = scsi_execute_req(ch->device, cmd, direction, buffer,
...
> diff --git a/drivers/scsi/scsi_logging.c
> b/drivers/scsi/scsi_logging.c
> index dca45fe..d166d12 100644
> --- a/drivers/scsi/scsi_logging.c
> +++ b/drivers/scsi/scsi_logging.c
> @@ -13,10 +13,10 @@
>  #include <scsi/scsi.h>
>  #include <scsi/scsi_cmnd.h>
>  #include <scsi/scsi_device.h>
> +#include <scsi/scsi_eh.h>
>  #include <scsi/scsi_dbg.h>
> 
>  #define SCSI_LOG_SPOOLSIZE 4096
> -#define SCSI_LOG_BUFSIZE 128
> 
>  struct scsi_log_buf {
>  	char buffer[SCSI_LOG_SPOOLSIZE];
> @@ -64,6 +64,21 @@ static void scsi_log_release_buffer(char *bufptr)
>  	preempt_enable();
>  }
> 
> +static size_t scmd_format_header(char *logbuf, size_t logbuf_len,
> +				 struct gendisk *disk, int tag)
> +{
> +	size_t off = 0;
> +
> +	if (disk)
> +		off += scnprintf(logbuf + off, logbuf_len - off,
> +				 "[%s] ", disk->disk_name);
> +
> +	if (tag >= 0)
> +		off += scnprintf(logbuf + off, logbuf_len - off,
> +				 "tag#%d ", tag);

If the first scnprintf consumes the full logbuf_len, then
logbuf_len - off will cause an unsigned wrap (since it's
using size_t types; it'd go negative if it used signed types), 
triggering this from vsnprintf (called by scnprintf):
        if (WARN_ON_ONCE((int) size < 0))
                return 0;

It might be prudent to check that it hasn't gone too far
before calling scnprintf again.

> +	return off;
> +}
> +
>  int sdev_prefix_printk(const char *level, const struct scsi_device
> *sdev,
>  		       const char *name, const char *fmt, ...)
>  {
> @@ -106,13 +121,8 @@ int scmd_printk(const char *level, const struct
> scsi_cmnd *scmd,
>  	logbuf = scsi_log_reserve_buffer(&logbuf_len);
>  	if (!logbuf)
>  		return 0;
> -	if (disk)
> -		off += scnprintf(logbuf + off, logbuf_len - off,
> -				 "[%s] ", disk->disk_name);
> -
> -	if (scmd->request->tag >= 0)
> -		off += scnprintf(logbuf + off, logbuf_len - off,
> -				 "tag#%d ", scmd->request->tag);
> +	off = scmd_format_header(logbuf, logbuf_len, disk,
> +				 scmd->request->tag);
>  	va_start(args, fmt);

Same comment about ensuring off hasn't gone too far.

>  	off += vscnprintf(logbuf + off, logbuf_len - off, fmt, args);
>  	va_end(args);
> @@ -121,3 +131,121 @@ int scmd_printk(const char *level, const struct
> scsi_cmnd *scmd,
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(scmd_printk);
> +
> +static size_t scsi_format_opcode_name(char *buffer, size_t buf_len,
> +				      const unsigned char *cdbp)
> +{
> +	int sa, cdb0;
> +	const char *cdb_name = NULL, *sa_name = NULL;
> +	size_t off;
> +
> +	cdb0 = cdbp[0];
> +	if (cdb0 == VARIABLE_LENGTH_CMD) {
> +		int len = scsi_varlen_cdb_length(cdbp);
> +
> +		if (len < 10) {
> +			off = scnprintf(buffer, buf_len,
> +					"short variable length command,
> len=%d",
> +					len);
> +			return off;
> +		}
> +		sa = (cdbp[8] << 8) + cdbp[9];
> +	} else
> +		sa = cdbp[1] & 0x1f;
> +
> +	if (!scsi_opcode_sa_name(cdb0, sa, &cdb_name, &sa_name)) {
> +		if (cdb_name)
> +			off = scnprintf(buffer, buf_len, "%s", cdb_name);
> +		else {
> +			off = scnprintf(buffer, buf_len, "cdb[0]=0x%x",
> cdb0);

Since the service action is printed using "sa=" below,
consider using "op=" or "opcode=" rather than "cdb[0]=".
That might be clearer to readers who don't know the CDB
layout but do have an opcode table handy.


> +			if (cdb0 > VENDOR_SPECIFIC_CDB)

The > should be >= since that define is 0xc0 (which itself
is vendor-specific).

> +				off += scnprintf(buffer + off, buf_len -
> off,
> +						 " (vendor)");
> +			else if (cdb0 > 0x60 && cdb0 < 0x7e)

The > should be >= since 0x60 is reserved.  
The < is correct (0x7e is "extended CDB").


> +				off += scnprintf(buffer + off, buf_len -
> off,
> +						 " (reserved)");
> +		}
> +	} else {
> +		if (sa_name)
> +			off = scnprintf(buffer, buf_len, "%s", sa_name);
> +		else if (cdb_name)
> +			off = scnprintf(buffer, buf_len, "%s, sa=0x%x",
> +					cdb_name, sa);
> +		else
> +			off = scnprintf(buffer, buf_len,
> +					"cdb[0]=0x%x, sa=0x%x", cdb0, sa);
> +	}
> +	return off;
> +}
> +
> +size_t __scsi_format_command(char *logbuf, size_t logbuf_len,
> +			     const unsigned char *cdb, size_t cdb_len)
> +{
> +	int len, k;
> +	size_t off;
> +
> +	off = scsi_format_opcode_name(logbuf, logbuf_len, cdb);
> +	len = scsi_command_size(cdb);
> +	if (cdb_len < len)
> +		len = cdb_len;
> +	/* print out all bytes in cdb */
> +	for (k = 0; k < len; ++k) {
> +		if (off + 3 > logbuf_len)
> +			break;

Might need a check for logbuf_len - off causing an unsigned
wraparound problem before proceeding to scnprintf.


> +		off += scnprintf(logbuf + off, logbuf_len - off,
> +				 " %02x", cdb[k]);
> +	}
> +	return off;
> +}
> +EXPORT_SYMBOL(__scsi_format_command);
> +
> +void scsi_print_command(struct scsi_cmnd *cmd)
> +{
> +	struct gendisk *disk = cmd->request->rq_disk;
> +	int k;
> +	char *logbuf;
> +	size_t off, logbuf_len;
> +
> +	if (cmd->cmnd == NULL)
> +		return;

Using !cmd->cmnd seems more common in SCSI midlayer code.

> +
> +	logbuf = scsi_log_reserve_buffer(&logbuf_len);
> +	if (!logbuf)
> +		return;
> +
> +	off = scmd_format_header(logbuf, logbuf_len, disk, cmd-
> >request->tag);

Repeat the logbuf_len - off wraparound concern.

> +	off += scnprintf(logbuf + off, logbuf_len - off, "CDB: ");

Repeat the logbuf_len - off wraparound concern.

> +	off += scsi_format_opcode_name(logbuf + off, logbuf_len - off,
> +				       cmd->cmnd);
> +	/* print out all bytes in cdb */
> +	if (cmd->cmd_len > 16) {
> +		/* Print opcode in one line and use separate lines for
> CDB */
> +		off += scnprintf(logbuf + off, logbuf_len - off, "\n");
> +		dev_printk(KERN_INFO, &cmd->device->sdev_gendev, logbuf);
> +		scsi_log_release_buffer(logbuf);
> +		for (k = 0; k < cmd->cmd_len; k += 16) {
> +			size_t linelen = min(cmd->cmd_len - k, 16);
> +
> +			logbuf = scsi_log_reserve_buffer(&logbuf_len);
> +			if (!logbuf)
> +				break;
> +			off = scmd_format_header(logbuf, logbuf_len, disk,
> +						 cmd->request->tag);

Repeat the logbuf_len - off wraparound concern.

> +			off += scnprintf(logbuf + off, logbuf_len - off,
> +					 "CDB[%02x]: ", k);

Repeat the logbuf_len - off wraparound concern.

> +			hex_dump_to_buffer(&cmd->cmnd[k], linelen, 16, 1,
> +					   logbuf + off, logbuf_len - off,
> +					   false);
> +			dev_printk(KERN_INFO, &cmd->device->sdev_gendev,
> +				   logbuf);
> +			scsi_log_release_buffer(logbuf);
> +		}
> +	} else {
> +		off += scnprintf(logbuf + off, logbuf_len - off, " ");

Repeat the logbuf_len - off wraparound concern.

> +		hex_dump_to_buffer(cmd->cmnd, cmd->cmd_len, 16, 1,
> +				   logbuf + off, logbuf_len - off, false);
> +		dev_printk(KERN_INFO, &cmd->device->sdev_gendev, logbuf);
> +		scsi_log_release_buffer(logbuf);
> +	}
> +}
> +EXPORT_SYMBOL(scsi_print_command);
> diff --git a/drivers/scsi/sr_ioctl.c b/drivers/scsi/sr_ioctl.c
> index fb929fa..4f9fb3c 100644
> --- a/drivers/scsi/sr_ioctl.c
> +++ b/drivers/scsi/sr_ioctl.c
> @@ -188,6 +188,7 @@ int sr_do_ioctl(Scsi_CD *cd, struct
> packet_command *cgc)
>  	struct scsi_sense_hdr sshdr;
>  	int result, err = 0, retries = 0;
>  	struct request_sense *sense = cgc->sense;
> +	char logbuf[SCSI_LOG_BUFSIZE];
> 
>  	SDev = cd->device;
> 
> @@ -257,14 +258,20 @@ int sr_do_ioctl(Scsi_CD *cd, struct
> packet_command *cgc)
>  				/* sense: Invalid command operation code */
>  				err = -EDRIVE_CANT_DO_THIS;
>  #ifdef DEBUG
> -			__scsi_print_command(cgc->cmd, CDROM_PACKET_SIZE);
> +			__scsi_format_command(logbuf, SCSI_LOG_BUFSIZE,
> +					      cgc->cmd, CDROM_PACKET_SIZE);

Use sizeof(logbuf) rather than SCSI_LOG_BUFSIZE to avoid 
the macro name ever mismatching.

> +			sr_printk(KERN_INFO, cd,
> +				  "CDROM (ioctl) invalid command: %s\n",
> +				  logbuf);
>  			scsi_print_sense_hdr(cd->device, cd->cdi.name,
> &sshdr);
>  #endif
>  			break;
>  		default:
> +			__scsi_format_command(logbuf, SCSI_LOG_BUFSIZE,
> +					      cgc->cmd, CDROM_PACKET_SIZE);

Use sizeof(logbuf) rather than SCSI_LOG_BUFSIZE to avoid 
the macro name ever mismatching.

>  			sr_printk(KERN_ERR, cd,
> -				  "CDROM (ioctl) error, command: ");
> -			__scsi_print_command(cgc->cmd, CDROM_PACKET_SIZE);
> +				  "CDROM (ioctl) error, command: %s\n",
> +				  logbuf);
>  			scsi_print_sense_hdr(cd->device, cd->cdi.name,
> &sshdr);
>  			err = -EIO;
>  		}
...

