From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 3/21] advansys: Convert to pci_register_driver interface
Date: Thu, 26 Jul 2007 15:31:21 -0400
Message-ID: <46A8F689.108@garzik.org>
References: 20070726171141.GE19275@parisc-linux.org <11854705774041-git-send-email-matthew@wil.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:50875 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753693AbXGZTbY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Jul 2007 15:31:24 -0400
In-Reply-To: <11854705774041-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> +static int __devinit
> +advansys_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
> +{
> +	int ioport;
> +	struct Scsi_Host *shost;
> +
> +	if (pci_enable_device(pdev))
> +		goto fail;
> +
> +	ioport = pci_resource_start(pdev, 0);
> +	shost = advansys_board_found(ioport, &pdev->dev, ASC_IS_PCI);
> +
> +	if (shost) {
> +		pci_set_drvdata(pdev, shost);
> +		return 0;
> +	}
> +
> +	pci_disable_device(pdev);
> + fail:
> +	return -ENODEV;
> +}

1) you should propagate pci_enable_device return value to caller on error

1.1) in general, following my comment #1 will make this function look 
more like other normal Linux code, i.e.

	rc = foo
	if (rc)
		goto err_out

	return 0;

      err_out:
	return rc;

2) you dropped the check for pci_resource_start() returning zero (look 
for 'iop == 0' in original code)

3) what happened to PCI BAR #1 ?  shouldn't you move that call here too? 
  it gets ioremapped (look at 'pci_memory_address' in old code, right 
next to pci_resource_start call)

4) it is often wise to add sanity checks that ensure that PCI BAR #0 == 
IORESOURCE_IO and PCI BAR #1 == IORESOURCE_MEM



> +static void __devexit advansys_pci_remove(struct pci_dev *pdev)
> +{
> +	int i;
> +	struct Scsi_Host *shost = pci_get_drvdata(pdev);
> +	scsi_remove_host(shost);
> +	advansys_release(shost);
> +
> +	for (i = 0; i < asc_board_count; i++) {
> +		if (asc_host[i] == shost) {
> +			asc_host[i] = NULL;
> +			break;
> +		}
> +	}
> +
> +	pci_disable_device(pdev);

5) call pci_set_drvdata(pdev, NULL) as with other PCI drivers


> +static struct pci_driver advansys_pci_driver = {
> +	.name = "advansys",
> +	.id_table = advansys_pci_tbl,
> +	.probe = advansys_pci_probe,
> +	.remove = __devexit_p(advansys_pci_remove),
> +};

6) suggestions:  tab alignment for struct member values; makes it far 
easier to read.


> +static int __init advansys_init(void)
> +{
> +	int count, error;
> +	count = advansys_detect();
> +	error = pci_register_driver(&advansys_pci_driver);
> +
> +	/*
> +	 * If we found some ISA, EISA or VLB devices, we must not fail.
> +	 * We may not drive any PCI devices, but it's better to drive
> +	 * the cards that we successfully discovered than none at all.
> +	 */
> +	if (count > 0)
> +		error = 0;
> +	return error;
> +}
> +
> +static void __exit advansys_exit(void)
> +{
> +	int i;
> +
> +	pci_unregister_driver(&advansys_pci_driver);

7) bug: don't unregister, if pci_register_driver() failed during init


> +	for (i = 0; i < asc_board_count; i++) {
> +		struct Scsi_Host *host = asc_host[i];
> +		if (!host)
> +			continue;
> +		scsi_remove_host(host);
> +		advansys_release(host);
> +		asc_host[i] = NULL;

this last line of code is rather pointless, isn't it?

