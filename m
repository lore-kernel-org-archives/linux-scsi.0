From: "Ewan D. Milne" <emilne@redhat.com>
Subject: Re: [PATCH 2/3] scsi-trace: Decode MAINTENANCE_IN and
 MAINTENANCE_OUT commands
Date: Thu, 24 Mar 2016 09:03:29 -0400
Message-ID: <1458824609.17965.70.camel@localhost.localdomain>
References: <1458815011-9054-1-git-send-email-hare@suse.de>
	 <1458815011-9054-3-git-send-email-hare@suse.de>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58332 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757543AbcCXNDb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Mar 2016 09:03:31 -0400
In-Reply-To: <1458815011-9054-3-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On Thu, 2016-03-24 at 11:23 +0100, Hannes Reinecke wrote:
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/scsi_trace.c | 96 +++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 96 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_trace.c b/drivers/scsi/scsi_trace.c
> index 08bb47b..b50cfe8 100644
> --- a/drivers/scsi/scsi_trace.c
> +++ b/drivers/scsi/scsi_trace.c
> @@ -231,6 +231,98 @@ out:
>  }
>  
>  static const char *
> +scsi_trace_maintenance_in(struct trace_seq *p, unsigned char *cdb, int len)
> +{
> +	const char *ret = trace_seq_buffer_ptr(p), *cmd;
> +	u32 alloc_len = 0;
> +
> +	switch (SERVICE_ACTION16(cdb)) {
> +	case MI_REPORT_IDENTIFYING_INFORMATION:
> +		cmd = "REPORT_IDENTIFYING_INFORMATION";
> +		break;
> +	case MI_REPORT_TARGET_PGS:
> +		cmd = "REPORT_TARGET_PORT_GROUPS";
> +		break;
> +	case MI_REPORT_ALIASES:
> +		cmd = "REPORT_ALIASES";
> +		break;
> +	case MI_REPORT_SUPPORTED_OPERATION_CODES:
> +		cmd = "REPORT_SUPPORTED_OPERATION_CODES";
> +		break;
> +	case MI_REPORT_SUPPORTED_TASK_MANAGEMENT_FUNCTIONS:
> +		cmd = "REPORT_SUPPORTED_TASK_MANAGEMENT_FUNCTIONS";
> +		break;
> +	case MI_REPORT_PRIORITY:
> +		cmd = "REPORT_PRIORITY";
> +		break;
> +	case MI_REPORT_TIMESTAMP:
> +		cmd = "REPORT_TIMESTAMP";
> +		break;
> +	case MI_MANAGEMENT_PROTOCOL_IN:
> +		cmd = "MANAGEMENT_PROTOCOL_IN";
> +		break;
> +	default:
> +		trace_seq_puts(p, "UNKNOWN");
> +		goto out;
> +	}
> +
> +	alloc_len |= (cdb[6] << 24);
> +	alloc_len |= (cdb[7] << 16);
> +	alloc_len |= (cdb[8] << 8);
> +	alloc_len |=  cdb[9];

You could use get_unaligned_be32() here instead, as well as in
scsi_trace_maintenance_out() and similar get_unaligned_XX calls
in the other functions in scsi_trace.c

> +
> +	trace_seq_printf(p, "%s alloc_len=%u", cmd, alloc_len);
> +
> +out:
> +	trace_seq_putc(p, 0);
> +
> +	return ret;
> +}
> +
> +static const char *
> +scsi_trace_maintenance_out(struct trace_seq *p, unsigned char *cdb, int len)
> +{
> +	const char *ret = trace_seq_buffer_ptr(p), *cmd;
> +	u32 alloc_len = 0;
> +
> +	switch (SERVICE_ACTION16(cdb)) {
> +	case MO_SET_IDENTIFYING_INFORMATION:
> +		cmd = "SET_IDENTIFYING_INFORMATION";
> +		break;
> +	case MO_SET_TARGET_PGS:
> +		cmd = "SET_TARGET_PORT_GROUPS";
> +		break;
> +	case MO_CHANGE_ALIASES:
> +		cmd = "CHANGE_ALIASES";
> +		break;
> +	case MO_SET_PRIORITY:
> +		cmd = "SET_PRIORITY";
> +		break;
> +	case MO_SET_TIMESTAMP:
> +		cmd = "SET_TIMESTAMP";
> +		break;
> +	case MO_MANAGEMENT_PROTOCOL_OUT:
> +		cmd = "MANAGEMENT_PROTOCOL_OUT";
> +		break;
> +	default:
> +		trace_seq_puts(p, "UNKNOWN");
> +		goto out;
> +	}
> +
> +	alloc_len |= (cdb[6] << 24);
> +	alloc_len |= (cdb[7] << 16);
> +	alloc_len |= (cdb[8] << 8);
> +	alloc_len |=  cdb[9];
> +
> +	trace_seq_printf(p, "%s alloc_len=%u", cmd, alloc_len);
> +
> +out:
> +	trace_seq_putc(p, 0);
> +
> +	return ret;
> +}
> +
> +static const char *
>  scsi_trace_varlen(struct trace_seq *p, unsigned char *cdb, int len)
>  {
>  	switch (SERVICE_ACTION32(cdb)) {
> @@ -282,6 +374,10 @@ scsi_trace_parse_cdb(struct trace_seq *p, unsigned char *cdb, int len)
>  		return scsi_trace_service_action_in(p, cdb, len);
>  	case VARIABLE_LENGTH_CMD:
>  		return scsi_trace_varlen(p, cdb, len);
> +	case MAINTENANCE_IN:
> +		return scsi_trace_maintenance_in(p, cdb, len);
> +	case MAINTENANCE_OUT:
> +		return scsi_trace_maintenance_out(p, cdb, len);
>  	default:
>  		return scsi_trace_misc(p, cdb, len);
>  	}

Reviewed-by: Ewan D. Milne <emilne@redhat.com>


