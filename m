From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: [PATCH]: Fix section mismatch in mpt2sas
Date: Thu, 8 Jul 2010 14:44:05 -0600
Message-ID: <4565AEA676113A449269C2F3A549520F400E050E@cosmail03.lsi.com>
References: <20100707230819.31455.6553.sendpatchset@prarit.bos.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:46401 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753889Ab0GHUoM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Jul 2010 16:44:12 -0400
In-Reply-To: <20100707230819.31455.6553.sendpatchset@prarit.bos.redhat.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Prarit Bhargava <prarit@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Desai, Kashyap" <Kashyap.Desai@lsi.com>, "revers@redhat.com" <revers@redhat.com>

On Wednesday, July 07, 2010 5:09 PM, Prarit Bhargava wrote:
> 
> WARNING: drivers/scsi/mpt2sas/mpt2sas.o(.text+0xe3d4): Section mismatch
> in reference from the function _scsih_pci_error_detected() to the
> function .devexit.text:_scsih_remove()
> The function _scsih_pci_error_detected() references a function in an
> exit section.
> Often the function _scsih_remove() has valid usage outside the exit
> section
> and the fix is to remove the __devexit annotation of _scsih_remove.
> 
> by removing __devexit from _scsih_remove()
> 
> Signed-off-by: Prarit Bhargava <prarit@redhat.com>
> 
> diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> index c5ff26a..c630aa7 100644
> --- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> +++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> @@ -6290,7 +6290,7 @@ _scsih_shutdown(struct pci_dev *pdev)
>   * Routine called when unloading the driver.
>   * Return nothing.
>   */
> -static void __devexit
> +static void
>  _scsih_remove(struct pci_dev *pdev)
>  {
>  	struct Scsi_Host *shost = pci_get_drvdata(pdev);
> @@ -6798,7 +6798,7 @@ static struct pci_driver scsih_driver = {
>  	.name		= MPT2SAS_DRIVER_NAME,
>  	.id_table	= scsih_pci_table,
>  	.probe		= _scsih_probe,
> -	.remove		= __devexit_p(_scsih_remove),
> +	.remove		= _scsih_remove,
>  	.shutdown	= _scsih_shutdown,
>  	.err_handler	= &_scsih_err_handler,
>  #ifdef CONFIG_PM


NACK.   This is not required after the patch I just posted.  The fix is we shouldn't be calling _scsih_remove from _scsih_pci_error_detected.

Eric Moore



