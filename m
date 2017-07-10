From: Don Brace <don.brace@microsemi.com>
Subject: RE: device support in hpsa, was: Re: OOPS from cciss_ioctl in
 4.12+git
Date: Mon, 10 Jul 2017 21:56:44 +0000
Message-ID: <4993A297653ECB4581FA5C3C31323D19533CE302@avsrvexchmbx2.microsemi.net>
References: <alpine.LRH.2.20.1707051555130.20086@math.ut.ee>
 <20170705225134.GA31786@infradead.org>
 <alpine.LRH.2.20.1707061236010.6514@math.ut.ee>
 <20170707150042.GA15445@infradead.org>
 <799cf0d6-658d-4124-1ba0-3962671e3f1e@kernel.dk>
 <1bc9895b-bfcb-9ff5-c046-277b0d67a94e@redhat.com>
 <20170707180857.GA19790@infradead.org>
 <alpine.LRH.2.20.1707101523470.5280@math.ut.ee>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.20.1707101523470.5280@math.ut.ee>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Meelis Roos <mroos@linux.ee>, Christoph Hellwig <hch@infradead.org>
Cc: Laurence Oberman <loberman@redhat.com>, Jens Axboe <axboe@kernel.dk>, Linux Kernel list <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Scott Benesh <scott.benesh@microsemi.com>, Scott Teel <scott.teel@microsemi.com>, Kevin Barnett <kevin.barnett@microsemi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

So, adding adding  hpsa_allow_any=3D1 did not work...

When you added the 0x40800e11, did you add it to both tables?

/* define the PCI info for the cards we can control */
static const struct pci_device_id hpsa_pci_device_id[] =3D {
       {PCI_VENDOR_ID_COMPAQ, PCI_DEVICE_ID_COMPAQ_CISSB, 0x0E11, 0x4080},
...
{0,}
};

/*  board_id =3D Subsystem Device ID & Vendor ID
 *  product =3D Marketing Name for the board
 *  access =3D Address of the struct of function pointers
 */
static struct board_type products[] =3D {
{0x40800E11, "Smart Array 5i", &SA5B_access},


...
};

I added it at the very first entry to make it easier.


---
However, there is not a SA5B_access table in hpsa.h.

/*
 *  This card is the opposite of the other cards.
 *   0 turns interrupts on...
 *   0x04 turns them off...
 */
static void SA5B_intr_mask(ctlr_info_t *h, unsigned long val)
{
        if (val)
        { /* Turn interrupts on */
                h->interrupts_enabled =3D 1;
                writel(0, h->vaddr + SA5_REPLY_INTR_MASK_OFFSET);
                (void) readl(h->vaddr + SA5_REPLY_INTR_MASK_OFFSET);
        } else /* Turn them off */
        {
                h->interrupts_enabled =3D 0;
                writel( SA5B_INTR_OFF,
                        h->vaddr + SA5_REPLY_INTR_MASK_OFFSET);
                (void) readl(h->vaddr + SA5_REPLY_INTR_MASK_OFFSET);
        }
}


/*
 *      Returns true if an interrupt is pending..
 */
static bool SA5B_intr_pending(ctlr_info_t *h)
{
        unsigned long register_value  =3D
                readl(h->vaddr + SA5_INTR_STATUS);
#ifdef CCISS_DEBUG
        printk("cciss: intr_pending %lx\n", register_value);
#endif  /* CCISS_DEBUG */
        if( register_value &  SA5B_INTR_PENDING)
                return  1;
        return 0 ;
}


static struct access_method SA5B_access =3D {
        .submit_command =3D SA5_submit_command,
        .set_intr_mask =3D SA5B_intr_mask,
        .fifo_full =3D SA5_fifo_full,
        .intr_pending =3D SA5B_intr_pending,
        .command_completed =3D SA5_completed,
};



Can you try adding the two table entries and the SA5B definitions in hpsa.h=
?



> -----Original Message-----
> From: mroos@math.ut.ee [mailto:mroos@math.ut.ee] On Behalf Of Meelis
> Roos
> Sent: Monday, July 10, 2017 9:08 AM
> To: Christoph Hellwig <hch@infradead.org>
> Cc: Laurence Oberman <loberman@redhat.com>; Jens Axboe
> <axboe@kernel.dk>; Linux Kernel list <linux-kernel@vger.kernel.org>; linu=
x-
> block@vger.kernel.org; Don Brace <don.brace@microsemi.com>; Scott
> Benesh <scott.benesh@microsemi.com>; Scott Teel
> <scott.teel@microsemi.com>; Kevin Barnett
> <kevin.barnett@microsemi.com>; linux-scsi@vger.kernel.org; Hannes
> Reinecke <hare@suse.de>
> Subject: Re: device support in hpsa, was: Re: OOPS from cciss_ioctl in 4.=
12+git
>=20
> EXTERNAL EMAIL
>=20
>=20
> > On Fri, Jul 07, 2017 at 11:42:38AM -0400, Laurence Oberman wrote:
> > > What happens when  hpsa_allow_any=3D1 with the Smart Array 64xx
> > > It should probe.
> >
> > But only if it has a HP vendor ID as far as I can tell.  We'd
> > still need to add the compaq ids so that these controllers get
> > probed.  But maybe it's time to add them and flip the hpsa_allow_any
> > default (maybe conditionally on a config option?) and mark cciss
> > deprecated.
>=20
> I added hpsa_allow_any=3D1, did not help.
>=20
> Added a wildcard Compaq entry with RAID class, like the one for HP,
> still no go:
>=20
> [    5.199125] hpsa 0000:00:04.0: unrecognized board ID: 0x40800e11, igno=
ring.
> [    5.282517] hpsa 0000:00:04.0: Board ID not found
>=20
> Added specific PCI ID and subdevice ID quad and I still get the same
> messages and the adapter is ignored.
>=20
> What am I doing wrong?
>=20
> --
> Meelis Roos (mroos@linux.ee)
