From: Arjan van de Ven <arjan@infradead.org>
Subject: RE: [PATCH 9/11][REPOST #2]  lpfc 8.1.1 : Add polled-mode support
Date: Thu, 01 Dec 2005 18:41:54 +0100
Message-ID: <1133458914.2853.85.camel@laptopd505.fenrus.org>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7B87@xbl3.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:46246 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S932363AbVLARl5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Dec 2005 12:41:57 -0500
In-Reply-To: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7B87@xbl3.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org

On Thu, 2005-12-01 at 12:37 -0500, James.Smart@Emulex.Com wrote:
> > sure.. but if the defaults are 0... why couldn't mode 1 by 
> > the default..
> > isn't mode 1 with coalesing value 0 the same as mode 0.. and 
> > if so.. why
> > need a mode 0 in the first place ?
> 
> There's no gain - and in fact there is now a loss. Queuecommand
> now eats up more cycles attempting to service i/o completions on
> every invokation. Nothing gets helped on the interrupt side. We
> would still have interrupts firing, thus the interrupt handler
> being invoked to clear the interrupt.
> 
> We're going to consume more cycles for a) queuecommand calls that
> don't have i/o completions available, and b) for handling spurious
> interrupts.

ok fair enough...  what kind of granularity can this delay be set too?
It might make sense to default to say 50 usec or 100usec always...

Also, not sure how your hardware works but it would be really sweet if
the kernel could set "this request should be coalesed" or "this request
is latency sensitive, gimme immediate", so that we can set async write
IO's for coalescing while not getting latency on reads...


