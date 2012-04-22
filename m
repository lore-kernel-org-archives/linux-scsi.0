From: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [PATCH 14/17] hpsa: use new IS_ENABLED macro
Date: Sun, 22 Apr 2012 14:12:40 -0400
Message-ID: <CAP=VYLpOyBuvZ3+Nfw1u0dojOX8kt-1TDJA+v-EWQuKPdh0A1w@mail.gmail.com>
References: <20120420150349.10596.73732.stgit@beardog.cce.hp.com> <20120420150732.10596.9085.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:56690 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782Ab2DVSNM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Apr 2012 14:13:12 -0400
In-Reply-To: <20120420150732.10596.9085.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, matthew.gates@hp.com, stephenmcameron@gmail.com, thenzl@redhat.com, akpm@linux-foundation.org, mikem@beardog.cce.hp.com

On Fri, Apr 20, 2012 at 11:07 AM, Stephen M. Cameron
<scameron@beardog.cce.hp.com> wrote:
> From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
>
> Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>

You've not written a commit log, so I'm left guessing what the
intended rationale is here.  COMPAT, X86 and PCI_MSI are
I believe all bool, so why make this change?  To me it gives
a misleading message that some level of modular awareness
is needed here, when there really isn't any such need.

Thanks,
Paul.
---

> ---
> =A0drivers/scsi/hpsa.c | =A0 12 ++++++------
> =A01 files changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index 2e01583..67a0ad0 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -139,7 +139,7 @@ static irqreturn_t do_hpsa_intr_msi(int irq, void=
 *dev_id);
> =A0static int hpsa_ioctl(struct scsi_device *dev, int cmd, void *arg)=
;
> =A0static void start_io(struct ctlr_info *h);
>
> -#ifdef CONFIG_COMPAT
> +#if IS_ENABLED(COMPAT)
> =A0static int hpsa_compat_ioctl(struct scsi_device *dev, int cmd, voi=
d *arg);
> =A0#endif
>
> @@ -513,7 +513,7 @@ static struct scsi_host_template hpsa_driver_temp=
late =3D {
> =A0 =A0 =A0 =A0.ioctl =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=3D hpsa_ioc=
tl,
> =A0 =A0 =A0 =A0.slave_alloc =A0 =A0 =A0 =A0 =A0 =A0=3D hpsa_slave_all=
oc,
> =A0 =A0 =A0 =A0.slave_destroy =A0 =A0 =A0 =A0 =A0=3D hpsa_slave_destr=
oy,
> -#ifdef CONFIG_COMPAT
> +#if IS_ENABLED(COMPAT)
> =A0 =A0 =A0 =A0.compat_ioctl =A0 =A0 =A0 =A0 =A0 =3D hpsa_compat_ioct=
l,
> =A0#endif
> =A0 =A0 =A0 =A0.sdev_attrs =3D hpsa_sdev_attrs,
> @@ -2721,7 +2721,7 @@ static void cmd_special_free(struct ctlr_info *=
h, struct CommandList *c)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0c, (dma_addr_t=
) (c->busaddr & DIRECT_LOOKUP_MASK));
> =A0}
>
> -#ifdef CONFIG_COMPAT
> +#if IS_ENABLED(COMPAT)
>
> =A0static int hpsa_ioctl32_passthru(struct scsi_device *dev, int cmd,=
 void *arg)
> =A0{
> @@ -3972,7 +3972,7 @@ static int find_PCI_BAR_index(struct pci_dev *p=
dev, unsigned long pci_bar_addr)
>
> =A0static void __devinit hpsa_interrupt_mode(struct ctlr_info *h)
> =A0{
> -#ifdef CONFIG_PCI_MSI
> +#if IS_ENABLED(PCI_MSI)
> =A0 =A0 =A0 =A0int err, i;
> =A0 =A0 =A0 =A0struct msix_entry hpsa_msix_entries[MAX_REPLY_QUEUES];
>
> @@ -4013,7 +4013,7 @@ static void __devinit hpsa_interrupt_mode(struc=
t ctlr_info *h)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0dev_warn(&h->pdev->dev=
, "MSI init failed\n");
> =A0 =A0 =A0 =A0}
> =A0default_int_mode:
> -#endif =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* CONFIG_PCI=
_MSI */
> +#endif /* PCI_MSI enabled */
> =A0 =A0 =A0 =A0/* if we get here we're going to use the default inter=
rupt mode */
> =A0 =A0 =A0 =A0h->intr[h->intr_mode] =3D h->pdev->irq;
> =A0}
> @@ -4187,7 +4187,7 @@ static inline bool hpsa_CISS_signature_present(=
struct ctlr_info *h)
> =A0/* Need to enable prefetch in the SCSI core for 6400 in x86 */
> =A0static inline void hpsa_enable_scsi_prefetch(struct ctlr_info *h)
> =A0{
> -#ifdef CONFIG_X86
> +#if IS_ENABLED(X86)
> =A0 =A0 =A0 =A0u32 prefetch;
>
> =A0 =A0 =A0 =A0prefetch =3D readl(&(h->cfgtable->SCSI_Prefetch));
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kerne=
l" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at =A0http://www.tux.org/lkml/
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
