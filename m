From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] updated: suspending I/Os to a device
Date: Fri, 20 Aug 2004 01:55:17 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040820085516.GA5582@us.ibm.com>
References: <0B1E13B586976742A7599D71A6AC733C02F172@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:32422 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S264980AbUHTI5t
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Aug 2004 04:57:49 -0400
Content-Disposition: inline
In-Reply-To: <0B1E13B586976742A7599D71A6AC733C02F172@xbl3.ma.emulex.com>
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org

James.Smart@Emulex.Com [James.Smart@Emulex.Com] wrote:
> All True...  and I'm not trying to belittle it.
> 
> The main things that sent me to the LLDD side were:
> 
> 1) The number of timers that had to be running. A single cable pull can be handled by 1 timer in the LLDD, which will always be there. If there's a timer per device - and the config (still small) has 4-8 arrays, each array with 256 LUNs - this is a 1k/2k timers vs 1 scenario. A single device disappearance (a target) is a 256 (or more) vs 1 scenario. Not only the amount of resources for the timers, but also the complexity of when all these timers fire and the same time and start spitting i/o - which is not necessarily coordinated with the LLDD state change. Makes for a lot of fun error handling. I'd rather deal with an LLDD that misses an unblock (easy to spot) vs the race conditions that could occur due to the last point. Granted, this should all work, but its in a location that is typically much harder to test and reproduce.
> 

An option to consider is that what you want is target level suspend in
the mid layer. While the mid-layer does not have a target representation
equal to the lun representation (scsi_device) you get some target linkage
between the scsi_devs using same_target_siblings.

Just pass in the scsi_device as you where doing (maybe update the
function names to match the target suspend). Inside the function use a
list_for_each_entry over same_target_siblings to set the scsi_device
state to suspend. Then use a single timeout timer for each target.

If we want to have full symmetric interfaces to the LLDD for suspending
a target "siblings" or a lun "scsi_device" with protection for
calling already suspend objects we may need a little more locking around
the state changes or some other exclusion method.

It would be nice some day to have real target representation, but this
pseudo support we have now may address your needs.

I am little sleepy so maybe this idea is not as good as it seems
now as it would after a little sleep. YMMV

-andmike
--
Michael Anderson
andmike@us.ibm.com

