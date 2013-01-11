From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: linux-next: build failure after merge of the scsi tree
Date: Fri, 11 Jan 2013 15:37:17 +0000
Message-ID: <1357918637.3065.22.camel@dabdike.int.hansenpartnership.com>
References: <20130111120323.cdc06081d0fb1c498c9f1779@canb.auug.org.au>
	 <1357889656.3065.2.camel@dabdike.int.hansenpartnership.com>
	 <50F02F4E.4070804@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <50F02F4E.4070804@linux.vnet.ibm.com>
Sender: linux-next-owner@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, Wen Xiong <wenxiong@linux.vnet.ibm.com>, Greg KH <greg@kroah.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2013-01-11 at 09:27 -0600, Brian King wrote:
> It looks like this was a due to the fact that the new patches
> added __devinit tags in the same merge window the __devinit tag
> itself was getting removed.

Not exactly.  The patch which makes them nops went into 3.8.  Now
there's a patch queued in, Gregs tree I presume, to remove them all and
the #defines which causes the compile failure.

> As to the sparse warnings, this patch fixed the ones that
> were actual bugs in the new code, although we could have
> made that more clear in the patch description.
> 
> http://marc.info/?l=linux-scsi&m=135716576204083&w=2

Ah, thanks ... I've been on holiday for a while, so I did miss that.

> There is one outstanding issue I am aware of which was an
> array bounds compiler warning which looks to be a misdetection
> by the compiler. Wendy and I discussed adding a BUG_ON
> to stop the compiler from complaining.
> 
> Wendy - lets queue these two changes up ASAP. They should both
> be very simple changes.

If it's a simple gcc bug, just ignore it.

I do need you to redo the patches to remove the __dev annotations,
though.  We can't risk introducing a bisect killing compile breakage if
Greg's tree merges before mine in the next merge window.

James
