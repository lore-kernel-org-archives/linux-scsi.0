From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: Full hostlock pushdown available
Date: Thu, 28 Oct 2010 14:28:43 -0500
Message-ID: <1288294123.3043.164.camel@mulgrave.site>
References: <20101028150508.GA2385@basil.fritz.box>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:36190 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753322Ab0J1T2v (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Oct 2010 15:28:51 -0400
In-Reply-To: <20101028150508.GA2385@basil.fritz.box>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: nab@linux-iscsi.org, linux-scsi@vger.kernel.org

On Thu, 2010-10-28 at 17:05 +0200, Andi Kleen wrote:
> Here's the promised attempt to do a full host_lock pushdown. This
> was done using coccinelle and some manual adjustments.
> 
> This is just a dumb pushdown of host lock and serial number into
> the driver, no attempt to remove any locks yet.
> 
> Currently lightly tested, but compiles with allmodconfig on 32bit x86.
> 
> I made no attempt to automatically add maintainers to Cc.
> 
> I'm not posting the patches because they are numerous and boring,
> but it's available in git.
> 
> This will likely bitrot quickly so if it's decided to do it this
> way I would prefer if this was merged quickly.

OK, so can you post an actual diff?  It obviously has to be done in one
commit rather than the 87 you have.

> Issues found:
> - I found a clear deadlock in aha1740, not sure if that driver ever
> worked since host_lock was introduced. Anyways I attempted to work
> around it. But if it's really that unused it may be better to 
> simply drop it.

I certainly don't have the hardware ... and I don't think we've had any
bug reports for a while

> - I'm not sure how to compile cciss_scsi, is it even used?

It's used for tape support in the cciss driver.  It's actually #included
into the cciss.c file (don't ask, I'll only start to cry) and is
conditioned on the CISS_SCSI_TAPE Kconfig variable.

James


