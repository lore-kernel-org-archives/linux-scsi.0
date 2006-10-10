From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/8] qla2xxx: Add support for system hostname FC transport attribute.
Date: Tue, 10 Oct 2006 10:32:32 +0100
Message-ID: <20061010093232.GD395@infradead.org>
References: <20061002185947.GF16536@andrew-vasquezs-computer.local> <11598156511495-git-send-email-andrew.vasquez@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:59572 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S965133AbWJJJcd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Oct 2006 05:32:33 -0400
Content-Disposition: inline
In-Reply-To: <11598156511495-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>

On Mon, Oct 02, 2006 at 12:00:45PM -0700, Andrew Vasquez wrote:
> The system hostname will be used during a subsequent FDMI registration
> with the fabric.
> 
> Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
> ---
>  drivers/scsi/qla2xxx/qla_attr.c |   10 ++++++++++
>  drivers/scsi/qla2xxx/qla_gs.c   |   15 +++++++++++++++
>  2 files changed, 25 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
> index 4638469..4e1e175 100644
> --- a/drivers/scsi/qla2xxx/qla_attr.c
> +++ b/drivers/scsi/qla2xxx/qla_attr.c
> @@ -857,6 +857,14 @@ qla2x00_get_host_symbolic_name(struct Sc
>  	qla2x00_get_sym_node_name(ha, fc_host_symbolic_name(shost));
>  }
>  
> +static void
> +qla2x00_set_host_system_hostname(struct Scsi_Host *shost)
> +{
> +	scsi_qla_host_t *ha = to_qla_host(shost);
> +
> +	set_bit(REGISTER_FDMI_NEEDED, &ha->dpc_flags);
> +}

I think you should allow to set and clear that flag by echoing 1 respectively 0 to the
file.  Also it might make sense to have this attribute completely implemented at the
transport-level.

