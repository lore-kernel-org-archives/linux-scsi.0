From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH RESEND 2] mvsas: Recognise device/subsystem 9485/9485 as
 88SE9485
Date: Mon, 14 Apr 2014 12:42:39 -0700
Message-ID: <1397504559.2207.30.camel@dabdike.int.hansenpartnership.com>
References: <1392772002.10088.50.camel@deadeye.wl.decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:56055 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752962AbaDNTml (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Apr 2014 15:42:41 -0400
In-Reply-To: <1392772002.10088.50.camel@deadeye.wl.decadent.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ben Hutchings <ben@decadent.org.uk>, yxlraid@gmail.com
Cc: Matt Taggart <taggart@debian.org>, Debian kernel maintainers <debian-kernel@lists.debian.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, 2014-02-19 at 01:06 +0000, Ben Hutchings wrote:
> Matt Taggart reported that mvsas didn't bind to the Marvell
> SAS controller on a Supermicro AOC-SAS2LP-MV8 board.
> 
> lspci reports it as:
> 
> 01:00.0 RAID bus controller [0104]: Marvell Technology Group Ltd. Device [1b4b:9485] (rev 03)
>         Subsystem: Marvell Technology Group Ltd. Device [1b4b:9485]
> [...]
> 
> Add it to the device table as chip_9485.

Adding Marvell maintainer to cc.  Can we get an ack on this ... or is
mvsas dead and I can just apply it anyway?

Thanks,

James


> Reported-by: Matt Taggart <taggart@debian.org>
> Tested-by: Matt Taggart <taggart@debian.org>
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  drivers/scsi/mvsas/mv_init.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
> index 7b7381d..83fa5f8 100644
> --- a/drivers/scsi/mvsas/mv_init.c
> +++ b/drivers/scsi/mvsas/mv_init.c
> @@ -729,6 +729,15 @@ static struct pci_device_id mvs_pci_table[] = {
>  		.class_mask	= 0,
>  		.driver_data	= chip_9485,
>  	},
> +	{
> +		.vendor		= PCI_VENDOR_ID_MARVELL_EXT,
> +		.device		= 0x9485,
> +		.subvendor	= PCI_ANY_ID,
> +		.subdevice	= 0x9485,
> +		.class		= 0,
> +		.class_mask	= 0,
> +		.driver_data	= chip_9485,
> +	},
>  	{ PCI_VDEVICE(OCZ, 0x1021), chip_9485}, /* OCZ RevoDrive3 */
>  	{ PCI_VDEVICE(OCZ, 0x1022), chip_9485}, /* OCZ RevoDrive3/zDriveR4 (exact model unknown) */
>  	{ PCI_VDEVICE(OCZ, 0x1040), chip_9485}, /* OCZ RevoDrive3/zDriveR4 (exact model unknown) */
> 
> 
> -- 
> Ben Hutchings
> One of the nice things about standards is that there are so many of them.
> 



