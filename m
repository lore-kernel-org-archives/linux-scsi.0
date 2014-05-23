From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [target:for-next 20/20] drivers/scsi/virtio_scsi.c:531:48:
 error: dereferencing pointer to incomplete type
Date: Fri, 23 May 2014 10:45:10 -0700
Message-ID: <1400867110.30565.6.camel@haakon3.risingtidesystems.com>
References: <537d6b74.lQGMmmapPq/MP5Nx%fengguang.wu@intel.com>
	 <1400791590.26558.6.camel@haakon3.risingtidesystems.com>
	 <537F12C1.4080407@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:56728 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbaEWRpM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 May 2014 13:45:12 -0400
In-Reply-To: <537F12C1.4080407@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kbuild test robot <fengguang.wu@intel.com>, kbuild-all@01.org, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Fri, 2014-05-23 at 11:20 +0200, Paolo Bonzini wrote:
> Il 22/05/2014 22:46, Nicholas A. Bellinger ha scritto:
> > Hi Fengguang,
> >
> > On Thu, 2014-05-22 at 11:13 +0800, kbuild test robot wrote:
> >> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git for-next
> >> head:   4baaa7d589e24bfe87dfd6c7a1229108be404a28
> >> commit: 4baaa7d589e24bfe87dfd6c7a1229108be404a28 [20/20] virtio-scsi: Enable DIF/DIX modes in SCSI host LLD
> >> config: x86_64-randconfig-x000 (attached as .config)
> >>
> >> All error/warnings:
> >>
> >>    drivers/scsi/virtio_scsi.c: In function 'virtio_scsi_init_hdr_pi':
> >>>> drivers/scsi/virtio_scsi.c:531:48: error: dereferencing pointer to incomplete type
> >>       cmd_pi->pi_bytesout = blk_rq_sectors(rq) * bi->tuple_size;
> >>                                                    ^
> >>>> drivers/scsi/virtio_scsi.c:533:47: error: dereferencing pointer to incomplete type
> >>       cmd_pi->pi_bytesin = blk_rq_sectors(rq) * bi->tuple_size;
> >>                                                   ^
> >>
> >> vim +531 drivers/scsi/virtio_scsi.c
> >>
> >>    525		if (!rq || !scsi_prot_sg_count(sc))
> >>    526			return;
> >>    527	
> >>    528		bi = blk_get_integrity(rq->rq_disk);
> >>    529	
> >>    530		if (sc->sc_data_direction == DMA_TO_DEVICE)
> >>  > 531			cmd_pi->pi_bytesout = blk_rq_sectors(rq) * bi->tuple_size;
> >>    532		else if (sc->sc_data_direction == DMA_FROM_DEVICE)
> >>  > 533			cmd_pi->pi_bytesin = blk_rq_sectors(rq) * bi->tuple_size;
> >>    534	}
> >>    535	
> >>    536	static int virtscsi_queuecommand(struct virtio_scsi *vscsi,
> >>
> >
> > Squashing the following into the original commit to enable blk-integrity
> > for virtio-scsi to address the randconfig build failure above.
> >
> > Thanks!
> >
> > --nab
> >
> > diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> > index 02832d6..baca589 100644
> > --- a/drivers/scsi/Kconfig
> > +++ b/drivers/scsi/Kconfig
> > @@ -1773,6 +1773,7 @@ config SCSI_BFA_FC
> >  config SCSI_VIRTIO
> >         tristate "virtio-scsi support"
> >         depends on VIRTIO
> > +       select BLK_DEV_INTEGRITY
> >         help
> >            This is the virtual HBA driver for virtio.  If the kernel will
> >            be used in a virtual machine, say Y or M.
> 
> What about #ifdef'ing VIRTIO_SCSI_F_T10_PI support out if 
> !CONFIG_BLK_DEV_INTEGRITY?
> 

I figured it was slightly cleaner to enable BLK_DEV_INTEGRITY by default
when referencing struct blk_integrity (following what IBLOCK does), than
adding the equivalent #ifdef's..

MKP, do you have a preference on this..?

--nab

