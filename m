From: "Ewan D. Milne" <emilne@redhat.com>
Subject: Re: [PATCH] scsi: Add QEMU CD-ROM to VPD Inquiry Blacklist
Date: Fri, 03 Jun 2016 15:19:31 -0400
Message-ID: <1464981571.20724.84.camel@localhost.localdomain>
References: <1464702149-26573-1-git-send-email-emilne@redhat.com>
	 <20160531134335.o3jpinkdl3wg7ww2@c203.arch.suse.de>
	 <CAGnHSEmS7NzEFK7uD357r6Y=xU5o1O0i+AU5qhmqcqjmp_K0Lw@mail.gmail.com>
	 <1464964617.20724.79.camel@localhost.localdomain>
	 <CAGnHSE=PA-2CR3T-q1JEvXrOFAVFfmVMQaTcf=i6LwVf0hEo6w@mail.gmail.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751919AbcFCTTd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Jun 2016 15:19:33 -0400
In-Reply-To: <CAGnHSE=PA-2CR3T-q1JEvXrOFAVFfmVMQaTcf=i6LwVf0hEo6w@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tom Yan <tom.ty89@gmail.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

commit 09e2b0b14690fb13ccfc04af49f156df3e25b152
Author: Hannes Reinecke <hare@suse.de>
Date:   Mon Nov 9 13:24:28 2015 +0100

    scsi: rescan VPD attributes

---
see also:

commit 5ddfe0858ea7848c5d4efe3f4319e7543522e0ee
Author: Hannes Reinecke <hare@suse.de>
Date:   Fri Apr 1 08:57:36 2016 +0200

    scsi: Do not attach VPD to devices that don't support it

commit 82c43310508eb19eb41fe7862e89afeb74030b84
Author: Mika Westerberg <mika.westerberg@linux.intel.com>
Date:   Wed Jan 27 16:19:13 2016 +0200

    SCSI: Add Marvell Console to VPD blacklist

and presumably:

commit fb2d65d28918ef4f0caa1de3d8c7416949c28b41
Author: Todd Fujinaka <todd.fujinaka@intel.com>
Date:   Tue Feb 9 21:02:07 2016 -0500

    SCSI: Add Marvell configuration device to VPD blacklist


On Sat, 2016-06-04 at 03:14 +0800, Tom Yan wrote:
> What changes are you referring to? Doesn't that mean the changes are
> flawed and some actual follow-up fixes are needed instead?
>=20
> On 3 June 2016 at 22:36, Ewan D. Milne <emilne@redhat.com> wrote:
> > This is an existing configuration that broke with the VPD rescan
> > changes.  The problem is that the error causes a rescan to be
> > initiated, which results in endless error messages.
> >
> > On Fri, 2016-06-03 at 03:15 +0000, Tom Yan wrote:
> >> Why not get qemu have it fixed instead?
> >>
> >> On Tuesday, 31 May 2016, Johannes Thumshirn <jthumshirn@suse.de>
> >> wrote:
> >>         On Tue, May 31, 2016 at 09:42:29AM -0400, Ewan D. Milne wr=
ote:
> >>         > Linux fails to boot as a guest with a QEMU CD-ROM:
> >>         >
> >>         > [    4.439488] ata2.00: ATAPI: QEMU CD-ROM, 0.8.2, max
> >>         UDMA/100
> >>         > [    4.443649] ata2.00: configured for MWDMA2
> >>         > [    4.450267] scsi 1:0:0:0: CD-ROM            QEMU     =
QEMU
> >>         CD-ROM      0.8. PQ: 0 ANSI: 5
> >>         > [    4.464317] ata2.00: exception Emask 0x0 SAct 0x0 SEr=
r
> >>         0x0 action 0x6 frozen
> >>         > [    4.464319] ata2.00: BMDMA stat 0x5
> >>         > [    4.464339] ata2.00: cmd
> >>         a0/01:00:00:00:01/00:00:00:00:00/a0 tag 0 dma 16640 in
> >>         > [    4.464339]          Inquiry 12 01 00 00 ff 00res
> >>         48/20:02:00:24:00/00:00:00:00:00/a0 Emask 0x2 (HSM violati=
on)
> >>         > [    4.464341] ata2.00: status: { DRDY DRQ }
> >>         > [    4.465864] ata2: soft resetting link
> >>         > [    4.625971] ata2.00: configured for MWDMA2
> >>         > [    4.628290] ata2: EH complete
> >>         > [    4.646670] ata2.00: exception Emask 0x0 SAct 0x0 SEr=
r
> >>         0x0 action 0x6 frozen
> >>         > [    4.646671] ata2.00: BMDMA stat 0x5
> >>         > [    4.646683] ata2.00: cmd
> >>         a0/01:00:00:00:01/00:00:00:00:00/a0 tag 0 dma 16640 in
> >>         > [    4.646683]          Inquiry 12 01 00 00 ff 00res
> >>         48/20:02:00:24:00/00:00:00:00:00/a0 Emask 0x2 (HSM violati=
on)
> >>         > [    4.646685] ata2.00: status: { DRDY DRQ }
> >>         > [    4.648193] ata2: soft resetting link
> >>         >
> >>         > ...
> >>         >
> >>         > Fix this by suppressing VPD inquiry for this device.
> >>         >
> >>         > Reported-by: Jan Stancek <jstancek@redhat.com>
> >>         > Tested-by: Jan Stancek <jstancek@redhat.com>
> >>         > Cc: <stable@vger.kernel.org>
> >>         > Signed-off-by: Ewan D. Milne <emilne@redhat.com>
> >>
> >>         Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
> >>
> >>         --
> >>         Johannes Thumshirn
> >>         Storage
> >>         jthumshirn@suse.de                                +49 911
> >>         74053 689
> >>         SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
> >>         GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton
> >>         HRB 21284 (AG N=C3=BCrnberg)
> >>         Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969=
D 2D76
> >>         0850
> >>         --
> >>         To unsubscribe from this list: send the line "unsubscribe
> >>         linux-scsi" in
> >>         the body of a message to majordomo@vger.kernel.org
> >>         More majordomo info at
> >>         http://vger.kernel.org/majordomo-info.html
> >
> >


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
