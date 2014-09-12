From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] ahci_xgene: Fix the error print invalid resource for APM
 X-Gene SoC AHCI SATA Host Controller driver.
Date: Sat, 13 Sep 2014 02:50:14 +0900
Message-ID: <20140912175014.GA6298@mtj.dyndns.org>
References: <1410508448-25111-1-git-send-email-stripathi@apm.com>
 <1410508448-25111-2-git-send-email-stripathi@apm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:40919 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043AbaILRuV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Sep 2014 13:50:21 -0400
Content-Disposition: inline
In-Reply-To: <1410508448-25111-2-git-send-email-stripathi@apm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Suman Tripathi <stripathi@apm.com>
Cc: olof@lixom.net, arnd@arndb.de, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, ddutile@redhat.com, jcm@redhat.com, patches@apm.com, Loc Ho <lho@apm.com>

On Fri, Sep 12, 2014 at 01:24:08PM +0530, Suman Tripathi wrote:
> This patch fixes the error print invalid resource for the APM X-Gene
> SoC AHCI SATA Host Controller driver. This print was due to the fact
> that the controller 3 don't have a mux resource. This didn't result
> in any errors but the print seems like meaningless.
> 
> Signed-off-by: Loc Ho <lho@apm.com>
> Signed-off-by: Suman Tripathi <stripathi@apm.com>
> ---
>  drivers/ata/ahci_xgene.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/ata/ahci_xgene.c b/drivers/ata/ahci_xgene.c
> index 40d0a76..9404db0c 100644
> --- a/drivers/ata/ahci_xgene.c
> +++ b/drivers/ata/ahci_xgene.c
> @@ -434,7 +434,7 @@ static int xgene_ahci_mux_select(struct xgene_ahci_context *ctx)
>  	u32 val;
> 
>  	/* Check for optional MUX resource */
> -	if (IS_ERR(ctx->csr_mux))
> +	if (!ctx->csr_mux)
>  		return 0;

Hmmm?  So, if devm_ioremap_resource() call actually fails, now the
function tries to operation on ERR_PTR() value as a real pointer?

Thanks.

-- 
tejun
