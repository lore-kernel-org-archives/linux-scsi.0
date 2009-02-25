From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: [PATCH 1/11] mpt2sas: mpt2sas_base sources
Date: Wed, 25 Feb 2009 13:27:00 -0700
Message-ID: <660360F4F2570145BD872F298951B17A7673CB09@cosmail03.lsi.com>
References: <da824cf30902241600g121d2acfw937020a750a79a57@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og106.obsmtp.com ([64.18.2.165]:34246 "EHLO
	exprod7og106.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893AbZBYU1P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Feb 2009 15:27:15 -0500
In-Reply-To: <da824cf30902241600g121d2acfw937020a750a79a57@mail.gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Grant Grundler <grundler@google.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Tuesday, February 24, 2009 5:00 PM,  Grant Grundler wrote:
> > +static void
> > +_base_display_reply_info(struct MPT2SAS_ADAPTER *ioc, u16=20
> smid, u8 VF_ID,
> > + =A0 =A0u32 reply)
> > +{
> > + =A0 =A0 =A0 MPI2DefaultReply_t *mpi_reply;
> > + =A0 =A0 =A0 u16 ioc_status;
> > +
> > + =A0 =A0 =A0 mpi_reply =3D =A0base_get_reply_virt_addr(ioc, reply)=
;
> > + =A0 =A0 =A0 ioc_status =3D le16_to_cpu(mpi_reply->IOCStatus);
> > +#ifdef CONFIG_SCSI_MPT2SAS_LOGGING
> > + =A0 =A0 =A0 if ((ioc_status & MPI2_IOCSTATUS_MASK) &&
> > + =A0 =A0 =A0 =A0 =A0 (ioc->logging_level & MPT_DEBUG_REPLY)) {
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 _base_sas_ioc_info(ioc , mpi_reply,
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 base_get_msg_frame(ioc, smid)=
);
> > + =A0 =A0 =A0 }
> > +#endif
>=20
> Can all the "if (ioc_status...)" gunk get wrapped into a macro that i=
s
> conditionally defined?
> e.g. the logging level could become a compile time option instead of =
a
> runtime option.
>=20
> I was able to cut 1% CPU utilization from another driver by allowing
> the compiler to get
> rid of all the debug messages that would never get printed because
> they were below
> a particular threshold.
>=20
> Maybe it doesn't matter in this case. But I've no clue yet how
> often/when _base_display_reply_info()
> is called.


I have already implemented macros for all the debug prints in the drive=
r. In addition, these debug prints are designed to be compile time opti=
ons, as you have suggested. There are logging levels to designate diffe=
rent type of debug that one would be interested in. There is an option =
in the Kconfig via CONFIG_SCSI_MPT2SAS_LOGGING for this.  Please refer =
to mpt2sas_debug.h and Kconfig.

Also, this particular function needs to be called all the time becuase =
at the end of it we are printing out the loginfos returned by controlle=
r firmware.  The loginfos are needed as a way to be informed when  prob=
lems resonating below the driver in controller firmware.


> > +static void
> > +_base_mask_interrupts(struct MPT2SAS_ADAPTER *ioc)
> > +{
> > + =A0 =A0 =A0 u32 him_register;
> > +
> > + =A0 =A0 =A0 ioc->mask_interrupts =3D 1;
> > + =A0 =A0 =A0 him_register =3D readl(&ioc->chip->HostInterruptMask)=
;
> > + =A0 =A0 =A0 him_register |=3D MPI2_HIM_DIM + MPI2_HIM_RIM +=20
> MPI2_HIM_RESET_IRQ_MASK;
> > + =A0 =A0 =A0 writel(him_register, &ioc->chip->HostInterruptMask);
>=20
> This is a posted write. Does it need to be flushed?
> ie do other parts of the driver require this take effect immediately
> or will they tolerate some late arriving interrupt?


What are you suggesting?   Calling wmb()?

I thought I was handling this case.   I'm setting the flag "ioc->mask_i=
nterrupts".  If there are any spurious interrupts that occur following =
this calling this function, I will ignore them from the interrupt routi=
ne -> base_interrupt() where I have this sanity check.


> > + =A0 =A0 =A0 completed_cmds =3D 0;
> > + =A0 =A0 =A0 do {
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ioc->reply_post_free[post_index].=
Words =3D=3D
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 0xFFFFFFFFFFFFFFFFULL)
>=20
> Would this be better written as "~0ULL" or as a predefined constant?
>=20

I guess your right, that would be better becuase its shorter. =20

> > + =A0 =A0 =A0 /* reply post descriptor handling */
> > + =A0 =A0 =A0 post_index_next =3D ioc->reply_post_host_index;
> > + =A0 =A0 =A0 for (i =3D 0 ; i < completed_cmds; i++) {
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 post_index =3D post_index_next;
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* poison the reply post descriptor *=
/
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ioc->reply_post_free[post_index_next]=
=2EWords =3D
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 0xFFFFFFFFFFFFFFFFULL;
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 post_index_next =3D (post_index =3D=3D
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (ioc->reply_post_queue_depth =
- 1))
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ? 0 : post_index + 1;
> > + =A0 =A0 =A0 }
> > + =A0 =A0 =A0 ioc->reply_post_host_index =3D post_index_next;
> > + =A0 =A0 =A0 writel(post_index_next, &ioc->chip->ReplyPostHostInde=
x);
> > + =A0 =A0 =A0 wmb();
>=20
> What is the wmb() protecting here? Add a comment?
>=20
> My impression is the wmb() belongs in front of the writel()=20
> and not behind it.
> That is, we want to make sure the updates to ioc->reply_post_free[]
> are visible before sending out the writel().
>=20

I'm doing is a 64bit write to pcie memory. On some systems this is brok=
en out to two 32bit writes.  So I put the barrier there to insure the e=
ntire 64bits was written out to the ReplyPostHostIndex register before =
another write was done.  =20


> > +static int
> > +_base_config_dma_addressing(struct MPT2SAS_ADAPTER *ioc,=20
> struct pci_dev *pdev)
> > +{
> > + =A0 =A0 =A0 struct sysinfo s;
> > + =A0 =A0 =A0 char *desc =3D NULL;
> > +
> > + =A0 =A0 =A0 if (sizeof(dma_addr_t) > 4) {
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 const uint64_t required_mask =3D
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dma_get_required_mask(&pdev->=
dev);
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((required_mask > DMA_32BIT_MASK) =
&&=20
> !pci_set_dma_mask(pdev,
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 DMA_64BIT_MASK) &&=20
> !pci_set_consistent_dma_mask(pdev,
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 DMA_64BIT_MASK)) {
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ioc->base_add_sg_sing=
le =3D=20
> &base_add_sg_single_64;
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ioc->sge_size =3D siz=
eof(Mpi2SGESimple64_t);
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 desc =3D "64";
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> > + =A0 =A0 =A0 }
> > +
> > + =A0 =A0 =A0 if (!pci_set_dma_mask(pdev, DMA_32BIT_MASK)
> > + =A0 =A0 =A0 =A0 =A0 && !pci_set_consistent_dma_mask(pdev, DMA_32B=
IT_MASK)) {
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ioc->base_add_sg_single =3D &base_add=
_sg_single_32;
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ioc->sge_size =3D sizeof(Mpi2SGESimpl=
e32_t);
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 desc =3D "32";
> > + =A0 =A0 =A0 } else
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENODEV;
> > +
> > + out:
> > + =A0 =A0 =A0 si_meminfo(&s);
> > + =A0 =A0 =A0 printk(MPT2SAS_INFO_FMT "%s BIT PCI BUS DMA=20
> ADDRESSING SUPPORTED, "
> > + =A0 =A0 =A0 =A0 =A0 "total mem (%ld kB)\n", ioc->name, desc,=20
> convert_to_kb(s.totalram));
> > +
> > + =A0 =A0 =A0 return 0;
> > +}
>=20
>=20
> Interesting. I would have expected the dma_mask and=20
> consistent_dma_mask
> to not depend on each other. ie set dma_mask to 64, if that fails, se=
t
> dma_mask to 32-bit.
> Rinse and repeat for consistent_dma_mask.


I'm not clear what your point is.   My algorithm is to find out if the =
system has addressable memory above 32bit boundary, then set that mask =
for 64bit, else go for 32bit addressing.

> > +/**
> > + * base_check_enable_msix - checks MSIX capabable.
> > + * @ioc: per adapter object
> > + *
> > + * Check to see if card is capable of MSIX, and set number
> > + * of avaliable msix vectors
> > + */
> > +static int
> > +base_check_enable_msix(struct MPT2SAS_ADAPTER *ioc)
> > +{
> > + =A0 =A0 =A0 int base;
> > + =A0 =A0 =A0 u16 message_control;
> > + =A0 =A0 =A0 u32 msix_table_offset;
> > +
> > + =A0 =A0 =A0 base =3D pci_find_capability(ioc->pdev, PCI_CAP_ID_MS=
IX);
> > + =A0 =A0 =A0 if (!base) {
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dfailprintk(ioc, printk(MPT2SAS_INFO_=
=46MT "msix not "
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "supported\n", ioc->name));
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
> > + =A0 =A0 =A0 }
> > +
> > + =A0 =A0 =A0 /* get msix vector count */
> > + =A0 =A0 =A0 pci_read_config_word(ioc->pdev, base + 2, &message_co=
ntrol);
> > + =A0 =A0 =A0 ioc->msix_vector_count =3D (message_control & 0x3FF) =
+ 1;
>=20
>=20
> Any comments on why the return value from pci_enable_msix()=20
> isn't used here?

I'm calling pci_enable_msix() from base_enable_msix(), and from that fu=
nction I'm checking the return value.   I'm not clear what your point i=
s.

>=20
> I wasn't expecting the drivers would need to read the MSIX=20
> table directly.

There is a bug in the hardware, where the msix table is cleared out dur=
ing host reset.  So the architechs here at LSI decided to address this =
errata by having all the device driver writters back and restore this t=
able during host reset.  I made reference to this errata from the comme=
nts in base_save_msix_table().

> > +
> > + =A0 =A0 =A0 /* current HW implemention uses only one interrupt=20
> handler */
>=20
> Which implementation?
> This comment sounds like it expects to be obsolete soon.
> Specifying the implementation makes it clear even when other
> implementations become available.
>=20

The explanation is currently we only map the first MSIX vector for all =
interrupts   In future products we may have more expand to use more vec=
tors, however that has not been decided upon yet. What I mean by more v=
ectors is we might map the 1st vector for initiator mode, and the 2nd f=
or target mode, or maybe in virtualization, each VF port is assigned it=
s own handler.


>=20
> > + =A0 =A0 =A0 r =3D request_irq(entries[0].vector, base_interrupt,=20
> IRQF_SHARED,
> > + =A0 =A0 =A0 =A0 =A0 ioc->name, ioc);
>=20
> MSI is never shared. IRQF_SHARED flag is still correct?
>=20
> I have to stop looking now...back to work. :(
>=20

There are two drivers that currently implement MSIX in the scsi tree.  =
I found the emulex driver doing IRQF_SHARED, and qlogic is zero.    Sin=
ce we suport shared interrupts, I set it up for that.  I didn't know if=
 it mattered, does it?

     --
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
