From: Luben Tuikov <luben@splentec.com>
Subject: Re: [patch 2.5] ips queue depths
Date: Tue, 15 Oct 2002 16:26:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DAC7A05.31B17A39@splentec.com>
References: <A3B9245C291EEF4785A24A1DBE8D852B0376BC@rtpexc01.adaptec.com> <20021015194705.GD4391@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from splentec.com (canoe.splentec.com [209.47.35.250])
	by pepsi.splentec.com (8.11.6/8.11.0) with ESMTP id g9FKQhf27306
	for <linux-scsi@vger.kernel.org>; Tue, 15 Oct 2002 16:26:43 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Doug Ledford wrote:
> 
> The scsi mid layer will never send you more than host->can_queue commands
> at one time, so why do all the scsi driver authors feel it is necessary to
> split their queue depth up amongst devices?  Justin Gibbs is the only one
> that gets it right IMHO.  Set the depth on each device as deep as that
> device can take (if that happens to be host->can_queue - 1 or such, then
> so be it).  Then, let the mid layer and the request function worry about
> fairness across devices.  That's its job after all.  If everyone is going
> to moderate their queue depths like that, then we might as well yank
> can_queue out of the host struct entirely because *it serves no purpose*.
> [...]

I agree with Doug on the functionality splitting.
Regarding bashing SCSI core that it doesn't handle the device
q's (starvation) properly: nevertheless it is _its_ function to do
so and this should be observed. Soon enough it will get it right.

There should be a functionality split and LLDD should abide by it --
in the worst case, LLDD can play with the max tagged cmnds number.

Re. bashing the too large a number of tags allowed -- this actually
makes sense sometimes -- e.g. an iSCSI Initiator wants to have
as many tagged commands under its control rather than they
be waiting in SCSI core. If the mid layer has a problem with
a scsi tagged command, then it can notify the LLDD and it
will resolve this (*** please see my next Q. posting ***).

Statements like this: ``The queue depth should be as small as
possible without limiting the performance.'' cannot be generalized
to all devices, be it hardware or software emulations (YKWIM).

-- 
Luben
