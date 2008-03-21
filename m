From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [SCSI] fix media change events for polled devices
Date: Fri, 21 Mar 2008 14:38:37 -0500
Message-ID: <1206128318.2961.32.camel@localhost.localdomain>
References: <200803211559.m2LFxPi6017869@hera.kernel.org>
	 <47E3EC67.4050404@garzik.org>
	 <alpine.LFD.1.00.0803211031010.3020@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:49984 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752080AbYCUTim (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Mar 2008 15:38:42 -0400
In-Reply-To: <alpine.LFD.1.00.0803211031010.3020@woody.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff Garzik <jeff@garzik.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Kay Sievers <kay.sievers@vrfy.org>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org

On Fri, 2008-03-21 at 10:31 -0700, Linus Torvalds wrote:
> 
> On Fri, 21 Mar 2008, Jeff Garzik wrote:
> > 
> > And that is the fix -- initialize supported_events according to sr/sd's needs,
> > and revert this change (4d1566ed2100d074ccc654e5cf2e44cdea3a01d0) as obviously
> > broken.
> 
> Patches, please? I can do the revert, but the patch to supported_events 
> and the testing, please?

I tested this and discussed it with Kristen before it went in.  The
current fix you sucked in with scsi-rc-fixes basically makes the whole
lot work for 2.6.25 (both AN media change events and traditional polled
ones).  The thing that doesn't work is the ability to turn off AN events
from user space, but that feature never worked anyway.

I promised Kay I'd work on a better solution for 2.6.26 which will
include separating up the input events into polled and AN for a CD but
emitting the same media change event to udev at the top (so you can rely
on either polled or AN for media change and select which or both if you
desire).

James


