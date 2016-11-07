From: "Ewan D. Milne" <emilne@redhat.com>
Subject: Re: [PATCH 2/4] qla2xxx: Fix mailbox command timeout due to
 starvation
Date: Mon, 07 Nov 2016 10:53:46 -0500
Message-ID: <1478534026.32271.28.camel@localhost.localdomain>
References: <1478277213-3848-1-git-send-email-himanshu.madhani@cavium.com>
         <1478277213-3848-3-git-send-email-himanshu.madhani@cavium.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58846 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932226AbcKGPxs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 7 Nov 2016 10:53:48 -0500
In-Reply-To: <1478277213-3848-3-git-send-email-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: himanshu.madhani@cavium.com
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, himanshu.madhani@qlogic.com

On Fri, 2016-11-04 at 09:33 -0700, himanshu.madhani@cavium.com wrote:
...
> @@ -2349,6 +2349,17 @@ uint32_t qla2x00_isp_reg_stat(struct qla_hw_data *ha)
>  	return atomic_read(&vha->loop_state) == LOOP_READY;
>  }
>  
> +static void qla2x00_destroy_mbx_wq(struct qla_hw_data *ha)
> +{
> +	struct workqueue_struct *wq = ha->mbx_wq;
> +
> +	if (wq) {
> +		ha->mbx_wq = NULL;
> +		flush_workqueue(wq);
> +		destroy_workqueue(wq);
> +	}
> +}
> +
>  /*
>   * PCI driver interface
>   */

There is already a function qla2x00_destroy_deferred_work() that
destroys 3 other workqueues.

...

> @@ -3059,6 +3079,8 @@ uint32_t qla2x00_isp_reg_stat(struct qla_hw_data *ha)
>  
>  	qla2x00_free_fw_dump(ha);
>  
> +	qla2x00_destroy_mbx_wq(ha);
> +
>  	pci_disable_pcie_error_reporting(pdev);
>  	pci_disable_device(pdev);
>  }

This code path (pci_driver->shutdown) does not appear to destroy the
other workqueues created by the driver. ???

> @@ -5011,6 +5033,8 @@ void qla2x00_relogin(struct scsi_qla_host *vha)
>  	 */
>  	qla2x00_free_sysfs_attr(base_vha, false);
>  
> +	qla2x00_destroy_mbx_wq(ha);
> +
>  	fc_remove_host(base_vha->host);
>  
>  	scsi_remove_host(base_vha->host);

See above.

-Ewan


