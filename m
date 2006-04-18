From: Michael Reed <mdr@sgi.com>
Subject: Re: [Comments Needed] scan vs remove_target deadlock
Date: Tue, 18 Apr 2006 15:09:48 -0500
Message-ID: <4445478C.3070703@sgi.com>
References: <1144693508.3820.33.camel@localhost.localdomain> <443B6E90.4020705@s5r6.in-berlin.de> <443E6C60.3050501@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:13209 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S932308AbWDRUKE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Apr 2006 16:10:04 -0400
In-Reply-To: <443E6C60.3050501@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-scsi@vger.kernel.org



James Smart wrote:
> Thanks Stefan...
> 
>> Another driver which uses a block/unblock interface is sbp2. It blocks
>> shosts (because one shost == one SBP-2 LU at the moment) during 1394 bus
>> reset/ 1394 nodes rescan/ SBP-2 reconnect phases. I learned the hard way
>> that an shost (or sdev if you will) *must not be blocked* when an shost
>> (or sdev) is to be removed.
> 
> True. The FC transport explicitly performs an unblock prior to the remove
> call. However, the remove is then deadlocking on the scan_mutext vs the
> pending request queue (still trying to find out why it's really stuck).

The remove is not for the target which holds the scsi host's scan mutex.
Hence, the unblock doesn't kick the [right] queue.

I think this means that transport cannot call scsi_remove_target() for any
target if a scan is running.  So, transport has to wait until it can assure
that no scan is running, perhaps a new mutex, and has to have a way of kicking
a blocked target which is being scanned, either when the LLDD unblocks
the target or the delete work for that target fires.

Mike

> 
>> IOW before a transport may remove an sdev or shost, it has to unblock it
>> and it also has to make sure that all commands that were enqueued before
>> the blocking are being completed.
> 
> True. The FC transport explicitly performs an unblock prior to the remove
> call. What I'm seeing would align with "not" making sure the prior queued
> commands are completed before it removes.
> 
>> But isn't it rather a responsibility
>> of the SCSI core to get a LU's or target's state transitions right?
> 
> Agreed. The real issue is - define the window for prior queued commands.
> You may flush all that are there right now, but that may immediately
> requeue a retry, etc - which means you have to start all over.
> 
>> When
>> an sdev is "blocked" and the transport tells the core to transition it
>> to "to be removed", then the core should know that the sdev's LU cannot
>> be reached anymore and act accordingly.
> 
> I would assume - that's what we'll eventually get to, with the mutex
> being the first onion layer to get pulled.
> 
> -- james s
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
