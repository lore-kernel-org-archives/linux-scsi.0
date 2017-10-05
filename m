From: Kyle Fortin <kyle.fortin@oracle.com>
Subject: Re: [PATCH] vmw_pvscsi: Don't call free_irq twice on remove adapter
Date: Thu, 5 Oct 2017 13:55:44 -0400
Message-ID: <CA9FE5EA-7E53-436D-AF3A-4F21A1457A43@oracle.com>
References: <20171004190331.icpl7ku5tcwe4igm@petr-dev3.eng.vmware.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38621 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751286AbdJERzr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Oct 2017 13:55:47 -0400
In-Reply-To: <20171004190331.icpl7ku5tcwe4igm@petr-dev3.eng.vmware.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jim Gill <jgill@vmware.com>
Cc: jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org

Hi Jim,

On Oct 4, 2017, at 3:03 PM, Jim Gill <jgill@vmware.com> wrote:
> 
> Remove redundant call to pvscsi_shutdown_intr from
> pvscsi_remove_resources.  Add calls to pvscsi_shutdown_intr
> in the failure cases for pvscsi_probe.
> 
> Signed-off-by: Jim Gill <jgill@vmware.com>
> ---
> drivers/scsi/vmw_pvscsi.c | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
> index c374e3b..c7e74ac 100644
> --- a/drivers/scsi/vmw_pvscsi.c
> +++ b/drivers/scsi/vmw_pvscsi.c
> @@ -1197,8 +1197,6 @@ static void pvscsi_shutdown_intr(struct pvscsi_adapter *adapter)
> 
> static void pvscsi_release_resources(struct pvscsi_adapter *adapter)
> {
> -	pvscsi_shutdown_intr(adapter);
> -
> 	if (adapter->workqueue)
> 		destroy_workqueue(adapter->workqueue);
> 
> @@ -1530,6 +1528,7 @@ static int pvscsi_probe(struct pci_dev *pdev, const struct pci_device_id *id)
> out_reset_adapter:

>From what I understand the irq(s) are not allocated until the pci_alloc_irq_vectors call.  After, all breakout jumps are to out_reset_adapter.

Could it be simplified to just adding pvscsi_shutdown_intr before ll_adapter_reset() here?  Then you don’t need the other two pvscsi_shutdown_intr() calls below.

> 	ll_adapter_reset(adapter);
> out_release_resources:
> +	pvscsi_shutdown_intr(adapter);
> 	pvscsi_release_resources(adapter);
> 	scsi_host_put(host);
> out_disable_device:
> @@ -1538,6 +1537,7 @@ static int pvscsi_probe(struct pci_dev *pdev, const struct pci_device_id *id)
> 	return error;
> 
> out_release_resources_and_disable:
> +	pvscsi_shutdown_intr(adapter);
> 	pvscsi_release_resources(adapter);
> 	goto out_disable_device;
> }
> -- 
> 2.7.4

--
Kyle Fortin - Oracle Linux Engineering
