From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH]: Flexible timeout infrastructure
Date: Tue, 15 Jun 2004 15:12:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40CF4A15.9060005@adaptec.com>
References: <40CF0F9F.4050902@adaptec.com> <1087313492.1796.37.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:64474 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S265861AbUFOTM1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jun 2004 15:12:27 -0400
In-Reply-To: <1087313492.1796.37.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

> But what this basically does is force any implementor of
> eh_cmd_timed_out to handle all timers themselves.  Given that a large
> number of driver writers who try to do this get it wrong (mostly around
> del_timer() and del_timer_sync()), I don't think this is such a good
> idea.

True, it is not a good idea for all LLDD to use this interface.
But a few capable LLDD exist who can make use of it (including
non-native interconnect subsystems).

Also we can include a comment in there that in order to use
this interface the driver has to <funny quote here>. ;-)
 
> This proposal was to allow LLD notification that the timer fired (rather
> than first hearing about it when the eh activated).  I could see an
> extension to this, like the return values you propose, where the LLD
> tells the mid-layer that it corrected the command problem (in interrupt
> context) and the command is ready for completion (otherwise proceed into
> the eh).

But to stay on track and in spec, the LLDD has to notify completion
of the command, via, the only one, antagonist of queuecommand(),
scsi_done().  This would keep the interface consistent.  I explained
this in my latter emails.
 
> Since we also already have the ability to modify the command times in
> slave configure, is it really necessary to encourage the alteration of
> SCSI timers in this way?

Keywords: optional, non-intrusive patch.  It merely adds an alternative
to capable only drivers.  This patch DOES NOT modify SCSI Core.

I'm not talking about an overhaul of SCSI Core here, just an optional
method which a capable driver could use.  It has no effect to the rest
of SCSI Core or LLDDs.

-- 
Luben


