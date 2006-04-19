From: Michael Reed <mdr@sgi.com>
Subject: Re: [Comments Needed] scan vs remove_target deadlock
Date: Wed, 19 Apr 2006 10:34:19 -0500
Message-ID: <4446587B.60709@sgi.com>
References: <1144693508.3820.33.camel@localhost.localdomain> <443B6E90.4020705@s5r6.in-berlin.de> <443E6C60.3050501@emulex.com> <4445478C.3070703@sgi.com> <44455BAA.6080509@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:27607 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S1750902AbWDSPe3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Apr 2006 11:34:29 -0400
In-Reply-To: <44455BAA.6080509@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-scsi@vger.kernel.org



James Smart wrote:
> Michael Reed wrote:
>> The remove is not for the target which holds the scsi host's scan mutex.
>> Hence, the unblock doesn't kick the [right] queue.
> 
> Certainly could be true.

I don't think it would deadlock if it wasn't.  The scan mutex is a rather
gross lock.

> 
>> I think this means that transport cannot call scsi_remove_target() for any
>> target if a scan is running.  So, transport has to wait until it can assure
>> that no scan is running, perhaps a new mutex, and has to have a way of kicking
>> a blocked target which is being scanned, either when the LLDD unblocks
>> the target or the delete work for that target fires.
> 
> Well - that's one way. Very difficult for the transport to know when this is
> true (not all scans occur from the transport). It should be a midlayer thing
> to ensure the proper things happen. Also highlights just how gross the that
> scan_lock is - which is where the real fix should be, although this will be
> a rats nest.

There's fc_user_scan() which I believe handles scans initiated
via the sysfs/proc variables.  There's fc_scsi_scan_rport() run via the scan work.
It appears that the routines that perform a scan, in a fibre channel context,
are all entered via the transport.

What am I missing?

Mike

> 
> -- james s
> 
