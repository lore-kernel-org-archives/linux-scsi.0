From: "Moore, Eric Dean" <Emoore@lsil.com>
Subject: RE: [PATCH] fusion/mptscsih init/exit sections
Date: Wed, 10 Mar 2004 09:52:46 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E57040DABAC@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:23538 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S262637AbUCJOwy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Mar 2004 09:52:54 -0500
List-Id: linux-scsi@vger.kernel.org
To: "Randy.Dunlap" <rddunlap@osdl.org>, scsi <linux-scsi@vger.kernel.org>
Cc: jejb <james.bottomley@steeleye.com>

Randy - This fix has already been applied in the mpt drivers
for version 3.00.04 and 3.01.00 drivers, which are are in
the queue for the 2.6.5 kernel

3.00.04 drivers location:
ftp://ftp.lsil.com/HostAdapterDrivers/linux/FiberChannel/2.6-patches/3.00.04

3.01.00 drivers location:
ftp://ftp.lsil.com/HostAdapterDrivers/linux/FiberChannel/2.6-patches/3.01.00



On Tuesday, March 09, 2004 11:02 PM, Randy.Dunlap wrote:
> 
> V: linux-264-rc2
> D: mptscsih_remove() can be called during init, for error handling;
> 
> diffstat:=
>  drivers/message/fusion/mptscsih.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> 
> diff -Naurp ./drivers/message/fusion/mptscsih.c~mptscsi_init 
> ./drivers/message/fusion/mptscsih.c
> --- ./drivers/message/fusion/mptscsih.c~mptscsi_init	
> 2004-03-06 20:57:05.000000000 -0800
> +++ ./drivers/message/fusion/mptscsih.c	2004-03-07 
> 16:16:54.000000000 -0800
> @@ -201,7 +201,7 @@ static int  __init   mptscsih_init  (voi
>  static void __exit   mptscsih_exit  (void);
>  
>  static int  __devinit mptscsih_probe (struct pci_dev *, 
> const struct pci_device_id *);
> -static void __devexit mptscsih_remove(struct pci_dev *);
> +static void mptscsih_remove(struct pci_dev *);
>  static void mptscsih_shutdown(struct device *);
>  #ifdef CONFIG_PM
>  static int mptscsih_suspend(struct pci_dev *pdev, u32 state);
> @@ -1718,7 +1718,7 @@ mptscsih_probe_failed:
>   *
>   *
>   */
> -static void __devexit
> +static void
>  mptscsih_remove(struct pci_dev *pdev)
>  {
>  	MPT_ADAPTER 		*ioc = pci_get_drvdata(pdev);
> @@ -1920,7 +1920,7 @@ mptscsih_resume(struct pci_dev *pdev)
>  
>  static struct mpt_pci_driver mptscsih_driver = {
>  	.probe		= mptscsih_probe,
> -	.remove		= __devexit_p(mptscsih_remove),
> +	.remove		= mptscsih_remove,
>  	.shutdown	= mptscsih_shutdown,
>  #ifdef CONFIG_PM
>  	.suspend	= mptscsih_suspend,
> 
> 
> --
> ~Randy
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
