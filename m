From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 23/23] scsi_trace: add tracepoint for completion
Date: Tue, 30 Sep 2014 08:21:23 -0700
Message-ID: <20140930152123.GD28330@infradead.org>
References: <1412077852-40893-1-git-send-email-hare@suse.de>
 <1412077852-40893-24-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:33753 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbaI3PVY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Sep 2014 11:21:24 -0400
Content-Disposition: inline
In-Reply-To: <1412077852-40893-24-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliott <elliott@hp.com>

On Tue, Sep 30, 2014 at 01:50:52PM +0200, Hannes Reinecke wrote:
> A tracepoint should be inserted upon completion to make tracing
> equivalent to logging.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/scsi_lib.c     |  1 +
>  drivers/scsi/scsi_trace.c   | 16 ++++++++++++++++
>  include/trace/events/scsi.h | 31 +++++++++++++++++++++++++++++++
>  3 files changed, 48 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 2df485f..5c67e4e 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1626,6 +1626,7 @@ static void scsi_softirq_done(struct request *rq)
>  	}
>  
>  	scsi_log_completion(cmd, disposition);
> +	trace_scsi_cmd_completion(cmd, disposition);
>  
>  	switch (disposition) {
>  		case SUCCESS:
> diff --git a/drivers/scsi/scsi_trace.c b/drivers/scsi/scsi_trace.c
> index 503594e..51a7737 100644
> --- a/drivers/scsi/scsi_trace.c
> +++ b/drivers/scsi/scsi_trace.c
> @@ -286,3 +286,19 @@ scsi_trace_parse_cdb(struct trace_seq *p, unsigned char *cdb, int len)
>  		return scsi_trace_misc(p, cdb, len);
>  	}
>  }
> +
> +const char *
> +scsi_trace_mlreturn_name(struct trace_seq *p, int rtn)
> +{
> +	const char *ret = trace_seq_buffer_ptr(p);
> +	const char *mlstr = scsi_mlreturn_string(rtn);
> +
> +	if (mlstr)
> +		trace_seq_printf(p, "%s", mlstr);
> +	else
> +		trace_seq_printf(p, "UNKNOWN (0x%x)", rtn);
> +
> +	trace_seq_putc(p, 0);
> +
> +	return ret;
> +}

Nak, again this doesn't do the right thing for binary tracing.  Please
use __print_symbolic instead.

