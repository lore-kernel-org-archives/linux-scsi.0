From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: T10 WCE interpretation in Linux & device level access
Date: Tue, 23 Apr 2013 16:28:01 -0400
Message-ID: <5176EED1.7070305@interlog.com>
References: <5176E3E8.3000809@redhat.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:41733 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754866Ab3DWU3N (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Apr 2013 16:29:13 -0400
In-Reply-To: <5176E3E8.3000809@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <mkp@mkp.net>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jeff Moyer <jmoyer@redhat.com>, Tejun Heo <tj@kernel.org>, Mike Snitzer <snitzer@redhat.com>

On 13-04-23 03:41 PM, Ric Wheeler wrote:
>
> For many years, we have used WCE as an indication that a device has a volatile
> write cache (not just a write cache) and used this as a trigger to send down
> SYNCHRONIZE_CACHE commands as needed.
>
> Some arrays with non-volatile cache seem to have WCE set and simply ignore the
> command.
>
> Some arrays with non-volatile cache seem to not set WCE.
>
> Others arrays with non-volatile cache - our problem arrays - set WCE and do
> something horrible and slow when sent the SYNCHRONIZE_CACHE commands.

Do the problematic arrays correctly set the NV_SUP** or V_SUP
bits in the Extended Inquiry VPD pages? Does Linux take any
notice of those bits? [Guess the answer.]

If the problematic arrays correctly set the NV_SUP and Linux
sends SYNCHRONIZE_CACHE commands then Linux should be named
and shamed.

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

> Is this a hook worth doing?
>
> Have we hashed this out in the T10 committee?

There is also a NV_DIS bit in the caching mode page that if
supported would allow the NV cache to be disabled.

Looks like T10 supplies enough knobs, it is up to the vendor
to set them appropriately and Linux to take notice.

Doug Gilbert


** What JB called SYNC_NV ...
