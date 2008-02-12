From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] 2.6.25-rc1-git2: GDT SCSI: change drivers/scsi/gdth.c
	into using pci_get device
Date: Tue, 12 Feb 2008 10:22:34 -0600
Message-ID: <1202833354.3137.19.camel@localhost.localdomain>
References: <47B1ADCE.40202@larces.uece.br>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1762989AbYBLQWv@vger.kernel.org>
In-Reply-To: <47B1ADCE.40202@larces.uece.br>
Sender: linux-kernel-owner@vger.kernel.org
To: Sergio Luis <sergio@larces.uece.br>
Cc: Achim Leubner <achim_leubner@adaptec.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2008-02-12 at 11:31 -0300, Sergio Luis wrote:
> Fix compilation warning in drivers/scsi/gdth.c, using deprecated pci_find_device. 
> Change it into using pci_get_device instead:
> drivers/scsi/gdth.c:645: warning: 'pci_find_device' is deprecated (declared at include/linux/pci.h:495)
> 
> Signed-off-by: Sergio Luis <sergio@larces.uece.br>
> 
> gdth.c |    2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> diff -urN linux-2.6.25-rc1-git2.orig/drivers/scsi/gdth.c linux-2.6.25-rc1-git2/drivers/scsi/gdth.c
> --- linux-2.6.25-rc1-git2.orig/drivers/scsi/gdth.c	2008-02-12 09:26:14.000000000 -0300
> +++ linux-2.6.25-rc1-git2/drivers/scsi/gdth.c	2008-02-12 10:33:08.000000000 -0300
> @@ -642,7 +642,7 @@
>            *cnt, vendor, device));
>  
>      pdev = NULL;
> -    while ((pdev = pci_find_device(vendor, device, pdev)) 
> +    while ((pdev = pci_get_device(vendor, device, pdev)) 
>             != NULL) {
>          if (pci_enable_device(pdev))
>              continue;

This can't be correct without a matching put in the error leg.

The difference between the two APIs is that pci_get_device returns a
pci_device with a reference taken and pci_find_device doesn't.  However,
pci_get_device does drop the reference again so as long as you never
exit the loop until it returns NULL, it is OK ... it's the exits before
pci_get_device() returns NULL that need the put.

James
