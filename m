From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH]: Flexible timeout infrastructure
Date: Tue, 15 Jun 2004 11:15:36 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040615181536.GA12611@us.ibm.com>
References: <40CF0F9F.4050902@adaptec.com> <1087313492.1796.37.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.104]:63207 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S265810AbUFOSPk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jun 2004 14:15:40 -0400
Content-Disposition: inline
In-Reply-To: <1087313492.1796.37.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Luben Tuikov <luben_tuikov@adaptec.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley [James.Bottomley@steeleye.com] wrote:
> On Tue, 2004-06-15 at 10:02, Luben Tuikov wrote:
> > This patch introduces a flexible command timeout infrastructure
> > accomodating completely current behaviour SCSI Core command timeout,
> > but also offering the ability to hand command timeout handling to
> > a LLDD, _yet_ still have it all go through *SCSI Core*.
> 
> But what this basically does is force any implementor of
> eh_cmd_timed_out to handle all timers themselves.  Given that a large
> number of driver writers who try to do this get it wrong (mostly around
> del_timer() and del_timer_sync()), I don't think this is such a good
> idea.
> 
> > This is somewhat similar to Christoph's proposal patch, but I wasn't
> > aware of his patch when I thought of this. Interestingly enough it can be
> > viewed as an extension to his patch.
> 
> This proposal was to allow LLD notification that the timer fired (rather
> than first hearing about it when the eh activated).  I could see an
> extension to this, like the return values you propose, where the LLD
> tells the mid-layer that it corrected the command problem (in interrupt
> context) and the command is ready for completion (otherwise proceed into
> the eh).
> 

Could we get the eh_times_out part of the patch broken out as the
addition of the return values look like a good idea along with some
method to call a modified version of scsi_done through a exported
function to the LLDD.

-andmike
--
Michael Anderson
andmike@us.ibm.com

