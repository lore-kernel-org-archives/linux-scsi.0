From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: Full hostlock pushdown available
Date: Thu, 28 Oct 2010 12:32:02 -0700
Message-ID: <1288294322.5169.285.camel@haakon2.linux-iscsi.org>
References: <20101028150508.GA2385@basil.fritz.box>
	 <1288294123.3043.164.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm19.bullet.mail.sp2.yahoo.com ([98.139.91.89]:43573 "HELO
	nm19.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759471Ab0J1Tg6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Oct 2010 15:36:58 -0400
In-Reply-To: <1288294123.3043.164.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Andi Kleen <andi@firstfloor.org>, linux-scsi@vger.kernel.org

On Thu, 2010-10-28 at 14:28 -0500, James Bottomley wrote:
> On Thu, 2010-10-28 at 17:05 +0200, Andi Kleen wrote:
> > Here's the promised attempt to do a full host_lock pushdown. This
> > was done using coccinelle and some manual adjustments.
> > 
> > This is just a dumb pushdown of host lock and serial number into
> > the driver, no attempt to remove any locks yet.
> > 
> > Currently lightly tested, but compiles with allmodconfig on 32bit x86.
> > 
> > I made no attempt to automatically add maintainers to Cc.
> > 
> > I'm not posting the patches because they are numerous and boring,
> > but it's available in git.
> > 
> > This will likely bitrot quickly so if it's decided to do it this
> > way I would prefer if this was merged quickly.
> 
> OK, so can you post an actual diff?  It obviously has to be done in one
> commit rather than the 87 you have.
> 

So it appears this series will still need the atomic_add_return() usage
in scsi_cmd_get_serial() and drop host_lock usage from those LLDs that
we know can be converted to 'host_lock-less', yes..?

Following Chrisof's and David's comments for zfcp and srp host_lock push
down this morning, the latest v9 code has been pushed into:

git://git.kernel.org/pub/scm/linux/kernel/git/nab/lio-4.0.git host_lock-less-for-37-v9

+1 for ak for actually coding this up in coccinelle.  ;)

> > Issues found:
> > - I found a clear deadlock in aha1740, not sure if that driver ever
> > worked since host_lock was introduced. Anyways I attempted to work
> > around it. But if it's really that unused it may be better to 
> > simply drop it.
> 
> I certainly don't have the hardware ... and I don't think we've had any
> bug reports for a while
> 
> > - I'm not sure how to compile cciss_scsi, is it even used?
> 
> It's used for tape support in the cciss driver.  It's actually #included
> into the cciss.c file (don't ask, I'll only start to cry) and is
> conditioned on the CISS_SCSI_TAPE Kconfig variable.
> 

I just did a 'make drivers/block' to compile this code..

Thanks!

--nab

