From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/8] qla2xxx: Add support for host port state FC transport attribute.
Date: Tue, 10 Oct 2006 10:33:13 +0100
Message-ID: <20061010093313.GF395@infradead.org>
References: <20061002185947.GF16536@andrew-vasquezs-computer.local> <11598156512789-git-send-email-andrew.vasquez@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:55518 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S965138AbWJJJdO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Oct 2006 05:33:14 -0400
Content-Disposition: inline
In-Reply-To: <11598156512789-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>

On Mon, Oct 02, 2006 at 12:00:47PM -0700, Andrew Vasquez wrote:
> Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

Ok.

> ---
>  drivers/scsi/qla2xxx/qla_attr.c |   15 +++++++++++++++
>  1 files changed, 15 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
> index d4cf51a..ee75a71 100644
> --- a/drivers/scsi/qla2xxx/qla_attr.c
> +++ b/drivers/scsi/qla2xxx/qla_attr.c
> @@ -879,6 +879,19 @@ qla2x00_get_host_fabric_name(struct Scsi
>  	fc_host_fabric_name(shost) = node_name;
>  }
>  
> +static void
> +qla2x00_get_host_port_state(struct Scsi_Host *shost)
> +{
> +	scsi_qla_host_t *ha = to_qla_host(shost);
> +
> +	if (!ha->flags.online)
> +		fc_host_port_state(shost) = FC_PORTSTATE_OFFLINE;
> +	else if (atomic_read(&ha->loop_state) == LOOP_TIMEOUT)
> +		fc_host_port_state(shost) = FC_PORTSTATE_UNKNOWN;
> +	else
> +		fc_host_port_state(shost) = FC_PORTSTATE_ONLINE;
> +}
> +
>  struct fc_function_template qla2xxx_transport_functions = {
>  
>  	.show_host_node_name = 1,
> @@ -897,6 +910,8 @@ struct fc_function_template qla2xxx_tran
>  	.show_host_system_hostname = 1,
>  	.get_host_fabric_name = qla2x00_get_host_fabric_name,
>  	.show_host_fabric_name = 1,
> +	.get_host_port_state = qla2x00_get_host_port_state,
> +	.show_host_port_state = 1,
>  
>  	.dd_fcrport_size = sizeof(struct fc_port *),
>  	.show_rport_supported_classes = 1,
> -- 
> 1.4.2.3.gf59615
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
---end quoted text---
