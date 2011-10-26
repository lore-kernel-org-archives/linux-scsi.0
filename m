From: Arnaud Lacombe <lacombar@gmail.com>
Subject: Re: [PATCH] mv_sas: OCZ RevoDrive3 & zDrive R4 support
Date: Wed, 26 Oct 2011 18:08:34 -0400
Message-ID: <CACqU3MVkm25gzfFns3HqFj8bkshGefyEaMDw=QtaqJ+HsR9F3Q@mail.gmail.com>
References: <1318032026-21913-1-git-send-email-robbat2@gentoo.org>
	<1318132024-12426-1-git-send-email-robbat2@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1318132024-12426-1-git-send-email-robbat2@gentoo.org>
Sender: linux-ide-owner@vger.kernel.org
To: "Robin H. Johnson" <robbat2@gentoo.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi,

On Sat, Oct 8, 2011 at 11:47 PM, Robin H. Johnson <robbat2@gentoo.org> =
wrote:
> From: "Robin H. Johnson" <robbat2@gentoo.org>
>
> In the OCZ RevoDrive3/zDrive R4 series, the "OCZ SuperScale Storage
> Controller" with "Virtualized Controller Architecture 2.0" really see=
ms
> to be a Marvell 88SE9485 part, with OCZ firmware/BIOS.
>
> Developed and tested on OCZ RevoDrive3 120GB [PCI 1b85:1021]
>
> Should work on:
> - OCZ RevoDrive3 (2x SandForce 2281)
> - OCZ RevoDrive3 X2 (4x SandForce 2281)
> - OCZ zDrive R4 CM84 (4x SandForce 2281)
> - OCZ zDrive R4 CM88 (8x SandForce 2281)
> - OCZ zDrive R4 RM84 (4x SandForce 2582)
> - OCZ zDrive R4 RM88 (8x SandForce 2582)
>
> All of this because a friend recently bought a OCZ RevoDrive3 and was
> bitten by the lack of Linux support.
>
> Notes from testing:
> -------------------
> - SMART works.
> - VPD Device Identification is "OCZ-REVODRIVE3"
> - Thin provisioning/TRIM seems to be implemented as WRITE SAME UNMAP,
> =A0with deterministic (non-zero) read after TRIM, but I'm not sure if=
 it
> =A0works 100% in my testing.
> - Some of the tuning in the firmware seems to ensure much better
> =A0performance when in a RAID0 setup than using the two devices
> =A0seperately.
>
> I have not tested booting from the SSD, because all of this was
> developed and tested remotely from the actual hardware.
>
> Signed-off-by: Robin H. Johnson <robbat2@gentoo.org>
> Thanks-To: Gordon Pritchard <gordp@sfu.ca>
> ---
> =A0drivers/scsi/mvsas/mv_init.c | =A0 10 ++++++++++
> =A0include/linux/pci_ids.h =A0 =A0 =A0| =A0 =A02 ++
> =A02 files changed, 12 insertions(+), 0 deletions(-)
>
> =A0Tested and cleaned up now :-). Please apply.
>
> diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_ini=
t.c
> index 4e9af66..b88315a 100644
> --- a/drivers/scsi/mvsas/mv_init.c
> +++ b/drivers/scsi/mvsas/mv_init.c
> @@ -723,6 +723,16 @@ static struct pci_device_id __devinitdata mvs_pc=
i_table[] =3D {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0.class_mask =A0 =A0 =3D 0,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0.driver_data =A0 =A0=3D chip_9485,
> =A0 =A0 =A0 =A0},
> + =A0 =A0 =A0 { PCI_VDEVICE(OCZ, 0x1021), chip_9485}, /* OCZ RevoDriv=
e3 */
> + =A0 =A0 =A0 { PCI_VDEVICE(OCZ, 0x1022), chip_9485}, /* OCZ RevoDriv=
e3/zDriveR4 (exact model unknown) */
> + =A0 =A0 =A0 { PCI_VDEVICE(OCZ, 0x1040), chip_9485}, /* OCZ RevoDriv=
e3/zDriveR4 (exact model unknown) */
> + =A0 =A0 =A0 { PCI_VDEVICE(OCZ, 0x1041), chip_9485}, /* OCZ RevoDriv=
e3/zDriveR4 (exact model unknown) */
> + =A0 =A0 =A0 { PCI_VDEVICE(OCZ, 0x1042), chip_9485}, /* OCZ RevoDriv=
e3/zDriveR4 (exact model unknown) */
> + =A0 =A0 =A0 { PCI_VDEVICE(OCZ, 0x1043), chip_9485}, /* OCZ RevoDriv=
e3/zDriveR4 (exact model unknown) */
> + =A0 =A0 =A0 { PCI_VDEVICE(OCZ, 0x1044), chip_9485}, /* OCZ RevoDriv=
e3/zDriveR4 (exact model unknown) */
> + =A0 =A0 =A0 { PCI_VDEVICE(OCZ, 0x1080), chip_9485}, /* OCZ RevoDriv=
e3/zDriveR4 (exact model unknown) */
> + =A0 =A0 =A0 { PCI_VDEVICE(OCZ, 0x1083), chip_9485}, /* OCZ RevoDriv=
e3/zDriveR4 (exact model unknown) */
> + =A0 =A0 =A0 { PCI_VDEVICE(OCZ, 0x1084), chip_9485}, /* OCZ RevoDriv=
e3/zDriveR4 (exact model unknown) */
>
> =A0 =A0 =A0 =A0{ } =A0 =A0 /* terminate list */
> =A0};
> diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
> index ae96bbe..3fe46e9 100644
> --- a/include/linux/pci_ids.h
> +++ b/include/linux/pci_ids.h
> @@ -2868,3 +2868,5 @@
>
> =A0#define PCI_VENDOR_ID_XEN =A0 =A0 =A0 =A0 =A0 =A0 =A00x5853
> =A0#define PCI_DEVICE_ID_XEN_PLATFORM =A0 =A0 0x0001
> +
> +#define PCI_VENDOR_ID_OCZ =A0 =A0 =A0 =A0 =A0 =A0 =A00x1b85
> --
> 1.7.7
>
Out of curiosity, do you know if the current mvsas driver would
support Marvell 88nv9143 family of chip ?

Thanks,
 - Arnaud

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kerne=
l" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at =A0http://www.tux.org/lkml/
>
