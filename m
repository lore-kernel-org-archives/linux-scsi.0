From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH 04/10] scsi: log request tag for scmd_printk()
Date: Wed, 12 Nov 2014 17:18:20 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B4029593990F0@G9W0745.americas.hpqcorp.net>
References: <1415262639-121586-1-git-send-email-hare@suse.de>
 <1415262639-121586-5-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3426.houston.hp.com ([15.201.208.54]:22109 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087AbaKLRTc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Nov 2014 12:19:32 -0500
In-Reply-To: <1415262639-121586-5-git-send-email-hare@suse.de>
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
> Subject: [PATCH 04/10] scsi: log request tag for scmd_printk()
> 
> The request tag provides a concise identification of a SCSI
> command, so we should be printing that out for scmd_printk().
> 
> Suggested-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/scsi_logging.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_logging.c
> b/drivers/scsi/scsi_logging.c
> index 4a76796..dca45fe 100644
> --- a/drivers/scsi/scsi_logging.c
> +++ b/drivers/scsi/scsi_logging.c
> @@ -109,6 +109,10 @@ int scmd_printk(const char *level, const struct
> scsi_cmnd *scmd,
>  	if (disk)
>  		off += scnprintf(logbuf + off, logbuf_len - off,
>  				 "[%s] ", disk->disk_name);
> +
> +	if (scmd->request->tag >= 0)
> +		off += scnprintf(logbuf + off, logbuf_len - off,
> +				 "tag#%d ", scmd->request->tag);
>  	va_start(args, fmt);
>  	off += vscnprintf(logbuf + off, logbuf_len - off, fmt, args);
>  	va_end(args);
> --
> 1.8.5.2

Reviewed-by: Robert Elliott <elliott@hp.com>

