From: Lin Ming <ming.m.lin@intel.com>
Subject: Re: [PATCH v5 00/12] SATA ZPODD support
Date: Mon, 18 Jun 2012 14:32:47 +0800
Message-ID: <CAF1ivSa-6xwwASBLsCwv9YS=T1FRvu2+mH4z_=7cXzw=VhKQ1w@mail.gmail.com>
References: <1340000766-129148-1-git-send-email-ming.m.lin@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:43361 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686Ab2FRGdG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jun 2012 02:33:06 -0400
In-Reply-To: <1340000766-129148-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, Aaron Lu <aaron.lu@amd.com>, Holger Macht <holger@homac.de>, Matthew Garrett <mjg@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>, David Woodhouse <David.Woodhouse@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org

(The subject should be: [PATCH v5 00/12] SATA ZPODD support)

On Mon, Jun 18, 2012 at 2:25 PM, Lin Ming <ming.m.lin@intel.com> wrote:
> Hi all,
>
> This is the v5 patches to add SATA ZPODD support, to try it:
> git pull git://git.kernel.org/pub/scm/linux/kernel/git/mlin/linux.git=
 zpodd
>
> Holger and Mathtew,
> Patch 1 to Patch 4 are the libata acpi binding patches from you.
> I removed dock related code from your original version.
> Would you help to review?
>
> v5:
> - rebase to v3.5-rc3
> - fixed crash reported at https://lkml.org/lkml/2012/2/24/2 (Aaron Lu=
)
> - rename is_pci_ata to compat_pci_ata (Alan Cox)
>
> v4:
> https://lkml.org/lkml/2012/5/28/11
> - Includes libata acpi binding patches from Holger Macht and Matthew =
Garrett.
> - tell scsi layer device supports runtime power off
> - check support for device busy class events
>
> v3:
> https://lkml.org/lkml/2012/3/28/20
> - Split the ACPI D3Cold state support patches out
> - Adds "Device Attention" bit check
>
> v2:
> https://lkml.org/lkml/2012/3/1/61
> - _PR3 indicates D3Cold support
> - move can_power_off flag to pm_subsys_data
> - allow all combinations of power resource and device
> - split patches into smaller ones to make review easy
>
> v1:
> https://lkml.org/lkml/2012/2/13/86
>
>
> Aaron Lu (4):
> =A0 =A0 =A0libata: tell scsi layer device supports runtime power off
> =A0 =A0 =A0[SCSI] sr: check support for device busy class events
> =A0 =A0 =A0[SCSI] sr: support zero power ODD
> =A0 =A0 =A0[SCSI] sr: make sure ODD is in resumed state in block ioct=
l
>
> Holger Macht (2):
> =A0 =A0 =A0[SCSI]: add wrapper to access and set scsi_bus_type in str=
uct acpi_bus_type
> =A0 =A0 =A0libata: use correct PCI devices
>
> Lin Ming (4):
> =A0 =A0 =A0libata-acpi: set acpi state for SATA port
> =A0 =A0 =A0libata-acpi: add ata port runtime D3Cold support
> =A0 =A0 =A0libata-acpi: register/unregister device to/from power reso=
urce
> =A0 =A0 =A0libata: detect Device Attention support
>
> Matthew Garrett (2):
> =A0 =A0 =A0libata: bind the Linux device tree to the ACPI device tree
> =A0 =A0 =A0libata: migrate ACPI code over to new bindings
>
>
> =A0drivers/acpi/glue.c =A0 =A0 =A0 =A0| =A0 =A04 +-
> =A0drivers/acpi/power.c =A0 =A0 =A0 | =A0 =A02 +
> =A0drivers/ata/libata-acpi.c =A0| =A0389 ++++++++++++++++++++++++++++=
+++++++++++++++++++++++++++++++++---------------------------
> =A0drivers/ata/libata-core.c =A0| =A0 =A09 ++-
> =A0drivers/ata/libata-pmp.c =A0 | =A0 =A04 -
> =A0drivers/ata/libata-scsi.c =A0| =A0 =A03 +
> =A0drivers/ata/libata.h =A0 =A0 =A0 | =A0 13 +--
> =A0drivers/ata/pata_acpi.c =A0 =A0| =A0 =A04 +-
> =A0drivers/scsi/scsi_lib.c =A0 =A0| =A0 17 ++++
> =A0drivers/scsi/sr.c =A0 =A0 =A0 =A0 =A0| =A0160 ++++++++++++++++++++=
+++++++++++++++-
> =A0drivers/scsi/sr.h =A0 =A0 =A0 =A0 =A0| =A0 =A03 +
> =A0include/linux/ata.h =A0 =A0 =A0 =A0| =A0 =A01 +
> =A0include/linux/cdrom.h =A0 =A0 =A0| =A0 43 ++++++++++
> =A0include/linux/libata.h =A0 =A0 | =A0 =A09 +--
> =A0include/scsi/scsi.h =A0 =A0 =A0 =A0| =A0 10 +++
> =A0include/scsi/scsi_device.h | =A0 =A02 +
> =A016 files changed, 534 insertions(+), 139 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
