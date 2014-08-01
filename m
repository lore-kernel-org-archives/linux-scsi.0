From: Alexander Gordeev <agordeev@redhat.com>
Subject: Re: [PATCH v1.3 2/18] arcmsr: Add code to support MSI-X, MSI
 interrupt
Date: Fri, 1 Aug 2014 10:46:17 +0200
Message-ID: <20140801084616.GA26695@dhcp-26-207.brq.redhat.com>
References: <1406881989.10378.39.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1406881989.10378.39.camel@Centos6.3-64>
Sender: linux-kernel-owner@vger.kernel.org
To: Ching Huang <ching2048@areca.com.tw>
Cc: hch@infradead.org, jbottomley@parallels.com, dan.carpenter@oracle.com, thenzl@redhat.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Aug 01, 2014 at 04:33:09PM +0800, Ching Huang wrote:
> 
> This patch adds code to support MSI, MSI-X interrupt.
> 
> Signed-off-by: Ching<ching2048@areca.com.tw>
> ---
> 
> diff -uprN a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcmsr.h
> --- a/drivers/scsi/arcmsr/arcmsr.h	2014-04-28 16:02:46.000000000 +0800
> +++ b/drivers/scsi/arcmsr/arcmsr.h	2014-05-06 15:24:36.000000000 +0800
> @@ -64,6 +64,7 @@ struct device_attribute;
>  #define ARCMSR_MAX_HBB_POSTQUEUE						264
>  #define ARCMSR_MAX_XFER_LEN							0x26000 /* 152K */
>  #define ARCMSR_CDB_SG_PAGE_LENGTH						256 
> +#define ARCMST_NUM_MSIX_VECTORS		4
>  #ifndef PCI_DEVICE_ID_ARECA_1880
>  #define PCI_DEVICE_ID_ARECA_1880 0x1880
>   #endif
> @@ -508,6 +509,7 @@ struct AdapterControlBlock
>  	struct pci_dev *		pdev;
>  	struct Scsi_Host *		host;
>  	unsigned long			vir2phy_offset;
> +	struct msix_entry	entries[ARCMST_NUM_MSIX_VECTORS];
>  	/* Offset is used in making arc cdb physical to virtual calculations */
>  	uint32_t			outbound_int_enable;
>  	uint32_t			cdb_phyaddr_hi32;
> @@ -544,6 +546,8 @@ struct AdapterControlBlock
>  	/* iop init */
>  	#define ACB_F_ABORT				0x0200
>  	#define ACB_F_FIRMWARE_TRAP           		0x0400
> +	#define ACB_F_MSI_ENABLED		0x1000
> +	#define ACB_F_MSIX_ENABLED		0x2000
>  	struct CommandControlBlock *			pccb_pool[ARCMSR_MAX_FREECCB_NUM];
>  	/* used for memory free */
>  	struct list_head		ccb_free_list;
> @@ -594,6 +598,7 @@ struct AdapterControlBlock
>  				#define	FW_DEADLOCK	0x0010
>  	atomic_t 			rq_map_token;
>  	atomic_t			ante_token_value;
> +	int		msix_vector_count;
>  };/* HW_DEVICE_EXTENSION */
>  /*
>  *******************************************************************************
> diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
> --- a/drivers/scsi/arcmsr/arcmsr_hba.c	2014-08-01 11:02:44.000000000 +0800
> +++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2014-08-01 11:03:00.000000000 +0800
> @@ -603,6 +603,60 @@ static void arcmsr_message_isr_bh_fn(str
>  	}
>  }
>  
> +static int
> +arcmsr_request_irq(struct pci_dev *pdev, struct AdapterControlBlock *acb)
> +{
> +	int	i, j, r;
> +	struct msix_entry entries[ARCMST_NUM_MSIX_VECTORS];
> +
> +	if (!pci_find_capability(pdev, PCI_CAP_ID_MSIX))
> +		goto msi_int;

It is not on top of my head, but checking the capability is discouraged.
pci_enable_msix_range() will fail if MSI-X is not supported. Hence, it
is redundant.

> +	for (i = 0; i < ARCMST_NUM_MSIX_VECTORS; i++)
> +		entries[i].entry = i;
> +	r = pci_enable_msix_range(pdev, entries, 1, ARCMST_NUM_MSIX_VECTORS);
> +	if (r < 0)
> +		goto msi_int;
> +	acb->msix_vector_count = r;

Not sure how msix_vector_count is used throughout the rest of the code,
but placing this assignment after successful initialization of MSI-X
is generally safer and clearer.

> +	for (i = 0; i < r; i++) {
> +		if (request_irq(entries[i].vector,
> +			arcmsr_do_interrupt, 0, "arcmsr", acb)) {
> +			pr_warn("arcmsr%d: request_irq =%d failed!\n",
> +				acb->host->host_no, pdev->irq);

Nah, pdev->irq is wrong here. Should be entries[i].vector.

> +			for (j = 0 ; j < i ; j++)
> +				free_irq(entries[j].vector, acb);
> +			pci_disable_msix(pdev);
> +			goto msi_int;
> +		}
> +		acb->entries[i] = entries[i];
> +	}
> +	acb->acb_flags |= ACB_F_MSIX_ENABLED;
> +	pr_info("arcmsr%d: msi-x enabled\n", acb->host->host_no);
> +	return ARC_SUCCESS;
> +msi_int:
> +	if (!pci_find_capability(pdev, PCI_CAP_ID_MSI))
> +		goto legacy_int;

The same as with MSI-X (above).

> +	if (pci_enable_msi_range(pdev, 1, 1) < 0)
> +		goto legacy_int;

pci_enable_msi_exact() or pci_enable_msi() is better choice here.

> +	if (request_irq(pdev->irq, arcmsr_do_interrupt,
> +		IRQF_SHARED, "arcmsr", acb)) {
> +		pr_warn("arcmsr%d: request_irq =%d failed!\n",
> +			acb->host->host_no, pdev->irq);
> +		pci_disable_msi(pdev);
> +		goto legacy_int;
> +	}
> +	acb->acb_flags |= ACB_F_MSI_ENABLED;
> +	pr_info("arcmsr%d: msi enabled\n", acb->host->host_no);
> +	return ARC_SUCCESS;
> +legacy_int:
> +	if (request_irq(pdev->irq, arcmsr_do_interrupt,
> +		IRQF_SHARED, "arcmsr", acb)) {
> +		pr_warn("arcmsr%d: request_irq = %d failed!\n",
> +			acb->host->host_no, pdev->irq);
> +		return ARC_FAILURE;
> +	}
> +	return ARC_SUCCESS;
> +}
> +
>  static int arcmsr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  {
>  	struct Scsi_Host *host;
> @@ -667,16 +721,13 @@ static int arcmsr_probe(struct pci_dev *
>  	if(error){
>  		goto free_hbb_mu;
>  	}
> -	arcmsr_iop_init(acb);
>  	error = scsi_add_host(host, &pdev->dev);
>  	if(error){
>  		goto RAID_controller_stop;
>  	}
> -	error = request_irq(pdev->irq, arcmsr_do_interrupt, IRQF_SHARED, "arcmsr", acb);
> -	if(error){
> +	if (arcmsr_request_irq(pdev, acb) == ARC_FAILURE)
>  		goto scsi_host_remove;
> -	}
> -	host->irq = pdev->irq;
> +	arcmsr_iop_init(acb);
>      	scsi_scan_host(host);
>  	INIT_WORK(&acb->arcmsr_do_message_isr_bh, arcmsr_message_isr_bh_fn);
>  	atomic_set(&acb->rq_map_token, 16);
> @@ -710,6 +761,21 @@ pci_disable_dev:
>  	return -ENODEV;
>  }
>  
> +static void arcmsr_free_irq(struct pci_dev *pdev, struct AdapterControlBlock *acb)
> +{
> +	int i;
> +
> +	if (acb->acb_flags & ACB_F_MSI_ENABLED) {
> +		free_irq(pdev->irq, acb);
> +		pci_disable_msi(pdev);
> +	} else if (acb->acb_flags & ACB_F_MSIX_ENABLED) {
> +		for (i = 0; i < acb->msix_vector_count; i++)
> +			free_irq(acb->entries[i].vector, acb);
> +		pci_disable_msix(pdev);
> +	} else
> +		free_irq(pdev->irq, acb);
> +}
> +
>  static uint8_t arcmsr_abort_hba_allcmd(struct AdapterControlBlock *acb)
>  {
>  	struct MessageUnit_A __iomem *reg = acb->pmuA;
> @@ -992,6 +1058,7 @@ static void arcmsr_done4abort_postqueue(
>  	}
>  	}
>  }
> +
>  static void arcmsr_remove(struct pci_dev *pdev)
>  {
>  	struct Scsi_Host *host = pci_get_drvdata(pdev);
> @@ -1029,7 +1096,7 @@ static void arcmsr_remove(struct pci_dev
>  			}
>  		}
>  	}
> -	free_irq(pdev->irq, acb);
> +	arcmsr_free_irq(pdev, acb);
>  	arcmsr_free_ccb_pool(acb);
>  	arcmsr_free_hbb_mu(acb);
>  	arcmsr_unmap_pciregion(acb);
> @@ -1045,6 +1112,7 @@ static void arcmsr_shutdown(struct pci_d
>  		(struct AdapterControlBlock *)host->hostdata;
>  	del_timer_sync(&acb->eternal_timer);
>  	arcmsr_disable_outbound_ints(acb);
> +	arcmsr_free_irq(pdev, acb);
>  	flush_work(&acb->arcmsr_do_message_isr_bh);
>  	arcmsr_stop_adapter_bgrb(acb);
>  	arcmsr_flush_adapter_cache(acb);
> @@ -2516,8 +2584,6 @@ static int arcmsr_iop_confirm(struct Ada
>  	case ACB_ADAPTER_TYPE_A: {
>  		if (cdb_phyaddr_hi32 != 0) {
>  			struct MessageUnit_A __iomem *reg = acb->pmuA;
> -			uint32_t intmask_org;
> -			intmask_org = arcmsr_disable_outbound_ints(acb);
>  			writel(ARCMSR_SIGNATURE_SET_CONFIG, \
>  						&reg->message_rwbuffer[0]);
>  			writel(cdb_phyaddr_hi32, &reg->message_rwbuffer[1]);
> @@ -2529,7 +2595,6 @@ static int arcmsr_iop_confirm(struct Ada
>  				acb->host->host_no);
>  				return 1;
>  			}
> -			arcmsr_enable_outbound_ints(acb, intmask_org);
>  		}
>  		}
>  		break;
> @@ -2539,8 +2604,6 @@ static int arcmsr_iop_confirm(struct Ada
>  		uint32_t __iomem *rwbuffer;
>  
>  		struct MessageUnit_B *reg = acb->pmuB;
> -		uint32_t intmask_org;
> -		intmask_org = arcmsr_disable_outbound_ints(acb);
>  		reg->postq_index = 0;
>  		reg->doneq_index = 0;
>  		writel(ARCMSR_MESSAGE_SET_POST_WINDOW, reg->drv2iop_doorbell);
> @@ -2569,7 +2632,6 @@ static int arcmsr_iop_confirm(struct Ada
>  			return 1;
>  		}
>  		arcmsr_hbb_enable_driver_mode(acb);
> -		arcmsr_enable_outbound_ints(acb, intmask_org);
>  		}
>  		break;
>  	case ACB_ADAPTER_TYPE_C: {
> 
> 

One general question. What is justification for replacing standard error
codes with ARC_xxxx ones?

Thanks!

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
