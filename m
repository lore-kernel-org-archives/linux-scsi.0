From: Simon Oosthoek <simon.oosthoek@ti-wmc.nl>
Subject: Re: SATA status report updated
Date: Fri, 19 Aug 2005 10:09:14 +0200
Message-ID: <430593AA.50201@ti-wmc.nl>
References: <42FC2EF8.7030404@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932324AbVHSIJg@vger.kernel.org>
In-Reply-To: <42FC2EF8.7030404@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Jeff Garzik wrote:
> 
> Things in SATA-land have been moving along recently, so I updated the 
> software status report:
> 
>     http://linux.yyz.us/sata/software-status.html
> 
> Although I have not updated it in several weeks, folks may wish to refer 
> to the hardware status report as well:
> 
>     http://linux.yyz.us/sata/sata-status.html
> 
> Thanks to all the hard-working SATA contributors!
> 

Good overview!

I'm wondering how the support for the SIS 182 controller is doing, I 
noticed they have a GPL driver on their website for kernel 2.6.10, which 
is not a drop in replacement for sata_sis.c in 2.6.12.5, I haven't tried 
compiling it as an add-on module outside the tree, though...

Adding the 0x182 identifier to the 180 driver does compile (duh!), but I 
haven't tried it on hardware.

As a temporary measure, there was a patch posted to this list [1] a 
while ago, would it be a good idea to include this while full support is 
being worked on?

Cheers

Simon

[1]
Patch signed-off-by: Rainer Koenig <Rainer.Koenig@fujitsu-siemens.com>

--- linux-2.6.12.4/drivers/scsi/sata_sis.c	2005-08-05 09:04:37.000000000 
+0200
+++ linux/drivers/scsi/sata_sis.c	2005-08-11 10:22:07.000000000 +0200
@@ -62,6 +62,7 @@
  static struct pci_device_id sis_pci_tbl[] = {
  	{ PCI_VENDOR_ID_SI, 0x180, PCI_ANY_ID, PCI_ANY_ID, 0, 0, sis_180 },
  	{ PCI_VENDOR_ID_SI, 0x181, PCI_ANY_ID, PCI_ANY_ID, 0, 0, sis_180 },
+        { PCI_VENDOR_ID_SI, 0x182, PCI_ANY_ID, PCI_ANY_ID, 0, 0, sis_180 },
  	{ }	/* terminate list */
  };
