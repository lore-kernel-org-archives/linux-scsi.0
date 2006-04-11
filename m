From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [Comments Needed] scan vs remove_target deadlock
Date: Mon, 10 Apr 2006 23:03:05 -0500
Message-ID: <443B2A79.4020600@cs.wisc.edu>
References: <1144693508.3820.33.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:51395 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1751222AbWDKEDR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Apr 2006 00:03:17 -0400
In-Reply-To: <1144693508.3820.33.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org

James Smart wrote:
> We've seen a very nasty deadlock condition between the scan code and
> the scsi remove code, when the sdev block/unblock functionality is
> used. The scsi_scan mutex is taken as a very coarse lock over the
> scan code, and will be held across multiple SCSI i/o's while the
> scan is proceeding. The scan may be on a single lun basis, or on a
> target basis. The jist is - it's held a loooonnng time. Additionally,
> the scan code uses the block request queue for scan i/o's.  In the case
> where the block/unblock interfaces are being used (fc transport), the
> request queue can be stopped - which stops scanning.  If the same or
> unrelated sdev is then to be removed, we enter a deadlock waiting for
> the scan mutex to be released. In most cases, a background timer fires
> that unblocks the sdev and things eventually unclog (granted a *lot*
> of time may have gone by). In a few cases, we are seeing the sdev
> request queue get plugged, then this deadlock really locks up. One last
> observation: don't mix scan code and other work on the same workq.
> Workq flushing will fall over fast.
> 
> 
> I'd like to poll the wisdom of those on this list as to the best way
> to approach this issue:
> 
> - The plugged queue logic needs to be tracked down. Anyone have any
>   insights ?

Are you referring to a problem in a function like our prep or request fn 
where we could plug the queue if the device state is not online? Do we 
need the scan mutex to change the device state? I mean if a scan has the 
mutex lock, and the transport class decides to remove the device it 
tries to grab the scan_mutex by calling scsi_remove_device, but if we 
moved the state change invocation before the scan_mutex is taken in 
scsi_remove_device then, I assume eventually the device should get 
unplugged, the prep or request_fn will see the new state and fail the 
request.

I am also asking because if you change the state from userspace we do 
not grab the scan_mutex so I did not know if that was bug.


> - The scan mutex, as coarse as it is, is really broken. It would be
>   great to reduce the lock holding so the lock isn't held while an
>   i/o is pending.  This change would be extremely invasive to the scan
>   code. Any other alternatives ?
> - If an sdev is "blocked", we shouldn't be wasting our time scanning it.
>   Should we be adding this checks before sending each scan i/o, or is
>   there a better lower-level function place this check ? Should we be

are you referring to our request or prep fn or scsi_dispatch_cmd or 
something else like when the scan code calls the scsi_execute?

>   creating an explicit return code, or continue to piggy-back on
>   DID_NO_CONNECT ? How do we deal with a scan i/o which may already be
>   queued when the device is blocked ?

Are you thinking about adding a abort/cancel_request() callback to the 
request_queue? Something that could also be called by upper layers like 
DM, and could eventually end up calling a scsi abort function?
