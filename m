From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH V2] hpsa: refine the pci enable/disable handling
Date: Sat, 6 Sep 2014 23:38:31 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958C55BD2@G4W3202.americas.hpqcorp.net>
References: <53ECC3D7.90303@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3427.houston.hp.com ([15.201.208.55]:60730 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbaIFXmS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 6 Sep 2014 19:42:18 -0400
In-Reply-To: <53ECC3D7.90303@redhat.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: "Handzik, Joe" <joseph.t.handzik@hp.com>



> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Tomas Henzl
...

> +	/* kdump kernel is loading, we don't know in which state is
> +	 * the pci interface. The dev->enable_cnt is equal zero
> +	 * so we call enable+disable, wait a while and switch it on.
> +	 */
> +	rc = pci_enable_device(pdev);
> +	if (rc) {
> +		dev_warn(&pdev->dev, "Failed to enable PCI device\n");
> +		return -ENODEV;
> +	}
> +	pci_disable_device(pdev);
> +	msleep(260);			/* a randomly chosen number */
> +	rc = pci_enable_device(pdev);
> +	if (rc) {
> +		dev_warn(&pdev->dev, "failed to enable device.\n");
> +		return -ENODEV;
> +	}
> +
>  	/* Reset the controller with a PCI power-cycle or via doorbell
> */

I tested this patch by adding:
	reset_devices
to the kernel command line, which sets a kernel global variable that
triggers the driver to take this path.

Controller initialization failed with:
[   21.822789] hpsa 0000:02:00.0: Waiting for controller to respond to no-op
[  121.822219] hpsa 0000:02:00.0: controller message 03:00 timed out
[  121.854814] hpsa 0000:02:00.0: no-op failed; re-trying
...

The reason is that pci_disable_device clears the Bus Master Enable bit,
and there is no call to pci_set_master after pci_enable.  The controller is
unable to return the response for the command sent by hpsa_noop down
below.  Adding pci_set_master(pdev) got it working.

A call to pci_request_regions is also missing (that's supposed to
be called before accessing the controller's memory space), but
that's not fatal here.

---
Rob Elliott    HP Server Storage
