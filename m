From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH] updated: suspending I/Os to a device
Date: Fri, 20 Aug 2004 09:48:06 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <41260116.90804@adaptec.com>
References: <0B1E13B586976742A7599D71A6AC733C02F172@xbl3.ma.emulex.com> <20040820085516.GA5582@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:59844 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S267553AbUHTNsL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Aug 2004 09:48:11 -0400
In-Reply-To: <20040820085516.GA5582@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: James.Smart@Emulex.Com, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org

>  > 1) The number of timers that had to be running. A single cable pull 
> can be handled by 1 timer in the LLDD, which will always be there. If 
> there's a timer per device - and the config (still small) has 4-8 
> arrays, each array with 256 LUNs - this is a 1k/2k timers vs 1 scenario. 
> A single device disappearance (a target) is a 256 (or more) vs 1 
> scenario. Not only the amount of resources for the timers, but also the 
> complexity of when all these timers fire and the same time and start 
> spitting i/o - which is not necessarily coordinated with the LLDD state 
> change. Makes for a lot of fun error handling. I'd rather deal with an 
> LLDD that misses an unblock (easy to spot) vs the race conditions that 
> could occur due to the last point. Granted, this should all work, but 
> its in a location that is typically much harder to test and reproduce.

This is true.  I can imagine this being added in a flexible manner
so that LLDD who can drive it, can use it, and the rest can rely on
SCSI Core.

Similar arguments have been discussed before (flexible command timeout
patch).

> It would be nice some day to have real target representation, but this
> pseudo support we have now may address your needs.

I'd been thinking about scsi_target since my days at Splentec.
(but really _just_ thinking)

Basically there'd be properties and methods that only belong to
SCSI Targets, and not to LUs.  So at some point we may want to
represent/expose those properties and methods to those who may
want to use them and/or are interested in them.

It would be a step closer to SAM, although, one doesn't technically
need it to have a working SCSI layer (as we do now).

		Luben



