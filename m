From: "Ju, Seokmann" <Seokmann.Ju@lsil.com>
Subject: RE: [PATCH] megaraid_mbox: fix section mismatch warnings
Date: Tue, 30 May 2006 07:37:18 -0600
Message-ID: <890BF3111FB9484E9526987D912B261901BD99@NAMAIL3.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:9386 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1751499AbWE3Nhd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 May 2006 09:37:33 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Randy.Dunlap" <rdunlap@xenotime.net>, =?iso-8859-1?Q?=5F=5Fsmail_D=F6nmez?= <ismail@pardus.org.tr>, scsi <linux-scsi@vger.kernel.org>
Cc: akpm <akpm@osdl.org>, jejb <james.bottomley@steeleye.com>, "Kolli, Neela" <Neela.Kolli@engenio.com>

Hi,

Thursday, May 25, 2006 12:46 PM, Randy Dunlap wrote:
> Fix section warning:
> WARNING: drivers/scsi/megaraid/megaraid_mbox.o - Section=20
> mismatch: reference to .init.text: from .text between=20
> 'megaraid_probe_one' (at offset 0x171e) and 'megaraid_queue_command'
>=20
> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
> ---
>  drivers/scsi/megaraid/megaraid_mbox.c |    2 +-
>  1 files changed, 1 insertion(+), 1 deletion(-)
>=20
> --- linux-2617-rc5.orig/drivers/scsi/megaraid/megaraid_mbox.c
> +++ linux-2617-rc5/drivers/scsi/megaraid/megaraid_mbox.c
> @@ -714,7 +714,7 @@ megaraid_io_detach(adapter_t *adapter)
>   * . Allocate memory required for all the commands
>   * . Use internal library of FW routines, build up complete=20
> soft state
>   */
> -static int __init
> +static int __devinit
>  megaraid_init_mbox(adapter_t *adapter)
>  {
>  	struct pci_dev		*pdev;
Thank you for pointing out a bug.
However, in my opinion, I would rather to simply remove '__init' from t=
he function.
The function is just a sub function called by megaraid_probe_one which =
has '__devinit' tag.
Please let me know if this is acceptable.
I will submit a patch with proper change.

Thanks,

Seokmann

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org=20
> [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Randy.Dunlap
> Sent: Thursday, May 25, 2006 12:46 PM
> To: __smail D=F6nmez; scsi
> Cc: akpm; jejb; Kolli, Neela
> Subject: [PATCH] megaraid_mbox: fix section mismatch warnings
>=20
> From: Randy Dunlap <rdunlap@xenotime.net>
>=20
> Fix section warning:
> WARNING: drivers/scsi/megaraid/megaraid_mbox.o - Section=20
> mismatch: reference to .init.text: from .text between=20
> 'megaraid_probe_one' (at offset 0x171e) and 'megaraid_queue_command'
>=20
> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
> ---
>  drivers/scsi/megaraid/megaraid_mbox.c |    2 +-
>  1 files changed, 1 insertion(+), 1 deletion(-)
>=20
> --- linux-2617-rc5.orig/drivers/scsi/megaraid/megaraid_mbox.c
> +++ linux-2617-rc5/drivers/scsi/megaraid/megaraid_mbox.c
> @@ -714,7 +714,7 @@ megaraid_io_detach(adapter_t *adapter)
>   * . Allocate memory required for all the commands
>   * . Use internal library of FW routines, build up complete=20
> soft state
>   */
> -static int __init
> +static int __devinit
>  megaraid_init_mbox(adapter_t *adapter)
>  {
>  	struct pci_dev		*pdev;
>=20
>=20
> ---
> -
> To unsubscribe from this list: send the line "unsubscribe=20
> linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
