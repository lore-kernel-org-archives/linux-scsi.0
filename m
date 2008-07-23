From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Subject: RE: [RFC PATCH] HP (Compaq) Smart Array 5xxx controller SCSI driver
Date: Wed, 23 Jul 2008 14:07:39 +0000
Message-ID: <0F5B06BAB751E047AB5C87D1F77A778826B3D60DE5@GVW0547EXC.americas.hpqcorp.net>
References: <20080719195150Y.fujita.tomonori@lab.ntt.co.jp>
	<0F5B06BAB751E047AB5C87D1F77A778826B3D60673@GVW0547EXC.americas.hpqcorp.net>
 <20080723223940S.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:48665 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119AbYGWOIv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Jul 2008 10:08:51 -0400
In-Reply-To: <20080723223940S.tomof@acm.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, ISS StorageDev <iss_storagedev@hp.com>
Cc: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "Jens.Axboe@oracle.com" <Jens.Axboe@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>



> -----Original Message-----
> From: fujita [mailto:tomof@acm.org] On Behalf Of FUJITA Tomonori
> Sent: Wednesday, July 23, 2008 8:47 AM
> To: Miller, Mike (OS Dev)
> Cc: fujita.tomonori@lab.ntt.co.jp;
> James.Bottomley@HansenPartnership.com; Jens.Axboe@oracle.com;
> linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: RE: [RFC PATCH] HP (Compaq) Smart Array 5xxx
> controller SCSI driver
>
> On Tue, 22 Jul 2008 14:19:22 +0000
> "Miller, Mike (OS Dev)" <Mike.Miller@hp.com> wrote:
>
> > > -----Original Message-----
> > > From: FUJITA Tomonori [mailto:fujita.tomonori@lab.ntt.co.jp]
> > > Sent: Saturday, July 19, 2008 5:52 AM
> > > To: Miller, Mike (OS Dev)
> > > Cc: James.Bottomley@HansenPartnership.com;
> > > Jens.Axboe@oracle.com; linux-scsi@vger.kernel.org;
> > > linux-kernel@vger.kernel.org
> > > Subject: [RFC PATCH] HP (Compaq) Smart Array 5xxx controller SCSI
> > > driver
> > >
> > > This is a SCSI driver for HP (Compaq) Smart Array 5xxx
> controllers.
> > >
> > > SCSI people can skip the following two paragraphs.
> > >
> > > Currently, a driver for HP (Compaq) Smart Array 5xxx
> controllers is
> > > implemented as a block device driver, block/cciss.c (aka, cciss).
> > > But the controller interface is
> > > SCSI-3 compatible. The specification says, "A controller that
> > > supports CISS is considered to be a SCSI storage array
> controller".
> > > A scsi driver for the controllers was discussed
> >
> > Not really. The only resemblance we have to a SCSI
> controller is the
> > fact that we hang SCSI, SAS, and SATA drives off the backend. Our
> > implementation of the SCSI spec is cherry picked for what we need.
> > That, of course, could be changed.
>
> The controllers support mandatory commands at least, as the spec says?

As of today our inquiry data doesn't neccesarily match the SCSI-3 spec. But that can be changed.

>
>
> > > several times.
> > >
> > > I think that a SCSI cciss driver can be much simpler (and
> > > maintainable) than the block cciss driver (the majority
> of the code
> > > forging SCSI command can go away, we have the proper
> sysfs entries
> > > for free, we can handle scsi tape drives easily
> >
> > We already handle tape drives quite easily and one of these days I
> > hope to satisfy Andrew to the point where he will accept my sysfs
> > changes.
>
> I think that there are other areas that we can improve with a
> SCSI driver, such as error handling, queue depth management, etc.

True.

>
>
> > > etc). It would be helpful for distributions too since they don't
> > > need stuff specific to cciss (such as udev rules).
> > >
> > >
> > > There isn't any easy migration path for users. So I think that we
> > > need to keep the block and scsi drivers for cciss for
> some time (say
> > > two years).
> >
> > Precisely why I am luke warm to this proposal. Who's going to help
> > customers decide which driver to use?
>
> I guess that distributions (with HP) can, as they could with
> libata vs. ide.

I've had discussions with our partners. They are open to the concept of porting to SCSI. There will be some period of time where there are 2 drivers, however. And as James stated  the udev rules can create the /dev/cciss links so hopefully there will be minimal impact to users.

>
>
> > What if a number of customers are happy with the block driver? Who
> > will decide for them when to switch? What if a customer is
> using the
> > block driver and unknowingly upgrades to the SCSI driver? He's dead
> > the water at best, lost his data at worst.
>
> I think that customers don't care about how the driver is
> implemented. My point is that the SCSI cciss driver could be
> better than the block one.

You're probably right here, also.

>
> As James pointed out, we could provide a migration path; we
> can change only the driver internal without changing the
> user-space interfaces:
>
> With my SCSI driver (I uploaded a new one), I got the
> following devices connected with my CCISS adapter:
>
> clover:/home/fujita# lsscsi
> (snip)
> [3:0:0:0]    disk    HP       LOGICAL VOLUME   1.66  /dev/sde
> [3:0:0:1]    disk    HP       LOGICAL VOLUME   1.66  /dev/sdf
> [3:0:0:2]    disk    HP       LOGICAL VOLUME   1.66  /dev/sdg
> [3:0:0:3]    disk    HP       LOGICAL VOLUME   1.66  /dev/sdh
>
> I created symbolic links (neat udev rules can do automatically).
>
> clover:/home/fujita# ls -l /dev/cciss/
> total 0
> lrwxrwxrwx 1 root root 8 2008-07-23 21:38 c0d0 -> /dev/sde
> lrwxrwxrwx 1 root root 9 2008-07-23 21:39 c0d0p1 -> /dev/sde1
> lrwxrwxrwx 1 root root 9 2008-07-23 21:39 c0d0p2 -> /dev/sde2
> lrwxrwxrwx 1 root root 8 2008-07-23 21:38 c0d1 -> /dev/sdf
> lrwxrwxrwx 1 root root 8 2008-07-23 21:38 c0d2 -> /dev/sdg
> lrwxrwxrwx 1 root root 8 2008-07-23 21:38 c0d3 -> /dev/sdh
>
> The symbolic links enable users to mount the device as before.
>
> hpacucli seems to work (I didn't try all the commands but the
> point is that we can provide the ioctl compatibility):

Very good. I don't believe most people would have taken the utils into consideration.

>
> clover:/home/fujita# hpacucli
> HP Array Configuration Utility CLI 7.80-3.0 Detecting
> Controllers...Done.
> Type "help" for a list of supported commands.
> Type "exit" to close the console.
>
> => ctrl all show config
>
> Smart Array E200 in Slot 3    (sn: PA6C90L9SV90L0)
>
>    array A (SAS, Unused Space: 0 MB)
>
>       logicaldrive 1 (68.3 GB, RAID 0, OK)
>
>       physicaldrive 1I:1:1 (port 1I:box 1:bay 1, SAS, 72 GB, OK)
>
>    array B (SAS, Unused Space: 0 MB)
>
>       logicaldrive 2 (68.3 GB, RAID 0, OK)
>
>       physicaldrive 1I:1:3 (port 1I:box 1:bay 3, SAS, 72 GB, OK)
>
>    array C (SAS, Unused Space: 0 MB)
>
>       logicaldrive 3 (68.3 GB, RAID 0, OK)
>
>       physicaldrive 1I:1:2 (port 1I:box 1:bay 2, SAS, 72 GB, OK)
>
>    array D (SAS, Unused Space: 0 MB)
>
>       logicaldrive 4 (68.3 GB, RAID 0, OK)
>
>       physicaldrive 1I:1:4 (port 1I:box 1:bay 4, SAS, 72 GB, OK)
>
>
> When HP and distributions think that the scsi driver is
> ready, they can modify their udev rules for cciss and enable
> the SCSI driver module instead of the block driver.
>
>
> > > My scsi driver is still in an early stage (I tried to keep the
> > > changes minimum). I can detect logical units, mount a
> file system,
> > > do lots of I/Os, however, there are lots of TODOs in the
> management
> > > features.
> >
> > Have you taken into consideration any of the HP utilities
> and management agents? Those must work, period.
>
> Yes, I understand that. We will need lots of tests.
>
> As I explained, we can provide the compatibility of ioctl and
> device names. We could avoid breaking the existing tools?

Correct.

>
> Even though we need lots of tests, I still think that
> migrating to the SCSI subsystem is the right thing for CCISS
> in the long term perspective.

I'm afraid I have to agree with you. I've been a steadfast opponent of a SCSI port but in the long run perhaps it is the best thing to do.

>
>
> > > If I can get an ACK from HP about the long-term migration
> of cciss
> > > to SCSI, I'm happy to keep working on the SCSI cciss driver and
> > > maintain it until HP takes over the driver.
> >
> > We already have a SCSI port of the driver that is at least as
> > functional as you decribe. But I am against it's release for the
> > reasons stated above. If we ever decide to release the SCSI port it
> > should be developed by HP so we can be assured that the utils and
> > agents work as expected. That doesn't mean we wouldn't
> leverage some
> > of your work. ;)
>
> If HP releases its SCSI driver, I'm happy to throw my driver
> away and work on HP SCSI driver. I like to see a driver in
> development rather than a finished driver; development in
> mainline rather than private development at a vendor.
> Everyone can see the progress and try it.

We'll post something sooner rather than later. I've been hesitant to submit unfinished work but I guess having the community provide input along the way is the best way to go.

OK, Tomo, you win!   :)

-- mikem

>
>
> Thanks,
>
