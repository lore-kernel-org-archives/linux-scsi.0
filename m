From: Jiang Liu <jiang.liu@linux.intel.com>
Subject: Re: [RFT v3] eata: Convert eata driver as normal PCI and platform
 device drivers
Date: Sat, 3 Oct 2015 16:11:28 +0800
Message-ID: <560F8DB0.8030704@linux.intel.com>
References: <20150916134211.GA21535@infradead.org>
 <1442907023-12709-1-git-send-email-jiang.liu@linux.intel.com>
 <5601D550.5000801@internode.on.net>
 <1442961929.15264.4.camel@HansenPartnership.com>
 <5601E5FE.7020706@internode.on.net> <56023771.5010006@linux.intel.com>
 <5602829C.5090500@internode.on.net>
 <1443019207.2240.27.camel@HansenPartnership.com>
 <56037C09.5050201@linux.intel.com> <560390A1.5060503@internode.on.net>
 <56063AB7.9030309@internode.on.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080201060803010608010500"
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <56063AB7.9030309@internode.on.net>
Sender: linux-pci-owner@vger.kernel.org
To: Arthur Marsh <arthur.marsh@internode.on.net>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Bjorn Helgaas <bhelgaas@google.com>, Hannes Reinecke <hare@suse.de>, Ballabio Dario <dario.ballabio@emc.com>, Christoph Hellwig <hch@infradead.org>, Dario Ballabio <ballabio_dario@emc.com>, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org, x86@kernel.org
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------080201060803010608010500
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

On 2015/9/26 14:27, Arthur Marsh wrote:
> 
> 
> Arthur Marsh wrote on 24/09/15 15:26:
>>
>>
>> Jiang Liu wrote on 24/09/15 13:58:
>>
>>> Hi James,
>>>     Thanks for review. How about the attached patch which addresses
>>> the three suggestions from you?
>>> Thanks!
>>> Gerry
>>
>> I've applied the patch, rebuilt the kernel and verified that it allows
>> unloading of the eata module and reloading it, as well as a successful
>> kexec.
>>
>> Regards,
>>
>> Arthur.
> 
> After some more thorough testing I've encountered an ongoing problem
> trying to use kexec with filesystems mounted with the eata driver.
> 
> If I boot up and have the eata driver loaded but no filesystem check or
> mounting of filesystems on the disk attached to the DPT2044W controller,
> then attempt a kexec reboot I get the reboot pausing after the
> "synchronizing scsi cache" messages and getting the errors that I have
> included as pictures in my previous reports.
> 
> If I do a normal boot which includes eata being loaded, the disk
> attached to the DPT2044W controller having its filesystems checked and
> mounted, then attempt a kexec reboot, I get the reboot pausing after the
> "synchronizing SCSI cache" messages as before.
> 
> If I un-mount the filesystems on the disk attached to the DPT2044W
> controller after start-up and try a reboot I get the same problem.
> 
> If I do modprobe -r eata after un-mounting the filesystems on the disk
> attached to the DPT2044W controller after a start-up kexec *works fine*.
Hi Arthur,
	The above results suggest that we need to shutdown eata
controller for kexec. So could you please try to apply the attached
patch upon the previous two patches?
Thanks!
Gerry

--------------080201060803010608010500
Content-Type: text/x-patch;
 name="0001-eata-Implement-shutdown-callback-for-eata-driver.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-eata-Implement-shutdown-callback-for-eata-driver.patch"

>From 44a7ee9008951684a6ee1482a4445a64da61f54a Mon Sep 17 00:00:00 2001
From: Jiang Liu <jiang.liu@linux.intel.com>
Date: Sat, 3 Oct 2015 15:57:39 +0800
Subject: [PATCH] eata: Implement shutdown callback for eata driver

Implement shutdown callback for eata driver, so eata controllers will
be put into ready state for kexec.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/scsi/eata.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/scsi/eata.c b/drivers/scsi/eata.c
index ceeba4d7b4ff..f3ef9ac97646 100644
--- a/drivers/scsi/eata.c
+++ b/drivers/scsi/eata.c
@@ -1517,6 +1517,11 @@ static void eata2x_pci_remove(struct pci_dev *pdev)
 	pci_disable_device(pdev);
 }
 
+static void eata2x_pci_shutdown(struct pci_dev *pdev)
+{
+	port_remove(&pdev->dev);
+}
+
 static struct pci_device_id eata2x_tbl[] = {
 	{ PCI_DEVICE_CLASS(PCI_CLASS_STORAGE_SCSI << 8, PCI_ANY_ID) },
 	{ },
@@ -1528,6 +1533,7 @@ static struct pci_driver eata2x_pci_driver = {
 	.id_table	= eata2x_tbl,
 	.probe		= eata2x_pci_probe,
 	.remove		= eata2x_pci_remove,
+	.shutdown	= eata2x_pci_shutdown,
 };
 
 static int eata2x_register_pci_driver(void)
@@ -1569,8 +1575,14 @@ static int __exit eata2x_platform_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static void eata2x_platform_shutdown(struct platform_device *pdev)
+{
+	port_remove(&pdev->dev);
+}
+
 static struct platform_driver eata2x_platform_driver = {
 	.remove = __exit_p(eata2x_platform_remove),
+	.shutdown = eata2x_platform_shutdown,
 	.driver = {
 		.name	= "eata_plat",
 		.owner	= THIS_MODULE,
-- 
1.7.10.4


--------------080201060803010608010500--
