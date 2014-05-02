From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH v1.0 2/16] arcmsr: Support MSI-X interrupt
Date: Fri, 2 May 2014 11:31:01 +0300
Message-ID: <20140502083101.GB4963@mwanda>
References: <1398851412.1769.16.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26577 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbaEBIbY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 May 2014 04:31:24 -0400
Content-Disposition: inline
In-Reply-To: <1398851412.1769.16.camel@localhost>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ching <ching2048@areca.com.tw>
Cc: jbottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, thenzl@redhat.com

On Wed, Apr 30, 2014 at 05:50:12PM +0800, ching wrote:
> From: Ching<ching2048@areca.com.tw>
> 
> Adding code for supporting MSI-X interrupt
> 
> Signed-off-by: Ching<ching2048@areca.com.tw>
> ---

These patches seem to be broken up nicely into patches which do one
thing per patch and they are much easier to review now.  Thanks!

> +static int arcmsr_request_irq(struct pci_dev *pdev, struct AdapterControlBlock *acb)
> +{
> +	int	i, j, r;
> +	struct msix_entry entries[ARCMST_NUM_MSIX_VECTORS];
> +

This function is more confusing than necessary and it goes over the 80
character limit.  One hint for improving it is that you should always
test for failure and handle the failure condition first before moving
on.  In other words reverse these tests.

Also let's rename LEG_INT to legacy_int: and MSI_INT to msi_int:.

> +	if (pci_find_capability(pdev, PCI_CAP_ID_MSIX)) {

	if (!pci_find_capability(pdev, PCI_CAP_ID_MSIX))
		goto msi_int;

We can pull the following code in one indent level.

> +		for (i = 0; i < ARCMST_NUM_MSIX_VECTORS; i++) {
> +			entries[i].entry = i;
> +		}

Remove unneeded curly braces.

> +		r = pci_enable_msix(pdev, entries, ARCMST_NUM_MSIX_VECTORS);

		if (r < 0)
			goto msi_int;

> +		if (r == 0) {
> +			for (i = 0; i < ARCMST_NUM_MSIX_VECTORS; i++) {
> +				if (request_irq(entries[i].vector,
> +					arcmsr_do_interrupt, 0, "arcmsr", acb)) {
> +					pr_warn("arcmsr%d: request_irq =%d failed!\n",
> +						acb->host->host_no, pdev->irq);
> +					for (j = 0 ; j < i ; j++)
> +						free_irq(entries[i].vector, acb);
> +					pci_disable_msix(pdev);
> +					goto MSI_INT;
> +				}
> +				acb->entries[i] = entries[i];
> +			}
> +			acb->acb_flags |= ACB_F_MSIX_ENABLED;
> +			pr_warn("arcmsr%d: msi-x enabled\n", acb->host->host_no);

This should be pr_info().  pr_warn() will probably trigger a popup in
gnome.
			return ARC_SUCCESS;

Returning right away is easier to understand than a return at the end
of the function.

> +		} else if (r > 0) {

This else statement is not needed because we already handled the other
cases.  Pull the code in one additional indent level.

> +			if (!pci_enable_msix(pdev, entries, r)) {

			if (pci_enable_msix(pdev, entries, r))
				goto msi_int;

Pull the code in a third indent level.

> +				for (i = 0; i < r; i++) {
> +					if (request_irq(entries[i].vector,
> +						arcmsr_do_interrupt, 0, "arcmsr", acb)) {
> +						pr_warn("arcmsr%d: request_irq =%d failed!\n",
> +							acb->host->host_no, pdev->irq);
> +						for (j = 0 ; j < i ; j++)
> +							free_irq(entries[i].vector, acb);
> +						pci_disable_msix(pdev);
> +						goto MSI_INT;
> +					}
> +					acb->entries[i] = entries[i];
> +				}
> +				acb->acb_flags |= ACB_F_MSIX_ENABLED;
> +				pr_warn("arcmsr%d: msi-x enabled\n", acb->host->host_no);


Same thing.  Change this to pr_info() and add a return ARC_SUCCESS;

> +			} else {
> +				goto MSI_INT;
> +			}
> +		} else {


Ok.  At this point we have removed a lot of indenting so we are back to
level 1 indenting.

msi_int:
	if (!pci_find_capability(pdev, PCI_CAP_ID_MSI))
		goto legacy_int;
	if (pci_enable_msi(pdev))
		goto legacy_int;
	if (request_irq(...)) {
		....
		goto legacy_int;
	}

> +MSI_INT:
> +			if (pci_find_capability(pdev, PCI_CAP_ID_MSI)) {
> +				if (pci_enable_msi(pdev))
> +					goto LEG_INT;
> +				if (request_irq(pdev->irq, arcmsr_do_interrupt,
> +					IRQF_SHARED, "arcmsr", acb)) {
> +					pr_warn("arcmsr%d: request_irq =%d failed!\n",
> +						acb->host->host_no, pdev->irq);
> +					pci_disable_msi(pdev);
> +					goto LEG_INT;
> +				}
> +				acb->acb_flags |= ACB_F_MSI_ENABLED;
> +				pr_warn("arcmsr%d: msi enabled\n", acb->host->host_no);

return sucess.

> +			} else {
> +				goto LEG_INT;
> +			}
> +		}


The following block is all duplicative code and we have already handled
msi_int.  Just delete it.

> +	} else if (pci_find_capability(pdev, PCI_CAP_ID_MSI)) {
> +		if (pci_enable_msi(pdev))
> +			goto LEG_INT;
> +		if (request_irq(pdev->irq, arcmsr_do_interrupt,
> +			IRQF_SHARED, "arcmsr", acb)) {
> +			pr_warn("arcmsr%d: request_irq =%d failed!\n",
> +				acb->host->host_no, pdev->irq);
> +			pci_disable_msi(pdev);
> +			goto LEG_INT;
> +		}
> +		acb->acb_flags |= ACB_F_MSI_ENABLED;
> +		pr_warn("arcmsr%d: msi enabled\n", acb->host->host_no);
> +	} else {

Ok.  We're back to level one indenting now.

legacy_int:
	if (request_irq(...) {
		...
		return ARC_FAILURE;
	}
	return ARC_SUCCESS;

Flipping the conditions around and adding immediate returns makes the
code a lot easier to read.

> +LEG_INT:
> +		if (request_irq(pdev->irq, arcmsr_do_interrupt,
> +			IRQF_SHARED, "arcmsr", acb)) {
> +			pr_warn("arcmsr%d: request_irq = %d failed!\n",
> +				acb->host->host_no, pdev->irq);
> +			return ARC_FAILURE;
> +		}
> +	}
> +	return ARC_SUCCESS;
> +}
> +

regards,
dan carpenter
