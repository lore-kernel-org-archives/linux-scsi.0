From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 01/10] scsi: Use real functions for logging
Date: Tue, 4 Nov 2014 05:58:45 -0800
Message-ID: <20141104135845.GA3531@infradead.org>
References: <1415088409-46590-1-git-send-email-hare@suse.de>
 <1415088409-46590-2-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:34751 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479AbaKDN6y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Nov 2014 08:58:54 -0500
Content-Disposition: inline
In-Reply-To: <1415088409-46590-2-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, Ewan Milne <emilne@redhat.com>, Robert Elliott <elliott@hp.com>, linux-scsi@vger.kernel.org

On Tue, Nov 04, 2014 at 09:06:40AM +0100, Hannes Reinecke wrote:
> Implement a per-cpu buffer for formatting messages,
> and add real functions for scmd_printk and sdev_prefix_printk
> using that buffer and use dev_printk() to print out things.
> And make sdev_printk() a wrapper for sdev_prefix_printk().

The "real functions" mostly seem to be a side effect of the
implementation, how about a more descriptive subject line?

Also adding a sentence or two why this is done to the patch description
would be very helpful.

> +/*
> + * scsi_logging.c

Please don't mention the file name in top of file comments, it's bound
to get out of date.

> +#define SCSI_LOG_SPOOLSIZE 4096
> +#define SCSI_LOG_BUFSIZE 128
> +
> +struct scsi_log_buf {
> +	char buffer[SCSI_LOG_SPOOLSIZE];
> +	unsigned long map;
> +};
> +
> +static DEFINE_PER_CPU(struct scsi_log_buf, scsi_format_log);

Some sort of comment explaining why we need the per-cpu buffers also
would be very useful.  To me this seems like a little bit too much
duplication of the tracing code.

