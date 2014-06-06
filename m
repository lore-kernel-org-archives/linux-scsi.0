From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v0 1/2] libahci: Implement the function restart_engine to
 restart the port dma engine.
Date: Fri, 6 Jun 2014 18:29:10 -0400
Message-ID: <20140606222910.GA1055@mtj.dyndns.org>
References: <1402090134-23164-1-git-send-email-stripathi@apm.com>
 <1402090134-23164-2-git-send-email-stripathi@apm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:37220 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207AbaFFW3O (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jun 2014 18:29:14 -0400
Content-Disposition: inline
In-Reply-To: <1402090134-23164-2-git-send-email-stripathi@apm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Suman Tripathi <stripathi@apm.com>
Cc: olof@lixom.net, arnd@arndb.de, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, ddutile@redhat.com, jcm@redhat.com, patches@apm.com, Loc Ho <lho@apm.com>

On Sat, Jun 07, 2014 at 02:58:53AM +0530, Suman Tripathi wrote:
> This patch implements the function restart_engine function to add the flexibility to  restart the port dma engine from the libata framework.
> 
> Signed-off-by: Loc Ho <lho@apm.com>
> Signed-off-by: Suman Tripathi <stripathi@apm.com>
> ---
>  drivers/ata/libahci.c  | 11 +++++++++++
>  include/linux/libata.h |  1 +
>  2 files changed, 12 insertions(+)
> 
> diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
> index b986145..5f9a13e 100644
> --- a/drivers/ata/libahci.c
> +++ b/drivers/ata/libahci.c
> @@ -70,6 +70,7 @@ static int ahci_scr_read(struct ata_link *link, unsigned int sc_reg, u32 *val);
>  static int ahci_scr_write(struct ata_link *link, unsigned int sc_reg, u32 val);
>  static unsigned int ahci_qc_issue(struct ata_queued_cmd *qc);
>  static bool ahci_qc_fill_rtf(struct ata_queued_cmd *qc);
> +static int ahci_restart_engine(struct ata_port *ap);
>  static int ahci_port_start(struct ata_port *ap);
>  static void ahci_port_stop(struct ata_port *ap);
>  static void ahci_qc_prep(struct ata_queued_cmd *qc);
> @@ -178,6 +179,7 @@ struct ata_port_operations ahci_ops = {
>  #endif
>  	.port_start		= ahci_port_start,
>  	.port_stop		= ahci_port_stop,
> +	.restart_engine		= ahci_restart_engine,

Umm... you're adding something very ahci-specific as general libata
callback.  I haven't looked at the second patch yet but don't think
this is gonna work out.

Thanks.

-- 
tejun
