From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH]: Flexible timeout infrastructure
Date: 15 Jun 2004 10:31:31 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1087313492.1796.37.camel@mulgrave>
References: <40CF0F9F.4050902@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:49800 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S265690AbUFOPbi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jun 2004 11:31:38 -0400
In-Reply-To: <40CF0F9F.4050902@adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2004-06-15 at 10:02, Luben Tuikov wrote:
> This patch introduces a flexible command timeout infrastructure
> accomodating completely current behaviour SCSI Core command timeout,
> but also offering the ability to hand command timeout handling to
> a LLDD, _yet_ still have it all go through *SCSI Core*.

But what this basically does is force any implementor of
eh_cmd_timed_out to handle all timers themselves.  Given that a large
number of driver writers who try to do this get it wrong (mostly around
del_timer() and del_timer_sync()), I don't think this is such a good
idea.

> This is somewhat similar to Christoph's proposal patch, but I wasn't
> aware of his patch when I thought of this. Interestingly enough it can be
> viewed as an extension to his patch.

This proposal was to allow LLD notification that the timer fired (rather
than first hearing about it when the eh activated).  I could see an
extension to this, like the return values you propose, where the LLD
tells the mid-layer that it corrected the command problem (in interrupt
context) and the command is ready for completion (otherwise proceed into
the eh).

Since we also already have the ability to modify the command times in
slave configure, is it really necessary to encourage the alteration of
SCSI timers in this way?

James


