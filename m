From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: scsi command slab allocation under memory pressure
Date: 03 Feb 2003 18:05:11 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1044313513.1777.91.camel@mulgrave>
References: <20030129104731.A2811@beaverton.ibm.com>
	<3E382E2C.4030201@splentec.com> <20030129121117.A3389@beaverton.ibm.com>
	<20030130225738.1874c2e0.akpm@digeo.com>
	<1044020591.2002.16.camel@mulgrave>
	<20030131124412.086f2d1c.akpm@digeo.com>
	<20030203225550.GJ29516@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id PAA08630
	for <linux-scsi@vger.kernel.org>; Mon, 3 Feb 2003 15:05:20 -0800
In-Reply-To: <20030203225550.GJ29516@redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Andrew Morton <akpm@digeo.com>, patmans@us.ibm.com, luben@splentec.com, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2003-02-03 at 17:55, Doug Ledford wrote:
> I think the case is that there is no problem to be solved.  One command 
> per host is enough to keep each host running, and that's enough to keep 
> the system running.  If we are ever low enough on mem that we get down to 
> failing scsi command allocations, the system is already hurting.  The 
> complaint was that a device doing something other than swap could starve a 
> swap device.  I don't buy that.  If the device is doing constant reads 
> then it's going to run out of mem eventually and block just like our 
> allocations are, if it's writing then it very likely is freeing up just as 
> many pages as the swap operation would be.  In short, I think if we keep 
> the disk subsystem running, even if crippled with just one command, the 
> problem becomes self correcting and there isn't much for us to solve.  Of 
> course, that's just my 5 minute analysis, someone feel free to prove me 
> wrong.

I agree with the analysis: The system can make forward progress as long
as we have only one guaranteed command.

However, I do worry about the performance under memory pressure.  I
don't think only having one command pre allocated per HBA is sufficient
to ensure efficient swap out behaviour under load.  The question, of
course, is what do we need to do to make it more efficient?

Andrew, these patches are now in Linus' BK, so if you want to take a
look and see how our loaded behaviour is, I'd be grateful.

James


