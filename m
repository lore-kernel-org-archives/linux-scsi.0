From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 3/3] qla4xxx: iospace_config move defn
Date: Wed, 09 Aug 2006 13:56:14 -0400
Message-ID: <44DA21BE.3050506@cs.wisc.edu>
References: <20060809182406.2021.90492.stgit@bebe.enoyolf.org> <20060809184243.2021.48891.stgit@bebe.enoyolf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:24776 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S1751145AbWHIS4Z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Aug 2006 14:56:25 -0400
In-Reply-To: <20060809184243.2021.48891.stgit@bebe.enoyolf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Doug Maxey <dwm@enoyolf.org>
Cc: Ravi Anand <ravi.anand@qlogic.com>, David Somayajulu <david.somayajulu@qlogic.com>, open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org

Doug Maxey wrote:
> From: Doug Maxey <dwm@enoyolf.org>
> 
> Move the defn before the caller, and remove the decl.
> 

I think not doing the defn before the caller is nice, but I honestly
could care less either way as far as merging things goes (it seems like
Christoph hates then but people like Jeff let the driver writer do what
they want). Qlogic seems to love doing it, so are they ok with all these
patches?


And one comment...

> Signed-off-by: Doug Maxey <dwm@enoyolf.org>
> ---
> 
> drivers/scsi/qla4xxx/ql4_os.c |  126
> ++++++++++++++++++++---------------------
> 1 files changed, 62 insertions(+), 64 deletions(-)
> 
> diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
> index f656fb3..30f245a 100644
> --- a/drivers/scsi/qla4xxx/ql4_os.c
> +++ b/drivers/scsi/qla4xxx/ql4_os.c
> @@ -46,8 +46,6 @@ MODULE_PARM_DESC(extended_error_logging,
> 
> void qla4xxx_config_dma_addressing(struct scsi_qla_host *ha);
> 
> -static int qla4xxx_iospace_config(struct scsi_qla_host *ha);
> -
> /*
>  * iSCSI template entry points
>  */
> @@ -1138,6 +1136,68 @@ static void qla4xxx_free_adapter(struct
> }
> 
> +/***
> + * qla4xxx_iospace_config - maps registers
> + * @ha: pointer to adapter structure
> + *
> + * This routines maps HBA's registers from the pci address space
> + * into the kernel virtual address space for memory mapped i/o.
> + **/
> +static int qla4xxx_iospace_config(struct scsi_qla_host *ha)
> +{
> +    unsigned long pio, pio_len, pio_flags;
> +    unsigned long mmio, mmio_len, mmio_flags;
> +
> +    pio = pci_resource_start(ha->pdev, 0);
> +    pio_len = pci_resource_len(ha->pdev, 0);
> +    pio_flags = pci_resource_flags(ha->pdev, 0);
> +    if (pio_flags & IORESOURCE_IO) {
> +        if (pio_len < MIN_IOBASE_LEN) {
> +            dev_warn(&ha->pdev->dev,
> +                   "Invalid PCI I/O region size\n");
> +            pio = 0;
> +        }
> +    } else {
> +        dev_warn(&ha->pdev->dev, "region #0 not a PIO resource\n");
> +        pio = 0;
> +    }
> +

Is my mailer messing up the tabs or are you (maybe the original code was
messed up and did not get fixed in the move)?
