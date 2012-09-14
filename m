From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: + sections-fix-section-conflicts-in-drivers-scsi.patch added to
 -mm tree
Date: Fri, 14 Sep 2012 09:04:21 +0100
Message-ID: <1347609861.2794.1.camel@dabdike.int.hansenpartnership.com>
References: <20120913233742.7287E100047@wpzn3.hot.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:57736 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756468Ab2INIE2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Sep 2012 04:04:28 -0400
In-Reply-To: <20120913233742.7287E100047@wpzn3.hot.corp.google.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: mm-commits@vger.kernel.org, ak@linux.intel.com, linux-scsi <linux-scsi@vger.kernel.org>

On Thu, 2012-09-13 at 16:37 -0700, akpm@linux-foundation.org wrote:
> The patch titled
>      Subject: sections: fix section conflicts in drivers/scsi
> has been added to the -mm tree.  Its filename is
>      sections-fix-section-conflicts-in-drivers-scsi.patch
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> 
> The -mm tree is included into linux-next and is updated
> there every 3-4 working days
> 
> ------------------------------------------------------
> From: Andi Kleen <ak@linux.intel.com>
> Subject: sections: fix section conflicts in drivers/scsi

NAK this, please.  We're fixing all of this by removing CONFIG_HOTPLUG,
so all __dev annotations become nops and there's little point changing
any.

James

> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  drivers/scsi/aacraid/linit.c        |    2 +-
>  drivers/scsi/aic94xx/aic94xx_init.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff -puN drivers/scsi/aacraid/linit.c~sections-fix-section-conflicts-in-drivers-scsi drivers/scsi/aacraid/linit.c
> --- a/drivers/scsi/aacraid/linit.c~sections-fix-section-conflicts-in-drivers-scsi
> +++ a/drivers/scsi/aacraid/linit.c
> @@ -93,7 +93,7 @@ static DECLARE_PCI_DEVICE_TABLE(aac_pci_
>  #elif defined(__devinitconst)
>  static const struct pci_device_id aac_pci_tbl[] __devinitconst = {
>  #else
> -static const struct pci_device_id aac_pci_tbl[] __devinitdata = {
> +static const struct pci_device_id aac_pci_tbl[] __devinitconst = {
>  #endif
>  	{ 0x1028, 0x0001, 0x1028, 0x0001, 0, 0, 0 }, /* PERC 2/Si (Iguana/PERC2Si) */
>  	{ 0x1028, 0x0002, 0x1028, 0x0002, 0, 0, 1 }, /* PERC 3/Di (Opal/PERC3Di) */
> diff -puN drivers/scsi/aic94xx/aic94xx_init.c~sections-fix-section-conflicts-in-drivers-scsi drivers/scsi/aic94xx/aic94xx_init.c
> --- a/drivers/scsi/aic94xx/aic94xx_init.c~sections-fix-section-conflicts-in-drivers-scsi
> +++ a/drivers/scsi/aic94xx/aic94xx_init.c
> @@ -1012,7 +1012,7 @@ static struct sas_domain_function_templa
>  	.lldd_ata_set_dmamode	= asd_set_dmamode,
>  };
>  
> -static const struct pci_device_id aic94xx_pci_table[] __devinitdata = {
> +static const struct pci_device_id aic94xx_pci_table[] __devinitconst = {
>  	{PCI_DEVICE(PCI_VENDOR_ID_ADAPTEC2, 0x410),0, 0, 1},
>  	{PCI_DEVICE(PCI_VENDOR_ID_ADAPTEC2, 0x412),0, 0, 1},
>  	{PCI_DEVICE(PCI_VENDOR_ID_ADAPTEC2, 0x416),0, 0, 1},
> _
> 
> Patches currently in -mm which might be from ak@linux.intel.com are
> 
> compilerh-add-__visible.patch
> linux-next.patch
> thp-x86-introduce-have_arch_transparent_hugepage.patch
> thp-remove-assumptions-on-pgtable_t-type.patch
> thp-introduce-pmdp_invalidate.patch
> thp-make-madv_hugepage-check-for-mm-def_flags.patch
> thp-s390-thp-splitting-backend-for-s390.patch
> thp-s390-thp-pagetable-pre-allocation-for-s390.patch
> thp-s390-disable-thp-for-kvm-host-on-s390.patch
> thp-s390-architecture-backend-for-thp-on-s390.patch
> sections-disable-const-sections-for-pa-risc-v2.patch
> sections-fix-section-conflicts-in-arch-arm.patch
> sections-fix-section-conflicts-in-arch-frv.patch
> sections-fix-section-conflicts-in-arch-h8300.patch
> sections-fix-section-conflicts-in-arch-ia64.patch
> sections-fix-section-conflicts-in-arch-mips.patch
> sections-fix-section-conflicts-in-arch-powerpc.patch
> sections-fix-section-conflicts-in-arch-score.patch
> sections-fix-section-conflicts-in-arch-sh.patch
> sections-fix-section-conflicts-in-arch-x86.patch
> sections-fix-section-conflicts-in-drivers-atm.patch
> sections-fix-section-conflicts-in-drivers-char.patch
> sections-fix-section-conflicts-in-drivers-cpufreq.patch
> sections-fix-section-conflicts-in-drivers-ide.patch
> sections-fix-section-conflicts-in-drivers-macintosh.patch
> sections-fix-section-conflicts-in-drivers-mfd.patch
> sections-fix-section-conflicts-in-drivers-mmc.patch
> sections-fix-section-conflicts-in-drivers-net.patch
> sections-fix-section-conflicts-in-drivers-net-hamradio.patch
> sections-fix-section-conflicts-in-drivers-net-wan.patch
> sections-fix-section-conflicts-in-drivers-platform-x86.patch
> sections-fix-section-conflicts-in-drivers-scsi.patch
> sections-fix-section-conflicts-in-drivers-video.patch
> sections-fix-section-conflicts-in-mm-percpuc.patch
> sections-fix-section-conflicts-in-net-can.patch
> sections-fix-section-conflicts-in-net.patch
> sections-fix-section-conflicts-in-sound.patch
> sectons-fix-const-sections-for-crc32-table.patch
> compat_ioctl-remove-unused-local-typedef.patch



