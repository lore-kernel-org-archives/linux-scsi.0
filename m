From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: no INQUIRY from userspace please (was Re: [PATCH 7/9] scsi_dh:
	Add support for SDEV_PASSIVE)
Date: Thu, 07 Feb 2008 09:01:30 -0600
Message-ID: <1202396490.3171.8.camel@localhost.localdomain>
References: <20080124003010.18871.84095.sendpatchset@localhost.localdomain>
	 <20080124003203.18871.52040.sendpatchset@localhost.localdomain>
	 <1202151498.3096.84.camel@localhost.localdomain>
	 <1202156151.13537.14.camel@linuxchandra>
	 <1202156914.3096.112.camel@localhost.localdomain>
	 <47A8C14A.3030207@cs.wisc.edu> <20080205215657.GA20963@linux.vnet.ibm.com>
	 <47AAD898.30004@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:40296 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755904AbYBGPBg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Feb 2008 10:01:36 -0500
In-Reply-To: <47AAD898.30004@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Mike Anderson <andmike@linux.vnet.ibm.com>, Mike Christie <michaelc@cs.wisc.edu>, sekharan@us.ibm.com, dm-devel@redhat.com, linux-scsi@vger.kernel.org, jens.axboe@oracle.com

On Thu, 2008-02-07 at 11:08 +0100, Stefan Richter wrote:
> Mike Anderson wrote:
> > A number of user apps like lvm scanning that execute media access commands
> > already have filter capability to filter devices that one does not want to
> > scan. Another class of device scanners just use inquiries which are not
> > effected by the passive state (though some could probably use udevinfo and
> > reduce the amount of repeated SCSI inquiries execute on the system.
> 
> To expand on this:
> 
> At least on desktop systems and SOHO server systems, userspace should
> _never_ issue INQUIRY.  There are too many broken firmwares out there
> which assume that there will never be more than one INQUIRY sent.  They
> start to return garbled data or crash if they get a second INQUIRY.

It's all very well to say this, but I think if you look at what udev
does, you'll find that it uses scsi_id to send a VPD inquiry to the
device so it can populate /dev/disk/by-id, so the point is already
conceded (and I think looking at a recent camera crash that seems to
have been precipitated by this, it's already causing us problems).

This is all a tradeoff.  If you want userspace *never* to issue raw SCSI
commands like INQUIRY, we're going to have to provide the needed
information from the kernel via sysfs ... including VPD strings.  This
is something we've always shovelled off into userspace before.

James


