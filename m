From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 2/9] [SCSI] aacraid: Add Power Management support
Date: Mon, 01 Jun 2015 14:38:55 -0700
Message-ID: <1433194735.2174.43.camel@HansenPartnership.com>
References: <1431562378-8514-1-git-send-email-rajinikanth.pandurangan@pmcs.com>
	 <1431562378-8514-3-git-send-email-rajinikanth.pandurangan@pmcs.com>
	 <1433171695.2174.4.camel@HansenPartnership.com>
	 <E34C6B6293F0214497D0C55B92526C05B697BE88@BBYEXM01.pmc-sierra.internal>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:48891 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751874AbbFAVi5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Jun 2015 17:38:57 -0400
In-Reply-To: <E34C6B6293F0214497D0C55B92526C05B697BE88@BBYEXM01.pmc-sierra.internal>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rajinikanth Pandurangan <Rajinikanth.Pandurangan@pmcs.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "aacraid@pmc-sierra.com" <aacraid@pmc-sierra.com>, Harry Yang <Harry.Yang@pmcs.com>, Rich Bono <Rich.Bono@pmcs.com>, Achim Leubner <Achim.Leubner@pmcs.com>, Murthy Bhat <Murthy.Bhat@pmcs.com>

On Mon, 2015-06-01 at 21:16 +0000, Rajinikanth Pandurangan wrote:
> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com]=20
> Sent: Monday, June 01, 2015 8:15 AM
> To: Rajinikanth Pandurangan
> Cc: linux-scsi@vger.kernel.org; aacraid@pmc-sierra.com; Harry Yang; R=
ich Bono; Achim Leubner; Murthy Bhat
> Subject: Re: [PATCH 2/9] [SCSI] aacraid: Add Power Management support
>=20
> On Wed, 2015-05-13 at 17:12 -0700, rajinikanth.pandurangan@pmcs.com
> wrote:
> > diff --git a/drivers/scsi/aacraid/linit.c=20
> > b/drivers/scsi/aacraid/linit.c index 9eec027..be30e43 100644
> > --- a/drivers/scsi/aacraid/linit.c
> > +++ b/drivers/scsi/aacraid/linit.c
> > @@ -1317,6 +1317,149 @@ static int aac_probe_one(struct pci_dev *pd=
ev, const struct pci_device_id *id)
> >  	return error;
> >  }
> > =20
> > +#if (defined(CONFIG_PM))
> > +void aac_release_resources(struct aac_dev *aac) {
> > +	int i;
> > +
> > +	aac_adapter_disable_int(aac);
> > +	if (aac->pdev->device =3D=3D PMC_DEVICE_S6 ||
> > +	    aac->pdev->device =3D=3D PMC_DEVICE_S7 ||
> > +	    aac->pdev->device =3D=3D PMC_DEVICE_S8 ||
> > +	    aac->pdev->device =3D=3D PMC_DEVICE_S9) {
> > +		if (aac->max_msix > 1) {
> > +			for (i =3D 0; i < aac->max_msix; i++)
> > +				free_irq(aac->msixentry[i].vector,
> > +					&(aac->aac_msix[i]));
> > +		} else {
> > +			free_irq(aac->pdev->irq, &(aac->aac_msix[0]));
> > +		}
> > +	} else {
> > +		free_irq(aac->pdev->irq, aac);
> > +	}
> > +	if (aac->msi)
> > +		pci_disable_msi(aac->pdev);
> > +	else if (aac->max_msix > 1)
> > +		pci_disable_msix(aac->pdev);
> > +
> > +}
> > +
> > +static int aac_acquire_resources(struct aac_dev *dev) {
> > +	int i, j;
> > +	int instance =3D dev->id;
> > +	const char *name =3D dev->name;
> > +	unsigned long status;
> > +	/*
> > +	 *	First clear out all interrupts.  Then enable the one's that we
> > +	 *	can handle.
> > +	 */
> > +	while (!((status =3D src_readl(dev, MUnit.OMR)) & KERNEL_UP_AND_R=
UNNING)
> > +		|| status =3D=3D 0xffffffff)
> > +			msleep(1);
>=20
> checkpatch would warn you not to do this.  Use msleep(20) to keep it =
quiet.
>=20
> [RajP] Yes, will change and make it part of next patchset.
>=20
> > +
> > +	aac_adapter_disable_int(dev);
> > +	aac_adapter_enable_int(dev);
> > +
> > +
> > +	if ((dev->pdev->device =3D=3D PMC_DEVICE_S7 ||
> > +	     dev->pdev->device =3D=3D PMC_DEVICE_S8 ||
> > +	     dev->pdev->device =3D=3D PMC_DEVICE_S9))
> > +		aac_define_int_mode(dev);
> > +
> > +	if (dev->msi_enabled)
> > +		aac_src_access_devreg(dev, AAC_ENABLE_MSIX);
> > +
> > +	if (!dev->sync_mode && dev->msi_enabled && dev->max_msix > 1) {
> > +		for (i =3D 0; i < dev->max_msix; i++) {
> > +			dev->aac_msix[i].vector_no =3D i;
> > +			dev->aac_msix[i].dev =3D dev;
> > +
> > +			if (request_irq(dev->msixentry[i].vector,
> > +					dev->a_ops.adapter_intr,
> > +					0, "aacraid", &(dev->aac_msix[i]))) {
> > +				printk(KERN_ERR "%s%d: Failed to register IRQ for vector %d.\n=
",
> > +						name, instance, i);
> > +				for (j =3D 0 ; j < i ; j++)
> > +					free_irq(dev->msixentry[j].vector,
> > +						 &(dev->aac_msix[j]));
> > +				pci_disable_msix(dev->pdev);
> > +				goto error_iounmap;
> > +			}
> > +		}
> > +	} else {
> > +		dev->aac_msix[0].vector_no =3D 0;
> > +		dev->aac_msix[0].dev =3D dev;
> > +
> > +		if (request_irq(dev->pdev->irq, dev->a_ops.adapter_intr,
> > +			IRQF_SHARED|IRQF_DISABLED, "aacraid",
> > +			&(dev->aac_msix[0])) < 0) {
>=20
> And this won't compile:
>=20
> drivers/scsi/aacraid/linit.c: In function =E2=80=98aac_acquire_resour=
ces=E2=80=99:
> drivers/scsi/aacraid/linit.c:1395:16: error: =E2=80=98IRQF_DISABLED=E2=
=80=99 undeclared (first use in this function)
>     IRQF_SHARED|IRQF_DISABLED, "aacraid",
>=20
> Please run checkpatch and compile against the kernel you're submittin=
g
> for.  The reason for this failure is that IRQF_DISABLED got eliminate=
d
> from the kernel somewhere in the 3.x series.
>=20
> [RajP] Yes, I had compiled against the kernel 4.0.0-rc2+ and did not
> get any compile error.  In fact, checkpatch didn't warn either.  Am I
> missing something?

Yes, this:

commit d8bf368d0631d4bc2612d8bf2e4e8e74e620d0cc
Author: Valentin Rothberg <valentinrothberg@gmail.com>
Date:   Thu Mar 5 15:23:08 2015 +0100

    genirq: Remove the deprecated 'IRQF_DISABLED' request_irq() flag
entirely

It went in in the merge window for 4.1.  However, IRQF_DISABLED has bee=
n
deprecated for long enough that you shouldn't have been using it anyway=
=2E

James


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
