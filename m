From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [SCSI] fix media change events for polled devices
Date: Fri, 21 Mar 2008 16:54:39 -0400
Message-ID: <47E4208F.20601@garzik.org>
References: <200803211559.m2LFxPi6017869@hera.kernel.org>	 <47E3EC67.4050404@garzik.org>	 <alpine.LFD.1.00.0803211031010.3020@woody.linux-foundation.org> <1206128318.2961.32.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:41019 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756093AbYCUUyn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Mar 2008 16:54:43 -0400
In-Reply-To: <1206128318.2961.32.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Kay Sievers <kay.sievers@vrfy.org>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Fri, 2008-03-21 at 10:31 -0700, Linus Torvalds wrote:
>> On Fri, 21 Mar 2008, Jeff Garzik wrote:
>>> And that is the fix -- initialize supported_events according to sr/sd's needs,
>>> and revert this change (4d1566ed2100d074ccc654e5cf2e44cdea3a01d0) as obviously
>>> broken.
>> Patches, please? I can do the revert, but the patch to supported_events 
>> and the testing, please?
> 
> I tested this and discussed it with Kristen before it went in.  The
> current fix you sucked in with scsi-rc-fixes basically makes the whole
> lot work for 2.6.25 (both AN media change events and traditional polled
> ones).  The thing that doesn't work is the ability to turn off AN events
> from user space, but that feature never worked anyway.

Not true.  Change the perm with chmod...

But furthermore, change 4d1566ed renders the userspace interface 
/inconsistent/ even for the read-only case that we all acknowledge 
_does_ work.

IOW, after your "fix", the userspace interface gives an incorrect 
picture of what events are/are not masked.


If you don't have the time to complete work on

	commit 285e9670d91cdeb6b6693729950339cb45410fdc
	Author: Kay Sievers <kay.sievers@vrfy.org>
	Date:   Tue Aug 14 14:10:39 2007 +0200

	    [SCSI] sr,sd: send media state change modification events

then revert _that_.

Don't break my patch, just because yours (which came _after_ mine) 
doesn't work.

	Jeff


