From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH RFC 36/77] ipr: Enable MSI-X when IPR_USE_MSIX type is
 set, not IPR_USE_MSI
Date: Wed, 02 Oct 2013 14:31:25 -0500
Message-ID: <524C748D.8080803@linux.vnet.ibm.com>
References: <cover.1380703262.git.agordeev@redhat.com> <2d4272136269f3cb3b1a5ac53b12aa45c7ea65c0.1380703263.git.agordeev@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:50779 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753580Ab3JBTbu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Oct 2013 15:31:50 -0400
Received: from /spool/local
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Wed, 2 Oct 2013 13:31:49 -0600
In-Reply-To: <2d4272136269f3cb3b1a5ac53b12aa45c7ea65c0.1380703263.git.agordeev@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org, "VMware, Inc." <pv-drivers@vmware.com>, linux-nvme@lists.infradead.org, linux-ide@vger.kernel.org, stable@vger.kernel.org, linux-s390@vger.kernel.org, Andy King <acking@vmware.com>, linux-scsi@vger.kernel.org, linux-rdma@vger.kernel.org, x86@kernel.org, linux-pci@vger.kernel.org, iss_storagedev@hp.com, linux-driver@qlogic.com, Tejun Heo <tj@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, Dan Williams <dan.j.williams@intel.com>, Jon Mason <jon.mason@intel.com>, Ingo Molnar <mingo@redhat.com>, Solarflare linux maintainers <linux-net-drivers@solarflare.com>, netdev@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>, e1000-devel@lists.sourceforge.net, Martin Schwidefsky <schwidefsky@de.ibm.com>, linux390@de.ibm.com, linuxppc-dev@lists.ozlabs.org, Wendy Xiong <wenxiong@linux.vnet.ibm.com>

On 10/02/2013 05:48 AM, Alexander Gordeev wrote:
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> ---
>  drivers/scsi/ipr.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
> index fb57e21..762a93e 100644
> --- a/drivers/scsi/ipr.c
> +++ b/drivers/scsi/ipr.c
> @@ -9527,7 +9527,7 @@ static int ipr_probe_ioa(struct pci_dev *pdev,
>  		ipr_number_of_msix = IPR_MAX_MSIX_VECTORS;
>  	}
> 
> -	if (ioa_cfg->ipr_chip->intr_type == IPR_USE_MSI &&
> +	if (ioa_cfg->ipr_chip->intr_type == IPR_USE_MSIX &&
>  			ipr_enable_msix(ioa_cfg) == 0)
>  		ioa_cfg->intr_flag = IPR_USE_MSIX;
>  	else if (ioa_cfg->ipr_chip->intr_type == IPR_USE_MSI &&
> 

Nack. ioa_cfg->ipr_chip->intr_type gets initialized from the ipr_chip table
at the top of the driver which never sets intr_type to IPR_USE_MSIX, so this
will break MSI-X support for ipr. 

We indicate at the chip level only whether we want to force LSI or whether
we want to enable MSI / MSI-X and then try enabling MSI-X and fall back to
MSI if MSI-X is not available or does not work. We then set intr_flag to indicate
what we are actually using on the specific adapter.

Thanks,

Brian

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center


