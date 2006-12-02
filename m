From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 5/8] stex: update device id info
Date: Sat, 02 Dec 2006 00:09:54 -0500
Message-ID: <45710AA2.3000101@garzik.org>
References: <NONAMEBzg7KazMfhgmu0000149b@nonameb.ptu.promise.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:39342 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1162811AbWLBFJ5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Dec 2006 00:09:57 -0500
In-Reply-To: <NONAMEBzg7KazMfhgmu0000149b@nonameb.ptu.promise.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ed Lin <ed.lin@promise.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "James.Bottomley" <James.Bottomley@SteelEye.com>, promise_linux <promise_linux@promise.com>

Ed Lin wrote:
> Update pci device id and Kconfig help information.
> 
> Signed-off-by: Ed Lin <ed.lin@promise.com>

NAK.  At the very least, this patch description needs enhancing, but 
more likely we need another PCI ID entry or two.


> ---
> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> index 1301d52..fb55373 100644
> --- a/drivers/scsi/Kconfig
> +++ b/drivers/scsi/Kconfig
> @@ -968,8 +968,16 @@ config SCSI_STEX
>  	tristate "Promise SuperTrak EX Series support"
>  	depends on PCI && SCSI
>  	---help---
> -	  This driver supports Promise SuperTrak EX8350/8300/16350/16300
> -	  Storage controllers.
> +	  This driver supports Promise SuperTrak EX series storage controllers.
> +	  These include SuperTrak EX8350, EX8300, EX16350, EX16300, EX12350,
> +	  EX4350, EX24350; SuperTrak EX4650, EX4650o, EX8650EL, EX8650, EX8654;
> +	  and VSC7250 series.

I would strongly suggest eliminating the "These include ...." sentence. 
  Otherwise, you will be forced by marketing department to patch the 
driver every time a new board appears.


> -	{ 0x1725, 0x7250, PCI_ANY_ID, PCI_ANY_ID, 0, 0, st_vsc },
[...]
> +	/* st_vsc */
> +	{ 0x105a, 0x7250, 0x105a, 0x1000, 0, 0, st_vsc0 },
> +	{ 0x105a, 0x7250, 0x105a, 0x2500, 0, 0, st_vsc0 },
> +	{ 0x105a, 0x7250, 0x105a, 0x2510, 0, 0, st_vsc0 },
> +	{ 0x105a, 0x7250, 0x105a, 0x2520, 0, 0, st_vsc0 },
> +	{ 0x105a, 0x7250, 0x105a, 0x2530, 0, 0, st_vsc0 },
> +	{ 0x105a, 0x7250, 0x105a, 0x1001, 0, 0, st_vsc1 },
> +	{ 0x105a, 0x7250, 0x105a, 0x2501, 0, 0, st_vsc1 },
> +	{ 0x105a, 0x7250, 0x105a, 0x2511, 0, 0, st_vsc1 },
> +	{ 0x105a, 0x7250, 0x105a, 0x2521, 0, 0, st_vsc1 },
> +	{ 0x105a, 0x7250, 0x105a, 0x2531, 0, 0, st_vsc1 },

Normal this sort of change -- not providing a generic PCI_ANY_ID entries 
for the sub-device and sub-vendor IDs -- is a bad idea.

This means that the VSC-related section of the pci_device_id table will 
be very maintenance intensive over time.  It also means that new or 
unknown compatible devices will not automatically be picked up by the 
driver.

It may be preferable even to do

	 0x105a, 0x7250, PCI_ANY_ID, PCI_ANY_ID, 0, 0, st_vsc0

and then in the PCI init routine, add code that looks something like

	if ((ent->driver_data == st_vsc0) && (test for newer rev1))
		driver_data = st_vsc1;
	else
		driver_data = st_vsc0;

Regards,

	Jeff


