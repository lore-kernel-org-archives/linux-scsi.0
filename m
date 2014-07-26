From: Alexander Gordeev <agordeev@redhat.com>
Subject: Re: [PATCH v2 RESEND 21/23] qla2xxx: Use pci_enable_msix_range()
 instead of pci_enable_msix()
Date: Sat, 26 Jul 2014 09:40:50 +0100
Message-ID: <20140726084049.GK21129@agordeev.usersys.redhat.com>
References: <cover.1405533479.git.agordeev@redhat.com>
 <cf38d1596543fd61c099bc0b834c2ea7a11f8b28.1405533479.git.agordeev@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cf38d1596543fd61c099bc0b834c2ea7a11f8b28.1405533479.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: qla2xxx-upstream@qlogic.com, linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Jul 16, 2014 at 08:05:25PM +0200, Alexander Gordeev wrote:
> As result of deprecation of MSI-X/MSI enablement functions
> pci_enable_msix() and pci_enable_msi_block() all drivers
> using these two interfaces need to be updated to use the
> new pci_enable_msi_range()  or pci_enable_msi_exact()
> and pci_enable_msix_range() or pci_enable_msix_exact()
> interfaces.
> 
> Log message code 0x00c6 preserved, although it is reported
> after successful call to pci_enable_msix_range(), not before
> possibly unsuccessful call to pci_enable_msix(). Consumers
> of the error code should not notice the difference.

Hello,

Could someone review this patch, please?

Thanks!

> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> Cc: qla2xxx-upstream@qlogic.com
> Cc: linux-scsi@vger.kernel.org
> Cc: linux-pci@vger.kernel.org
> ---
>  drivers/scsi/qla2xxx/qla_isr.c |   27 +++++++++++----------------
>  1 files changed, 11 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
> index a56825c..52d420f 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -2923,27 +2923,22 @@ qla24xx_enable_msix(struct qla_hw_data *ha, struct rsp_que *rsp)
>  	for (i = 0; i < ha->msix_count; i++)
>  		entries[i].entry = i;
>  
> -	ret = pci_enable_msix(ha->pdev, entries, ha->msix_count);
> -	if (ret) {
> -		if (ret < MIN_MSIX_COUNT)
> -			goto msix_failed;
> -
> +	ret = pci_enable_msix_range(ha->pdev,
> +				    entries, MIN_MSIX_COUNT, ha->msix_count);
> +	if (ret < 0) {
> +		ql_log(ql_log_fatal, vha, 0x00c7,
> +		    "MSI-X: Failed to enable support, "
> +		    "giving   up -- %d/%d.\n",
> +		    ha->msix_count, ret);
> +		goto msix_out;
> +	} else if (ret < ha->msix_count) {
>  		ql_log(ql_log_warn, vha, 0x00c6,
>  		    "MSI-X: Failed to enable support "
>  		    "-- %d/%d\n Retry with %d vectors.\n",
>  		    ha->msix_count, ret, ret);
> -		ha->msix_count = ret;
> -		ret = pci_enable_msix(ha->pdev, entries, ha->msix_count);
> -		if (ret) {
> -msix_failed:
> -			ql_log(ql_log_fatal, vha, 0x00c7,
> -			    "MSI-X: Failed to enable support, "
> -			    "giving   up -- %d/%d.\n",
> -			    ha->msix_count, ret);
> -			goto msix_out;
> -		}
> -		ha->max_rsp_queues = ha->msix_count - 1;
>  	}
> +	ha->msix_count = ret;
> +	ha->max_rsp_queues = ha->msix_count - 1;
>  	ha->msix_entries = kzalloc(sizeof(struct qla_msix_entry) *
>  				ha->msix_count, GFP_KERNEL);
>  	if (!ha->msix_entries) {
> -- 
> 1.7.7.6
> 

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
