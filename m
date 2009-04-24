From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 2 of 9] block: Export I/O topology for block devices and partitions
Date: Fri, 24 Apr 2009 11:00:52 -0400
Message-ID: <yq1ws9a85az.fsf@sermon.lab.mkp.net>
References: <patchbomb.1240551141@sermon.lab.mkp.net>
	<72f4e15760670febdb40.1240551143@sermon.lab.mkp.net>
	<ac3eb2510904240514y660973abj7621864e11e514f2@mail.gmail.com>
	<49F1B68D.3010304@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet12.oracle.com ([148.87.113.124]:16938 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbZDXPDv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Apr 2009 11:03:51 -0400
In-Reply-To: <49F1B68D.3010304@garzik.org> (Jeff Garzik's message of "Fri, 24
	Apr 2009 08:54:37 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, rwheeler@redhat.com, snitzer@redhat.com, neilb@suse.de, James.Bottomley@hansenpartnership.com, dgilbert@interlog.com, jens.axboe@oracle.com, matthew@wil.cx, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

>>>>> "Jeff" == Jeff Garzik <jeff@garzik.org> writes:

Jeff> Why do we need all this syscall overhead just to read individual
Jeff> data items?

Jeff> Isn't it dumb to require 30 userland syscalls simply to input a
Jeff> 10-member data structure?

Jeff> netlink looks more and more attractive for anything non-trivial.

I think these three knobs are very trivial :)

I agree that traversing sysfs can be sucky.  But for the mkfs-es of the
world I expect most of this to be handled by libdisk.

I also I really wanted something that could be easily scripted for
installers to poke at.

If these values were in any kind of hot path I'd be inclined to agree
with the need for a different interface.  But realistically these are
only ever going to be accessed when creating a filesystem, partition or
MD/DM device.

So I opted to keep things simple.  Doesn't mean we can't add another
interface if there's a real need...

-- 
Martin K. Petersen	Oracle Linux Engineering
