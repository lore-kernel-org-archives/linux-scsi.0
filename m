From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH V2] hpsa: refine the pci enable/disable handling
Date: Mon, 08 Sep 2014 17:26:02 +0200
Message-ID: <540DCA8A.9010203@redhat.com>
References: <53ECC3D7.90303@redhat.com> <94D0CD8314A33A4D9D801C0FE68B402958C55BD2@G4W3202.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52479 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753584AbaIHP1f (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Sep 2014 11:27:35 -0400
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402958C55BD2@G4W3202.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: "Handzik, Joe" <joseph.t.handzik@hp.com>, Christoph Hellwig <hch@infradead.org>

On 09/07/2014 01:38 AM, Elliott, Robert (Server Storage) wrote:
>
>> -----Original Message-----
>> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
>> owner@vger.kernel.org] On Behalf Of Tomas Henzl
> ...
>
>> +	/* kdump kernel is loading, we don't know in which state is
>> +	 * the pci interface. The dev->enable_cnt is equal zero
>> +	 * so we call enable+disable, wait a while and switch it on.
>> +	 */
>> +	rc = pci_enable_device(pdev);
>> +	if (rc) {
>> +		dev_warn(&pdev->dev, "Failed to enable PCI device\n");
>> +		return -ENODEV;
>> +	}
>> +	pci_disable_device(pdev);
>> +	msleep(260);			/* a randomly chosen number */
>> +	rc = pci_enable_device(pdev);
>> +	if (rc) {
>> +		dev_warn(&pdev->dev, "failed to enable device.\n");
>> +		return -ENODEV;
>> +	}
>> +
>>  	/* Reset the controller with a PCI power-cycle or via doorbell
>> */
> I tested this patch by adding:
> 	reset_devices
> to the kernel command line, which sets a kernel global variable that
> triggers the driver to take this path.
>
> Controller initialization failed with:
> [   21.822789] hpsa 0000:02:00.0: Waiting for controller to respond to no-op
> [  121.822219] hpsa 0000:02:00.0: controller message 03:00 timed out
> [  121.854814] hpsa 0000:02:00.0: no-op failed; re-trying
> ...
>
> The reason is that pci_disable_device clears the Bus Master Enable bit,
> and there is no call to pci_set_master after pci_enable.  The controller is
> unable to return the response for the command sent by hpsa_noop down
> below.  Adding pci_set_master(pdev) got it working.

And I was sure I've tested it, but apparently I haven't after adding the last part.
Thanks for testing.

>
> A call to pci_request_regions is also missing (that's supposed to
> be called before accessing the controller's memory space), but
> that's not fatal here.

This patch doesn't change this, pci_request_regions wasn't also called without
it before. Likely there probably are some weak points during the pci initialisation
and combined with the "OS BUG" there is room for changes.
I wanted just to get rid of the "disabling already-disabled device" warning
and change it only as least as possible so it doesn't stop working (but have failed though).


The patch below fixes the problem for me.

Christoph, what is the best approach - should  I post this to the list as new patch
or would you prefer to drop the old version and repost a fixed patch?
Maybe HP could add the patch to their upcoming series in that case.

Tomas

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 7828834..cef5d49 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -6544,7 +6544,7 @@ static int hpsa_init_reset_devices(struct pci_dev *pdev)
 		dev_warn(&pdev->dev, "failed to enable device.\n");
 		return -ENODEV;
 	}
-
+	pci_set_master(pdev);
 	/* Reset the controller with a PCI power-cycle or via doorbell */
 	rc = hpsa_kdump_hard_reset_controller(pdev);
 

>
> ---
> Rob Elliott    HP Server Storage
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

