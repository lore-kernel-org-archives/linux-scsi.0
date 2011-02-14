From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [RFC PATCH 1/6] isci: initialization
Date: Sun, 13 Feb 2011 23:49:23 -0800
Message-ID: <AANLkTintM7-AG=tuo8viaiS_twxiuzXdPbcN5jjHj5PX@mail.gmail.com>
References: <20110207003056.27040.89174.stgit@localhost6.localdomain6>
	<201102071558449371072@usish.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48768 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369Ab1BNHtZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Feb 2011 02:49:25 -0500
Received: by fxm20 with SMTP id 20so4846700fxm.19
        for <linux-scsi@vger.kernel.org>; Sun, 13 Feb 2011 23:49:24 -0800 (PST)
In-Reply-To: <201102071558449371072@usish.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jack_wang <jack_wang@usish.com>
Cc: "james.bottomley" <james.bottomley@suse.de>, "dave.jiang" <dave.jiang@intel.com>, linux-scsi <linux-scsi@vger.kernel.org>, "jacek.danecki" <jacek.danecki@intel.com>, "ed.ciechanowski" <ed.ciechanowski@intel.com>, "jeffrey.d.skirvin" <jeffrey.d.skirvin@intel.com>, "edmund.nadolski" <edmund.nadolski@intel.com>

Thanks Jack, comments below:

On Sun, Feb 6, 2011 at 11:58 PM, jack_wang <jack_wang@usish.com> wrote:
>
> +
> + /**
> + =A0* check interrupt_handler's status and call completion_handler i=
f true,
> + =A0* link_up events should be coming from the scu core lib, as phy'=
s come
> + =A0* online. for each link_up from the core, call
> + =A0* get_received_identify_address_frame, copy the frame into the
> + =A0* sas_phy object and call libsas notify_port_event(PORTE_BYTES_D=
MAED).
> + =A0* continue to return zero from thee scan_finished routine until
>
> [Jack] Here "thee" seams typo of "the"

Yes, fixed.

> + /* memset the whole memory area. */
> + memset((char *)uncached_address, 0, size);
> [Jack] cast void * is not needed.

Yes, and neither is the comment.

> + struct sci_physical_memory_descriptor *mde_struct,
> + struct coherent_memory_info *mdl_struct)
> +{
> + unsigned long address =3D 0;
> + dma_addr_t dma_addr =3D 0;
> +
> + address =3D (unsigned long)mdl_struct->vaddr;
> [Jack] Why cast void vadd to usigned long? This may cause problem on =
x64.

No, Linux is LP64.  However this routine does not seem to be aware of
the fact that dma_alloc_coherent always returns at least page
alignment, and also open codes the ALIGN() macro.

> + /* stop the comtroller and wait for completion. =A0*/
> [Jack] controller.

Yes, misspelled and superfluous given the context... deleted.

> +static inline struct isci_pci_info *to_pci_info(struct pci_dev *pdev=
)
> +{
> + return pci_get_drvdata(pdev);
> +}
> +
> [Jack] This wrap is not needed I think.

Ok, fixed up all occurrences of unnecessary line wrapping in host.h.

> +static inline
> +enum isci_status isci_host_get_state(
> + struct isci_host *isci_host)
> +{
> + return isci_host->status;
> +}
> [Jack] This wrap is not needed too.

This helper is not needed.  Will remove.

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
