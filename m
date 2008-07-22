From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Subject: RE: [RFC PATCH] HP (Compaq) Smart Array 5xxx controller SCSI driver
Date: Tue, 22 Jul 2008 14:19:22 +0000
Message-ID: <0F5B06BAB751E047AB5C87D1F77A778826B3D60673@GVW0547EXC.americas.hpqcorp.net>
References: <20080719195150Y.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0026.austin.hp.com ([15.216.28.33]:11766 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615AbYGVOUV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Jul 2008 10:20:21 -0400
In-Reply-To: <20080719195150Y.fujita.tomonori@lab.ntt.co.jp>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "Jens.Axboe@oracle.com" <Jens.Axboe@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>



> -----Original Message-----
> From: FUJITA Tomonori [mailto:fujita.tomonori@lab.ntt.co.jp]
> Sent: Saturday, July 19, 2008 5:52 AM
> To: Miller, Mike (OS Dev)
> Cc: James.Bottomley@HansenPartnership.com;
> Jens.Axboe@oracle.com; linux-scsi@vger.kernel.org;
> linux-kernel@vger.kernel.org
> Subject: [RFC PATCH] HP (Compaq) Smart Array 5xxx controller
> SCSI driver
>
> This is a SCSI driver for HP (Compaq) Smart Array 5xxx controllers.
>
> SCSI people can skip the following two paragraphs.
>
> Currently, a driver for HP (Compaq) Smart Array 5xxx
> controllers is implemented as a block device driver,
> block/cciss.c (aka, cciss). But the controller interface is
> SCSI-3 compatible. The specification says, "A controller that
> supports CISS is considered to be a SCSI storage array
> controller". A scsi driver for the controllers was discussed

Not really. The only resemblance we have to a SCSI controller is the fact that we hang SCSI, SAS, and SATA drives off the backend. Our implementation of the SCSI spec is cherry picked for what we need. That, of course, could be changed.

> several times.
>
> I think that a SCSI cciss driver can be much simpler (and
> maintainable) than the block cciss driver (the majority of
> the code forging SCSI command can go away, we have the proper
> sysfs entries for free, we can handle scsi tape drives easily

We already handle tape drives quite easily and one of these days I hope to satisfy Andrew to the point where he will accept my sysfs changes.

> etc). It would be helpful for distributions too since they
> don't need stuff specific to cciss (such as udev rules).
>
>
> There isn't any easy migration path for users. So I think
> that we need to keep the block and scsi drivers for cciss for
> some time (say two years).

Precisely why I am luke warm to this proposal. Who's going to help customers decide which driver to use? What if a number of customers are happy with the block driver? Who will decide for them when to switch? What if a customer is using the block driver and unknowingly upgrades to the SCSI driver? He's dead the water at best, lost his data at worst.

> My scsi driver is still in an early stage (I tried to keep
> the changes minimum). I can detect logical units, mount a
> file system, do lots of I/Os, however, there are lots of
> TODOs in the management features.

Have you taken into consideration any of the HP utilities and management agents? Those must work, period.

>
> If I can get an ACK from HP about the long-term migration of
> cciss to SCSI, I'm happy to keep working on the SCSI cciss
> driver and maintain it until HP takes over the driver.

We already have a SCSI port of the driver that is at least as functional as you decribe. But I am against it's release for the reasons stated above. If we ever decide to release the SCSI port it should be developed by HP so we can be assured that the utils and agents work as expected. That doesn't mean we wouldn't leverage some of your work. ;)

If cciss is ever released as a SCSI driver it would be best if the work was done at HP. Thank you for your efforts, Tomo. I hope you understand my position.

-- mikem

>
>
> The patch is available at:
>
> http://www.kernel.org/pub/linux/kernel/people/tomo/ciss/0001-a
> dd-HP-Compaq-Smart-Array-5xxx-controller-SCSI-dri.patch
>
> clover:/home/fujita# insmod ciss.ko
> clover:/home/fujita# lsscsi
> (snip)
> [1:0:0:0]    disk    HP       LOGICAL VOLUME   1.66  /dev/sde
> [1:0:0:1]    disk    HP       LOGICAL VOLUME   1.66  /dev/sdf
> [1:0:0:2]    disk    HP       LOGICAL VOLUME   1.66  /dev/sdg
> [1:0:0:3]    disk    HP       LOGICAL VOLUME   1.66  /dev/sdh
>
> Yeah, it just works as SCSI disk, the dmesg says:
>
> sd 1:0:0:0: [sde] Attached SCSI disk
> sd 1:0:0:1: [sdf] 143305920 512-byte hardware sectors (73373
> MB) sd 1:0:0:1: [sdf] Write Protect is off sd 1:0:0:1: [sdf]
> Mode Sense: 5b 00 00 08 sd 1:0:0:1: [sdf] Write cache:
> disabled, read cache: enabled, doesn't support DPO or FUA
>
> I needed a different name and just stole 'ciss' from *BSD.
> But any names (like hpciss) works for me.
>
>
> Thanks,
>
