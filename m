From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v7 2/3] ahci_xgene: Skip the PHY and clock initialization
 if already configured by the firmware.
Date: Tue, 19 Aug 2014 11:14:17 -0400
Message-ID: <20140819151417.GA16480@htj.dyndns.org>
References: <1408429911-1406-1-git-send-email-stripathi@apm.com>
 <1408429911-1406-3-git-send-email-stripathi@apm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qc0-f172.google.com ([209.85.216.172]:57471 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648AbaHSPOV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Aug 2014 11:14:21 -0400
Content-Disposition: inline
In-Reply-To: <1408429911-1406-3-git-send-email-stripathi@apm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Suman Tripathi <stripathi@apm.com>
Cc: olof@lixom.net, arnd@arndb.de, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, ddutile@redhat.com, jcm@redhat.com, patches@apm.com, Loc Ho <lho@apm.com>

On Tue, Aug 19, 2014 at 12:01:50PM +0530, Suman Tripathi wrote:
> This patch implements the feature to skip the PHY and clock
> initialization if it is already configured by the firmware.
> 
> Signed-off-by: Loc Ho <lho@apm.com>
> Signed-off-by: Suman Tripathi <stripathi@apm.com>
...
> +static int xgene_ahci_is_memram_inited(struct xgene_ahci_context *ctx)
> +{
> +	void __iomem *diagcsr = ctx->csr_diag;
> +
> +	if (readl(diagcsr + CFG_MEM_RAM_SHUTDOWN) == 0 &&
> +	    readl(diagcsr + BLOCK_MEM_RDY) == 0xFFFFFFFF)
> +		return 1;
> +	return 0;
> +}

Please make it return bool.

Thanks.

-- 
tejun
