From: Luben Tuikov <luben@splentec.com>
Subject: Re: Q: aborting commands
Date: Tue, 15 Oct 2002 20:02:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DACACAC.9AA42D85@splentec.com>
References: <3DAC7F2F.AA9348F7@splentec.com> <20021015222511.GG1049@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from splentec.com (canoe.splentec.com [209.47.35.250])
	by pepsi.splentec.com (8.11.6/8.11.0) with ESMTP id g9G02qf28855
	for <linux-scsi@vger.kernel.org>; Tue, 15 Oct 2002 20:02:52 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Mike Anderson wrote:
> 
> Luben Tuikov [luben@splentec.com] wrote:
> > I've been meaning to ask this for some time now:
> > What is the consensus on the meaning of an aborted command?
> >
> > Most notably in the SCSI LLP standards, a successfully aborted command
> > will NOT return status as non-aborted commands would (normally) do.
> >
> > 1. Should successfully aborted commands call scsi_done()?
> >    (of course with result=DID_ABORT)
>
> The new eh on calling eh_abort_handler on a cmd believes that it is the
> owner of the command again.

Yes, we know. That's why the ability to sleep on eh, else
there's no way out...
 
> I also noticed an issue in our current error handling in that if call
> eh_abort_handler we may want to call eh_device_reset_handler on the
> device later in recovery. The issue is that it at least one
> implementation by a LLDD this is a either / or case not a progressive
> step of error recovery.

I don't understand this.
 
> How could a LLDD know where the error occurred on a timeout. Take FC for
> example the problem could be a dropped response IU (with device
> completing the cmd) or a class 3 data frame dropped in the middle.

Right, in this case it cannot.

Anyway I was just throwing ideas and questions to increase the brainstorm
pool at linux-scsi, nothing more.

-- 
Luben
