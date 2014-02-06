From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH] st: Do not rewind for SG_IO
Date: Thu, 6 Feb 2014 14:38:35 +0000
Message-ID: <1391697515.2213.74.camel@dabdike.int.hansenpartnership.com>
References: <1391157974-17512-1-git-send-email-hare@suse.de>
	 <52EBD2BB.8020705@tributary.com> <52ECFF7B.7000401@suse.de>
	 <60EE5D9C-A799-4C8D-8962-DB9D7C1C8414@kolumbus.fi>
	 <52EE2F2D.1010300@suse.de> <52EFACA4.6060001@tributary.com>
	 <52EFB06C.8010101@suse.de> <52EFB0E7.3000504@tributary.com>
	 <CAPXgP13dn+VGpu0OLHatUvP4TRDp2YEgCXYB837ReADZTWg_NA@mail.gmail.com>
	 <52F010F9.5090305@tributary.com> <52F389A9.808@suse.de>
	 <yq1eh3gv0l9.fsf@sermon.lab.mkp.net> <52F38D78.2070002@suse.de>
	 <yq161osuz90.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:50295 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbaBFOjO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Feb 2014 09:39:14 -0500
In-Reply-To: <yq161osuz90.fsf@sermon.lab.mkp.net>
Content-Language: en-US
Content-ID: <1F1C3E5AF09E7448B4A05BC1CD0C304E@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jlinton@tributary.com" <jlinton@tributary.com>, "kay@vrfy.org" <kay@vrfy.org>, "hare@suse.de" <hare@suse.de>, "dgilbert@interlog.com" <dgilbert@interlog.com>, "kai.makisara@kolumbus.fi" <kai.makisara@kolumbus.fi>

On Thu, 2014-02-06 at 08:50 -0500, Martin K. Petersen wrote:
> >>>>> "Hannes" == Hannes Reinecke <hare@suse.de> writes:
> 
> >> My patch provides both the original VPD 0x83 and 0x80 bits as well as
> >> a handle identical to /sbin/scsi_id.
> >> 
> Hannes> Bah, don't do that.  That should better be handled by udev
> Hannes> rules.  I've got a set of patches moving from scsi_id to sg_inq,
> Hannes> which can be easily adapted to using sysfs directly.
> 
> I just want to get out of the "userland sending random SCSI commands"
> business. That is a world of pain right now.

Well, in the words of Bill Clinton "I feel your pain".  However, I need
to know we won't pick up that same whole world of pain in the kernel.
Remember it's not just SCSI devices, it's also ATA devices and
potentially other block devices ... then there's blkid and all the weird
things it does. Then there's transport identifiers for multi-path
reservations and so on.

Convince me this path won't have us shifting a whole bunch of weird from
user space to the kernel without any reduction in the weird factor.
Remember the point is not what can we do for all the nicely behaved
SCSI-3 devices, it's what do we do for everything.

James

> I wanted to provide a handle that was guaranteed to be compatible with
> existing tooling. If you have worked around that in udev rules I guess
> that's OK with me.
> 


