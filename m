From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: RE: [PATCH 3/3] scsi: aacraid: Prevent crash in case of free
 interrupt during scsi EH path
Date: Fri, 17 Nov 2017 22:09:59 +0000
Message-ID: <4D8E82A446BF54499747901DBDEB737A9D8FDE7B@avsrvexchmbx2.microsemi.net>
References: <20171117211455.29031-1-gpiccoli@linux.vnet.ibm.com>
 <20171117211455.29031-4-gpiccoli@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0050.outbound.protection.outlook.com ([104.47.42.50]:31893
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933696AbdKQWKD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 17 Nov 2017 17:10:03 -0500
In-Reply-To: <20171117211455.29031-4-gpiccoli@linux.vnet.ibm.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Guilherme G. Piccoli" <gpiccoli@linux.vnet.ibm.com>, dl-esc-Aacraid Linux Driver <aacraid@microsemi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Dave Carroll <david.carroll@microsemi.com>, "gpiccoli@protonmail.ch" <gpiccoli@protonmail.ch>



> -----Original Message-----
> From: Guilherme G. Piccoli [mailto:gpiccoli@linux.vnet.ibm.com]
> Sent: Friday, November 17, 2017 1:15 PM
> To: dl-esc-Aacraid Linux Driver <aacraid@microsemi.com>; linux-
> scsi@vger.kernel.org
> Cc: gpiccoli@linux.vnet.ibm.com; Dave Carroll
> <david.carroll@microsemi.com>; Raghava Aditya Renukunta
> <RaghavaAditya.Renukunta@microsemi.com>; gpiccoli@protonmail.ch
> Subject: [PATCH 3/3] scsi: aacraid: Prevent crash in case of free interru=
pt
> during scsi EH path
>=20
> EXTERNAL EMAIL
>=20
>=20
> As part of the scsi EH path, aacraid performs a reinitialization of
> the adapter, which encompass freeing resources and IRQs, NULLifying
> lots of pointers, and then initialize it all over again.
> We've identified a problem during the free IRQ portion of this path
> if CONFIG_DEBUG_SHIRQ is enabled on kernel config file.
>=20
> Happens that, in case this flag was set, right after free_irq()
> effectively clears the interrupt, it checks if it was requested
> as IRQF_SHARED. In positive case, it performs another call to the
> IRQ handler on driver. Problem is: since aacraid currently free
> some resources *before* freeing the IRQ, once free_irq() path
> calls the handler again (due to CONFIG_DEBUG_SHIRQ), aacraid
> crashes due to NULL pointer dereference with the following trace:
>=20
>   aac_src_intr_message+0xf8/0x740 [aacraid]
>   __free_irq+0x33c/0x4a0
>   free_irq+0x78/0xb0
>   aac_free_irq+0x13c/0x150 [aacraid]
>   aac_reset_adapter+0x2e8/0x970 [aacraid]
>   aac_eh_reset+0x3a8/0x5d0 [aacraid]
>   scsi_try_host_reset+0x74/0x180
>   scsi_eh_ready_devs+0xc70/0x1510
>   scsi_error_handler+0x624/0xa20
>=20
> This patch prevents the crash by changing the order of the
> deinitialization in this path of aacraid: first we clear the IRQ,
> then we free other resources. No functional change intended.
>=20
> Signed-off-by: Guilherme G. Piccoli <gpiccoli@linux.vnet.ibm.com>
> ---

Thank you for the fix. Much appreciated.=20

Reviewed-by :Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.co=
m>
