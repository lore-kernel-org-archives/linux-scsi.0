From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH 0/2] convert sg to use block layer helpers
Date: Fri, 09 Feb 2007 11:52:34 -0500
Message-ID: <45CCA6D2.10008@torque.net>
References: <1171010063.3713.26.camel@max>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:47831 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946544AbXBIQwv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Feb 2007 11:52:51 -0500
In-Reply-To: <1171010063.3713.26.camel@max>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: jens.axboe@oracle.com, linux-scsi@vger.kernel.org

Mike Christie wrote:
> sg duplicates a lot of block layer dio and copying code. The block layer
> is missing some things like mmap helpers and a way to support sg and
> st's reserve buffer. The next two patches move move functionality from
> sg to the block layer so later st and osst can use it, and then coverts
> sg to use the block layer helper.
> 
> The goal is to kill scsi_execute_async and friends and covert the ULDs
> to use the block layer functions directly. This is nice because
> scsi_execute_async sucks and it actually duplicates block layer code,
> and in the end the scsi layer does not have to do any bio processing
> (which irks Jens :)), and we have common code for all ULDs.
> 
> The patches were made over Jens's bsg branch in his block layer git tree
> on kernel.org. Sorry for the large patches. The sg conversion patch rips
> out alot of code duplicated in the block layer and the patch to add some
> missing functionality to the block layer has conversions to bsg, tgt,
> etc so git bisect works on it.

Mike,
Might I suggest ripping all the scatter gather list
handling out of the block layer and putting it in
a library (a bit like libata). That way when the
block layer paradigm doesn't apply, we don't lose
all the useful things that have been put in there.

OSD and char devices (e.g. SSC, SES, wlun, security)
are not block devices in any reasonable sense. It
would be good to get away from "devices" that need
a "/dev/" or even a sysfs representation. A REPORT
LUNS well known LU is only needed during a LU
discovery process on a target. So if that is done
from the user space why do we need a "/dev" or
sysfs entry hanging around clogging up the device
space?

Pushing SCSI pass-through functionality further and
further up the stack diminishes its utility and may
lead to a re-introduction of useful pass-throughs
at a lower level (actually there are some already there).

Think about a SCSI INQUIRY command, it is implicit
"head of queue" which means it should bypass all
the block layer queuing and other impediments. It can
be sent to logical units that don't even exist!
Task management functions should not be queued.
SMP functions should not be queued. And so it goes
on.

Doug Gilbert
