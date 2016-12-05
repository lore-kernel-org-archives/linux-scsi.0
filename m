From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 3/6] qla2xxx: Utilize
 pci_alloc_irq_vectors/pci_free_irq_vectors calls.
Date: Mon, 5 Dec 2016 04:55:30 -0800
Message-ID: <20161205125530.GB23221@infradead.org>
References: <1480715097-13611-1-git-send-email-himanshu.madhani@cavium.com>
 <1480715097-13611-4-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59047 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751039AbcLEMzc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Dec 2016 07:55:32 -0500
Content-Disposition: inline
In-Reply-To: <1480715097-13611-4-git-send-email-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org

On Fri, Dec 02, 2016 at 01:44:54PM -0800, Himanshu Madhani wrote:
> From: Michael Hernandez <michael.hernandez@cavium.com>
> 
> Replaces the old pci_enable_msi[x]* and pci_disable_msi[x] calls.
> 
> Signed-off-by: Michael Hernandez <michael.hernandez@cavium.com>
> Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
> ---
>  drivers/scsi/qla2xxx/qla_def.h |  1 +
>  drivers/scsi/qla2xxx/qla_isr.c | 81 +++++++++++++++---------------------------
>  2 files changed, 30 insertions(+), 52 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
> index 9a6ddcb..53021b5 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -2748,6 +2748,7 @@ struct qla_msix_entry {
>  	uint32_t vector;
>  	uint16_t entry;
>  	struct rsp_que *rsp;
> +	void *handle;

Just curious: why do you need this new handle field instead of just
passing the rsp as the old code did?
