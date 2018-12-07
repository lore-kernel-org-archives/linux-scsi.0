From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH] scsi: qla2xxx: disabling pci error handler early
Date: Fri, 7 Dec 2018 16:00:27 -0600
Message-ID: <d7b867f3-22d1-855d-86ce-43089e46ca6a@linux.vnet.ibm.com>
References: <1544212602-28085-1-git-send-email-glagolig@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1544212602-28085-1-git-send-email-glagolig@gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Anatoliy Glagolev <glagolig@gmail.com>, aglagolev@purestorage.com, qla2xxx-upstream@qlogic.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Benjamin Herrenschmidt <benh@au1.ibm.com>, kmahlkuc@linux.vnet.ibm.com
List-Id: linux-scsi@vger.kernel.org

On 12/07/2018 01:56 PM, Anatoliy Glagolev wrote:
> qla2x00_disable_board_on_pci_error and pcie error handlers may run
> in parallel. Specifically, I observed qla2xxx_pci_slot_reset running
> at around the same moment as qla2x00_disable_board_on_pci_error.
> If scsi_qla_host_t or qla_hw_data structs are removed before an error
> handler completes, the handler crashes.
> 
> This patch disables pcie error handling early in
> qla2x00_disable_board_on_pci_error and in other paths that remove
> those structs.

While this may fix this issue for PCIe AER, I think you'll still have
the exposure for EEH errors on a Power system, since we don't have
the pci_enable_pcie_error_reporting API wired up to do anything,
nor do we have much ability to do anything with it since its an
attribute of the hardware.

Is there a way to fix this that doesn't break Power?

Thanks,

Brian

> 
> Signed-off-by: Anatoliy Glagolev <glagolig@gmail.com>
> ---
>  drivers/scsi/qla2xxx/qla_os.c | 15 +++++++++------
>  1 file changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index e881fce..b8f277a 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -2775,9 +2775,6 @@ static void qla2x00_iocb_work_fn(struct work_struct *work)
>  			return ret;
>  	}
> 
> -	/* This may fail but that's ok */
> -	pci_enable_pcie_error_reporting(pdev);
> -
>  	ha = kzalloc(sizeof(struct qla_hw_data), GFP_KERNEL);
>  	if (!ha) {
>  		ql_log_pci(ql_log_fatal, pdev, 0x0009,
> @@ -3039,6 +3036,9 @@ static void qla2x00_iocb_work_fn(struct work_struct *work)
>  		goto probe_hw_failed;
>  	}
> 
> +	/* This may fail but that's ok */
> +	pci_enable_pcie_error_reporting(pdev);
> +
>  	pci_set_drvdata(pdev, base_vha);
>  	set_bit(PFLG_DRIVER_PROBING, &base_vha->pci_flags);
> 
> @@ -3400,6 +3400,8 @@ static void qla2x00_iocb_work_fn(struct work_struct *work)
>  		kthread_stop(t);
>  	}
> 
> +	pci_disable_pcie_error_reporting();
> +
>  	qla2x00_free_device(base_vha);
>  	scsi_host_put(base_vha->host);
>  	/*
> @@ -3625,6 +3627,8 @@ static void qla2x00_iocb_work_fn(struct work_struct *work)
>  	}
>  	qla2x00_wait_for_hba_ready(base_vha);
> 
> +	pci_disable_pcie_error_reporting(pdev);
> +
>  	qla2x00_wait_for_sess_deletion(base_vha);
> 
>  	/*
> @@ -3698,8 +3702,6 @@ static void qla2x00_iocb_work_fn(struct work_struct *work)
>  	pci_release_selected_regions(ha->pdev, ha->bars);
>  	kfree(ha);
> 
> -	pci_disable_pcie_error_reporting(pdev);
> -
>  	pci_disable_device(pdev);
>  }
> 
> @@ -5826,6 +5828,8 @@ void qla2x00_relogin(struct scsi_qla_host *vha)
>  		return;
>  	}
> 
> +	pci_disable_pcie_error_reporting(pdev);
> +
>  	qla2x00_wait_for_sess_deletion(base_vha);
> 
>  	set_bit(UNLOADING, &base_vha->dpc_flags);
> @@ -5866,7 +5870,6 @@ void qla2x00_relogin(struct scsi_qla_host *vha)
>  	qla2x00_unmap_iobases(ha);
> 
>  	pci_release_selected_regions(ha->pdev, ha->bars);
> -	pci_disable_pcie_error_reporting(pdev);
>  	pci_disable_device(pdev);
> 
>  	/*
> 


-- 
Brian King
Power Linux I/O
IBM Linux Technology Center
