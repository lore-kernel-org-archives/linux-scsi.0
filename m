From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 05/10] scsi: use per-cpu buffer for formatting sense
Date: Wed, 5 Nov 2014 23:33:13 -0800
Message-ID: <20141106073313.GA14854@infradead.org>
References: <1415088409-46590-1-git-send-email-hare@suse.de>
 <1415088409-46590-6-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43890 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883AbaKFHdR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Nov 2014 02:33:17 -0500
Content-Disposition: inline
In-Reply-To: <1415088409-46590-6-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, Ewan Milne <emilne@redhat.com>, Robert Elliott <elliott@hp.com>, linux-scsi@vger.kernel.org

> +#define scmd_format_header(b, l, d, t) \
> +	sdev_format_header(b, l, (d) ? (d)->disk_name : NULL, t)

I'd rather have a

static inline const char *scmd_name(struct scsi_cmnd *scmd)
{
	return scmd->request->rq_disk ?
		scmd->request->rq_disk->disk_name : NULL;
}

helper and use that directlu, which also gets rid of all the
local gendisk variables.

> +	if (scsi_sense_is_deferred(sshdr))
> +		off += scnprintf(buffer + off, buf_len - off, "[deferred] ");
> +	else
> +		off += scnprintf(buffer + off, buf_len - off, "[current] ");

	off += scnprintf(buffer + off, buf_len - off,
		scsi_sense_is_deferred(sshdr) ? "[deferred] " : "[current] ");

> +{
> +	struct scsi_sense_hdr sshdr;
> +
> +	if (!scsi_normalize_sense(sense_buffer, sense_len, &sshdr)) {
> +		int i;
> +
> +		for (i = 0; i < sense_len; i += 16) {
> +			char *logbuf;
> +			int len = min(sense_len - i, 16);
> +			size_t off, logbuf_len;
> +
> +			logbuf = scsi_log_reserve_buffer(&logbuf_len);
> +			if (!logbuf)
> +				break;
> +			off = sdev_format_header(logbuf, logbuf_len,
> +						 name, tag);
> +			hex_dump_to_buffer(&sense_buffer[i], len, 16, 1,
> +					   logbuf + off, logbuf_len - off,
> +					   false);
> +			dev_printk(KERN_INFO, &sdev->sdev_gendev, logbuf);
> +			scsi_log_release_buffer(logbuf);
> +		}
> +		return;

Keeping the code inside the if in a separate helper would probably be a
lot more readable.

