From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH 08/10] scsi: use per-cpu buffer for formatting
 scsi_print_result()
Date: Fri, 14 Nov 2014 22:20:36 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B4029593A85DA@G9W0745.americas.hpqcorp.net>
References: <1415262639-121586-1-git-send-email-hare@suse.de>
 <1415262639-121586-9-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3425.houston.hp.com ([15.201.208.53]:49578 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161814AbaKNWYc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Nov 2014 17:24:32 -0500
In-Reply-To: <1415262639-121586-9-git-send-email-hare@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ewan Milne <emilne@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.de]
> Sent: Thursday, 06 November, 2014 2:31 AM
...
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
...
> diff --git a/drivers/scsi/scsi_logging.c
> b/drivers/scsi/scsi_logging.c
> index 065792a3..e7e7cab 100644
> --- a/drivers/scsi/scsi_logging.c
> +++ b/drivers/scsi/scsi_logging.c
> @@ -398,3 +398,47 @@ void scsi_print_sense(const struct scsi_cmnd
> *cmd)
>  			     cmd->sense_buffer, SCSI_SENSE_BUFFERSIZE);
>  }
>  EXPORT_SYMBOL(scsi_print_sense);
> +
> +void scsi_print_result(struct scsi_cmnd *cmd, const char *msg, int
> disposition)

Since this function does not modify anything pointed to by cmd,
consider adding const to that argument.

> +{
> +	char *logbuf;
> +	size_t off, logbuf_len;
> +	const char *mlret_string = scsi_mlreturn_string(disposition);

As mentioned in the last series, it might be good to
change the midlayer string from SUCCESS to COMPLETE,
since that is printed even for commands that fail with
errors.  

(This patch series doesn't touch that function, so mentioning
the issue here at the only caller)

>
> +	const char *hb_string = scsi_hostbyte_string(cmd->result);
> +	const char *db_string = scsi_driverbyte_string(cmd->result);
> +
> +	logbuf = scsi_log_reserve_buffer(&logbuf_len);
> +	if (!logbuf)
> +		return;
> +
> +	off = sdev_format_header(logbuf, logbuf_len,
> +				 scmd_name(cmd), cmd->request->tag);
> +
> +	if (msg)
> +		off += scnprintf(logbuf + off, logbuf_len - off,
> +				 "%s: ", msg);
> +	if (mlret_string)
> +		off += scnprintf(logbuf + off, logbuf_len - off,
> +				 "%s ", mlret_string);
> +	else
> +		off += scnprintf(logbuf + off, logbuf_len - off,
> +				 "UNKNOWN(0x%02x) ", disposition);
> +	off += scnprintf(logbuf + off, logbuf_len - off, "Result: ");
...

Consider printing "Result: " first.  That would make
the messages more consistent since "Done:" is not always there.

Current:
 [491784.462209] sd 1:0:0:0: [sdq] tag#0 Done: SUCCESS Result: hostbyte=DID_OK driverbyte=DRIVER_OK
 [491784.464962] sd 1:0:0:0: [sdq] tag#0 CDB: Write(10) 2a 00 39 8c fa 80 00 00 08 00
 [  259.667383] sd 2:0:0:0: [sdr] tag#334 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
 [  259.667387] sd 2:0:0:0: [sdr] tag#334 Sense Key : Hardware Error [current]
 [  259.667391] sd 2:0:0:0: [sdr] tag#334 Add. Sense: Logical unit failure
 [  259.667395] sd 2:0:0:0: [sdr] tag#334 CDB: Read(10) 28 00 1b 85 9d 30 00 00 08 00
 [27907.647377] sd 1:0:0:0: [sdq] tag#768 Done: TIMEOUT_ERROR Result: hostbyte=DID_OK driverbyte=DRIVER_OK
 [27907.647380] sd 1:0:0:0: [sdq] tag#768 CDB: Write(10) 2a 00 39 8a f4 e0 00 00 08 00
 [27907.647382] sd 1:0:0:0: [sdq] tag#768 scmd ffff880424761470 abort scheduled

Proposed:
 [491784.462209] sd 1:0:0:0: [sdq] tag#0 Result: Done: COMPLETE hostbyte=DID_OK driverbyte=DRIVER_OK
 [491784.464962] sd 1:0:0:0: [sdq] tag#0 CDB: Write(10) 2a 00 39 8c fa 80 00 00 08 00
 [  259.667383] sd 2:0:0:0: [sdr] tag#334 Result: FAILED hostbyte=DID_OK driverbyte=DRIVER_SENSE
 [  259.667387] sd 2:0:0:0: [sdr] tag#334 Sense Key : Hardware Error [current]
 [  259.667391] sd 2:0:0:0: [sdr] tag#334 Add. Sense: Logical unit failure
 [  259.667395] sd 2:0:0:0: [sdr] tag#334 CDB: Read(10) 28 00 1b 85 9d 30 00 00 08 00
 [27907.647377] sd 1:0:0:0: [sdq] tag#768 Result: Done: TIMEOUT_ERROR hostbyte=DID_OK driverbyte=DRIVER_OK
 [27907.647380] sd 1:0:0:0: [sdq] tag#768 CDB: Write(10) 2a 00 39 8a f4 e0 00 00 08 00
 [27907.647382] sd 1:0:0:0: [sdq] tag#768 scmd ffff880424761470 abort scheduled

Furthermore, consider dropping "Done" (the only msg argument 
ever used) altogether.  "Done" means scsi_log_completion is
printing this. No "Done" means scsi_io_completion's ACTION_FAIL
case is printing this.

The disposition (COMPLETE, FAILED, TIMEOUT_ERROR, etc.) seems
to convey that same information, in more detail.


Reviewed-by: Robert Elliott <elliott@hp.com>

---
Rob Elliott    HP Server Storage



