From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [BUG] 2.6.29-rc6-2450cf in scsi_lib.c (was: Large amount of
	scsi-sgpool)objects
Date: Wed, 04 Mar 2009 18:13:49 -0600
Message-ID: <1236212029.32072.4.camel@localhost.localdomain>
References: <alpine.LSU.2.00.0903030220050.2438@fbirervta.pbzchgretzou.qr>
	 <49ACF8FE.2020904@panasas.com>
	 <1236093718.3263.3.camel@localhost.localdomain>
	 <alpine.LSU.2.00.0903031703270.855@fbirervta.pbzchgretzou.qr>
	 <1236097526.3263.17.camel@localhost.localdomain>
	 <alpine.LFD.2.00.0903031818230.29264@localhost.localdomain>
	 <alpine.LFD.2.00.0903032247170.29264@localhost.localdomain>
	 <1236119195.24019.24.camel@localhost.localdomain>
	 <alpine.LFD.2.00.0903040249460.29264@localhost.localdomain>
	 <alpine.LFD.2.00.0903042232270.29264@localhost.localdomain>
	 <1236207389.21486.19.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1236207389.21486.19.camel@localhost.localdomain>
Sender: linux-ide-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jan Engelhardt <jengelh@medozas.de>, Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2009-03-04 at 22:56 +0000, James Bottomley wrote:
> On Wed, 2009-03-04 at 22:45 +0100, Thomas Gleixner wrote:
> > On Wed, 4 Mar 2009, Thomas Gleixner wrote:
> > 
> > Instrumented the code and the result of the failing request is
> > below. Looks like the function which sets up the request gets
> > nr_phys_segments wrong by one. 
> > 
> > If you need further trace data feel free to ask.
> 
> OK, the mapping all checks out correctly ... there must be something
> wrong with the way we count before mapping.
> 
> If you're tracing everything, could you add these static prints to the
> trace ... they'll trigger a lot, but capturing how they applied to the
> failing request might tell us why the count is wrong.

Debugging this on IRC, this is the point we reached:

ftrace debugging patch:

http://tglx.de/~tglx/dbg.patch

We're tracing both blk_recalc_rq_segments() and
blk_phys_contig_segment()

The results are here:

http://tglx.de/~tglx/t.txt.bz2

Although what they show is that we're missing the point where the
counting goes wrong (blk_recalc_rq_segments only goes up to 5 max).

James


