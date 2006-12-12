From: Joe Malicki <jmalicki@metacarta.com>
Subject: Re: megaraid_sas waiting for command and then offline
Date: Mon, 11 Dec 2006 22:04:57 -0500
Message-ID: <457E1C59.80208@metacarta.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from silene.metacarta.com ([65.77.47.18]:47885 "EHLO
	silene.metacarta.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbWLLDF5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Dec 2006 22:05:57 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Brett G. Durrett" <brett@imvu.com>, "linux-scsi "@vger.kernel.org, "David N. Welton" <d.welton@webster.it>, linux-poweredge@dell.com, Sumant Patro <Sumant.Patro@lsil.com>
Cc: "Marc A. Meadows" <mam+megaraid@metacarta.com>, "Keith R. Baker" <krbaker+megaraid@metacarta.com>

>  I have the same or a similar issue running 2.6.17 SMP x86_64 - the
> megaraid_sas driver hangs waiting for commands and then the filesystem
> unmounts, leaving the machine in an unusable state until there is a hard
> reboot (the machine is responsive but any access, shell or otherwise, is
> impossible without the filesystem). While I do not have much debugging
> information available, this happens to me about once every 6-7 days in
> my pool of seven machines, so I can probably get debugging info. Since
> the disk is offline and I can't get remote console, I don't have any
> details except something similar to Dave Lloyd's post, below.

Brett, is this still happening to you?  We're seeing this very
sporadically, but it does concern us.  We've seen driver updates in
2.6.19 (v00.00.03.05) and a new Dell PERC 5/i firmware:

Package Version - 5.0.2-0003
Firmware Version - 1.00.01-0157
SASBIOS Version - MT23
Ctrl-R Version - 1.02-007
MPT Version - 00.06.71.00-IT

and haven't been able to reproduce it, but we can't find a test case to
reliably reproduce the problem to know that anything was fixed (out of
31 identically configured Dell 2950's with the PERC 5/i RAID controller
(configured with 6 300MB SAS drives in a RAID 5, most (all?) of them
Maxtor Atlas 10k, not hot spare).  Our 2950s do have 16GB of RAM each,
so the firmware update (which mentions that it fixes DMA beyond 8GB)
sounds promising, but I would think that if that was the problem we were
experiencing, we would reproduce this much more often?  We are certainly
using the RAM for cache and memory, it's not like we've never touched
beyond 8GB.

Does anyone have a test case to reproduce this problem reliably, or a
detailed description of what actually happens (on low levels) when this
problem occurs that can help to make a test?  We are more interested in
making this reproducible now than in finding a workaround... if anyone
has any tips on how to make this *more* likely to happen we'd like to
know (so far, I know to try to use XFS and enable ReadAhead).

We have seen this correlated with Patrol Reads going on at the same
time, but aren't sure if this is a red herring, and haven't been able to
force the issue to happen by enabling Patrol Reads.

We've only ever seen these on two machines - one machine reproduces the
problem in a little over a week, and the other has reproduced it a small
number of times.  The machines that reproduce it run an experimental
demo workload, but we have not found a test case so far to reproduce the
problem on demand to find or verify solutions.  We're currently swapping
out machines to verify that there are no hardware problems, but the
machines diagnose themselves cleanly, and the workload they run is
different enough that something about the workload we can't yet
synthesize into a test case is the problem.

Thank you!
Joe Malicki
Software Engineer
Metacarta, Inc.
email: jmalicki@metacarta.com

> The only thing that the machines with these failures seem to have in
> common is the fact that they are almost exclusively writes - they are
> slave database machines with large memory and pretty much just
> replicate. The read/write machines seem to have less failures.
> 
> I am happy to help provide debugging information in any reasonable way.
> In the mean time, if there are any known suggestions or workarounds for
> the problem, I would be grateful for the guidance.
> 
> Here are what details on the controller. If you want additional info,
> let me know exactly what you need and I will do what I can to get it to
> you.:
> 
> Product Name : PERC 5/i Integrated
> Serial No : 12345
> FW Package Build: 5.0.1-0030
> FW Version : 1.00.01-0088
> BIOS Version : MT23
> Ctrl-R Version :1.02-007
> 
> B-

