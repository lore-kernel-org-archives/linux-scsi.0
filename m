From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/12]  qla2xxx: Collapse ISP2xxx queuecommand implementations.
Date: Fri, 14 Oct 2005 11:24:36 +0100
Message-ID: <20051014102434.GA23600@infradead.org>
References: <20051013231534.27191.19815.sendpatchset@plap.qlogic.com> <20051013231604.27191.9981.sendpatchset@plap.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:43447 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1750709AbVJNKZI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Oct 2005 06:25:08 -0400
Content-Disposition: inline
In-Reply-To: <20051013231604.27191.9981.sendpatchset@plap.qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, Oct 13, 2005 at 04:16:04PM -0700, Andrew Vasquez wrote:
> Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

I don't like this at all.  Even the first variant with the indirect
function call seems better than this.

> +#define QLA_QUEUE_COMMAND(isp)  \
> +static int \
> +isp##_queuecommand(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *)) \
> +{ \
> +	scsi_qla_host_t *ha = to_qla_host(cmd->device->host); \
> +	fc_port_t *fcport = (struct fc_port *) cmd->device->hostdata; \
> +	srb_t *sp; \
> +	int rval; \
> +	if (!fcport) { \
> +		cmd->result = DID_NO_CONNECT << 16; \
> +		goto fail_command; \
> +	} \

While we're at it, I don't think cmd->device->hostdata could ever be
NULL.

