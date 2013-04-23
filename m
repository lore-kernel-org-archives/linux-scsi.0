From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: T10 WCE interpretation in Linux & device level access
Date: Tue, 23 Apr 2013 13:07:02 -0700
Message-ID: <1366747622.1939.6.camel@dabdike>
References: <5176E3E8.3000809@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:55492 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752913Ab3DWUHH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Apr 2013 16:07:07 -0400
In-Reply-To: <5176E3E8.3000809@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <mkp@mkp.net>, Jeff Moyer <jmoyer@redhat.com>, Tejun Heo <tj@kernel.org>, Mike Snitzer <snitzer@redhat.com>

On Tue, 2013-04-23 at 15:41 -0400, Ric Wheeler wrote:
> For many years, we have used WCE as an indication that a device has a volatile 
> write cache (not just a write cache) and used this as a trigger to send down 
> SYNCHRONIZE_CACHE commands as needed.
> 
> Some arrays with non-volatile cache seem to have WCE set and simply ignore the 
> command.

I bet they don't; they probably obey the spec.  There's a SYNC_NV bit
which if unset (which it is in our implementation) means only sync your
non-NV cache.  For a device with all NV, that equates to nop.

> Some arrays with non-volatile cache seem to not set WCE.
> 
> Others arrays with non-volatile cache - our problem arrays - set WCE and do 
> something horrible and slow when sent the SYNCHRONIZE_CACHE commands.

These arrays sound to be out of spec, so we should probably just
blacklist them.

> Note that for file systems, you can override this behavior by mounting with our 
> barriers disabled (mount -o nobarrier .....). There is currently no way do 
> disable this for anything using the device directly, not through the file system.
> 
> Some applications run against block devices - not through a file system - and 
> want not to slow to a crawl when they have an array in my problem set.
> 
> Giving them a hook to ignore WCE seems to be a hack, but one that would resolve 
> issues with users who won't want to wait months (years?) for us to convince the 
> array vendors.
> 
> Is this a hook worth doing?

We already have the ability to set the cache type in sysfs.  It tries to
do a mode select back to the array, but the USB guys want it for the
reverse problem (write back cache behind bridge declared as write
through).

> Have we hashed this out in the T10 committee?

SBC-3 contains everything one could wish for about handling devices with
volatile and NV cache, I thought.

James


