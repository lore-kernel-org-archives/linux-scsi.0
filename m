From: Jeremy Linton <jlinton@tributary.com>
Subject: Re: T10 WCE interpretation in Linux & device level access
Date: Tue, 23 Apr 2013 17:39:38 -0500
Message-ID: <51770DAA.4020409@tributary.com>
References: <5176E3E8.3000809@redhat.com> <1366747622.1939.6.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay.ihostexchange.net ([66.46.182.57]:45003 "EHLO
	relay.ihostexchange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755896Ab3DWWjp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Apr 2013 18:39:45 -0400
In-Reply-To: <1366747622.1939.6.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Ric Wheeler <rwheeler@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <mkp@mkp.net>, Jeff Moyer <jmoyer@redhat.com>, Tejun Heo <tj@kernel.org>, Mike Snitzer <snitzer@redhat.com>, "dgilbert@interlog.com" <dgilbert@interlog.com>

On 4/23/2013 3:07 PM, James Bottomley wrote:

> 
> I bet they don't; they probably obey the spec.  There's a SYNC_NV bit
> which if unset (which it is in our implementation) means only sync your
> non-NV cache.  For a device with all NV, that equates to nop.

	Yes, linux leaves the SYNC_NV bit unset in scsi_setup_flush_cmnd().

The draft specs, and a couple others I have laying about says: says the device
shall sync cache to medium for both volatile and non volatile cache data if
SYNC_NV is _unset_.

With it set, the table could be more confusing!

For volatile cache blocks with SYNC_NV set "If a non-volatile cache is present,
then the device server shall synchronize to non-volatile cache or to the medium.
If a non-volatile cache is not present, then the device server shall synchronize
to the medium".

And for Non-volatile cache with it set "No Requirement"


Which to me says, don't expect any particular behavior if you set this bit and
have NV it could flush to medium, flush to NV cache, or do nothing at all. But
it seems pretty clear that with it unset its probably going to get synchronized
to the medium.


If T10 were to do something, maybe they could stop putting bits in the docs that
aren't guaranteed to do anything (fill in rant).

As for linux, seems the state of the spec really doesn't leave any good options
other than provide the user the ability to disable the flush_cmnd() if  the
NV_SUP bit is set. Or maybe a white list (ick!)...







