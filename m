From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [Comments Needed] scan vs remove_target deadlock
Date: Tue, 18 Apr 2006 17:35:38 -0400
Message-ID: <44455BAA.6080509@emulex.com>
References: <1144693508.3820.33.camel@localhost.localdomain> <443B6E90.4020705@s5r6.in-berlin.de> <443E6C60.3050501@emulex.com> <4445478C.3070703@sgi.com>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:31974 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1750702AbWDRVfu
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Apr 2006 17:35:50 -0400
In-Reply-To: <4445478C.3070703@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-scsi@vger.kernel.org


Michael Reed wrote:
> The remove is not for the target which holds the scsi host's scan mutex.
> Hence, the unblock doesn't kick the [right] queue.

Certainly could be true.

> I think this means that transport cannot call scsi_remove_target() for any
> target if a scan is running.  So, transport has to wait until it can assure
> that no scan is running, perhaps a new mutex, and has to have a way of kicking
> a blocked target which is being scanned, either when the LLDD unblocks
> the target or the delete work for that target fires.

Well - that's one way. Very difficult for the transport to know when this is
true (not all scans occur from the transport). It should be a midlayer thing
to ensure the proper things happen. Also highlights just how gross the that
scan_lock is - which is where the real fix should be, although this will be
a rats nest.

-- james s

