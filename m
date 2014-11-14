From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH 07/10] scsi: use per-cpu buffer for formatting sense
Date: Fri, 14 Nov 2014 16:52:50 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B4029593A7F02@G9W0745.americas.hpqcorp.net>
References: <1415262639-121586-1-git-send-email-hare@suse.de>
 <1415262639-121586-8-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3425.houston.hp.com ([15.201.208.53]:20116 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935267AbaKNQze convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Nov 2014 11:55:34 -0500
In-Reply-To: <1415262639-121586-8-git-send-email-hare@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ewan Milne <emilne@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.de]
> Sent: Thursday, 06 November, 2014 2:31 AM
...

> diff --git a/drivers/scsi/scsi_logging.c
...
> @@ -249,3 +255,146 @@ void scsi_print_command(struct scsi_cmnd *cmd)
>  	}
>  }
>  EXPORT_SYMBOL(scsi_print_command);
> +
> +static size_t
> +scsi_format_extd_sense(char *buffer, size_t buf_len,
> +		       unsigned char asc, unsigned char ascq)
> +{
> +	size_t off = 0;
> +	const char *extd_sense_fmt = NULL;
> +	const char *extd_sense_str = scsi_extd_sense_format(asc, ascq,
> +							    &extd_sense_fmt);

As Dan Carpenter noted, there's a missing {} in 
scsi_extd_sense_format (from the previous logging series)
that causes it to return incorrectly.

...
> +static void
> +scsi_log_print_sense_hdr(const struct scsi_device *sdev, const char
> *name,
> +			 int tag, const struct scsi_sense_hdr *sshdr)
> +{
> +	char *logbuf;
> +	size_t off, logbuf_len;
> +
> +	logbuf = scsi_log_reserve_buffer(&logbuf_len);
> +	if (!logbuf)
> +		return;
> +	off = sdev_format_header(logbuf, logbuf_len, name, tag);
> +	off += scsi_format_sense_hdr(logbuf + off, logbuf_len - off,
> sshdr);
> +	dev_printk(KERN_INFO, &sdev->sdev_gendev, logbuf);
> +	scsi_log_release_buffer(logbuf);
> +
> +	logbuf = scsi_log_reserve_buffer(&logbuf_len);
> +	if (!logbuf)
> +		return;
> +	off = sdev_format_header(logbuf, logbuf_len, name, tag);
> +	off += scsi_format_extd_sense(logbuf + off, logbuf_len - off,
> +				      sshdr->asc, sshdr->ascq);
> +	dev_printk(KERN_INFO, &sdev->sdev_gendev, logbuf);
> +	scsi_log_release_buffer(logbuf);
> +}

This releases the buffer, but reserves it on the next line.
Should the buffer just be held between these two portions?
The subfunctions being called aren't functions that will cause
delays and thus delay other functions waiting on a buffer.
Although the tag on each line helps tremendously, the serial
log will be even more readable if the prints are back-to-back.

The same question applies to scsi_print_command in patch 05/10.
That function prints several lines in a for loop (for long CDBs):

+		for (k = 0; k < cmd->cmd_len; k += 16) {
+			size_t linelen = min(cmd->cmd_len - k, 16);
+
+			logbuf = scsi_log_reserve_buffer(&logbuf_len);
...
+			scsi_log_release_buffer(logbuf);
+		}

Perhaps the reserve/release should be outside the for loop
so they all reuse one buffer and are printed adjacently.

...
> +/* Normalize and print sense buffer in SCSI command */
> +void scsi_print_sense(const struct scsi_cmnd *cmd)
> +{
> +	struct gendisk *disk = cmd->request->rq_disk;
> +	const char *disk_name = disk ? disk->disk_name : NULL;
> +	scsi_log_print_sense(cmd->device, disk_name, cmd->request->tag,
> +			     cmd->sense_buffer, SCSI_SENSE_BUFFERSIZE);
> +}
> +EXPORT_SYMBOL(scsi_print_sense);

This function should use the new scmd_name function, which does:
        return scmd->request->rq_disk ?
                scmd->request->rq_disk->disk_name : NULL;


Reviewed-by: Robert Elliott <elliott@hp.com>


---
Rob Elliott    HP Server Storage


