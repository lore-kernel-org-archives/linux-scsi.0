From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH 03/10] scsi: Implement per-cpu logging buffer
Date: Thu, 13 Nov 2014 02:22:29 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B4029593A1317@G9W0745.americas.hpqcorp.net>
References: <1415262639-121586-1-git-send-email-hare@suse.de>
 <1415262639-121586-4-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3425.houston.hp.com ([15.201.208.53]:30294 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117AbaKMCY2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Nov 2014 21:24:28 -0500
In-Reply-To: <1415262639-121586-4-git-send-email-hare@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ewan Milne <emilne@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

One more comment on this one (which was PATCH 01 in v1 of the series,
to which I sent most of my comments)...

> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.de]
> Sent: Thursday, 06 November, 2014 2:31 AM
> To: James Bottomley
> Cc: Christoph Hellwig; Ewan Milne; Elliott, Robert (Server Storage);
> linux-scsi@vger.kernel.org; Hannes Reinecke
> Subject: [PATCH 03/10] scsi: Implement per-cpu logging buffer
> 
> +++ b/drivers/scsi/scsi_logging.c
> @@ -0,0 +1,119 @@
...
> +static DEFINE_PER_CPU(struct scsi_log_buf, scsi_format_log);
> +
> +static char *scsi_log_reserve_buffer(size_t *len)
> +{
> +	struct scsi_log_buf *buf;
> +	unsigned long map_bits = SCSI_LOG_SPOOLSIZE / SCSI_LOG_BUFSIZE;

sizeof(buf->buffer) would be a bit safer than 
SCSI_LOG_SPOOLSIZE - adapts automatically if the real value
used in the structure definition ever changes.


---
Rob Elliott    HP Server Storage




