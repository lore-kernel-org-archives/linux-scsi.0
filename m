From: Sumit Saxena <sumit.saxena@broadcom.com>
Subject: RE: [PATCH] megaraid_sas: Fix the search of first memory bar
Date: Fri, 26 Aug 2016 09:31:19 +0530
Message-ID: <c0561d5e1fa756c46d2eafa2c0b8dc09@mail.gmail.com>
References: <1471768105-14730-1-git-send-email-christophe.jaillet@wanadoo.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <1471768105-14730-1-git-send-email-christophe.jaillet@wanadoo.fr>
Sender: kernel-janitors-owner@vger.kernel.org
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com, uday.lingala@avagotech.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: megaraidlinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>-----Original Message-----
>From: Christophe JAILLET [mailto:christophe.jaillet@wanadoo.fr]
>Sent: Sunday, August 21, 2016 1:58 PM
>To: kashyap.desai@avagotech.com; sumit.saxena@avagotech.com;
>uday.lingala@avagotech.com; jejb@linux.vnet.ibm.com;
>martin.petersen@oracle.com
>Cc: megaraidlinux.pdl@avagotech.com; linux-scsi@vger.kernel.org; linux-
>kernel@vger.kernel.org; kernel-janitors@vger.kernel.org; Christophe JAILLE=
T
>Subject: [PATCH] megaraid_sas: Fix the search of first memory bar
>
>The 2nd parameter of 'find_first_bit' is the number of bits to search.
>In this case, we are passing 'sizeof(unsigned long)' which is likely to be
>4.
>
>It is likely that the number of bits in a long was expected here, so use
>BITS_PER_LONG instead.
>
>Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>---
>Other options are possible:
>  - 'bar_list' being a 'unsigned long', use __ffs to reduce code verbosity
>  - PCI_NUM_RESOURCES, which is the maximum number of bits that can be set
>    by 'pci_select_bars()'
>---
> drivers/scsi/megaraid/megaraid_sas_base.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
>b/drivers/scsi/megaraid/megaraid_sas_base.c
>index c1ed25adb17e..7d3de811d33c 100644
>--- a/drivers/scsi/megaraid/megaraid_sas_base.c
>+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
>@@ -5036,7 +5036,7 @@ static int megasas_init_fw(struct megasas_instance
>*instance)
>
> 	/* Find first memory bar */
> 	bar_list =3D pci_select_bars(instance->pdev, IORESOURCE_MEM);
>-	instance->bar =3D find_first_bit(&bar_list, sizeof(unsigned long));
>+	instance->bar =3D find_first_bit(&bar_list, BITS_PER_LONG);
> 	if (pci_request_selected_regions(instance->pdev, 1<<instance->bar,
> 					 "megasas: LSI")) {
> 		dev_printk(KERN_DEBUG, &instance->pdev->dev, "IO memory
>region busy!\n");

Acked by: Sumit Saxena <sumit.saxena@broadcom.com>

>--
>2.7.4
>
>
>---
>L'absence de virus dans ce courrier =C3=A9lectronique a =C3=A9t=C3=A9 v=C3=
=A9rifi=C3=A9e par le
>logiciel
>antivirus Avast.
>https://www.avast.com/antivirus
